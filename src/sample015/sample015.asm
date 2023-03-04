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
; テレポート位置をメモリに展開する
;--------------------------------------------
    ld hl, TELEPORT_DATA
    ld de, WK_TELEPORT_DATA_TBL
    ld bc, 112 ; 112バイトぶんをメモリに展開する
    ldir

    ld a, 0
    ld (WK_TELEPORT_INTTIME), a

;--------------------------------------------
; マップデータ（初期画面）のデータを
; VRAM(1800H-1AFFH)に書き込む
;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_DEFAULT
    ld bc, 768
    call LDIRVM

;--------------------------------------------
; ゴールタイルをセットする
;--------------------------------------------
    ld de, 111
    ld hl, WK_MAPAREA
    add hl, de
    ld a, 4   ; ゴールのドアタイルは#4
    ld (hl), a

    ; ゲームステータスを初期化する
    ; タイトル画面を表示する
    ld a, 0
    ld (WK_GAMESTATUS), a
    ld (WK_GAMESTATUS_INTTIME), a

;-------------------------------------------------
; メインループ(割り込み処理でGameProcを呼び出す)
;-------------------------------------------------
    ld a, 0
    ld (VSYNC_WAIT_CNT), a
    ld (VSYNC_ENEMYMOVE_CNT), a

    call INIT_H_TIMI_HANDLER

MainLoop:
    ; VSYNC_WAIT_FLGの初期化
    ;   この値は以下の制御を行うために使用する：
    ;   - メインロジック開始時に 0 に設定
    ;   - H.TIMI割り込み処理の中でデクリメント (1/60秒ごとに呼び出し)
    ;   - メインロジックの最後に、キャリーがONになるまで待機
    ld a, 1
    ld (VSYNC_WAIT_CNT), a

    ; 処理呼び出し
    ld a, (WK_GAMESTATUS)
    cp 1
    jp c, TitleDisplayProc ; タイトル画面

    cp 1
    jp z, OpeningProc      ; オープニングアニメーション

    cp 2
    jp z, GameProc         ; ゲームメイン処理

    cp 3
    jp z, GameOverProc     ; ゲームオーバー処理

    cp 4
    jp z, GameClearProc    ; ゲームクリア画面

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

    ; ライフゲージがなくなったらGAME OVER画面を呼び出す
    ld a, (WK_PLAYERLIFEGAUGE+0)
    cp 1
    jp nc, GameProc_Init3

    ld a, 3
    ld (WK_GAMESTATUS), a
    ld a, 180
    ld (WK_GAMESTATUS_INTTIME), a ; 180/60秒後にゲームオーバー画面に遷移する

    ; 効果音を鳴らす
    ld hl, SFX_06
    call SOUNDDRV_SFXPLAY

    jp GameProcEnd
    
GameProc_Init3:
    ; テレポート位置か判定する
    call CheckWarpZone

    ; テキとの衝突を判定する
    ; ただしテレポート期間中は当たり判定は行わない
    ld a, (WK_TELEPORT_INTTIME)
    or 0
    jr nz, GameProcMoveEnemy

    call CheckEnemyCollision
    cp 1
    jr c, GameProcMoveEnemy

    ; 当たり判定情報に15をセットする
    ld a, 15
    ld (WK_PLAYERCOLLISION), a
    
GameProcMoveEnemy:
    
    call MoveEnemies

    call CreateViewPort
    call DisplayViewPort

    ; テレポート中は動かせないようにする
    ; テレポート中は入力を受け付けない
    ld a, (WK_TELEPORT_INTTIME)
    or 0
    jr nz, GameProc_PlayerMoveEnd

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

    ; ToDo: 弾は2発までとしたいが
    ; 2発打つと変になるのでとりあえず1発までとしておく
    ld a, (WK_FIREBALL_TRIG)
    cp 1
    jr z, GameProc_IsCURSOR

    ; ファイアボール処理を呼び出す
    call Fireball
    
    jp GameProcEnd

    ; ジョイスティック1のAボタンが押されているか？
GameProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jr nz, GameProc_IsCURSOR

    ; ToDo: 弾は2発までとしたいが
    ; 2発打つと変になるのでとりあえず1発までとしておく
    ld a, (WK_FIREBALL_TRIG)
    cp 1
    jr z, GameProc_IsCURSOR

    ; ファイアボール処理を呼び出す
    call Fireball
    
    jp GameProcEnd

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

    ; テキキャラのセリフを表示する
    call DisplayMessage

GameProc_PlayerMoveEnd:

    ; PEACEFULモードであれば
    ; PEACEFULカウンタをデクリメントする
    ; 値が1になったらライフに1を加算する
    ld a, (WK_PEACEFUL_COUNT)
    or 0
    jp z, GameProc_PeacefulEnd

    dec a
    ld (WK_PEACEFUL_COUNT), a

    cp 1
    jp nz, GameProc_PeacefulEnd

    ; ライフを加算する
    call IncLifeGauge

    ; PEACEFULカウントを初期化する
    ld a, 0
    ld (WK_PEACEFUL_COUNT), a

GameProc_PeacefulEnd:

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
    ; (WK_PLAYERCOLLISIONの値が15の場合のみ)
    cp 15
    jr nz, SoundSFXEnd

    ld hl, SFX_00
    call SOUNDDRV_SFXPLAY

    ; EPISODEカウントが2以上であれば
    ; テキキャラから受けるダメージを倍にする
    ld a, (WK_EPISODE_COUNT)
    cp 2
    jp c, GameProc_Damage1

    ; ライフゲージをデクリメントする
    call DecLifeGauge

GameProc_Damage1:

    ; ライフゲージをデクリメントする
    call DecLifeGauge

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

    ; ステータス表示（アイテム利用）を行う
    call DisplayFireballEnable

    ; ステータス表示（カギ保有状態）を行う
    call DisplayHaveKey

    ; エピソードタイトル表示を行う
    call DisplayEpisodeTitle

    ; ライフゲージを表示する
    call DisplayLifeGauge

    ; アイテムとの重なりをチェックする
    call GetCollisionItem

    jp VSYNC_Wait
    
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
include "gameclear.asm"
include "title.asm"
include "opening.asm"
include "map.asm"
include "data_sprite.asm"
include "pcg_graphic2.asm"
include "data_pcg.asm"
include "data_map.asm"
include "data_enemy.asm"
include "data_psg.asm"
include "messages.asm"
include "data_messages.asm"
include "debugprn.asm"
