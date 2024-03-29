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
    
CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
