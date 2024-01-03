;--------------------------------------------
; data_pcg.asm
; 固定データ(GRAPHIC2モード用)
;--------------------------------------------
; キャラクタパターンとカラーテーブル

CHRPTN_TITLE_LOGO:

    defb $60
    defb $20, $30, $38, $3C, $37, $33, $30, $30
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $61
    defb $10, $30, $70, $F0, $B0, $30, $31, $33
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $62
    defb $00, $00, $00, $00, $00, $06, $E3, $33
    defb $41, $41, $41, $41, $41, $41, $41, $41
  
    defb $63
    defb $00, $00, $00, $00, $06, $02, $33, $33
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $64
    defb $00, $00, $02, $03, $09, $E7, $D1, $31
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $65
    defb $00, $00, $00, $10, $18, $CE, $21, $0F
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $66
    defb $00, $00, $00, $18, $1B, $01, $11, $19
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $67
    defb $00, $00, $00, $00, $00, $70, $D8, $98
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $80
    defb $30, $30, $30, $30, $30, $30, $60, $40
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $81
    defb $33, $33, $33, $33, $33, $33, $3B, $3E
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $82
    defb $33, $33, $33, $33, $33, $33, $33, $CC
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $83
    defb $33, $33, $33, $33, $33, $33, $32, $CC
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $84
    defb $33, $33, $33, $33, $33, $33, $32, $1C
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $85
    defb $19, $19, $19, $19, $19, $19, $99, $67
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $86
    defb $99, $99, $99, $99, $99, $99, $A9, $66
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $87
    defb $98, $98, $98, $98, $98, $98, $1F, $9F
    defb $41, $41, $41, $71, $71, $71, $71, $71

    defb $68
    defb $00, $04, $02, $19, $25, $25, $25, $19
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1

    defb $69
    defb $00, $00, $20, $C0, $00, $E0, $00, $00
    defb $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1

    defb $6A
    defb $04, $07, $03, $00, $00, $00, $00, $00
    defb $71, $71, $71, $71, $71, $71, $71, $71

    defb $6B
    defb $00, $70, $F8, $C4, $C6, $C6, $C6, $C6
    defb $71, $71, $71, $71, $71, $71, $71, $71

    defb $6C
    defb $00, $00, $00, $48, $67, $6C, $6C, $6C
    defb $71, $71, $71, $71, $71, $71, $71, $71

    defb $6D
    defb $00, $00, $00, $00, $8E, $07, $07, $06
    defb $71, $71, $71, $71, $71, $71, $71, $71

    defb $6E
    defb $00, $00, $00, $0D, $0D, $1C, $BC, $EC
    defb $71, $71, $71, $71, $71, $71, $71, $71

    defb $6F
    defb $00, $00, $00, $00, $80, $E0, $10, $F0
    defb $71, $71, $71, $71, $71, $71, $71, $71

    defb $8C
    defb $C3, $CF, $D6, $C6, $C6, $C6, $C4, $88
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $8D
    defb $6C, $EF, $6C, $6C, $6C, $6C, $6F, $30
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $8E
    defb $06, $86, $06, $06, $06, $06, $86, $F8
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $8F
    defb $4D, $0D, $0D, $0D, $0D, $0D, $0D, $06
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $70
    defb $9A, $9B, $9B, $9B, $9B, $9B, $9B, $76
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $77
    defb $63, $B6, $36, $36, $36, $37, $36, $F9
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $78
    defb $C0, $30, $30, $30, $C0, $88, $10, $F0
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $71
    defb $00, $00, $00, $3E, $00, $00, $00, $00
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $72
    defb $00, $00, $00, $F7, $00, $00, $00, $00
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $73
    defb $00, $00, $00, $6B, $00, $00, $00, $00
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $74
    defb $00, $00, $00, $FF, $00, $00, $00, $00
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $75
    defb $00, $00, $00, $FF, $01, $01, $00, $00
    defb $41, $41, $41, $41, $41, $41, $41, $41

    defb $76
    defb $30, $30, $30, $70, $70, $C0, $80, $00
    defb $41, $41, $41, $41, $41, $41, $41, $41
   
CHRPTN_TITLE_LOGO_END:

    defb $00

;
; キャラクラパターン作成規則：
;
CHRPTN:

    defb $23  ; MAP外（白い壁）CHAR CODE
    defb $80, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; P
    defb $FE, $FE, $FE, $FE, $FE, $FE, $FE, $FE ; C 

    defb $24  ; 背景
    defb $80, $7F, $AA, $94, $AA, $94, $AA, $7F ; P
    defb $51, $51, $51, $51, $51, $51, $51, $51 ; C

; プレイヤーの体力アイコン

    defb $25  ; ハート(7/1)
    defb $00, $00, $80, $80, $80, $00, $00, $00 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    defb $26  ; ハート(7/2)
    defb $00, $40, $C0, $C0, $C0, $40, $00, $00 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    defb $27  ; ハート(7/3)
    defb $00, $60, $E0, $E0, $E0, $60, $20, $00 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    defb $28  ; ハート(7/4)
    defb $00, $60, $F0, $F0, $F0, $70, $30, $10 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    defb $29  ; ハート(7/5)
    defb $00, $68, $F8, $F8, $F8, $78, $38, $10 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    defb $2A  ; ハート(7/6)
    defb $00, $6C, $FC, $FC, $FC, $7C, $38, $10 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    defb $2B  ; ハート(7/7)
    defb $00, $6C, $FE, $FE, $FE, $7C, $38, $10 ; P
    defb $81, $81, $81, $81, $81, $61, $81, $61 ; C

    ; ロウソクマーク
    defb $2C
    defb $18, $3C, $3C, $3C, $18, $18, $18, $18 ; P
    defb $61, $61, $61, $61, $61, $F1, $F1, $E1 ; C

; テキキャラの体力アイコン

    defb $80  ; ハート(7/0)
    defb $00, $00, $00, $00, $00, $00, $00, $00 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $81  ; ハート(7/1)
    defb $00, $00, $80, $80, $80, $00, $00, $00 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $82  ; ハート(7/2)
    defb $00, $40, $C0, $C0, $C0, $40, $00, $00 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $83  ; ハート(7/3)
    defb $00, $60, $E0, $E0, $E0, $60, $20, $00 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $84  ; ハート(7/4)
    defb $00, $60, $F0, $F0, $F0, $70, $30, $10 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $85  ; ハート(7/5)
    defb $00, $68, $F8, $F8, $F8, $78, $38, $10 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $86  ; ハート(7/6)
    defb $00, $6C, $FC, $FC, $FC, $7C, $38, $10 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

    defb $87  ; ハート(7/7)
    defb $00, $6C, $FE, $FE, $FE, $7C, $38, $10 ; P
    defb $51, $51, $51, $51, $51, $41, $51, $41 ; C

; ミッションステータスアイコン

    defb $5B
    defb $00, $FE, $FE, $FE, $FE, $FE, $FE, $00 ; P
    defb $11, $F1, $31, $21, $21, $31, $F1, $11 ; C

; 装備中マーク

    defb $5C
    defb $3C, $42, $DF, $C3, $DF, $DF, $42, $3C ; P
    defb $51, $51, $51, $51, $51, $51, $51, $51 ; C

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

; ダイアログ内に表示するスロットアイコン

    defb $AA ; 攻撃
    defb $03, $07, $0E, $1C, $38, $70, $E0, $C0 ; P
    defb $F1, $F1, $F1, $F1, $E1, $61, $61, $61 ; C

    defb $AB ; 防御
    defb $7E, $7E, $7E, $7E, $7E, $7E, $3C, $18 ; P
    defb $F1, $F1, $61, $61, $61, $61, $61, $E1 ; C

    defb $AC ; 装飾品
    defb $3C, $42, $42, $24, $18, $3C, $18, $18 ; P
    defb $71, $71, $51, $51, $41, $41, $41, $D1 ; C

    defb $AD ; 道具
    defb $7C, $44, $44, $7C, $10, $18, $10, $18 ; P
    defb $F1, $E1, $E1, $F1, $E1, $E1, $E1, $E1 ; C

    defb $AE ; 下向き矢印
    defb $38, $38, $38, $38, $FE, $7C, $38, $10 ; P
    defb $A1, $F1, $A1, $F1, $A1, $F1, $A1, $A1 ; C 

    defb $AF ; 右向き矢印
    defb $00, $60, $70, $78, $7C, $78, $70, $60 ; P
    defb $61, $61, $61, $61, $61, $61, $61, $61 ; C

; リング職人（山岳地帯へのガードマン兼任）

    defb $B0
    defb $0F, $1F, $3F, $7F, $3F, $3B, $35, $3F ; P
    defb $41, $31, $41, $41, $F1, $F1, $F1, $F1 ; C
    defb $B1
    defb $3B, $3C, $DF, $DF, $DF, $1F, $1F, $3E ; P
    defb $F1, $F1, $F1, $C1, $C1, $31, $31, $31 ; C
    defb $B2
    defb $F0, $F8, $FC, $FE, $FC, $DC, $AC, $FC ; P
    defb $41, $31, $41, $41, $F1, $F1, $F1, $F1 ; C
    defb $B3
    defb $DC, $3C, $FB, $FB, $FB, $F8, $F8, $7C ; P
    defb $F1, $F1, $F1, $C1, $C1, $31, $31, $31 ; C

CHRPTN_STAIR_UP1:

    ; 上り階段1
    defb $64  ; CHAR CODE
    defb $00, $FF, $BF, $BF, $80, $8F, $8F, $8F ; P
    defb $F1, $F1, $F1, $E1, $F1, $F1, $F1, $E1 ; C
    defb $65  ; CHAR CODE
    defb $80, $83, $83, $83, $80, $80, $80, $FF ; P
    defb $F1, $F1, $F1, $E1, $F1, $F1, $F1, $E1 ; C
    defb $66  ; CHAR CODE
    defb $00, $80, $80, $80, $00, $E0, $E0, $E0 ; P
    defb $F1, $F1, $F1, $E1, $F1, $F1, $F1, $E1 ; C
    defb $67  ; CHAR CODE
    defb $00, $F8, $F8, $F8, $00, $FE, $FE, $FE ; P
    defb $F1, $F1, $F1, $E1, $00, $F1, $F1, $E1 ; C

CHRPTN_STAIR_UP2:

    ; 上り階段
    defb $68  ; CHAR CODE
    defb $00, $FF, $BF, $BF, $80, $8F, $8F, $8F ; P
    defb $F1, $F1, $F1, $E1, $F1, $F1, $F1, $E1 ; C
    defb $69  ; CHAR CODE
    defb $80, $83, $83, $83, $80, $80, $80, $FF ; P
    defb $F1, $F1, $F1, $E1, $F1, $F1, $F1, $E1 ; C
    defb $6A  ; CHAR CODE
    defb $00, $80, $80, $80, $00, $E0, $E0, $E0 ; P
    defb $F1, $F1, $F1, $E1, $F1, $F1, $F1, $E1 ; C
    defb $6B  ; CHAR CODE
    defb $00, $F8, $F8, $F8, $00, $FE, $FE, $FE ; P
    defb $F1, $F1, $F1, $E1, $00, $F1, $F1, $E1 ; C

CHRPTN_STAIR_DOWN:

    ; 下り階段
    defb $6C  ; CHAR CODE
    defb $00, $01, $01, $01, $00, $07, $07, $07 ; P
    defb $11, $E1, $F1, $F1, $11, $E1, $F1, $F1 ; C
    defb $6D  ; CHAR CODE
    defb $00, $1F, $1F, $1F, $00, $7F, $7F, $7F ; P
    defb $11, $E1, $F1, $F1, $11, $E1, $F1, $F1 ; C
    defb $6E  ; CHAR CODE
    defb $00, $FF, $FF, $FF, $00, $FF, $FF, $FF ; P
    defb $11, $E1, $F1, $F1, $11, $E1, $F1, $F1 ; C
    defb $6F  ; CHAR CODE
    defb $00, $FF, $FF, $FF, $00, $FF, $FF, $FF ; P
    defb $11, $E1, $F1, $F1, $11, $E1, $F1, $F1 ; C

CHRPTN_PIT_BLOCK:

    ; PITの壁
    defb $70  ; CHAR CODE
    defb $7F, $AF, $5F, $AF, $7F, $FF, $FF, $00 ; P
    defb $41, $51, $51, $51, $51, $41, $41, $11 ; C
    defb $71  ; CHAR CODE
    defb $EF, $DF, $DF, $EF, $F7, $F7, $6F, $00 ; P
    defb $41, $51, $51, $51, $51, $41, $41, $11 ; C
    defb $72  ; CHAR CODE
    defb $DC, $EE, $EE, $DE, $BE, $BE, $DE, $00 ; P
    defb $41, $51, $51, $51, $51, $41, $41, $11 ; C
    defb $73  ; CHAR CODE
    defb $FE, $FE, $FE, $FE, $FE, $FE, $FC, $00 ; P
    defb $41, $51, $51, $51, $51, $41, $41, $11 ; C

CHRPTN_MOUNTAIN:

    ; 岩山
    defb $75  ; CHAR CODE
    defb $1C, $3E, $3E, $7F, $7F, $7F, $7F, $BF ; P
    defb $61, $61, $61, $61, $61, $61, $91, $61 ; C
    defb $76  ; CHAR CODE
    defb $DF, $EF, $F7, $FB, $FD, $FD, $FD, $00 ; P
    defb $61, $91, $61, $91, $61, $91, $91, $61 ; C
    defb $77  ; CHAR CODE
    defb $30, $78, $F8, $7C, $7C, $7C, $BC, $BE ; P
    defb $61, $61, $61, $61, $61, $61, $61, $91 ; C
    defb $78  ; CHAR CODE
    defb $BE, $DF, $DE, $EF, $F6, $F7, $FA, $00 ; P
    defb $61, $61, $91, $61, $91, $91, $91, $61 ; C

CHRPTN_MINEBLOCK:

    ; 炭鉱の壁
    defb $79  ; CHAR CODE
    defb $7F, $FF, $FF, $FF, $FF, $FF, $7F, $00 ; P
    defb $B1, $B1, $B1, $B1, $B1, $B1, $A1, $A1 ; C
    defb $7A  ; CHAR CODE
    defb $FC, $FE, $FC, $FA, $F4, $EA, $F4, $00 ; P
    defb $A1, $B1, $B1, $B1, $B1, $A1, $A1, $A1 ; C
    defb $7B  ; CHAR CODE
    defb $FC, $FE, $FC, $FA, $F4, $FA, $D4, $00 ; P
    defb $B1, $B1, $B1, $B1, $B1, $B1, $A1, $A1 ; C
    defb $7C  ; CHAR CODE
    defb $7F, $FF, $FF, $FF, $FF, $FF, $7F, $00 ; P
    defb $B1, $B1, $B1, $B1, $B1, $B1, $A1, $A1 ; C

CHRPTN_TREASUREBOX:

    ; 宝箱
    defb $88
    defb $00, $00, $00, $3F, $7F, $81, $FF, $80 ; P
    defb $11, $11, $11, $A1, $A1, $AB, $A1, $A6 ; C
    defb $89
    defb $FF, $84, $87, $81, $E1, $A1, $FF, $00 ; P
    defb $A1, $A6, $A6, $A6, $A6, $A6, $A6, $11 ; C
    defb $8A
    defb $00, $00, $00, $FC, $FE, $FF, $FF, $01 ; P
    defb $11, $11, $11, $A1, $B1, $A1, $A1, $A6 ; C
    defb $8B
    defb $FF, $21, $E1, $81, $87, $85, $FF, $00 ; P
    defb $A1, $A6, $A6, $A6, $A6, $A6, $A1, $11 ; C

CHRPTN_YELLOW_DOOR:

    ; 黄色ドア
    defb $8D
    defb $3F, $7F, $7F, $C1, $81, $81, $81, $81 ; P
    defb $A1, $A1, $A1, $AB, $AB, $AB, $AB, $AB ; C
    defb $8E
    defb $83, $83, $83, $81, $81, $81, $81, $81 ; P
    defb $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB ; C
    defb $8F
    defb $FC, $FE, $FE, $83, $81, $81, $81, $81 ; P
    defb $A1, $A1, $A1, $AB, $AB, $AB, $AB, $AB ; C
    defb $90
    defb $C1, $C1, $C1, $81, $81, $81, $81, $81 ; P
    defb $AB, $AB, $AB, $AB, $AB, $AB, $AB, $AB ; C

CHRPTN_BLUE_DOOR:

    ; 青色ドア
    defb $91
    defb $3F, $7F, $7F, $C1, $81, $81, $81, $81 ; P
    defb $41, $41, $41, $45, $45, $45, $45, $45 ; C
    defb $92
    defb $83, $83, $83, $81, $81, $81, $81, $81 ; P
    defb $45, $45, $45, $45, $45, $45, $45, $45 ; C
    defb $93
    defb $FC, $FE, $FE, $83, $81, $81, $81, $81 ; P
    defb $41, $41, $41, $45, $45, $45, $45, $45 ; C
    defb $94
    defb $C1, $C1, $C1, $81, $81, $81, $81, $81 ; P
    defb $45, $45, $45, $45, $45, $45, $45, $45 ; C

CHRPTN_TREASUREBOX_RARE:

    ; 宝箱（レアアイテム）
    defb $95
    defb $00, $00, $00, $3F, $7F, $81, $FF, $80 ; P
    defb $11, $11, $11, $A1, $A1, $AB, $A1, $A5 ; C
    defb $96
    defb $FF, $84, $87, $81, $E1, $A1, $FF, $00 ; P
    defb $A1, $A5, $A5, $A5, $A5, $A5, $A5, $11 ; C
    defb $97
    defb $00, $00, $00, $FC, $FE, $FF, $FF, $01 ; P
    defb $11, $11, $11, $A1, $B1, $A1, $A1, $A5 ; C
    defb $98
    defb $FF, $21, $E1, $81, $87, $85, $FF, $00 ; P
    defb $A1, $A5, $A5, $A5, $A5, $A5, $A1, $11 ; C

CHRPTN_WATER:

    ; 水
    defb $74  ; CHAR CODE
    defb $FF, $AA, $55, $FF, $FF, $FF, $FF, $FF ; P
    defb $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; C

    ; 水（永久回廊判定用）
    defb $99  ; CHAR CODE
    defb $FF, $AA, $55, $FF, $FF, $FF, $FF, $FF ; P
    defb $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; C

    defb 0 ; EoD

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

CHRPTN_FOREST_GROUND_0:

    ; 平野：床
    defb $22  ; 歩行可能な床 CHAR CODE
    defb $00, $66, $00, $33, $00, $66, $00, $33 ; P
    defb $32, $32, $32, $32, $32, $32, $32, $32 ; C

CHRPTN_PLAIN_WOOD:

    ; 平野：木
    defb $60
    defb $1F, $3F, $7F, $C7, $FF, $F0, $FF, $FF ; P
    defb $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2 ; C
    defb $61
    defb $FC, $FF, $67, $3F, $07, $03, $07, $0F ; P
    defb $C2, $C2, $C2, $C2, $A2, $82, $A2, $82 ; C
    defb $62
    defb $F8, $FC, $FC, $FF, $C3, $7F, $E1, $FF ; P
    defb $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2 ; C
    defb $63
    defb $1F, $FF, $FE, $FC, $E0, $C0, $E0, $F0 ; P
    defb $C2, $C2, $C2, $C2, $82, $A2, $82, $82 ; C
    defb $00

CHRPTN_FOREST_GROUND_1:

    ; 怪しい森：床
    defb $22  ; 歩行可能な床 CHAR CODE
    defb $00, $78, $00, $00, $1F, $00, $00, $00 ; P
    defb $61, $61, $61, $61, $61, $61, $61, $61 ; C
    defb $00

CHRPTN_FOREST_WOOD_1:

    ; 怪しい森：木2
    defb $60
    defb $1F, $3F, $7F, $FF, $DD, $E3, $FF, $F7 ; P
    defb $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1 ; C
    defb $61
    defb $F9, $FC, $7E, $3F, $07, $03, $07, $0F ; P
    defb $C1, $C1, $C1, $C1, $A1, $81, $A1, $81 ; C
    defb $62
    defb $F8, $FC, $FE, $FF, $BB, $C7, $FF, $EF ; P
    defb $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1 ; C
    defb $63
    defb $9F, $3F, $7E, $FC, $E0, $C0, $E0, $F0 ; P
    defb $C1, $C1, $C1, $C1, $81, $A1, $81, $81 ; C
    defb $00

CHRPTN_FOREST_WOOD_2:

    ; 怪しい森：木2
    defb $60
    defb $1F, $33, $7D, $E3, $C9, $E3, $FF, $F7 ; P
    defb $C1, $C1, $C1, $C1, $CF, $CF, $CF, $C1 ; C
    defb $61
    defb $F9, $FC, $7E, $3F, $07, $03, $07, $0F ; P
    defb $C1, $C1, $C1, $C1, $A1, $81, $A1, $81 ; C
    defb $62
    defb $F8, $CC, $BE, $C7, $93, $C7, $FF, $EF ; P
    defb $C1, $C1, $C1, $C1, $CF, $CF, $CF, $C1 ; C
    defb $63
    defb $9F, $3F, $7E, $FC, $E0, $C0, $E0, $F0 ; P
    defb $C1, $C1, $C1, $C1, $81, $A1, $81, $81 ; C
    defb $00

CHRPTN_PLAIN_WOOD_2:

    ; 平野：木（ピープホール状態で表示される）
    defb $60
    defb $1F, $3F, $7F, $C7, $FF, $F0, $FF, $FF ; P
    defb $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1 ; C
    defb $61
    defb $FC, $FF, $67, $3F, $07, $03, $07, $0F ; P
    defb $C1, $C1, $C1, $C1, $A1, $81, $A1, $81 ; C
    defb $62
    defb $F8, $FC, $FC, $FF, $C3, $7F, $E1, $FF ; P
    defb $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1 ; C
    defb $63
    defb $1F, $FF, $FE, $FC, $E0, $C0, $E0, $F0 ; P
    defb $C2, $C1, $C1, $C1, $81, $A1, $81, $81 ; C
    defb $00

CHRPTN_PIT_GROUND_1:

    defb $22  ; 床（PITの床、ダンジョンの床）CHAR CODE
    defb $FE, $80, $80, $80, $80, $80, $80, $00 ; P
    defb $41, $41, $41, $41, $41, $41, $41, $11 ; C
    defb $00

CHRPTN_WATER_1:

    defb $74  ; CHAR CODE
    defb $FF, $AA, $55, $FF, $FF, $FF, $FF, $FF ; P
    defb $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; C
    defb $99  ; CHAR CODE
    defb $FF, $AA, $55, $FF, $FF, $FF, $FF, $FF ; P
    defb $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; C
    defb $00

CHRPTN_WATER_2:

    defb $74  ; CHAR CODE
    defb $FF, $FF, $FF, $FF, $FF, $AA, $55, $FF ; P
    defb $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; C
    defb $99  ; CHAR CODE
    defb $FF, $FF, $FF, $FF, $FF, $AA, $55, $FF ; P
    defb $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F ; C
    defb $00

CHRPTN_MINE_GROUND_1:

    ; 炭鉱：床
    defb $22  ; 歩行可能な床 CHAR CODE
    defb $FE, $82, $BA, $AA, $BA, $82, $FE, $00 ; P
    defb $86, $86, $86, $86, $86, $86, $86, $86 ; C
    defb $00

TITLE_LOGO_1:
    defb $60, $61, $62, $63, $64, $65, $66, $67
TITLE_LOGO_2:
    defb $80, $81, $82, $83, $84, $85, $86, $87
TITLE_LOGO_3:
    defb $20, $20, $20, $68, $69, $20, $20, $20
TITLE_LOGO_4:
    defb $6A, $6B, $6C, $6D, $6E, $6F, $20, $20
TITLE_LOGO_5:
    defb $20, $8C, $8D, $8E, $8F, $70, $77, $78
TITLE_LOGO_6:
    defb $71, $72, $73, $74, $74, $75, $76, $20
