GameInitialize:

    xor a
    ld (WK_SPRITE0_NUM), a

    ;--------------------------------------------
    ; 乱数のSEED値を初期化する
    ;--------------------------------------------
    call InitRandom

    ;--------------------------------------------
    ; CLEAR SCREEN
    ;--------------------------------------------
    call ClearScreen

    ;--------------------------------------------
    ; アニメーション用パターン番号
    ;--------------------------------------------
    xor a
    ld (WK_ANIME_PTN), a

    ;--------------------------------------------
    ; プレイヤーの方向
    ;--------------------------------------------
    ld a, 5
    ld (WK_PLAYERDIST), a
    xor a
    ld (WK_PLAYERDIST_PRE), a

    ld hl, WK_SPRITE_MOVETBL
    ld d, 0
    ld e, 12

    inc hl ; 種別コード
    inc hl ; Y
    inc hl ; X
    ld a, 0
    ld (hl), a
    inc hl ; パターン番号
    ld a, 7 ; カラー
    ld (hl), a

    add hl, de
    
    inc hl ; 種別コード
    inc hl ; Y
    inc hl ; X
    ld a, 4
    ld (hl), a
    inc hl ; パターン番号
    ld a, 15 ; カラー
    ld (hl), a

    add hl, de
    
    inc hl ; 種別コード
    inc hl ; Y
    inc hl ; X
    ld a, 8
    ld (hl), a
    inc hl ; パターン番号
    ld a, 7 ; カラー
    ld (hl), a

    add hl, de
    
    inc hl ; 種別コード
    inc hl ; Y
    inc hl ; X
    ld a, 12
    ld (hl), a
    inc hl ; パターン番号
    ld a, 15 ; カラー
    ld (hl), a

    ; 初期状態のスプライトパターンを定義する
    ld a, 5
    ld (WK_SPRPTNCHG), a
    call VBLANK_sprredefine

    ld a, 5 * 8
    ld (WK_POSY), a
    ld a, 4 * 8
    ld (WK_POSX), a

    xor a
    ld (WK_FALLDOWN), a
    ld (WK_SURROUNDFLG), a

    ld a, $FF
    ld (WK_JUMPCNT), a

    ;--------------------------------------------
    ; 床の表示
    ;--------------------------------------------
    ld hl, GenMap
    ld (PAGE0_FUNC), hl
    call ChangePage0Call
    
    ; プレイヤーの初期表示
    call WallCollision
    call MovePlayer

    ;--------------------------------------------
    ; ゲームを開始する
    ;--------------------------------------------
    ld a, 1
    ld (WK_GAMESTATUS), a

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ;-------------------------------------------------
    ; 割り込み処理の初期処理
    ;-------------------------------------------------
    xor a
    ld (VSYNC_WAIT_CNT), a

    call INIT_H_TIMI_HANDLER

    ei

    ret
