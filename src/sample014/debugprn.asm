DebugPrint:

    push af
    push bc
    push de
    push hl

    ;
    ; DUMP出力するためのデータを準備する
    ;
    ld hl, WK_FIREBALL_MAPX1
    ld de, WK_DUMPDATA            ; WK_DUMPDATAのアドレスに
    ld bc, 16                     ; 16バイト転送する
    ldir

    call PrintHexaDump

    ;
    ; WK_DUMPCHARのアドレスの内容を
    ; 画面上の下段(1AE0H)に32バイト転送する
    ;
    ld de, $1AE0
    call HexaDumpToVRAM

    pop hl
    pop de
    pop bc
    pop af

    ret

