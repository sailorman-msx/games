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

    ; --- 0123
    defb '0'
    defb $0E,$19,$31,$31,$31,$33,$3F,$1E
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '1'
    defb $06,$0E,$3C,$0C,$08,$18,$38,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '2'
    defb $1C,$36,$22,$06,$0C,$31,$7E,$7C
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '3'
    defb $1C,$36,$22,$0C,$02,$46,$7C,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; --- 4567
    defb '4'
    defb $0C,$0C,$1A,$12,$64,$7F,$1E,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '5'
    defb $26,$1F,$10,$3E,$33,$03,$7E,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '6'
    defb $0E,$18,$30,$3C,$66,$46,$7C,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '7'
    defb $42,$7F,$33,$04,$0C,$18,$38,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- 89
    defb '8'
    defb $1C,$3F,$26,$18,$24,$66,$7E,$3C
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb '9'
    defb $3C,$67,$67,$3E,$0C,$18,$38,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- ABC
    defb 'A'
    defb $02,$06,$06,$4A,$73,$3B,$67,$66
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'B'
    defb $3E,$13,$16,$5C,$76,$33,$67,$7E
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'C'
    defb $0C,$1A,$32,$20,$61,$62,$76,$3C
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- DEFG
    defb 'D'
    defb $3C,$12,$11,$51,$71,$23,$7E,$78
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'E'
    defb $23,$3E,$10,$5C,$70,$21,$67,$7C
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'F'
    defb $43,$7E,$10,$52,$7C,$24,$60,$70
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'G'
    defb $0C,$1A,$32,$20,$67,$62,$76,$3C
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- HIJK
    defb 'H'
    defb $31,$11,$12,$52,$7E,$22,$6E,$67
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'I'
    defb $06,$02,$04,$04,$2C,$1C,$18,$18
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'J'
    defb $07,$02,$02,$46,$24,$64,$6C,$38
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'K'
    defb $41,$31,$13,$26,$38,$6E,$67,$63
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- LMNO
    defb 'L'
    defb $18,$08,$10,$10,$30,$60,$7F,$76
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'M'
    defb $61,$33,$15,$29,$2A,$62,$67,$63
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'N'
    defb $61,$31,$13,$2A,$26,$62,$67,$63
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'O'
    defb $3E,$13,$21,$21,$61,$62,$3E,$18
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- PQRS
    defb 'P'
    defb $6E,$33,$11,$51,$72,$3C,$60,$60
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'Q'
    defb $0E,$13,$21,$21,$65,$62,$7F,$39
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'R'
    defb $6E,$33,$11,$53,$7E,$28,$66,$63
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'S'
    defb $0E,$13,$11,$4C,$26,$63,$73,$3E
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- TUVW
    defb 'T'
    defb $67,$3E,$10,$10,$30,$60,$60,$60
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'U'
    defb $63,$31,$11,$21,$21,$62,$7E,$3C
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'V'
    defb $61,$31,$13,$22,$24,$68,$70,$60
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'W'
    defb $63,$21,$29,$69,$6B,$7A,$7E,$34
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    ; 
    ; --- XYZ
    defb 'X'
    defb $31,$11,$0A,$0C,$3C,$76,$67,$63
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'Y'
    defb $31,$11,$1A,$0C,$0C,$18,$18,$18
    defb $F1,$F1,$F1,$F1,$F1,$71,$71,$51
    defb 'Z'
    defb $33,$1E,$04,$08,$10,$71,$7F,$66
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

CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
