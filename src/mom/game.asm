GameMainProc:

    ;----------------------------------------
    ; WK_GAMESTATUS_INTTIMEの値が0でなければ
    ; 何もせず、画面をスペースで塗りつぶす
    ;----------------------------------------
    ld a, (WK_GAMESTATUS_INTTIME)
    or a
    jp nz, SkipLifeUnder4

    ;----------------------------------------
    ; ゲームスタートメッセージを表示する
    ;----------------------------------------
    ld a, (WK_GAME_STARTFLG)
    or a
    jr z, SkipGameStartMessage

    xor a
    ld (WK_GAME_STARTFLG), a

    ld a, 3
    ld (WK_GAMESTATUS), a
    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a

    ld a, 2
    ld (WK_DIALOG_TYPE), a

    ld a, ($002C)
    or a
    jr z, DispGameStartJp

    ld hl, MESSAGE_DIALOG_MESSAGE_GAME_START_EN
    jr DispGameStartMsg

DispGameStartJp:

    ld hl, MESSAGE_DIALOG_MESSAGE_GAME_START_JP

DispGameStartMsg:

    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl

    jp GameMainProcEnd

SkipGameStartMessage:

    xor a
    ld (WK_DIALOG_INITEND), a

    ; ゲームオーバーの判定はこのタイミングで行う
    ld a, (WK_PLAYERLIFEVAL)
    or a
    jr nz, GameMainProcCheckNotGameOver
    ; jr GameMainProcCheckNotGameOver

    ; プレイヤーのライフが0であればゲームオーバー
    ld a, 4
    ld (WK_GAMESTATUS), a

    ld a, 10 ; 30/60秒をINTERVALにセット
    ld (WK_GAMESTATUS_INTTIME), a

    jp NextHTIMIHook

GameMainProcCheckNotGameOver:

    ;----------------------------------------
    ; テキキャラの移動処理を行なう
    ;----------------------------------------
    call MoveEnemy

    ;----------------------------------------
    ; 衝突判定処理を行う
    ;----------------------------------------
    call PlayerCollision
    ld a, (WK_BOX_PICKUP)
    or a
    jp nz, GameMainProcEnd
    call SwordCollision

GameMainProcKeyInput:

    ;----------------------------------------
    ; キー入力呼び出し
    ;----------------------------------------
    call KeyInputProc

    ; Xキー、またはBボタンが押されたらダイアログ表示
    ld a, (WK_TRIGGERB)
    cp $02
    jp z, GameMainProcChangeDialogMode
    cp $12
    jp z, GameMainProcChangeDialogMode

    jp GameMainProcNormalMode

GameMainProcChangeDialogMode:

    ; ゲームモードをダイアログ表示モードに切り替える
    xor a
    ld (WK_TRIGGERA), a
    ld (WK_TRIGGERB), a

    ld a, 1
    ld (WK_DIALOG_TYPE), a

    ld a, 3
    ld (WK_GAMESTATUS), a

    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a

    ; 矢印アイコンの位置を初期化する
    xor a
    ld (WK_DOWNARROWICON_POS), a
    ld (WK_RIGHTARROWICON_POS), a
    ld (WK_ITEMLISTPOS), a

    ; スプライトを消す
    call ClearSprite

    ; 効果音を鳴らす
    ld a,$0E ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    jp GameMainProcEnd

GameMainProcNormalMode:
    
    ;----------------------------------------
    ; プレイヤー攻撃処理
    ;----------------------------------------

    ld a, (WK_TRIGGERA)

    ; TRIGGERAの押下直後であれば剣を振る
    ; 剣を戻す
    cp 1
    jp z, GameMainProcNormalModeSwordOn

    cp $11
    jp z, GameMainProcNormalModeSwordOn

    jp GameMainProcNormalModeSkipSwordOn

GameMainProcNormalModeSwordOn:

    ; 水没中は剣を振れない
    ld a, (WK_IN_WATER_FLG)
    or a
    jp nz, GameMainProcNormalModeSkipSwordOff

    ; 剣を振っている期間内であれば何もしない
    ld a, (WK_SWORDACTION_COUNT)
    or a
    jp nz, GameMainProcNormalModeSkipSwordOn

    ; 剣を装備していない状態であれば何もしない
    ld a, (WK_EQUIP_STR)
    or a
    jp z, GameMainProcNormalModeSkipSwordOn

    ; 剣の振り直しインターバル値がセットされているのであれば
    ; なにもしない
    ld a, (WK_SWORD_REUSE_COUNT)
    or a
    jp nz, GameMainProcNormalModeSkipSwordOn

    ; 剣を振る
    ld a, 10
    ld (WK_SWORDACTION_COUNT), a

    ; 効果音を鳴らす

    ; 元の音を消す
    ld a,1 ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    jp GameMainProcNormalModeSkipSwordOn

GameMainProcNormalModeSkipSwordOff:

    ; 剣を戻す（水没中の処理）
    xor a
    ld (WK_SWORDACTION_COUNT), a
    ld (WK_SWORD_REUSE_COUNT), a

GameMainProcNormalModeSkipSwordOn:

    ;----------------------------------------
    ; PITの出入りを行う
    ; プレイヤーの位置が下り階段に一致:
    ;   WK_PIT_MAP_ADDRにセットされている
    ;   マップ情報を読み込み画面情報を作り直す
    ; プレイヤーの位置が上り階段に一致:
    ;   ChangeMapViewを呼び出し
    ;   WK_PIT_ENTER_POSX,POSYの座標に
    ;   プレイヤーを表示する
    ;----------------------------------------
    call PitProc
    ld a, (WK_MAPCHANGE_COUNT)
    cp 2
    jp z, NextHTIMIHook ; 画面が切り替わった

    ;----------------------------------------
    ; プレイヤー移動処理
    ;----------------------------------------
    call PlayerMove
    ld a, (WK_MAPCHANGE_COUNT)
    cp 2
    jp z, NextHTIMIHook ; 画面が切り替わった

    ;----------------------------------------
    ; ミッション(レベルアップ)判定を行う
    ;----------------------------------------
    call BattleDispLevelUp

    ;----------------------------------------
    ; ステータス表示
    ;----------------------------------------
    call BattleDispEnemyStatus
    ld a, (WK_GAMECLEAR)
    or a
    jr nz, GameMainProcGameClear
    call BattleDispLifeGuage

    ;----------------------------------------
    ; プレイヤー衝突時の点滅処理
    ;----------------------------------------
    call PlayerCollisionEffect

    ;----------------------------------------
    ; 仮想スプライトアトリビュートテーブルを
    ; 更新する
    ;----------------------------------------
    call SetVirtAttrTable

    ;----------------------------------------
    ; 仮想スプライトアトリビュートテーブルを
    ; シャッフルする
    ;----------------------------------------
    call ShuffleSprite

GameMainProcSkipSpriteRedraw:

    jp GameMainProcEnd

GameMainProcGameClear:
    
    ld hl, WK_VIRT_PTNNAMETBL
    ld bc, 768
    ld a, $2B
    call MemFil

GameMainProcEnd:

    ld a, (WK_PLAYERLIFEVAL)
    cp 4
    jr nc, SkipLifeUnder4

    ld a, (WK_BGCOLOR_CHGFLG)
    cp 1
    jr nc, SkipLifeUnder4

    ; 背景を赤にする
    ld a, 1
    ld (WK_BGCOLOR_CHGFLG), a

SkipLifeUnder4:

    jp NextHTIMIHook

;----------------------------------------
; 画面初期処理
; ゲームモード初期表示時は
; この処理をCALLすること
;----------------------------------------
GameMainProcInit:

    ;--------------------------------------------
    ; PCGパターンを作成する
    ;--------------------------------------------
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPattern

    ;--------------------------------------------
    ; マップ情報と仮想アトリビュートテーブルを
    ; 作成する
    ;--------------------------------------------

    xor a
    ld (WK_TIME10), a

    ; RANDOM SEED値の更新を行う
    call InitRandom

    ld a, 5
    ld (WK_MAPCHANGE_COUNT), a

    ; これが本物
    ld a, 0
    ld (WK_MAPPOSX), a
    ld a, 0
    ld (WK_MAPPOSY), a

    ;-------------------------------------------------
    ; プレイヤーの初期位置
    ;-------------------------------------------------
    ld a, 3 * 8
    ld (WK_PLAYERPOSX), a
    ld a, 5 * 8
    ld (WK_PLAYERPOSY), a
    ld a, 3
    ld (WK_CHECKPOSX), a
    ld a, 5
    ld (WK_CHECKPOSY), a

    ; CONTINUEであれば
    ; ミッションステータスや所持アイテムスロットの
    ; 初期化は行わない
    ld a, (WK_GAME_STARTFLG)
    or a
    jp z, GameMainProcInitContinue

    ;-------------------------------------------------
    ; ミッションステータス値の初期化
    ;-------------------------------------------------
    xor a
    ld (WK_MISSION_STATUSVAL), a

    ;-------------------------------------------------
    ; 所持アイテムスロットを初期化する
    ;-------------------------------------------------
    xor a
    ld hl, WK_STRITEMSLOT ; 攻撃アイテムスロット
    ld bc, 4
    call MemFil

    ; TEST CODE: 最初からスロットにセットしておく
    ; ld hl, WK_STRITEMSLOT ; 攻撃アイテムスロット
    ; ld a, 4
    ; ld (hl), a
    ; inc hl
    ; inc a
    ; ld (hl), a
    ; inc hl
    ; inc a
    ; ld (hl), a
    ; inc hl
    ; inc a
    ; ld (hl), a

    xor a
    ld hl, WK_DEFITEMSLOT ; 防御アイテムスロット
    ld bc, 4
    call MemFil

    ; TEST CODE: 最初からスロットにセットしておく
    ; ld hl, WK_DEFITEMSLOT ; 防具アイテムスロット
    ; ld a, 4
    ; ld (hl), a
    ; inc hl
    ; ld a, 2
    ; ld (hl), a

    xor a
    ld hl, WK_RINGITEMSLOT ; 装飾品アイテムスロット
    ld bc, 4
    call MemFil

    ; TEST CODE
    ; ld hl, WK_RINGITEMSLOT
    ; ld a, 4
    ; ld (hl), a
    ; inc hl
    ; ld a, 2
    ; ld (hl), a
    ; ld a, 4
    ; ld (hl), a

    xor a
    ld hl, WK_TOOLITEMSLOT ; 道具アイテムスロット
    ld bc, 20
    call MemFil

    ; TEST CODE: 最初から道具スロットにセットしておく
    ld hl, WK_TOOLITEMSLOT
    ld a, 1 ; HEART+1
    ld (hl), a

    inc hl
    ld a, 1 ; HEART+1
    ld (hl), a

    ; inc hl
    ; ld a, 5 ; FULL RECOVER
    ; ld (hl), a

    ; inc hl
    ; ld a, 2 ; FULL RECOVER
    ; ld (hl), a

    ; inc hl
    ; ld a, 2 ; FULL RECOVER
    ; ld (hl), a

    ; inc hl
    ; ld a, 2 ; FULL RECOVER
    ; ld (hl), a

    ; inc hl
    ; ld a, 2 ; FULL RECOVER
    ; ld (hl), a

    inc hl
    ld a, 4 ; 黄色鍵
    ld (hl), a

    ; inc hl
    ; ld a, 5 ; 青色鍵
    ; ld (hl), a

    ; inc hl
    ; ld a, 5 ; 青色鍵
    ; ld (hl), a

    ; inc hl
    ; ld a, 5 ; 青色鍵
    ; ld (hl), a

    ; inc hl
    ; ld a, 7 ; ロウソク
    ; ld (hl), a

    ; inc hl
    ; ld a, 7 ; ロウソク
    ; ld (hl), a

    ; inc hl
    ; ld a, 7 ; ロウソク
    ; ld (hl), a

    ; inc hl
    ; ld a, 7 ; ロウソク
    ; ld (hl), a

    ; inc hl
    ; ld a, 7 ; ロウソク
    ; ld (hl), a

    ; inc hl
    ; ld a, 8 ; PASSPORT
    ; ld (hl), a

    ; inc hl
    ; ld a, 9 ; JUNK
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a
    ; inc hl
    ; ld (hl), a

    ; DOOR情報を初期化
    call InitializeDoorTable

    ; 水没フラグをクリア
    xor a
    ld (WK_IN_WATER_FLG), a

    ;-------------------------------------------------
    ; プレイヤーの所持アイテムの初期化
    ;-------------------------------------------------
    xor a
    ld (WK_EQUIP_STR), a
    ld (WK_EQUIP_DEF), a
    ld (WK_EQUIP_RING), a
    ld (WK_EQUIP_ADJSTR), a
    ld (WK_EQUIP_ADJDEF), a

    ;-------------------------------------------------
    ; プレイヤーのライフ最大値
    ; 初期値は14
    ;-------------------------------------------------
    ld a, 14
    ld (WK_PLAYERLIFEMAX), a
    ld a, 14
    ld (WK_PLAYERLIFEVAL), a

    jr GameMainProcInitEnd

GameMainProcInitContinue:

    ld a, (WK_PLAYERLIFEMAX)
    ld (WK_PLAYERLIFEVAL), a

    ; コンティニュー時は装備品は全部外す
    xor a
    ld (WK_EQUIP_STR), a
    ld (WK_EQUIP_DEF), a
    ld (WK_EQUIP_RING), a

    ; コンティニュー時はTORCH関連を初期化する
    ld (WK_TORCH_TBL), a
    ld (WK_TORCH_TBL+1), a
    ld (WK_TORCH_TBL+2), a
    ld (WK_TORCH_TBL+3), a
    ld (WK_TORCH_TIMER), a
    ld (WK_TORCH_TIMER+1), a
    ld (WK_TORCH_USED), a
    ld a, 1
    ld (WK_PEEPHOLE), a

GameMainProcInitEnd:

    call GameMainProcInitPutSprite

    ld a, 0
    ld (WK_PLAYERLIFESUM), a
    call AddLifeGuage

    ; プレイヤーの向きを初期化する
    ld a, 5
    ld (WK_PLAYERDIST), a
    ld (WK_PLAYERDISTOLD), a

    ld a, 2
    ld (WK_GAMESTATUS), a

    ; インターバルタイマ値を10にする
    ld a, 30
    ld (WK_GAMESTATUS_INTTIME), a

    ret

GameMainProcInitPutSprite:
    ;-------------------------------------------------
    ; プレイヤーの保持アイテムのスプライト情報
    ; ゲーム開始直後は何も持っていない
    ;-------------------------------------------------
    ld hl, WK_SPRITE_MOVETBL
    ld bc, 12

    ; プレイヤーのスプライト情報を設定する
    ld a, $FE
    ld (hl), a  ; + 0

    inc hl
    ld a, 209
    ld (hl), a ; + 1 SPRITE#0 Y座標

    ld a, (WK_PLAYERPOSX)
    inc hl
    ld (hl), a ; + 2SPRITE#1 X座標

    ld a, 100
    inc hl
    ld (hl), a  ; + 3 パターン番号

    xor a
    inc hl      ;
    ld (hl), a  ; + 4 カラー（ゲーム開始時点では透明）

    add hl, bc  ; + 5 - +16

    ;-------------------------------------------------
    ; プレイヤー1枚目のスプライト情報
    ;-------------------------------------------------

    ld a, $FF
    ld (hl), a ; +16

    inc hl
    ld a, (WK_PLAYERPOSY)
    ld (hl), a ; +17 SPRITE#0 Y座標

    inc hl
    ld a, (WK_PLAYERPOSX)
    ld (hl), a ; +18 SPRITE#1 X座標

    inc hl
    ld a, 32
    ld (hl), a ; +19 パターン番号

    inc hl
    ld a, (WK_PLAYERSPRCLR1)
    ld (hl), a ; +20 カラー

    inc hl     ; +21 移動方向
    inc hl     ; +22 X移動量
    inc hl     ; +23 Y移動量
    inc hl     ; +24 攻撃力
    ld a, 0    ; 初期値は STR=0
    ld (hl), a
    inc hl     ; +25 防御力
    ld a, 2    ; 初期値は DEF=2
    ld (hl), a

    inc hl     ; +26
    inc hl     ; +27
    inc hl     ; +28
    inc hl     ; +29
    inc hl     ; +30
    inc hl     ; +31
    inc hl     ; +32
    
    ;-------------------------------------------------
    ; プレイヤー2枚目のスプライト情報
    ;-------------------------------------------------

    ld a, $FF
    ld (hl), a ; +32

    inc hl
    ld a, (WK_PLAYERPOSY)
    ld (hl), a ; +33 SPRITE#0 Y座標

    inc hl
    ld a, (WK_PLAYERPOSX)
    ld (hl), a ; +34 SPRITE#1 X座標

    inc hl
    ld a, 36
    ld (hl), a ; +35 パターン番号

    inc hl
    ld a, (WK_PLAYERSPRCLR2)
    ld (hl), a ; +36 カラー

    ret
