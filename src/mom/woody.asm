;--------------------------------------------
; SUB-ROUTINE: MoveEnemyWoody
; WOODY MONSTERの移動処理
;--------------------------------------------
MoveEnemyWoody:

    ld hl, (WK_HLREGBACK)
    inc hl ; Y
    inc hl ; X
    inc hl ; パターン番号

    ; 2枚目のスプライト(スプライト番号192)は処理しない
    ld a, (hl)
    cp 192
    jp z, MoveWoodyEndNextData

MoveWoodyProc:

    ; LV#1
    ; 緑WOODY MONSTER
    ; 攻撃力1 防御力1
    ; プレイヤーの方向にめがけてくる
    ; 最大距離8

    ; LV#2
    ; 緑WOODY MONSTER
    ; 攻撃力2 防御力1
    ; プレイヤーの方向にめがけてくる
    ; 最大距離6

    ; LV#3
    ; 濃赤WOODY MONSTER
    ; 攻撃力2 防御力2
    ; プレイヤーの方向にめがけてくる
    ; 最大距離4

    ; LV#4
    ; 白WOODY MONSTER
    ; 攻撃力3 防御力2
    ; プレイヤーの方向にめがけてくる
    ; 最大距離2

    ; LV4のWOODY MONSTERで、なおかつ
    ; 透視のリングがある場合
    ; スプライトカラーを白にする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, $0E      ; +14 : テキキャラのレベル
    add hl, bc
    cp 4
    jp nz, MoveWoodyNotLV4

    ld hl, (WK_HLREGBACK)
    ld a, $00
    ld b, 0
    ld c, 4
    add hl, bc
    ld (hl), a     ; +4 : カラー番号

MoveWoodyNotLV4:

    ;---------------------------------------
    ; テキキャラ移動の共通処理を呼び出す
    ;---------------------------------------
    ld de, WK_ENEMY_RESPAWN
    ld hl, MoveWoodyResetMoveInfo
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    call MoveEnemyCommonProc

MoveWoodyEndNextData:

    jp MoveEnemyNextDataAddCounter

;-------------------------------------------------------
; SUB-ROUTINE: MoveWoodyResetMoveInfo
; WOODY MONSTERの移動方向と移動量をリセットする
;-------------------------------------------------------
MoveWoodyResetMoveInfo:

    push hl

    ld hl, (WK_HLREGBACK)
    push hl
    ld b, 0
    ld c, 14
    add hl, bc
    ld a, (hl)
    pop hl

    ; 移動量を決める
    ; 10 - (テキキャラのレベル*2)が移動量
    ; LV1 = 10 - 1*2 = 8
    ; LV2 = 10 - 2*2 = 6
    ; LV3 = 10 - 3*2 = 4
    ; LV4 = 10 - 4*2 = 2

    add a, a ; x2
    ld b, a
    ld a, 10
    sub b
    ld (WK_VALUE01), a ; 移動量

MoveWoodyResetMoveInfoInit:

    ; 移動方向と移動量を初期化する
    ; WOODY MONSTERの移動方向は
    ; プレイヤーの方向に向かってくる
    ; ただし、移動方向のリセット時には
    ; 乱数を発生させ、乱数が127以下であれば
    ; ランダムに移動させる

    ; 次の方向を決める
    call MoveWoodyGetNextVect
    ld a, (WK_VALUE02)

MoveWoodyResetMoveInfoInitSetVect:

    cp 1
    jp z, MoveWoodyDataSetDistY
    cp 5
    jp z, MoveWoodyDataSetDistY

MoveWoodyDataSetDistX:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a  ; +6 X移動量
    
    jp MoveWoodyResetMoveInfoEnd

MoveWoodyDataSetDistY:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a ; +7 Y移動量

MoveWoodyResetMoveInfoEnd:

    ; インターバル値をセットする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 15
    add hl, bc
    ld (hl), 10

    pop hl

    jp MoveEnemyCommonPopEnd

; プレイヤーの位置とWOODY MONSTERの位置を比較して
; プレイヤーのほうに位置付ける
MoveWoodyGetNextVect:

    ld hl, (WK_HLREGBACK)

    inc hl
    ld a, (hl)
    ld (WK_VALUE02), a     ; Y座標
    inc hl
    ld a, (hl)
    ld (WK_VALUE03), a     ; X座標  

    ; 乱数の第0ビットが1であればY方向に
    ; 追跡させる
    call RandomValue
    ld c, 0
    and 00000001B
    cp 1
    jp z, MoveWoodyGetNextVectSetY

MoveWoodyGetNextVectSetX:

    ld a, (WK_VALUE03)
    ld b, a
    ld a, (WK_PLAYERPOSX)

    sub b     ; A < B ?
    jp c, MoveWoodyGetNextVectSetXMinus

MoveWoodyGetNextVectSetXPlus:

    ld a, 3     ; 次の方向は右方向
    jp MoveWoodyGetNextVectEnd

MoveWoodyGetNextVectSetXMinus:

    ld a, 7     ; 次の方向は右方向
    jp MoveWoodyGetNextVectEnd

MoveWoodyGetNextVectSetY:

    ld c, 1

    ld a, (WK_VALUE02)
    ld b, a
    ld a, (WK_PLAYERPOSY)

    sub b     ; A < B ?
    jp c, MoveWoodyGetNextVectSetYMinus

MoveWoodyGetNextVectSetYPlus:

    ld a, 5     ; 次の方向は下方向
    jp MoveWoodyGetNextVectEnd

MoveWoodyGetNextVectSetYMinus:

    ld a, 1     ; 次の方向は上方向

MoveWoodyGetNextVectEnd:

    ld (WK_VALUE02), a

    ld hl, (WK_HLREGBACK)
    ld d, 0
    ld e, 5
    add hl, de
    
    ld (hl), a  ; 方向をセット

    ret
