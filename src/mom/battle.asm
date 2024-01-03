;---------------------------------------------
; 戦闘処理
;
; テキキャラとの戦闘処理
; ・ダメージ計算処理
; ・メッセージ表示(HIT! or MISS!)
; ・テキキャラのステータス表示域表示
; ・テキキャラ消滅処理
; ・アイテムドロップ処理
; ・Playerのレベルアップ処理
;---------------------------------------------

;-------------------------------------
; SUB-ROUTINE: BattleCalculateDamage
; ダメージ計算処理を行う
; 算出したダメージをAレジスタにセットして
; 返却する
;
; ■INPUT
; DE : 甲のアドレス（テキキャラ）
; HL : 乙のアドレス（プレイヤー）
;
; ■計算式
; x = (プレイヤーの攻撃力 - テキキャラの防御力）+ RND(0-3)
; y = (テキキャラの攻撃力 - プレイヤーの防御力) + RND(0-3)
; z = x - y
; ※RNDの値が攻撃力を超えることはない
;
; z>0: プレイヤー勝利
; z<0: プレイヤー敗北
; Aレジスタにzの値をセットしてRETする
;-------------------------------------
BattleCalculateDamage:

    push bc

    ; WK_VALUE03 からは使って良い変数

    ; WK_VALUE03 : 乙の攻撃力
    ; WK_VALUE04 : 乙の防御力
    ; WK_VALUE05 : 甲の攻撃力
    ; WK_VALUE06 : 甲の防御力
    ; WK_VALUE07 : 乙のポイント
    ; WK_VALUE08 : 甲のポイント

    ; テキキャラが弾の場合は
    ; 無条件にテキキャラの攻撃力だけダメージとする
    ld b, 0
    ld c, 8

    ld a, (de)
    cp 10 ; Fireball ?
    jp z, BattleCalculateDispEnemyForceWin

    add hl, bc
    ld a, (hl)  ; +8 : 乙の攻撃力
    ld (WK_VALUE03), a

    inc hl
    ld a, (hl)  ; +9 : 乙の防御力
    ld (WK_VALUE04), a

    ld hl, de
    add hl, bc
    ld a, (hl)  ; +8 : 甲の攻撃力
    ld (WK_VALUE05), a

    inc hl
    ld a, (hl)  ; +9 : 甲の防御力
    ld (WK_VALUE06), a

    ; RINGを装備していたらRINGの効果を付与する
    ; ただし、ラスボスには無効とする
    push hl
    ld hl, de
    ld b, 0
    ld c, 14
    add hl, bc
    ld a, (hl)
    pop hl
DEBUG_STOP:
    cp 5 ; LV=5はラスボスのみ
    jr z, BattleCalculateEffectEnd

    ld a, (WK_EQUIP_RING)
    cp 1
    jr z, BattleCalculateEffectPower
    cp 2
    jr z, BattleCalculateEffectFire

    jr BattleCalculateEffectEnd

BattleCalculateEffectPower:

    ; POWER RING
    ; ダメージを1.5倍する
    ld a, (WK_VALUE03)
    ; 右に1ビットシフトした結果に元の値を加算すると1.5倍になる
    ld b, a
    srl a
    add a, b

    ld (WK_VALUE03), a

    jr BattleCalculateEffectEnd

BattleCalculateEffectFire:

    ; FIRE RING
    ; 甲の種別がWOODYかスケルトンであれば攻撃力を2倍にする
    ld a, (de)
    cp 4
    jp z, BattleCalculateEffectFire2
    cp 5
    jp z, BattleCalculateEffectFire2
    
    jp BattleCalculateEffectEnd

BattleCalculateEffectFire2:

    ld a, (WK_VALUE03)
    sla a
    ld (WK_VALUE03), a

BattleCalculateEffectEnd:

    ; ダメージ計算
    ; ポイント=((乙の攻撃力-甲の防御力)+RND(4))-((甲の攻撃力-乙の防御力)+RND(4))

    ld a, (WK_VALUE06) ; 甲の防御力
    ld b, a
    ld a, (WK_VALUE03) ; 乙の攻撃力
    sub b

BattleCalculateSetOtuPoint:

    ld (WK_VALUE07), a ; 乙のポイント（ダイス振る前）

    ; ポイントがマイナスであれば0にする
    call RandomValue

    ; Aレジスタの値に00000011BをANDして0-3の数値にする
    and 00000011B
    ld b, a
    ld a, (WK_VALUE07)

    add a, b           ; 乙のポイント（ダイス結果を加算）
    ld (WK_VALUE07), a


    ld a, (WK_VALUE04) ; 乙の防御力
    ld b, a
    ld a, (WK_VALUE05) ; 甲の攻撃力
    sub b

BattleCalculateSetKouPoint:

    ld (WK_VALUE08), a ; 甲のポイント（ダイス振る前）

    call RandomValue

    ; Aレジスタの値に00000011BをANDして0-3の数値にする
    and 00000011B
    ld b, a
    ld a, (WK_VALUE08)
    add a, b           ; 甲のポイント（ダイス結果を加算）
    ld (WK_VALUE08), a

    ; A = WK_VALUE07 - WK_VALUE08
    ld b, a
    ld a, (WK_VALUE07)
    sub b ; A = WK_VALUE07 - WK_VALUE08

    ld (WK_VALUE07), a ; ダメージ計算結果をWK_VALUE07にセットする

    ld hl, WK_VIRT_PTNNAMETBL + 1 + 32
    ld bc, 18
    ld  a, $20
    call MemFil

    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32
    ld bc, 11
    ld  a, $20
    call MemFil

    ld a, (WK_VALUE07)
    cp $80
    jp c, BattleCalculateDispPlayerWin

    jp BattleCalculateDispEnemyWin

BattleCalculateDispEnemyForceWin:

    ; テキキャラが弾の場合は強制的にプレイヤーへの
    ; ダメージとなる
    ld hl, de
    add hl, bc
    ld a, (hl)
    neg a
    ld (WK_VALUE07), a

BattleCalculateDispEnemyWin:

    ; プレイヤーが被ダメージ
    ; 剣の場合は確率によって被ダメージを受ける
    ; 確率：26/256
    ld b, a

    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    cp $FE
    jr z, BattleCalculateDispSwordJudge

    jr BattleCalculateDispEnemyWinNotSword

BattleCalculateDispSwordJudge:

    ; 剣の場合は確率を算出する
    call RandomValue
    cp 26
    jr nc, BattleCalculateDispPlayerSwordLose

BattleCalculateDispEnemyWinNotSword:

    ld a, b
    neg
    ld (WK_NUMTOCHARVAL), a

    call NumToStr
    ld de, WK_VIRT_PTNNAMETBL + 1 + 32
    ld hl, WK_NUMTOCHAR
    ld bc, 3
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 4 + 32
    ld hl, MESSAGE_DAMAGE
    ld bc, 7
    call MemCpy

    jp BattleCalculateDispEnd

BattleCalculateDispPlayerSwordLose:

    ; 剣使用時に負けた場合は確率によって
    ; 引き分けとする
    xor a
    ld (WK_VALUE07), a
    jp BattleCalculateDispPlayerMisstake

BattleCalculateDispPlayerWin:

    ; テキキャラが被ダメージ
    ld (WK_NUMTOCHARVAL), a

    or a
    jp z, BattleCalculateDispPlayerMisstake

    call NumToStr
    ld de, WK_VIRT_PTNNAMETBL + 22 + 32
    ld hl, WK_NUMTOCHAR
    ld bc, 3
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 25 + 32
    ld hl, MESSAGE_HIT
    ld bc, 4
    call MemCpy

    jp BattleCalculateDispEnd

BattleCalculateDispPlayerMisstake:

    ld de, WK_VIRT_PTNNAMETBL + 22 + 32
    ld hl, MESSAGE_MISSTAKE
    ld bc, 4
    call MemCpy

BattleCalculateDispEnd:

    ld a, (WK_VALUE07)

    pop bc

    ret

;-------------------------------------------------
; SUB-ROUTINE:プレイヤーのライフゲージを表示する
; 仮想パターンネームテーブルに表示情報をセットする
;-------------------------------------------------
BattleDispLifeGuage:

    push af
    push bc
    push de
    push hl
    
    ld hl, WK_VIRT_PTNNAMETBL + 1 + 32 + 32 ; 表示位置
    ld bc, 10 ; ハート10個分をスペースで塗りつぶす
    ld  a, $20
    call MemFil
    
    ld hl, WK_PLAYERLIFEPOINT
    ld de, WK_VIRT_PTNNAMETBL + 1 + 32 + 32
    ld b, 10
    
BattleDispLifeGuageLoop:

    ld a, (hl)
    and a
    jr z, BattleDispLifeGuageLoopEnd
    
    ; ハートゲージの文字列を特定する
    add a, $24
    ld (de), a
    
    inc hl
    inc de

    djnz BattleDispLifeGuageLoop

    ld a, 1
    ld (WK_REDRAW_FINE), a

BattleDispLifeGuageLoopEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;-------------------------------------
; SUB-ROUTINE: BattleDispEnemyStatus
; テキキャラのステータス表示
; テキキャラのスプライトと
; 生命力をハートゲージで表示する
;
; 表示する情報は衝突判定テーブルの
; 1レコード目のみとする
; 甲のアドレスがテキキャラではない場合は
; 次のレコードを採用する
;
;-------------------------------------
BattleDispEnemyStatus:

    push af
    push bc
    push de
    push hl
    
    ; テキキャラ情報を画面に表示する
    
    ; テキキャラステータス表示欄に表示する
    ; スプライト情報のデータを初期化

    ; 衝突判定テーブルをチェックする
    ld de, WK_COLLISION_TBL

    ; 各種変数を初期化
    ld (WK_VALUE01), a
    ld (WK_VALUE02), a
    ld (WK_VALUE03), a
    ld (WK_VALUE04), a
    ld (WK_VALUE05), a
    ld (WK_VALUE06), a
    ld (WK_VALUE07), a

    ld a, 20
    ld (WK_VALUE01), a

    xor a
    ld (WK_ENEMYLIFEVAL), a

BattleDispEnemyStatusSearchLoop:

    ld (WK_DEREGBACK), de

    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
    ld b, 0
    ld c, 0 
    or a ; ZERO TO CY
    sbc hl, bc

    ; 甲のアドレスが$0000なら次のデータを探す
    jp z, BattleDispEnemyStatusSearchNextData

    ld (WK_HLREGBACK), hl

    ld a, (hl)

    cp $E0 ; 消失データはスキップ（動かさない）
    jp z, BattleDispEnemyStatusSearchNextData

    ; 甲の種別コードがテキキャラでなければ
    ; 次のデータを探す
    cp 10
    jp nc, BattleDispEnemyStatusSearchNextData

    ; 種別コードが10以上はプレイヤーかテキの弾となる
    ld hl, (WK_HLREGBACK)

    ; テキキャラが見つかった
    ld (WK_VALUE03), a ; テキキャラの種別コード
    
    ld a, 1
    ld (WK_ENEMY_COLLISION), a

    ; テキキャラのスプライト番号とカラーを取得する　
    inc hl ; +1 : Y座標
    inc hl ; +2 : X座標
    inc hl ; +3 : パターン番号
    ld a, (hl)
    ld (WK_VALUE04), a

    inc hl ; +4 : カラー番号
    ld a, (hl)
    ld (WK_VALUE06), a

    ld a, (WK_VALUE03)
    cp 3
    jr z, BattleDispEnemyStatusSetSpr2
    cp 4
    jr z, BattleDispEnemyStatusSetSpr2
    cp 5
    jr z, BattleDispEnemyStatusSetSpr2

    jr BattleDispEnemyStatusSetSprNoWiz

BattleDispEnemyStatusSetSpr2:

    ; 種別がウイザード、WOODY MONSTER、スケルトンであれば
    ; 2枚目のスプライトの情報もセットする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 19
    add hl, bc
    ld a, (hl)
    ld (WK_VALUE05), a ; +19 2枚目のパターン番号
    inc hl             ; +20 2枚目の+4
    ld a, (hl)
    ld (WK_VALUE07), a ; +20 2枚目のカラー番号

BattleDispEnemyStatusSetSprNoWiz:

    ld hl, (WK_HLREGBACK)

    ld b, 0
    ld c, $0A
    add hl, bc
    ld a, (hl) ; +10 : テキの体力

    ; テキキャラ消去の判定のためWK_ENEMYLIFEVALにテキキャラの
    ; 体力値をセットする
    ld (WK_ENEMYLIFEVAL), a

    jp BattleDispEnemyStatusSearchLoopEnd

BattleDispEnemyStatusSearchNextData:

    ld a, (WK_VALUE01)
    dec a
    ld (WK_VALUE01), a

    or a
    jp z, BattleDispEnemyStatusSearchNoCollision

    ld de, (WK_DEREGBACK)
    inc de ; +1
    inc de ; +2
    inc de ; +3
    inc de ; +4
    inc de ; +5 <= 次のデータ

    jp BattleDispEnemyStatusSearchLoop

BattleDispEnemyStatusSearchNoCollision:

    ; 衝突していない

    xor a
    ld (WK_ENEMY_COLLISION), a ; 衝突判定フラグをクリア

    jp BattleDispEnemyStatusAlived

BattleDispEnemyStatusSearchLoopEnd:

    ;
    ; テキキャラステータス表示域に
    ; 表示する
    ; スプライト番号は#30と#31を使う
    ;

    ld hl, WK_SPRITE_MOVETBL + 30 * 16
    ld bc, 32
    ld a, 0
    call MemFil

    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32 + 32
    ld bc, 11
    ld a, $20
    call MemFil
    
    ld hl, WK_ENEMYLIFEPOINT
    ld de, WK_VIRT_PTNNAMETBL + 22 + 32 + 32
    ld b, 7 ; テキのハートマークの最大値は7

BattleDispEnemyLifeGuageLoop:

    ld a, (hl)
    cp 1
    jp c, BattleDispEnemyLifeGuageLoopEnd
   
    ; ハートゲージの文字列を特定する
    add a, $80
    ld (de), a
   
    inc hl
    inc de
    djnz BattleDispEnemyLifeGuageLoop

    ld a, 1
    ld (WK_REDRAW_FINE), a

BattleDispEnemyLifeGuageLoopEnd:

    ; WK_SPRITE_MOVETBLにテキキャラの情報を
    ; セットする
    ; WK_VALUE04, WK_VALUE05: スプライト番号
    ; WK_VALUE06, WK_VALUE07: カラー番号

    ; スプライト番号#30のポジションにセット
    ld hl, WK_SPRITE_MOVETBL + 30 * 16

    ; 1枚目
    inc hl     ; 種別コード
    ld a, 8
    ld (hl), a ; Y座標
    inc hl
    ld a, 20 * 8
    ld (hl), a ; X座標
    inc hl
    ld a, (WK_VALUE04)
    ld (hl), a ; パターン番号
    inc hl
    ld a, (WK_VALUE06)
    ld (hl), a ; カラー番号

    ; WK_SPRITE_MOVETBL の +5 - +15はスキップ
    ld b, 0
    ld c, 12
    add hl, bc

    ld a, (WK_VALUE03)
    cp 3
    jr z, BattleDispEnemyStatus2Spites
    cp 4
    jr z, BattleDispEnemyStatus2Spites
    cp 5
    jr z, BattleDispEnemyStatus2Spites

    jr BattleDispEnemyStatusEnd

BattleDispEnemyStatus2Spites:

    ; 2枚目
    inc hl
    ld a, 8
    ld (hl), a ; Y座標
    inc hl
    ld a, 20 * 8
    ld (hl), a ; X座標
    inc hl
    ld a, (WK_VALUE05)

    ld (hl), a ; パターン番号
    inc hl
    ld a, (WK_VALUE07)
    ld (hl), a ; カラー番号

BattleDispEnemyStatusEnd:

    ld a, (WK_ENEMYLIFEVAL)
    or a
    jp nz, BattleDispEnemyStatusAlived

    ; スプライト1枚目を消去する
    ; スプライトアトリビュートに対応するデータのみ消去する

    ld hl, (WK_HLREGBACK)
    ld a, (hl)

    ld d, a
    ld a, $E0
    ld (hl), a
    inc hl ; +1 : Y
    inc hl ; +2 : X
    inc hl ; +3 : パターン番号
    ld a, 184
    ld (hl), a ; +3 パターン番号
    inc hl ;
    ld a, $0B
    ld (hl), a ; +4 カラー番号

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, $0F
    add hl, bc
    ld (hl), 10 ; インターバル
    
    ld a, d
    cp 3 ; Wizard ?
    jp z, BattleDispEnemyStatusRemove2Sprite
    cp 4 ; WOODY ?
    jp z, BattleDispEnemyStatusRemove2Sprite
    cp 5 ; Skelton ?
    jp z, BattleDispEnemyStatusRemove2Sprite

    jr BattleDispEnemyStatusRemoveSprite

BattleDispEnemyStatusRemove2Sprite:

    ; 2枚目を消去する
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 16
    add hl, bc

    ld a, $E0
    ld (hl), a
    inc hl ; +1 : Y
    ld a, 209
    ld (hl), a
    xor a
    inc hl ; +2 : X
    ld (hl), a
    inc hl ; +3 : パターン番号
    ld (hl), a
    inc hl ; +4 : パターン番号
    ld (hl), a

BattleDispEnemyStatusRemoveSprite:

    ; 倒したテキキャラの種別を退避する
    ld a, d
    ld (WK_BUSTERD_ENEMY_TYPE), a

    ; アイテムドロップ処理を呼び出す
    call DropItem

    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32
    ld bc, 11
    ld a, $20
    call MemFil

    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32 + 32
    ld bc, 11
    ld a, $20
    call MemFil
    
    ld hl, WK_SPRITE_MOVETBL + 30 * 16
    inc hl ; Y
    ld a, 209
    ld (hl), a
    ld bc, 15
    ld a, 0
    call MemFil

    ld hl, WK_SPRITE_MOVETBL + 31 * 16
    inc hl ; Y
    ld a, 209
    ld (hl), a
    ld bc, 15
    ld a, 0
    call MemFil

BattleDispEnemyStatusAlived:

    pop hl
    pop de
    pop bc
    pop af

    ret

;--------------------------------------
; SUB-ROUTINE: BattleAddMissionStatus
; ミッションステータスバーを表示する
; WK_VALUE03：テキキャラの種別コード
; WK_VALUE04：テキキャラのレベル
;--------------------------------------
BattleAddMissionStatus:

    ld a, (WK_PLAYERLIFEMAX)

    cp 14 ; 現時点はLV=1 -> 2 ?
    jp z, BattleAddMissionStatusLV1
    cp 21 ; 現時点はLV=2 -> 3 ?
    jp z, BattleAddMissionStatusLV2
    cp 28 ; 現時点はLV=3 -> 4 ?
    jp z, BattleAddMissionStatusLV3
    cp 35 ; 現時点はLV=4 -> 5 ?
    jp z, BattleAddMissionStatusLV4
    cp 42 ; 現時点はLV=5 -> 6 ?
    jp z, BattleAddMissionStatusLV5
    cp 49 ; 現時点はLV=6 -> 7 ?
    jp z, BattleAddMissionStatusLV6
    cp 56 ; 現時点はLV=7 -> 8 ?
    jp z, BattleAddMissionStatusLV7

    jp BattleAddMissionStatusEnd

BattleAddMissionStatusLV1:

    ; スライムLV1またはウイスプLV1であればステータスをインクリメントする
    ld a, (WK_VALUE03)
    cp 3
    jp nc, BattleAddMissionStatusEnd

    ld a, (WK_VALUE04)
    cp 1
    jp nz, BattleAddMissionStatusEnd

    jp BattleAddMissionStatusIncStatus

BattleAddMissionStatusLV2:

    ; スライムLV2またはウイスプLV2であればステータスをインクリメントする
    ld a, (WK_VALUE03)
    cp 3
    jp nc, BattleAddMissionStatusEnd

    ld a, (WK_VALUE04)
    cp 2
    jp nz, BattleAddMissionStatusEnd

    jp BattleAddMissionStatusIncStatus

BattleAddMissionStatusLV3:

    ; スライムLV3またはウイスプLV3であればステータスをインクリメントする
    ld a, (WK_VALUE03)
    cp 3
    jp nc, BattleAddMissionStatusEnd

    ld a, (WK_VALUE04)
    cp 3
    jp nz, BattleAddMissionStatusEnd

    jp BattleAddMissionStatusIncStatus

BattleAddMissionStatusLV4:

    ; ウイザードLV1であればステータスをインクリメントする
    ld a, (WK_VALUE03)
    cp 3
    jp nz, BattleAddMissionStatusEnd

    ld a, (WK_VALUE04)
    cp 1
    jp nz, BattleAddMissionStatusEnd

    jp BattleAddMissionStatusIncStatus

BattleAddMissionStatusLV5:

    ; ウイザードLV2であればステータスをインクリメントする
    ld a, (WK_VALUE03)
    cp 3
    jp nz, BattleAddMissionStatusEnd

    ld a, (WK_VALUE04)
    cp 2
    jp nz, BattleAddMissionStatusEnd

    jp BattleAddMissionStatusIncStatus

BattleAddMissionStatusLV6:

    ; ウイザードLV3であればステータスをインクリメントする
    ld a, (WK_VALUE03)
    cp 3
    jp nz, BattleAddMissionStatusEnd

    ld a, (WK_VALUE04)
    cp 3
    jp nz, BattleAddMissionStatusEnd

    jp BattleAddMissionStatusIncStatus

BattleAddMissionStatusLV7:

    ; LV4のテキであればステータスをインクリメントする
    ld a, (WK_VALUE04)
    cp 4
    jp nz, BattleAddMissionStatusEnd

BattleAddMissionStatusIncStatus:

    ld a, (WK_MISSION_STATUSVAL)
    cp 10
    jp z, BattleAddMissionStatusIncStatusSetVal

    inc a

BattleAddMissionStatusIncStatusSetVal:

    ld (WK_MISSION_STATUSVAL), a

BattleAddMissionStatusEnd:

    ret

;--------------------------------------
; SUB-ROUTINE: BattleDispMissionStatus
; ミッションステータスバーを表示する
;--------------------------------------
BattleDispMissionStatus:

    push bc
    push hl

    ld hl, WK_VIRT_PTNNAMETBL + 23 * 32 + 21
    ld b, 0
    ld c, 10
    ld a, $20
    call MemFil

    ld a, (WK_MISSION_STATUSVAL)
    cp 1
    jp c, BattleDispMissionStatusEnd
    
    ld b, 0
    ld c, a
    ld hl, WK_VIRT_PTNNAMETBL + 23 * 32 + 21
    ld a, $5B
    call MemFil

BattleDispMissionStatusEnd:

    pop hl
    pop bc

    ret

;--------------------------------------
; SUB-ROUTINE: BattleDispLevelUp
; ミッション(レベルアップ)判定を行う 
;--------------------------------------
BattleDispLevelUp:

    push bc
    push de
    push hl

    ld a, (WK_MISSION_STATUSVAL)
    cp 10
    jp nz, BattleDispLevelUpEnd

    ld a, (WK_PLAYERLIFEMAX)
    ld b, 7
    add a, b

    ld (WK_PLAYERLIFEMAX), a
    ld (WK_PLAYERLIFEVAL), a

    ld de, WK_VIRT_PTNNAMETBL + 23 * 32 + 21
    ld hl, MESSAGE_LEVELUP
    ld bc, 10
    call MemCpy

    xor a
    ld (WK_PLAYERLIFESUM), a
    ld (WK_MISSION_STATUSVAL), a

    ; プレイヤーのライフを再表示する
    call AddLifeGuage
    call BattleDispLifeGuage

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0F ; SOUND EFFECT NUMBER 
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT
    
BattleDispLevelUpEnd:

    pop hl
    pop de
    pop bc

    ret
