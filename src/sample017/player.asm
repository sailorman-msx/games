;--------------------------------------------
; player.asm
; キー入力情報やトリガ情報をもとに
; プレイヤーのアクションを制御する
;--------------------------------------------
PlayerMove:

    ; プレイヤーの移動量を取得する
    ld  a, (WK_PLAYERDIST)

    or 0
    ret z ; カーソルキーやジョイスティックが押されていなければ処理終了

    ld hl, WK_MOVECONDITION_PROC

    add a, a ; Aレジスタの値を2倍する

    ld b, 0
    ld c, a
    
    add hl, bc ; 2倍した値を加算してジャンプ先のアドレスを決定する
    
    ; HLレジスタにはジャンプ先のアドレスが格納されているアドレスが
    ; セットされており、その「ジャンプ先のアドレス」を取得する

    ; ジャンプ先アドレスをBCレジスタにセット
    ld a, (hl)
    ld c, a 
    inc hl
    ld a, (hl)
    ld b, a
    
    ; BCレジスタの値（ジャンプ先アドレス）をHLレジスタにセット
    ld hl, bc

    jp (hl) ; 進行方向にあわせた処理に強制ジャンプ

PlayerMoveCheckEnd:
   
    ; 移動可能かチェックした結果はAレジスタに格納される
    ; 0(移動不可)の場合は即リターンする
    or 0
    ret z 

    ld hl, PLAYERMOVE_TBL
    ld  a, (WK_PLAYERDIST)

    add a, l

    ld l, a

    ld a, (hl) ; 方向にあわせて移動量を取得する
    ld c, a

PlayerMoveX:

    ; 上位4ビットがX方向の移動量
    sra a
    sra a
    sra a
    sra a
    and 00001111B

    cp 2
    jp z, PlayerMoveXMinus

    ld (WK_PLAYERMOVE_X), a

    jp PlayerMoveY

PlayerMoveXMinus:

    ld a, $FF
    ld (WK_PLAYERMOVE_X), a

PlayerMoveY:

    ; 下位4ビットがY方向の移動量
    ld a, c
    and 00001111B

    cp 2
    jp z, PlayerMoveYMinus

    ld (WK_PLAYERMOVE_Y), a

    jp PlayerMoveEnd

PlayerMoveYMinus:

    ld a, $FF
    ld (WK_PLAYERMOVE_Y), a

PlayerMoveEnd:

    ; WK_SPRITE_MOVETBLのプレイヤーの
    ; X, Y座標とパターン番号を更新する
    ; Bレジスタ=Xの移動量
    ; Cレジスタ=Yの移動量
    ; Dレジスタ=プレイヤーの向き

    ld hl, SPRDISTPTN_TBL

    ld  a, (WK_PLAYERDIST)
    add a, l
    ld l, a

    ld a, (hl)
    ld d, a
    add a, 4
    ld e, a

    ld a, (WK_PLAYERMOVE_X)
    add a, a  ; A = A * 2
    ld b, a

    ld a, (WK_PLAYERMOVE_Y)
    add a, a  ; A = A * 2
    ld c, a

    ld hl, WK_SPRITE_MOVETBL

    ld  a, (hl) ; SPRITE#0 Y座標
    add a, c
    ld (hl), a  ; +0

    ld (WK_PLAYERPOSY), a

    inc l
    ld  a, (hl) ; SPRITE#0 X座標
    add a, b
    ld (hl), a  ; +1

    ld (WK_PLAYERPOSX), a

    inc l       ; +2
    ld a, d
    ld (hl), a  ; パターン番号

    inc l       ; +3
    inc l       ; +4
    inc l       ; +5
    
    ld a, (WK_PLAYERMOVE_X)
    add a, a  ; A = A * 2
    ld b, a

    ld a, (WK_PLAYERMOVE_Y)
    add a, a  ; A = A * 2
    ld c, a

    inc l
    ld  a, (hl) ; SPRITE#1 Y座標
    add a, c
    ld (hl), a  ; +6

    inc l
    ld  a, (hl) ; SPRITE#2 X座標
    add a, b
    ld (hl), a  ; +7

    inc l       ; +8
    ld a, e
    ld (hl), a  ; パターン番号

    ret

;---------------------------------------------
; SUB-ROUTINE:移動可否判定処理
; Aレジスタ=0(移動不可), 1(移動可)
;---------------------------------------------

CheckMoveUp:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; Y座標が24で進行方向が1の場合は動かせない
    ld a, c
    cp 24
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveUpRight:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; Y座標が24で進行方向が2の場合は動かせない
    ld a, c
    cp 24
    jp z, CheckMoveConditionNG

    ; X座標が232で進行方向が2の場合は動かせない
    ld a, b
    cp 232
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveRight:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; X座標が232で進行方向が2の場合は動かせない
    ld a, b
    cp 232
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveDownRight:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; Y座標が168で進行方向が3の場合は動かせない
    ld a, c
    cp 168
    jp z, CheckMoveConditionNG

    ; X座標が232で進行方向が3の場合は動かせない
    ld a, b
    cp 232
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveDown:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; Y座標が168で進行方向が5の場合は動かせない
    ld a, c
    cp 168
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveDownLeft:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; Y座標が168で進行方向が6の場合は動かせない
    ld a, c
    cp 168
    jp z, CheckMoveConditionNG

    ; X座標がで進行方向が6の場合は動かせない
    ld a, b
    cp 8
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveLeft:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; X座標がで進行方向が7の場合は動かせない
    ld a, b
    cp 8
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveUpLeft:

    push bc

    ld  a, (WK_PLAYERPOSX)
    ld  b, a
    ld  a, (WK_PLAYERPOSY)
    ld  c, a
    
    ; Y座標が24で進行方向が8の場合は動かせない
    ld a, c
    cp 24
    jp z, CheckMoveConditionNG

    ; X座標が8で進行方向が8の場合は動かせない
    ld a, b
    cp 8
    jp z, CheckMoveConditionNG

    jp CheckMoveConditionOkay

CheckMoveConditionNG:

    ld a, 0
    jp CheckMoveConditionEnd

CheckMoveConditionOkay:

    ld a, 1

CheckMoveConditionEnd:

    pop bc

    jp PlayerMoveCheckEnd
