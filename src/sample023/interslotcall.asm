;----------------------------------------------------
; インタースロットコール,SUB-ROMコール用
;----------------------------------------------------
BiosCall:

    ; JP (DE)
    push de
    ret

BiosCallNotFDD:

    ; 普通に呼び出す
    ; 呼び出し時はJPで行う
    jp (hl)

BiosNotFDDSubRomCall:

    ; SUB-ROMをコールする
    ld hl, EXTROM
    jp (hl)

BiosInterSlotCall:

    ; インタースロットコールにて
    ; 呼び出す
    ; IXレジスタに呼び出し先をセットしてある必要あり

    ld iy,(EXPTBL-1) ; MAINROMのスロット
    ld de, CALSLT    ; 指定したスロットの指定アドレスを呼びだす

    ; JP (DE)
    push de
    ret

BiosFDDSubRomCall:

    ; SUB-ROMをコールする
    exx
    ex af, af'
    ld hl, EXTROM
    push hl      ; EXTROM -> SP
    ld hl, $C300 ;
    push hl      ; NOP, JP -> SP
    push ix      ; SUB ROM Entry
    ld hl, $21DD
    push hl      ; LD IX -> SP
    ld hl, $3333
    push hl      ; INC SP, INC SP
    ld hl, 0
    add hl, sp
    ld a, $C3
    ld (H_NMI), a    ;
    ld (H_NMI+1),hl  ;
    ex af, af'
    exx

    ld ix, H_NMI
    ld iy, (EXPTBL-1)
    ld hl, CALSLT
    jp (hl)
