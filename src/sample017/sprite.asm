;--------------------------------------------
; スプライト関連の処理
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: CreateSpritePattern
; スプライトパターンと
; 仮想スプライトアトリビュートテーブルを作成する
;--------------------------------------------
CreateSpritePattern:

    ;--------------------------------------------
    ; スプライトパターンデータをVRAMの
    ; スプライトパターンジェネレータテーブルに
    ; 転送する
    ;--------------------------------------------
    ld hl, SPRPTN
    ld de, $3800   ; スプライトパターンのVRAM先頭アドレスは3800H
    ld bc, 512     ; BALL: 1体あたり64バイトx4パターン PLAYER: 1対あたり64バイトx4 パターン
    call WRTVRMSERIAL

    ret
    
;--------------------------------------------
; SUB-ROUTINE: InitializeVirtSpritePattern
; 仮想スプライトアトリビュートテーブルを初期化する
;--------------------------------------------
InitializeVirtSpritePattern:

    ;--------------------------------------------
    ; 仮想スプライトアトリビュートテーブルを作成する
    ; 32体分作成する
    ;--------------------------------------------
    ld hl, WK_VIRT_SPR_ATTR_TBL

    ld a, 168
    ld (WK_PLAYERPOSY), a
    ld (hl), a ; PLAYER Y座標
    inc l
    
    ld a, 8
    ld (WK_PLAYERPOSX), a
    ld (hl), a ; PLAYER X座標
    inc l

    ld a, 32
    ld (hl), 32
    inc l

    ld a, (WK_PLAYERSPRCLR1)
    ld (hl), a
    inc l

    ld a, 168
    ld (hl), a ; PLAYER Y座標
    inc l
    
    ld a, 8
    ld (hl), a ; PLAYER X座標
    inc l

    ld a, 32
    ld (hl), 36
    inc l

    ld a, (WK_PLAYERSPRCLR2)
    ld (hl), a
    inc l

    ; SPITE#2 - SPRITE#31までの
    ; アトリビュート情報を初期化
    ; 30枚 x 4byte = 120 byte

    ld b, 120

InitializeVirtSpritePatternLoop1:

    ld a, 0

    ld (hl), a
    inc l

    djnz InitializeVirtSpritePatternLoop1

    ;--------------------------------------------
    ; スプライト座標管理用テーブルを初期化する
    ; 32体分作成する
    ;--------------------------------------------
    ld hl, WK_SPRITE_MOVETBL

    ld a, 168
    ld (hl), a ; PLAYER Y座標
    inc l
    
    ld a, 8
    ld (hl), a ; PLAYER X座標
    inc l

    ld a, 32
    ld (hl), 32
    inc l

    ld a, (WK_PLAYERSPRCLR1)
    ld (hl), a
    inc l

    ld a, 0
    ld (hl), a
    inc l
    ld (hl), a
    inc l

    ld a, 168
    ld (hl), a ; PLAYER Y座標
    inc l
    
    ld a, 8
    ld (hl), a ; PLAYER X座標
    inc l

    ld a, 32
    ld (hl), 36
    inc l

    ld a, (WK_PLAYERSPRCLR2)
    ld (hl), a
    inc l

    ld a, 0
    ld (hl), a
    inc l
    ld (hl), a
    inc l

    ; SPITE#2 - SPRITE#31までの
    ; スプライト管理情報を初期化
    ; 30枚 x 6byte = 1 byte

    ld b, 180

InitializeVirtSpritePatternLoop2:

    ld a, 0

    ld (hl), a
    inc l

    djnz InitializeVirtSpritePatternLoop2

    ret

;--------------------------------------------
; SUB-ROUTINE: CreateSpriteMoveTable
; スプライト座標管理用テーブルを作成する
; WK_STAGE_NUM*3 ぶん作成する
;--------------------------------------------
CreateSpriteMoveTable:

    ; 仮想スプライトアトリビュートを初期化する
    call InitializeVirtSpritePattern

    ld hl, WK_SPRITE_MOVETBL

    ld de, 12   ; PLAYERのスプライトぶんだけスキップする
    add hl, de

    ld a, (WK_STAGE_NUM)
    ld c, a
    add a, a
    add a, c ; 3倍

    ld b, a

CreateSpriteMoveTableLoop:

    ; Y座標の初期化

    call InitialSpriteMoveTableY
    ld (hl), a
    inc l

    ; X座標の初期化

    call InitialSpriteMoveTableX
    ld (hl), a
    inc l

    ; パターン番号のセット
    ld a, 0
    ld (hl), a
    inc l

    ; カラーのセット
    call GetSpriteColor
    ld (hl), a
    inc l

    ; 移動方向のセット
    call InitialSpriteMoveTableMove
    ld a, d
    ld (hl), a
    inc l
    ld a, e
    ld (hl), a
    inc l
    
    djnz CreateSpriteMoveTableLoop

    ret

InitialSpriteMoveTableY:

InitialSpriteMoveTableYLoop:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)

    ; 乱数値が167以上だったら再度乱数を取得する
    cp 167
    jp nc, InitialSpriteMoveTableYLoop

    ; 乱数値が24未満だったら再度乱数を取得する
    cp 24
    jp c, InitialSpriteMoveTableYLoop

    ret

InitialSpriteMoveTableX:

InitialSpriteMoveTableXLoop:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)

    ; 乱数値が233以上だったら再度乱数を取得する
    cp 233
    jp nc, InitialSpriteMoveTableXLoop

    ; 乱数値が8未満だったら再度乱数を取得する
    cp 8
    jp c, InitialSpriteMoveTableXLoop

    ret

InitialSpriteMoveTableMove:

    push bc

InitialSpriteMoveTableMoveXLoop:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    ld b, a  ; Bレジスタに乱数値を退避

    ; 乱数値の第0ビットによって移動量を決める
    and $01

InitialSpriteMoveXPlus:

    ; 1だったらプラス移動とする
    cp 1
    jp z, InitialSpriteMoveXMinus

    ld d, 1 ; Xの移動方向(+)

    jp InitialSpriteMoveYPlus

InitialSpriteMoveXMinus:

    ld d, $FF ; Xの移動方向(-)

InitialSpriteMoveYPlus:

    ld a, b   ; AレジスタにBレジスタの値(乱数値)をセット

    ; 乱数値の第4ビットによって移動量を決める
    and $10
    sra a
    sra a
    sra a
    sra a

    ; 1だったらマイナス移動とする
    cp 1
    jp z, InitialSpriteMoveYMinus

    ld e, 1 ; Yの移動方向(+)

    jp InitialSpriteMoveTableMoveEnd

InitialSpriteMoveYMinus:
    
    ld e, $FF ; Yの移動方向(-)

InitialSpriteMoveTableMoveEnd:

    pop bc

    ret

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

    ; Aレジスタの値からX座標の移動量を取得する
    ld hl, (WK_HLREGBACK)
    inc l
    inc l
    inc l
    inc l ; HL = HL + 4

    ld a, (hl) ; 移動量を取得

    cp 1
    jp nz, MoveSpriteMinusX

MoveSpritePlusX:

    ld hl, (WK_HLREGBACK)
    inc l
    ld a, (hl)
    inc a

    ; X座標が233以上になったら移動方向を逆転する
    cp 233
    call nc, MoveSpriteReverseX

    ld hl, (WK_HLREGBACK)
    inc l
    ld (hl), a

    jp MoveSpriteY

MoveSpriteMinusX:

    ld hl, (WK_HLREGBACK)
    inc l
    ld a, (hl)
    dec a

    ; X座標がマイナスになったら移動方向を逆転する
    cp 8
    call c, MoveSpriteReverseX
   
    ld hl, (WK_HLREGBACK)
    inc l
    ld (hl), a

MoveSpriteY:

    ; Aレジスタの値からY座標の移動量を取得する
    ld hl, (WK_HLREGBACK)
    inc l
    inc l
    inc l
    inc l
    inc l ; HL = HL + 5 

    ld a, (hl) ; 移動量を取得

    cp 1
    jp nz, MoveSpriteMinusY

MoveSpritePlusY:

    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    inc a

    ; Y座標が167以上になったら移動方向を逆転する
    cp 167
    call nc, MoveSpriteReverseY

    ld hl, (WK_HLREGBACK)
    ld (hl), a

    jp MoveSpriteEnd

MoveSpriteMinusY:

    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    dec a

    ; Y座標がマイナスになったら移動方向を逆転する
    cp 24
    call z, MoveSpriteReverseY
   
    ld hl, (WK_HLREGBACK)
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
    jp nz, MoveSpriteReverseXtoMinus

    ld a, 0

MoveSpriteReverseXtoMinus:

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

    cp 1
    jp nz,  MoveSpriteReverseXtoPlus

    ; Xの移動方向の符号を反転する
    ; 2の補数でマイナス値に変換する
    neg
    ld (hl), a

    ld a, 232

    jp MoveSpriteReverseXEnd

MoveSpriteReverseXtoPlus:

    ; Xの移動方向の符号を反転する
    ; 2の補数でプラス値に変換する
    neg
    ld (hl), a

    ld a, 8

MoveSpriteReverseXEnd:

    ret

MoveSpriteReverseY:

    ld hl, (WK_HLREGBACK)
    inc l
    inc l

    ld a, (hl) ; パターン番号を変える
    add a, 4
    
    cp 16
    jp nz, MoveSpriteReverseYtoMinus

    ld a, 0

MoveSpriteReverseYtoMinus:

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

    cp 1
    jp nz, MoveSpriteReverseYtoPlus

    ; Yの移動方向をマイナス方向に変更する
    ; 2の補数でマイナス値に変換する
    neg
    ld (hl), a

    ld a, 167

    jp MoveSpriteReverseYEnd

MoveSpriteReverseYtoPlus:

    ; Yの移動方向をプラス方向に変更する
    ; 2の補数でプラス値に変換する
    neg
    ld (hl), a

    ld a, 24

MoveSpriteReverseYEnd:

    ret

GetSpriteColor:

GetSpriteColorLoop:

    call RandomValue
    and 00001111B
    
    ; 1以下は再度乱数を取り直す
    cp 2
    jp c, GetSpriteColorLoop

    ; 第0ビットに1を立てる
    ; このことでカラー番号は必ず奇数になる
    or 00000001B
   
    ret

;--------------------------------------------
; SUB-ROUTINE: SetVirtAttrTable
; スプライト座標管理用テーブルを更新する
;--------------------------------------------
SetVirtAttrTable:

    ld b, 32

    ld hl, WK_SPRITE_MOVETBL
    ld (WK_HLREGBACK), hl

    ld de, WK_VIRT_SPR_ATTR_TBL

SetVirtAttrTableLoop:

    ld hl, (WK_HLREGBACK)
    ld a, (hl) ; Y座標
    inc l
    ld (WK_HLREGBACK), hl

    ld hl, de
    ld (hl), a
    inc e

    ld hl, (WK_HLREGBACK)
    ld a, (hl) ; Y座標
    inc l
    ld (WK_HLREGBACK), hl
    ld hl, de
    ld (hl), a
    inc e

    ld hl, (WK_HLREGBACK)
    ld a, (hl) ; パターン番号
    inc l
    ld (WK_HLREGBACK), hl
    ld hl, de
    ld (hl), a
    inc e

    ld hl, (WK_HLREGBACK)
    ld a, (hl) ; カラー
    inc l
    inc l ; X移動方向
    inc l ; Y移動方法
    ld (WK_HLREGBACK), hl

    ld hl, de
    ld (hl), a
    inc e

    djnz SetVirtAttrTableLoop

    ret

;--------------------------------------------
; SUB-ROUTINE: ShuffleSprite
; ワーク用スプライトアトリビュートテーブルの内容を
; 素数を使った形式(KONAMI方式)でシャッフルし
; その後、VDPポートを直接叩いて
; アトリビュートテーブルの内容をVRAMに転送する。
;--------------------------------------------
ShuffleSprite:

    ; VRAM書込み事前準備
    ; VDP書き込み用ポートに書き込みたいVRAMアドレスを
    ; セットする

    ; 直接、スプライトアトリビューﾄのVRAMアドレスを
    ; 書き換えるとテアリングが発生する可能性があるため
    ; 1C00Hにシャッフルした仮想アトリビュートテーブルを
    ; セットする
    ; シャッフルが終わったら1C00Hから128バイトぶんを
    ; 1B00Hに書き込む

    ld hl, $1C00
    call VDPWRT

    ld b, 32

    ; VRAM書込み事前準備
    ; HLレジスタにVDPに転送する先頭アドレスを
    ; セットする

    ld h, WK_VIRT_SPR_ATTR_TBL >> 8

    ld a, CONST_VDPPORT0
    ld c, a

    ld a, (WK_SPRITE0_NUM)

ShuffleSpriteLoop:

    ld l, a

    ; HLレジスタの指すメモリの4バイトぶんの内容を
    ; 事前準備でセットしたVRAMアドレスに対して書き込む
    ; OUTIを実行するとBレジスタがデクリメントされるので
    ; OUTIのつどBレジスタをインクリメント補正する
    ; VRAMへの書き換えを行ったら最低21ステート間隔を
    ; あける必要があるらしい

    outi  ; 16ステート
    inc b ;  4ステート
    nop   ;  4ステート

    outi
    inc b
    nop

    outi
    inc b
    nop

    outi
    inc b
    nop

    add a, 28   ; A = A + 7 * 4

    ; Aレジスタの値はスプライト番号*7のアドレス
    ; スプライトの最大数は32なので32*4-1で
    ; 128以上にならないようマスクする
    and a, 7FH

    ; 32回分ループする
    djnz ShuffleSpriteLoop

    ; 次のシャッフル値の基準値（アドレス）を決める

    add a, 76   ; A = A + 19 * 4
    and a, 7FH  ; Aレジスタの値が128以上にならないようマスク

    ; 次のシャッフルの基準値を変更する
    ld (WK_SPRITE0_NUM), a

    ret

;--------------------------------------------
; SUB-ROUTINE: PutSprite
; VRAM 1C00Hから128バイト分を
; VRAM 1B00Hに転送する
;--------------------------------------------
PutSprite:

    ; VRAMの1C00Hから128バイトぶんを
    ; データ表示用のワークテーブルに格納する
    ld hl, WK_DISP_SPR_ATTR_TBL
    ld de, $1C00
    ld bc, 128
    call REDVRMSERIAL

    ld hl, WK_DISP_SPR_ATTR_TBL
    ld de, $1B00
    ld bc, 128
    call WRTVRMSERIAL
    
    ret
