;---------------------------------------------
; 魔法（マジックミサイル）処理
;
; 仕様
;   初期作成時にはWK_SPRITE_MOVETBLの種別が00Hの
;   場所を探し、その場所をテーブルとして使う
;   消失時にはY座標とカラーをゼロクリアする
;---------------------------------------------
CreateMagicMissile:

    ; WK_SPRITE_MOVETBLの空いてる場所を
    ; 検出する
    xor a ; Set Carry=0

    ld hl, WK_SPRITE_MOVETBL
    ld d, 0
    ld e, 16
    sbc hl, de ; 16バイト減らしておく
    
CreateMagicMissileLoop:

    add hl, de
    ld a, (hl)
    or a ; NULL Valueを検知
    jp z, CreateMagicMissileLoopEnd

    ; 種別が10で、なおかつY座標が0であれば
    ; 消失データなので、そのテーブルを使う
    cp 10
    jp nz, CreateMagicMissileLoop

    inc hl
    ld a, (hl) ; Y座標を取得
    dec hl
    or a
    jp nz, CreateMagicMissileLoop

    ; 空いてる場所を検出

    ; マジックミサイルのデータを作成する

CreateMagicMissileLoopEnd:

    ld (WK_HLREGBACK), hl

    ; X移動量、Y移動量の初期化
    ld a, $FF
    ld (WK_VALUE07), a ; X,Y移動方向 1であればX方向に移動

    ; テキキャラレベルをワーク変数WK_VALUE01にセットする
    ld a, (ix + $0E)
    ld (WK_VALUE01), a

    ld a, 10
    ld (hl), a ; + 0 種別コード(10=ファイアボール)

    ; 初期XY座標はテキキャラのY座標と同じとする
    inc hl
    ld a, (ix + 1)
    ld (hl), a ; + 1 Y座標

    inc hl
    ld a, (ix + 2)
    ld (hl), a ; + 2 X座標

    ; ファイアボールの発射方向を決める
    ; スライムLV#3,スライムLV#4の場合は進行方向と逆にする
    ; ウイザードの場合は進行方向と同じとする

    ld bc, hl ; HLレジスタの値をBCレジスタに退避

    ld a, (ix + 0)
    cp 1
    jp z, CreateMagicMissileSetSlimeDist
    cp 3
    jp z, CreateMagicMissileSetWizardDist

CreateMagicMissileSetWizardDist:

    ; ウイザードの移動量を決定する
    ld hl, FIREBALL_MOVESIZE_WIZARD
    jp CreateMagicMissileSetDist

CreateMagicMissileSetSlimeDist:

    ; スライムの移動量を決定する
    ld hl, FIREBALL_MOVESIZE_SLIME

CreateMagicMissileSetDist:

    ld a, (WK_VALUE01) ; テキキャラのレベル値
    ld d, 0
    ld e, a
    add hl, de         ; レベルに応じた値のアドレスを取得
    ld a, (hl)
    ld (WK_VALUE03), a ; ワーク変数WK_VALUE03に移動量をセットする
    ld hl, bc ; 退避したHLレジスタの値を復帰

    ; 種別によって進行方向を決定する
    ; スライム；進行方向とは逆方向に発射
    ; ウイザード：進行方向と同じ方向に発射

    ld a, (ix + 0)
    cp 1
    jp z, CreateMagicMissileSetDistSlime

    jp CreateMagicMissileSetDistWizard

CreateMagicMissileSetDistSlime:

    ld a, (ix + 5)
    cp 1
    jp z, CreateMagicMissileSlimeUp
    cp 3
    jp z, CreateMagicMissileSlimeRight
    cp 5
    jp z, CreateMagicMissileSlimeDown
    cp 7
    jp z, CreateMagicMissileSlimeLeft

    jp CreateMagicMissileEnd

CreateMagicMissileSlimeRight:

    ld a, 1
    ld (WK_VALUE07), a ; X方向に移動

    ld a, 3 ; 進行方向は右とする
    ld de, ENEMY_PTN_FIREBALL + 3

    jp CreateMagicMissileSetPattern

CreateMagicMissileSlimeDown:

    ld a, 2
    ld (WK_VALUE07), a ; Y方向に移動

    ld a, 5 ; 進行方向は下とする
    ld de, ENEMY_PTN_FIREBALL + 5

    jp CreateMagicMissileSetPattern

CreateMagicMissileSlimeLeft:

    ld a, 1
    ld (WK_VALUE07), a ; X方向に移動

    ld a, 7 ; 進行方向は左とする
    ld de, ENEMY_PTN_FIREBALL + 7

    jp CreateMagicMissileSetPattern

CreateMagicMissileSlimeUp:

    ld a, 2
    ld (WK_VALUE07), a ; Y方向に移動

    ld a, 1 ; 進行方向は上とする
    ld de, ENEMY_PTN_FIREBALL + 1

    jp CreateMagicMissileSetPattern

CreateMagicMissileSetDistWizard:

    ld a, 0
    ld (WK_VALUE07), a

    ; 進行方向はウイザードの進行方向と同じとする
    ld a, (ix + 5)
    cp 1
    jp z, CreateMagicMissileSetDistWizardY
    cp 5
    jp z, CreateMagicMissileSetDistWizardY

    jp CreateMagicMissileSetDistWizardX

CreateMagicMissileSetDistWizardX:

    ld a, 1
    ld (WK_VALUE07), a
    jp CreateMagicMissileSetDistWizardPtn
    
CreateMagicMissileSetDistWizardY:

    ld a, 2
    ld (WK_VALUE07), a
    
CreateMagicMissileSetDistWizardPtn:
    
    ld a, (ix + 5)
    ld de, ENEMY_PTN_FIREBALL
    ld h, d
    ld l, e
    ld d, 0
    ld e, a
    add hl, de
    ld d, h
    ld e, l
 
    ld h, b
    ld l, c ; 退避したHLレジスタの値を復帰

CreateMagicMissileSetPattern:

    ; 進行方向をワーク変数WK_VALUE02にセットする
    ld (WK_VALUE02), a

    ; スプライトパターン番号
    ld a, (de)

    inc hl
    ld (hl), a ; +3 スプライトパターン番号

    ; ファイアボールの色はテキキャラの色と同じとする
    ; ただし、透明色であれば白で表示する(LV4対応)
    
    inc hl
    ld a, (ix + 4)    ; +4 スプライトカラー番号
    or a
    jp nz, CreateMagicMissileSetPatternNotLV4
    ld a, $0F

CreateMagicMissileSetPatternNotLV4:

    ld (hl), a

    inc hl
    ld a, (WK_VALUE02)
    ld (hl), a        ; +5 移動方向

    ; ファイアボールの移動量は
    ;   スライムLV#3 10
    ;   スライムLV#4 14
    ;   ウイザードLV#1 6
    ;   ウイザードLV#2 10
    ;   ウイザードLV#3 14
    ;   ウイザードLV#4 18

    ld a, (WK_VALUE07) ; X方向に移動する場合は1がセットされている
    cp 1
    jp nz, CreateMagicMissileSetY

    ld a, (WK_VALUE03)

    inc hl
    ld (hl), a         ; +6 X移動量

    inc hl             ; +7 Y移動量

    jp CreateMagicMissileSetOffenceValue

CreateMagicMissileSetY:

    ld a, (WK_VALUE03)
    inc hl             ; +6 X移動量

    inc hl
    ld (hl), a         ; +7 Y移動量

CreateMagicMissileSetOffenceValue:   

    ; 攻撃力はテキキャラと同じとする
    ; ただしLV=5（ラスボス）の場合は
    ; 4倍にする
    inc hl
    ld a, (ix + 8)
    ld b, a
    ld a, (WK_VALUE01)
    cp 5
    jr nz, CreateMagicMissileSetOffenceValueNotLv5

    sla a
    sla a
    ld b, a
    jr CreateMagicMissileSetOffenceValueSetSTR

CreateMagicMissileSetOffenceValueNotLv5:

    ld b, a

CreateMagicMissileSetOffenceValueSetSTR:
    ld (hl), a         ; +8 攻撃力

    ; 防御力、生命力は0とする
    inc hl
    xor a
    ld (hl), a         ; +9 防御力
    inc hl
    ld a, $80
    ld (hl), a         ; +A 生命力

    ; 弾発射状態アドレスに発射元となる
    ; テキキャラのテーブルの先頭位置をセットする
    ; TODO: とりあえずWK_DEREGBACK変数を使う・・
    inc hl
    ld (WK_DEREGBACK), ix
    ld de, (WK_DEREGBACK)
    ld (hl), e
    inc hl
    ld (hl), d

    ; アイテムドロップ確率は0とする
    inc hl
    ld (hl), a         ; +D アイテムドロップ確率

    ; レベルをセットする
    inc hl
    ld a, (WK_VALUE01)
    ld (hl), a         ; =E ファイアボールのレベル

    ; 移動インターバルをセットする
    inc hl
    ld a, 1            ; ファイアボールの速度は2/60秒
    ld (hl), a

CreateMagicMissileEnd:

    ; SFXを鳴らす
    ; 効果音：弾の発射音を鳴らす

    ld a,$08 ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ; HLレジスタにファイアボールのアドレスを
    ; セットして返却する
    ld hl, (WK_HLREGBACK)

    ret

;---------------------------------------
; ファイアボール処理
; ファイアボールは障害物を貫通する
;---------------------------------------
MoveMagicMissile:

    ; WK_HLREGBACKにはキャラクター1体分の
    ; WK_SPRITEMOVE_TBLの先頭アドレスがセットされて
    ; 呼び出されてくる

    ld hl, (WK_HLREGBACK)

    ; 消失しているファイアボールであれば何も処理しない
    ; ファイアボール消失時にはY座標とカラーが0になる
    inc hl ; +1
    ld a, (hl)
    or a
    jp z, MoveMagicMissileMoveEnd

    ;---------------------------------------
    ; テキキャラ移動の共通処理を呼び出す
    ; マジックミサイルの場合、消失したら
    ; 再生成は行わない
    ;---------------------------------------
    ld de, WK_ENEMY_RESPAWN
    ld hl, MoveEnemyCommonBusterdNextData
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    call MoveEnemyCommonProc

MoveMagicMissileMoveEnd:

    ; ファイアボール消失時はファイアボールアドレスを
    ; 0にする

    ; 次のテキキャラのポインタまでアドレスを進める
    ld hl, (WK_HLREGBACK)

    ld d, 0
    ld e, 16
    add hl, de
    ld (WK_HLREGBACK), hl

    jp MoveEnemyLoop
