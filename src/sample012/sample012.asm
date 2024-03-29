;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize.asm"

;--------------------------------------------
; 乱数のSEED値の初期化
;--------------------------------------------
    call InitRandom

;--------------------------------------------
; キャラクタパターンとカラーテーブルを
; 作成する
;--------------------------------------------
    call CreateCharacterPattern

;--------------------------------------------
; スプライトパターンを作成する
;--------------------------------------------
    call CreateSpritePattern

;--------------------------------------------
; マップデータを生成する
;--------------------------------------------
    call CreateMapArea

    ld a, 0
    ld (WK_FLAME_ANIME_COUNT), a
    ld (WK_FLAME_PATTERN), a

;--------------------------------------------
; テキキャラデータを生成する
;--------------------------------------------
    ld b, 100
    ld hl, WK_ENEMY_PTR_TBL
    ld de, 0x0000 
EnemyPtrTblInitLoop:
    ld (hl), de ; アドレスの値を初期化する
    inc hl      ; アドレスを2バイト進める
    inc hl
    djnz EnemyPtrTblInitLoop

    ld a, 127
    ld (WK_RANDOM_VALUE), a
    call InitializeEnemyDatas ; テキキャラデータ生成メイン

    ld a, 0
    ld (WK_VIEWPORTPOSX), a ; ビューポート左上X座標
    ld a, 0
    ld (WK_VIEWPORTPOSY), a ; ビューポート左上Y座標

;--------------------------------------------
; マップデータ（初期画面）のデータを
; VRAM(1800H-1AFFH)に書き込む
;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_DEFAULT
    ld bc, 768
    call LDIRVM

;--------------------------------------------
; ビューポートにマップ情報を表示する
;--------------------------------------------
    call CreateViewPort
    call DisplayViewPort

    ld a, 3
    ld (WK_PLAYERPOSX), a    ; プレイヤーのX座標の初期化
    ld (WK_PLAYERPOSXOLD), a ; プレイヤーのX座標の初期化
    ld (WK_PLAYERPOSY), a    ; プレイヤーのY座標の初期化
    ld (WK_PLAYERPOSYOLD), a ; プレイヤーのX座標の初期化

    ld a, 5
    ld (WK_PLAYERDIST), a    ; プレイヤーの向きの初期化（下向き）
    ld (WK_PLAYERDISTOLD), a ; プレイヤーの向きの初期化（下向き）

    ld a, $0D
    ld (WK_PLAYERSPRCLR1), a ; スプライトの表示色

    ld a, $0F
    ld (WK_PLAYERSPRCLR2), a ; スプライトの表示色

    ; 現在の位置をOLD変数にセット
    ld bc, 8
    ld de, WK_PLAYERMOVE_TBL
    ld hl, PLAYERMOVE_TBL
    ldir

    ; プレイヤーのジョイスティック方向にあわせた
    ; スプライトを初期表示する
    ld a, $02

    ld ix, SPRDISTPTN_TBL + 2
    call CreateWorkSpriteAttr

    ld de, $1B00
    ld bc, 8
    call PutSprite

;-------------------------------------------------
; メインループ(割り込み処理でGameProcを呼び出す)
;-------------------------------------------------
    ld a, 0
    ld (VSYNC_WAIT_CNT), a

    call INIT_H_TIMI_HANDLER

;--------------------------------------------
; BGM演奏開始
;--------------------------------------------
    ld hl, BGM_00
    call SOUNDDRV_BGMPLAY

MainLoop:
    ; VSYNC_WAIT_FLGの初期化
    ;   この値は以下の制御を行うために使用する：
    ;   - メインロジック開始時に 0 に設定
    ;   - H.TIMI割り込み処理の中でデクリメント (1/60秒ごとに呼び出し)
    ;   - メインロジックの最後に、キャリーがONになるまで待機
    ld a, 1
    ld (VSYNC_WAIT_CNT), a

    ; ゲーム処理呼び出し
    call GameProc

VSYNC_Wait:
    ; 垂直帰線待ち
    ld a, (VSYNC_WAIT_CNT)
    or a
    jr nz,VSYNC_Wait

    jr MainLoop

;--------------------------------------------
; 割り込み処理開始
;--------------------------------------------
GameProc:

    call MoveEnemies

    call CreateViewPort
    call DisplayViewPort

    ;call DelayLoop

    ;--------------------------------------------
    ; 入力を受け付ける
    ;--------------------------------------------
    ; キーボードバッファをクリアする
    ; これを呼び出さないとカーソルキーを正常に判定できない
    call KILBUF

    ; ジョイスティックまたはカーソルキーの方向を取得
    ; GTSTCK呼び出し後、Aレジスタに方向がセットされる

GameProc_IsCURSOR:
    ld a, 0
    call GTSTCK
    or 0
    ;--------------------------------------------
    ; ジョイスティックが押されたら移動処理を呼ぶ
    ;--------------------------------------------
    ; Aレジスタに0をOR演算する
    ; ジョイスティックが押されるとAレジスタの
    ; 値には0より大きい値が入るためOR演算の結果はゼロにならない
    or 0
    jr nz, GameProc_PlayerMove

GameProc_IsJOYSTICK:
    ld a, 1
    call GTSTCK
    or 0
    ;--------------------------------------------
    ; ジョイスティックが押されたら移動処理を呼ぶ
    ;--------------------------------------------
    ; Aレジスタに0をOR演算する
    ; ジョイスティックが押されるとAレジスタの
    ; 値には0より大きい値が入るためOR演算の結果はゼロにならない
    or 0
    jr z, GameProcEnd

GameProc_PlayerMove:

    ; 斜め移動は許可しない
    cp 2
    jr z, GameProcEnd
    cp 4
    jr z, GameProcEnd
    cp 6
    jr z, GameProcEnd
    cp 8
    jr z, GameProcEnd

    ;--------------------------------------------
    ; プレイヤーの移動
    ; 移動は8ドット単位で移動する
    ; X座標は1-29まで
    ; Y座標は1-21まで
    ; の範囲だけ移動可能とする
    ;--------------------------------------------
    ld (WK_PLAYERDIST), a

    call MovePlayer

    ; call DebugPrint

GameProcEnd:

    ret ; GameProc処理終了

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "interval.asm"
include "psgdriver.asm"
include "common.asm"
include "vram.asm"
include "sprite.asm"
include "enemy.asm"
include "map.asm"
include "data_sprite.asm"
include "pcg_graphic2.asm"
include "data_pcg.asm"
include "data_map.asm"
include "data_enemy.asm"
include "debugprn.asm"
include "data_psg.asm"
