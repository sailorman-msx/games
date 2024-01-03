;---------------------------------------------
; 当たり判定処理
; 当たり判定はスプライト対スプライトと
; スプライト対PCGキャラクタの2種類がある
;---------------------------------------------

;---------------------------------------------
; SUB-ROUTINE:スプライト同士の当たり判定処理
; HLレジスタに格納されているWK_SPRITE_MOVETBL
; のアドレスのスプライトと衝突しているスプライト
; のWK_SPRITE_MOVETBLのアドレスを取得する
;
; すでに当たり判定テーブルにアドレスがセット
; されている場合はインターバル値をデクリメントする
;
; 当処理はテーブルにアドレスをセットするだけとし
; 当たり判定時のエフェクト処理等は別のサブルーチンで
; 実施する
;
; (衝突判定タイプ1)
; 甲：テキキャラ（orテキの弾）と乙：自キャラとの衝突
;   →テキキャラ移動後のインターバル間に1回実施
;
; (衝突判定タイプ2)
; 甲：テキキャラと乙：剣の衝突
;   →テキキャラ移動後のインターバル間に1回実施
;
; (衝突判定タイプ3)
; 未実装
; 
; 引数
;  Aレジスタ
;    1: 衝突判定タイプ1
;    2: 衝突判定タイプ2
;    3: 衝突判定タイプ3
;  HLレジスタ
;    甲のWK_SPRITE_MOVETBLのアドレス
;  WK_VALUE03: POS X座標
;  WK_VALUE04: POS Y座標
;
; 破壊レジスタ）BC, DE
;---------------------------------------------
CheckCollisionSprite:

    push hl

    ; 衝突判定タイプをWK_VALUE02にセット
    ld (WK_VALUE02), a

    ld de, WK_COLLISION_TBL

    ld a, 20

    ; ループ回数をWK_VALUE01にセット
    ld (WK_VALUE01), a

CheckCollisionSpriteLoop:

    ld (WK_DEREGBACK), de

    ; 当たり判定テーブルの空いている場所を見つける
    ; 当たり判定テーブルが空いているとみなす条件
    ;   甲のアドレスが$0000
    ld a, (de)   ; +0
    ld c, a
    inc de
    ld a, (de)   ; +1
    ld b, a
    add a, c
    
    or a         ; 甲のアドレスが$0000か？
    jp z, CheckCollisionSpriteLoopEmptyFound

    push hl
    or a
    sbc hl, bc
    pop hl

    ; 既に甲のアドレスにセットされているので
    ; あれば何もしない（既に衝突判定済みと判定）
    jp z, CheckCollisionSpriteLoopExists

    inc de ; +2
    inc de ; +3
    inc de ; +4

    ld a, (de)   ; +1
    or a
    jp z, CheckCollisionSpriteLoopEmptyFound

    ; $0000でもなく、既に登録されているわけでもない
    ; アドレスがセットされていたら次のテーブルを探す
    jp CheckCollisionSpriteLoopNextData
    
CheckCollisionSpriteLoopExists:

    ; すでにアドレスがセットされている場合の処理
    
    ; 甲と同じアドレスであれば処理を終了する
    ; (当たり判定情報を多重に登録しない)
    jp CheckCollisionSpriteEnd

CheckCollisionSpriteLoopEmptyFound:

    ; 当たり判定テーブル上に空きが見つかった
    ld a, (WK_VALUE02)

    cp 1
    jp z, CheckCollisionSpriteType1

    cp 2
    jp z, CheckCollisionSpriteType2

    jp z, CheckCollisionSpriteType3

CheckCollisionSpriteType1:

    ; プレイヤーのLOCATE X,Y座標と
    ; テキキャラのLOCATE X,Y座標がそれぞれ絶対値で
    ; 2以下であれば衝突していると判定する

    ; プレイヤーのX座標、Y座標は
    ; WK_PLAYERPOSX, WK_PLAYERPOSYにセットされている

CheckCollisionSpriteType1Collision:

    ; テキキャラのY座標と、プレイヤーのY座標の距離を
    ; 絶対値で取得する
    ld a, (WK_PLAYERPOSY)
    call DivideBy8
    ld b, d

    inc hl ; +1 : Y座標
    ld a, (hl)
    call DivideBy8
    ld a, d

    sub b      ; A=ABS(PLAYERPOSY - ENEMYPOSY)
    call AbsA

    ; LOCATE Y座標が2以上離れていたら衝突していない
    cp 2
    jp nc, CheckCollisionSpriteEnd

    ; テキキャラのX座標と、プレイヤーのX座標の距離を
    ; 絶対値で取得する
    ld a, (WK_PLAYERPOSX)
    call DivideBy8
    ld b, d

    inc hl ; +2 : X座標
    ld a, (hl)
    call DivideBy8
    ld a, d

    sub b      ; A=ABS(PLAYERPOSX - ENEMYPOSX)
    call AbsA

    ; LOCATE X座標が2以上離れていたら衝突していない
    cp 2
    jp nc, CheckCollisionSpriteEnd

    ; 衝突している

    ; 衝突判定した場合はCOLLISIONテーブルにアドレスをセットする
    ; 甲にテキキャラのアドレス
    ; 乙にプレイヤーのアドレス
    ; インターバル値に0をセットする
    ld bc, WK_SPRITE_MOVETBL + 16
    ld (WK_BCREGBACK), bc
    jp CheckCollisionSpriteSetCollisionTable

    jp CheckCollisionSpriteEnd
    
CheckCollisionSpriteType2:

    ; 剣のLOCATE X,Y座標と
    ; テキキャラのLOCATE X,Y座標がそれぞれ絶対値で
    ; 2以下であれば衝突していると判定する

    ; 剣のX座標、Y座標は
    ; WK_VALUE03, WK_VALUE04にセットされている

    ; 剣を振っている状態でなければ何もしない
    ld a, (WK_SWORDACTION_COUNT)
    or a
    jp z, CheckCollisionSpriteEnd

    ; テキキャラがファイアボールであれば何もしない
    ld a, (hl)
    cp 10
    jp z, CheckCollisionSpriteEnd

CheckCollisionSpriteType2Collision:

    ; テキキャラのY座標と、剣のY座標の距離を
    ; 絶対値で取得する
    ld a, (WK_VALUE04)
    call DivideBy8
    ld b, d

    inc hl ; +1 : Y座標
    ld a, (hl)
    call DivideBy8
    ld a, d

    sub b      ; A=ABS(PLAYERPOSY - ENEMYPOSY)
    call AbsA

    ; LOCATE Y座標が2以上離れていたら衝突していない
    cp 2
    jp nc, CheckCollisionSpriteEnd

    ; テキキャラのX座標と、プレイヤーのX座標の距離を
    ; 絶対値で取得する
    ld a, (WK_VALUE03)
    call DivideBy8
    ld b, d

    inc hl ; +2 : X座標
    ld a, (hl)
    call DivideBy8
    ld a, d

    sub b      ; A=ABS(PLAYERPOSX - ENEMYPOSX)
    call AbsA

    ; LOCATE X座標が2以上離れていたら衝突していない
    cp 2
    jp nc, CheckCollisionSpriteEnd

    ld bc, WK_SPRITE_MOVETBL
    ld (WK_BCREGBACK), bc

CheckCollisionSpriteSetCollisionTable:

    ; 衝突している

    ; 衝突判定した場合はCOLLISIONテーブルにアドレスをセットする
    ; 甲にテキキャラのアドレス
    ; 乙にプレイヤーのアドレス
    ; インターバル値に0をセットする
    dec hl
    dec hl
    ld bc, hl ;
    ld hl, (WK_DEREGBACK)
    
    ld (hl), bc
    inc hl
    inc hl
    ld bc, (WK_BCREGBACK)
    ld (hl), bc

    inc hl
    inc hl
    xor a
    ld (hl), a

    jp CheckCollisionSpriteEnd

CheckCollisionSpriteType3:

CheckCollisionSpriteLoopNextData:

    ld a, (WK_VALUE01)
    dec a
    ld (WK_VALUE01), a

    or a
    jp z, CheckCollisionSpriteEnd

    ; 次のテーブルを調査
    ld de, (WK_DEREGBACK)
    inc de ; +1
    inc de ; +2
    inc de ; +3
    inc de ; +4
    inc de ; +5 <= 次のアドレス

    jp CheckCollisionSpriteLoop
   
CheckCollisionSpriteEnd:

    pop hl

    ret

;---------------------------------------------
; SUB-ROUTINE:スプライトの衝突時処理
; 衝突判定テーブルを走査し
; プレイヤーの衝突時処理を行う
; 当処理は毎フレームに実施する
;---------------------------------------------
PlayerCollision:

    ; ライフがゼロのときは衝突判定は行わない
    ld a, (WK_PLAYERLIFEVAL)
    or a
    ret z

    ; 衝突判定後の20/60秒間は衝突判定は行わない
    ld a, (WK_PLAYER_COLLISION)
    or a
    jp z, PlayerCollisionDecCollisionProc

    dec a
    ld (WK_PLAYER_COLLISION), a
    ret

PlayerCollisionDecCollisionProc:

    ld de, WK_COLLISION_TBL

    ld a, 20
    ld (WK_LOOP_COUNTER), a

PlayerCollisionLoop:

    ld a, (WK_PLAYER_COLLISION)
    or a
    ret nz

    ; WK_COLLISION_TBLのアドレス(甲のアドレス)を
    ; WK_DEREGBACKに退避しておく
    ld (WK_DEREGBACK), de

    ld a, (de)
    ld c, a
    inc de      ; +1
    ld a, (de)
    sub c       ; +0から+1の値を減算
    and $FF     ; 減算結果を$FFでAND演算

    ; 甲のアドレスが$0000であれば次のデータを探す
    jp z, PlayerCollisionLoopNextData

    ; 乙のアドレスがプレイヤーか剣でなければ次のデータを
    ; 探す

    ld hl, WK_SPRITE_MOVETBL + 0   ; 剣のスプライト

    inc de      ; +2
    ld a, (de)
    ld c, a
    ld a, l
    sub c
    jp nz, PlayerCollisionLoopCheckBody

    inc de      ; +3
    ld a, (de)
    ld b, a
    ld a, h
    sub b
    jp nz, PlayerCollisionLoopCheckBody

    ; 剣が衝突していると判定されている
   
    ; 剣を振っていなければ何もしない
    ld a, (WK_SWORDACTION_COUNT)
    or a
    jp z, PlayerCollisionLoopNextData

    ld (WK_HLREGBACK), hl

    jp PlayerCollisionLoopCheckEnd

PlayerCollisionLoopCheckBody:

    ld hl, WK_SPRITE_MOVETBL + 16  ; プレイヤー本体のスプライト
    ld de, (WK_DEREGBACK)

    inc de      ; +1
    inc de      ; +2
    ld a, (de)
    ld c, a
    ld a, l
    sub c
    jp nz, PlayerCollisionLoopNextData

    inc de      ; +3
    ld a, (de)
    ld b, a
    ld a, h
    sub b
    jp nz, PlayerCollisionLoopNextData

    ; プレイヤー本体が衝突していると判定されている
   
    ld (WK_HLREGBACK), hl

PlayerCollisionLoopCheckEnd:

    ld de, (WK_DEREGBACK)
    inc de      ; +1
    inc de      ; +2
    inc de      ; +3
    inc de      ; +4 <= インターバル値

    ; すでにインターバル値がセットされている場合はデクリメントする
    ; ただし10の場合は衝突判定直後とみなしてダメージ計算を行う
    ld a, (de)
    cp 1
    jp nc, PlayerCollisionDecInterval

    ; 衝突直後の処理を行う

    ; インターバル値をセットし
    ; インターバル期間中は次の当たり判定は行わない
    ld a, 10
    ld (de), a ; インターバル値をセット(10/60秒)とする

    ; ダメージ計算処理を入れる
    ; 甲のアドレス（テキキャラ）をDEレジスタ
    ; 乙のアドレス（プレイヤー）をHLレジスタ
    ; にセットして呼び出す
    ;
    ; ダメージはAレジスタに格納されて返却される
    ; Aレジスタ<0 = Playerがダメージを浴びる
    ; Aレジスタ>0 = テキキャラがダメージを浴びる

    ld hl, (WK_DEREGBACK)
    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc

PlayerCollisionBattle:

    ; 甲のアドレスをDEレジスタにセットする
    ; 乙のアドレスをHLレジスタにセットする
    ld de, hl
    ld hl, (WK_HLREGBACK)

    call BattleCalculateDamage

    ; Aレジスタの値から$7Fを減算してキャリーしたら
    ; プレイヤーの負け
    ; 0であれば引き分け
    ; 引き分けの場合はテキのライフゲージのみ表示
    ; キャリーしなければプレイヤーの勝ち
    or a
    jp z, PlayerCollisionEnemyLose
    cp $7F
    jp nc, PlayerCollisionPlayerLose

PlayerCollisionEnemyLose:

    ; テキキャラの負け
    ; テキへのダメージポイントをWK_VALUE03にセットする
    neg
    ld (WK_ENEMYLIFESUM), a

    ld d, a

    ld hl, (WK_DEREGBACK)
    ld a, (hl) ; テキの種別
    ld (WK_VALUE03), a
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld hl, de
    ld b, 0
    ld c, $0A   ; +A : テキの体力
    add hl, bc
    ld a, (hl)

    ld (WK_ENEMYLIFEVAL), a

    ; ファイアボールでなければ
    ; テキキャラのライフゲージを表示する
    ld a, (WK_VALUE03)
    cp 10
    jr z, PlayerCollisionEnemyLoseDecLife
    call AddEnemyLifeGuage

PlayerCollisionEnemyLoseDecLife:

    ld a, (WK_ENEMYLIFEVAL)
    ld (hl), a  ; テキの体力を減らす

    ; テキのステータスを表示する
    call BattleDispEnemyStatus

    ; テキキャラの負けの場合は
    ; プレイヤーを点滅表示させない
    xor a
    ld (WK_PLAYER_COLLISION), a

    ld a,$0B ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    jp PlayerCollisionJudgeEnd

PlayerCollisionPlayerLose:

    ; プレイヤーの負け
    ; プレイヤーのライフからポイントを減算する
    ld (WK_PLAYERLIFESUM), a
    call AddLifeGuage
    call BattleDispLifeGuage

    ; WK_PLAYER_COLLISIONに20をセットする
    ld a, 20
    ld (WK_PLAYER_COLLISION), a

    ; ld hl, SFX_00
    ; call SOUNDDRV_SFXPLAY
    ld a,2 ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

PlayerCollisionJudgeEnd:

    ; 衝突判定が行われたら他のテーブルは参照しない
    ; jp PlayerCollisionLoopNextData
    jp PlayerCollisionLoopEnd

PlayerCollisionDecInterval:

    ; インターバル値をデクリメントする
    dec a
    ld (de), a

    ; インターバル値が0になった場合は
    ; 当たり判定テーブルの内容をクリアする
    or a
    jp nz, PlayerCollisionLoopNextData

    ; 衝突判定テーブルをゼロクリアする
    ld de, (WK_DEREGBACK)
    xor a
    ld (de), a   ; +0
    inc de
    ld (de), a   ; +1
    inc de
    ld (de), a   ; +2
    inc de
    ld (de), a   ; +3
    inc de
    ld (de), a   ; +4

    ; 衝突判定フラグをクリアする
    ld a, 0
    ld (WK_PLAYER_COLLISION), a

PlayerCollisionLoopNextData:

    ld a, (WK_LOOP_COUNTER)
    or a
    jp z, PlayerCollisionLoopEnd

    dec a
    ld (WK_LOOP_COUNTER), a

    ld de, (WK_DEREGBACK)
    inc de ; +1
    inc de ; +2
    inc de ; +3
    inc de ; +4
    inc de ; +5 <= 次のデータ

    jp PlayerCollisionLoop

PlayerCollisionLoopEnd:

    ; プレイヤーと宝箱が重なっていれば
    ; 宝箱を拾う

    ld hl, WK_SPRITE_MOVETBL + 16
    inc hl
    ld a, (hl)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    inc hl
    ld a, (hl)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    call GetVRAM4x4
    ld hl, WK_VRAM4X4_TBL
    ld b, 0
    ld c, 5
    add hl, bc
    ld a, (hl)
    cp $88 ; 宝箱？
    jp z, PlayerCollisionLoopEndPickBox
    cp $95 ; 宝箱（レア）？
    jp z, PlayerCollisionLoopEndPickBox

    ; リングショップ？
    cp $B0
    jp z, PlayerCollisionLoopEndShop

    jp PlayerCollisionLoopEndSkipBox

PlayerCollisionLoopEndShop:

    ; MAP座標 X=1, Y=3であれば
    ; カードマンのメッセージ表示を行う
    ld a, (WK_MAPPOSX)
    ld b, a
    ld a, (WK_MAPPOSY)
    ld c, a
    or a
    ld hl, $0103
    sbc hl, bc
    jr z, PlayerCollisionLoopEndShopGuardman

    ld d, 3
    jr PlayerCollisionLoopEndDispShop

PlayerCollisionLoopEndShopGuardman:

    ld d, 7

    ld a, ($002C)
    or a
    jr z, GuardmanMsgJP

    ld hl, MESSAGE_DIALOG_MESSAGE_DONOTENTER_EN
    jr GuardmanMsg

GuardmanMsgJP:
    ld hl, MESSAGE_DIALOG_MESSAGE_DONOTENTER_JP

GuardmanMsg:

    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl

    ld a, 27 * 8
    ld (WK_PLAYERPOSX), a
    ld a, 19 * 8
    ld (WK_PLAYERPOSY), a
    ld a, 27
    ld (WK_CHECKPOSX), a
    ld a, 19
    ld (WK_CHECKPOSY), a

    ; プレイヤーのスプライト座標を修正する
    ld hl, WK_SPRITE_MOVETBL
    inc hl
    ld a, 19 * 8
    ld (hl), a
    inc hl
    ld a, 27 * 8
    ld (hl), a
    ld hl, WK_SPRITE_MOVETBL + 16
    inc hl
    ld a, 19 * 8
    ld (hl), a
    inc hl
    ld a, 27 * 8
    ld (hl), a
    ld hl, WK_SPRITE_MOVETBL + 32
    inc hl
    ld a, 19 * 8
    ld (hl), a
    inc hl
    ld a, 27 * 8
    ld (hl), a

PlayerCollisionLoopEndDispShop:
    
    ; すでにショップと重なってる場合
    ; （ダイアログの表示終了後）
    ; は何もしない

    ld a, (WK_SHOP_ENTER_FLG)
    cp 1
    jp z, PlayerCollisionLoopEndSkipBox

    ; ショップ（またはガードマン）を表示する
    ld a, 1
    ld (WK_SHOP_ENTER_FLG), a

    ld a, d
    ld (WK_DIALOG_TYPE), a ; SHOP or Guardman
    ld a, 3
    ld (WK_GAMESTATUS), a
    ld (WK_GAMESTATUS_INTTIME), a
    call ClearSprite

    jp PlayerCollisionLoopEndSkipBox

PlayerCollisionLoopEndPickBox:

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0F ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume)) 
    call PLY_AKG_PLAYSOUNDEFFECT

    ; WK_TREASUREBOX_ITEMの上位4ビットによって
    ; 攻撃系、防御系、草食系、道具系かを判別する
    ld a, (WK_TREASUREBOX_ITEM)
    ld b, a
    and 00010000B
    jr nz, PickBoxSetItemSTR
    ld a, b
    and 00100000B
    jr nz, PickBoxSetItemDEF
    ld a, b
    and 01000000B
    jr nz, PickBoxSetItemRING

    jr PickBoxSetItemTOOL
    
PickBoxSetItemSTR:

    ; 攻撃系アイテム
    ld a, b
    and 00001111B
    ld hl, WK_STRITEMSLOT
    ld a, 4
    ld (WK_VALUE01), a
    jr PickBoxSetItemStart

PickBoxSetItemDEF:

    ; 防御系アイテム
    ld a, b
    and 00001111B
    ld hl, WK_DEFITEMSLOT
    ld a, 4
    ld (WK_VALUE01), a
    jr PickBoxSetItemStart

PickBoxSetItemRING:

    ; 装飾系アイテム
    ld a, b
    and 00001111B
    ld hl, WK_RINGITEMSLOT
    ld a, 4
    ld (WK_VALUE01), a
    jr PickBoxSetItemStart

PickBoxSetItemTOOL:

    ; 道具系アイテム
    ld a, b
    and 00001111B
    ld hl, WK_TOOLITEMSLOT
    ld a, 20
    ld (WK_VALUE01), a

PickBoxSetItemStart:

    ld (WK_HLREGBACK), hl
    ld b, 0

PickBoxSetItemLoop:

    ld a, (hl)
    or a
    jp z, PickBoxItemLoopEnd

    inc hl
    inc b
    jr PickBoxSetItemLoop

PickBoxItemLoopEnd:

    ld a, 18
    cp b
    jp nz, PickBoxItemPick

    ; 18を超えるアイテムは持てない
    ld hl, MESSAGE_DIALOG_MESSAGE_PICKITEMFULL
    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl
    ld a, 16
    ld (WK_DISP_DIALOG_MESSAGE_LEN), a

    jr PickBoxDispDialog

PickBoxItemPick:

    ld a, (WK_TREASUREBOX_ITEM)
    ld b, a
    and 00001111B ; 上位4ビットを除去する
    ld (hl), a

    ; 道具だったらアイテムスロットを並び替える
    ld a, b
    and 1000000B
    jr nz, PickBoxItemPickSkipToolSort
    call SortSlotToolItems

PickBoxItemPickSkipToolSort:

    ; 情報表示ダイアログを表示する
    ld hl, MESSAGE_DIALOG_MESSAGE_PICKTREASUREBOX
    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl
    ld a, 32
    ld (WK_DISP_DIALOG_MESSAGE_LEN), a

PickBoxDispDialog:

    xor a
    ld (WK_TREASUREBOX_ITEM), a ; 宝箱情報を消去する

    ld a, 2
    ld (WK_DIALOG_TYPE), a ; 情報表示タイプでダイアログを表示する
   
    ld a, 3
    ld (WK_GAMESTATUS), a  ; ダイアログ表示モードにする
    
    ld a, 10
    ld (WK_GAMESTATUS_INTTIME), a

    ; スプライトを消す
    call ClearSprite

    ld a, 1
    ld (WK_BOX_PICKUP), a

PlayerCollisionLoopEndSkipBox:

    ret
   
;---------------------------------------------
; SUB-ROUTINE:スプライトの衝突時エフェクト処理
; プレイヤーの衝突フラグが成立していたら
; スプライトの色を変更する
;---------------------------------------------
PlayerCollisionEffect:

    ld a, (WK_PLAYER_COLLISION)
    or a
    jp z, PlayerCollisionEffectNormalEnd

    ; プレイヤーの衝突処理

    ld b, $0F
    ld a, (WK_PLAYERSPRCLR1)
    cp b
    jp z, PlayerCollisionEffectSetCLRRed

    ld a, b
    ld (WK_PLAYERSPRCLR1), a
    ld (WK_PLAYERSPRCLR2), a
    ld (WK_PLAYERSPRCLR3), a

    jp PlayerCollisionEffectSetCLR

PlayerCollisionEffectSetCLRRed:

    ld a, $06

    ld (WK_PLAYERSPRCLR1), a
    ld (WK_PLAYERSPRCLR2), a
    ld (WK_PLAYERSPRCLR3), a

PlayerCollisionEffectSetCLR:

    ld hl, WK_SPRITE_MOVETBL + 4
    ld a, (WK_PLAYERSPRCLR3)
    ld (hl), a

    ld hl, WK_SPRITE_MOVETBL + 16 + 4
    ld a, (WK_PLAYERSPRCLR1)
    ld (hl), a

    ld hl, WK_SPRITE_MOVETBL + 32 + 4
    ld a, (WK_PLAYERSPRCLR2)
    ld (hl), a

    ld a, (WK_PLAYER_COLLISION)
    dec a
    ld (WK_PLAYER_COLLISION), a

    jp PlayerCollisionEffectEnd

PlayerCollisionEffectNormalEnd:

    ; 所持アイテムスプライトの情報更新
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

    ld a, (hl)  ; 剣のカラーコード
    ld (WK_PLAYERSPRCLR3), a
    inc hl
    ld a, (hl)  ; STR値
    ld (WK_VALUE04), a
    
    ; 所持アイテムスプライトの情報更新
    ; WK_EQUIP_DEFを2倍してEQUIP_DATA_DEFに加算すると
    ; アイテムデータのアドレスが取得できる

    push bc
    ld hl, EQUIP_DATA_DEF
    ld b, 0
    ld a, (WK_EQUIP_DEF)
    add a, a ; x2
    ld b, 0
    ld c, a 
    add hl, bc
    pop bc
    
    ; 防具のカラーコード
    ld a, (hl)
    ld (WK_PLAYERSPRCLR1), a

    ld a, $0B ; Yellow
    ld (WK_PLAYERSPRCLR2), a

    ld hl, WK_SPRITE_MOVETBL + 4
    ld a, (WK_PLAYERSPRCLR3)
    ld (hl), a

    ld hl, WK_SPRITE_MOVETBL + 16 + 4
    ld a, (WK_PLAYERSPRCLR1)
    ld (hl), a

    ld hl, WK_SPRITE_MOVETBL + 32 + 4
    ld a, (WK_PLAYERSPRCLR2)
    ld (hl), a

PlayerCollisionEffectEnd:

    ret
    
;---------------------------------------------
; SUB-ROUTINE:スプライトの衝突時処理
; 衝突判定テーブルを走査し
; 剣の衝突時処理を行う
; 当処理は毎フレームに実施する
;---------------------------------------------
SwordCollision:

    push af
    push bc
    push de
    push hl

    ; 剣を振っていたら剣の衝突判定を行う
    ld a, (WK_SWORDACTION_COUNT)
    or a
    jp z, SwordCollisionCheckSkip

    ; 剣を振っていれば
    ; プレイヤーのX座標、Y座標をWK_VALUE03,WK_VALUE04に
    ; セットして全テキキャラとの衝突判定を行う

    ld hl, WK_SPRITE_MOVETBL
    ld a, (hl) ; Y座標
    ld (WK_VALUE04), a

    inc hl
    ld a, (hl) ; X座標
    ld (WK_VALUE03), a

SwordCollisionCheck:

    ld de, WK_SPRITE_MOVETBL + 48

SwordCollisionCheckLoop:

    ld a, (de)
    or a ; 0x00であればループ終了
    jp z, SwordCollisionCheckSkip

    cp 10 ; ファイアボールであれば次のデータ
    jp z, SwordCollisionCheckNextData

    push de
    push hl

    ld hl, de
    ld b, 0
    ld c, $0F
    add hl, bc
    ld a, (hl)

    pop hl
    pop de

    or a  ; インターバル値が0の場合は何もしない
    jp z, SwordCollisionCheckNextData

    cp 10 ; インターバル値が10の場合は何もしない
    jp z, SwordCollisionCheckNextData

    inc de
    ld a, (de)
    or a ; Y=0(消失データ)であれば次のデータ
    jp z, SwordCollisionCheckNextData

    ld (WK_DEREGBACK), de
    ld h, d
    ld l, e
    ld a, 2
    call CheckCollisionSprite
    ld de, (WK_DEREGBACK)

SwordCollisionCheckNextData:

    ld h, d
    ld l, e

    ld b, 0
    ld c, 16

    add hl, bc

    ld d, h
    ld e, l

    jp SwordCollisionCheckLoop

SwordCollisionCheckSkip:

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------
; SUB-ROUTINE:障害物との当たり判定処理
; BレジスタとCレジスタに格納されている
; キャラクタコードの内容によって
; 障害物の当たり判定処理を行う
;
; 戻り値) Aレジスタ
;  0:当たっていない 1:当たっている
;---------------------------------------------
CheckCollisionObject:

    ld a, b
    
    ; 床のチェック
    cp $22
    jr z, CheckCollisionObjectCheckC ; B == $22

    ; 水のチェック
    cp $74
    jr z, CheckCollisionObjectCheckC ; B == $74
    cp $99
    jr z, CheckCollisionObjectCheckC ; B == $99

    ; 宝箱のチェック
    cp $88
    jr z, CheckCollisionObjectCheckC
    cp $89
    jr z, CheckCollisionObjectCheckC
    cp $8A
    jr z, CheckCollisionObjectCheckC
    cp $8B
    jr z, CheckCollisionObjectCheckC

    cp $95
    jr z, CheckCollisionObjectCheckC
    cp $96
    jr z, CheckCollisionObjectCheckC
    cp $97
    jr z, CheckCollisionObjectCheckC
    cp $98
    jr z, CheckCollisionObjectCheckC

    ; SHOPのチェック
    cp $B0
    jr z, CheckCollisionObjectCheckC
    cp $B1
    jr z, CheckCollisionObjectCheckC
    cp $B2
    jr z, CheckCollisionObjectCheckC
    cp $B3
    jr z, CheckCollisionObjectCheckC

    ; 階段のチェック

    ; 階段のチェック
    cp $64
    jr c, CheckCollisionObjectNG   ; B < $64
    cp $70
    jr nc, CheckCollisionObjectNG  ; B >= $70

CheckCollisionObjectCheckC:

    ld a, c

    ; 床のチェック
    cp $22
    jr z, CheckCollisionObjectOkay ; B == $22

    ; 水のチェック
    cp $74
    jr z, CheckCollisionObjectOkay ; B == $74
    cp $99
    jr z, CheckCollisionObjectOkay ; B == $99

    ; 宝箱のチェック
    cp $88
    jr z, CheckCollisionObjectOkay
    cp $89
    jr z, CheckCollisionObjectOkay
    cp $8A
    jr z, CheckCollisionObjectOkay
    cp $8B
    jr z, CheckCollisionObjectOkay

    cp $95
    jr z, CheckCollisionObjectOkay
    cp $96
    jr z, CheckCollisionObjectOkay
    cp $97
    jr z, CheckCollisionObjectOkay
    cp $98
    jr z, CheckCollisionObjectOkay

    ; SHOPのチェック
    cp $B0
    jr z, CheckCollisionObjectOkay
    cp $B1
    jr z, CheckCollisionObjectOkay
    cp $B2
    jr z, CheckCollisionObjectOkay
    cp $B3
    jr z, CheckCollisionObjectOkay

    ; 階段のチェック
    cp $64
    jr c, CheckCollisionObjectNG   ; B < $64
    cp $70
    jr nc, CheckCollisionObjectNG  ; B >= $70

    jr CheckCollisionObjectOkay

CheckCollisionObjectNG:

    ld a, 1
    jr CheckCollisionObjectEnd

CheckCollisionObjectOkay:

    ld a, 0

CheckCollisionObjectEnd:

    ret

