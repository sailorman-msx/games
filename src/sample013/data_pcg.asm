;--------------------------------------------
; data_pcg.asm
; 固定データ(GRAPHIC2モード用)
;--------------------------------------------
; キャラクタパターンとカラーテーブル
CHRPTN:
    defb '$'  ; CHAR CODE
    defb $FE, $80, $80, $80, $80, $80, $80, $00 ; CHAR PATTERN
    defb $41, $41, $41, $41, $41, $41, $41, $11 ; COLOR PATTERN

    defb '#' ; CHAR CODE
    defb $81, $7E, $7E, $7E, $7E, $7E, $7E, $81 ; CHAR PATTERN
    defb $45, $45, $45, $45, $45, $45, $45, $45 ; COLOR PATTERN

    defb '%'  ; CHAR CODE
    defb $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; CHAR PATTERN
    defb $77, $77, $77, $77, $77, $77, $77, $77 ; COLOR PATTERN

    defb '&'  ; CHAR CODE
    defb $81, $7E, $7E, $7E, $7E, $7E, $7E, $81 ; CHAR PATTERN
    defb $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE ; COLOR PATTERN

    defb $71  ; CHAR CODE
    defb $0F, $1E, $3E, $3E, $3E, $3E, $7E, $7E ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $72  ; CHAR CODE
    defb $7E, $7E, $7E, $40, $7E, $7E, $7E, $7E ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $73  ; CHAR CODE
    defb $70, $F0, $F8, $F8, $F8, $F8, $FC, $FC ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $74  ; CHAR CODE
    defb $FC, $FC, $FC, $04, $FC, $FC, $FC, $FC ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $75  ; CHAR CODE
    defb $FE, $80, $80, $80, $80, $80, $80, $00 ; CHAR PATTERN
    defb $61, $61, $61, $61, $61, $61, $61, $61 ; COLOR PATTERN

    defb $80  ; CHAR CODE
    defb $D8, $F8, $F8, $F8, $70, $77, $20, $27 ; CHAR PATTERN
    defb $81, $81, $81, $81, $61, $61, $61, $61 ; COLOR PATTERN

    defb $81  ; CHAR CODE : LIFE GAUGE HALF
    defb $00, $E0, $E0, $E0, $E0, $E0, $E0, $E0 ; CHAR PATTERN
    defb $31, $31, $31, $31, $31, $31, $31, $B1 ; COLOR PATTERN

    defb $82  ; CHAR CODE : LIFE GAUGE FULL
    defb $00, $EE, $EE, $EE, $EE, $EE, $EE, $EE ; CHAR PATTERN
    defb $31, $31, $31, $31, $31, $31, $31, $B1 ; COLOR PATTERN

CHRPTN_HEXFONT:

    defb '0'
    defb $7E, $46, $56, $56, $56, $56, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '1'
    defb $38, $18, $18, $18, $18, $18, $18, $18 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '2'
    defb $7E, $06, $06, $7E, $40, $40, $40, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '3'
    defb $7E, $06, $06, $7E, $06, $06, $06, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '4'
    defb $76, $76, $76, $76, $76, $7E, $06, $06 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '5'
    defb $7E, $40, $40, $7E, $06, $06, $06, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '6'
    defb $7E, $40, $40, $7E, $46, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '7'
    defb $7E, $06, $06, $06, $06, $06, $06, $06 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '8'
    defb $7E, $46, $46, $7E, $46, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '9'
    defb $7E, $46, $46, $46, $7E, $06, $06, $06 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'A'
    defb $7C, $46, $46, $46, $7E, $46, $46, $46 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'B'
    defb $78, $44, $44, $78, $46, $46, $46, $7C ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'C'
    defb $7E, $40, $40, $40, $40, $40, $40, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'D'
    defb $70, $48, $4C, $46, $46, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'E'
    defb $7E, $40, $40, $7E, $40, $40, $40, $7E ; ChAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'F'
    defb $7E, $40, $40, $7E, $40, $40, $40, $40 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'G'
    defb $3E, $40, $40, $40, $4E, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'M'
    defb $2C, $56, $56, $56, $46, $46, $46, $46 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'O'
    defb $3C, $46, $46, $46, $46, $46, $46, $3C ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'R'
    defb $7E, $46, $46, $7E, $48, $44, $46, $46 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'S'
    defb $7E, $40, $40, $7E, $06, $06, $06, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'V'
    defb $46, $46, $46, $46, $46, $26, $24, $18 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

CHRPTN_ENEMY_TYPE1: ; 16x16 dot character.

    ; 方向=上
    defb $98  ; LEFT-UP
    defb $0F, $1F, $1F, $3F, $3F, $3F, $3F, $3F ; CHAR PATTERN
    defb $31, $31, $31, $31, $31, $31, $31, $31 ; COLOR PATTERN
    defb $99  ; LEFT-DOWN
    defb $3F, $3F, $DF, $DF, $DF, $3F, $1F, $3E ; CHAR PATTERN
    defb $31, $C1, $C1, $C1, $C1, $31, $C1, $31 ; COLOR PATTERN
    defb $9A  ; RIGHT-UP
    defb $F0, $F8, $F8, $FC, $FC, $FC, $FC, $FC ; CHAR PATTERN
    defb $31, $31, $31, $31, $31, $31, $31, $31 ; COLOR PATTERN
    defb $9B  ; RIGHT-DOWN
    defb $FC, $FC, $FB, $FB, $FB, $FC, $F8, $7C ; CHAR PATTERN
    defb $31, $C1, $C1, $C1, $C1, $31, $C1, $31 ; COLOR PATTERN

    ; 方向=右
    defb $9C  ; LEFT-UP
    defb $07, $3F, $3F, $7E, $7E, $7F, $1F, $27 ; CHAR PATTERN
    defb $31, $31, $C1, $C1, $C1, $C1, $C1, $C1 ; COLOR PATTERN
    defb $9D  ; LEFT-DOWN
    defb $3B, $7D, $7E, $4E, $71, $7F, $7F, $7F ; CHAR PATTERN
    defb $C1, $C1, $C1, $C1, $C1, $C1, $31, $C1 ; COLOR PATTERN
    defb $9E  ; RIGHT-UP
    defb $F8, $FC, $FC, $F4, $24, $FC, $8C, $74 ; CHAR PATTERN
    defb $31, $31, $C1, $C1, $C1, $C1, $C1, $C1 ; COLOR PATTERN
    defb $9F  ; RIGHT-DOWN
    defb $F8, $0E, $F7, $FB, $FE, $FE, $FE, $FE ; CHAR PATTERN
    defb $C1, $C1, $C1, $C1, $C1, $C1, $C1, $31 ; COLOR PATTERN

    ; 方向=下
    defb $A0  ; LEFT-UP
    defb $0F, $1F, $1F, $3F, $3F, $37, $31, $3F ; CHAR PATTERN
    defb $31, $C1, $C1, $C1, $C1, $C1, $C1, $C1 ; COLOR PATTERN
    defb $A1  ; LEFT-DOWN
    defb $38, $37, $DF, $DF, $DF, $3F, $1F, $3F ; CHAR PATTERN
    defb $C1, $C1, $C1, $C1, $C1, $31, $C1, $31 ; COLOR PATTERN
    defb $A2  ; RIGHT-UP
    defb $F0, $F8, $F8, $FC, $FC, $EC, $8C, $FC ; CHAR PATTERN
    defb $31, $C1, $C1, $C1, $C1, $C1, $C1, $C1 ; COLOR PATTERN
    defb $A3  ; RIGHT-DOWN
    defb $1C, $EC, $FB, $FB, $FB, $FC, $F8, $FC ; CHAR PATTERN
    defb $C1, $C1, $C1, $C1, $C1, $31, $C1, $31 ; COLOR PATTERN

    ; 方向=左
    defb $A4  ; LEFT-UP
    defb $1F, $3F, $3F, $2F, $24, $3F, $31, $2E ; CHAR PATTERN
    defb $31, $31, $C1, $C1, $C1, $C1, $C1, $C1 ; COLOR PATTERN
    defb $A5  ; LEFT-DOWN
    defb $1F, $70, $EF, $DF, $7F, $3F, $3F, $3F ; CHAR PATTERN
    defb $C1, $C1, $C1, $C1, $C1, $C1, $C1, $31 ; COLOR PATTERN
    defb $A6  ; RIGHT-UP
    defb $E0, $FC, $FE, $7F, $7F, $FC, $F8, $E4 ; CHAR PATTERN
    defb $31, $31, $C1, $C1, $C1, $C1, $C1, $C1 ; COLOR PATTERN
    defb $A7  ; RIGHT-DOWN
    defb $DC, $BE, $7E, $72, $8E, $FE, $FE, $FE ; CHAR PATTERN
    defb $C1, $C1, $C1, $C1, $C1, $C1, $31, $C1
    
CHRPTN_ENEMY_TYPE2: ; 16x16 dot character.

    ; 方向=上
    defb $A8  ; LEFT-UP
    defb $0F, $1F, $1F, $3F, $3F, $3F, $3F, $3F ; CHAR PATTERN
    defb $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B1 ; COLOR PATTERN
    defb $A9  ; LEFT-DOWN
    defb $3F, $3F, $DF, $DF, $DF, $3F, $1F, $3E ; CHAR PATTERN
    defb $B1, $81, $81, $81, $81, $B1, $81, $B1 ; COLOR PATTERN
    defb $AA  ; RIGHT-UP
    defb $F0, $F8, $F8, $FC, $FC, $FC, $FC, $FC ; CHAR PATTERN
    defb $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B1 ; COLOR PATTERN
    defb $AB  ; RIGHT-DOWN
    defb $FC, $FC, $FB, $FB, $FB, $FC, $F8, $7C ; CHAR PATTERN
    defb $B1, $81, $81, $81, $81, $B1, $81, $B1 ; COLOR PATTERN

    ; 方向=右
    defb $AC  ; LEFT-UP
    defb $07, $3F, $3F, $7E, $7E, $7F, $1F, $27 ; CHAR PATTERN
    defb $B1, $B1, $81, $81, $81, $81, $81, $81 ; COLOR PATTERN
    defb $AD  ; LEFT-DOWN
    defb $3B, $7D, $7E, $4E, $71, $7F, $7F, $7F ; CHAR PATTERN
    defb $81, $81, $81, $81, $81, $81, $B1, $81 ; COLOR PATTERN
    defb $AE  ; RIGHT-UP
    defb $F8, $FC, $FC, $F4, $24, $FC, $8C, $74 ; CHAR PATTERN
    defb $B1, $B1, $81, $81, $81, $81, $81, $81 ; COLOR PATTERN
    defb $AF  ; RIGHT-DOWN
    defb $F8, $0E, $F7, $FB, $FE, $FE, $FE, $FE ; CHAR PATTERN
    defb $81, $81, $81, $81, $81, $81, $81, $B1 ; COLOR PATTERN

    ; 方向=下
    defb $B0  ; LEFT-UP
    defb $0F, $1F, $1F, $3F, $3F, $37, $31, $3F ; CHAR PATTERN
    defb $B1, $81, $81, $81, $81, $81, $81, $81 ; COLOR PATTERN
    defb $B1  ; LEFT-DOWN
    defb $38, $37, $DF, $DF, $DF, $3F, $1F, $3F ; CHAR PATTERN
    defb $81, $81, $81, $81, $81, $B1, $81, $B1 ; COLOR PATTERN
    defb $B2  ; RIGHT-UP
    defb $F0, $F8, $F8, $FC, $FC, $EC, $8C, $FC ; CHAR PATTERN
    defb $B1, $81, $81, $81, $81, $81, $81, $81 ; COLOR PATTERN
    defb $B3  ; RIGHT-DOWN
    defb $1C, $EC, $FB, $FB, $FB, $FC, $F8, $FC ; CHAR PATTERN
    defb $81, $81, $81, $81, $81, $B1, $81, $B1 ; COLOR PATTERN

    ; 方向=左
    defb $B4  ; LEFT-UP
    defb $1F, $3F, $3F, $2F, $24, $3F, $31, $2E ; CHAR PATTERN
    defb $B1, $B1, $81, $81, $81, $81, $81, $81 ; COLOR PATTERN
    defb $B5  ; LEFT-DOWN
    defb $1F, $70, $EF, $DF, $7F, $3F, $3F, $3F ; CHAR PATTERN
    defb $81, $81, $81, $81, $81, $81, $81, $B1 ; COLOR PATTERN
    defb $B6  ; RIGHT-UP
    defb $E0, $FC, $FE, $7F, $7F, $FC, $F8, $E4 ; CHAR PATTERN
    defb $B1, $B1, $81, $81, $81, $81, $81, $81 ; COLOR PATTERN
    defb $B7  ; RIGHT-DOWN
    defb $DC, $BE, $7E, $72, $8E, $FE, $FE, $FE ; CHAR PATTERN
    defb $81, $81, $81, $81, $81, $81, $B1, $81 ; COLOR PATTERN

CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
