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

    ;
    ; プレイヤーのライフゲージを作成する
    ; 値が2だとLIFEGAUGEのFULL状態を画面に表示する
    ; 値が1だとLIFEGAUGEのHALF状態を画面に表示する
    ; 値が0だとLIFEGAUGEは画面には表示しない
    ; WK_PLAYERLIFEGAUGE+0 の値が0だとGAME OVER処理が行われる
    ;
    ld ix, WK_PLAYERLIFEGAUGE
    ld a, 2
    ld (ix + 7), a
    ld (ix + 6), a
    ld (ix + 5), a
    ld (ix + 4), a
    ld (ix + 3), a
    ld (ix + 2), a
    ld (ix + 1), a
    ld (ix + 0), a

    ; ライフゲージを表示する
    call DisplayLifeGauge
    
    ; ステータス表示（アイテム利用）を行う
    call DisplayFireballEnable

;-------------------------------------------------
; メインループ(割り込み処理でGameProcを呼び出す)
;-------------------------------------------------
    ld a, 0
    ld (VSYNC_WAIT_CNT), a
    ld (VSYNC_ENEMYMOVE_CNT), a

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

    ; 弾発射のインターバル値が0でなければデクリメントする
    ld a, (WK_FIREBALL_INTTIME)
    or 0
    jp z, GameProc_Init2

GameProc_Init1:
    
    dec a
    ld (WK_FIREBALL_INTTIME), a

GameProc_Init2:

    ; 当たり判定情報の変数に値が入っていなければ
    ; 当たり判定をチェックする
    ; 当たっている場合はAレジスタに1がセットされる

    ld a, (WK_PLAYERCOLLISION)
    cp 1
    jr nc, GameProcMoveEnemy

    call CheckEnemyCollision
    cp 1
    jr c, GameProcMoveEnemy

    ; 当たり判定情報に30をセットする
    ld a, 30
    ld (WK_PLAYERCOLLISION), a
    
GameProcMoveEnemy:
    
    call MoveEnemies

    call CreateViewPort
    call DisplayViewPort

    ;--------------------------------------------
    ; 入力を受け付ける
    ;--------------------------------------------
    ; キーボードバッファをクリアする
    ; これを呼び出さないとカーソルキーを正常に判定できない
    call KILBUF

    ; スペースキーが押されているか？
GameProc_IsSPACE:
    ld a, 0
    call GTTRIG
    cp $FF
    jr nz, GameProc_IsAbutton

    ld a, (WK_FIREBALL_TRIG)
    cp 2
    jr z, GameProc_IsCURSOR  ; 弾は2発までとする

    ; ファイアボール処理を呼び出す
    call Fireball
    
    jp GameProc_IsCURSOR

    ; ジョイスティック1のAボタンが押されているか？
GameProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jr nz, GameProc_IsCURSOR

    ld a, (WK_FIREBALL_TRIG)
    cp 2
    jr z, GameProc_IsCURSOR  ; 弾は2発までとする

    ; ファイアボール処理を呼び出す
    call Fireball
    
    ; ジョイスティックまたはカーソルキーの方向を取得
    ; GTSTCK呼び出し後、Aレジスタに方向がセットされる

GameProc_IsCURSOR:
    ld a, 0
    call GTSTCK
    or 0
    ;--------------------------------------------
    ; カーソルキーが押されたら移動処理を呼ぶ
    ;--------------------------------------------
    ; Aレジスタに0をOR演算する
    ; カーソルキーが押されるとAレジスタの
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
    jr z, GameProc_PlayerMoveEnd

GameProc_PlayerMove:

    ; 斜め移動は許可しない
    cp 2
    jr z, GameProc_PlayerMoveEnd
    cp 4
    jr z, GameProc_PlayerMoveEnd
    cp 6
    jr z, GameProc_PlayerMoveEnd
    cp 8
    jr z, GameProc_PlayerMoveEnd

    ;--------------------------------------------
    ; プレイヤーの移動
    ; 移動は8ドット単位で移動する
    ; X座標は1-29まで
    ; Y座標は1-21まで
    ; の範囲だけ移動可能とする
    ;--------------------------------------------
    ld (WK_PLAYERDIST), a

    call MovePlayer

    ; ステータス表示（アイテム利用）を行う
    call DisplayFireballEnable

GameProc_PlayerMoveEnd:

    ; ワーク用スプライトアトリビュートテーブルを
    ; 作成する
    ld hl, SPRDISTPTN_TBL
    ld b, 0
    ld a, (WK_PLAYERDIST)
    ld c, a
    
    add hl, bc
    ld ix, hl

    ld a, (WK_PLAYERCOLLISION)
    cp 0
    jr z, SpriteColorNormal  ; 当たり判定情報が0なら何もせず終了

    ; 衝突時のSFXを鳴らす
    ; (WK_PLAYERCOLLISIONの値が30の場合のみ)
    cp 30
    jr nz, SoundSFXEnd

    ld hl, SFX_00
    call SOUNDDRV_SFXPLAY

    ; ライフゲージをデクリメントする
    call DecLifeGauge

    ; ライフゲージを表示する
    call DisplayLifeGauge

SoundSFXEnd:

    ; 当たり判定情報の第0ビットが1の場合は黄色にする（点滅させる）
    ; 当たり判定情報の第0ビットが0の場合は通常にする（点滅させる）
    and 00000001B
    call z, SpriteColorNormal

SpriteColorWarn:

    ld a, $0B
    ld (WK_PLAYERSPRCLR1), a ; スプライトの表示色

    jr SpriteDisplay

SpriteColorNormal:

    ld a, $0D 
    ld (WK_PLAYERSPRCLR1), a ; スプライトの表示色

SpriteDisplay:

    call CreateWorkSpriteAttr

    ; スプライトを表示する
    ld de, $1B00
    ld bc, 8 ; スプライト2枚分を表示
    call PutSprite

    ld a, (WK_PLAYERCOLLISION)
    cp 1
    jr c, SpriteDisplayEnd

    dec a ; 当たり判定情報をデクリメントする
    ld (WK_PLAYERCOLLISION), a

    ; ライフゲージがなくなったらGAME OVER画面を呼び出す
    ;ld a, (WK_PLAYERLIFEGAUGE+0)
    ;cp 1
    ;jp c, GameOverProc
    
SpriteDisplayEnd:

    ; WK_FIREBALL_TRIGの値が0でなければ
    ; ファイアボール処理を呼び出す
    ld a, (WK_FIREBALL_TRIG)
    or 0
    jr z, GameProcEnd
    ; 衝突判定中は弾の動作は止める
    ld a, (WK_PLAYERCOLLISION)
    or 0
    jr nz, GameProcEnd

    call MoveFireball

GameProcEnd:

    ret  
    
;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "interval.asm"
include "psgdriver.asm"
include "common.asm"
include "vram.asm"
include "sprite.asm"
include "enemy.asm"
include "status.asm"
include "gameover.asm"
include "map.asm"
include "data_sprite.asm"
include "pcg_graphic2.asm"
include "data_pcg.asm"
include "data_map.asm"
include "data_enemy.asm"
include "data_psg.asm"
include "debugprn.asm"
