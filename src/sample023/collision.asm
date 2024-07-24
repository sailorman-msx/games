;---------------------------------------
; 当たり判定関連
;---------------------------------------

; プレイヤーの周囲を調べて
; 壁があるか、動けるかをフラグに持たせる

WallCollision:

    ; Y座標を8で割る
    ld a, (WK_POSY)
    srl a
    srl a
    srl a

    ex af, af'  ; Aレジスタを退避

WallCollisionCheckX:

    ld a, (WK_POSX)
    add a, 4    ; 座標に4ドット加算した場所で調べる

    ; X座標が8未満であれば8にする
    cp 8
    jr c, WallCollisionXPosAdj8
    ; X座標が232を超えていたら232にする
    cp 233
    jr nc, WallCollisionXPosAdj240

    jr WallCollisionDiv8

WallCollisionXPosAdj8:

    ld a, 8
    jr WallCollisionDiv8

WallCollisionXPosAdj240:

    ld a, 232

WallCollisionDiv8:

    ; X座標を8で割る
    ; 割り切れたら左右を調べる
    ld l, a
    or a ; CY OFF
    srl a
    srl a
    srl a

WallCollisionSetXPos:

    ld (WK_CHECKPOSX), a

    ex af, af'  ; Aレジスタを復帰

    ld (WK_CHECKPOSY), a

    ; プレイヤーの周囲を調べる
    call GetVRAM4x6

    ; 周囲の情報にて
    ; WK_SURROUNDFLGのフラグを立てる
    ld a, (WK_SURROUNDFLG)

    ; 前回の移動可能フラグをBレジスタにセットする
    ld b, a
    
WallCollisionWallChk1:

    ; 落下中は必ず上下を調べる
    ld a, (WK_FALLDOWN)
    or a
    jr nz, WallCollisionWallChk1Start
 
    ; ジャンプ中は必ず上下を調べる
    ld a, (WK_JUMPCNT)
    cp $FF
    jr nz, WallCollisionWallChk1Start

    ; Dレジスタの値が1であれば(Xが8で割り切れたら)
    ; 縦方向は調べない
    ; ld a, d
    ; cp 1
    ; jr z, WallCollisionWallChk3

WallCollisionWallChk1Start:

    ; 上方向の壁チェック

WallCollisionWallChk1Chk05:

    ld a, (WK_VRAM4X6_TBL + $05)
    cp $66
    jr z, WallCollisionWallChk1Chk06
    cp CONST_SPACE
    jr z, WallCollisionWallChk1Chk06

    jr nz, WallCollisionWallChk1IsWall

WallCollisionWallChk1Chk06:

    ld a, (WK_VRAM4X6_TBL + $06)
    cp $66
    jr z, WallCollisionWallChk1UpOkay
    cp CONST_SPACE
    jr z, WallCollisionWallChk1UpOkay

    jr nz, WallCollisionWallChk1IsWall

WallCollisionWallChk1UpOkay:

    ; 上に壁はない（移動可能）
    set 3, b

    jr WallCollisionWallChk2

WallCollisionWallChk1IsWall:

    ; 上に壁がある（移動不可）
    res 3, b

WallCollisionWallChk2:

    ; 下方向の壁チェック

WallCollisionWallChk2Chk15:

    ld a, (WK_VRAM4X6_TBL + $15)
    cp $66
    jr z, WallCollisionWallChk2Chk16
    cp CONST_SPACE
    jr z, WallCollisionWallChk2Chk16

    jp WallCollisionWallChk2IsWall

WallCollisionWallChk2Chk16:

    ld a, (WK_VRAM4X6_TBL + $16)
    cp $66
    jr z, WallCollisionWallChk2DownOkay
    cp CONST_SPACE
    jr z, WallCollisionWallChk2DownOkay

    jr WallCollisionWallChk2IsWall

WallCollisionWallChk2DownOkay:

    ; 下に壁はない（移動可能）
    set 2, b

    jr WallCollisionWallChk3

WallCollisionWallChk2IsWall:

    ; 下に壁がある（移動不可）
    res 2, b

    jr WallCollisionWallChk3

WallCollisionWallChk3:

    ; X座標が8で割り切れない場合は
    ; 左右どちらも移動可能とする
    ld a, d
    or a
    jp z, WallCollisionWallChkLROkayEnd

    ; 左方向の壁チェック
    ; 横方向はキャラの頭と足の横を調べる
    ; 横方向は8で割り切れる時でなければ
    ; 判定しない

WallCollisionWallChk3Chk08:

    ld a, (WK_VRAM4X6_TBL + $08)
    cp $64
    jr z, WallCollisionWallChk3Chk0C
    cp $65
    jr z, WallCollisionWallChk3Chk0C
    cp $66
    jr z, WallCollisionWallChk3Chk0C
    cp CONST_SPACE
    jr z, WallCollisionWallChk3Chk0C

    jr WallCollisionWallChk3IsWall

WallCollisionWallChk3Chk0C:

    ld a, (WK_VRAM4X6_TBL + $0C)
    cp $64
    jr z, WallCollisionWallChk3Chk10
    cp $65
    jr z, WallCollisionWallChk3Chk10
    cp $66
    jr z, WallCollisionWallChk3Chk10
    cp CONST_SPACE
    jr z, WallCollisionWallChk3Chk10

    jr WallCollisionWallChk3IsWall

WallCollisionWallChk3Chk10:

    ld a, (WK_VRAM4X6_TBL + $10)
    cp $64
    jr z, WallCollisionWallChk3Chk09
    cp $65
    jr z, WallCollisionWallChk3Chk09
    cp $66
    jr z, WallCollisionWallChk3Chk09
    cp CONST_SPACE
    jr z, WallCollisionWallChk3Chk09

    jr nz, WallCollisionWallChk3IsWall

WallCollisionWallChk3Chk09:

    ld a, (WK_VRAM4X6_TBL + $09)
    cp $64
    jr z, WallCollisionWallChk3Chk0D
    cp $65
    jr z, WallCollisionWallChk3Chk0D
    cp $66
    jr z, WallCollisionWallChk3Chk0D
    cp CONST_SPACE
    jr z, WallCollisionWallChk3Chk0D

    jr WallCollisionWallChk3IsWall

WallCollisionWallChk3Chk0D:

    ld a, (WK_VRAM4X6_TBL + $0D)
    cp $64
    jr z, WallCollisionWallChk3Chk11
    cp $65
    jr z, WallCollisionWallChk3Chk11
    cp $66
    jr z, WallCollisionWallChk3Chk11
    cp CONST_SPACE
    jr z, WallCollisionWallChk3Chk11

    jr WallCollisionWallChk3IsWall

WallCollisionWallChk3Chk11:

    ld a, (WK_VRAM4X6_TBL + $11)
    cp $64
    jr z, WallCollisionWallChk3LeftOkay
    cp $65
    jr z, WallCollisionWallChk3LeftOkay
    cp $66
    jr z, WallCollisionWallChk3LeftOkay
    cp CONST_SPACE
    jr z, WallCollisionWallChk3LeftOkay

    jr nz, WallCollisionWallChk3IsWall

WallCollisionWallChk3LeftOkay:

    ; 左に壁はない（移動可能）
    set 1, b

    jr WallCollisionWallChk4

WallCollisionWallChk3IsWall:

    ; 左に壁がある（移動不可）
    res 1, b

WallCollisionWallChk4:

    ; 右方向の壁チェック
    ; 横方向はキャラの頭と足の横を調べる

WallCollisionWallChk4Chk0B:

    ld a, (WK_VRAM4X6_TBL + $0B)
    cp $64
    jr z, WallCollisionWallChk4Chk0F
    cp $65
    jr z, WallCollisionWallChk4Chk0F
    cp $66
    jr z, WallCollisionWallChk4Chk0F
    cp CONST_SPACE
    jr z, WallCollisionWallChk4Chk0F

    jr WallCollisionWallChk4IsWall

WallCollisionWallChk4Chk0F:

    ld a, (WK_VRAM4X6_TBL + $0F)
    cp $64
    jr z, WallCollisionWallChk4Chk13
    cp $65
    jr z, WallCollisionWallChk4Chk13
    cp $66
    jr z, WallCollisionWallChk4Chk13
    cp CONST_SPACE
    jr z, WallCollisionWallChk4Chk13

    jr WallCollisionWallChk4IsWall

WallCollisionWallChk4Chk13:

    ld a, (WK_VRAM4X6_TBL + $13)
    cp $64
    jr z, WallCollisionWallChk4Chk0A
    cp $65
    jr z, WallCollisionWallChk4Chk0A
    cp $66
    jr z, WallCollisionWallChk4Chk0A
    cp CONST_SPACE
    jr z, WallCollisionWallChk4Chk0A

    jr WallCollisionWallChk4IsWall

WallCollisionWallChk4Chk0A:

    ld a, (WK_VRAM4X6_TBL + $0A)
    cp $64
    jr z, WallCollisionWallChk4Chk0E
    cp $65
    jr z, WallCollisionWallChk4Chk0E
    cp $66
    jr z, WallCollisionWallChk4Chk0E
    cp CONST_SPACE
    jr z, WallCollisionWallChk4Chk0E

    jr WallCollisionWallChk4IsWall

WallCollisionWallChk4Chk0E:

    ld a, (WK_VRAM4X6_TBL + $0E)
    cp $64
    jr z, WallCollisionWallChk4Chk12
    cp $65
    jr z, WallCollisionWallChk4Chk12
    cp $66
    jr z, WallCollisionWallChk4Chk12
    cp CONST_SPACE
    jr z, WallCollisionWallChk4Chk12

    jr WallCollisionWallChk4IsWall

WallCollisionWallChk4Chk12:

    ld a, (WK_VRAM4X6_TBL + $12)
    cp $64
    jr z, WallCollisionWallChk4RightOkay
    cp $65
    jr z, WallCollisionWallChk4RightOkay
    cp $66
    jr z, WallCollisionWallChk4RightOkay
    cp CONST_SPACE
    jr z, WallCollisionWallChk4RightOkay

    jr WallCollisionWallChk4IsWall

WallCollisionWallChk4RightOkay:

    ; 右に壁はない（移動可能）
    set 0, b

    jr WallCollisionWallChkEnd

WallCollisionWallChk4IsWall:

    ; 右に壁がある（移動不可）
    res 0, b

    jr WallCollisionWallChkEnd

WallCollisionWallChkLROkayEnd:

    ; 左右どちらにも移動可能とする
    set 1, b
    set 0, b

WallCollisionWallChkEnd:

    ; 移動可能フラグをセットする
    ld a, b
    ld (WK_SURROUNDFLG), a

WallCollisionEnd:

    ret
