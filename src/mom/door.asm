;--------------------------------------------
; door.asm
; ドア開閉関連
;--------------------------------------------
InitializeDoorTable:

    ld hl, DOOR_POSITION_DATA
    ld de, WK_DOOR_TBL

InitializeDoorTableLoop:

    ld a, (hl)
    ld b, a
    inc hl
    ld a, (hl)
    ld c, a

    push hl
    or a ; ZERO TO CY
    ld hl, $FFFF
    sbc hl, bc
    pop hl

    jr z, InitializeDoorTableLoopEnd

    dec hl

    ld b, 0
    ld c, 6
    call MemCpy

    jr InitializeDoorTableLoop

InitializeDoorTableLoopEnd:

    ret

;--------------------------------------------
; マップ上にドアを生成する
;--------------------------------------------
CreateDoor:

    push af
    push bc
    push de
    push hl

    ; マップタイプが9(pit)の場合は何もしない
    ; PIT内部にはドアは設置しないこと！！
    ld a, (WK_MAPTYPE)
    cp 9
    jp z, CreateDoorEnd 

    ld a, (WK_MAPPOSX)
    ld (WK_VALUE01), a
    ld a, (WK_MAPPOSY)
    ld (WK_VALUE02), a

    ; 現在のMAP座標にドアがあればドアを描画する
    ld hl, WK_DOOR_TBL
    ld (WK_HLREGBACK), hl

CreateDoorLoop:

    ld hl, (WK_HLREGBACK)
    ld ix, hl

    ld a, (ix + 0)
    ld d, a
    ld a, (ix + 1)
    add a, d

    ; MAP座標に合致するドア情報がなければループを
    ; 抜ける

    jp z, CreateDoorEnd
    
    ; MAP座標と合致してるか確認する
    ld a, (WK_VALUE01)
    ld b, a
    ld a, (WK_VALUE02)
    ld c, a

    ld a, (ix + 0)
    ld l, a
    ld a, (ix + 1)
    ld h, a

    or a ; ZERO TO CY
    sbc hl, bc
    
    jp nz, CreateDoorLoopNextData

    ; 合致している

    ; ドアが開いていたら何もしない
    ld a, (ix + 5)
    or a
    jr nz, CreateDoorLoopNextData

    ; ドアを所定の位置に表示する
    ld a, (ix + 2) ; Y座標

    ; MAP_VIEWAREAの座標に変換する
    ld b, 3
    sub b    ; Y座標の3はMAP_VIEWAREAの0

    ld h, a
    ld e, 30

    call CalcMulti
    
    ld b, 0
    ld a, (ix + 3)
    dec a    ; X座標の1はMAP_VIEWAREAの0
    ld c, a
    add hl, bc

    ld de, WK_MAP_VIEWAREA
    add hl, de

    ; タイルを敷く
    ld a, (ix + 4)
    cp 17
    jr nz, DoorBlueDoor

    ld de, DOOR_TILES_YELLOW

    jr DoorPutTiles

DoorBlueDoor:
    
    ld de, DOOR_TILES_BLUE

DoorPutTiles:

    ; MAP座標 X=1, Y=3の場合は
    ; PASSPORTを所持していないと
    ; 邪魔者がドアを上書きする
    push hl
    ld a, (WK_VALUE01)
    ld b, a
    ld a, (WK_VALUE02)
    ld c, a
    ld hl, $0103
    or a
    sbc hl, bc
    pop hl
    jr nz, DoorPutTileNormalDoor

    ; PASSORT（ツールの$08）を取得しているかチェックする
    ; Aレジスタ=1であれば取得している
    ld a, $88
    call CheckEquipItems
    or a
    jr nz, DoorPutTileNormalDoor
    
    ld de, DOOR_TILE_GUARDMAN

DoorPutTileNormalDoor:

    ld a, (de)
    ld (hl), a ; 左上

    inc hl
    inc de
    inc de

    ld a, (de)
    ld (hl), a ; 右上

    dec de
    ld b, 0
    ld c, 29
    add hl, bc

    ld a, (de)
    ld (hl), a ; 左下

    inc hl
    inc de
    inc de

    ld a, (de)
    ld (hl), a ; 右下

CreateDoorLoopNextData:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld (WK_HLREGBACK), hl

    jp CreateDoorLoop
    
CreateDoorEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; ドアを開ける
; WK_VALUE05に以下のいずれかをセットして
; 呼び出すこと
; 17 : 黄色鍵
; 18 : 青色鍵
;--------------------------------------------
OpenDoor:

    push af
    push bc
    push de

    ; CheckUsedItemItemUseEndで
    ; HLREGBACKを使用しているため
    ; その値を壊さないようにする
    ld hl, (WK_HLREGBACK)
    push hl

    ; プレイヤー近隣にドアがあるかチェックする

    ; MAP座標を取得する
    ld a, (WK_MAPPOSX)
    ld (WK_VALUE01), a
    ld a, (WK_MAPPOSY)
    ld (WK_VALUE02), a

    ; ドアテーブルからドア情報を取得する
    ld hl, WK_DOOR_TBL
    ld (WK_HLREGBACK), hl

    ld a, (WK_MAPPOSX)
    ld (WK_VALUE01), a
    ld a, (WK_MAPPOSY)
    ld (WK_VALUE02), a

    ; プレイヤーの座標に隣接しているか調べる
    ld a, (WK_PLAYERPOSX)
    call DivideBy8
    ld a, d ; X座標
    ld (WK_VALUE03), a

    ld a, (WK_PLAYERPOSY)
    call DivideBy8
    ld a, d ; Y座標
    ld (WK_VALUE04), a
    
    ; 現在のMAP座標にドアがあればドアを描画する
    ld hl, WK_DOOR_TBL
    ld (WK_HLREGBACK), hl

OpenDoorLoop:

    ld hl, (WK_HLREGBACK)
    ld ix, hl

    ld a, (ix + 0)
    ld d, a
    ld a, (ix + 1)
    add a, d

    ; MAP座標に合致するドア情報がなければループを
    ; 抜ける

    jp z, OpenDoorNotFoundEnd
    
    ; MAP座標と合致してるか確認する
    ld a, (WK_VALUE01)
    ld b, a
    ld a, (WK_VALUE02)
    ld c, a

    ld a, (ix + 0)
    ld l, a
    ld a, (ix + 1)
    ld h, a

    or a ; ZERO TO CY
    sbc hl, bc
    
    jp nz, OpenDoorLoopNextData

    ; 合致している

    ; ドア位置と合致しているか確認する
   
    ; 同じY位置か？
    ld a, (WK_VALUE04) ; Y
    ld b, a

    ld a, (ix + 2) ; ドアのY
    cp b
    jr z, OpenDoorMatchY
    
    ; 上?
    dec a
    dec a

    cp b
    jr z, OpenDoorMatchY

    ; 下?
    inc a
    inc a
    inc a
    inc a

    cp b
    jr z, OpenDoorMatchY

    ; Y座標が合致しない場合は次のデータ
    jr OpenDoorLoopNextData

OpenDoorMatchY:

    ; 同じX位置か？
    ld a, (WK_VALUE03) ; X
    ld b, a

    ld a, (ix + 3) ; ドアのX
    cp b
    jr z, OpenDoorMatchX
    
    ; 左?
    dec a
    dec a

    cp b
    jr z, OpenDoorMatchX

    ; 右?
    inc a
    inc a
    inc a
    inc a

    cp b
    jr z, OpenDoorMatchX

    ; X座標が合致しない場合は次のデータ
    jr OpenDoorLoopNextData

OpenDoorMatchX:

    ; ドアのX,Yが隣接している場合は
    ; 対象となるタイル番号を調べる
    ; タイル番号はWK_VALUE05に入っている

    ld a, (WK_VALUE05)
    ld b, a

    ld a, (ix + 4)
    cp b
    jr nz, OpenDoorLoopNextData

OpenDoorMatch:

    ; 完全にマッチ

    ld a, (ix + 2)
    ld b, 3
    sub b    ; Y座標の3はMAP_VIEWAREAの0

    ld h, a
    ld e, 30

    call CalcMulti
    
    ld de, WK_MAP_VIEWAREA
    add hl, de

    ld a, (ix + 3)
    dec a    ; X座標の1はMAP_VIEWAREAの0

    ld b, 0
    ld c, a
    add hl, bc

    ld a, $22
    ld (hl), a ; 左上

    inc hl

    ld (hl), a ; 右上

    ld b, 0
    ld c, 29
    add hl, bc

    ld (hl), a ; 左下

    inc hl

    ld (hl), a ; 右下

    ; WK_MAP_VIEWAREAの内容をバックアップする
    ld hl, WK_MAP_VIEWAREA
    ld de, WK_MAP_VIEWAREA_DISP
    ld bc, 600
    call MemCpy

    ; ドアテーブルの開閉フラグを1（開）に変更する
    ld a, 1
    ld (ix + 5), a

    ; ld (WK_REDRAW_FINE), a

    jr OpenDoorEnd

OpenDoorLoopNextData:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld (WK_HLREGBACK), hl

    jp OpenDoorLoop
    
OpenDoorNotFoundEnd:

    xor a

OpenDoorEnd:

    ; 鍵開けに成功した場合はAレジスタには
    ; 1がセットされて返却される

    pop hl

    ; CheckUsedItemItemUseEndで
    ; HLREGBACKを使用しているため
    ; その値を壊さないようにする
    ld (WK_HLREGBACK), hl

    pop de
    pop bc
    pop af

    ret

; ここから下はドア情報

DOOR_POSITION_DATA:
; 78 byte
; マップ座標XY
; ドア位置 LOCATE Y,ドア位置 LOCATE,X,ドアタイル番号,状態(1:開いている 0:閉じてる)
; ドアタイル番号 17=YELLOW, 18=BLUE

; #01: MAP X=0, Y=2
defw $0002
defb  7, 27, 18, 0

; #02: MAP X=0, Y=5
defw $0005
defb 17,  7, 17, 0

; #03: MAP X=1, Y=0
defw $0100
defb 11, 25, 17, 0

; #04: MAP X=1, Y=0
defw $0100
defb 19, 27, 17, 0

; #05: MAP X=1, Y=2
defw $0102
defb 11, 25, 18, 0

; #06: MAP X=1, Y=3
defw $0103
defb 19, 29, 17, 0

; #07: MAP X=1, Y=5
defw $0105
defb 19, 21, 17, 0

; #08: MAP X=3, Y=1
defw $0301
defb 19, 27, 18, 0

; #09: MAP X=3, Y=2
defw $0302
defb  5,  21, 18, 0

; #10: MAP X=3, Y=3
defw $0303
defb  9, 13, 18, 0

; #11: MAP X=3, Y=5
defw $0305
defb 13,  3, 18, 0

; #12: MAP X=4, Y=0
defw $0400
defb  9,  3, 18, 0

; #13: MAP X=4, Y=5
defw $0405
defb 19,  7, 18, 0

; #14: MAP X=2, Y=2
defw $0202
defb  9,  3, 17, 0

; #15: MAP X=3, Y=0
defw $0300
defb 17,  9, 18, 0

; #16: MAP X=2, Y=3
defw $0203
defb 17, 29, 18, 0

; #17: MAP X=1, Y=5
defw $0105
defb 11, 29, 17, 0

; #18: MAP X=5, Y=0
defw $0500
defb  5, 21, 18, 0

; #19: MAP X=4, Y=3
defw $0403
defb  5, 19, 18, 0

; End of Data
defw $FFFF
