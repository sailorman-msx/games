;--------------------------------------------
; player.asm
; キー入力情報やトリガ情報をもとに
; プレイヤーのアクションを制御する
;--------------------------------------------
PlayerMove:

    push af
    push bc
    push de
    push hl

    ; 移動禁止フラグをOFFにする
    ld a, CONST_NOTMOVE_OFF
    ld (WK_NOTMOVE_FLG), a

PlayerMoveCheckWater:

    ; 周囲の情報を取得する
    call GetPlayerSurroundings
    
    ; WK_VRAM4X4_TBL+5と+6の値が74H(WATER TILE)であれば
    ; WK_IN_WATER_FLGに1をセットする
    ; そうでなければ0をセットする

    ld hl, WK_VRAM4X4_TBL + 5 
    ld a, (hl)
    cp $74 
    jr z, PlayerMoveCheckWaterIsWater
    cp $99
    jr z, PlayerMoveCheckWaterIsWater

    ld hl, WK_VRAM4X4_TBL + 6 
    ld a, (hl)
    cp $74 
    jr z, PlayerMoveCheckWaterIsWater
    cp $99
    jr z, PlayerMoveCheckWaterIsWater

    jr PlayerMoveCheckWaterNotWater

PlayerMoveCheckWaterIsWater:

    ; 前回フラグが0であればスプライトパターンを更新する
    ld a, (WK_IN_WATER_FLG)
    cp 1
    jr c, PlayerMoveCheckWaterSetFlg1

    call ChangeSpritePatternWater

PlayerMoveCheckWaterSetFlg1:

    ld a, 1
    ld (WK_IN_WATER_FLG), a

    jr PlayerMoveCheckWaterCheckEnd

PlayerMoveCheckWaterNotWater:

    ; 前回フラグが1であればスプライトパターンを元に戻す
    ld a, (WK_IN_WATER_FLG)
    cp 1
    jr nz, PlayerMoveCheckWaterCheckEnd

    call ChangeSpritePatternDefault

PlayerMoveCheckWaterNotWaterEnd:

    xor a
    ld (WK_IN_WATER_FLG), a

PlayerMoveCheckWaterCheckEnd:

    ld a, (WK_PLAYERPOSX)
    ld (WK_VALUE01), a
    ld a, (WK_PLAYERPOSY)
    ld (WK_VALUE02), a
    ld b, 0
    ld c, 0

    ld a, (WK_PLAYERDIST)
    or a
    jr nz, PlayerMoveKeyIn

    ; 方向キーが押されていない場合でも
    ; 剣のスプライト表示処理は行う
    jp PlayerMovePutSpriteItem

PlayerMoveKeyIn:

    ; プレイヤーの方向を取得する

    ; 前回の方向と異なる方向を選択されている場合は
    ; 移動は行わず方向だけ変える
    ld a, (WK_PLAYERDISTOLD)
    ld b, a
    ld a, (WK_PLAYERDIST)
    cp b
    jr z, PlayerMoveCheckCondition

    ld a, CONST_NOTMOVE_ON
    ld (WK_NOTMOVE_FLG), a

PlayerMoveCheckCondition:

    ; 今回の方向をOLD変数にセットする
    ld a, (WK_PLAYERDIST)
    ld (WK_PLAYERDISTOLD), a

    ; 障害物との当たり判定
    call GetPlayerSurroundings
    
    ld hl, MOVECONDITION_PROC

    ld  a, (WK_PLAYERDIST)

    add a, a ; Aレジスタの値を2倍する

    ld b, 0
    ld c, a
    
    add hl, bc ; 2倍した値を加算してジャンプ先のアドレスを決定する
    
    ; HLレジスタにはジャンプ先のアドレスが格納されているアドレスが
    ; セットされており、その「ジャンプ先のアドレス」を取得する

    ; ジャンプ先アドレスをBCレジスタにセット
    ld a, (hl)
    ld c, a 
    inc hl
    ld a, (hl)
    ld b, a
    
    ; BCレジスタの値（ジャンプ先アドレス）をHLレジスタにセット
    ld hl, bc

    jp (hl) ; 進行方向にあわせた処理に強制ジャンプ

PlayerMoveCheckEnd:
   
    ; 移動可能かチェックした結果で
    ; 移動禁止フラグがONの場合は移動させない
    ld a, (WK_NOTMOVE_FLG)
    cp CONST_NOTMOVE_ON
    jr z, PlayerMoveEnd

    ; 移動する場合、WK_PIT_ENTER_FLGとWK_SHOP_ENTER_FLGをクリアする
    xor a
    ld (WK_PIT_ENTER_FLG), a
    ld (WK_SHOP_ENTER_FLG), a

    ld hl, SPRITEMOVE_TBL
    ld  a, (WK_PLAYERDIST)

    ld b, 0
    ld c, a

    add hl, bc

    ld a, (hl) ; 方向にあわせて移動量を取得する
    ld c, a

PlayerMoveX:

    ; 上位4ビットがX方向の移動量
    rrca
    rrca
    rrca
    rrca
    and 00001111B

    cp 2
    jr z, PlayerMoveXMinus

    ld (WK_PLAYERMOVE_X), a

    jr PlayerMoveY

PlayerMoveXMinus:

    ld a, $FF
    ld (WK_PLAYERMOVE_X), a

PlayerMoveY:

    ; 下位4ビットがY方向の移動量
    ld a, c
    and 00001111B

    cp 2
    jr z, PlayerMoveYMinus

    ld (WK_PLAYERMOVE_Y), a

    jr PlayerMoveEnd

PlayerMoveYMinus:

    ld a, $FF
    ld (WK_PLAYERMOVE_Y), a

PlayerMoveEnd:

    ; テキキャラとの衝突判定中であれば
    ; ステップバックさせる
    ld a, (WK_PLAYER_COLLISION)
    cp 20
    jr nz, PlayerMoveEndSkipStepback

    ; 向きをOLD方向にする
    ld a, (WK_PLAYERDISTOLD)
    ld (WK_PLAYERDIST), a

PlayerMoveEndSkipStepback:

    ; WK_SPRITE_MOVETBLのプレイヤーの
    ; X, Y座標とパターン番号を更新する
    ; Bレジスタ=Xの移動量
    ; Cレジスタ=Yの移動量
    ; Dレジスタ=プレイヤーの向き

    ld hl, SPRDISTPTN_NOP

    ld  a, (WK_PLAYERDIST)

    ld d, 0
    ld e, a
    add hl, de ; HL = HL + WK_PLAYERDIST

    ld a, (hl) ; パターン番号の決定
    ld b, a

    ; WK_PLAYERANIMEVALの値によって
    ; パターン番号を補正する
    ld a, (WK_PLAYERANIMECNT)

    or 0
    jr nz, PlayerMoveEndAnimeNotZero

    ld a, 1
    ld (WK_PLAYERANIMEVAL), a ; カウンタを加算する値は+1

    jr PlayerMoveEndAnimeNotTwo

PlayerMoveEndAnimeNotZero:

    cp 2
    jr nz, PlayerMoveEndAnimeNotTwo

    ld a, $FF
    ld (WK_PLAYERANIMEVAL), a ; カウンタを加算する値は-1(FFH)

PlayerMoveEndAnimeNotTwo:

    ld a, (WK_PLAYERANIMECNT)
    ld c, a
    ld a, (WK_PLAYERANIMEVAL)
    add a, c
    ld (WK_PLAYERANIMECNT), a

    ; WK_PLAYERANIMECNTの値*8をBレジスタに加算する
    ; sla a ; x2
    ; sla a ; x4
    ; sla a ; x8
    add a, a
    add a, a
    add a, a

    add a, b

    ld d, a  ; プレイヤースプライト1枚目のパターン番号をDレジスタにセットする
    add a, 4
    ld e, a  ; プレイヤースプライト2枚目のパターン番号をEレジスタにセットする

    ld (WK_DEREGBACK), de

    ; 移動禁止フラグがONの場合、移動量は加算しない
    ld b, 0
    ld c, 0
    xor a
    ld (WK_VALUE01), a
    ld (WK_VALUE02), a

    ld a, (WK_NOTMOVE_FLG)
    cp CONST_NOTMOVE_ON
    jr z, PlayerMovePutSprite
 
    ;
    ; TODO: いまのところ8ドットの移動
    ;

    ; BレジスタにX座標の移動量がセットされる
    ; CレジスタにY座標の移動量がセットされる
    ld a, (WK_PLAYERMOVE_X) ; X座標の移動　
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld b, a

    ld a, (WK_PLAYERMOVE_Y) ; Y座標の移動
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld c, a

    ; 移動量をWK_VALUE01, WK_VALUE02にそれぞれセットする
    ld a, b
    ld (WK_VALUE01), a
    ld a, c
    ld (WK_VALUE02), a

    ld a, b
    add a, c
    jr nz, PlayerMovePutSprite

PlayerMovePutSprite:

    ld hl, WK_SPRITE_MOVETBL + 16

    ;-------------------------------------------------
    ; プレイヤー1枚目のスプライト情報
    ;-------------------------------------------------
 
    ld de, (WK_DEREGBACK)

    ld a, $FF
    ld (hl), a  ; +16

    inc hl
    ld  a, (hl) ; SPRITE#1 Y座標
    push bc
    ld b, a
    ld a, (WK_VALUE02)
    add a, b
    ld (WK_VALUE02), a
    pop bc
    ld (hl), a  ; +17

    inc hl
    ld  a, (hl) ; SPRITE#1 X座標
    push bc
    ld b, a
    ld a, (WK_VALUE01)
    add a, b
    ld (WK_VALUE01), a
    pop bc
    ld (hl), a  ; +18

    inc hl
    ld a, d
    ld (hl), a  ; +19 パターン番号

    inc hl
    ld a, (WK_PLAYERSPRCLR1)
    ld (hl), a  ; +20 カラー
    
    push bc
    ld bc, 12
    add hl, bc  ; +21 - +31
    pop bc

    ;-------------------------------------------------
    ; プレイヤー2枚目のスプライト情報
    ;-------------------------------------------------

    ld a, $FF
    ld (hl), a  ; +32

    inc hl
    ld  a, (hl) ; SPRITE#1 Y座標
    ld a, (WK_VALUE02)
    ld (hl), a  ; +33

    inc hl
    ld  a, (hl) ; SPRITE#1 X座標
    ld a, (WK_VALUE01)
    ld (hl), a  ; +34

    inc hl      
    ld a, e
    ld (hl), a  ; +35 パターン番号

    inc hl
    ld a, (WK_PLAYERSPRCLR2)
    ld (hl), a  ; +36 カラー

    push bc
    ld bc, 12
    add hl, bc  ; +37 - +48
    pop bc

    ; ピープホールの場合、動くたびに再描画する
    ; ピープホール型のマップでない場合
    ; 何もしない
    ld a, (WK_MAPTYPE)
    cp 2
    jr z, PlayerMoveSetRedraw
    cp 5
    jr z, PlayerMoveSetRedraw
    cp 6
    jr z, PlayerMoveSetRedraw
    cp 8
    jr z, PlayerMoveSetRedraw

    jr PlayerMovePutSpriteItem

PlayerMoveSetRedraw:

    ld a, 1
    ld (WK_REDRAW_FINE), a

PlayerMovePutSpriteItem:

    ; WK_EQUIP_STRを2倍してEQUIP_DATA_STRに加算すると
    ; アイテムデータのアドレスが取得できる

    push bc
    ld hl, EQUIP_DATA_STR
    ld a, (WK_EQUIP_STR)
    add a, a ; x2
    ld b, 0
    ld c, a
    add hl, bc
    pop bc

    inc hl
    ld a, (hl)  ; STR値
    ld (WK_VALUE04), a

    ;-------------------------------------------------
    ; 剣のスプライト情報をセットする
    ;-------------------------------------------------
    call ItemPlayerEquipment

    ; 方向キーが押されてない場合はREDRAWはしない
    ; WK_REDRAW_FINEをONにすると再描画処理が
    ; 行われるためすごく重くなる

    ld a, (WK_PLAYERDIST)
    or a
    jr z, PlayerMovePopEndSkipOld

PlayerMovePutSpriteMoveEnd:

    ; HLレジスタにWK_SPRITE_MOVETBLのアドレスをセット
    ; 剣は消えることがあるので1枚目のアドレスをセットする
    ld hl, WK_SPRITE_MOVETBL + 16

    inc hl ; 種別コードの箇所はスキップ

    ld  a, (hl) ; SPRITE#0 Y座標
    ld (WK_PLAYERPOSY), a
    inc hl

    ld  a, (hl) ; SPRITE#0 X座標
    ld (WK_PLAYERPOSX), a

    ; X座標(0-255)の値を8で割る
    call DivideBy8

    ld a, d
    ld (WK_CHECKPOSX), a
     
    ld  a, (WK_PLAYERPOSY)

    ; Y座標(0-191)の値を8で割る
    call DivideBy8

    ld a, d ; 商
    ld (WK_CHECKPOSY), a

    ld a, CONST_NOTMOVE_OFF
    ld (WK_NOTMOVE_FLG), a

    ; プレイヤーが動いた場合は
    ; ・20/60秒タイマーを0にして強制的に画面を再描画する
    ; ・休憩カウントダウンタイマーを0にする
    ; ・今回の移動方向をOLD変数にセットする
    ; ただし、マップ切替時は再描画はしない

    ld a, (WK_MAPCHANGE_COUNT)
    or a
    jr nz, PlayerMovePopEndNotRest

PlayerMovePopEndSkipOld:

    ; 方向が押されていない場合
    ; 休憩カウントダウンタイマーを作動させる
    ; 休憩カウントダウンタイマーの値が
    ; 1秒(60)経過しており、なおかつ
    ; 画面内にテキキャラが存在していなければ
    ; プレイヤーのライフを+1する

    ld a, (WK_PLAYERDIST)
    or a
    jr nz, PlayerMovePopEndRestReset

    ; 休憩カウントダウンタイマーが0の場合
    call CheckEnemyExists

    ; テキキャラが画面内に存在していたら
    ; 休憩はできない
    or a
    jr nz, PlayerMovePopEndRestReset

    ; ライフが最大値であれば休憩はできない
    ld a, (WK_PLAYERLIFEMAX)
    ld b, a
    ld a, (WK_PLAYERLIFEVAL)
    cp b
    jr z, PlayerMovePopEndRestEraseDispMsg

    ld a, (WK_REST_COUNTDOWN)
    or a
    jr nz, PlayerMovePopEndRestNow

    jr PlayerMovePopEndRestEraseDispMsg

PlayerMovePopEndRestNow:

    ; 休憩カウントダウンタイマーが0以外であれば
    ; 休憩カウントダウンタイマーをデクリメントする
    ; その結果が0であればライフを+1して画面を再描画する

    ld a, (WK_REST_COUNTDOWN)
    dec a
    jr nz, PlayerMovePopEndRestNowNotLifeUp

    ; 休憩カウントダウンタイマーが0になったら
    ; ・プレイヤーのライフをインクリメントする
    ; ・プレイヤーのライフを再表示する
    ; ただし、プレイヤーの最大ライフ以上には増やさない

    ; 休憩時にはテキキャラは存在していないので
    ; テキキャラのメッセージ欄を消す
    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32
    ld bc, 11
    ld a, $20
    call MemFil

    ; 休憩中のメッセージを表示する
    ld hl, WK_VIRT_PTNNAMETBL + 1 + 32
    ld bc, 18
    ld a, $20
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 1 + 32
    ld hl, MESSAGE_RESTING
    ld bc, 10
    call MemCpy

    ld a, 1
    ld (WK_PLAYERLIFESUM), a
    call AddLifeGuage

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ld a, 60
    jr PlayerMovePopEndRestNowNotLifeUp

PlayerMovePopEndRestReset:

    ld a, 60
    ld (WK_REST_COUNTDOWN), a

PlayerMovePopEndRestEraseDispMsg:

    ; プレイヤー休憩中のメッセージを消す
    ld hl, WK_VIRT_PTNNAMETBL + 1 + 32
    ld bc, 18
    ld a, $20
    call MemFil

    jr PlayerMovePopEndNotRest

PlayerMovePopEndRestNowNotLifeUp:

    ; デクリメントした値を休憩カウントダウンタイマーに
    ; セットしなおす
    ld (WK_REST_COUNTDOWN), a

PlayerMovePopEndNotRest:

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------
; SUB-ROUTINE:移動可否判定処理
; Aレジスタ=0(移動不可), 1(移動可)
; プレイヤーの周囲のVRAM情報を取得し
; 移動可否を判定する
;---------------------------------------------
CheckMoveUp:

    ld  a, (WK_CHECKPOSY)
    
    ; WK_CHECKPOPSY が3で進行方向が1の場合はマップを移動する
    cp 3
    jr z, CheckMoveUpDecPosY

    ld hl, WK_VRAM4X4_TBL
    
    ; WK_VRAM4X4を調べる
    inc hl
    ld b, (hl)  ; +01H
    inc hl
    ld c, (hl)  ; +02H
    call CheckCollisionObject

    ; 当たり判定結果はAレジスタにセットされて返却する
    cp 1 
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveUpDecPosY:

    ; MAP座標Yを取得する
    ld a, (WK_MAPPOSY)

    ; MAP座標Yを-1する
    dec a
    ld (WK_MAPPOSY), a

    ; プレイヤーのY座標を修正する
    ld a,  21
    ld (WK_CHECKPOSY), a

    ld a, 168
    ld (WK_PLAYERPOSY), a

    ; マップを切替える
    call CheckMoveMapPosChange

    ; マップ切替時にはプレイヤーは移動させない
    jp PlayerMoveEnd

CheckMoveRight:

    ld  a, (WK_CHECKPOSX)
    
    ; WK_CHECKPOPSX が29で進行方向が3の場合はマップを移動する
    cp 29
    jr z, CheckMoveRightIncPosX

    ld hl, WK_VRAM4X4_TBL
    
    ; WK_VRAM4X4を調べる

    ld b, 0
    ld c, $07
    add hl, bc
    ld d, (hl)  ; +07H
    ld c, $04
    add hl, bc
    ld e, (hl)  ; +0BH
    ld b, d
    ld c, e
    call CheckCollisionObject

    ; 当たり判定結果はAレジスタにセットされて返却する
    cp 1 
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveRightIncPosX:

    ; MAP座標Xを取得する
    ld a, (WK_MAPPOSX)

    ; MAP座標Xを+1する
    inc a
    ld (WK_MAPPOSX), a

    ; プレイヤーのX座標を修正する
    ld a,  1
    ld (WK_CHECKPOSX), a

    ld a, 8
    ld (WK_PLAYERPOSX), a

    ; マップを切替える
    call CheckMoveMapPosChange

    ; マップ切替時にはプレイヤーは移動させない
    jp PlayerMoveEnd

CheckMoveDown:

    ld  a, (WK_CHECKPOSY)
    ld  c, a
    
    ; WK_CHECKPOSY が21で進行方向が5の場合はマップを移動する
    ld a, c
    cp 21
    jr z, CheckMoveDownIncPosY

    ld hl, WK_VRAM4X4_TBL
    
    ; WK_VRAM4X4を調べる

    ld b, 0
    ld c, $0D
    add hl, bc
    ld b, (hl)  ; +0DH
    inc hl
    ld c, (hl)  ; +0EH
    call CheckCollisionObject

    ; 当たり判定結果はAレジスタにセットされて返却する
    cp 1 
    jr z, CheckMoveConditionNG

    jr CheckMoveConditionOkay

CheckMoveDownIncPosY:

    ; MAP座標Yを取得する
    ld a, (WK_MAPPOSY)

    ; MAP座標Yを+1する
    inc a
    ld (WK_MAPPOSY), a

    ; プレイヤーのY座標を修正する
    ld a,  3
    ld (WK_CHECKPOSY), a

    ld a, 24
    ld (WK_PLAYERPOSY), a

    ; マップを切替える
    call CheckMoveMapPosChange

    ; マップ切替時にはプレイヤーは移動させない
    jp PlayerMoveEnd

CheckMoveLeft:

    ld  a, (WK_CHECKPOSX)
    
    ; WK_CHECKPOSX が1で進行方向が7の場合はマップを移動する
    cp 1
    jr z, CheckMoveLeftDecPosX

    ld hl, WK_VRAM4X4_TBL
    
    ; WK_VRAM4X4を調べる

    ld b, 0
    ld c, $04
    add hl, bc
    ld d, (hl)  ; +04H
    ld c, $04
    add hl, bc
    ld e, (hl)  ; +08H
    ld b, d
    ld c, e
    call CheckCollisionObject

    ; 当たり判定結果はAレジスタにセットされて返却する
    cp 1 
    jr z, CheckMoveConditionNG

    jr CheckMoveConditionOkay

CheckMoveLeftDecPosX:

    ; MAP座標Xを取得する
    ld a, (WK_MAPPOSX)

    ; MAP座標Xを-1する
    dec a
    ld (WK_MAPPOSX), a

    ; プレイヤーのX座標を修正する
    ld a,  29
    ld (WK_CHECKPOSX), a

    ld a, 232
    ld (WK_PLAYERPOSX), a

    ; マップを切替える
    call CheckMoveMapPosChange

    ; マップ切替時にはプレイヤーは移動させない
    jp PlayerMoveEnd

CheckMoveConditionNG:

    ; 移動不可の場合、移動禁止フラグをONにする
    ld a, CONST_NOTMOVE_ON
    ld (WK_NOTMOVE_FLG), a

    jr CheckMoveConditionEnd

CheckMoveConditionOkay:

    ; 前回移動方向と異なっている場合は
    ; 移動禁止フラグが成立している。
    ; その場合は移動禁止フラグはOFFにしない
    ld a, (WK_NOTMOVE_FLG)
    cp CONST_NOTMOVE_ON
    jr z, CheckMoveConditionEnd

    ; 移動可の場合、移動禁止フラグをOFFにする
    ld a, CONST_NOTMOVE_OFF
    ld (WK_NOTMOVE_FLG), a

CheckMoveConditionEnd:

    jp PlayerMoveCheckEnd

;---------------------------------------------
; SUB-ROUTINE:マップを切り替える
;---------------------------------------------
CheckMoveMapPosChange:

    push af
    push bc
    push de
    push hl

    ; マップを切替える
    ld a, 5
    ld (WK_MAPCHANGE_COUNT), a

    ld a, 10
    ld (WK_GAMESTATUS_INTTIME), a

    call ClearScreen

    ; プレイヤーのスプライトのXY座標をセットする
    call PlayerSetXYPos

    ; 移動禁止フラグをONにする
    ld a, CONST_NOTMOVE_ON
    ld (WK_NOTMOVE_FLG), a

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------
; SUB-ROUTINE:プレイヤーの座標設定
; WK_SPRITE_MOVETBLの座標をセットする
;---------------------------------------------
PlayerSetXYPos:

    push af
    push hl

    ; プレイヤーのスプライト座標を変更する
    ld hl, WK_SPRITE_MOVETBL
    
    inc hl ; 1枚目：Y座標
    ld a, (WK_PLAYERPOSY)
    ld (hl), a

    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    inc hl ; 1枚目：X座標
    ld a, (WK_PLAYERPOSX)
    ld (hl), a

    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ld hl, WK_SPRITE_MOVETBL + 16
    inc hl
    ld a, (WK_PLAYERPOSY) ; 2枚目：Y座標
    ld (hl), a
    inc hl
    ld a, (WK_PLAYERPOSX) ; 2枚目：X座標
    ld (hl), a

    ld hl, WK_SPRITE_MOVETBL + 32
    inc hl
    ld a, (WK_PLAYERPOSY) ; 3枚目：Y座標
    ld (hl), a
    inc hl
    ld a, (WK_PLAYERPOSX) ; 3枚目：X座標
    ld (hl), a

    ; CHECKPOX, CHECKPOSYを再設定する

    pop hl
    pop af

    ret

;---------------------------------------------
; SUB-ROUTINE:プレイヤーの周囲情報を取得
; 仮想パターンネームテーブルをもとに
; プレイヤーの周囲のVRAM情報を取得する
;---------------------------------------------
GetPlayerSurroundings:

    ld  a, (WK_PLAYERPOSX)

    ; X座標(0-255)の値を8で割る
    call DivideBy8

    ld a, d
    ld (WK_CHECKPOSX), a
     
    ld  a, (WK_PLAYERPOSY)

    ; Y座標(0-191)の値を8で割る
    call DivideBy8

    ld a, d ; 商
    ld (WK_CHECKPOSY), a

    call GetVRAM4x4

    ret

;----------------------------------------------------
; SUB-ROUTINE:プレイヤーのライフゲージに値を加算する
; WK_PLAYERLIFESUMに加算値をセットして呼び出すこと
; 加算値にはマイナス値も許可する
;-------------------------------------------------
AddLifeGuage:

    push bc
    push de

    ld a, (WK_GAMECLEAR)
    or a
    jr nz, AddLifeGuageEndSkipSetBGCOLOR

    ; ライフポイントの桁情報をすべてゼロにする
    ld hl, WK_PLAYERLIFEPOINT
    ld bc, 10
    ld  a, 0
    call MemFil

    ; ライフポイント値に加算値を加算する
    ld a, (WK_PLAYERLIFEVAL)
    ld b, a
    ld a, (WK_PLAYERLIFESUM)
    add a, b
    ld (WK_PLAYERLIFEVAL), a

    or a
    jr z, AddLifeGuageGameOver  ; ライフゲージが0か？

    and 10000000B
    cp 128
    jr z, AddLifeGuageGameOver  ; ライフゲージがマイナスであれば0にする

    ; 加算結果がライフポイント最大値を超える場合は
    ; ライフポイント最大値をライフポイント値とする
    ld a, (WK_PLAYERLIFEMAX)
    ld b, a

    ld a, (WK_PLAYERLIFEVAL)
    cp b  ; LIFEVAL - LIFEMAX
    jr nc, AddLifeGuageSetMax

    jr AddLifeGuagePutLifeMark

AddLifeGuageSetMax:

    ; ライフポイントを最大値にする
    ld a, (WK_PLAYERLIFEMAX)
    ld (WK_PLAYERLIFEVAL), a

AddLifeGuagePutLifeMark:

    ; WK_PLAYERLIFEVALから7を減算しながらライフマークを埋めていく
    ld hl, WK_PLAYERLIFEPOINT
    ld b, a
    ld c, 7

AddLifeGuageLoop:

    ld a, b
    sub c    ; A = B - 7
    jr c, AddLifeGuageAddAmari
    jr z, AddLifeGuageAddAmari
    
    ld (hl), c
    inc hl

    ld b, a
    jr AddLifeGuageLoop   

AddLifeGuageAddAmari:

    ld a, b
    cp 1
    jr c, AddLifeGuageGameOver ; Bの値が7未満であればゼロにする

    ld (hl), a ; 

    jr AddLifeGuageEnd

AddLifeGuageGameOver:

    ; ライフ<=の場合はライフを0にする
    xor a
    ld (WK_PLAYERLIFEVAL), a

AddLifeGuageEnd:

    ; ライフゲージが4以上の場合、背景を青にする
    ld a, (WK_PLAYERLIFEVAL)
    cp 4
    jr c, AddLifeGuageEndSkipSetBGCOLOR
    
    ld a, (WK_BGCOLOR_CHGFLG)
    cp 2 ; 背景色が赤色に変更されていなければスキップ
    jr nz, AddLifeGuageEndSkipSetBGCOLOR

    ; 背景色の赤を青に戻す
    ld a, 3
    ld (WK_BGCOLOR_CHGFLG), a

AddLifeGuageEndSkipSetBGCOLOR:

    ld a, 1
    ld (WK_REDRAW_FINE), a

    pop de
    pop bc

    ret


