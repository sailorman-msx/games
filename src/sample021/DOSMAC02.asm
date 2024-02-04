;
; BIOS SUBROUTINE 
; BIOSサブルーチンの定義
;
CHGMOD:equ $005F
CHGCLR:equ $0062
SETGRP:equ $007E ; VDPのみをGRAPHIC2モードにする
ERAFNK:equ $00CC
KILBUF:equ $0156
SNSMAT:equ $0141

; BDOSルーチン(MSX-DOS用)
FNCCAL:equ   $0005  ; ファンクションコール

; ファンクションコール関連
_TERM0:equ  $00   ; MSX-DOSシステムに戻る
_FOPEN:equ  $0F   ; ファイル読み込み
_FCLOSE:equ $10   ; ファイルクローズ
_SETDTA:equ $1A   ; DTAの設定(データ読み込み先アドレスの設定)
_RDSEQ:equ  $14   ; シーケンシャルファイル読み込み(128byteずつ読み込む)

; ファイル読み込みに必要な情報
BUFAD:equ   $4000 ; ファイル読み込み内容の格納先アドレス

; BIOSルーチン(SUB-ROM用)
EXTROM:equ $015F ; SUB-ROMインタースロットコール
SETPLT:equ $014D ; カラーパレットの設定

; Work area addresses.
; ワークエリアアドレスの定義
LINWID:equ $F3AF ; WIDTH
RG0SAV:equ $F3DF ; VDP#0 Register
FORCLR:equ $F3E9 ; Fore ground color
BAKCLR:EQU $F3EA ; Back ground color
BDRCLR:equ $F3EB ; Border color
CLIKSW:equ $F3DB ; キークリック音のON/OFFが格納されているアドレス
INTCNT:equ $FCA2 ; MSX BIOSにて1/60秒ごとにインクリメントされる値が格納されているアドレス

; MSX-DOSからSUB-ROMを呼び出す場合のおまじない
CALSLT:equ $001C ; CALSLT
H_NMI:equ $015F  ; H.NMIフック
EXPTBL:equ $FCC1

; VDP関連定数
CONST_VDPPORT0:equ $98
CONST_VDPPORT1:equ $99

; ========================================
; ワークエリアの上限：
; DISK-BASICでの上限はDE3FHが推奨値
; MSX-DOSでの上限はD405H
; MSX-DOSでのプログラミング時には
; ワークエリアが極端に狭くなるので
; 注意する必要がある
; ========================================

; ワークテーブル
WK_VRAMTORAM:equ $C000 ; C000H - C7FFH 

; 仮想VRAM（ネームテーブル)
WK_VIRTVRAM:equ $C800  ; C800H - CFFFH

; MSX-DOSプログラムの開始位置アドレスは0x0100
org $0100

Start:

    ;-------------------------------------------
    ; 画面構成の初期化
    ;-------------------------------------------

    ; Initialize screen
    ; 画面の初期化
    ld a, $0F
    ld (FORCLR), a
    ld a, $01
    ld (BAKCLR), a
    ld (BDRCLR), a

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a

    ld a, 1          ; SCREEN MODE = 1
    ld ix, CHGMOD
    call BiosInterSlotCall

    ; Set GRAPHIC2 mode
    ld ix, SETGRP
    call BiosInterSlotCall
    
    ; Disable FUNCTION KEY DISPLAY.
    ld ix, ERAFNK
    call BiosInterSlotCall

    ; RANDOM SEEDの初期化
    call INITRANDOM
    
    ; WK_VIRTVRAMの初期化
    ld hl, WK_VIRTVRAM
    ld bc, 768
    ld a, $20
    call MEMFIL
    
    ;-------------------------------------------
    ; VRAMカラーテーブルの初期化
    ;-------------------------------------------
    ld hl, $2000
    ld bc, $800 * 3 ; 上中下のカラーを前景色:白,背景色:黒で統一する
    ld  a, $F1
    call WRTVRMFIL

FILSCREEN:

    ; 仮想VRAMに0-255までの文字を3回(上中下)に書き込む
    
    ld hl, WK_VIRTVRAM

FILSCREEN_UP:

    xor a

FILSCREEN_UP_LOOP:

    ld (hl), a
    inc hl

    cp 255
    jr z, FILSCREEN_MID

    inc a

    jr FILSCREEN_UP_LOOP

FILSCREEN_MID:

    xor a

FILSCREEN_MID_LOOP:
    
    ld (hl), a
    inc hl

    cp 255
    jr z, FILSCREEN_DOWN

    inc a

    jr FILSCREEN_MID_LOOP

FILSCREEN_DOWN:

    xor a

FILSCREEN_DOWN_LOOP:
    
    ld (hl), a
    inc hl

    cp 255
    jr z, FILSCREEN_END

    inc a

    jr FILSCREEN_DOWN_LOOP

FILSCREEN_END:

    ;-------------------------------------------
    ; MSX-DOSのファンクションコールを使って
    ; ファイルを読み込み
    ; パターンテーブルを書き換える
    ;-------------------------------------------
  
    ; (読み込みモードでのファイルオープン）
    ; 1. DEレジスタにFCB(*)のアドレスをセットする
    ; 2. Cレジスタに_FOPEN(05H)を指定して
    ; BDOSコールする
    ; *読み込み前だと、ファイル名だけの指定となる

    ld de, FCB
    ld  c, _FOPEN
    call FNCCAL

    ; ファイルオープン時に失敗した場合は
    ; Aレジスタに0以外がセットされる
    ; ファイルアクセス失敗時はMS-DOSに戻るようにしておく

    or a
    jp nz, RETMSXDOS

    ; データ読み込み先を設定しておく
    ; 設定方法
    ; 1. DEレジスタにバッファアドレスを設定する
    ; 2. Cレジスタに_SETDTA(1AH)をセットして
    ; BDOSコールする

    ld de, BUFAD
    ld  c, _SETDTA
    call FNCCAL

    ; 今回のサンプルでは128バイトずつファイルを読む
    ; 128バイト読んだらVRAMのパターンテーブル0000Hから順に
    ; 128バイト読み込んだデータを転送していく
    ; 合計で6144バイト埋めていく(0000H - 17FFH)

    ; DEレジスタに書き込み先のVRAMアドレスをセットして
    ; 変数に退避しておく
    ; *ファンクションコールを呼び出すとレジスタはたいてい破壊される

    ld de, $0000
    ld (DEREGBACK), de

FREAD_LOOP:

    ; ファイル読み込み
    ; 読み込み方法（128バイトずつのシーケンシャルアクセス）
    ; 1. DEレジスタにFCBのアドレスをセットする
    ; 2. Cレジスタに_RDSEQ(14H)をセットする
    ; 3. BDOSコールする
    ; 4. 読み込んだデータがDTAのアドレスに格納される
    ; _RDSEQで読み込む場合、データが128バイトに満たなかったら
    ; 足りない部分は0で埋められる。

    ld de, FCB
    ld  c, _RDSEQ
    call FNCCAL

    ; 読み込みに失敗したら
    ; Aレジスタに01Hがセットされる
    ; ファイルをオープンしているのでクローズ処理にジャンプする
    cp $01
    jr z, FREAD_LOOPEND

    ; バッファの内容をVRAMに転送する
    ld de, (DEREGBACK)
    
    ld hl, BUFAD
    ld bc, 128
    call WRTVRMSERIAL

    ; 読み込みデータのVRAM書き込み先アドレスを+128しておく
    ld de, (DEREGBACK)
    ld hl, 128
    add hl, de
    ld de, hl
    ld (DEREGBACK), de

    ; 次のデータを読みにいく
    jr FREAD_LOOP

FREAD_LOOPEND:

    ; ファイルをクローズする
    ; クローズの方法
    ; 1. DEレジスタにFCBのアドレスをセットする
    ; 2. Cレジスタに_FCLOSE(10H)をセットする
    ; 3. BDOSをコールする
    
    ld de, FCB
    ld  c, _FCLOSE
    call FNCCAL

    ; =========================================================
    ; 仮想VRAMの情報768バイトをネームテーブル(1800H)に転送する
    ; =========================================================

    ld hl, WK_VIRTVRAM
    ld de, $1800
    ld bc, 768
    call WRTVRMSERIAL

KEYIN_LOOP:

    ; Zキーを押したら終了する

    ld ix, KILBUF
    call BiosInterSlotCall

    ld a, 5
    ld ix, SNSMAT
    call BiosInterSlotCall

    cp 01111111B
    jr nz, KEYIN_LOOP

RETMSXDOS:

    ; Cレジスタに00Hをセットして
    ; BDOSコールする（MSX-DOSシステムに戻る）
    ld c, _TERM0
    call FNCCAL

DEREGBACK:
defw $0000

; ========================
; ここから先は共通処理
; 使わないかもだけど・・
; ========================
MEMFIL:

MEMFILLOOP:

    ld (hl), a
    cpi
    jp pe, MEMFILLOOP

    ret
    
INITRANDOM:
             
    ld a, r
    ld (RANDOM_SEED), a
    
    ret
    
RANDOMVALUE: 
    
    push bc
    
    ; 乱数のシード値を乱数ワークエリアから取得
    ld a, (RANDOM_SEED)
    ld b, a
    ld a, b

    add a, a ; Aを5倍する
    add a, a ;
    add a, b ;

    add a,123 ; 123を加える

    ld b, a
    ld a, r ; Rレジスタの値を加算
    add a, b

    ; 乱数ワークエリアに保存
    ld (RANDOM_SEED), a

    pop bc

    ret

RANDOM_SEED:
defb 0

;----------------------------------------------------
; インタースロットコール,SUB-ROMコール用
;----------------------------------------------------
BiosCall:

    ; JP (DE)
    push de
    ret

BiosCallNotFDD:

    ; 普通に呼び出す
    ; 呼び出し時はJPで行う
    jp (hl)

BiosNotFDDSubRomCall:

    ; SUB-ROMをコールする
    ld hl, EXTROM
    jp (hl)

BiosInterSlotCall:

    ; インタースロットコールにて
    ; 呼び出す
    ; IXレジスタに呼び出し先をセットしてある必要あり

    ld iy,(EXPTBL-1) ; MAINROMのスロット
    ld de, CALSLT    ; 指定したスロットの指定アドレスを呼びだす

    ; JP (DE)
    push de
    ret

BiosFDDSubRomCall:

    ; SUB-ROMをコールする
    exx
    ex af, af'
    ld hl, EXTROM
    push hl      ; EXTROM -> SP
    ld hl, $C300 ;
    push hl      ; NOP, JP -> SP
    push ix      ; SUB ROM Entry
    ld hl, $21DD
    push hl      ; LD IX -> SP
    ld hl, $3333
    push hl      ; INC SP, INC SP
    ld hl, 0
    add hl, sp
    ld a, $C3
    ld (H_NMI), a    ;
    ld (H_NMI+1),hl  ;
    ex af, af'
    exx

    ld ix, H_NMI
    ld iy, (EXPTBL-1)
    ld hl, CALSLT
    jp (hl)

;  ここから下はVDP直叩きするVRAM操作サブルーチン群

;--------------------------------------------
; SUB-ROUTINE: VDPRED
; VDPポート#1に対してREAD宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPRED:

    push af
    push bc
    push de
    
    di

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 下位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ei

    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: VDPWRT
; VDPポート#1に対してWRITE宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPWRT:

    push af
    push bc
    push de

    di

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 上位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    or  $40                    ; 第6ビットを1にする(WRITE-MODE)
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ei

    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: REDVRM
; HLレジスタにセットされたVRAMアドレスの
; 値を1バイトだけ読み込みAレジスタに格納する
; HLレジスタは読み込み後インクリメントされる
;--------------------------------------------
REDVRM:

    ; 読み込み宣言
    call VDPRED

    ; 読み込み
    in a, (CONST_VDPPORT0)    ; (12)
    nop                       ; (05)
    nop                       ; (05)

    ret

;--------------------------------------------
; SUB-ROUTINE: WRTVRM
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値を1バイトだけ書き込む
; HLレジスタは書き込み後インクリメントされる
;--------------------------------------------
WRTVRM:
    
    ; 書き込み宣言
    call VDPWRT

    ; 書き込み
    out (CONST_VDPPORT0), a   ; (12)
    nop                       ; (05)
    nop                       ; (05)

    ret

;---------------------------------------------------
; SUB-ROUTINE: REDVRMSERIAL
; HLレジスタにセットされたメモリアドレスに
; DEレジスタで指定されたVRAMアドレスの内容を
; BCレジスタの値だけ連続して読み込む
; HLレジスタとDEレジスタは
; 書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
REDVRMSERIAL:

    ; HLレジスタの値を退避
    push hl

    ; HLレジスタにVRAMアドレスをセット
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPRED

    ; HLレジスタに退避したメモリアドレスをセット
    pop hl

REDVRMSERIALLOOP:

    in a, (CONST_VDPPORT0)     ; (12)
    ld (hl), a                 ; (8)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, REDVRMSERIALLOOP

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMFIL
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値をBCレジスタの値だけ連続して書き込む
; HLレジスタは書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMFIL:

    ; 書き込み宣言
    call VDPWRT

WRTVRMFILLOOP:

    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMFILLOOP

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMSERIAL
; HLレジスタにセットされたメモリアドレスの値を
; DEレジスタにセットされたVRAMアドレスに
; BCレジスタの値だけ連続して書き込む
; HLレジスタとDEレジスタは書き込み後
; BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMSERIAL:

    ; HLレジスタの値を退避
    push hl

    ; HLレジスタにVRAMアドレスをセット
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPWRT

    ; HLレジスタに退避したメモリアドレスをセット
    pop hl

WRTVRMSERIALLOOP:

    ld a, (hl)
    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMSERIALLOOP

    ret

;--------------------------------------------------------
; ここからFCB
; FCBは37バイトとなっていて
; ファイル読み込み前の状態であれば
; カレントドライブとファイル名以外は0にしておく
; ファイルをオープンすると0にしていた部分が
; 書き換えられ「完全にオープンされた」という状態になる
;--------------------------------------------------------

FCB:

defb 0             ; カレントドライブ(Aドライブ)
defb "SAMPL021DAT" ; ファイル名はピリオド無しで、ファイル名(8バイト固定),拡張子(3バイト固定)
                   ; ファイル名が8文字に満たない場合は末尾はブランクにしておく

; 先頭13バイト目以降は読み込み前は0にしておく
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; FCB+12 - FCB+21 
defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; FCB+22 - FCB+31
defb 0, 0, 0, 0, 0                ; FCB+32 - FCB+36

