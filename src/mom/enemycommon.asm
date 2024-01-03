;--------------------------------------------
; SUB-ROUTINE: MoveEnemyCommonProc
; テキキャラの移動処理共通
; Hlレジスタ：テキキャラのテーブルアドレス
; 使用する変数
; WK_VALUE01
; WK_VALUE02
;
; マジックミサイルの発射処理は
; 各種テキキャラのメインルーチンで実施すること
; 
;--------------------------------------------
MoveEnemyCommonProc:

    push af
    push bc
    push de
    push hl

    ; WK_HLREGBACKにはキャラクター1体分の
    ; WK_SPRITEMOVE_TBLの先頭アドレスがセットされて
    ; 呼び出されてくる
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    ld (WK_VALUE01), a ; 種別

    ; 生命力が0であれば消失キャラとなる。
    ; 消失キャラであれば
    ; そのキャラクターのデータを消去する
    ld b, 0
    ld c, $0A
    add hl, bc
    ld a, (hl)   ; +10 : 生命力
    cp 1
    jp c, MoveEnemyCommonBusterdNextData

    ; レベルと種別を変数にセット
    ld hl, (WK_HLREGBACK)
    ld a, (hl)   ; +0 : 種別
    ld b, 0
    ld c, $0E
    add hl, bc
    ld a, (hl)   ; +14 : レベル
    ld (WK_VALUE02), a

    ; インターバル中は移動せず
    ; インターバル値のみデクリメントする
    inc hl
    ld a, (hl)   ; +15 : インターバル値
    or a
    jp nz, MoveEnemyCommonEndDec

    ; 移動処理
    ld hl, (WK_HLREGBACK)
    inc hl
    ld a, (hl)   ; +1 : Y座標を取得
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    inc hl
    ld a, (hl)   ; +2 : X座標を取得
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ; キャラのレベルによって移動仕様を変更する
    ld a, (WK_VALUE02)

    inc hl ; +3  ; パターン番号
    inc hl ; +4  ; カラー番号

    ; LV4のテキの場合、RINGを持っていたら白色で表示
    ; LV4のマジックミサイルであれば常に白色で表示
    cp 4
    jr nz, SkipSprite1Color

    ld a, (WK_VALUE01)
    cp 10
    jr z, SetSpriteColor15

    ld a, (WK_EQUIP_RING)
    cp 3
    jp nz, SetSpriteColor0

    ; スプライトカラーを白にする
    jr SetSpriteColor15

SetSpriteColor0:

    ; スプライトカラーを透明にする
    xor a
    ld (hl), a
    jr SkipSprite1Color

SetSpriteColor15:

    ld a, 15
    ld (hl), a

SkipSprite1Color:

    inc hl ; +5  ; 移動方向
    ld a, (hl)   ; 移動方向を取得
    cp 1
    jp z, MoveEnemyCommonProcUp    ; 上方向
    cp 3
    jp z, MoveEnemyCommonProcRight ; 右方向
    cp 5
    jp z, MoveEnemyCommonProcDown  ; 下方向

    jp MoveEnemyCommonProcLeft     ; 左方向

MoveEnemyCommonProcUp:

    ; 移動量が0であれば移動方向と移動量をセットしなおす
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld a, (hl)     ; +7 : Y移動量
    or 0
    jp z, MoveEnemyCommonProcResetMoveInfo

    ld a, (WK_CHECKPOSY)
    dec a

    ; 移動後のY座標が2であれば移動させない
    cp 2
    jp z, MoveEnemyCommonProcNoMove

    ld (WK_CHECKPOSY), a

    ; 移動先が移動可能かチェックする
    ; ただし、マジックミサイルとウイスプの場合は
    ; 移動先の障害物は無視する
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    cp 2  ; WISP ?
    jp z, MoveEnemyCommonProcUpMoveOkay
    cp 10 ; Fireball ?
    jp z, MoveEnemyCommonProcUpMoveOkay

    call GetVRAM4x4

    ld hl, WK_VRAM4X4_TBL + $05
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcUpCheckTile

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcUpCheckTile:
    
    ld hl, WK_VRAM4X4_TBL + $06
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcUpMoveOkay
    
    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcUpMoveOkay:
    
    ; 移動先が他のテキキャラのアドレスと
    ; 同じになるようであれば移動方向を変更する
    ld hl, (WK_HLREGBACK)
    call MoveEnemyCommonProcCheckYPos
    or a
    jp nz, MoveEnemyCommonProcNoMove
    
    ; 移動可能であればY座標を更新する
    ld hl, (WK_HLREGBACK)
    inc hl
    ld a, (WK_CHECKPOSY)
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld (hl), a     ; +1 : Y座標

    ; Y移動量をデクリメントする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld a, (hl)     ; +7 : Y移動量
    dec a
    ld (hl), a

    jp MoveEnemyCommonProcMoveEnd

MoveEnemyCommonProcRight:

    ; 移動量が0であれば移動方向と移動量をセットしなおす
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (hl)     ; +6 : X移動量
    or 0
    jp z, MoveEnemyCommonProcResetMoveInfo

    ld a, (WK_CHECKPOSX)
    inc a

    ; 移動後のX座標が30であれば移動させない
    cp 30
    jp z, MoveEnemyCommonProcNoMove

    ld (WK_CHECKPOSX), a

    ; 移動先が移動可能かチェックする
    ; ただし、マジックミサイルとウイスプの場合は
    ; 移動先の障害物は無視する
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    cp 2 ; Wisp ?
    jp z, MoveEnemyCommonProcRightMoveOkay
    cp 10 ; Fireball ?
    jp z, MoveEnemyCommonProcRightMoveOkay

    call GetVRAM4x4

    ld hl, WK_VRAM4X4_TBL + $06
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcRightCheckTile

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcRightCheckTile:

    ld hl, WK_VRAM4X4_TBL + $0A
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcRightMoveOkay

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcRightMoveOkay:

    ; 移動可能であればX座標を更新する
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 2
    add hl, bc
    ld a, (WK_CHECKPOSX)
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld (hl), a       ; +2 : X座標

    ; X移動量をデクリメントする
    inc hl   ; +3
    inc hl   ; +4
    inc hl   ; +5
    inc hl   ; +6 : X移動量
    ld a, (hl)
    dec a
    ld (hl), a

    jp MoveEnemyCommonProcMoveEnd

MoveEnemyCommonProcDown:

    ; 移動量が0であれば移動方向と移動量をセットしなおす
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc
    ld a, (hl)
    or 0
    jp z, MoveEnemyCommonProcResetMoveInfo

    ld a, (WK_CHECKPOSY)
    inc a

    ; 移動後のY座標が22であれば移動させない
    cp 22
    jp z, MoveEnemyCommonProcNoMove

    ld (WK_CHECKPOSY), a

    ; 移動先が移動可能かチェックする
    ; ただし、マジックミサイルとウイスプの場合は
    ; 移動先の障害物は無視する
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    cp 2 ; Wisp ?
    jp z, MoveEnemyCommonProcDownMoveOkay
    cp 10 ; Fireball ?
    jp z, MoveEnemyCommonProcDownMoveOkay

    call GetVRAM4x4

    ld hl, WK_VRAM4X4_TBL + $09
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcDownCheckTile

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcDownCheckTile:

    ld hl, WK_VRAM4X4_TBL + $0A
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcDownMoveOkay

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcDownMoveOkay:

    ; 移動先が他のテキキャラのアドレスと
    ; 同じになるようであれば移動方向を変更する
    ld hl, (WK_HLREGBACK)
    call MoveEnemyCommonProcCheckYPos
    or a
    jp nz, MoveEnemyCommonProcNoMove

    ; 移動可能であればY座標を更新する
    ld hl, (WK_HLREGBACK)
    inc hl
    ld a, (WK_CHECKPOSY)
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld (hl), a     ; +1 : Y座標

    ; Y移動量をデクリメントする
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (hl)     ; +7 : Y移動量
    dec a
    ld (hl), a

    jp MoveEnemyCommonProcMoveEnd

MoveEnemyCommonProcLeft:

    ; 移動量が0であれば移動方向と移動量をセットしなおす
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc
    ld a, (hl)     ; +6 : X移動量
    or 0
    jp z, MoveEnemyCommonProcResetMoveInfo

    ld a, (WK_CHECKPOSX)
    dec a

    ; 移動後のX座標が0であれば移動させない
    or 0
    jp z, MoveEnemyCommonProcNoMove

    ld (WK_CHECKPOSX), a

    ; 移動先が移動可能かチェックする
    ; ただし、マジックミサイルとウイスプの場合は
    ; 移動先の障害物は無視する
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    cp 2 ; Wisp ?
    jp z, MoveEnemyCommonProcLeftMoveOkay
    cp 10 ; Fireball ?
    jp z, MoveEnemyCommonProcLeftMoveOkay

    call GetVRAM4x4

    ld hl, WK_VRAM4X4_TBL + $05
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcLeftCheckTile

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcLeftCheckTile:

    ld hl, WK_VRAM4X4_TBL + $09
    ld a, (hl)
    cp $22
    jp z, MoveEnemyCommonProcLeftMoveOkay

    cp $64
    jp c, MoveEnemyCommonProcNoMove   ; A < $64
    cp $70
    jp nc, MoveEnemyCommonProcNoMove  ; A >= $70

MoveEnemyCommonProcLeftMoveOkay:

    ; 移動可能であればX座標を更新する
    ld hl, (WK_HLREGBACK)
    inc hl   ; +1
    inc hl   ; +2
    ld a, (WK_CHECKPOSX)
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld (hl), a       ; +2 : X座標

    ; X移動量をデクリメントする
    ld b, 0
    ld c, 4
    add hl, bc
    ld a, (hl)       ; +6 : X移動量
    dec a
    ld (hl), a

    jp MoveEnemyCommonProcMoveEnd

MoveEnemyCommonProcMoveEnd:

    ; 移動できた場合は衝突判定を行う

    ld hl, (WK_HLREGBACK)
    ld  a, 1   ; TYPE1で衝突判定を行う
    call CheckCollisionSprite

    ; 剣を振ってる状態であればTYPE2でも
    ; 衝突判定を行う
    push hl
    ld hl, WK_SPRITE_MOVETBL
    inc hl
    ld a, (hl) ; Y座標
    ld (WK_VALUE04), a
    inc hl
    ld a, (hl) ; X座標
    ld (WK_VALUE03), a
    pop hl

    ld  a, 2   ; TYPE2でも衝突判定を行う
    call CheckCollisionSprite

    ; 移動できた場合はインターバル値を初期化する
    jp MoveEnemyCommonEndSetInterval

MoveEnemyCommonProcNoMove:

    ; 移動しない（できない）場合の処理

    ; 衝突判定を行う

    ld hl, (WK_HLREGBACK)
    ld  a, 1   ; TYPE1で衝突判定を行う
    call CheckCollisionSprite

    ; 剣を振ってる状態であればTYPE2でも
    ; 衝突判定を行う
    push hl
    ld hl, WK_SPRITE_MOVETBL
    inc hl
    ld a, (hl) ; Y座標
    ld (WK_VALUE04), a
    inc hl
    ld a, (hl) ; X座標
    ld (WK_VALUE03), a
    pop hl

    ld  a, 2   ; TYPE2でも衝突判定を行う
    call CheckCollisionSprite

MoveEnemyCommonProcResetMoveInfo:

    ; テキキャラの再生成処理は
    ; WK_ENEMY_RESPAWNに格納されている
    ; アドレスにて処理を行う
    ; 呼び出し先では再生処理終了時にかならず
    ; MoveEnemyCommonPopEndにジャンプする
    ; マジックミサイルの場合は
    ; 再生成は行わずデータ消去のみ行う

    ld hl, (WK_ENEMY_RESPAWN)
    jp (hl)

MoveEnemyCommonEndDec:

    ld hl, (WK_HLREGBACK)

    ld  a, 1   ; TYPE1で衝突判定を行う
    call CheckCollisionSprite

    ; 剣を振ってる状態であればTYPE2でも
    ; 衝突判定を行う
    push hl
    ld hl, WK_SPRITE_MOVETBL
    inc hl
    ld a, (hl) ; Y座標
    ld (WK_VALUE04), a
    inc hl
    ld a, (hl) ; X座標
    ld (WK_VALUE03), a
    pop hl

    ld  a, 2   ; TYPE2でも衝突判定を行う
    call CheckCollisionSprite

    jp MoveEnemyCommonPopEnd

MoveEnemyCommonEndSetInterval:

    ld hl, (WK_HLREGBACK)
    ld a, (hl)

    ; ファイアボールのインターバル値は1/60秒
    ; テキキャラのインターバル値は10/60秒
    ld d, 10
    cp 10  ; Fireballか？
    jp nz, MoveEnemyCommonEndSetIntervalSet

    ld d, 1

MoveEnemyCommonEndSetIntervalSet:

    ; テキキャラが動いたらスプライト再描画フラグをONにする
    ld b, 0
    ld c, $0F
    add hl, bc
    ld a, d     ; 種別コードにあわせたインターバル値をセット
    ld (hl), a

    jp MoveEnemyCommonPopEnd

MoveEnemyCommonBusterdNextData:
    
    ; テキキャラが消失している場合は
    ; テキキャラの座標をクリアする
    ; 種別コードが10の場合（ファイアボールの場合）は
    ; 発射元となるテキキャラのファイアボールアドレスを
    ; クリアする
    ld hl, (WK_HLREGBACK)

    ld a, (hl)
    cp 10 ; Fireball ?
    jp nz, MoveEnemyCommonBusterdNextDataSkipFireball

    ; ファイアボールの発射元のテキキャラアドレスを取得する
    push hl
    pop ix
    ld l, (ix + $0B)
    ld h, (ix + $0C) ; HL=発射元テキキャラアドレス

    ld b, 0
    ld c, $0B
    add hl, bc

    ; 発射元テキキャラアドレスからファイアボールのアドレスを
    ; 消去する
    xor a
    ld (hl), a
    inc hl
    ld (hl), a
    
    ; ファイアボールを消す
    ld hl, (WK_HLREGBACK)
    inc hl      ; 種別コードは0クリアしてはいけない！！
    ld bc, 15   ; テキキャラ情報をゼロクリアする
    ld a, 0
    call MemFil

MoveEnemyCommonPopEnd:
MoveEnemyCommonBusterdNextDataSkipFireball:

    ; 1体ぶんの処理終了

    ; ウイザード、WOODY、スケルトンの場合、2枚目のスプライト情報にも
    ; 同じ値をセットする
    ; セットする値は、Y座標、X座標、パターン番号、カラー、インターバル値とする
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    cp 3
    jr z, MoveEnemyCommonPopEnd2sprites
    cp 4
    jr z, MoveEnemyCommonPopEnd2sprites
    cp 5
    jr z, MoveEnemyCommonPopEnd2sprites

    jr MoveEnemyCommonPopEndNot2sprites 

MoveEnemyCommonPopEnd2sprites:

    push hl
    ld hl, (WK_HLREGBACK)
    ld a, (hl)
    ld (WK_VALUE01), a ; 種別をセット
    ld b, 0
    ld c, 14
    add hl, bc
    ld a, (hl)
    ld (WK_VALUE02), a ; レベルをセット
    inc hl
    inc hl
    ld d, h      ; 2枚目の情報アドレスをDEレジスタにセットする
    ld e, l
    pop hl

    inc hl
    inc de
    ld a, (hl)
    ld (de), a   ; +1: Y座標

    inc hl
    inc de
    ld a, (hl)
    ld (de), a   ; +2: X座標

    inc hl
    inc de
    ld a, (hl)   ; +3: パターン番号
    ld b, 4
    add a, b
    ld (de), a

    inc de
    ld a, (WK_VALUE01) ; 種別
    cp 4
    jp z, MoveEnemyCommonSetWoodyColor

    ; ウイザード、スケルトンの2枚目のカラー
    ; LIGHT RINGを持っていなければ
    ; LV4のテキは透明

    ld b, $0E

    ld a, (WK_VALUE02) ; レベル
    cp 4
    jp nz, SkipMoveEnemyCommonLV4WizColor

    ; LV4のWizard, Skeltonの2枚目のカラー設定
    ld a, (WK_EQUIP_RING)
    cp 3
    jr z, SkipMoveEnemyCommonLV4WizColor

    ld b, $00 ; 透明にする

SkipMoveEnemyCommonLV4WizColor:
    ld a, b
    jr MoveEnemyCommonSetColor

MoveEnemyCommonSetWoodyColor:

    ; WOODYの2枚目のカラー
    ; LIGHT RINGを持っていなければ
    ; LV4のテキは透明

    ld b, $08

    ld a, (WK_VALUE02)
    cp 4
    jp nz, SkipMoveEnemyCommonLV4WoodColor

    ld a, (WK_EQUIP_RING)
    cp 3
    jr z, SkipMoveEnemyCommonLV4WoodColor

    ld b, $00 ; 透明にする

SkipMoveEnemyCommonLV4WoodColor:
    ld a, b

MoveEnemyCommonSetColor:

    ld (de), a   ; +4: 2枚目のカラーコード

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 15
    add hl, bc
    ld a, (hl)

    inc de ; +5
    inc de ; +6
    inc de ; +7
    inc de ; +8
    inc de ; +9
    inc de ; +10
    inc de ; +11
    inc de ; +12
    inc de ; +13
    inc de ; +14
    inc de ; +15

    ld (de), a   ; インターバル値

MoveEnemyCommonPopEndNot2sprites:

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------------------
; SUB-ROUTIN: MoveEnemyCommonProcCheckYPos
; テキキャラ移動時に他のテキキャラの
; Y座標と平行方向が重複するかチェックを行う
; HLレジスタ：移動させようとしているテキキャラのアドレス
; 戻り値：
; Aレジスタ：0=重複しない 1=重複する
;---------------------------------------------------------
MoveEnemyCommonProcCheckYPos:

    push hl

    ; ファイアボールはチェック除外とする
    ld a, (hl)
    cp 10
    jp z, MoveEnemyCommonProcCheckYPosOKEnd

    ; ファイアボール以外はY座標が並ばないようにする
    inc hl
    ld a, (hl) ; Y座標
    
    ld a, (WK_CHECKPOSY)
    ld (WK_VALUE02), a

    ; 
    ; WK_SPRITE_MOVETBLのY座標を取得し
    ; Y座標が重複するかチェックを行う

    ld hl, WK_SPRITE_MOVETBL + 48
    ld b, 0
    ld c, 16
    ld (WK_BCREGBACK), bc

MoveEnemyCommonProcCheckYPosLoop:

    ld d, h
    ld e, l

    ld a, (hl)
    or a
    jp z, MoveEnemyCommonProcCheckYPosOKEnd

    ; ファイアボールであればスキップ
    cp 10
    jp z, MoveEnemyCommonProcCheckYPosLoopNext

    ; ウイザード、スケルトンでなおかつ2枚目であればスキップ
    cp 4
    jp z, MoveEnemyCommonProcCheckYPosWoody

    ld b, 0
    ld c, 4
    add hl, bc
    ld a, (hl)
    ld h, d
    ld l, e
    cp $0E
    jp nz, MoveEnemyCommonProcCheckYPosLoopStep1

    jp MoveEnemyCommonProcCheckYPosLoopNext

MoveEnemyCommonProcCheckYPosWoody:

    ; WOODYでなおかつ2枚目であればスキップ
    cp 4
    jp nz, MoveEnemyCommonProcCheckYPosLoopStep1

    ld b, 0
    ld c, 4
    add hl, bc
    ld a, (hl)
    ld h, d
    ld l, e
    cp $08
    jp nz, MoveEnemyCommonProcCheckYPosLoopStep1

    jp MoveEnemyCommonProcCheckYPosLoopNext

MoveEnemyCommonProcCheckYPosLoopStep1:

    ; 移動対象となるデータと同じであればスキップ
    push hl
    
    ld hl, (WK_HLREGBACK)
    ld a, h
    sub a, d
    ld b, a    ; H - D -> B
    ld a, l
    sub a, e   ; L - E -> A
    add a, b   ; A + B -> A

    pop hl

    jp z, MoveEnemyCommonProcCheckYPosLoopNext

    inc hl ; +1 : Y座標
    ld a, (hl)
    dec hl
    call DivideBy8

    ld a, (WK_VALUE02)

    sub d      ; A=ABS(移動しようといているキャラのPOSY - 他のキャラのPOSY)
    call AbsA

    ; LOCATE Y座標の差が2以上離れていなければ移動不可と判定する
    cp 2
    jp c, MoveEnemyCommonProcCheckYPosNGEnd

MoveEnemyCommonProcCheckYPosLoopNext:

    ld bc, (WK_BCREGBACK)
    add hl, bc

    jp MoveEnemyCommonProcCheckYPosLoop

MoveEnemyCommonProcCheckYPosOKEnd:

    ld a, 0
    jp MoveEnemyCommonProcCheckYPosPopEnd
    
MoveEnemyCommonProcCheckYPosNGEnd:

    ld a, 1

MoveEnemyCommonProcCheckYPosPopEnd:

    pop hl

    ld (WK_HLREGBACK), hl

    ret
