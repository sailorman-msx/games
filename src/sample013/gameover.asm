GameOverProc:

    call SOUNDDRV_STOP

;--------------------------------------------
; マップデータ（初期画面）のデータを
; VRAM(1800H-1AFFH)に書き込む
;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_GAMEOVER
    ld bc, 768
    call LDIRVM

Mugen:
    jr Mugen

