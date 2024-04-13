;--------------------------------------------
; initialize.asm
; 初期処理
; 変数が増える場合はこちらに記述すること！
;--------------------------------------------
; BIOSルーチン
CHGMOD:equ $005F ; SCREENモードを変更する
SETGRP:equ $007E ; VDPのみをGRAPHIC2モードにする
GICINI:equ $0090 ; PSGの初期化アドレス
WRTPSG:equ $0093 ; PSGレジスタへのデータ書込アドレス
ERAFNK:EQU $00CC ;ファンクションキーを非表示にする
GTSTCK:equ $00D5 ; JOY STICKの状態を調べる
GTTRIG:equ $00D8 ; トリガボタンの状態を返す
CHGCLR:equ $0111 ; 画面の色を変える
SNSMAT:equ $0141 ; キーボード判定
KILBUF:equ $0156 ; キーボードバッファをクリアする

; BIOSルーチン(SUB-ROM用)
EXTROM:equ $015F ; SUB-ROMインタースロットコール
SETPLT:equ $014D ; カラーパレットの設定

; ワークエリア
LINWID:equ $F3AF ; WIDTHで設定する1行の幅が格納されているアドレス
RG0SAV:equ $F3DF ; VDPレジスタ#0の値が格納されているアドレス
FORCLR:equ $F3E9 ; 前景色が格納されているアドレス
BAKCLR:EQU $F3EA ; 背景色のアドレス
BDRCLR:equ $F3EB ; 背景色が格納されているアドレス
CLIKSW:equ $F3DB ; キークリック音のON/OFFが格納されているアドレス
INTCNT:equ $FCA2 ; MSX BIOSにて1/60秒ごとにインクリメントされる値が格納されているアドレス
H_TIMI:equ $FD9F ; 垂直帰線割り込みフック
H_PHYDIO:equ $FFA7 ; 物理FDD装着時のフック

; カラーパレット設定用
ISMSX1FLG:equ $002D ; 0でなければMSX1ではないと判定する

; MSX-DOSからSUB-ROMを呼び出す場合のおまじない
CALSLT:equ $001C ; CALSLT
H_NMI:equ $015F  ; H.NMIフック
EXPTBL:equ $FCC1

; 8000H以降も使えるようにするおまじない
RSLREG:equ $0138
ENASLT:equ $0024

;--------------------------------------------
; 初期処理（お約束コード）
;--------------------------------------------
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

    ;-------------------------------------------
    ; 画面構成の初期化
    ; 8000H以降も使えるようにするおまじない:ここから
    ;-------------------------------------------

    ; 基本スロット選択レジスタを読み出しAレジスタに格納
    ; 基本スロット選択レジスタの第0、第1ビットは
    ; どちらも0(slot#0のpage#0)になっている
    call RSLREG

    ; Aレジスタを2ビット右にローテートし
    ; A=[00|00|00|P1]の形にする
    rrca             ; Aレジスタを2ビット右にローテート
    rrca             ; 

    ; P1(page#1の基本スロット番号)を00000011BでANDして
    ; BCレジスタに格納
    and 3
    ld c, a
    ld b, 0
    
    ; EXPTBL(基本スロットの拡張の有無のslot#3のアドレスを
    ; HLレジスタにセット
    ; HL=EXPTBL + 3(slot#3 existing info)
    ld hl, EXPTBL
    add hl, bc

    ; 拡張有無をAレジスタにセットする
    ; (Aレジスタの第7ビットに拡張有無が格納されている)
    ld a,(hl)
    and 80h          ; Keep the secondary slot flag only

    ; Aレジスタ（拡張有無)とCレジスタ（P1）のORをとり
    ; Cレジスタに格納する
    or c
    ld c, a

    ; SLTTBL(FCC5H,4)にHLレジスタのアドレスを位置付ける
    ; このアドレスは拡張スロット選択情報のslot#3の値となる
    inc hl
    inc hl
    inc hl
    inc hl           ; HL=SLTTBL + P1

    ; 拡張スロット選択情報のslot#3の情報を
    ; Aレジスタに格納する
    ld  a, (hl)

    ; Aレジスタの値(slot#3)の情報と
    ; $0CをANDする
    ; A=[80|00|S1|P1] or [00|00|XX|P1]
    and $0C
    or c
    ld h, $80

    ; ENASLTを呼び出しROM上のpage#2(8000H - BFFFH)までを
    ; 利用できるようにする
    ld de, ENASLT        ; Select the ROM on page 8000h-BFFFh
    call BiosCall

    ; 8000H以降も使えるようにするおまじない:ここまで

    ;-------------------------------------------
    ; 画面カラーパレットの初期化
    ;-------------------------------------------
SetColorPalleteMSX1:

    ld a, (ISMSX1FLG)
    or a

    ; ISMSX1FLGが0でなければMSX2以上であると判定する
    jp z, SkipColorPallete

    ld hl, ColorPalleteData
    ld b, 15
    ld c, 0

ColorPalleteSetLoop:

    ; SETPLTはSUB-ROMに格納されてあるため
    ; EXTROM経由で呼び出しを行う

    ld d, c
    ld a, (hl)
    inc hl
    ld e, (hl)
    inc hl

    ld ix, SETPLT
    push hl
    call BiosNotFDDSubRomCall
    pop hl
    ei

    inc c
    ld a, c
    cp b
    jp nz, ColorPalleteSetLoop

    jp SkipColorPallete

ColorPalleteData:

defb $00, $00 ; Color 0
defb $00, $00 ; Color 1
defb $11, $05 ; Color 2
defb $33, $06 ; Color 3
defb $26, $02 ; Color 4
defb $37, $03 ; Color 5
defb $52, $02 ; Color 6
defb $27, $06 ; Color 7
defb $62, $02 ; Color 8
defb $63, $03 ; Color 9
defb $52, $05 ; Color A
defb $63, $06 ; Color B
defb $11, $04 ; Color C
defb $55, $02 ; Color D
defb $55, $05 ; Color E
defb $77, $07 ; Color F

SkipColorPallete:

    xor a
    ld (WK_VRAM_SYNC), a
    ld (WK_GAMESTATUS), a

;--------------------------------------------
; 初期処理（お約束コード）ここまで
;--------------------------------------------
