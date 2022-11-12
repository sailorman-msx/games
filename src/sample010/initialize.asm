;--------------------------------------------
; initialize.asm
; 初期処理
; 変数が増える場合はこちらに記述すること！
;--------------------------------------------
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

; VRAMデータ退避用
WK_VRAMTORAM:equ $C030   ; 0800Hバイト(C030H - C82FH)

; MAPデータ格納用(タイルデータ格納エリア)
; 45 x 45 tile
WK_MAPAREA:equ $D500       ; 2025バイト(D500H-)

; ビューポート表示データ(VRAM転送データ生成用)
; 横20x縦20のデータのみ生成する
WK_MAP_VIEWAREA:equ $D01A ; 400バイト(D01AH - D1AAH)

; MAPデータ作成用ワーク
WK_MAPAREA_ADDR:equ $D1AB ; 2バイト

; ビューポート左上のMAP上での論理座標
WK_VIEWPORTPOSX:equ $D1AD ; 1バイト(X座標)
WK_VIEWPORTPOSY:equ $D1AE ; 1バイト(Y座標)

; ビューポート作成用
WK_VIEWPORT_ADDR:equ $D1AF     ; 2バイト
WK_VIEWPORT_VRAMADDR:equ $D1B1 ; 2バイト
WK_VIEWPORT_COUNTER:equ $D1B3  ; 1バイト(ただのカウンタ変数格納用)

; キャラクタデータ作成用
WK_CHARDATAADR:equ $D200   ; 2バイト
WK_CHARCODE:equ $D202      ; 1バイト

; スプライト座標格納用
WK_PLAYERPOSX:equ $D203     ; 1バイト(0-31)
WK_PLAYERPOSY:equ $D204     ; 1バイト(0-23)
WK_PLAYERPOSXOLD:equ $D205  ; 1バイト(0-31)
WK_PLAYERPOSYOLD:equ $D206  ; 1バイト(0-23)

WK_PLAYERDIST:equ $D207     ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)
WK_PLAYERDISTOLD:equ $D208  ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)

WK_PLAYERMOVE_TBL:equ $D209 ; 8バイト（プレイヤーの移動量）

; ワーク用スプライトアトリビュートテーブル
; スプライトを表示させるために、いったんこのワークテーブルを
; 作成してからLDIRVMでVRAMに一括転送する
WK_PLAYERSPRATTR:equ $D211  ; 8バイト（スプライト2枚分）
WK_PLAYERSPRCLR1:equ $D219  ; 1バイト（スプライト1枚目)
WK_PLAYERSPRCLR2:equ $D21A  ; 1バイト（スプライト2枚目)

; VRAM情報取得用ワークテーブル
; 指定されたXY座標周辺のVRAM情報を取得する
WK_VRAM4X4_TBL:equ $D21B    ; 16バイト（VRAM情報格納用）
WK_CHECKPOSX:equ $D22B      ; 1バイト（VRAM情報取得用X座標）
WK_CHECKPOSY:equ $D22C      ; 1バイト（VRAM情報取得用Y座標）


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

    ; GRAPHIC2モードに変更する
    call SETGRP

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

