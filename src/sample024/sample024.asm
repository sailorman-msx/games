; BIOSルーチン
CHGMOD:equ $005F ; SCREENモードを変更する
ERAFNK:EQU $00CC ;ファンクションキーを非表示にする

; ワークエリア
LINWID:equ $F3AF ; WIDTHで設定する1行の幅が格納されているアドレス
RG0SAV:equ $F3DF ; VDPレジスタ#0の値が格納されているアドレス
FORCLR:equ $F3E9 ; 前景色が格納されているアドレス
BAKCLR:EQU $F3EA ; 背景色のアドレス
BDRCLR:equ $F3EB ; 背景色が格納されているアドレス
CLIKSW:equ $F3DB ; キークリック音のON/OFFが格納されているアドレス
H_TIMI:equ $FD9F ; 垂直帰線割り込みフック

CONST_VDPPORT0:equ $98
CONST_VDPPORT1:equ $99

; プログラムの開始位置アドレスは0x4000
org $4000

Header:

    ; MSX の ROM ヘッダ (16 bytes)
    ; プログラムの先頭位置は0x4010
    defb 'A', 'B', $10, $40, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00

Start:

    ; スタックポインタを初期化
    ld sp, $F380

    ; カラーを変更する
    ld a, $0F
    ld (FORCLR), a   ;白色
    ld a, $01
    ld (BAKCLR), a   ;黒色
    ld (BDRCLR), a   ;黒色

    ; WIDTH変更
    ld a, 32         ;WIDTH=32
    ld (LINWID), a

    ; ファンクションキー情報を消す
    CALL ERAFNK

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a  ;スプライトモードを16X16に

    ; SCREEN1モードに変更する
    ld a, 1
    call CHGMOD

    ; カチカチ音を消す
    xor a
    ld (CLIKSW), a

    ; インターバル(6/60秒）値の初期化
    ld a, 6
    ld (INTERVAL_WAIT6), a

    ; VRAM書き込み同期フラグの初期化
    xor a
    ld (WK_VRAM_SYNC), a

    ; 0-9のフォントカラーを青にする
    ld hl, $2006
    ld bc, 2
    ld a, $71
    call WRTVRMFIL

    ; アルファベットのフォントカラーを赤にする
    ld hl, $2008
    ld bc, 4
    ld a, $81
    call WRTVRMFIL

    ; タイトルの表記
    ld hl, MESSAGE
    ld de, $1820
    ld bc, 23
    call WRTVRMSERIAL

    ei

    ; BCD値の変数を初期化する
    ld hl, NUMBER_DIGIT
    ld bc, 5
    ld a, 0
    call MemFil

    ld hl, NUMBER_DIGIT_STR
    ld bc, 10
    ld a, 0
    call MemFil

    ; H.TIMI書き換え
    call INIT_H_TIMI_HANDLER

    xor a
    ld (VSYNC_WAIT_CNT), a

;-------------------------------
; メイン処理
; 空ループするだけ
;-------------------------------
MainLoop:

    jr MainLoop

;-------------------------------
; H.TIMI書き換え
;-------------------------------
INIT_H_TIMI_HANDLER:

    push af
    push bc
    push de
    push hl

    di

    ; ■H.TIMIバックアップ
    ld hl, H_TIMI                   ; 転送元
    ld de, H_TIMI_BACKUP            ; 転送先
    ld bc, 5                        ; 転送バイト数
    ldir

    ; ■H.TIMI書き換え
    ld a, $C3                        ; JP
    ld hl, H_TIMI_HANDLER            ; サウンドドライバのアドレス
    ld (H_TIMI + 0), a
    ld (H_TIMI + 1), hl

    ei

    pop hl
    pop de
    pop bc
    pop af

    ret

H_TIMI_HANDLER:

    push af

    ; VSYNC_WAIT_CNTデクリメント
    ;   1/60ごとに-1される
    ;   メインルーチンの最初の設定値により
    ;     1 = 60フレーム
    ;     2 = 30フレーム
    ;   の処理となる
    ld a, (VSYNC_WAIT_CNT)
    or a
    jr z, H_TIMI_HANDLER_L1
    dec a
    ld (VSYNC_WAIT_CNT), a

H_TIMI_HANDLER_L1:

    ; 0.1秒（6/60秒）WAIT
    ld a, (INTERVAL_WAIT6)

    ; INTERVAL_WAIT6が0でなければ値のデクリメントのみ実施
    or a
    jr nz, DecIntervalWait
    
    ; INTERVAL_WAIT6を初期化する
    ld a, 6
    ld (INTERVAL_WAIT6), a

    ; BCD値に1を加算する
    call AddBCD

    ; BCDの値を文字列に変換する

    ld hl, NUMBER_DIGIT
    ld de, NUMBER_DIGIT_STR
    ld b, 5 ; NUMBER_DIGITに5バイトぶん(10桁）のBCD値が格納されている

DigitToStr:

    ld a, (hl)
    ld c, a

    ; 上位4ビットの値を抽出
    srl a
    srl a
    srl a
    srl a

    ; 値に$30を加算して文字列にする
    add a, $30

    ; 文字列を変数にセット
    ld (de), a
    inc de

    ld a, c

    ; 下位4ビットの値を抽出
    and $0F

    ; 値に$30を加算して文字列にする
    add a, $30

    ; 文字列を変数にセット
    ld (de), a
    inc de

    inc hl

    ; Bをデクリメントして0になるまでループする
    djnz DigitToStr

DispDigit:

    ; 画面に文字列を表示する
    ld hl, NUMBER_DIGIT_STR
    ld de, $1840
    ld bc, 10
    call WRTVRMSERIAL

    jr IntervalEnd

DecIntervalWait:

    dec a
    ld (INTERVAL_WAIT6), a

IntervalEnd:
    
    ; 割り込み処理の終了後は必ずEIを実施する
    ei
    
    pop af
    
    jp H_TIMI_BACKUP

;--------------------------------------------
; BCD加算処理
;
; BCD(2進化10進）は
; 1バイトを上位4ビットと下位4ビットにわけて
; 10進数の数値を格納する方法
;
; 例1）数値の58の場合
;     58H 
; 例2) 数値の7の場合
;     07H
; 例3) 数値の90の場合
;     90H
;
; BCD値同士を加算して桁上りするとCYフラグが立つ
; 例えば 99H(10進で99)に01H(10進で1)を加算すると
; Aレジスタには00Hになり、CYフラグが成立する
; CYフラグが成立していたら
; ADDを使って上位の桁に1を加算すれば良い
; もちろん上位の桁に加算したあとも
; その桁をDAAで補正する必要がある
;
; 2桁を超える場合は2バイト、3バイトで表現する
;
; 例4) 数値の100の場合
;     01H , 00H
; 例5) 数値の123の場合
;     01H , 23H
; 例6) 数値の9876の場合
;     98H , 76H
;
;--------------------------------------------
AddBCD:

    ; 一番位の低い桁のアドレスをHLにセット
    ; 今回は10桁（5バイト）なので
    ; NUMBER_DIGIT + 4 が一番桁が低い場所

    ld hl, NUMBER_DIGIT + 4

AddBCD_One:

    ; DAAを使ってNUMBER_DIGITを加算する
    ld a, (hl)
    ld e, 1

    ; A = A + 01H してBCDにする
    add a, e
    daa  ; BCDに補正

    ld (hl), a ; 補正値をセットしなおす

    ; CYが成立していたらひとつ手前のDIGITの値に加算する
    ; CYが成立していなければ何もせず処理を抜ける
    jr nc, AddBCDEnd

    ; HLがNUMBER_DIGITと同じアドレスであれば
    ; なにもしない

    push hl
    ld bc, NUMBER_DIGIT
    sbc hl, bc
    ex af, af'  ; フラグレジスタの退避
    pop hl

    ex af, af'  ; フラグレジスタの復旧
    jr z, AddBCDEnd

    ; 加算対象となる桁を減らして上位の桁に再度加算する
    dec hl
    jr AddBCD_One
    
AddBCDEnd:

    ret

MemFil:

    ld (hl), a
    cpi
    jp pe, MemFil

    ret

;---------------------------------------------
; VRAM関連サブルーチン群
;---------------------------------------------

; これらの処理がよばれるとDIされる
; 呼び出したあとに適宜、EIを実施すること

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

    ; WAIT追加
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 上位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    or  $40                    ; 第6ビットを1にする(WRITE-MODE)
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ; WAIT追加
    nop                        ; (05)
    nop                        ; (05)

    pop de
    pop bc
    pop af

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

    ; WAIT追加
    nop
    nop

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

    ld a, (WK_VRAM_SYNC)
    or a
    jr nz, WRTVRMSERIAL_End

    ld a, 1
    ld (WK_VRAM_SYNC), a

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

    xor a
    ld (WK_VRAM_SYNC), a

WRTVRMSERIAL_End:

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMFIL       
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値をBCレジスタの値だけ連続して書き込む
; HLレジスタは書き込み後BCレジスタの数だけ加算される 
;---------------------------------------------------
WRTVRMFIL:
    
    ld d, a                    

    ld a, (WK_VRAM_SYNC)
    or a
    jr nz, WRTVRMFIL_End

    ld a, 1
    ld (WK_VRAM_SYNC), a

    ld a, d

    ; 書き込み宣言
    call VDPWRT

WRTVRMFILLOOP:
    
    out (CONST_VDPPORT0), a    ; (12)
    
    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMFILLOOP

    xor a
    ld (WK_VRAM_SYNC), a

WRTVRMFIL_End:

    ret

; 変数

MESSAGE:
defm "COUNT UP EVERY 0.01 SEC"

DEFVARS $C000
{
WK_VRAM_SYNC       ds.b 1
INTERVAL_WAIT6     ds.b 1
NUMBER_DIGIT       ds.b 5
NUMBER_DIGIT_STR   ds.b 10
VSYNC_WAIT_CNT     ds.b 1
H_TIMI_BACKUP      ds.b 5
}
