;--------------------------------------------
; data_sprite.asm
; 固定データ(スプライト作成用)
;--------------------------------------------

SPRPTN:

    ; BALL
    defb $0F, $19, $37, $6F, $6F, $DF, $DF, $FF ; PATTERN#000
    defb $FF, $FF, $FF, $7F, $7F, $3F, $1F, $0F
    defb $F0, $F8, $FC, $FE, $FE, $FF, $FF, $FF
    defb $FF, $FF, $FF, $FE, $FE, $FC, $F8, $F0
    ;
    defb $0F, $1F, $3F, $7F, $7F, $FF, $FF, $FF ; PATTERN#004
    defb $FF, $FF, $FF, $7F, $7F, $3F, $1F, $0F
    defb $F0, $98, $EC, $F6, $F6, $FB, $FB, $FF
    defb $FF, $FF, $FF, $FE, $FE, $FC, $F8, $F0
    ;
    defb $0F, $1F, $3F, $7F, $7F, $FF, $FF, $FF ; PATTERN#008
    defb $FF, $FF, $FF, $7F, $7F, $3F, $1F, $0F
    defb $F0, $F8, $FC, $FE, $FE, $FF, $FF, $FF
    defb $FF, $FB, $FB, $F6, $F6, $EC, $98, $F0
    ;
    defb $0F, $1F, $3F, $7F, $7F, $FF, $FF, $FF ; PATTERN#012
    defb $FF, $DF, $DF, $6F, $6F, $37, $19, $0F
    defb $F0, $F8, $FC, $FE, $FE, $FF, $FF, $FF
    defb $FF, $FF, $FF, $FE, $FE, $FC, $F8, $F0
