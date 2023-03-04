GameClearProc:

    ; 効果音を鳴らす
    ld hl, SFX_05
    call SOUNDDRV_SFXPLAY

    ; スプライトを表示する
    ld a, 1
    ld (WK_PLAYERPOSX), a
    ld a, 0
    ld (WK_PLAYERPOSY), a
    
    ld ix, SPRDISTPTN_TBL + 5
    call CreateWorkSpriteAttr

    ld de, $1B00
    ld bc, 8
    call PutSprite

;--------------------------------------------
; マップデータ（初期画面）のデータを
; VRAM(1800H-1AFFH)に書き込む
;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_CLEAR
    ld bc, 768
    call LDIRVM

    ; スコア表示する
    ld b, 1
    ld c, 0
    call AddScore

GameClearLoop:
    jr GameClearLoop

