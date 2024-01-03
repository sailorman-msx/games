PeepHoleProc:

    ;--------------------------------------------
    ; WK_CHECKPOSX, WK_CHECKPOSYをもとに
    ; プレイヤーの半径5タイル分(25x25キャラ)の
    ; 箇所だけ可視化する。
    ; 見えない領域にはスペースを描画する
    ;
    ; オリジナルのWK_MAP_VIEWAREAの内容を600バイトぶん
    ; コピーしたWK_MAP_VIEWAREA_DISPを上書きすることで実現する
    ;--------------------------------------------

    push af
    push bc
    push de
    push hl
    push ix
    push iy

    ld a, (WK_PEEPHOLE)
    ld (WK_PH_VALUE01), a

    ; ピープホール型のマップでない場合
    ; 何もしない
    ld a, (WK_MAPTYPE)
    cp 2
    jr z, StartPeepHole 
    cp 5
    jr z, StartPeepHole 
    cp 6
    jr z, StartPeepHoleCasle
    cp 8
    jr z, StartPeepHoleCasle

    jp PeepHoleProcPopEnd

StartPeepHoleCasle:

    ; 魔導士の居城やダンジョンではTORCHの効果は常に1
    ; ただし、LIGHT RING装備中はPEEPHOLE値は7になる
    ld a, 1
    ld (WK_PH_VALUE01), a

    ld a, (WK_EQUIP_RING)
    cp 3
    jr nz, StartPeepHole

    ld a, 7
    ld (WK_PH_VALUE01), a

StartPeepHole:

    ; ここから処理開始

    ld hl, WK_MAP_VIEWAREA
    ld de, WK_MAP_VIEWAREA_DISP
    ld bc, 600
    ldir

    ld a, (WK_CHECKPOSX)
    sub 1     ; WK_CHECKPOSXから1を引くとビューポート上でのX座標になる

    ld b, a   ; B = (WK_CHECKPOSX - 1)
    ld a, (WK_PH_VALUE01)
    ld c, a

    ; X座標がPEEPHOLEの値より小さい場合、PEEPHOLEの値にする
    cp b  ; WK_PEEPHOLE - (WK_CHECKPOSX - 1) ?
    jp nc, PeepHoleProcSetPeepXMinDefault

    ; X座標が28-PEEPHOLEより大きい場合、28にする
    ld a, 28
    sub b ; A = 28 - (WK_CHECKPOSX - 1)
    cp c  ; A - WK_PEEPHOLE ?
    jp c, PeepHoleProcSetPeepXMaxDefault

    ld a, b

    jp PeepHoleProcSetPeepX

PeepHoleProcSetPeepXMinDefault:

    ld b, c
    jp PeepHoleProcSetPeepX

PeepHoleProcSetPeepXMaxDefault:

    ld a, 28
    sub c     ; A = 28 - WK_PEEPHOLE

PeepHoleProcSetPeepX:

    ld (WK_MAP_PEEPX), a

    ld a, (WK_CHECKPOSY)
    sub 3  ; WK_CHECKPOSYから3を引くとビューポート上でのY座標になる

    ld b, a   ; B = (WK_CHECKPOSY - 1)
    ld a, (WK_PH_VALUE01)
    ld c, a

    ; Y座標がPEEPHOLEの値より小さい場合、PEEPHOLEの値にする
    cp b  ; WK_PEEPHOLE - (WK_CHECKPOSY - 1) ?
    jp nc, PeepHoleProcSetPeepYMinDefault

    ; Y座標が18-PEEPHOLEより大きい場合、18にする
    ld a, 18
    sub b ; A = 18 - (WK_CHECKPOSY - 1)
    cp c  ; A - WK_PEEPHOLE ?
    jp c, PeepHoleProcSetPeepYMaxDefault

    ld a, b

    jp PeepHoleProcSetPeepY

PeepHoleProcSetPeepYMinDefault:

    ld b, c
    jp PeepHoleProcSetPeepY

PeepHoleProcSetPeepYMaxDefault:

    ld a, 18
    sub c     ; A = 18 - WK_PEEPHOLE

PeepHoleProcSetPeepY:

    ld (WK_MAP_PEEPY), a

    ; ピープホール開始基準位置を決める
    ld a, (WK_PH_VALUE01)
    ld b, a ; WK_PEEPHOLEキャラ分

    ld a, (WK_MAP_PEEPY)

    ; WK_MAP_PEEPY - WK_PEEPHOLE の結果を見る
    cp b
    jp c, PeepHoleProcSetBaseMinYMinus

    sub b
    jp PeepHoleProcSetBaseMinY

PeepHoleProcSetBaseMinYMinus:
    
    ; WK_MAP_PEEPY - WK_PEEPHOLEの結果がマイナスであれば
    ; WK_MAP_PEEPBASEYにはゼロをセットする

    xor a

PeepHoleProcSetBaseMinY:

    ld (WK_MAP_PEEPBASEY), a
    ld (WK_PEEPHOLEMINY), a

    ld a, (WK_PH_VALUE01)
    ld b, a ; WK_PEEPHOLEキャラ分

    ld a, (WK_MAP_PEEPX)

    ; WK_MAP_PEEPX - WK_PEEPHOLE の結果を見る
    cp b
    jp c, PeepHoleProcSetBaseMinXMinus

    sub b
    jp PeepHoleProcSetBaseMinX

PeepHoleProcSetBaseMinXMinus:
    
    ; WK_MAP_PEEPX - WK_PEEPHOLEの結果がマイナスであれば
    ; WK_MAP_PEEPBASEXにはゼロをセットする

    xor a

PeepHoleProcSetBaseMinX:

    ld (WK_MAP_PEEPBASEX), a
    ld (WK_PEEPHOLEMINX), a

    ld a, (WK_PH_VALUE01)
    ld c, a
    ld a, (WK_MAP_PEEPX)
    inc a
    add c  ; A = WK_MAP_PEEPX + 1 + WK_PEEPHOLE

    cp 30  ; IF A = A - 30 >= 0 THEN PeepHoleCutOverX
    jp nc, PeepHoleCutOverX

    jp PeepHoleProcSetNormalYohakuX

PeepHoleCutOverX:

    ; プレイヤーの右側が30以上の場合は30を減算する
    ld a, 30
    sub c ; A = 30 - C
    add b

PeepHoleProcSetNormalYohakuX:

    ld (WK_PEEPHOLEMAXX), a

    ld a, (WK_MAP_PEEPBASEX)
    ld c, a

    ld a, (WK_PEEPHOLEMAXX)
    sub c
    inc a
    ld (WK_PEEPHOLEWIDTH), a ; ピープホールの横幅
    
PeepHoleProcMinY:

    ld a, (WK_PH_VALUE01)
    ld c, a
    ld a, (WK_MAP_PEEPY)
    inc a
    add c  ; A = WK_MAP_PEEPY + 1 + WK_PEEPHOLE

    cp 20  ; IF A = A - 20 >= 0 THEN PeepHoleCutOverY
    jp nc, PeepHoleCutOverY

    jp PeepHoleProcSetNormalYohakuY

PeepHoleCutOverY:

    ld a, 20
    sub c ; A = 20 - C
    add b

PeepHoleProcSetNormalYohakuY:

    ld (WK_PEEPHOLEMAXY), a

    ld a, (WK_MAP_PEEPBASEY)
    ld c, a

    ld a, (WK_PEEPHOLEMAXY)
    sub c
    inc a
    ld (WK_PEEPHOLEHEIGHT), a ; ピープホールの縦幅
    
PeepHoleProcMakeHole:

    ld a, (WK_PEEPHOLEHEIGHT)
    ld d, 0
    ld e, a
    ld (WK_PH_DEREGBACK), de

    ld hl, WK_MAP_VIEWAREA_DISP
    ld (WK_PH_HLREGBACK), hl

    ld a, (WK_MAP_PEEPBASEY)
    or a
    jp z, PeepHoleProcSetFilY

PeepHoleProcSetLocateY:

    ld b, 0
    ld c, a
    ld h, 0
    ld l, a
    add hl, hl ; x2
    add hl, hl ; x4
    add hl, hl ; x8
    add hl, hl ; x16
    add hl, hl ; x32
    
    or a ; Set CY=0
    sbc hl, bc
    or a ; Set CY=0
    sbc hl, bc

PeepHoleProcSetFilY:

    ld de, hl
    ld hl, (WK_PH_HLREGBACK)

    ld a, (WK_MAP_PEEPBASEY)
    or a
    jp z, PeepHoleProcLoop

    ld bc, de
    ld a, $20
    call MemFil ; ピープホールの基準Y位置までをスペースで埋める

PeepHoleProcLoop:

    ld (WK_PH_HLREGBACK), hl

    ld a, (WK_MAP_PEEPBASEX)
    or a
    jp z, PeepHolePrevNext

    ld b, 0
    ld c, a

    ld a, $20
    call MemFil

PeepHolePrevNext:

    ld a, (WK_PEEPHOLEWIDTH)
    ld b, 0
    ld c, a

    add hl, bc ; ピープホールの横幅ぶんスキップする

    ld a, (WK_MAP_PEEPBASEX)
    ld b, a
    ld a, (WK_PEEPHOLEWIDTH)
    add a, b
    ld  b, a
    ld a, 30   ; ピープホールの横幅以降をスペースで埋める
    sub b

    or a
    jp z, PeepHolePrevNext2

PeepHolePrev2:

    ld b, 0
    ld c, a

    ld a, $20
    call MemFil

PeepHolePrevNext2:

    ld de, (WK_PH_DEREGBACK)

    dec e
    jp z, PeepHoleProcEnd

    ld (WK_PH_DEREGBACK), de

    ld hl, (WK_PH_HLREGBACK)

    ld d, 0
    ld e, 30
    add hl, de

    jp PeepHoleProcLoop

PeepHoleProcEnd:

    ; ピープホールの下部分をスペースで埋める
    ld a, (WK_PEEPHOLEMAXY)
    ld b, a
    cp 19
    jp z, PeepHoleProcPopEnd

    ld a, 19
    sub b

    ld b, 0
    ld c, a
    ld h, 0
    ld l, a
    add hl, hl ; x2
    add hl, hl ; x4
    add hl, hl ; x8
    add hl, hl ; x16
    add hl, hl ; x32
    
    or a ; Set CY=0
    sbc hl, bc
    or a ; Set CY=0
    sbc hl, bc

    ld bc, hl
    
    ld hl, (WK_PH_HLREGBACK)
    add hl, 30

    ld a, $20
    call MemFil

PeepHoleProcPopEnd:

    xor a
    ld (WK_PEEPHOLE_BUILDNOW), a

    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af

    ret
