;--------------------------------------------
; data_sprite.asm
; 固定データ(スプライト作成用)
;--------------------------------------------

; キャラクタパターン
; キャラクターは方向に応じて
; #1 -> #2 -> #1 -> #0 -> #1 -> #2 -> #1 -> #0 ...
; という順番で表示する
; #2なったら減算していく
; #0になったら加算していく

SPRPTN:

; NO 001

; PLAYER
; 上方向#0
defb $00, $0F, $1F, $1F, $1F, $07, $03, $00 ; PATTERN#0
defb $0F, $0F, $0F, $07, $00, $00, $06, $00
defb $00, $F0, $F8, $F8, $FC, $E0, $C0, $00
defb $F0, $F0, $F0, $E0, $00, $00, $00, $60
defb $00, $00, $00, $00, $00, $08, $0C, $07 ; PATTERN#4
defb $10, $30, $70, $60, $46, $06, $00, $00
defb $00, $00, $00, $00, $00, $10, $32, $E6
defb $0E, $0C, $08, $00, $60, $60, $60, $00

; 上方向#1
defb $07, $0F, $1F, $1F, $1F, $07, $03, $00 ; PATTERN#8
defb $0F, $0F, $0F, $07, $00, $00, $00, $06
defb $E0, $F0, $F8, $F8, $FC, $E0, $C0, $00
defb $F0, $F0, $F0, $E0, $00, $00, $00, $60
defb $00, $00, $00, $00, $00, $08, $0C, $07 ; PATTERN#12
defb $10, $30, $30, $30, $36, $06, $06, $00
defb $00, $00, $00, $00, $00, $10, $30, $E0
defb $08, $0C, $0C, $0C, $6C, $60, $60, $00
; 上方向#2
defb $00, $0F, $1F, $1F, $1F, $07, $03, $00 ; PATTERN#16
defb $0F, $0F, $0F, $07, $00, $00, $00, $06
defb $00, $F0, $F8, $F8, $FC, $E0, $C0, $00
defb $F0, $F0, $F0, $E0, $00, $00, $60, $00
defb $00, $00, $00, $00, $00, $08, $0C, $07 ; PATTERN#20
defb $10, $30, $70, $60, $46, $06, $06, $00
defb $00, $00, $00, $00, $00, $10, $30, $E0
defb $08, $0C, $0E, $06, $62, $60, $00, $00

; 下方向#0
defb $00, $0F, $1F, $1F, $3C, $08, $00, $00 ; PATTERN#24
defb $0C, $0F, $0F, $07, $07, $00, $00, $06
defb $00, $F0, $F8, $98, $18, $00, $00, $00
defb $30, $F0, $F0, $E0, $E0, $00, $60, $00
defb $00, $00, $00, $00, $01, $05, $0F, $06 ; PATTERN#28
defb $13, $30, $70, $60, $40, $06, $06, $00
defb $00, $00, $00, $60, $A0, $B0, $F0, $60
defb $C8, $0C, $0E, $06, $00, $60, $00, $00
; 下方向#1
defb $07, $0F, $1F, $1C, $38, $00, $00, $00 ; PATTERN#32
defb $0F, $0F, $0F, $07, $00, $00, $00, $06
defb $E0, $F0, $98, $18, $18, $00, $00, $30
defb $F0, $F0, $F0, $E0, $00, $00, $00, $60
defb $00, $00, $00, $01, $05, $0F, $06, $03 ; PATTERN#36
defb $10, $30, $30, $30, $36, $06, $06, $00
defb $00, $00, $60, $A0, $A0, $F0, $60, $C0
defb $08, $0C, $0C, $0C, $6C, $60, $60, $00
; 下方向#2
defb $00, $0F, $1F, $1F, $3C, $08, $00, $00 ; PATTERN#40
defb $0C, $0F, $0F, $07, $07, $00, $06, $00
defb $00, $F0, $F8, $98, $18, $00, $00, $00
defb $30, $F0, $F0, $E0, $E0, $00, $00, $60
defb $00, $00, $00, $00, $01, $05, $0F, $06 ; PATTERN#44
defb $13, $30, $70, $60, $40, $06, $00, $00
defb $00, $00, $00, $60, $A0, $B0, $F0, $60
defb $C8, $0C, $0E, $06, $02, $60, $60, $00

; 右方向#0
defb $00, $0F, $1F, $1F, $3F, $1E, $00, $00 ; PATTERN#48
defb $0C, $0F, $0F, $07, $07, $00, $00, $38
defb $00, $F0, $F8, $F8, $D8, $00, $00, $00
defb $20, $E0, $00, $00, $C0, $00, $00, $38
defb $00, $00, $00, $00, $00, $01, $0F, $07 ; PATTERN#52
defb $13, $30, $70, $60, $40, $0E, $1C, $00
defb $00, $00, $00, $00, $20, $50, $50, $E0
defb $C0, $00, $F8, $F8, $00, $E0, $70, $00

; 右方向#1
defb $07, $0F, $1F, $1F, $3E, $18, $04, $00 ; PATTERN#56
defb $07, $04, $04, $03, $00, $00, $00, $01
defb $E0, $F0, $F8, $D8, $08, $00, $00, $00
defb $E0, $E0, $E0, $E0, $00, $00, $00, $C0
defb $00, $00, $00, $00, $01, $07, $03, $03 ; PATTERN#60
defb $00, $03, $03, $00, $01, $01, $01, $00
defb $00, $00, $00, $20, $50, $50, $E0, $A0
defb $00, $18, $18, $00, $C0, $C0, $C0, $00

; 右方向#2
defb $00, $0F, $1F, $1F, $3F, $1E, $00, $00 ; PATTERN#64
defb $1C, $1F, $1F, $07, $07, $00, $00, $38
defb $00, $F0, $F8, $F8, $D8, $00, $00, $00
defb $30, $F0, $F0, $E0, $C0, $00, $00, $38
defb $00, $00, $00, $00, $00, $01, $0F, $07 ; PATTERN#68
defb $03, $20, $60, $60, $40, $0E, $1C, $00
defb $00, $00, $00, $00, $20, $50, $50, $E0
defb $CE, $0E, $00, $00, $00, $E0, $70, $00

; 左方向#0
defb $00, $0F, $1F, $1F, $1D, $00, $00, $00 ; PATTERN#72
defb $04, $07, $00, $00, $03, $00, $00, $1C
defb $00, $F0, $F8, $F8, $FC, $38, $00, $00
defb $30, $F0, $F0, $E0, $E0, $00, $00, $1C
defb $00, $00, $00, $00, $02, $0A, $0A, $07 ; PATTERN#76
defb $03, $00, $1F, $1F, $00, $07, $0E, $00
defb $00, $00, $00, $00, $00, $C0, $F0, $E0
defb $C8, $0C, $0E, $06, $02, $70, $38, $00

; 左方向#1
defb $07, $0F, $1F, $1D, $00, $00, $00, $00 ; PATTERN#80
defb $07, $07, $07, $07, $00, $00, $00, $03
defb $E0, $F0, $F8, $F8, $3C, $38, $00, $20
defb $E0, $20, $20, $C0, $00, $00, $00, $80
defb $00, $00, $00, $02, $0A, $0A, $0F, $05 ; PATTERN#84
defb $00, $18, $18, $00, $03, $03, $03, $00
defb $00, $00, $00, $00, $C0, $C0, $E0, $C0
defb $00, $C0, $C0, $00, $80, $80, $80, $00

; 左方向#2
defb $00, $0F, $1F, $1F, $1D, $00, $00, $00 ; PATTERN#88
defb $0C, $0F, $0F, $07, $03, $00, $00, $1C
defb $00, $F0, $F8, $F8, $FC, $38, $00, $00
defb $38, $F8, $F8, $E0, $E0, $00, $00, $1C
defb $00, $00, $00, $00, $02, $0A, $0A, $07 ; PATTERN#92
defb $73, $70, $00, $00, $00, $07, $0E, $00
defb $00, $00, $00, $00, $00, $C0, $F0, $E0
defb $C0, $04, $06, $06, $02, $70, $38, $00

; 剣のスプライト定義

; 上方向、右方向　
defb $00, $00, $00, $00, $00, $00, $00, $00 ; PATERN#96
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $04, $06, $06, $06, $02, $06, $06, $0F
defb $06, $06, $06, $00, $00, $00, $00, $00

; 下方向、左方向
defb $20, $60, $60, $60, $40, $60, $60, $F0 ; PATTERN#100
defb $60, $60, $60, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00

; スライムのスプライト定義
defb $00, $00, $00, $00, $00, $00, $03, $0F ; PATTERN#104
defb $1F, $3F, $3F, $7F, $78, $70, $00, $00
defb $00, $00, $00, $00, $00, $00, $C0, $B0
defb $C8, $F4, $FC, $FE, $1E, $0E, $00, $00

defb $00, $00, $00, $00, $00, $00, $70, $78 ; PATTERN#108
defb $7F, $7F, $3F, $1F, $0F, $03, $00, $00
defb $00, $00, $00, $00, $00, $00, $0E, $1E
defb $FE, $FE, $FC, $F8, $F0, $C0, $00, $00

; ウイスプのスプライト定義
defb $00, $00, $00, $00, $01, $07, $0C, $1B ; PATTERN#112
defb $16, $2D, $2B, $2C, $17, $18, $0F, $00
defb $00, $08, $1C, $7C, $FC, $FC, $0C, $FC
defb $18, $E8, $68, $58, $D0, $30, $E0, $00

defb $00, $10, $38, $3E, $3F, $3F, $30, $3F ; PATTERN#116
defb $18, $17, $16, $1A, $0B, $0C, $07, $00
defb $00, $00, $00, $00, $80, $E0, $30, $D8
defb $68, $B4, $D4, $24, $C8, $10, $F0, $00

; ウイザードのスプライト定義
; ウイザードは2枚で1キャラ

; 上方向
defb $00, $07, $0F, $0F, $0F, $1F, $1F, $0F ; PATTERN#120
defb $17, $1B, $1C, $1F, $1F, $1F, $1F, $00
defb $00, $E0, $F0, $F0, $F2, $FA, $FA, $F2
defb $E8, $D8, $3A, $FA, $FA, $FA, $FA, $00
defb $00, $00, $00, $00, $00, $00, $00, $10 ; PATTERN#124
defb $68, $64, $23, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $08
defb $16, $26, $C4, $00, $00, $00, $00, $00

; 下方向
defb $00, $07, $0F, $0F, $4E, $5C, $58, $5C ; PATTERN#128
defb $07, $07, $47, $5F, $5F, $5F, $51, $00
defb $00, $E0, $F0, $F0, $70, $38, $18, $38
defb $E0, $E0, $E0, $F8, $F8, $F8, $88, $00
defb $00, $00, $00, $00, $01, $03, $07, $02 ; PATTERN#132
defb $78, $78, $38, $00, $00, $00, $0E, $00
defb $00, $00, $00, $00, $80, $C0, $E0, $40
defb $1E, $1E, $1C, $00, $00, $00, $70, $00

; 左方向
defb $00, $0F, $1F, $1F, $1F, $9F, $87, $40 ; PATTERN#136
defb $1F, $1F, $1F, $27, $23, $13, $10, $00
defb $00, $E0, $F0, $F0, $F0, $F0, $F8, $F8
defb $78, $9C, $FC, $FC, $FC, $FC, $3E, $00
defb $00, $00, $00, $00, $00, $00, $08, $0F ; PATTERN#140
defb $60, $60, $60, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $80, $60, $00, $00, $00, $00, $C0, $00

; 右方向
defb $00, $07, $0F, $0F, $0F, $0F, $1F, $1F ; PATTERN#144
defb $1E, $39, $3F, $3F, $3F, $3F, $7C, $00
defb $00, $F0, $F8, $F8, $F8, $F9, $E1, $02
defb $F8, $F8, $F8, $E4, $C4, $C8, $08, $00
defb $00, $00, $00, $00, $00, $00, $00, $00 ; PATTERN#148
defb $01, $06, $00, $00, $00, $00, $03, $00
defb $00, $00, $00, $00, $00, $00, $10, $F0
defb $06, $06, $06, $00, $00, $00, $80, $00

; ファイアボール（Magic Missile）

; 上方向
defb $00, $17, $10, $0B, $08, $0B, $08, $05 ; PATTERN#152
defb $04, $05, $05, $02, $03, $03, $01, $00
defb $00, $E8, $08, $D0, $10, $D0, $10, $A0
defb $20, $A0, $20, $40, $40, $40, $80, $00

; 下方向
defb $00, $01, $02, $02, $02, $04, $05, $04 ; PATTERN#156
defb $05, $08, $0B, $08, $0B, $10, $17, $00
defb $00, $80, $40, $40, $40, $20, $A0, $20
defb $A0, $10, $D0, $10, $D0, $08, $E8, $00

; 左方向
defb $00, $00, $00, $60, $1E, $41, $54, $55 ; PATTERN#160
defb $55, $54, $41, $1E, $60, $00, $00, $00
defb $00, $00, $00, $00, $00, $E0, $1C, $42
defb $42, $1C, $E0, $00, $00, $00, $00, $00

; 右方向
defb $00, $00, $00, $00, $00, $07, $38, $42 ; PATTERN#164
defb $42, $38, $07, $00, $00, $00, $00, $00
defb $00, $00, $00, $06, $78, $82, $2A, $AA
defb $AA, $2A, $82, $78, $06, $00, $00, $00

; 剣（攻撃時）のスプライト定義

; 上方向
defb $01, $03, $03, $07, $07, $07, $07, $07 ; PATTERN#168
defb $06, $05, $05, $03, $06, $05, $03, $04
defb $80, $C0, $C0, $E0, $E0, $E0, $E0, $E0
defb $60, $A0, $A0, $C0, $60, $A0, $C0, $20

; 下方向
defb $04, $03, $05, $06, $03, $05, $05, $06 ; PATTERN$172
defb $07, $07, $07, $07, $07, $03, $03, $01
defb $20, $C0, $A0, $60, $C0, $A0, $A0, $60
defb $E0, $E0, $E0, $E0, $E0, $C0, $C0, $80

; 右方向
defb $00, $00, $00, $00, $00, $B7, $59, $6E ; PATTERN#176
defb $6E, $59, $B7, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $F8, $FE, $FF
defb $FF, $FE, $F8, $00, $00, $00, $00, $00

; 左方向
defb $00, $00, $00, $00, $00, $1F, $7F, $FF ; PATTERN#180
defb $FF, $7F, $1F, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $ED, $9A, $76
defb $76, $9A, $ED, $00, $00, $00, $00, $00

; テキキャラ消失時のスプライト定義
defb $81, $41, $21, $11, $00, $00, $00, $F0 ; PATTERN#184
defb $00, $00, $00, $11, $21, $41, $81, $00
defb $02, $04, $08, $10, $00, $00, $00, $1E
defb $00, $00, $00, $10, $08, $04, $02, $00

; Woody Monsterのスプライト定義
; 1枚目
defb $1F, $3F, $7F, $E7, $E1, $F1, $FF, $FF ; PATTERN#188
defb $FF, $EF, $5F, $1F, $00, $00, $00, $00
defb $F8, $FC, $FE, $E7, $87, $8F, $FF, $FF
defb $FF, $F7, $FA, $F8, $00, $00, $00, $00

; 2枚目
defb $00, $00, $00, $18, $1E, $0E, $00, $00 ; PATTERN#192
defb $00, $10, $20, $20, $47, $A3, $07, $0F
defb $00, $00, $00, $18, $78, $70, $00, $00
defb $00, $08, $04, $04, $E2, $C5, $E0, $F0

; SKELTONのスプライト定義

; 下方向#0
defb $00, $00, $07, $4C, $4C, $48, $49, $4F ; PATTERN#196
defb $E5, $48, $5F, $50, $07, $00, $07, $07
defb $00, $00, $F0, $98, $98, $88, $C8, $F8
defb $50, $88, $7C, $04, $70, $00, $70, $70

; 下方向#1
defb $00, $07, $08, $13, $13, $17, $16, $10 ; PATTERN#200
defb $0A, $17, $20, $2F, $38, $07, $00, $00
defb $00, $F0, $08, $64, $64, $74, $34, $04
defb $A8, $74, $82, $FA, $8E, $F0, $00, $00

; 上方向#0
defb $00, $00, $0F, $1F, $1F, $1F, $1F, $1F ; PATTERN#204
defb $0F, $11, $3E, $20, $0E, $00, $0E, $0E
defb $00, $00, $E0, $F2, $F2, $F2, $F2, $F2
defb $E7, $12, $FA, $0A, $E0, $00, $E0, $E0

; 上方向#1
defb $00, $0F, $10, $20, $20, $20, $20, $20 ; PATTERN#208
defb $10, $2E, $41, $5F, $71, $0F, $00, $00
defb $00, $E0, $10, $08, $08, $08, $08, $08
defb $10, $E8, $04, $F4, $1C, $E0, $00, $00

; 左方向#0
defb $00, $00, $07, $49, $49, $48, $44, $47 ; PATTERN#212
defb $45, $C8, $5D, $40, $05, $00, $0E, $0E
defb $00, $00, $F0, $F8, $F8, $F8, $F8, $F0
defb $60, $00, $F8, $6C, $EC, $00, $70, $70

; 左方向#1
defb $00, $07, $08, $16, $16, $17, $0B, $08 ; PATTERN#216
defb $0A, $37, $22, $3F, $0A, $07, $00, $00
defb $00, $F0, $08, $04, $04, $04, $04, $08
defb $90, $F8, $04, $92, $12, $FC, $00, $00

; 右方向#0
defb $00, $00, $0F, $1F, $1F, $1F, $1F, $0F ; PATTERN#220
defb $06, $00, $1F, $36, $37, $00, $0E, $0E
defb $00, $00, $E0, $92, $92, $12, $22, $E2
defb $A2, $13, $BA, $02, $A0, $00, $70, $70

; 右方向#1
defb $00, $0F, $10, $20, $20, $20, $20, $10 ; PATTERN#224
defb $09, $1F, $20, $49, $48, $3F, $00, $00
defb $00, $E0, $10, $68, $68, $E8, $D0, $10
defb $50, $EC, $44, $FC, $50, $E0, $00, $00

defb $00 ; End of SPRITE DATA

; プレイヤースプライトの向きにあわせたジャンプ先
; player.asm で使用
MOVECONDITION_PROC:
defw CheckMoveConditionNG ; 0
defw CheckMoveUp          ; 1
defw CheckMoveConditionNG ; 2
defw CheckMoveRight       ; 3
defw CheckMoveConditionNG ; 4
defw CheckMoveDown        ; 5
defw CheckMoveConditionNG ; 6
defw CheckMoveLeft        ; 7
defw CheckMoveConditionNG ; 6

; スプライトの向きにあわせたパターン番号
; パターン番号は指定した番号から連続して8個使用する
; カラーはここでは定義しない

; キーインなし
SPRDISTPTN_NOP:
defb 32 ; パターン番号

SPRDISTPTN_UP:
; 上#0
defb  0 ; パターン番号

SPRDISTPRN_UPRIGHT:
defb  0 ; （未使用）

SPRDISTPTN_RIGHT:
defb 48 ; パターン番号

SPRDISTPTN_DOWNRIGHT:
defb  0 ; （未使用）

SPRDISTPTN_DOWN:
; 下#0
defb 24 ; パターン番号

SPRDISTPTN_DOWNLEFT:
defb  0 ; （未使用）

SPRDISTPTN_LEFT:
; 左#0
defb  72 ; パターン番号

SPRDISTPTN_UPLEFT:
defb   0 ; （未使用）

; 剣：0方向
SWORDDISTPTN_NOP:
defb   0 ; パターン番号

; 剣：上方向
SWORDDISTPTN_UP:
defb  96 ; パターン番号

; 剣：右上方向
defb  00 ; （未使用）

; 剣：右方向
SWORDDISTPTN_RIGHT:
defb  96 ; パターン番号

; 剣：右下方向
SWORDDISTPTN_DOWNRIGHT:
defb  00 ; （未使用）

; 剣：下方向
SWORDDISTPTN_DOWN:
defb 100 ; パターン番号

; 剣：左下方向
SWORDDISTPTN_DOWNLEFT:
defb  00 ; （未使用）

; 剣：左方向
SWORDDISTPTN_LEFT:
defb 100 ; パターン番号

; 剣：左上方向
SWORDDISTPTN_UPLEFT:
defb  00 ; （未使用）

; 剣（攻撃時）：0方向
SWORDATTACKDISTPTN_NOP:
defb   0 ; パターン番号

; 剣（攻撃時）：上方向
SWORDATTACKDISTPTN_UP:
defb 168 ; パターン番号

; 剣（攻撃時）：右上方向
defb  00 ; （未使用）

; 剣（攻撃時）：右方向
SWORDATTACKDISTPTN_RIGHT:
defb 176 ; パターン番号

; 剣（攻撃時）：右下方向
SWORDATTACKDISTPTN_DOWNRIGHT:
defb  00 ; （未使用）

; 剣（攻撃時）：下方向
SWORDATTACKDISTPTN_DOWN:
defb 172 ; パターン番号

; 剣（攻撃時）：左下方向
SWORDATTACKDISTPTN_DOWNLEFT:
defb  00 ; （未使用）

; 剣（攻撃時）（攻撃時）：左方向
SWORDATTACKDISTPTN_LEFT:
defb 180 ; パターン番号

; 剣（攻撃時）：左上方向
SWORDATTACKDISTPTN_UPLEFT:
defb  00 ; （未使用）

; スプライトの移動量を格納したテーブル
; 1バイト内の上位4ビットがX方向の移動量
; 1バイト内の下位4ビットがY方向の移動量
; 移動量が2の場合は-1として処理する
SPRITEMOVE_TBL:
defb $00 ; ジョイスティック方向0
defb $02 ; ジョイスティック方向1(X= 0, Y=-1)
defb $00 ; ジョイスティック方向2(X= 1, Y=-1)
defb $10 ; ジョイスティック方向3(X= 1, Y= 0)
defb $00 ; ジョイスティック方向4(X= 1, Y= 1)
defb $01 ; ジョイスティック方向5(X= 0, Y= 1)
defb $00 ; ジョイスティック方向6(X=-1, Y= 1)
defb $20 ; ジョイスティック方向7(X=-1, Y= 0)
defb $00 ; ジョイスティック方向8(X=-1, Y=-1)

; テキのスプライトパターン番号
ENEMY_PTN:
defw $0000, ENEMY_PTN_SLIME, ENEMY_PTN_WISP, ENEMY_PTN_WIZ, ENEMY_PTN_WOODY, ENEMY_PTN_SKELTON, ENEMY_PTN_MAGE

ENEMY_PTN_SLIME:
defb 104

ENEMY_PTN_WISP:
defb 112

ENEMY_PTN_WIZ:
; +0:none +1:UP +2:none +3:RIGHT +4:none +5:DOWN +6:none +7:LEFT +8:none
defb 0, 120, 0, 144, 0, 128, 0, 136, 0

ENEMY_PTN_WOODY:
defb 188

ENEMY_PTN_SKELTON:
; +0:none +1:UP +2:none +3:RIGHT +4:none +5:DOWN +6:none +7:LEFT +8:none
defb 0, 204, 0, 220, 0, 196, 0, 212, 0

ENEMY_PTN_MAGE:

ENEMY_PTN_FIREBALL:
; +0:none +1:UP +2:none +3:RIGHT +4:none +5:DOWN +6:none +7:LEFT +8:none
defb 0, 152, 0, 164, 0, 156, 0, 160, 0

FIREBALL_MOVESIZE_SLIME:
; スライムのファイアボールの移動量
defb 0, 0, 0, 10, 14

FIREBALL_MOVESIZE_WIZARD:
; ウイザードのファイアボールの移動量
defb 0, 10, 10, 14, 18, 20

ENEMY_COLOR:
defw $0000, ENEMY_COL_SLIME, ENEMY_COL_WISP, ENEMY_COL_WIZ, ENEMY_COL_WOODY, ENEMY_COL_SKELTON, ENEMY_COL_MAGE

ENEMY_COL_SLIME:
; 水色、薄青、濃赤、白(透視のリング保持であれば白表示)
defb $07, $05, $06, $00

ENEMY_COL_WISP:
; 黄、赤、濃赤、白(透視のリング保持であれば白表示)
defb $0A, $09, $06, $00

ENEMY_COL_WIZ:
; 水色、薄青、濃赤、白(透視のリング保持であれば白表示), 薄緑（ラスボス）
defb $07, $05, $06, $00, $03

ENEMY_COL_WOODY:
; 緑色、黄緑色、濃赤、白(透視のリング保持であれば白表示)
; 2枚目は常に$0A
defb $0C, $03, $06, $00

ENEMY_COL_SKELTON:
; 水色、薄青、濃赤、白(透視のリング保持であれば白表示)
defb $07, $05, $06, $00

ENEMY_COL_MAGE:
defb 0 ; （残念だけど未使用）

;------------------------------
; テキキャラのステータスデータ
;------------------------------
ENEMY_STATUS_ENEMYTYPE:
defw $0000
defw ENEMY_STATUS_SLIME
defw ENEMY_STATUS_WISP
defw ENEMY_STATUS_WIZ
defw ENEMY_STATUS_WOODY
defw ENEMY_STATUS_SKELTON

ENEMY_STATUS_SLIME:
defw $0000 
defw ENEMY_STATUS_SLIME_LV1, ENEMY_STATUS_SLIME_LV2
defw ENEMY_STATUS_SLIME_LV3, ENEMY_STATUS_SLIME_LV4 

ENEMY_STATUS_SLIME_LV1:
defb 1    ; STR
defb 1    ; DEF
defb 7    ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_SLIME_LV2:
defb 2    ; STR
defb 1    ; DEF
defb 14   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_SLIME_LV3:
defb 2    ; STR
defb 2    ; DEF
defb 14   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_SLIME_LV4:
defb 3    ; STR
defb 2    ; DEF
defb 21   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WISP:
defw $0000 
defw ENEMY_STATUS_WISP_LV1, ENEMY_STATUS_WISP_LV2
defw ENEMY_STATUS_WISP_LV3, ENEMY_STATUS_WISP_LV4 

ENEMY_STATUS_WISP_LV1:
defb 2    ; STR
defb 1    ; DEF
defb 7    ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WISP_LV2:
defb 4    ; STR
defb 1    ; DEF
defb 14   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WISP_LV3:
defb 6    ; STR
defb 2    ; DEF
defb 14   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WISP_LV4:
defb 7    ; STR
defb 2    ; DEF
defb 28   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WIZ:
defw $0000 
defw ENEMY_STATUS_WIZ_LV1, ENEMY_STATUS_WIZ_LV2
defw ENEMY_STATUS_WIZ_LV3, ENEMY_STATUS_WIZ_LV4 
defw ENEMY_STATUS_WIZ_LV5

ENEMY_STATUS_WIZ_LV1:
defb 3    ; STR
defb 3    ; DEF
defb 14   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WIZ_LV2:
defb 4    ; STR
defb 4    ; DEF
defb 21   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WIZ_LV3:
defb 4    ; STR
defb 4    ; DEF
defb 28   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WIZ_LV4:
defb 5    ; STR
defb 4    ; DEF
defb 35   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WIZ_LV5:
defb 7    ; STR
defb 6    ; DEF
defb 35   ; LIFE
defb 128  ; アイテムドロップ率(128/256)

ENEMY_STATUS_WOODY:
defw $0000 
defw ENEMY_STATUS_WOODY_LV1, ENEMY_STATUS_WOODY_LV2
defw ENEMY_STATUS_WOODY_LV3, ENEMY_STATUS_WOODY_LV4 

ENEMY_STATUS_WOODY_LV1:
defb 3    ; STR
defb 3    ; DEF
defb 28  ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_WOODY_LV2:
defb 4    ; STR
defb 4    ; DEF
defb 28   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_WOODY_LV3:
defb 4    ; STR
defb 4    ; DEF
defb 35   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_WOODY_LV4:
defb 5    ; STR
defb 4    ; DEF
defb 35   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_SKELTON:
defw $0000 
defw ENEMY_STATUS_SKELTON_LV1, ENEMY_STATUS_SKELTON_LV2
defw ENEMY_STATUS_SKELTON_LV3, ENEMY_STATUS_SKELTON_LV4 

ENEMY_STATUS_SKELTON_LV1:
defb 3    ; STR
defb 3    ; DEF
defb 21   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_SKELTON_LV2:
defb 4    ; STR
defb 4    ; DEF
defb 21   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_SKELTON_LV3:
defb 5    ; STR
defb 5    ; DEF
defb 28   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

ENEMY_STATUS_SKELTON_LV4:
defb 6    ; STR
defb 6    ; DEF
defb 35   ; LIFE
defb 64   ; アイテムドロップ率(64/256)

; テキのサブルーチンアドレス
; +0:none +2:スライム +4:ウイスプ +6:ウイザード +8:WOODY MONSTER 
; +10:スケルトン +20:ファイアボール
ENEMY_MOVEPROC:
defw $0000             ;
defw MoveEnemySlime    ; 種別コード=1
defw MoveEnemyWisp     ; 種別コード=2
defw MoveEnemyWizard   ; 種別コード=3
defw MoveEnemyWoody    ; 種別コード=4
defw MoveEnemySkelton  ; 種別コード=5
defw $0000             ; 種別コード=6
defw $0000             ; 種別コード=7
defw $0000             ; 種別コード=8
defw $0000             ; 種別コード=9
defw MoveMagicMissile  ; 種別コード=10
