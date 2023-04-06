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

    ; ドア
    defb $71  ; CHAR CODE
    defb $0F, $1E, $3E, $3E, $3E, $3E, $7E, $7E ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $72  ; CHAR CODE
    defb $7E, $7E, $7E, $40, $7E, $7E, $7E, $7E ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $73  ; CHAR CODE
    defb $E0, $F0, $F8, $F8, $F8, $F8, $FC, $FC ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    defb $74  ; CHAR CODE
    defb $FC, $FC, $FC, $04, $FC, $FC, $FC, $FC ; CHAR PATTERN
    defb $21, $21, $21, $21, $21, $21, $21, $21 ; COLOR PATTERN

    ; ドア
    defb $75  ; CHAR CODE
    defb $0F, $1E, $3E, $3E, $3E, $3E, $7E, $7E ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $71 ; COLOR PATTERN

    defb $76  ; CHAR CODE
    defb $7E, $7E, $7E, $40, $7E, $7E, $7E, $7E ; CHAR PATTERN
    defb $71, $71, $71, $71, $51, $51, $51, $51 ; COLOR PATTERN

    defb $77  ; CHAR CODE
    defb $E0, $F0, $F8, $F8, $F8, $F8, $FC, $FC ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $71 ; COLOR PATTERN

    defb $78  ; CHAR CODE
    defb $FC, $FC, $FC, $04, $FC, $FC, $FC, $FC ; CHAR PATTERN
    defb $71, $71, $71, $71, $51, $51, $51, $51 ; COLOR PATTERN

    ; ライフアイコン
    defb $80  ; CHAR CODE
    defb $D8, $F8, $F8, $F8, $70, $77, $20, $27 ; CHAR PATTERN
    defb $81, $81, $81, $81, $61, $61, $61, $61 ; COLOR PATTERN

    ; ライフゲージ表示用
    defb $81  ; CHAR CODE : LIFE GAUGE HALF
    defb $00, $E0, $E0, $E0, $E0, $E0, $E0, $E0 ; CHAR PATTERN
    defb $31, $31, $31, $31, $31, $31, $31, $B1 ; COLOR PATTERN

    defb $82  ; CHAR CODE : LIFE GAUGE FULL
    defb $00, $EE, $EE, $EE, $EE, $EE, $EE, $EE ; CHAR PATTERN
    defb $31, $31, $31, $31, $31, $31, $31, $B1 ; COLOR PATTERN

    ; ステータスアイコン（発射OKサイン）
    defb $83
    defb $65, $96, $95, $64, $03, $04, $09, $0A ; CHAR PATTERN
    defb $81, $81, $81, $81, $A1, $A1, $A1, $A1 ;

    defb $84
    defb $0A, $09, $04, $03, $00, $00, $00, $00 ; CHAR PATTERN
    defb $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1

    defb $85
    defb $20, $20, $00, $A0, $C0, $20, $90, $50 ; CHAR PATTERN
    defb $81, $81, $81, $81, $A1, $A1, $A1, $A1 ;

    defb $86
    defb $50, $90, $20, $C0, $00, $00, $00, $00 ; CHAR PATTERN
    defb $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1

    ; カギ
    defb $87
    defb $0F, $1F, $38, $30, $30, $38, $1F, $0F ; CHAR PATTERN
    defb $A1, $A1, $B1, $B1, $B1, $B1, $A1, $B1 ; COLOR PATTERN

    defb $88
    defb $01, $01, $01, $01, $01, $01, $01, $01 ; CHAR PATTERN
    defb $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B1 ; COLOR PATTERN

    defb $89
    defb $F0, $F8, $1C, $0C, $0C, $1C, $F8, $F0 ; CHAR PATTERN
    defb $A1, $A1, $B1, $B1, $B1, $B1, $A1, $B1 ; COLOR PATTERN

    defb $8A
    defb $80, $80, $80, $F0, $F0, $80, $F0, $F0 ; CHAR PATTERN
    defb $B1, $B1, $B1, $B1, $B1, $B1, $B1, $B1 ; COLOR PATTERN

    ; 最後のカギ
    defb $8B
    defb $0F, $1F, $38, $30, $30, $38, $1F, $0F ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $71 ; COLOR PATTERN

    defb $8C
    defb $01, $01, $01, $01, $01, $01, $01, $01 ; CHAR PATTERN
    defb $71, $71, $71, $71, $51, $51, $51, $51 ; COLOR PATTERN

    defb $8D
    defb $F0, $F8, $1C, $0C, $0C, $1C, $F8, $F0 ; CHAR PATTERN
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $71 ; COLOR PATTERN

    defb $8E
    defb $80, $80, $80, $F0, $F0, $80, $F0, $F0 ; CHAR PATTERN
    defb $71, $71, $71, $71, $51, $51, $51, $51 ; COLOR PATTERN

CHRPTN_HEXFONT:

    defb ' '
    defb $00,$00,$00,$00,$00,$00,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '!'
    defb $38,$38,$38,$38,$00,$00,$38,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '"'
    defb $6c,$6c,$6c,$00,$00,$00,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb "'"
    defb $38,$30,$60,$00,$00,$00,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '('
    defb $10,$20,$40,$40,$40,$20,$10,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb ')'
    defb $40,$20,$10,$10,$10,$20,$40,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '*'
    defb $20,$a8,$70,$20,$70,$a8,$20,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '+'
    defb $00,$20,$20,$f8,$20,$20,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb ','
    defb $00,$00,$00,$00,$00,$20,$20,$40
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '-'
    defb $00,$00,$00,$78,$00,$00,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '.'
    defb $00,$00,$00,$00,$00,$60,$60,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '/'
    defb $00,$00,$08,$10,$20,$40,$80,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '0'
    defb $7c,$c6,$d6,$d6,$d6,$c6,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '1'
    defb $38,$78,$f8,$38,$38,$38,$fc,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '2'
    defb $7c,$ee,$0e,$1c,$78,$e0,$fe,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '3'
    defb $7c,$ee,$0e,$3c,$0e,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '4'
    defb $1c,$3c,$6c,$cc,$fe,$1c,$1c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '5'
    defb $fe,$e0,$f8,$1c,$0e,$1c,$f8,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '6'
    defb $3c,$70,$e0,$fc,$ee,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '7'
    defb $fc,$cc,$18,$30,$30,$30,$30,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '8'
    defb $7c,$ee,$ee,$7c,$ee,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '9'
    defb $7c,$ee,$ee,$7e,$0e,$1c,$78,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb ':'
    defb $00,$00,$38,$00,$00,$38,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb ';'
    defb $00,$00,$38,$00,$00,$38,$38,$70
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '<'
    defb $18,$30,$60,$c0,$60,$30,$18,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '='
    defb $00,$00,$fe,$00,$fe,$00,$00,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '>'
    defb $c0,$60,$30,$18,$30,$60,$c0,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '?'
    defb $7c,$ee,$0e,$1c,$38,$00,$38,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '@'
    defb $70,$88,$08,$48,$a8,$a8,$70,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'A'
    defb $38,$7c,$ee,$ee,$fe,$ee,$ee,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'B'
    defb $fc,$7e,$6e,$7c,$6e,$7e,$fc,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'C'
    defb $3c,$7e,$e0,$e0,$e0,$7e,$3c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'D'
    defb $f8,$7c,$6e,$6e,$6e,$7c,$f8,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'E'
    defb $fe,$e0,$e0,$fc,$e0,$e0,$fe,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'F'
    defb $fe,$e0,$e0,$fc,$e0,$e0,$e0,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'G'
    defb $7c,$ee,$c0,$de,$ce,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'H'
    defb $ee,$ee,$ee,$fe,$ee,$ee,$ee,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'I'
    defb $7c,$38,$38,$38,$38,$38,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'J'
    defb $3e,$1c,$1c,$1c,$fc,$fc,$78,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'K'
    defb $ee,$fc,$f8,$f0,$f8,$fc,$ee,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'L'
    defb $e0,$e0,$e0,$e0,$e0,$e0,$fe,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'M'
    defb $c6,$ee,$fe,$fe,$ee,$ee,$ee,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'N'
    defb $ce,$ee,$fe,$fe,$fe,$ee,$e6,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'O'
    defb $7c,$ee,$ee,$ee,$ee,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'P'
    defb $fc,$ee,$ee,$fc,$e0,$e0,$e0,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'Q'
    defb $7c,$ee,$ee,$ee,$fe,$fc,$7e,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'R'
    defb $fc,$ee,$ee,$fc,$f8,$fc,$ee,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'S'
    defb $7c,$ee,$e0,$7c,$0e,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'T'
    defb $fe,$38,$38,$38,$38,$38,$38,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'U'
    defb $ee,$ee,$ee,$ee,$ee,$ee,$7c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'V'
    defb $c6,$ee,$ee,$ee,$7c,$7c,$38,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'W'
    defb $c6,$ee,$ee,$fe,$fe,$6c,$6c,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'X'
    defb $ee,$ee,$7c,$38,$7c,$ee,$ee,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'Y'
    defb $ee,$ee,$ee,$7c,$38,$38,$38,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'Z'
    defb $fe,$0e,$1c,$38,$70,$e0,$fe,$00
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    
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

CHRPTN_BALLS:

    ; ボール未回収マーク
    defb $B8
    defb $38, $44, $82, $82, $82, $82, $44, $38
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
  
    ; ボール回収済マーク
    defb $B9
    defb $39, $74, $FA, $FE, $FE, $FE, $7C, $38
    defb $51, $51, $51, $51, $51, $51, $51, $41

    ; BALL
    defb $BA
    defb $0F, $19, $37, $6F, $6F, $DF, $DF, $FF
    defb $11, $11, $11, $11, $11, $11, $11, $11
    defb $BB
    defb $FF, $FF, $FF, $7F, $7F, $3F, $1F, $0F
    defb $11, $11, $11, $11, $11, $11, $11, $11
    defb $BC
    defb $F0, $F8, $FC, $FE, $FE, $FF, $FF, $FF
    defb $11, $11, $11, $11, $11, $11, $11, $11
    defb $BD
    defb $FF, $FF, $FF, $FE, $FE, $FC, $F8, $F0
    defb $11, $11, $11, $11, $11, $11, $11, $11

CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
