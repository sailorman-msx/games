GameOverProc:

    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    jp nz, GameOverProcDecTime

    ; BGMを消す
    call SOUNDDRV_STOP

    ; スプライトを消す
    ld hl, SPRDISTPTN_TBL
    ld b, 0
    ld a, (WK_PLAYERDIST)
    ld c, a
    
    add hl, bc
    ld ix, hl

    call CreateWorkSpriteAttr
    ld hl, WK_PLAYERSPRATTR
    ld ix, hl
    ld a, 0
    ld (ix + 3), 0 ; 透明色にする
    ld (ix + 7), 0 ; 透明色にする
    
    ; スプライトを表示する
    ; カラーを透明色にしているので実質は消える
    ld de, $1B00
    ld bc, 8 ; スプライト2枚分を表示
    call PutSprite

    ; GAME OVER 表示
    ld hl, GAMEOVER_MESSAGE1
    ld bc, 11
    ld de, $18A5
    call LDIRVM
    ld hl, GAMEOVER_MESSAGE2
    ld bc, 11
    ld de, $18C5
    call LDIRVM
    ld hl, GAMEOVER_MESSAGE1
    ld bc, 11
    ld de, $18E5
    call LDIRVM

GameOverProcInit:

    ; キーボードバッファをクリアする
    ; これを呼び出さないとカーソルキーを正常に判定できない
    call KILBUF

    ; スペースキーが押されているか？
GameOverProc_IsSPACE:

    ld a, 0
    call GTTRIG
    cp $FF
    jr nz, GameOverProc_IsAbutton

    ld a, 0
    ld (WK_GAMESTATUS_INTTIME), a

    jp GameOverProcToTitle

    ; ジョイスティック1のAボタンが押されているか？
GameOverProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jp nz, GameOverProcEnd

    ld a, 0
    ld (WK_GAMESTATUS_INTTIME), a

    jp GameOverProcToTitle

GameOverProcToTitle:

    ld a, 0
    ld (WK_GAMESTATUS), a
    ld a, 0
    ld (WK_GAMESTATUS_INTTIME), a

    jp TitleDisplayProc 
    
GameOverProcDecTime:

    ld (WK_GAMESTATUS_INTTIME), a

GameOverProcEnd:

    jp VSYNC_Wait

