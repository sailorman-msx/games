;--------------------------------------------
; data_pcg.asm
; 固定データ(GRAPHIC2モード用)
;--------------------------------------------
; キャラクタパターンとカラーテーブル

;
; キャラクラパターン作成規則：
;
CHRPTN:

; ダイアログの枠

    ; 左上端
    defb $A0
    defb $00, $1F, $3F, $70, $60, $60, $60, $60 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 上横
    defb $A1
    defb $00, $FF, $FF, $00, $00, $00, $00, $00 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 右上端
    defb $A2
    defb $00, $F8, $FC, $0E, $06, $06, $06, $06 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 右縦
    defb $A3
    defb $06, $06, $06, $06, $06, $06, $06, $06 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 右下端
    defb $A4
    defb $06, $06, $06, $06, $0E, $FC, $F8, $00 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 下横
    defb $A5
    defb $00, $00, $00, $00, $00, $FF, $FF, $00 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 左下端
    defb $A6
    defb $60, $60, $60, $60, $70, $3F, $1F, $00 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

    ; 左縦
    defb $A7
    defb $60, $60, $60, $60, $60, $60, $60, $60 ; P
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1 ; C

; ダイアログのAボタンマーク

    defb $A8
    defb $3C, $66, $DB, $C3, $DB, $DB, $5A, $3C ; P
    defb $61, $61, $61, $61, $61, $81, $61, $81 ; C
    
; ダイアログのBボタンマーク

    defb $A9
    defb $3C, $46, $Db, $C7, $DB, $DB, $46, $3C ; P
    defb $C1, $C1, $C1, $C1, $C1, $21, $C1, $21 ; C

; とりあえずの床

    defb "#"
    defb $FF, $6D, $5B, $36, $6D, $5B, $36, $6D ; P
    defb $55, $41, $41, $41, $41, $41, $41, $71 ; C

;--------------------------------------------
; タイル構成キャラクター
;--------------------------------------------

    defb $60
    defb $FB, $FE, $FC, $FB, $FE, $FC, $FB, $FE ; P
    defb $51, $51, $51, $51, $51, $51, $51, $51 ; C

    defb $61
    defb $FC, $FB, $56, $00, $55, $AA, $00, $44 ; P
    defb $E1, $E1, $E1, $E1, $E1, $E1, $E1, $E1 ; C

    defb $62
    defb $AA, $00, $EE, $00, $AA, $00, $EE, $00 ; P
    defb $E1, $E1, $41, $E1, $E1, $41, $E1, $41 ; C

    defb $63
    defb $FE, $FE, $FE, $00, $AA, $00, $EE, $00 ; P
    defb $51, $41, $51, $E1, $E1, $E1, $E1, $E1 ; C

    defb $64
    defb $C0, $FF, $FF, $C0, $C0, $FF, $FF, $C0 ; P
    defb $91, $81, $91, $91, $91, $81, $91, $81 ; C

    defb $65
    defb $03, $FF, $FF, $03, $03, $FF, $FF, $03 ; P
    defb $81, $61, $81, $61, $81, $61, $81, $61 ; C

    defb $66
    defb $00, $56, $06, $60, $08, $66, $64, $00 ; P
    defb $51, $51, $51, $51, $51, $51, $51, $51 ; C

    defb $00 ; EoD

CHRPTN_NUMALPHA_COLOR:

    defb $F1,$F1,$F1,$F1,$E1,$F1,$E1,$E1

CHRPTN_HIRAGANA_COLOR:

    defb $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1

CHRPTN_NUMALPHA:

    ; シングルクオート記号（つぶすなよ）
    defb $2F
    defb $18,$18,$18,$10,$00,$00,$00,$00

    defb ' '
    defb $00,$00,$00,$00,$00,$00,$00,$00
    defb '0'
    defb $7c,$c6,$d6,$d6,$d6,$c6,$7c,$00
    defb '1'
    defb $38,$78,$f8,$38,$38,$38,$fc,$00
    defb '2'
    defb $7c,$ee,$0e,$1c,$78,$e0,$fe,$00
    defb '3'
    defb $7c,$ee,$0e,$3c,$0e,$ee,$7c,$00
    defb '4'
    defb $1c,$3c,$6c,$cc,$fe,$1c,$1c,$00
    defb '5'
    defb $fe,$e0,$f8,$1c,$0e,$1c,$f8,$00
    defb '6'
    defb $3c,$70,$e0,$fc,$ee,$ee,$7c,$00
    defb '7'
    defb $fc,$cc,$18,$30,$30,$30,$30,$00
    defb '8'
    defb $7c,$ee,$ee,$7c,$ee,$ee,$7c,$00
    defb '9'
    defb $7c,$ee,$ee,$7e,$0e,$1c,$78,$00
    defb 'A'
    defb $38,$7c,$ee,$ee,$fe,$ee,$ee,$00
    defb 'B'
    defb $fc,$7e,$6e,$7c,$6e,$7e,$fc,$00
    defb 'C'
    defb $3c,$7e,$e0,$e0,$e0,$7e,$3c,$00
    defb 'D'
    defb $f8,$7c,$6e,$6e,$6e,$7c,$f8,$00
    defb 'E'
    defb $fe,$e0,$e0,$fc,$e0,$e0,$fe,$00
    defb 'F'
    defb $fe,$e0,$e0,$fc,$e0,$e0,$e0,$00
    defb 'G'
    defb $7c,$ee,$c0,$de,$ce,$ee,$7c,$00
    defb 'H'
    defb $ee,$ee,$ee,$fe,$ee,$ee,$ee,$00
    defb 'I'
    defb $7c,$38,$38,$38,$38,$38,$7c,$00
    defb 'J'
    defb $3e,$1c,$1c,$1c,$fc,$fc,$78,$00
    defb 'K'
    defb $ee,$fc,$f8,$f0,$f8,$fc,$ee,$00
    defb 'L'
    defb $e0,$e0,$e0,$e0,$e0,$e0,$fe,$00
    defb 'M'
    defb $c6,$ee,$fe,$fe,$ee,$ee,$ee,$00
    defb 'N'
    defb $ce,$ee,$fe,$fe,$fe,$ee,$e6,$00
    defb 'O'
    defb $7c,$ee,$ee,$ee,$ee,$ee,$7c,$00
    defb 'P'
    defb $fc,$ee,$ee,$fc,$e0,$e0,$e0,$00
    defb 'Q'
    defb $7c,$ee,$ee,$ee,$fe,$fc,$7e,$00
    defb 'R'
    defb $fc,$ee,$ee,$fc,$f8,$fc,$ee,$00
    defb 'S'
    defb $7c,$ee,$e0,$7c,$0e,$ee,$7c,$00
    defb 'T'
    defb $fe,$38,$38,$38,$38,$38,$38,$00
    defb 'U'
    defb $ee,$ee,$ee,$ee,$ee,$ee,$7c,$00
    defb 'V'
    defb $c6,$ee,$ee,$ee,$7c,$7c,$38,$00
    defb 'W'
    defb $c6,$ee,$ee,$fe,$fe,$6c,$6c,$00
    defb 'X'
    defb $ee,$ee,$7c,$38,$7c,$ee,$ee,$00
    defb 'Y'
    defb $ee,$ee,$ee,$7c,$38,$38,$38,$00
    defb 'Z'
    defb $fe,$0e,$1c,$38,$70,$e0,$fe,$00

    defb $00 ; EoD

CHRPTN_HIRAGANA:

    ; ここから下はひらがなフォント
    defb $86
    defb $20,$F2,$4C,$30,$50,$82,$7C,$00 ; を

    defb $8C
    defb $00,$10,$58,$64,$A8,$20,$10,$00 ; ゃ

    defb $8D
    defb $00,$10,$B8,$D4,$94,$B8,$20,$00 ; ゅ

    defb $8E
    defb $00,$10,$1C,$10,$70,$9C,$70,$00 ; ょ

    defb $8F
    defb $00,$00,$38,$C4,$04,$08,$10,$00 ; っ

    defb $91
    defb $20,$FC,$20,$7C,$AA,$B2,$64,$00 ; あ

    defb $92
    defb $00,$84,$82,$82,$42,$50,$20,$00 ; い

    defb $93
    defb $38,$00,$7C,$02,$02,$04,$38,$00 ; う

    defb $94
    defb $30,$00,$FC,$08,$30,$48,$8E,$00 ; え

    defb $95
    defb $20,$74,$22,$7C,$A2,$A2,$6C,$00 ; お

    defb $96
    defb $40,$F4,$4A,$48,$48,$48,$90,$00 ; か

    defb $97
    defb $20,$FC,$10,$FE,$08,$80,$7C,$00 ; き

    defb $98
    defb $0C,$30,$40,$80,$40,$30,$0C,$00 ; く

    defb $99
    defb $84,$BE,$84,$84,$84,$84,$48,$00 ; け

    defb $9A
    defb $78,$04,$00,$00,$00,$40,$3C,$00 ; こ

    defb $9B
    defb $10,$FE,$08,$04,$80,$40,$3C,$00 ; さ

    defb $9C
    defb $40,$40,$40,$40,$42,$24,$18,$00 ; し

    defb $9D
    defb $08,$FE,$18,$28,$28,$18,$08,$00 ; す

    defb $9E
    defb $04,$44,$FE,$44,$44,$40,$3C,$00 ; せ

    defb $9F
    defb $78,$10,$2E,$F0,$20,$20,$1C,$00 ; そ
    
    defb $E0
    defb $20,$F8,$40,$4E,$40,$90,$8E,$00 ; た

    defb $E1
    defb $20,$FE,$20,$3C,$02,$02,$3C,$00 ; ち

    defb $E2
    defb $00,$3C,$C2,$02,$02,$04,$08,$00 ; つ

    defb $E3
    defb $FE,$08,$10,$20,$20,$10,$0C,$00 ; て

    defb $E4
    defb $82,$4C,$30,$40,$80,$80,$7E,$00 ; と

    defb $E5
    defb $40,$F4,$42,$44,$9C,$A6,$18,$00 ; な

    defb $E6
    defb $80,$9E,$80,$80,$80,$90,$8E,$00 ; に

    defb $E7
    defb $48,$48,$7C,$D2,$B6,$AA,$4E,$00 ; ぬ

    defb $E8
    defb $40,$60,$DC,$62,$4E,$D2,$4E,$00 ; ね

    defb $E9
    defb $00,$38,$54,$92,$92,$A2,$44,$00 ; の

    defb $EA
    defb $84,$BE,$84,$84,$9C,$A6,$5C,$00 ; は

    defb $EB
    defb $E0,$28,$4C,$8A,$88,$90,$60,$00 ; ひ

    defb $EC
    defb $20,$18,$20,$14,$8A,$AA,$58,$00 ; ふ

    defb $ED
    defb $00,$20,$50,$88,$04,$02,$00,$00 ; へ

    defb $EE
    defb $BE,$84,$BE,$84,$9C,$A6,$5C,$00 ; ほ

    defb $EF
    defb $7C,$10,$7C,$10,$70,$9C,$72,$00 ; ま

    defb $F0
    defb $E4,$24,$24,$7C,$A6,$A4,$64,$00 ; み

    defb $F1
    defb $20,$F4,$62,$A0,$A2,$62,$3C,$00 ; む

    defb $F2
    defb $48,$48,$7C,$D2,$B2,$A2,$44,$00 ; め

    defb $F3
    defb $20,$F0,$40,$F2,$42,$44,$38,$00 ; も

    defb $F4
    defb $10,$4C,$32,$E2,$24,$10,$10,$00 ; や

    defb $F5
    defb $08,$9C,$AA,$CA,$AA,$9C,$30,$00 ; ゆ

    defb $F6
    defb $30,$1C,$10,$10,$70,$9C,$72,$00 ; よ   

    defb $F7
    defb $70,$08,$80,$BC,$C2,$02,$3C,$00 ; ら

    defb $F8
    defb $42,$42,$42,$42,$22,$04,$18,$00 ; り

    defb $F9
    defb $00,$7E,$02,$0C,$22,$52,$3C,$00 ; る

    defb $FA
    defb $40,$6C,$D4,$64,$44,$C4,$42,$00 ; れ

    defb $FB
    defb $78,$10,$38,$44,$84,$04,$38,$00 ; ろ

    defb $FC
    defb $40,$60,$DC,$62,$42,$C2,$4C,$00 ; わ

    defb $FD
    defb $20,$20,$40,$60,$52,$92,$8C,$00 ; ん

    defb $00 ; EoD

