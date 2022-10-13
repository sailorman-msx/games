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

; 変数格納エリア
; 変数格納エリアをプログラム領域の近いところに設定すると暴走のもとになるため
; わりと遠いアドレスにしておくのが良い
MESSAGE_ADR:equ $D000

;---------------------------------------------------------
; 初期処理（お約束コード）
;---------------------------------------------------------
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

;---------------------------------------------------------
; 初期処理（お約束コード）ここまで
;---------------------------------------------------------

;---------------------------------------------------------
; MAIN-LOOP
;---------------------------------------------------------
MainLoop:

    ; 無駄ループを繰り返し遅延させる
    ; 遅延させないとマシン語は速すぎる！
    ; call でサブルーチンにジャンプする
    call DelayLoop
    call DelayLoop
    call DelayLoop

    ; テキストメッセージを全て*にする
    ld hl, MESSAGE_ASTERISK
    ld de, MESSAGE_ADR
    ld bc, 26

    ; LDIRはブロック転送命令
    ; LDIRはHLが指し示すアドレスの内容を
    ; DEレジスタが指し示すアドレスを先頭に
    ; BCレジスタが指し示すバイト数だけブロック転送する
    ; このサンプルだと以下のようになる
    ;   MESSAGE_ASTERISKのアドレス以降26バイトぶんの文字を
    ;   MESSAGE_ADRのアドレスの中にブロック転送する
    ldir

    ; テキストメッセージを画面に表示する
    call PrintMessage

    ; 無駄ループを繰り返し遅延させる
    call DelayLoop
    call DelayLoop
    call DelayLoop

    ; テキストメッセージを文章にする
    ld hl, MESSAGE
    ld de, MESSAGE_ADR
    ld bc, 26
    ldir

    ; テキストメッセージを画面に表示する
    call PrintMessage
    
    ; MainLoopに戻る
    ; JPは直接アドレッシング指定と呼ばれるジャンプ
    jp MainLoop

;---------------------------------------------------------
; SUB-ROUTINE: DelayLoop
; 空ループを繰り返し処理遅延をおこす
;---------------------------------------------------------
DelayLoop:

    ld b, 150 ; 150 * 255回空ループを繰り返す

DelayLoop1:

    ld a, $FF ; Aレジスタに$FF(255)をセット

DelayLoop2:

    dec a ; Aレジスタの値から1を減算する

    ; ZフラグがたっていなければDelayLoop2に戻る
    ; JRは間接アドレッシング指定と呼ばれるジャンプ
    jr nz, DelayLoop2

    ; Bレジスタの値から1を減算しZフラグがたっていなければDelayLoop1に戻る
    ; DJNZも間接アドレッシング指定
    djnz DelayLoop1

    ; ret で呼び出し元の次の命令アドレスに実行位置が戻る
    ret

;---------------------------------------------------------
; SUB-ROUTINE: PrintMessage
;---------------------------------------------------------
PrintMessage:

    ; VRAMを使って画面に文字を表示する
    ; HLレジスタにメモリ(RAM)のアドレス
    ; DEレジスタにVRAMの先頭アドレス
    ; BCレジスタに転送サイズ（バイト）
    ; VRAMにメモリのデータを転送するにはBIOSのLDIRVMを使う

    ld hl, MESSAGE_ADR
    ld de, $1800    ; 数値の先頭に$をつけると16進として解釈する
    ld bc, 26       ; メッセージは26バイト
    call LDIRVM

    ret

;---------------------------------------------------------
; 固定値領域
;---------------------------------------------------------
MESSAGE:
    defm "Let's make an arcade game!"

MESSAGE_ASTERISK:
    defm "**************************"
