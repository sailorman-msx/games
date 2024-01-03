;--------------------------------------------
; SUB-ROUTINE: MoveEnemySlime
; スライムの移動処理
;--------------------------------------------
MoveEnemySlime:

MoveSlimeProc:

    ; LV#1
    ; 水色スラ
    ; 攻撃力1 防御力1
    ; 縦横いずれかにランダム移動
    ; 最大距離4

    ; LV#2
    ; 薄青スラ
    ; 攻撃力2 防御力1
    ; 縦横いずれかにランダム移動
    ; 最大距離8

    ; LV#3
    ; 濃赤スラ
    ; 攻撃力2 防御力2
    ; 縦横いずれかにランダム移動
    ; 最大距離4
    ; 移動終了時に移動方向の逆方向に魔法を発射
    ; 魔法は1発のみ
    ; 魔法の最大距離10

    ; LV#4
    ; 白スラ
    ; 攻撃力3 防御力2
    ; 縦横いずれかにランダム移動
    ; 最大距離8
    ; 魔法は1発のみ
    ; 移動終了時に移動方向の逆方向に魔法を発射
    ; 透視の指輪がない場合は透明で表示
    ; 魔法の最大距離14

    ; LV4のスライムで、なおかつ
    ; 透視のリングがある場合
    ; スプライトカラーを白にする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, $0E      ; +14 : テキキャラのレベル
    add hl, bc
    ld a, (hl)
    cp 4
    jp nz, MoveSlimeNotLV4

    ld hl, (WK_HLREGBACK)
    ld a, $00
    ld b, 0
    ld c, 4
    add hl, bc
    ld (hl), a     ; +4 : カラー番号

MoveSlimeNotLV4:

    ;---------------------------------------
    ; テキキャラ移動の共通処理を呼び出す
    ;---------------------------------------
    ld de, WK_ENEMY_RESPAWN
    ld hl, MoveSlimeResetMoveInfo
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
    jp nz, MoveSlimeEndNextData

MoveSlimeMoveFireball:

    ; LV3以上のスライムであればファイアボールを発射する
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 14
    add hl, bc

    ld a, (hl)
    cp 3
    jp c, MoveSlimeMoveEnd

    ; ファイアボールが未発射状態であれば
    ; ファイアボールを発射する
    ld hl, (WK_HLREGBACK)

    ld ix, hl

    ; 進行方向が$FFであれば何もしない
    ld a, (ix + 5)
    cp $FF
    jp z, MoveSlimeMoveEnd

    ld h, (ix + $0C)
    ld l, (ix + $0B)
    ld a, h
    
    or l ; HレジスタとLレジスタ双方が0であれば未発射状態となる
    jp nz, MoveSlimeMoveEnd
    
    ld hl, (WK_HLREGBACK)
    push hl

    call CreateMagicMissile ; ファイアボールが消失していれば再発射する
    
    ; ファイアボール発射後はHLレジスタに
    ; ファイアボールのデータの先頭アドレスが
    ; セットされるためその値をセットする
    ld a, h 
    ld (ix + $0C), a
    ld a, l
    ld (ix + $0B), a
    
    pop hl
    ld (WK_HLREGBACK), hl

MoveSlimeMoveEnd:

    ; スプライトパターン番号を更新する
    ld hl, (WK_HLREGBACK)

    inc hl ; +1 : Y座標
    inc hl ; +2 ; X座標
    inc hl ; +3 ; パターン番号

    ld b, 104
    ld a, (hl)
    cp b
    jp nz, MoveSlimeMoveEndPattern104

    ld b, 108
    jp MoveSlimeMoveEndPatternEnd

MoveSlimeMoveEndPattern104:

    ld b, 104

MoveSlimeMoveEndPatternEnd:

    ld a, b
    ld (hl), a

MoveSlimeEndNextData:

    jp MoveEnemyNextDataAddCounter

;-------------------------------------------------------
; SUB-ROUTINE: MoveSlimeResetMoveInfo
; スライムの移動方向と移動量をリセットする
;-------------------------------------------------------
MoveSlimeResetMoveInfo:

    push hl

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 5
    add hl, bc
    ld a, (hl)
    ld (WK_VALUE02), a   ; 移動方向を退避

MoveSlimeResetMoveInfoInit:

    ; 移動方向と移動量を初期化する
    ; スライムの移動方向は
    ; 横移動であれば次は縦移動
    ; 縦移動であれば次は横移動
    ; とする

    cp 1
    jp z, MoveSlimeSetVectLR
    cp 3
    jp z, MoveSlimeSetVectUD
    cp 5
    jp z, MoveSlimeSetVectLR

    jp MoveSlimeSetVectUD

MoveSlimeSetVectLR:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    and 00000001B
    or a
    jp z, MoveSlimeSetVectRight

    jp MoveSlimeSetVectLeft

MoveSlimeSetVectRight:

    ld a, 3
    jp MoveSlimeSetVectEnd

MoveSlimeSetVectLeft:

    ld a, 7
    jp MoveSlimeSetVectEnd

MoveSlimeSetVectUD:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    and 00000001B
    or a
    jp z, MoveSlimeSetVectUp

    jp MoveSlimeSetVectDown

MoveSlimeSetVectDown:

    ld a, 5
    jp MoveSlimeSetVectEnd

MoveSlimeSetVectUp:

    ld a, 1

MoveSlimeSetVectEnd:

    ld (WK_VALUE02), a
    ld (hl), a

    ; 移動量を決める
MoveSlimeDataSetDist:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    and 00000111B
    jp z, MoveSlimeDataSetDist

    ; レベルによって移動量を調整する
    ld a, (WK_VALUE01)
    cp 2
    jp z, MoveSlimeDataDistLV2
    
    ld b, 00000011B
    jp MoveSlimeDataSetDistEnd

MoveSlimeDataDistLV2:

    ld b, 00000111B

MoveSlimeDataSetDistEnd:

    and b ; 移動量を0-3または0-7の値にマスクする
    inc a ; 移動量に1を加算する

    ld (WK_VALUE01), a ; 移動量をVALUE01に格納

    ; 移動方向によって移動量の値を取得する
    ld hl, SPRITEMOVE_TBL
    ld b, 0
    ld a, (WK_VALUE02)
    ld c, a
    add hl, bc

    ld a, (hl)
    ld b, a      ; SPRITEMOVE_TBLの値をBレジスタに退避

    ; 上位4ビットを取得
    srl a
    srl a
    srl a
    srl a

    or 0
    jp z, MoveSlimeDataSetDistY

MoveSlimeDataSetDistX:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (WK_VALUE01)
    ld (hl), a  ; +6 X移動量
    
    jp MoveSlimeResetMoveInfoEnd

MoveSlimeDataSetDistY:

    ; 下位4ビットを取得
    ld a, b
    and $0F

    or 0
    jp z, MoveSlimeResetMoveInfoEnd

    ld a, (WK_VALUE01)
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld (hl), a ; +7 Y移動量

MoveSlimeResetMoveInfoEnd:

    ; インターバル値をセットする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 15
    add hl, bc
    ld (hl), 10

    pop hl

    jp MoveEnemyCommonPopEnd

