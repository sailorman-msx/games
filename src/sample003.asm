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
    ld  a, '0'
    call PutVRAM256Bytes

    ld hl, $1900
    ld  a, '8'
    call PutVRAM256Bytes

    ld hl, $1A00
    ld  a, '0'
    call PutVRAM256Bytes

MainEnd:
    jr MainEnd


;--------------------------------------------
; SUB-ROUTINE: PutVRAM256Bytes
; HLレジスタで指定したVRAMアドレスから
; Aレジスタの値を256文字分書き込む
;--------------------------------------------
PutVRAM256Bytes:

    push af
    push bc

    ld  b, $00

PutVRAM256BytesLoop:

    call WRTVRM
    inc hl

    djnz PutVRAM256BytesLoop

    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: CreateCharacterPattern
; パターンジェネレータテーブルと
; カラーテーブルを編集する
;--------------------------------------------
CreateCharacterPattern:
    
    ; キャラクタデータ作成用変数に
    ; パターンデータのアドレスをセット
    ld hl, CHRPTN
    ld (WK_CHARDATAADR), hl
 
CreateCharacterPatternLoop:

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld hl, (WK_CHARDATAADR)
    ld a, (hl)

    ld (WK_CHARCODE), a

    ;
    ; Aレジスタの値から1を減算した結果でCYフラグを確認する
    ; CYフラグがたてば処理終了とする
    ;
    cp 1
    jr c, CreateCharacterPatternEnd

    inc hl
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを1進める

    ;-----------------------------------------------
    ; パターンジェネレータテーブル処理
    ;-----------------------------------------------

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld a, (WK_CHARCODE)

    ;
    ; Aレジスタには文字コードがセットされているので
    ; その値を8倍した値がパターンの開始アドレスになる
    ;
    ld h, a
    ld e, 8

    ;
    ; Hレジスタの値を8倍する
    ;
    call CalcMulti

    ;
    ; HLレジスタの値にはVRAMのパターンジェネレータテーブルの
    ; アドレスが格納されているためDEレジスタにセットする
    ;
    ld de, hl

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ld hl, (WK_CHARDATAADR)
    add hl, 8
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    jr CreateCharacterPatternLoop

CreateCharacterPatternEnd:

    ;-----------------------------------------------
    ; 最後にカラーテーブルを処理する
    ;-----------------------------------------------
    ld hl, $2006  ; '0'の文字色
    ld  a, $81    ; FG:RED BG:BLACK
    call WRTVRM
    ld hl, $2007  ; '8'の文字色
    ld  a, $51    ; FG:BLUE BG:BLACK
    call WRTVRM
    
    ret
    
;--------------------------------------------
; SUB-ROUTINE: CalcMulti
; 掛け算を行う
; Eレジスタに格納されている値とHレジスタに
; 格納されている値を掛けてその結果をHLレジスタ
; にセットして返却する
;--------------------------------------------
CalcMulti:

    ;
    ; 当サブルーチンではBレジスタとDレジスタ
    ; HLレジスタを破壊するためPUSHで退避しておく
    ;
    push bc
    push de

    ld d, 0
    ld l, 0
    ld b, 8

CalcMulti1:

    ; 
    ; Hレジスタの値を2倍する
    ; (2倍することで左に1ビットシフトする)
    ;
    ; 計算結果が16bitになる場合もあるため
    ; HLレジスタ(16bit)として使う
    ;
    ; Hレジスタの第7ビットの値はCYフラグに入る
    ; (桁あがりするとCYフラグが1になる)
    ;
    add hl, hl

    ;
    ; CYフラグがたっていなければCalcMulti2へジャンプ
    jr nc, CalcMulti2

    ;
    ; CYフラグが立っている場合は
    ; Eレジスタの値をHLレジスタに足す
    ;
    add hl, de

CalcMulti2:

    ;
    ; Bレジスタが0になるまで（計8bitぶん）
    ; HL + HL を繰り返す
    djnz CalcMulti1

    ; 退避していたレジスタを戻す
    pop de
    pop bc

    ret

;--------------------------------------------
; ここから固定データ
;--------------------------------------------
; キャラクタパターンとカラーテーブル
CHRPTN:
    defb '0'  ; CHAR CODE
    defb $FC, $FC, $FC, $00, $CF, $CF, $CF, $00 ; CHAR PATTERN

    defb '8'  ; CHAR CODE
    defb $38, $38, $38, $7C, $BA, $38, $6C, $00 ; CHAR PATTERN

CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
