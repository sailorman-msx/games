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

;--------------------------------------------
; 変数領域
;--------------------------------------------
; DEBUG PRINT用
WK_DUMPDATA:equ $C000    ; 16バイト
WK_DUMPCHAR:equ $C010    ; 32バイト

; キャラクタデータ作成用
WK_CHARDATAADR:equ $D000 ; 2バイト
WK_CHARCODE:equ $D002    ; 1バイト

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

    ld a, 32         ;WIDTH=32
    ld (LINWID), a

    ;ファンクションキー非表示
    call ERAFNK

    ;カチカチ音を消す
    ld a, 0
    ld (CLIKSW), a

;--------------------------------------------
; 初期処理（お約束コード）ここまで
;--------------------------------------------

;--------------------------------------------
; メイン処理
;--------------------------------------------
Main:

    ;--------------------------------------------
    ; キャラクタパターンとカラーテーブルを
    ; 作成する
    ;--------------------------------------------
    call CreateCharacterPattern

    ;--------------------------------------------
    ; "0"という文字を768バイトぶん
    ; VRAMのパターンネームテーブルに埋める
    ; (横32文字 x 縦24行＝768バイト)
    ;--------------------------------------------
    ld hl, $1800
    ld  a, $80
    call PutVRAM256Bytes

    ld hl, $1900
    ld  a, $88
    call PutVRAM256Bytes

    ;
    ; 16バイト分のデータを画面にDUMP出力する
    ;
    ld hl, CHRPTN       ; CHRPTNのアドレスの内容を
    ld de, WK_DUMPDATA  ; WK_DUMPDATAのアドレスに
    ld bc, 16           ; 16バイト転送する
    ldir

    call PrintHexaDump

    ;
    ; WK_DUMPCHARのアドレスの内容を
    ; 画面上の下段(1A00H)に32バイト転送する
    ;
    ld de, $1A00
    call HexaDumpToVRAM

MainEnd:
    jr MainEnd

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "pcg_graphic1.asm"
include "common.asm"
include "data.asm"