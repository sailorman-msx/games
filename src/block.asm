; BIOSルーチン
REDVRM:equ $004A ; VRAMの内容をAレジスタに読み込む
WRTVRM:equ $004D ; VRAMのアドレスにAレジスタの値を書き込む
SETRED:equ $0050 ; VRAMからデータを読み込める状態にする
SETWRT:equ $0053 ; VRAMにデータを書き込める状態にする
FILVRM:equ $0056 ; VRAMの指定領域を同一のデータで埋める
LDIRMV:equ $0059 ; VRAMからRAMにブロック転送する
LDIRVM:equ $005C ; RAMからVRAMにブロック転送する
CHGMOD:equ $005F ; SCREENモードを変更する
SETGRP:equ $007E ; VDPのみをGRAPHIC2モードにする
ERAFNK:EQU $00CC ;ファンクションキーを非表示にする
GTSTCK:equ $00D5 ; JOY STICKの状態を調べる
GTTRIG:equ $00D8 ; トリガボタンの状態を返す
CHGCLR:equ $0111 ; 画面の色を変える
KILBUF:equ $0156 ; キーボードバッファをクリアする

; ワークエリア
LINWID:equ $F3AF ; WIDTHで設定する1行の幅が格納されているアドレス
RG0SAV:equ $F3DF ; VDPレジスタ#0の値が格納されているアドレス
FORCLR:equ $F3E9 ; 前景色が格納されているアドレス
BAKCLR:EQU $F3EA ;背景色のアドレス
BDRCLR:equ $F3EB ; 背景色が格納されているアドレス
CLIKSW:equ $F3DB ; キークリック音のON/OFFが格納されているアドレス
INTCNT:equ $FCA2 ; MSX BIOSにて1/60秒ごとにインクリメントされる値が格納されているアドレス

; プログラム内部で使う変数のアドレス
WK_VRAM          :equ $C000    ; VRAM退避用
WK_PLAYERPOSX    :equ $D000    ; PLAYERスプライトのX座標(LOCATE座標)
WK_PLAYERPOSY    :equ $D001    ; PLAYERスプライトのY座標(LOCATE座標)
WK_PLAYERPOSX_OLD:equ $D002    ; PLAYERスプライトのX座標(LOCATE座標)
WK_PLAYERPOSY_OLD:equ $D003    ; PLAYERスプライトのY座標(LOCATE座標)
WK_VRAMCALC      :equ $D004    ; VRAMアドレス格納用ワーク(2byte)
WK_DEBUGDAT      :equ $D006    ; DEBUG用出力データ(2byte)
WK_DEBUGLOC      :equ $D008    ; DEBUG出力先VRAMアドレス(2byte)
WK_RANDOM        :equ $D00A    ; 乱数算出用ワーク
WK_DECIMALDISP   :equ $D00B    ; 数字出力用ワーク8byte(1byteずつに0-9までの数値がセットされる
WK_DECIMALCHAR   :equ $D013    ; 数字出力用ワーク8byte(WK_DECIMAPDISPの値を文字に変換したコード)
WK_PLAYERDISTANCE:equ $D01B    ; プレイヤーの向き(上1,下5,左7,右3)

; プログラムの開始位置アドレスは0x4000
org $4000

.Header
    ; MSX の ROM ヘッダ (16 bytes)
    defb 'A', 'B', $10, $40, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00

.Start

    ; スタックポインタを初期化
    ld sp, $F380

    ; 画面構成の初期化
    ld a, $0F
    ld (FORCLR), a   ;白色
    ld a, $01
    ld (BAKCLR), a   ;黒色
    ld (BDRCLR), a   ;黒色

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a  ;スプライトモードを16X16に

    ld a, 1          ;SCREEN1
    call CHGMOD      ;スクリーンモード変更

    call SETGRP      ;GRAPHIC2モードに変更

    ld a, 32         ;WIDTH=32
    ld (LINWID), a

    ;ファンクションキー非表示
    call ERAFNK

    ;カチカチ音を消す
    ld a, 0
    ld (CLIKSW), a

.End
    jr End
