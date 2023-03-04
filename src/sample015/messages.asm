;--------------------------------------------
; message.asm
; メッセージを表示する
;--------------------------------------------
DisplayMessage:
    
    cp 10
    jp z, DisplayMessageNoKey

    ; ランダムにセリフを決める
    call RandomValue
   
    ld hl, MESSAGE_01
    ld (WK_MESSAGE_ADDR), hl

    ld a, (WK_RANDOM_VALUE)
    and 00000111B

    cp 1
    jp c, DisplayMessageDispToVRAM

    ld hl, MESSAGE_02
    ld (WK_MESSAGE_ADDR), hl

    cp 1
    jp z, DisplayMessageDispToVRAM

    ld hl, MESSAGE_03
    ld (WK_MESSAGE_ADDR), hl

    cp 2
    jp z, DisplayMessageDispToVRAM

    ld hl, MESSAGE_04
    ld (WK_MESSAGE_ADDR), hl

    cp 3
    jp z, DisplayMessageDispToVRAM

    ld hl, MESSAGE_05
    ld (WK_MESSAGE_ADDR), hl

    cp 4
    jp z, DisplayMessageDispToVRAM

    ld hl, MESSAGE_06
    ld (WK_MESSAGE_ADDR), hl

    cp 5
    jp z, DisplayMessageDispToVRAM

    ld hl, MESSAGE_07
    ld (WK_MESSAGE_ADDR), hl

    jp DisplayMessageDispToVRAM

DisplayMessageNoKey:

    ld a, (WK_EPISODE_COUNT)
    cp 3
    jp z, DisplayMessageNoKeyStep1

    ; エピソードを進める
    ld a, 3
    ld (WK_EPISODE_COUNT), a
    call DisplayEpisodeTitle

    ; 効果音を鳴らす
    ld hl, SFX_05
    call SOUNDDRV_SFXPLAY
    
DisplayMessageNoKeyStep1:

    ld hl, MESSAGE_90
    ld (WK_MESSAGE_ADDR), hl

DisplayMessageDispToVRAM:

    ld hl, (WK_MESSAGE_ADDR)
    ld bc, 9
    ld de, $1A16
    call LDIRVM  ; 1行目

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $1A36
    call LDIRVM  ; 2行目

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld hl, (WK_MESSAGE_ADDR)
    ld bc, 9
    ld de, $1A56 ; 3行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld hl, (WK_MESSAGE_ADDR)
    ld bc, 9
    ld de, $1A76 ; 4行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $1A96 ; 5行目
    call LDIRVM

    ret

;--------------------------------------------
; SUBROUTINE: DisplayEpisodeTitle
; エピソードを表示する
;--------------------------------------------
DisplayEpisodeTitle:

    ld hl, EPISODE_TITLE1
    ld (WK_MESSAGE_ADDR), hl

    ld a, (WK_EPISODE_COUNT)

    cp 1
    jp z, DisplayEpisodeTitleDispToVRAM

    ld hl, EPISODE_TITLE2
    ld (WK_MESSAGE_ADDR), hl

    cp 2
    jp z, DisplayEpisodeTitleDispToVRAM

    ld hl, EPISODE_TITLE3
    ld (WK_MESSAGE_ADDR), hl

    cp 3
    jp z, DisplayEpisodeTitleDispToVRAM

    ld hl, EPISODE_TITLE4
    ld (WK_MESSAGE_ADDR), hl

DisplayEpisodeTitleDispToVRAM:

    ld hl, (WK_MESSAGE_ADDR)
    ld bc, 9
    ld de, $1836
    call LDIRVM  ; 1行目

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $1856
    call LDIRVM  ; 2行目

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld hl, (WK_MESSAGE_ADDR)
    ld bc, 9
    ld de, $1876 ; 3行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld hl, (WK_MESSAGE_ADDR)
    ld bc, 9
    ld de, $1896 ; 4行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $18B6 ; 5行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $18D6 ; 6行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $18F6 ; 7行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $1916 ; 8行目
    call LDIRVM

    ld hl, (WK_MESSAGE_ADDR)
    ld de, 9
    add hl, de
    ld (WK_MESSAGE_ADDR), hl

    ld bc, 9
    ld de, $1936 ; 9行目
    call LDIRVM

DisplayEpisodeTitleEnd:

    ret
