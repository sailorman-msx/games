;--------------------------------------------
; data_sprite.asm
; 固定データ(スプライト作成用)
;--------------------------------------------

SPRPTN:

; 正面
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #0
defb $00, $00, $00, $03, $07, $0F, $08, $08
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $C0, $E0, $F0, $10, $10
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #4
defb $00, $00, $00, $00, $00, $00, $05, $05
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $A0, $A0
defb $08, $14, $20, $20, $20, $24, $24, $24 ; #8
defb $18, $04, $04, $04, $04, $08, $09, $0E
defb $10, $28, $04, $04, $04, $24, $24, $24
defb $18, $20, $20, $20, $20, $10, $90, $70
defb $07, $0A, $1F, $1F, $1F, $1B, $1B, $1B ; #12
defb $07, $03, $03, $03, $03, $07, $06, $00
defb $E0, $50, $F8, $F8, $F8, $D8, $D8, $D8
defb $E0, $C0, $C0, $C0, $C0, $E0, $60, $00

; 背面
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #16
defb $00, $00, $00, $03, $07, $0F, $0F, $0F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $C0, $E0, $F0, $F0, $F0
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #20
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $0F, $17, $23, $20, $20, $24, $24, $24 ; #24
defb $18, $04, $04, $04, $04, $08, $09, $0E
defb $F0, $E8, $C4, $04, $04, $24, $24, $24
defb $18, $20, $20, $20, $20, $10, $90, $70
defb $00, $08, $1C, $1F, $1F, $1B, $1B, $1B ; #28
defb $07, $03, $03, $03, $03, $07, $06, $00
defb $00, $10, $38, $F8, $F8, $D8, $D8, $D8
defb $E0, $C0, $C0, $C0, $C0, $E0, $60, $00

; 右方向#1
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #32
defb $00, $00, $00, $03, $07, $0F, $08, $08
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $C0, $E0, $F0, $10, $10
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #36
defb $00, $00, $00, $00, $00, $00, $07, $07
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $40, $40
defb $08, $08, $04, $08, $08, $08, $09, $09 ; #40
defb $09, $07, $02, $02, $02, $02, $02, $01
defb $10, $10, $20, $20, $20, $20, $20, $20
defb $20, $40, $40, $40, $40, $40, $40, $80
defb $07, $07, $03, $07, $07, $07, $06, $06 ; #44
defb $06, $00, $01, $01, $01, $01, $01, $00
defb $E0, $E0, $C0, $C0, $C0, $C0, $C0, $C0
defb $C0, $80, $80, $80, $80, $80, $80, $00

; 右方向#2
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #48
defb $00, $00, $00, $00, $00, $03, $07, $0F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $C0, $E0, $F0
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #52
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $08, $08, $08, $08, $04, $0C, $14, $24 ; #56
defb $44, $4C, $34, $08, $08, $11, $12, $1C
defb $10, $10, $10, $10, $20, $10, $08, $04
defb $42, $32, $2C, $50, $88, $88, $48, $30
defb $07, $07, $07, $07, $03, $03, $0B, $1B ; #60
defb $3B, $33, $03, $07, $07, $0E, $0C, $00
defb $40, $40, $E0, $E0, $C0, $E0, $F0, $F8
defb $BC, $CC, $C0, $A0, $70, $70, $30, $00

; 右方向#3
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #64
defb $00, $00, $00, $00, $00, $03, $07, $0F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $C0, $E0, $F0
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #68
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $08, $08, $08, $08, $04, $08, $10, $20 ; #72
defb $44, $4C, $36, $09, $08, $11, $12, $1C
defb $10, $10, $10, $10, $20, $30, $28, $24
defb $22, $32, $2C, $10, $88, $88, $48, $30
defb $07, $07, $07, $07, $03, $07, $0F, $1F ; #76
defb $3B, $33, $01, $06, $07, $0E, $0C, $00
defb $40, $40, $E0, $E0, $C0, $C0, $D0, $D8
defb $DC, $CC, $C0, $E0, $70, $70, $30, $00

; 右方向：しゃがみ
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #80
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #84
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $1B, $27 ; #88
defb $4F, $48, $38, $08, $08, $14, $13, $1C
defb $00, $00, $00, $00, $00, $00, $D8, $E4
defb $F2, $12, $1C, $10, $18, $28, $C8, $30
defb $00, $00, $00, $00, $00, $00, $00, $18 ; #92
defb $30, $37, $07, $07, $07, $0B, $0C, $00
defb $00, $00, $00, $00, $00, $00, $00, $18
defb $0C, $4C, $40, $E0, $E0, $D0, $30, $00

; 左方向#1
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #96
defb $00, $00, $00, $03, $07, $0F, $08, $08
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $C0, $E0, $F0, $10, $10
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #100
defb $00, $00, $00, $00, $00, $00, $02, $02
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $E0, $E0
defb $08, $08, $04, $04, $04, $04, $04, $04 ; #104
defb $04, $02, $02, $02, $02, $02, $02, $01
defb $10, $10, $20, $10, $10, $10, $90, $90
defb $90, $60, $40, $40, $40, $40, $40, $80
defb $07, $07, $03, $03, $03, $03, $03, $03 ; #108
defb $03, $01, $01, $01, $01, $01, $01, $00
defb $E0, $E0, $C0, $E0, $E0, $E0, $60, $60
defb $60, $80, $80, $80, $80, $80, $80, $00

; 左方向#2
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #112
defb $00, $00, $00, $00, $00, $03, $07, $0F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $C0, $E0, $F0
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #116
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $08, $08, $08, $08, $04, $08, $10, $20 ; #120
defb $42, $4C, $34, $0A, $09, $11, $12, $1C
defb $10, $10, $10, $10, $20, $30, $28, $24
defb $22, $32, $2C, $10, $08, $88, $48, $30
defb $02, $02, $07, $07, $03, $07, $0F, $1F ; #124
defb $3D, $33, $03, $05, $06, $0E, $0C, $00
defb $E0, $E0, $E0, $E0, $C0, $C0, $D0, $D8
defb $DC, $CC, $C0, $E0, $F0, $70, $30, $00

; 左方向#3
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #128
defb $00, $00, $00, $00, $00, $03, $07, $0F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $C0, $E0, $F0
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #132
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $08, $08, $08, $08, $04, $0C, $14, $24 ; #136
defb $44, $4C, $34, $08, $08, $11, $12, $1C
defb $10, $10, $10, $10, $20, $10, $08, $04
defb $22, $32, $6C, $90, $88, $88, $48, $30
defb $02, $02, $07, $07, $03, $03, $0B, $1B ; #140
defb $3B, $33, $03, $07, $07, $0E, $0C, $00
defb $E0, $E0, $E0, $E0, $C0, $E0, $F0, $F8
defb $DC, $CC, $80, $60, $70, $70, $30, $00

; 左方向：しゃがみ
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #144
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #148
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $1B, $27 ; #152
defb $4F, $48, $38, $08, $08, $14, $13, $1C
defb $00, $00, $00, $00, $00, $00, $D8, $E4
defb $F2, $12, $1C, $10, $18, $28, $C8, $30
defb $00, $00, $00, $00, $00, $00, $00, $18 ; #156
defb $30, $32, $02, $07, $07, $0B, $0C, $00
defb $00, $00, $00, $00, $00, $00, $00, $18
defb $0C, $EC, $E0, $E0, $E0, $D0, $30, $00

; はしご昇降#1
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #160
defb $00, $00, $00, $03, $07, $6F, $9F, $8F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $C0, $E0, $F0, $F0, $FE
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #164
defb $00, $00, $00, $00, $00, $00, $60, $70
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $8F, $9F, $94, $48, $48, $38, $08, $04 ; #168
defb $08, $08, $08, $11, $11, $0E, $00, $00
defb $F1, $F9, $29, $12, $12, $1C, $10, $20
defb $1C, $02, $82, $62, $1C, $00, $00, $00
defb $70, $60, $63, $37, $37, $07, $07, $03 ; #172
defb $07, $07, $07, $0E, $0E, $00, $00, $00
defb $0E, $06, $C6, $EC, $EC, $E0, $E0, $C0
defb $E0, $FC, $7C, $1C, $00, $00, $00, $00

; はしご昇降#2
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #176
defb $00, $00, $00, $03, $07, $0F, $0F, $7F
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $C0, $E0, $F6, $F9, $F1
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #180
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $06, $0E
defb $8F, $9F, $94, $48, $48, $38, $08, $04 ; #184
defb $38, $40, $41, $46, $38, $00, $00, $00
defb $F1, $F9, $29, $12, $12, $1C, $10, $20
defb $10, $10, $10, $88, $88, $70, $00, $00
defb $70, $60, $63, $37, $37, $07, $07, $03 ; #188
defb $07, $3F, $3E, $38, $00, $00, $00, $00
defb $0E, $06, $C6, $EC, $EC, $E0, $E0, $C0
defb $E0, $E0, $E0, $70, $70, $00, $00, $00

; 真上ジャンプ、下降
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #192
defb $00, $00, $00, $00, $03, $07, $68, $98
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $C0, $E0, $16, $19
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #196
defb $00, $00, $00, $00, $00, $00, $05, $65
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $A0, $A6
defb $88, $88, $88, $8C, $40, $40, $38, $08 ; #200
defb $04, $38, $44, $45, $46, $38, $00, $00
defb $11, $11, $11, $31, $02, $02, $1C, $10
defb $20, $1C, $22, $A2, $62, $1C, $00, $00
defb $77, $76, $77, $73, $3F, $3F, $07, $07 ; #204
defb $03, $07, $3B, $3A, $38, $00, $00, $00
defb $EE, $6E, $EE, $CE, $FC, $FC, $E0, $E0
defb $C0, $E0, $DC, $5C, $1C, $00, $00, $00

; 銃かまえる右向き
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #208
defb $00, $00, $00, $0F, $1F, $3F, $20, $20
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $80, $C0, $40, $40
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #212
defb $00, $00, $00, $00, $00, $00, $1D, $1D
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $20, $20, $10, $2E, $20, $20, $1E, $09 ; #216
defb $08, $16, $13, $12, $22, $22, $24, $18
defb $40, $40, $80, $40, $00, $00, $24, $D8
defb $20, $10, $90, $90, $90, $90, $90, $60
defb $1F, $1F, $0F, $11, $1F, $1F, $01, $06 ; #220
defb $07, $09, $0C, $0C, $1C, $1C, $18, $00
defb $80, $80, $00, $80, $00, $98, $D8, $00
defb $C0, $E0, $60, $60, $60, $60, $60, $00

; 銃かまえる左向き
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #224
defb $00, $00, $00, $00, $01, $03, $02, $02
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $F0, $F8, $FC, $04, $04
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #228
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $B8, $B8
defb $02, $02, $01, $02, $00, $00, $24, $1B ; #232
defb $04, $08, $09, $09, $09, $09, $09, $06
defb $04, $04, $08, $74, $04, $04, $78, $90
defb $10, $68, $C8, $48, $44, $44, $24, $18
defb $01, $01, $00, $01, $00, $19, $1B, $00 ; #236
defb $03, $07, $06, $06, $06, $06, $06, $00
defb $F8, $F8, $F0, $88, $F8, $F8, $80, $60
defb $E0, $90, $30, $30, $38, $38, $18, $00

; 弾
defb $00, $00, $00, $01, $03, $03, $01, $00 ; #240
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $80, $C0, $C0, $80, $00
defb $00, $00, $00, $00, $00, $00, $00, $00

; 被ダメエフェクト#1
defb $00, $10, $10, $38, $38, $7E, $38, $38 ; #244
defb $10, $13, $03, $00, $00, $10, $02, $00
defb $00, $40, $08, $00, $00, $60, $64, $04
defb $0E, $0E, $1F, $0E, $0E, $0E, $04, $04

; 被ダメエフェクト#2
defb $00, $40, $0C, $0C, $80, $00, $02, $02 ; #248
defb $27, $07, $0F, $07, $07, $02, $02, $00
defb $20, $20, $70, $70, $F8, $70, $70, $22
defb $20, $00, $80, $19, $18, $00, $02, $00

; ブランクスプライト
defb $00, $00, $00, $00, $00, $00, $00, $00 ; #252
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00

SPRPTN_END:
    nop
