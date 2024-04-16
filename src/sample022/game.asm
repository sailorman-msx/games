GameMainProc:

    ;-------------------------------------------
    ; ここにメインロジックを書きます
    ; WK_GAMESTATUS=2だとH.TIMIが終わったあとで
    ; この処理が必ず呼ばれます
    ;-------------------------------------------

    ld a, (WK_TIME05)
    cp 2
    jp nz, GameMainProcEnd

    ; 半径64の円周を描くようにスプライトを表示する
    ; 円の中心は X=128, Y=96とする

    ; 角度(WK_ANGLE)に1を加算する
    ld a, (WK_ANGLE)
    inc a
    cp 64
    jr z, ResetAngle

    jr SkipResetAngle

ResetAngle:

    ; 角度が64になったら0に戻す
    xor a

SkipResetAngle:

    ld (WK_ANGLE), a

    ; Y値、X値を取得する
    ld hl, TRIGFUNC_TBL

    ; 角度を4倍してTRIGFUNC_TBLのアドレスをセットする
    add a, a
    add a, a
    ld d, 0
    ld e, a
    add hl, de

    ;---------------------------------------------
    ; ここからY座標の算出処理
    ;---------------------------------------------

    ; Y値を取得する
    ld e, (hl) ; Y値小数部
    inc hl
    ld d, (hl) ; Y値整数部
    inc hl
    push hl ; [ HLレジスタの値をPUSH

    ; 整数部がマイナス値であれば
    ; マイナスサインフラグを立てて
    ; 整数部、小数部ともにNEGする
    xor a
    ld (WK_VALUE01), a

    ld a, d
    and 10000000B
    or a
    jr z, SkipSetMinusFlagY

    ld a, 1
    ld (WK_VALUE01), a

    ; DEレジスタ双方をプラマイ逆転させる
    ld a, d
    neg
    ld d, a

    ld a, e
    neg
    ld e, a

SkipSetMinusFlagY:

    ; 小数部が0であれば
    ; 整数部のみ64倍する
    ld a, e
    or a
    jr z, SetIntMulti64Y

    ; マイナスフラグが立っていたら
    ; プラスの値に変換する
    ld a, (WK_VALUE01)
    or a
    jr z, PointMulti64Y

PointMulti64Y:

    ; 小数値を64倍する
    ; HL = H * E
    ld h, 64

    ; 64倍した結果、Hレジスタの整数値を採用する
    call CalcMulti

    jr JudgeYMinus

SetIntMulti64Y:

    ; 整数値を64倍する
    ld e, d
    ld h, 64

    call CalcMulti

    ; 1を64倍してもLレジスタしか変動しないため
    ; Lレジスタの値をHレジスタにセットする
    ld h, l

JudgeYMinus:

    ; マイナスサインが立っていたらプラマイを逆転させる
    ld a, (WK_VALUE01)
    or a
    jr z, SetPOSY

    ld a, h
    neg
    ld h, a

SetPOSY:

    ; POSYの値はHレジスタにセットされている
    ; 96 を加算した値をスプライトのY座標とする
    ld a, h
    add a, 96
    ld (WK_POSY), a

    ;---------------------------------------------
    ; ここからX座標の算出処理
    ;---------------------------------------------

    ; X値を取得する
    pop hl   ; ] HLレジスタの値を復帰

    ld e, (hl) ; X値小数部
    inc hl
    ld d, (hl) ; X値整数部
    inc hl

    ; 整数部がマイナス値であれば
    ; マイナスサインフラグを立てる
    xor a
    ld (WK_VALUE01), a

    ld a, d
    and 10000000B
    or a
    jr z, SkipSetMinusFlagX

    ld a, 1
    ld (WK_VALUE01), a

    ; DEレジスタ双方をプラマイ逆転させる
    ld a, d
    neg
    ld d, a

    ld a, e
    neg
    ld e, a

SkipSetMinusFlagX:

    ; 小数部が0であれば
    ; 整数部のみ64倍する
    ld a, e
    or a
    jr z, SetIntMulti64X

    ; マイナスフラグが立っていたら
    ; プラスの値に変換する
    ld a, (WK_VALUE01)
    or a
    jr z, PointMulti64X

PointMulti64X:

    ; 小数値を64倍する
    ; HL = H * E
    ld h, 64

    ; 64倍した結果、Hレジスタの整数値を採用する
    call CalcMulti

    jr JudgeXMinus

SetIntMulti64X:

    ; 整数値を64倍する
    ld e, d
    ld h, 64

    call CalcMulti

    ; 1を64倍してもLレジスタしか変動しないため
    ; Lレジスタの値をHレジスタにセットする
    ld h, l

JudgeXMinus:

    ; マイナスサインが立っていたらプラマイを逆転させる
    ld a, (WK_VALUE01)
    or a
    jr z, SetPOSX

    ld a, h
    neg
    ld h, a

SetPOSX:

    ; POSXの値はHレジスタにセットされている
    ; 128 を加算した値をスプライトのY座標とする
    ld a, h
    add a, 128
    ld (WK_POSX), a

    ;------------------------------------------------
    ; スプライト移動管理テーブルにスプライトの情報を
    ; セットする
    ;------------------------------------------------
    
    ; WK_SPRITEMOVE_TBLに値をセットする
    ld hl, WK_SPRITE_MOVETBL
    inc hl          ; 種別コード
    ld a, (WK_POSY)
    ld (hl), a      ; Y座標
    inc hl
    ld a, (WK_POSX)
    ld (hl), a      ; X座標
    inc hl

    ld a, (WK_ANIME_PTN)
    ld (hl), a      ; スプライトパターン番号

    cp 12
    jr z, ResetAnimeNum

    inc a
    inc a
    inc a
    inc a
    jr SetColorNum

ResetAnimeNum:

    xor a
    
SetColorNum:

    ld (WK_ANIME_PTN), a

    inc hl
    ld a, $0A
    ld (hl), a      ; カラー番号

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

    ; スプライトを再描画する
    ld a, 1
    ld (WK_SPRREDRAW_FINE), a

GameMainProcEnd:

    jp NextHTIMIHook
