DisplayMessage:
    
    ; ランダムにセリフを決める
    call RandomValue
   
    ld hl, MESSAGE_01
    ld (WK_MESSAGE_ADDR), hl

    ld a, (WK_RANDOM_VALUE)
    and 00000111B

    or 0
    jp z, DisplayMessageDispToVRAM

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
