;-------------------------------------------- 
; 画面のステータス関連を操作するサブルーチン群
;--------------------------------------------

;-------------------------------------------- 
; ライフゲージを減算する
;--------------------------------------------
DecLifeGauge:

    ld ix, WK_PLAYERLIFEGAUGE

    ld a, (ix + 7)
    cp 1
    jr c, DecLifeGauge6

    dec a
    ld (ix + 7), a

    jr DecLifeGaugeEnd

DecLifeGauge6:

    ld a, (ix + 6)
    cp 1
    jr c, DecLifeGauge5

    dec a
    ld (ix + 6), a

    jr DecLifeGaugeEnd

DecLifeGauge5:

    ld a, (ix + 5)
    cp 1
    jr c, DecLifeGauge4

    dec a
    ld (ix + 5), a

    jr DecLifeGaugeEnd

DecLifeGauge4:

    ld a, (ix + 4)
    cp 1
    jr c, DecLifeGauge3

    dec a
    ld (ix + 4), a

    jr DecLifeGaugeEnd

DecLifeGauge3:

    ld a, (ix + 3)
    cp 1
    jr c, DecLifeGauge2

    dec a
    ld (ix + 3), a

    jr DecLifeGaugeEnd

DecLifeGauge2:

    ld a, (ix + 2)
    cp 1
    jr c, DecLifeGauge1

    dec a
    ld (ix + 2), a

    jr DecLifeGaugeEnd

DecLifeGauge1:

    ld a, (ix + 1)
    cp 1
    jr c, DecLifeGauge0

    dec a
    ld (ix + 1), a

    jr DecLifeGaugeEnd

DecLifeGauge0:

    ld a, (ix + 0)
    cp 1
    jr c, DecLifeGaugeEnd

    dec a
    ld (ix + 0), a

DecLifeGaugeEnd:

    ret

;-------------------------------------------- 
; ライフゲージを表示する
;--------------------------------------------
DisplayLifeGauge:

    ld ix, WK_PLAYERLIFEGAUGE
    ld iy, WK_PLAYERLIFEGAUGE_CHARS

    ; 最初にライフゲージをスペースで埋める
    ld a, ' '
    ld (iy + 0), ' '
    ld (iy + 1), ' '
    ld (iy + 2), ' '
    ld (iy + 3), ' '
    ld (iy + 4), ' '
    ld (iy + 5), ' '
    ld (iy + 6), ' '
    ld (iy + 7), ' '

DisplayLifeGauge7:

    ld a, (ix + 7)
    cp 1
    jr c, DisplayLifeGauge6

    add a, $80
    ld (iy + 7), a

DisplayLifeGauge6:

    ld a, (ix + 6)
    cp 1
    jr c, DisplayLifeGauge5

    add a, $80
    ld (iy + 6), a

DisplayLifeGauge5:

    ld a, (ix + 5)
    cp 1
    jr c, DisplayLifeGauge4

    add a, $80
    ld (iy + 5), a

DisplayLifeGauge4:

    ld a, (ix + 4)
    cp 1
    jr c, DisplayLifeGauge3

    add a, $80
    ld (iy + 4), a

DisplayLifeGauge3:

    ld a, (ix + 3)
    cp 1
    jr c, DisplayLifeGauge2

    add a, $80
    ld (iy + 3), a

DisplayLifeGauge2:

    ld a, (ix + 2)
    cp 1
    jr c, DisplayLifeGauge1

    add a, $80
    ld (iy + 2), a

DisplayLifeGauge1:

    ld a, (ix + 1)
    cp 1
    jr c, DisplayLifeGauge0

    add a, $80
    ld (iy + 1), a

DisplayLifeGauge0:

    ld a, (ix + 0)
    cp 1
    jr c, DisplayLifeGaugeEnd

    add a, $80
    ld (iy + 0), a

DisplayLifeGaugeEnd:

    ; WK_PLAYERLIFEGAUGE_CHARSの内容を
    ; 画面に出力する
    ld hl, WK_PLAYERLIFEGAUGE_CHARS
    ld de, $1AC1     
    ld bc, 8  ; 8バイト転送する

    call LDIRVM
    
    ret
