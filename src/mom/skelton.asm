; SUB-ROUTINE: MoveEnemySkelton
; スケルトンの移動処理
;--------------------------------------------
MoveEnemySkelton:

    ; WK_HLREGBACKにはキャラクター1体分の
    ; WK_SPRITEMOVE_TBLの先頭アドレスがセットされて
    ; 呼び出されてくる

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 4
    add hl, bc
    ld a, (hl)

    ; 2枚目のスプライト(カラーコード14)は処理しない
    cp 14
    jp z, MoveSkeltonEndNextData

    ;---------------------------------------
    ; テキキャラ移動の共通処理を呼び出す
    ;---------------------------------------
    ld de, WK_ENEMY_RESPAWN
    ld hl, MoveSkeltonResetMoveInfo
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    call MoveEnemyCommonProc

MoveSkeltonEndNextData:

    jp MoveEnemyNextDataAddCounter

;-------------------------------------------------------
; SUB-ROUTINE: MoveSkeltonResetMoveInfo
; スケルトンの移動方向と移動量をリセットする
;-------------------------------------------------------
MoveSkeltonResetMoveInfo:

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

MoveSkeltonResetMoveInfoInit:

    ; 移動方向と移動量を初期化する
    ; SKELTONの移動方向は
    ; プレイヤーの方向に向かってくる
    ; ただし、移動方向のリセット時には
    ; 乱数を発生させ、乱数が127以下であれば
    ; ランダムに移動させる

    ; 次の方向を決める
    call MoveSkeltonGetNextVect

MoveSkeltonResetMoveInfoInitDistSet:

    ; 移動方向によってパターン番号を特定する
    push hl

    ld hl, ENEMY_PTN_SKELTON
    ld b, 0
    ld c, a
    add hl, bc
    ld a, (hl)

    pop hl

    dec hl
    dec hl
    ld (hl), a     ; パターン番号

    ; 2枚目のパターン番号をセットする
    ld b, 4
    add a, b
    ld d, a

    ld b, 0
    ld c, 16
    add hl, bc
    ld a, d
    ld (hl), d

MoveSkeltonResetMoveInfoInitSetVect:

    ld a, (WK_VALUE02)

    cp 1
    jp z, MoveSkeltonDataSetDistY
    cp 5
    jp z, MoveSkeltonDataSetDistY

MoveSkeltonDataSetDistX:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a  ; +6 X移動量
    
    jp MoveSkeltonResetMoveInfoEnd

MoveSkeltonDataSetDistY:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a ; +7 Y移動量

MoveSkeltonResetMoveInfoEnd:

    ; インターバル値をセットする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 15
    add hl, bc
    ld (hl), 10

    pop hl

    jp MoveEnemyCommonPopEnd

; プレイヤーの位置とSKELTONの位置を比較して
; プレイヤーのほうに位置付ける
MoveSkeltonGetNextVect:

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
    jp z, MoveSkeltonGetNextVectSetY

MoveSkeltonGetNextVectSetX:

    ld a, (WK_VALUE03)
    ld b, a
    ld a, (WK_PLAYERPOSX)

    sub b     ; A < B ?
    jp c, MoveSkeltonGetNextVectSetXMinus

MoveSkeltonGetNextVectSetXPlus:

    ld a, 3     ; 次の方向は右方向
    jp MoveSkeltonGetNextVectEnd

MoveSkeltonGetNextVectSetXMinus:

    ld a, 7     ; 次の方向は右方向
    jp MoveSkeltonGetNextVectEnd

MoveSkeltonGetNextVectSetY:

    ld c, 1

    ld a, (WK_VALUE02)
    ld b, a
    ld a, (WK_PLAYERPOSY)

    sub b     ; A < B ?
    jp c, MoveSkeltonGetNextVectSetYMinus

MoveSkeltonGetNextVectSetYPlus:

    ld a, 5     ; 次の方向は下方向
    jp MoveSkeltonGetNextVectEnd

MoveSkeltonGetNextVectSetYMinus:

    ld a, 1     ; 次の方向は上方向

MoveSkeltonGetNextVectEnd:

    ld (WK_VALUE02), a

    ld hl, (WK_HLREGBACK)
    ld d, 0
    ld e, 5
    add hl, de
    
    ld (hl), a  ; 方向をセット

    ret
