;--------------------------------------------
; data_sprite.asm
; 固定データ(スプライト作成用)
;--------------------------------------------
; キャラクタパターン
SPRPTN:

; PLAYTER
; データサイズは1方向あたり64バイト

; 上方向
defb $1F, $1F, $3F, $3F, $3F, $3F, $3F, $1F ; PATTERN#0
defb $07, $20, $20, $20, $00, $00, $0E, $0E ; PATTERN#1
defb $F8, $F8, $FC, $FC, $FC, $FC, $FC, $F8 ; PATTERN#2
defb $E0, $04, $04, $04, $00, $00, $70, $70 ; PATTERN#3
defb $00, $00, $00, $00, $00, $00, $00, $00 ; PATTERN#4
defb $10, $18, $1F, $1F, $1F, $0F, $00, $00 ; PATTERN#5
defb $00, $00, $00, $00, $00, $00, $00, $00 ; PATTERN#6
defb $08, $18, $F8, $F8, $F8, $F0, $00, $00 ; PATTERN#7
; 右方向
defb $1F, $1F, $3F, $3F, $3E, $2E, $28, $10 ; PATTERN#8
defb $00, $38, $38, $38, $00, $00, $1C, $1C ; PATTERN#9
defb $F0, $F8, $D8, $80, $00, $00, $00, $00 ; PATTERN#10
defb $00, $00, $00, $00, $00, $04, $7C, $7C ; PATTERN#11
defb $00, $00, $00, $00, $01, $11, $17, $0F ; PATTERN#12
defb $1F, $07, $07, $07, $1F, $0F, $00, $00 ; PATTERN#13
defb $00, $00, $20, $78, $A8, $A8, $A8, $F0 ; PATTERN#14
defb $08, $F8, $D8, $F8, $D8, $F0, $00, $00 ; PATTERN#15
; 下方向
defb $1F, $1F, $3E, $3C, $38, $30, $30, $10 ; PATTERN#16
defb $00, $00, $00, $20, $20, $00, $1E, $1E ; PATTERN#17
defb $F8, $F8, $7C, $3C, $1C, $0C, $0C, $08 ; PATTERN#18
defb $00, $00, $00, $04, $04, $00, $78, $78 ; PATTERN#19
defb $00, $00, $01, $03, $05, $0D, $0D, $0F ; PATTERN#20
defb $07, $08, $1F, $1E, $1F, $1E, $01, $00 ; PATTERN#21
defb $00, $00, $80, $C0, $A0, $B0, $B0, $F0 ; PATTERN#22
defb $E0, $10, $F8, $78, $F8, $78, $80, $00 ; PATTERN#23
; 左方向
defb $0F, $1F, $1B, $01, $00, $00, $00, $00 ; PATTERN#24
defb $00, $00, $00, $00, $00, $20, $3E, $1E ; PATTERN#25
defb $F8, $F8, $FC, $FC, $7C, $74, $14, $08 ; PATTERN#26
defb $00, $1C, $1C, $1C, $00, $00, $38, $38 ; PATTERN#27
defb $00, $00, $04, $1E, $15, $15, $15, $0F ; PATTERN#28
defb $10, $1F, $1B, $1F, $1B, $0F, $00, $00 ; PATTERN#29
defb $00, $00, $00, $00, $80, $88, $E8, $F0 ; PATTERN#30
defb $F8, $E0, $E0, $E0, $F8, $F0, $00, $00 ; PATTERN#31

; スプライトの向きにあわせたパターン番号
; パターン番号は指定した番号から連続して8個使用する
; カラーはここでは定義しない
SPRDISTPTN_TBL:
; 上
defb  0 ; パターン番号
; 右
defb  8 ; パターン番号
; 下
defb 16 ; パターン番号
; 左
defb 24 ; パターン番号