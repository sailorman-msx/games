;--------------------------------------------
; SUB-ROUTINE: MoveEnemyWizard
; ウイザードの移動処理
;--------------------------------------------
MoveEnemyWizard:

    ; WK_HLREGBACKにはキャラクター1体分の
    ; WK_SPRITEMOVE_TBLの先頭アドレスがセットされて
    ; 呼び出されてくる

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 4
    add hl, bc
    ld a, (hl)

    ; 2枚目のスプライト(カラーコード14)は処理しない
    cp 14
    jp z, MoveWizardEndNextData

    ;---------------------------------------
    ; テキキャラ移動の共通処理を呼び出す
    ;---------------------------------------
    ld de, WK_ENEMY_RESPAWN
    ld hl, MoveWizardResetMoveInfo
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
    jp nz, MoveWizardEndNextData

MoveWizardMoveFireball:

    ; ファイアボールが未発射状態であれば
    ; ファイアボールを発射する

    ; ただし、SPELLOFF RING装備時には
    ; ファイアボールは発射しない
    ld a, (WK_EQUIP_RING)
    cp 4
    jr z, MoveWizardEndNextData

    ld hl, (WK_HLREGBACK)
    ld ix, hl

    ld h, (ix + $0C)
    ld l, (ix + $0B)
    ld a, h

    or l ; HレジスタとLレジスタ双方が0であれば未発射状態となる
    jp nz, MoveWizardEndNextData

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

MoveWizardEndNextData:

    jp MoveEnemyNextDataAddCounter

;-------------------------------------------------------
; SUB-ROUTINE: MoveWizardResetMoveInfo
; ウイザードの移動方向と移動量をリセットする
; この処理では1枚目のスプライトの情報だけセットする
; 2枚目のスプライト情報のセットは共通処理で行う
;-------------------------------------------------------
MoveWizardResetMoveInfo:

    push hl

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 5
    add hl, bc
    ld a, (hl)
    ld (WK_VALUE02), a  ; 移動方向を退避

MoveWizardResetMoveInfoInit:

    ; 移動方向と移動量を初期化する

    ; ウイザードの移動方向は以下のとおり
    ; 進行方向が上(1)か下(5)の場合
    ;   ランダムに右か左のいずれか
    ; 進行方向が右(3)か左(7)の場合
    ;   ランダムに上か下のいずれか

    cp 3
    jp z, MoveWizardResetMoveInfoInitUD
    cp 5
    jp z, MoveWizardResetMoveInfoInitUD

MoveWizardResetMoveInfoInitLR:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    and 00000001B ; 第0ビットだけにする
    
    ; 第0ビットが0であれば右とする
    jp nz, MoveWizardResetMoveInfoInitRight

    ld a, 7
    jp MoveWizardResetMoveInfoInitDistSet

MoveWizardResetMoveInfoInitRight:

    ld a, 3
    jp MoveWizardResetMoveInfoInitDistSet

MoveWizardResetMoveInfoInitUD:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    and 00000001B ; 第0ビットだけにする
    
    ; 第0ビットが0であれば上とする
    jp nz, MoveWizardResetMoveInfoInitUp

    ld a, 5
    jp MoveWizardResetMoveInfoInitDistSet

MoveWizardResetMoveInfoInitUp:

    ld a, 1

MoveWizardResetMoveInfoInitDistSet:

    ld (hl), a ; +5 移動方向

    ; 移動方向によってパターン番号を特定する
    push hl

    ld hl, ENEMY_PTN_WIZ
    ld b, 0
    ld c, a
    add hl, bc
    ld a, (hl)

    pop hl

    dec hl
    dec hl
    ld (hl), a     ; パターン番号

    ; 2枚目のパターン番号をセットする
    ld b, 4
    add a, b
    ld d, a

    ld b, 0
    ld c, 16
    add hl, bc
    ld a, d
    ld (hl), d

    ; 移動量を決める

    ; レベルによって移動量を調整する
    ld a, (WK_VALUE01)
    cp 2
    jp z, MoveWizardDataDistLV2
    cp 3
    jp z, MoveWizardDataDistLV34
    cp 4
    jp z, MoveWizardDataDistLV34
    cp 5
    jp z, MoveWizardDataDistLV34
    
; 以下はLV#1の場合のみ
; LV#1の移動量はランダムとする
MoveWizardDataSetDist:

    call RandomValue
    ld a, (WK_RANDOM_VALUE)
    and 00001111B
    jp z, MoveWizardDataSetDist

    ld b, 00000111B ; 最小1、最大8
    and b ; 移動量を0-3または0-7の値にマスクする

    jp MoveWizardDataSetDistEnd

MoveWizardDataDistLV2:

    ld a, 6 ; LV#2は常時移動量は6(3タイル)
    jp MoveWizardDataSetDistEnd

MoveWizardDataDistLV34:

    ld a, 2 ; LV#3は常時移動量は2(1タイル)

MoveWizardDataSetDistEnd:

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
    jp z, MoveWizardDataSetDistY

MoveWizardDataSetDistX:

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 6
    add hl, bc

    ld a, (WK_VALUE01)
    ld (hl), a           ; +6 X移動量
    
    jp MoveWizardResetMoveInfoEnd

MoveWizardDataSetDistY:

    ; 下位4ビットを取得
    ld a, b
    and $0F

    or 0
    jp z, MoveWizardResetMoveInfoEnd

    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 7
    add hl, bc

    ld a, (WK_VALUE01)
    ld (hl), a           ; +7 Y移動量

MoveWizardResetMoveInfoEnd:

    ; インターバル値をセットする
    ld hl, (WK_HLREGBACK)
    ld b, 0
    ld c, 15
    add hl, bc
    ld (hl), 10

    pop hl

    jp MoveEnemyCommonPopEnd
