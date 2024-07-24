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

;----------------------------------------------------------
; 初期処理（お約束コード）
; 当プログラムでは以下のようなページ構成で
; ROMを作成する
; Page#0 : PCG、スプライト作成処理
; Page#1 : プログラムエリア
; Page#2 : プログラムエリア
; Page#3 : 変数領域/サウンド領域/ワークエリア(F380H以降)
;          変数領域とサウンド領域はC000H-DE3FHまでとする
;-----------------------------------------------------------
; プログラムの開始位置アドレスは0x0000
org $0000

    ;-------------------------------------------
    ; PCG, スプライトの定義処理
    ; Page#0に記述する
    ;-------------------------------------------

    include "pcg_graphic2.asm"
    include "sprite_define.asm"
    include "data_pcg.asm"
    include "data_sprite.asm"
    include "map.asm"

    ;-------------------------------------------
    ; Page#0の終端に余りがある場合は
    ; 0x00で埋める
    ;-------------------------------------------
    defs $4000 - $, $00

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
    ;-------------------------------------------
    ld a, $0F
    ld (FORCLR), a   ;白色
    ld a, $01
    ld (BAKCLR), a   ;黒色
    ld (BDRCLR), a   ;黒色

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a  ;スプライトモードを16X16に

    ; FDD搭載機であればインタースロットコールする
    ld ix, CHGMOD
    ld a, (H_PHYDIO)
    cp $C9
    jp z, NORMAL_CHGMOD

CALSLT_CHGMOD:

    ld a, 1
    ld ix, CHGMOD
    call BiosInterSlotCall

    jp SetGraphic2

NORMAL_CHGMOD:

    ld a, 1
    ld de, CHGMOD
    call BiosCall      ;スクリーンモード変更

SetGraphic2:

    ; FDD搭載機であればインタースロットコールする
    ld a, (H_PHYDIO)
    cp $C9
    jp z, NORMAL_SETGRP2

    ld ix, SETGRP
    call BiosInterSlotCall

    jp SetWidth32

NORMAL_SETGRP2:

    ; GRAPHIC2モードに変更する
    call SETGRP

SetWidth32:

    ld a, 32         ;WIDTH=32
    ld (LINWID), a

SetERAFNK:

    ; FDD搭載機であればインタースロットコールする
    ld a, (H_PHYDIO)
    cp $C9
    jp z, NORMAL_SETERAFNK

    ld ix, ERAFNK
    call BiosInterSlotCall

    jp SetCLIKSW

NORMAL_SETERAFNK:

    call ERAFNK

SetCLIKSW:

    ;カチカチ音を消す
    xor a
    ld (CLIKSW), a

    xor a
    ld (WK_VRAM_SYNC), a

    ;-------------------------------------------
    ; 変数領域の初期化（ゼロクリア）
    ;-------------------------------------------
    xor a
    ld hl, $C000
    ld bc, $1000 ; C000H-CFFFHまでのアドレスに0をセットする
    call MemFil

    ld hl, $D000
    ld bc, $0E3F ; D000H-DE3FHまでのアドレスに0をセットする
    call MemFil

    ;-------------------------------------------
    ; PCGの定義
    ;-------------------------------------------

    ; ひらがなフォントを作成する
    ld a, 2
    ld (WK_VALUE08), a
    ld hl, CreateCharacterPattern
    ld (PAGE0_FUNC), hl
    call ChangePage0Call

    ld hl, InitialPCGDatas
    ld (PAGE0_FUNC), hl
    call ChangePage0Call

    xor a
    ld (WK_VALUE08), a
    ld hl, CreateCharacterPattern
    ld (PAGE0_FUNC), hl
    call ChangePage0Call

    ; 英数フォントを作成する
    ld a, 1
    ld (WK_VALUE08), a
    ld hl, CreateCharacterPattern
    ld (PAGE0_FUNC), hl
    call ChangePage0Call

    ;-------------------------------------------
    ; スプライトの定義
    ;-------------------------------------------

    ld hl, CreateSpritePattern
    ld (PAGE0_FUNC), hl
    call ChangePage0Call

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
    ld (WK_GAMESTATUS), a

;--------------------------------------------
; 初期処理（お約束コード）ここまで
;--------------------------------------------
