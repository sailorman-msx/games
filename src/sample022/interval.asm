; ==========================================================================================
;
; interval.asm
;
; licence:MIT Licence
; copyright-holders:Hitoshi Iwai(aburi6800)
; modified by:Hitoshi Inoue(brapunch2000)
;
; ==========================================================================================

; ==========================================================================================
; H.TIMI割り込みハンドラ初期化
; ==========================================================================================
INIT_H_TIMI_HANDLER:

    push af
    push bc
    push de
    push hl

    di

    ; ■H.TIMIバックアップ
    ld hl, H_TIMI                   ; 転送元
    ld de, H_TIMI_BACKUP            ; 転送先
    ld bc, 5                        ; 転送バイト数
    ldir

    ; ■H.TIMI書き換え
    ld a, $C3                        ; JP
    ld hl, H_TIMI_HANDLER            ; サウンドドライバのアドレス
    ld (H_TIMI + 0), a
    ld (H_TIMI + 1), hl

    ei

    pop hl
    pop de
    pop bc
    pop af

    ret


; ==========================================================================================
; H.TIMI割り込み処理
; ==========================================================================================
H_TIMI_HANDLER:

    push af

    ; VSYNC_WAIT_CNTデクリメント
    ;   1/60ごとに-1される
    ;   メインルーチンの最初の設定値により
    ;     1 = 60フレーム
    ;     2 = 30フレーム
    ;   の処理となる
    ld a, (VSYNC_WAIT_CNT)
    or a
    jr z, H_TIMI_HANDLER_L1
    dec a
    ld (VSYNC_WAIT_CNT), a

H_TIMI_HANDLER_L1:

    ; 画面の初期化中は何もしない
    ld a, (WK_GAMESTATUS)
    or a
    jp z, IntervalEnd

    ld a, (WK_SPRREDRAW_FINE)
    or a
    jp z, SkipPutSprite

    call PutSprite

    xor a
    ld (WK_SPRREDRAW_FINE), a

SkipPutSprite:

    ; TIME05のデクリメントを行う
    ; ダイアログ表示中は再描画フラグはたてない
    ; ダイアログ側のタイミングで再描画する
    ld a, (WK_GAMESTATUS)
    cp 3
    jr z, SkipDecTime05

    ld a, (WK_TIME05)
    or a
    jr z, SetTime05

    dec a
    jr DecTime05End
    
SetTime05:

    ld a, 1
    ld (WK_REDRAW_FINE), a
    ld a, 2

DecTime05End:
    ld (WK_TIME05), a

SkipDecTime05:

    ld a, (WK_REDRAW_FINE)
    or a
    jr z, SkipRedrawScreen

    call PutPatternNameTable

    xor a
    ld (WK_REDRAW_FINE), a

    jr IntervalEnd

SkipRedrawScreen:

    nop

SetBlankScreen:

    ld d, $20

SetBlankScreenFull:

    ld hl, $1800
    ld bc, 768
    ld a, d
    call WRTVRMFIL

    ; ■バックアップ済のH.TIMIハンドラにチェーン
    ;   最後に必ず実行する

IntervalEnd:

    ; 割り込み処理の終了後は必ずEIを実施する
    ei

    pop af

    jp H_TIMI_BACKUP
