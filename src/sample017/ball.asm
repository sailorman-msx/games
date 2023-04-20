;--------------------------------------------
; ball.asm
; ボールの制御を行う
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: MoveSprite
; スプライト座標管理用テーブルを更新する
;--------------------------------------------
MoveSprite:

    ld hl, WK_SPRITE_MOVETBL
    ld (WK_HLREGBACK), hl

    ; SPRITE#31の座標は更新しない
    ld b, 31

MoveSpriteLoop:

    ; スプライトが透明だったら次のデータを加工する
    inc l
    inc l
    inc l ; HL = HL + 3
    ld a, (hl)
    or 0
    jp z, MoveSpriteEnd

    dec l ; HL = HL + 2

    ; スプライトがPLAYERだったら次のデータを加工する
    ld a, (hl)
    cp 16
    jp nc, MoveSpriteEnd

MoveSpriteX:

    ld hl, (WK_HLREGBACK)
    inc l
    ld a, (hl) ; X座標を取得しDレジスタにセットする
    ld d, a

    ; X座標が232以上になったら移動方向を逆転する
    cp 232
    call nc, MoveSpriteReverseX

    ; X座標がマイナスになったら移動方向を逆転する
    cp 8
    call c, MoveSpriteReverseX

    ld hl, (WK_HLREGBACK)
    inc l
    inc l
    inc l
    inc l
    ld a, (hl) ; X方向の移動量を取得する

    ld hl, (WK_HLREGBACK)
    inc l
    add a, d ; X座標に移動量を加算する
    ld (hl), a

MoveSpriteY:

    ld hl, (WK_HLREGBACK)

    ld a, (hl) ; Y座標を取得しDレジスタにセットする
    ld d, a

    ; Y座標が168以上になったら移動方向を逆転する
    cp 168
    call nc, MoveSpriteReverseY

    ; Y座標が24以下になったら移動方向を逆転する
    cp 24
    call c, MoveSpriteReverseY

    ld hl, (WK_HLREGBACK)
    inc l
    inc l
    inc l
    inc l
    inc l
    ld a, (hl) ; Y方向の移動量を取得する

    ld hl, (WK_HLREGBACK)
    add a, d ; Y座標に移動量を加算する
    ld (hl), a

MoveSpriteEnd:

    ld hl, (WK_HLREGBACK)
    inc l
    inc l
    inc l
    inc l
    inc l
    inc l
    ld (WK_HLREGBACK), hl ; アドレスを6進める

    dec b
    jp nz, MoveSpriteLoop

    ret

MoveSpriteReverseX:

    ld hl, (WK_HLREGBACK)
    inc l
    inc l ; HL = HL + 2
    ld a, (hl) ; パターン番号を変える
    add a, 4

    cp 16
    jp nz, MoveSpriteReverseXMove

    ld a, 0

MoveSpriteReverseXMove:

    ld (hl), a

    call GetSpriteColor

    inc l
    ld (hl), a

    ld hl, (WK_HLREGBACK)

    inc l
    inc l
    inc l
    inc l
    ld a, (hl)

    ; Xの移動方向の符号を反転する
    neg
    ld (hl), a

    ret

MoveSpriteReverseY:

    ld hl, (WK_HLREGBACK)
    inc l
    inc l

    ld a, (hl) ; パターン番号を変える
    add a, 4

    cp 16
    jp nz, MoveSpriteReverseYMove

    ld a, 0

MoveSpriteReverseYMove:

    ld (hl), a

    call GetSpriteColor

    inc l
    ld (hl), a

    ld hl, (WK_HLREGBACK)

    inc l
    inc l
    inc l
    inc l
    inc l
    ld a, (hl)

    ; Yの移動方向をマイナス方向に変更する
    neg
    ld (hl), a

    ret
