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

; スプライト座標格納用
WK_PLAYERPOSX:equ $C011     ; 1バイト
WK_PLAYERPOSY:equ $C012     ; 1バイト
WK_PLAYERPOSXOLD:equ $C013  ; 1バイト
WK_PLAYERPOSYOLD:equ $C014  ; 1バイト

WK_PLAYERDIST:equ $C015     ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)
WK_PLAYERDISTOLD:equ $C016  ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)

WK_PLAYERMOVE_X:equ $C017   ; 1バイト（プレイヤーのX移動量）
WK_PLAYERMOVE_Y:equ $C018   ; 1バイト（プレイヤーのY移動量）

WK_PLAYERSPRCLR1:equ $C019  ; 1バイト（スプライト1枚目)
WK_PLAYERSPRCLR2:equ $C01A  ; 1バイト（スプライト2枚目)

WK_SPRITEPOSX:equ $C01B     ; 1バイト
WK_SPRITEPOSY:equ $C01C     ; 1バイト

; キーイン情報
WK_TRIGGER:equ $C01D        ; 1バイト(0:TRIGGER OFF, 1:TRIGGER ON)

; キーインのインターバル 
WK_KEYIN_INTERVAL:equ $C020 ; 1バイト

; 処理モード
; 0: title
; 1: opening
; 2: game main
; 3: game over
WK_GAMESTATUS:equ $C021 ; 1バイト

WK_GAMESTATUS_INTTIME:equ $C022 ; 1バイト

; BONUS BALLのカラー
WK_BONUS_BALL_CLR:equ $C023 ; 1バイト
; BAD BALLのカラー
WK_BAD_BALL_CLR:equ $C024   ; 1バイト

; BALL回収個数
; BALL10個でステージクリア
WK_GETBALL_NUM:equ $C025    ; 1バイト

; タイマー(300秒)
; 0になるとタイムアウト
WK_COUNTDOWN_TIMER:equ $C026 ; 2バイト

; 1/60秒ごとに加算する値
; 60で0に戻る
WK_TIMI60:equ $C028 ; 2バイト

; VDPポート番号定数
CONST_VDPPORT0:equ $98   
CONST_VDPPORT1:equ $99

; VRAMデータ退避用
WK_VRAMTORAM:equ $C030   ; 0800Hバイト(C030H - C82FH)

; HLレジスタ退避用
WK_HLREGBACK:equ $C830   ; 2バイト
; DEレジスタ退避用
WK_DEREGBACK:equ $C832   ; 2バイト
; BCレジスタ退避用
WK_BCREGBACK:equ $C834   ; 2バイト

; VRAM当たり判定用
WK_CHECKPOSX:equ $C836   ; 1バイト
WK_CHECKPOSY:equ $C837   ; 1バイト
WK_CONFLICTX:equ $C838    ; 1バイト
WK_CONFLICTY:equ $C839    ; 1バイト
WK_VRAM4X4_TBL:equ $C840 ; 16バイト

; キャラクタデータ作成用
WK_CHARDATAADR:equ $D000 ; 2バイト
WK_CHARCODE:equ $D002    ; 1バイト

; 乱数格納用変数 
WK_RANDOM_VALUE:equ $D003           ; 2バイト

; ステージ番号変数
; ステージ番号*3 の個数のボールが表示される
; ステージ番号は8が最大
WK_STAGE_NUM:equ $D005              ; 1バイト

; スプライト座標管理用(6byte * 32個分=160バイト)
; +0 : Y座標
; +1 : X座標
; +2 : パターン番号
; +3 : カラー
; +4 : X座標の移動方向(1:+ 2:マイナス)
; +5 : X座標の移動方向(1:+ 2:マイナス)
WK_SPRITE_MOVETBL:equ $D007 ; 192バイト(D007H - D0C6H)

; プレイヤー移動可能判定処理テーブル
WK_MOVECONDITION_PROC:equ $D0C7  ; 18バイト

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

    ld a, 0
    ld (WK_SPRITE0_NUM), a

;--------------------------------------------
; 初期処理（お約束コード）ここまで
;--------------------------------------------

    ;---------------------------------------
    ; スクロール処理ルーチンのアドレスを
    ; 定義する
    ; ※当テーブルの利用箇所はplayer.asm
    ;---------------------------------------
    ld ix, WK_MOVECONDITION_PROC
    ld de, CheckMoveConditionNG

    ; 方向=0 
    ld (ix + 0), e 
    ld (ix + 1), d

    ; 方向=1(上)
    ld hl, CheckMoveUp
    ld (ix + 2), l
    ld (ix + 3), h 

    ; 方向=2(右上) 
    ld hl, CheckMoveUpRight
    ld (ix + 4), l 
    ld (ix + 5), h 

    ; 方向=3(右)
    ld hl, CheckMoveRight
    ld (ix + 6), l
    ld (ix + 7), h

    ; 方向=4(右下)
    ld hl, CheckMoveDownRight
    ld (ix + 8), l
    ld (ix + 9), h

    ; 方向=5(下)
    ld hl, CheckMoveDown
    ld (ix + 10), l
    ld (ix + 11), h

    ; 方向=6(左下)
    ld hl, CheckMoveDownLeft
    ld (ix + 12), l
    ld (ix + 13), h

    ; 方向=7(左)
    ld hl, CheckMoveLeft
    ld (ix + 14), l
    ld (ix + 15), h

    ; 方向=8(左上)
    ld hl, CheckMoveUpLeft
    ld (ix + 16), l
    ld (ix + 17), h
