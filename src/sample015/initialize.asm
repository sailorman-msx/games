;-------------------------------------------
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
ERAFNK:equ $00CC ;ファンクションキーを非表示にする
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
; ビューポート左上のMAP上での論理座標
WK_VIEWPORTPOSX:equ $C000      ; 1バイト(X座標)
WK_VIEWPORTPOSY:equ $C001      ; 1バイト(Y座標)

; ビューポート作成用
WK_VIEWPORT_ADDR:equ $C002     ; 2バイト
WK_VIEWPORT_VRAMADDR:equ $C004 ; 2バイト
WK_VIEWPORT_COUNTER:equ $C006  ; 1バイト(ただのカウンタ変数格納用)

; VRAM情報取得用ワークテーブル
; 指定されたXY座標周辺のVRAM情報を取得する
WK_VRAM4X4_TBL:equ $C007       ; 16バイト（VRAM情報格納用）
WK_CHECKPOSX:equ $C017         ; 1バイト（VRAM情報取得用X座標）
WK_CHECKPOSY:equ $C018         ; 1バイト（VRAM情報取得用Y座標）

; キャラクタデータ作成用
WK_CHARDATAADR:equ $C019   ; 2バイト
WK_CHARCODE:equ $C01B      ; 1バイト

; スプライト座標格納用
WK_PLAYERPOSX:equ $C01C     ; 1バイト(0-31)
WK_PLAYERPOSY:equ $C01D     ; 1バイト(0-23)
WK_PLAYERPOSXOLD:equ $C01E  ; 1バイト(0-31)
WK_PLAYERPOSYOLD:equ $C01F  ; 1バイト(0-23)

WK_PLAYERDIST:equ $C020     ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)
WK_PLAYERDISTOLD:equ $C021  ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)

WK_PLAYERMOVE_TBL:equ $C022 ; 8バイト（プレイヤーの移動量）

; ワーク用スプライトアトリビュートテーブル
; スプライトを表示させるために、いったんこのワークテーブルを
; 作成してからLDIRVMでVRAMに一括転送する
WK_PLAYERSPRATTR:equ $C02A  ; 8バイト（スプライト2枚分）
WK_PLAYERSPRCLR1:equ $C032  ; 1バイト（スプライト1枚目)
WK_PLAYERSPRCLR2:equ $C033  ; 1バイト（スプライト2枚目)

; 乱数格納用変数
WK_RANDOM_VALUE:equ $C034           ; 2バイト

; 炎のアニメーションパターン
WK_FLAME_ANIME_COUNT:equ $C036      ; 1バイト
WK_FLAME_PATTERN:equ $C037          ; 1バイト

WK_SPAWN_POS:equ $C038              ; 2バイト
WK_SPAWN_POSX_OLD:equ $C03A         ; 1バイト
WK_SPAWN_POSY_OLD:equ $C03B         ; 1バイト

; WK_ENEMY_DATA_TBLのポインタアドレスを保持する
WK_ENEMY_DATA_IDX:equ $C03C         ; 2バイト

; テキキャラMAP座標格納用
WK_ENEMY_POSX_OLD:equ $C03E         ; 1バイト
WK_ENEMY_POSY_OLD:equ $C03F         ; 1バイト

; MAPデータ作成用ワーク
WK_MAPAREA_ADDR:equ $C040           ; 2バイト

; ビューポート作成用
;
; WK_VIEW_POSX = 0
;   AND WK_VIEWPORT_Y = 0
;     WK_MAP_VIEWAREAは横10x縦10タイルぶんだけ格納される
;   AND WK_VIEWPORT_Y > 0
;     WK_MAP_VIEWAREAは横10x縦12タイルぶんだけ格納される
;
; WK_VIEW_POSX > 0
;   AND WK_VIEWPORT_Y = 0
;     WK_MAP_VIEWAREAは横12x縦10タイルぶんだけ格納される
;   AND WK_VIEWPORT_Y > 0
;     WK_MAP_VIEWAREAは横12x縦12タイルぶんだけ格納される
;
WK_VIEWPORT_RANGEX:equ $C042        ; 1バイト
WK_VIEWPORT_RANGEY:equ $C043        ; 1バイト

; VRAMチェック処理のJUMP先アドレス
WK_VRAM_CHECK_PROC:equ $C044        ; 2*9 = 18バイト

; テキキャラ移動処理のJUMP先アドレス
WK_ENEMY_MOVE_PROC:equ $C056        ; 2*9 = 18バイト

; スクロール処理のJUMP先アドレス
WK_SCROLL_PROC:equ $C068            ; 2*9 = 18バイト

;
; DEBUG PRINT用
WK_DUMPDATA:equ $C07B    ; 16バイト
WK_DUMPCHAR:equ $C08B    ; 32バイト
 
; H.TIMIフックバックアップ用ワークエリア
H_TIMI_BACKUP:equ $C0AB  ; 5バイト

; H.TIMI垂直同期割込待ち用カウンタ
VSYNC_WAIT_CNT:equ $C0B0 ; 1バイト

; H.TIMI垂直同期割込待ち用カウンタ
; テキキャラ移動用カウンタ
;   1/60秒ごとにインクリメントされ30になったら
;   テキキャラが移動する
VSYNC_ENEMYMOVE_CNT:equ $C0B1 ; 1バイト

; プレイヤーの当たり判定情報
; 衝突時に30をセットし、1/60秒ごとにデクリメントする
; この変数の値が0でない場合は、プレイヤーの当たり判定は行わない
; この変数の第0ビットが1の場合は、プレイヤーの髪の毛の色を黄色に変更する
WK_PLAYERCOLLISION:equ $C0B2  ; 1バイト

; プレイヤーのライフポイント
; 0 - 16
WK_PLAYERLIFEPOINT:equ $C0B2  ; 1バイト

; 8バイト分用意する
; 8バイト目から減算していきそのバイトが0になったら
; ライフゲージには空白を出力する
WK_PLAYERLIFEGAUGE:equ $C0B3  ; 8バイト
WK_PLAYERLIFEGAUGE_CHARS:equ $C0BB  ; 8バイト

; FIREBALL移動制御用(同時に発射できるのは2個まで)
; 弾は4ドット単位で移動する
;
; +0 : 発射していれば1、そうでなければ0
; +1 : 弾のX座標(8-152)
; +2 : 弾のY座標(8-152) 
; +3 : 弾のX座標X(WK_PLAYERPOSXと同じ単位)
; +4 : 弾のY座標Y(WK_PLAYERPOSYと同じ単位)
; +5 : 移動量X(0:移動量なし 1:プラス移動 2:マイナス移動)
; +6 : 移動量Y(0:移動量なし 1:プラス移動 2:マイナス移動)
; +7 : 未使用
;
WK_FIREBALL_TRIG:equ $C0C3     ; スペースキー、もしくはジョイスティックAボタンの状態
WK_FIREBALL_DATA_TBL:equ $C0C4 ; 8バイト x 2 = 16バイト
WK_FIREBALLSPRATTR:equ $C0D4   ; 8バイト（スプライト2枚分）
WK_FIREBALL_INTTIME:equ $C0DC  ; 1バイト（1/60秒ごとにデクリメントされゼロになると弾を発射できる)
WK_FIREBALL_TIMER:equ 10       ; 定数（連続弾発射のためのインターバル値）
WK_FIREBALL_MAPX1:equ $C0DD    ; 1バイト（弾のMAP座標X）
WK_FIREBALL_MAPY1:equ $C0DE    ; 1バイト（弾のMAP座標Y）
WK_FIREBALL_MAPX2:equ $C0DF    ; 1バイト（弾のMAP座標X）
WK_FIREBALL_MAPY2:equ $C0E0    ; 1バイト（弾のMAP座標Y）

WK_ENEMY_POSX:equ $C0E1        ; 1バイト
WK_ENEMY_POSY:equ $C0E2        ; 1バイト

WK_HAVEKEY:equ $C0E3           ; 1バイト（0:カギを持っていない 1:カギを持っている）

WK_PLAYER_MAPPOSX: equ $C0E4   ; 1バイト
WK_PLAYER_MAPPOSY: equ $C0E5   ; 1バイト
WK_PLAYER_COLLISIONTILE: equ $C0E6   ; 1バイト

; スコア表示用
WK_SCORE:equ $C0E7  ; 8バイト(いちばん右端が10の位)
WK_SCORE_CHARS:equ $C0EF  ; 8バイト(いちばん右端が10の位)

;
; テキキャラポインタテーブル
; テキキャラ管理用1体分*100個ぶん
WK_ENEMY_PTR_TBL:equ $C100  ; (C100H - C1C7H) 2バイトx100体分=200バイト

; WK_ENEMY_PTR_TBLのポインタアドレスを保持する
WK_ENEMY_PTR_IDX:equ $C1C9  ; 2バイト

; テキキャラ管理用1体分(11byte x 100体ぶん)
;
; + 0  : テキキャラの種類(0:なし 1:ENEMY-TYPE1, 2:ENEMY-TYPE2, 3:GHOST)
;        ENEMY-TYPE1とENEMY-TYPE2はテキキャラ
;        GHOSTは味方キャラ
; + 1  : MAP論理X座標
; + 2  : MAP論理Y座標
; + 3  : 進行方向(1:上 3:右 5:下 7:左)
; + 4  : 進行距離(タイル数)移動ごとに1減らす(1-16)
; + 5  : 進行カウンタ(0:移動していない 0以外:移動している）
; + 6  : 当たり判定フラグ(0:床 1:壁ブロック 2:炎 3:緑ブロック)
; + 7  : 初期スポーン位置MAP論理X座標
; + 8  : 初期スポーン位置MAP論理Y座標
; + 9  : 上書き前のタイル番号
; + A  : 倒した時のスコア
;
WK_ENEMY_DATA_TBL:equ $C1CB; (C1CBH - C616H: 11x100 = 1100byte)

; VRAMデータ退避用
WK_VRAMTORAM:equ $C617   ; 0800Hバイト(C617H - CE17H)

; ビューポート表示データ(VRAM転送データ生成用)
; 最大 横24x縦24のデータを生成する
WK_MAP_VIEWAREA:equ $CE18 ; 576バイト(CE18H - D058H)

; MAPデータ格納用(タイルデータ格納エリア)
; 45 x 45 tile
WK_MAPAREA:equ $D059       ; 2025バイト(D059H - D842H)

; サウンドドライバ用ワークエリア
SOUNDDRV_H_TIMI_BACKUP:equ $E000     ; 5バイト
SOUNDDRV_STATE:equ $E005             ; 1バイト
SOUNDDRV_WK_MIXING_TONE:equ $E006    ; 1バイト
SOUNDDRV_WK_MIXING_NOISE:equ $E007   ; 1バイト
SOUNDDRV_BGMWK:equ $E008             ; 16バイト*3 = 48バイト
SOUNDDRV_DUMMYWK:equ $E038           ; 16バイト
SOUNDDRV_SFXWK:equ $E048             ; 16バイト*3 = 48バイト

;
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

    ;---------------------------------------
    ; テキキャラ処理ルーチンのアドレスを
    ; 定義する
    ; ※当テーブルの利用箇所はsprite.asm
    ;---------------------------------------
    ld ix, WK_ENEMY_MOVE_PROC
    ld de, MoveEnemiesLoop1End

    ; 方向=0
    ld (ix + 0), e
    ld (ix + 1), d

    ; 方向=1(上)
    ld hl, MoveEnemiesMoveUp
    ld (ix + 2), l
    ld (ix + 3), h

    ; 方向=2
    ld (ix + 4), e
    ld (ix + 5), d

    ; 方向=3(右)
    ld hl, MoveEnemiesMoveRight
    ld (ix + 6), l
    ld (ix + 7), h

    ; 方向=4
    ld (ix + 8), e
    ld (ix + 9), d

    ; 方向=5(下)
    ld hl, MoveEnemiesMoveDown
    ld (ix + 10), l
    ld (ix + 11), h

    ; 方向=6
    ld (ix + 12), e
    ld (ix + 13), d

    ; 方向=7(左)
    ld hl, MoveEnemiesMoveLeft
    ld (ix + 14), l
    ld (ix + 15), h

    ; 方向=8
    ld (ix + 16), e
    ld (ix + 17), d
    
    ;---------------------------------------
    ; VRAMチェック処理ルーチンのアドレスを
    ; 定義する
    ; ※当テーブルの利用箇所はsprite.asm
    ;---------------------------------------
    ld ix, WK_VRAM_CHECK_PROC
    ld de, CheckVRAM4x4End

    ; 方向=0
    ld (ix + 0), e
    ld (ix + 1), d

    ; 方向=1(上)
    ld hl, CheckVRAM4x4Up
    ld (ix + 2), l
    ld (ix + 3), h

    ; 方向=2
    ld (ix + 4), e
    ld (ix + 5), d

    ; 方向=3(右)
    ld hl, CheckVRAM4x4Right
    ld (ix + 6), l
    ld (ix + 7), h

    ; 方向=4
    ld (ix + 8), e
    ld (ix + 9), d

    ; 方向=5(下)
    ld hl, CheckVRAM4x4Down
    ld (ix + 10), l
    ld (ix + 11), h

    ; 方向=6
    ld (ix + 12), e
    ld (ix + 13), d

    ; 方向=7(左)
    ld hl, CheckVRAM4x4Left
    ld (ix + 14), l
    ld (ix + 15), h

    ; 方向=8
    ld (ix + 16), e
    ld (ix + 17), d
    
    ;---------------------------------------
    ; スクロール処理ルーチンのアドレスを
    ; 定義する
    ; ※当テーブルの利用箇所はsprite.asm
    ;---------------------------------------
    ld ix, WK_SCROLL_PROC
    ld de, UndoMoveEnd

    ; 方向=0
    ld (ix + 0), e
    ld (ix + 1), d

    ; 方向=1(上)
    ld hl, UndoMoveUpScroll
    ld (ix + 2), l
    ld (ix + 3), h

    ; 方向=2
    ld (ix + 4), e
    ld (ix + 5), d

    ; 方向=3(右)
    ld hl, UndoMoveRightScroll
    ld (ix + 6), l
    ld (ix + 7), h

    ; 方向=4
    ld (ix + 8), e
    ld (ix + 9), d

    ; 方向=5(下)
    ld hl, UndoMoveDownScroll
    ld (ix + 10), l
    ld (ix + 11), h

    ; 方向=6
    ld (ix + 12), e
    ld (ix + 13), d

    ; 方向=7(左)
    ld hl, UndoMoveLeftScroll
    ld (ix + 14), l
    ld (ix + 15), h

    ; 方向=8
    ld (ix + 16), e
    ld (ix + 17), d

