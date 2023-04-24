;--------------------------------------------
; data_gr2.asm
; 固定データ(GRAPHIC2モード用)
;--------------------------------------------
; キャラクタパターンとカラーテーブル
CHRPTN:
    defb $80  ; CHAR CODE
    defb $FE, $FE, $FE, $00, $DF, $DF, $DF, $00 ; CHAR PATTERN
    defb $81, $81, $81, $11, $81, $81, $D1, $D1 ; COLOR PATTERN

    defb $81  ; CHAR CODE
    defb $38, $38, $38, $7C, $BA, $38, $6C, $00 ; CHAR PATTERN
    defb $51, $51, $51, $81, $81, $C1, $51, $11 ; COLOR PATTERN

CHRPTN_HEXFONT:

    defb '0'
    defb $7E, $46, $46, $46, $46, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '1'
    defb $38, $18, $18, $18, $18, $18, $18, $18 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '2'
    defb $7E, $06, $06, $7E, $40, $40, $7E, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '3'
    defb $7E, $06, $06, $7E, $06, $06, $06, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '4'
    defb $7E, $60, $60, $66, $66, $7E, $06, $06 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '5'
    defb $7E, $40, $40, $7E, $06, $06, $06, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb '6'
    defb $7E, $40, $40, $7E, $46, $46, $71, $71 ; CHAR PATTERN
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
    defb $7C, $46, $46, $46, $7E, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'C'
    defb $7C, $46, $46, $40, $40, $40, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'D'
    defb $7C, $46, $46, $46, $46, $46, $46, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'E'
    defb $7E, $40, $40, $7E, $40, $40, $7E, $7E ; ChAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

    defb 'F'
    defb $7E, $40, $40, $7E, $40, $40, $40, $40 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $71, $71, $71, $71 ; COLOR PATTERN

CHRPTN_ENEMY_RANDOM: ; 16x16 dot character.

    defb $98  ; LEFT-UP
    defb $00, $1F, $3F, $7F, $7F, $3F, $0F, $07 ; CHAR PATTERN
    defb $11, $F1, $71, $41, $41, $71, $81, $61 ; COLOR PATTERN
    defb $99  ; LEFT-DOWN
    defb $07, $0F, $3F, $7F, $7F, $3F, $1F, $00 ; CHAR PATTERN
    defb $61, $81, $71, $41, $41, $71, $F1, $11 ; COLOR PATTERN
    defb $9A  ; RIGHT-UP
    defb $00, $F8, $FC, $FE, $FE, $FC, $F0, $E0 ; CHAR PATTERN
    defb $11, $F1, $71, $41, $41, $71, $81, $61 ; COLOR PATTERN
    defb $9B  ; RIGHT-DOWN
    defb $E0, $F0, $FC, $FE, $FE, $FC, $F8, $00 ; CHAR PATTERN
    defb $61, $81, $71, $41, $41, $71, $F1, $11 ; COLOR PATTERN

CHRPTN_PLAYER: ; 16x16 dot character.

    defb $A8  ; LEFT-UP
    defb $0F, $1F, $1F, $1F, $15, $15, $15, $0F ; CHAR PATTERN
    defb $D1, $D1, $D1, $F1, $F1, $F1, $F1, $F1 ; COLOR PATTERN
    defb $A9  ; LEFT-DOWN
    defb $10, $7F, $3B, $1F, $1B, $0F, $3E, $1E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $F1, $F1, $81, $81 ; COLOR PATTERN
    defb $AA  ; RIGHT-UP
    defb $F8, $F8, $FC, $FC, $FC, $FC, $FC, $F8 ; CHAR PATTERN
    defb $D1, $D1, $D1, $D1, $D1, $D1, $D1, $D1 ; COLOR PATTERN
    defb $AB  ; RIGHT-DOWN
    defb $E8, $DC, $DC, $DC, $E8, $F0, $3C, $3C ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $F1, $F1, $81, $81 ; COLOR PATTERN

CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
