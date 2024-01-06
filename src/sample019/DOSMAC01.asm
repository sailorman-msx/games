;
; BIOS SUBROUTINE 
; BIOSサブルーチンの定義
;
CHGMOD:equ $005F
CHGCLR:equ $0062
ERAFNK:equ $00CC
KILBUF:equ $0156
SNSMAT:equ $0141

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

; =================
; H.TIMI hook address
; =================
H_TIMI:equ $FD9F ; H.TIMI hook address

VBLANK_WAIT_FLG:equ $4000
TIMER_COUNTER:equ $4001
ADDR_BACK:equ $4002
H_TIMI_BACKUP:equ $4004

; VDPポート番号(定数)
CONST_VDPPORT0:equ $98
CONST_VDPPORT1:equ $99

; 表示するキャラクタコード
DISP_CHAR_CODE:equ $4009

; キャラクタのアニメーション番号
ANIME_NUM:equ $400A

; 乱数生成SEED値
RANDOM_SEED:equ $400B

; ダブルバッファリング
; 仮想VRAM用(768バイト)
VIRTVRAM:equ $400C

; スクロール用(768バイト)
SCROLLBUF:equ $130C

; LAST　COL生成用(32バイト)
SCREENLASTCOL:equ $160C

; LAST COLのアドレス(2バイト)
SCREENLASTCOLADDR:equ $162C

; スクロール先アドレス(２バイト)
SCROLLDESTADDR:equ $162E

; 画面書き換え可能フラグ(1バイト)
PATTERNNAMETB_REDRAW:equ $162F

; Zキー押されたフラグ
ZKEY_PUSHED:equ $1630

; Xキー押されたフラグ
XKEY_PUSHED:equ $1631

; Page#3のスロット番号格納用
RAMAD3:equ $F344

; ========================================
; ワークエリアの上限：
; DISK-BASICでの上限はDE3FHが推奨値
; MSX-DOSでの上限はD405H
; MSX-DOSでのプログラミング時には
; ワークエリアが極端に狭くなるので
; 注意する必要がある
; ========================================

; MSX-DOSプログラムの開始位置アドレスは0x0100
org $0100

Start:

; Main procedure.
; メイン処理
MAIN:

    xor a
    ld (TIMER_COUNTER), a
    ld (ANIME_NUM), a

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

    ; Disable FUNCTION KEY DISPLAY.
    ld ix, ERAFNK
    call BiosInterSlotCall

    ; RANDOM SEEDの初期化
    call INITRANDOM
    
    ; VIRTVRAMの初期化
    ld hl, VIRTVRAM
    ld bc, 768
    ld a, $20
    call MEMFIL
    
    ; スプライトの初期化
    ld hl, SPRITE_PTN
    ld de, $3800
    ld bc, 8 * 4 * 3
    call WRTVRMSERIAL
    
    ld hl, SPRITE_ATTR
    ld de, $1B00
    ld bc, 4 * 3
    call WRTVRMSERIAL
    
    ; 星が目に眩しいのでフォアカラーを12（濃い緑）にする
    ld hl, $2000 + $80 / 8
    ld a, $C1
    call WRTVRM
    
    ; 88Hのキャラクタパターンを作成する
    ld hl, ANME_7_PTN
    ld de, $88 * 8
    ld bc, 8
    call WRTVRMSERIAL

    ld hl, $2000 + $88 / 8
    ld a, $81
    call WRTVRM

    ld a, 5
    ld (TIMER_COUNTER), a

    ; 画面書き換え可能フラグの初期化
    xor a
    ld (PATTERNNAMETB_REDRAW), a
    
    ; AKG Playerの初期化
    ld hl, TRAINING_BGM_START
    xor a
    call PLY_AKG_INIT

    ; AKG Sound Effectの初期化
    ld hl, SOUNDEFFECTS
    call PLY_AKG_INITSOUNDEFFECTS

    ;=============================
    ; Initialize H.TIMI Handler
    ; H.TIMIのHOOK処理を変更する
    ;=============================
    xor a
    ld (VBLANK_WAIT_FLG), a

    call INIT_H_TIMI_HANDLER

;==================================
; Wait for H_TIMI(VBLANK) and call your procedure
; each time VBLANK.
; H_TIMI（VBLANK）を待ち
; VBLANKのつど、自分の処理を呼び出す
;==================================
H_TIMI_HOOK_LOOP:

    ;
    ; Set one to VBLANK_WAIT_FLG
    ; VBLANK_WAIT_FLGに1をセットする
    ;
    ; The value of this variable is updated to 0 by the 
    ; H_TIMI_HANDLER process when H.TIMI is hooked.
    ; 変数の値はH_TIMI_HANDLER処理にて0に更新される
    ;
    ld a, 1
    ld (VBLANK_WAIT_FLG), a
    
    ;=============================
    ; Jump to the REDRAW_SCREEN procedure.
    ; Return to VBLAN_WAIT when REDRAW_SCREEN
    ; process is finished.
    ; Rewriting this process to a process of 
    ; your choice will cause H.TIMI to call your process.
    ; [attention]
    ; Note that strictly speaking, 
    ; this part of the process does not have the 
    ; same timing as VBLANKING, and the timing is unstable; 
    ; if it must be contained within VBLANKING, 
    ; it should be placed in the H_TIMI_HANDLER subroutine.
    ;
    ; REDRAW_SCREEN処理にジャンプする
    ; REDRAW_SCREEN処理が終わったらVBLAN_WAITに
    ; 戻る
    ; この処理を自分の好きな処理に書き換えることで
    ; H.TIMIに自分の処理が呼ばれるようになる
    ; [注意]
    ; 厳密にはこの処理部分はVBLANKINGと同じタイミングではなく
    ; タイミングは不安定であることに注意する。
    ; VBLANKING内に処理を収める必要性がある場合は
    ; H_TIMI_HANDLERサブルーチンに中に記述すること。
    ;=============================
    jp REDRAW_SCREEN
 
 VBLANK_WAIT:

    ; Wait the VBLANK
    ; Wait for the value of VBLANK_FLG 
    ; to be updated to 0 by the occurrence of 
    ; the next VBLANK.
    ;
    ; VBLANKを待つ
    ; 次のVBLANKのタイミングにて
    ; VBLANK_FLGが0に更新されるのを待つ
    ;
    ld a, (VBLANK_WAIT_FLG)
    or a
    jr nz,VBLANK_WAIT
 
    ; Goto H_TIMI_HOOK_LOOP
    ; H_TIMI_HOOK_LOOPにジャンプする
    jp H_TIMI_HOOK_LOOP

;================================
; Initialized H.TIMI Interrupt routine
; H.TIMI割り込み時に呼ばれる処理を初期化する
;================================
INIT_H_TIMI_HANDLER:

    push af
    push bc
    push de
    push hl

    ; Backup H.TIMI original procedure
    ; もともと存在していたH.TIMI処理を退避する
    ld hl, H_TIMI
    ld de, H_TIMI_BACKUP
    ld bc, 5
    ldir

    ; Override the H.TIMI procedure
    ; H.TIMI処理処理を書き換える
    ; ==============================================
    ; H.TIMIが呼ばれたときにRAMのPage#3が表に出ている
    ; とは限らない。
    ; 例えばBIOS(ROM)での処理中に割込が発生する場合も
    ; ありえる。そのためインタースロットコールを使って
    ; 自身が作成したH.TIMIチェーン先のサブルーチンを
    ; 呼び出す。
    ; ==============================================
    ld a, $F7              ; H_TIMI + 0 <- RST30H
    ld (H_TIMI + 0) , a
    ld a, (RAMAD3)         ; H_TIMI + 1 <- Page#3のスロット
    ld (H_TIMI + 1), a
    ld hl, H_TIMI_HANDLER
    ld (H_TIMI + 2), hl    ; H_TIMI + 2 <- 呼び出し先アドレス上位8it
                           ; H_TIMI + 3 <- 呼び出し先アドレス下位8it
    ld a, $C9              ; H_TIMI + 4 <- RET
    ld (H_TIMI + 4) , a

    pop hl
    pop de
    pop bc
    pop af

    ret

;
; Redraw screen.
;
; タイトル行までスクロールさせようとするとタイトルがチラつくため
; 画面上のスクロール表示領域は1820H-1AFFHまでとする
; 当処理では仮想VRAMを対象とする
;
REDRAW_SCREEN:

    ld a, (ZKEY_PUSHED)
    or a
    jr nz, REDRAW_SCREEN_PUSHZKEY

    ld a, (XKEY_PUSHED)
    or a
    jr nz, REDRAW_SCREEN_PUSHXKEY

    jr REDRAW_PROC

REDRAW_SCREEN_PUSHZKEY:
    
    ; 効果音を鳴らす 
    ld a, $01 ; SOUND EFFECT NUMBER
    ld c, 2   ; CHANNEL ( 0 - 2 )
    ld b, 0   ; VOLUME ( 0 - 16 : 0=Full Volume)
    call PLY_AKG_PLAYSOUNDEFFECT
    
    jr REDRAW_PROC

REDRAW_SCREEN_PUSHXKEY:
    
    ; 効果音を鳴らす 
    ld a, $02 ; SOUND EFFECT NUMBER
    ld c, 2   ; CHANNEL ( 0 - 2 )
    ld b, 0   ; VOLUME ( 0 - 16 : 0=Full Volume)
    call PLY_AKG_PLAYSOUNDEFFECT

REDRAW_PROC:

    ld a, (TIMER_COUNTER)
    or a
    jp nz, REDRAW_SCREEN_DEC_END

    ; 画面のいちばん右端の行に該当するメモリエリアを初期化する
    ld hl, SCREENLASTCOL
    ld bc, 24
    ld a, $20
   
    call MEMFIL

REDRAW_SCREEN_DISPLAY_SETLASTCOL:

    ld b, 24
    
    ld hl, SCREENLASTCOL + 24
    
    ; 24個ぶんランダムに$80Hを配置する
    ; 乱数はRレジスタを使う
    
REDRAW_SCREEN_DISPLAY_LOOP:

    ld a, $20
    ld (DISP_CHAR_CODE), a
    
    ; 乱数値が20以下であれば星のキャラクタを表示する
    call RANDOMVALUE
    cp 21
    jp nc, REDRAW_SCREEN_DISPLAY_LOOP_NEXT
    
    ; 乱数値が6以上であれば緑色のキャラを表示
    cp 6
    jp nc, GREENCHAR

    ; 乱数値が5以下であれば赤色のキャラを表示
    ld a, $88
    ld (DISP_CHAR_CODE), a
    
    jp REDRAW_SCREEN_DISPLAY_LOOP_NEXT
    
GREENCHAR:

    ld a, $80
    ld (DISP_CHAR_CODE), a

REDRAW_SCREEN_DISPLAY_LOOP_NEXT:

    ld a, (DISP_CHAR_CODE)

    dec hl
    ld (hl), a
    
    djnz REDRAW_SCREEN_DISPLAY_LOOP 

    ; VIRTVRAMを左にスクロールさせる
    ld a, 0
    
    ; ここから下は右から左にスクロールさせる処理

    ld bc, SCREENLASTCOL
    ld (SCREENLASTCOLADDR), bc
    
    ld hl, VIRTVRAM + 1
    ld (ADDR_BACK), hl
    
    ld hl, SCROLLBUF
    ld (SCROLLDESTADDR), hl
    
MULTILOOP1:

    push af

    ; VIRTVRAMの1列目から31バイトを
    ; SCROLLBUFの0列目に転送する
    ld hl, (ADDR_BACK) ; 転送元アドレス(1列目)    
    ld de, (SCROLLDESTADDR) ; 転送先アドレス(SCROLL_BUFの0列目)
    
    ld bc, 31
    ldir
    
    pop af

    ; SCROLLBUFの32バイト目にSCREENLASTCOLの
    ; 情報を1バイトつける
    ld hl, (SCROLLDESTADDR)
    ld b, 0
    ld c, 31
    add hl, bc
    ld d, h
    ld e, l
    
    ld b, a ; Aレジスタの値をバックアップ
    ld hl, (SCREENLASTCOLADDR)
    ld a, (hl)
    ld (de), a
    inc hl ; SCREENLASTCOLADDRのアドレスを1進める
    ld (SCREENLASTCOLADDR), hl
    
    ld a, b
    cp 23
    jp z, REDRAW_SCREEN_DISP
    
    inc a ; 次の転送元行を進めてループに戻る
    
    ; 転送元アドレス、転送先アドレスに32を加算する
    ld b, 0
    ld c, 32
    ld hl, (ADDR_BACK)
    add hl, bc
    ld (ADDR_BACK), hl
    
    ld hl, (SCROLLDESTADDR)
    add hl, bc
    ld (SCROLLDESTADDR), hl
    
    jp MULTILOOP1
    
REDRAW_SCREEN_DISP:

    ; SCROLLBUFの内容をVIRTVRAMに転送する
    ld hl, SCROLLBUF
    ld de, VIRTVRAM
    ld bc, 768
    ldir
    
    ld a, 1
    ld (PATTERNNAMETB_REDRAW), a

    jp REDRAW_SCREEN_INIT_TIMER

REDRAW_SCREEN_INIT_TIMER:

    ; TIMER_COUNTERを初期化する
    ld a, 5
    ld (TIMER_COUNTER), a
    jp REDRAW_SCREEN_END
    
REDRAW_SCREEN_DEC_END:

    ; TIMER_COUNTERをデクリメントする
    ld a, (TIMER_COUNTER)
    dec a
    ld (TIMER_COUNTER), a
    
REDRAW_SCREEN_END:

    ; VBLANK_WAITに戻り次のH.TIMIを待つ
    jp VBLANK_WAIT

;==================================
; DEレジスタに格納されているVRAMアドレスに
; ANIME_0_PTNからANIME_7_PTNのいずれかの
; データを8バイト転送する
;==================================
CREATE_CHAR_PATTERN:

    push hl
    push de
    push bc

    ; パターンデータの位置を特定する
    ld a, (ANIME_NUM)
    add a, a ; A=Ax2
    add a, a ; A=Ax4
    add a, a ; A=Ax8
    ld b, 0
    ld c, a
    
    ld hl, ANIME_CHAR_PTN
    add hl, bc
    ld b, 0
    ld c, 8
    
    call WRTVRMSERIAL
    
    pop bc
    pop de
    pop hl

    ret

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
    ld (ADDR_BACK), hl

    ; HLレジスタにVRAMアドレスをセット
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPRED

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (ADDR_BACK)

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
    ld (ADDR_BACK), hl

    ; HLレジスタにVRAMアドレスをセット
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPWRT

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (ADDR_BACK)

WRTVRMSERIALLOOP:

    ld a, (hl)
    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMSERIALLOOP

    ret

; CHARACTER PATTERN
ANIME_CHAR_PTN:
ANIME_0_PTN:
defb $00,$00,$00,$01,$00,$00,$00,$00
ANIME_1_PTN:
defb $00,$00,$00,$02,$00,$00,$00,$00
ANIME_2_PTN:
defb $00,$00,$00,$04,$00,$00,$00,$00
ANIME_3_PTN:
defb $00,$00,$00,$08,$00,$00,$00,$00
ANIME_4_PTN:
defb $00,$00,$00,$10,$0,$00,$00,$00
ANIME_5_PTN:
defb $00,$00,$00,$20,$00,$00,$00,$00
ANIME_6_PTN:
defb $00,$00,$00,$40,$00,$00,$00,$00
ANME_7_PTN:
defb $00,$00,$00,$80,$00,$00,$00,$00

SPRITE_PTN:

; #0-
defb $00, $80, $C0, $60, $70, $3E, $3F, $1F
defb $1F, $3E, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $80, $FE
defb $FF, $00, $00, $00, $00, $00, $00, $00

; #4-
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $01, $3E, $60, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $E0, $00, $00, $00, $00, $00, $00

; #8-
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $38, $7C, $00
defb $00, $00, $00, $00, $00, $00, $00, $00

SPRITE_ATTR:

defb 12*8, 5*8, 0, $0F
defb 12*8, 5*8, 4, $07
defb 12*8, 5*8, 8, $06

TITLE_MSG:
defm "MSX-DOS DEMO   " ; LENGTH 15 byte

;   
; AKG Player include.
;   
include "AKGPlay.asm"

;=================================
; This program's own H.TIMI hook process. 
; At the end of this process, it jumps to the 
; original H.TIMI process.
; この処理は独自のH.TIMI処理となる
; この処理の終了後に本来のH.TIMI処理を呼び出す
;=================================
H_TIMI_HANDLER:

    ; Decrement VBLANK_WAIT_FLG variable.
    ; most every 1/60 second.
    ; 1/60秒ごとにVBLANK_WAIT_FLGの内容をチェックし
    ; 0であれば本来のH.TIMI処理を呼び出す
    ;  
    ld a, (VBLANK_WAIT_FLG)
    or a
    
    ;
    ; Call original H.TIMI hook procedure.
    ; most every 1/60 second.
    ; 本来のH.TIMI処理を呼び出す
    ;
    jr z, H_TIMI_HANDLER_GO_BACKUPPROC
        
    ; Set zero to VBLANK_WAIT_FLG variable.
    ; VBLANK_WAIT_FLGの値をゼロにする
    dec a
    ld (VBLANK_WAIT_FLG), a

H_TIMI_HANDLER_GO_BACKUPPROC:

    ; If you want to confine the 
    ; process within VBLANKING, 
    ; describe the process here.
    ; VBLANKING内に処理を閉じ込めたい場合は
    ; ここに処理を記述する。

    ; AKG Playerの処理
    call PLY_AKG_PLAY

    ; PATTERNNAMETB_REDRAWが1であれば
    ; VIRTVRAMの内容をVRAMのパターンネームテーブル
    ; 1820Hに書き込む

    ld a, (PATTERNNAMETB_REDRAW)
    or a
    jr z, SkipPatterNameTableRedraw

    ld a, $80
    ld (DISP_CHAR_CODE), a
    ld de, $80 * 8
    call CREATE_CHAR_PATTERN

    ld hl, VIRTVRAM + 32
    ld de, $1820
    ld bc, 736
    call WRTVRMSERIAL

    ld hl, TITLE_MSG
    ld de, $1800
    ld bc, 15
    call WRTVRMSERIAL

    xor a
    ld (PATTERNNAMETB_REDRAW), a

SkipPatterNameTableRedraw:

    ; ==============================================
    ; インタースロット呼び出し後で割込がDISABLEになる
    ; 場合があるため必ずEIして終了する
    ; ==============================================
    ei ; Enable Interrupt.

    ; キー入力を受け付ける
    ; BIOSを呼び出すためインタースロットコールで呼び出す

    xor a
    ld (ZKEY_PUSHED), a
    ld (XKEY_PUSHED), a

    ld ix, KILBUF
    call BiosInterSlotCall

    ld a, 5
    ld ix, SNSMAT
    call BiosInterSlotCall

    ; Zキーが押された？ 
    cp 01111111B
    jr nz, NOTPUSHZKEY

    ld a, 1
    ld (ZKEY_PUSHED), a
    jr  H_TIMI_HANDLER_END

NOTPUSHZKEY:

    ; Xキーが押された？
    cp 11011111B
    jr nz, H_TIMI_HANDLER_END

    ld a, 1
    ld (XKEY_PUSHED), a
    jr  H_TIMI_HANDLER_END
    
H_TIMI_HANDLER_END:

    ; Submit the original H.TIMI procedure.
    ; H_TIMI_BACKUPに戻る
    jp H_TIMI_BACKUP
