;--------------------------------------------
; SUB-ROUTINE: MoveEnemyWisp
; ウイスプの移動処理
;--------------------------------------------
MoveEnemyWisp:

MoveWispProc:

    ; LV#1
    ; オレンジウィスプ
    ; 攻撃力1 防御力1
    ; プレイヤーの方向にめがけてくる
    ; 最大距離8

    ; LV#2
    ; 赤ウイスプ
    ; 攻撃力2 防御力1
    ; プレイヤーの方向にめがけてくる
    ; 最大距離6

    ; LV#3
    ; 濃赤ウイスプ
    ; 攻撃力2 防御力2
    ; プレイヤーの方向にめがけてくる
    ; 最大距離4

    ; LV#4
    ; 白ウイスプ
    ; 攻撃力3 防御力2
    ; 縦横いずれかにランダム移動
    ; プレイヤーの方向にめがけてくる
    ; 最大距離2

    ; LV4のウイスプで、なおかつ
    ; 透視のリングがある場合
    ; スプライトカラーを白にする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, $0E      ; +14 : テキキャラのレベル
    add hl, bc
    cp 4
    jp nz, MoveWispNotLV4

    ld hl, (WK_HLREGBACK)
    ld a, $00
    ld b, 0
    ld c, 4
    add hl, bc
    ld (hl), a     ; +4 : カラー番号

MoveWispNotLV4:

    ;---------------------------------------
    ; テキキャラ移動の共通処理を呼び出す
    ;---------------------------------------
    ld de, WK_ENEMY_RESPAWN
    ld hl, MoveWispResetMoveInfo
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    call MoveEnemyCommonProc

    ; インターバル値が10ではない場合は
    ; 次のデータを参照する
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, $0F
    add hl, bc
    ld a, (hl)
    cp 10
    jp nz, MoveWispEndNextData

MoveWispMoveEnd:

    ; スプライトパターン番号を更新する
    ld hl, (WK_HLREGBACK)

    inc hl ; +1 : Y座標
    inc hl ; +2 ; X座標
    inc hl ; +3 ; パターン番号

    ld b, 112
    ld a, (hl)
    cp b
    jp nz, MoveWispMoveEndPattern112

    ld b, 116
    jp MoveWispMoveEndPatternEnd

MoveWispMoveEndPattern112:

    ld b, 112

MoveWispMoveEndPatternEnd:

    ld a, b
    ld (hl), a

MoveWispEndNextData:

    jp MoveEnemyNextDataAddCounter

;-------------------------------------------------------
; SUB-ROUTINE: MoveWispResetMoveInfo
; ウイスプの移動方向と移動量をリセットする
;-------------------------------------------------------
MoveWispResetMoveInfo:

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

    add a, a
    ld l, a
    ld a, 10
    sub l
    ld (WK_VALUE01), a ; 移動量

MoveWispResetMoveInfoInit:

    ; 移動方向と移動量を初期化する
    ; ウイスプの移動方向は
    ; プレイヤーの方向に向かってくる
    ; ただし、移動方向のリセット時には
    ; 乱数を発生させ、乱数が127以下であれば
    ; ランダムに移動させる

    ; 次の方向を決める
    call MoveWispGetNextVect
    
MoveWispResetMoveInfoInitSetVect:

    cp 1
    jp z, MoveWispDataSetDistY
    cp 5
    jp z, MoveWispDataSetDistY

MoveWispDataSetDistX:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a  ; +6 X移動量
    
    jp MoveWispResetMoveInfoEnd

MoveWispDataSetDistY:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a ; +7 Y移動量

MoveWispResetMoveInfoEnd:

    ; インターバル値をセットする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 15
    add hl, bc
    ld (hl), 10

    pop hl

    jp MoveEnemyCommonPopEnd

; プレイヤーの位置とウイスプの位置を比較して
; プレイヤーのほうに位置付ける
MoveWispGetNextVect:

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
    jp z, MoveWispGetNextVectSetY

MoveWispGetNextVectSetX:

    ld a, (WK_VALUE03)
    ld b, a
    ld a, (WK_PLAYERPOSX)

    sub b     ; A < B ?
    jp c, MoveWispGetNextVectSetXMinus

MoveWispGetNextVectSetXPlus:

    ld a, 3     ; 次の方向は右方向
    jp MoveWispGetNextVectEnd

MoveWispGetNextVectSetXMinus:

    ld a, 7     ; 次の方向は右方向
    jp MoveWispGetNextVectEnd

MoveWispGetNextVectSetY:

    ld c, 1

    ld a, (WK_VALUE02)
    ld b, a
    ld a, (WK_PLAYERPOSY)

    sub b     ; A < B ?
    jp c, MoveWispGetNextVectSetYMinus

MoveWispGetNextVectSetYPlus:

    ld a, 5     ; 次の方向は下方向
    jp MoveWispGetNextVectEnd

MoveWispGetNextVectSetYMinus:

    ld a, 1     ; 次の方向は上方向

MoveWispGetNextVectEnd:

    ld hl, (WK_HLREGBACK)
    ld d, 0
    ld e, 5
    add hl, de
    
    ld (hl), a  ; 方向をセット

    ret
