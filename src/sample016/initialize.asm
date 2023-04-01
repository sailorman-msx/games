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
GICINI:equ $0090 ; PSGの初期化アドレス
WRTPSG:equ $0093 ; PSGレジスタへのデータ書込アドレス
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
H_TIMI:equ $FD9F ; 垂直帰線割り込みフック

;--------------------------------------------
; 変数領域
;--------------------------------------------
; DEBUG PRINT用
WK_DUMPDATA:equ $C000    ; 16バイト
WK_DUMPCHAR:equ $C010    ; 32バイト

; VRAMデータ退避用
WK_VRAMTORAM:equ $C030   ; 0800Hバイト(C030H - C82FH)

; VDPポート番号格納用

; PORT#0 (0006Hの値が格納される）
CONST_VDP_PORT0ADDR:equ 0006H ; 定数
WK_VDPPORT0:equ $C830       ; 1バイト

; PORT#1 (0007Hの値が格納される）
CONST_VDP_PORT1ADDR:equ 0007H ; 定数
WK_VDPPORT1:equ $C831 ; 1バイト

; キャラクタデータ作成用
WK_CHARDATAADR:equ $D000 ; 2バイト
WK_CHARCODE:equ $D002    ; 1バイト

; スプライト座標格納用
WK_PLAYERPOSX:equ $C003     ; 1バイト(0-31)
WK_PLAYERPOSY:equ $C004     ; 1バイト(0-23)
WK_PLAYERPOSXOLD:equ $C005  ; 1バイト(0-31)
WK_PLAYERPOSYOLD:equ $C006  ; 1バイト(0-23)

WK_PLAYERDIST:equ $C007     ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)
WK_PLAYERDISTOLD:equ $C008  ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)

WK_PLAYERMOVE_TBL:equ $C009 ; 8バイト（プレイヤーの移動量）

WK_PLAYERSPRCLR1:equ $D011  ; 1バイト（スプライト1枚目)
WK_PLAYERSPRCLR2:equ $D012  ; 1バイト（スプライト2枚目)

WK_SPRITEPOSY:equ $D013     ; 1バイト

; スプライトアトリビュート格納用の仮想テーブル
; 1/60秒ごとに素数を使ってシャッフルする
; 同時に表示するスプライトは16体
; アトリビュートテーブルは1体あたり4バイト
; 計128バイト
;
; 以下のテーブルが16個並ぶ
; +0 : Y座標
; +1 : X座標
; +2 : パターン番号 
; +3 : カラー番号
;

; データ更新用（シャッフル用）
WK_VIRT_SPR_ATTR_TBL:equ $D100 ; 128バイト (D100H - D17FH)
; データ更新用（表示用）
WK_DISP_SPR_ATTR_TBL:equ $D180 ; 128バイト (D180H - D1FFH)

; VRAMスプライトアトリビュートのスプライト番号
; シャッフルのつど、19 * 4=76 を加算していく
; 加算結果は常に0x7FでANDを行い32*4を超えないようにする
WK_SPRITE0_NUM:equ $D200       ; 1バイト

; 垂直同期待ちカウンタ
VSYNC_WAIT_CNT:equ $D201       ; 1バイト

; H.TIMIフックバックアップ用ワークエリア 
H_TIMI_BACKUP:equ $D202  ; 5バイト

; サウンドドライバ用ワークエリア
SOUNDDRV_H_TIMI_BACKUP:equ $E000     ; 5バイト
SOUNDDRV_STATE:equ $E005             ; 1バイト
SOUNDDRV_WK_MIXING_TONE:equ $E006    ; 1バイト
SOUNDDRV_WK_MIXING_NOISE:equ $E007   ; 1バイト
SOUNDDRV_BGMWK:equ $E008             ; 16バイト*3 = 48バイト
SOUNDDRV_DUMMYWK:equ $E038           ; 16バイト
SOUNDDRV_SFXWK:equ $E048             ; 16バイト*3 = 48バイト

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

    ; VDP PORTのポート番号をセットする

    ld a, (CONST_VDP_PORT0ADDR)  ; ポート番号#0のセット
    ld (WK_VDPPORT0), a

    ld a, (CONST_VDP_PORT1ADDR)  ; ポート番号#1のセット
    ld (WK_VDPPORT1), a

    ld a, 0
    ld (WK_SPRITE0_NUM), a

;--------------------------------------------
; 初期処理（お約束コード）ここまで
;--------------------------------------------
