;--------------------------------------------
; data_map.asm
; 固定データ(マップ作成用)
;--------------------------------------------
;
; 4bitで1タイル
;
; オーバーワールドのMAPは横6(00-05) x 縦6(00-05)で構成される
; アンダーワールドのMAPは横3(06-08) x 縦3(00-02)で構成される
; MAPにはIDが付与される(例：横0、縦0のマップであれば0000)
; 特別なMAPIDとして横00,縦06をつける。これは敵の棲家やボス戦で使う
;

;----------------------------------------------------------
; ここから下はマップタイルデータ
; タイル番号とキャラクタコードのマッピングデータ
;----------------------------------------------------------

; MAPデータアドレス情報

MAP_DATAWORLD:

defw MAP_DATA0000 ; X=0, Y=0
defw MAP_DATA0100 ; X=1, Y=0
defw MAP_DATA0200 ; X=2, Y=0
defw MAP_DATA0300 ; X=3, Y=0
defw MAP_DATA0400 ; X=4, Y=0
defw MAP_DATA0500 ; X=5, Y=0

defw MAP_DATA0001 ; X=0, Y=1
defw MAP_DATA0101 ; X=1, Y=1
defw MAP_DATA0201 ; X=2, Y=1
defw MAP_DATA0301 ; X=3, Y=1
defw MAP_DATA0401 ; X=4, Y=1
defw MAP_DATA0501 ; X=5, Y=1

defw MAP_DATA0002 ; X=0, Y=2
defw MAP_DATA0102 ; X=1, Y=2
defw MAP_DATA0202 ; X=2, Y=2
defw MAP_DATA0302 ; X=3, Y=2
defw MAP_DATA0402 ; X=4, Y=2
defw MAP_DATA0502 ; X=5, Y=2

defw MAP_DATA0003 ; X=0, Y=3
defw MAP_DATA0103 ; X=1, Y=3
defw MAP_DATA0203 ; X=2, Y=3
defw MAP_DATA0303 ; X=3, Y=3
defw MAP_DATA0403 ; X=4, Y=3
defw MAP_DATA0503 ; X=5, Y=3

defw MAP_DATA0004 ; X=0, Y=4
defw MAP_DATA0104 ; X=1, Y=4
defw MAP_DATA0204 ; X=2, Y=4
defw MAP_DATA0304 ; X=3, Y=4
defw MAP_DATA0404 ; X=4, Y=4
defw MAP_DATA0504 ; X=5, Y=4

defw MAP_DATA0005 ; X=0, Y=5
defw MAP_DATA0105 ; X=1, Y=5
defw MAP_DATA0205 ; X=2, Y=5
defw MAP_DATA0305 ; X=3, Y=5
defw MAP_DATA0405 ; X=4, Y=5
defw MAP_DATA0505 ; X=5, Y=5

; MAPデータ

;----------------------------------------------------------
MAP_DATA0000: ; X=0 : Y=0
;----------------------------------------------------------

; MAP TYPE
defb $01

; PITデータ
defw PIT_DATA0000  ; PITのMAPアドレス

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb $00           ; PITに出た場所のMAPY座標
defb $00           ; PITに出た場所のMAPY座標
defb  5 * 8        ; PITから出た場所のX座標
defb 17 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $11 ; slime LV=1
defb 15, 15
defb $11 ; slime LV=1
defb 13,  7
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 60 ; BYTES
; COMPRESSION DATAS
defb $F1, $11, $E0, $11, $30, $21, $10, $11, $40, $41, $20, $31, $10, $41, $10, $11, $20, $11, $20, $11, $30, $11, $40, $11, $10, $21, $60, $21, $30, $11, $10, $51, $60, $31, $20, $21, $15, $11, $20, $11, $40, $21, $20, $21, $10, $41, $10, $11, $20, $21, $20, $21, $10, $11, $40, $11, $30, $11, $10, $11

;----------------------------------------------------------
MAP_DATA0100: ; X=1 : Y=0
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw PIT_DATA0100

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb $00           ; PITに出た場所のMAPY座標
defb $00           ; PITに出た場所のMAPY座標
defb 25 * 8        ; PITから出た場所のX座標
defb 13 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $13 ; slime LV=3
defb 13,  5 ; X,Yともにランダム（上位1バイトがY、下位がX）
defb $13 ; slime LV=3
defb  9, 21 ; X,Yともにランダム（上位1バイトがY、下位がX）
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 56 ; BYTES
; COMPRESSION DATAS
defb $F1, $10, $11, $90, $11, $27, $31, $20, $51, $20, $11, $27, $11, $B0, $21, $27, $11, $60, $51, $20, $17, $11, $20, $31, $10, $11, $30, $11, $15, $11, $17, $20, $11, $40, $11, $10, $11, $10, $31, $17, $20, $11, $10, $21, $10, $11, $60, $11, $10, $11, $A0, $11, $10, $E1, $10, $11

;----------------------------------------------------------
MAP_DATA0200: ; X=2 : Y=0
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw $FFFF

; ENEMY DATA
defb $53 ; Skelton LV=3
defb  7,  5
defb $53 ; Skelton LV=3
defb  9,  7
defb $53 ; Skelton LV=3
defb  5, 21
defb $34 ; Wizard LV=4
defb 15, 15
defb $00

; TILE DATA
; DATA LENGTH
defb 59 ; BYTES
; COMPRESSION DATAS
defb $11, $EA, $11, $1A, $C0, $1A, $11, $1A, $20, $6A, $50, $17, $1A, $90, $2A, $20, $27, $1A, $40, $8A, $37, $1A, $40, $1A, $60, $37, $1A, $40, $1A, $30, $3A, $11, $37, $1A, $30, $1A, $20, $1A, $30, $11, $10, $37, $1A, $20, $1A, $20, $1A, $30, $11, $10, $11, $27, $1A, $20, $2A, $10, $1A, $20, $1A

;----------------------------------------------------------
MAP_DATA0300: ; X=3 : Y=0
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw $FFFF

; ENEMY DATA
defb $53     ; Skelton LV=3
defb  7, 5
defb $53     ; Skelton LV=3
defb 13, 25
defb $23     ; Wisp LV=3
defb $80, $80
defb $23     ; Wisp LV=3
defb $80, $80

defb $00

; TILE DATA
; DATA LENGTH
defb 46 ; BYTES
; COMPRESSION DATAS
defb $FA, $1A, $40, $1A, $60, $1A, $70, $2A, $30, $5A, $20, $2A, $30, $2A, $10, $2A, $30, $5A, $30, $1A, $10, $2A, $80, $1A, $20, $1A, $40, $1A, $10, $3A, $20, $1A, $20, $1A, $10, $4A, $40, $1A, $10, $1A, $20, $3A, $90, $1A, $90, $FA

;----------------------------------------------------------
MAP_DATA0400: ; X=4 : Y=0
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0400

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb 7 * 8         ; PITから出た場所のX座標
defb 9 * 8         ; PITから出た場所のY座標

; ENEMY DATA
defb $53           ; Skelton LV=3
defb  9,  1
defb $53           ; Skelton LV=3
defb  5, 21
defb $23           ; Wisp LV=3
defb $80, $80
defb $23           ; Wisp LV=3
defb $80, $80

defb $00

; TILE DATA
; DATA LENGTH
defb 70 ; BYTES
; COMPRESSION DATAS
defb $FA, $60, $1A, $80, $5A, $10, $1A, $10, $7A, $30, $15, $1A, $10, $1A, $10, $1A, $70, $4A, $10, $1A, $10, $1A, $10, $5A, $10, $1A, $40, $1A, $30, $1A, $50, $1A, $10, $6A, $10, $1A, $10, $3A, $10, $1A, $40, $1A, $10, $1A, $10, $1A, $10, $2A, $20, $4A, $10, $1A, $10, $1A, $10, $1A, $10, $1A, $20, $1A, $30, $1A, $10, $1A, $30, $1A, $10, $1A, $10, $1A

;----------------------------------------------------------
MAP_DATA0500: ; X=5 : Y=0
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0500

defb 00
defb 00
defb 00
defb 00
defb 13 * 8
defb 19 * 8

; ENEMY DATA
defb $43       ; Skelton LV=3
defb  5,  5
defb $43       ; Skelton LV=3
defb 11, 27
defb $23       ; Wisp LV=3
defb $80, $80
defb $23       ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 65 ; BYTES
; COMPRESSION DATAS
defb $FA, $60, $1A, $70, $2A, $60, $1A, $20, $1A, $30, $1A, $10, $2A, $40, $1A, $20, $1A, $30, $4A, $10, $2A, $20, $1A, $10, $1A, $30, $1A, $40, $3A, $10, $1A, $15, $1A, $20, $3A, $10, $2A, $20, $1A, $10, $3A, $20, $2A, $10, $2A, $30, $1A, $30, $1A, $20, $2A, $20, $1A, $10, $1A, $20, $2A, $50, $2A, $30, $2A, $30, $2A, $30, $1A

;----------------------------------------------------------
MAP_DATA0001: ; X=0 : Y=1
;----------------------------------------------------------

; MAP TYPE
defb $01

; PITデータ
defw $FFFF

; ENEMY DATA
defb $11 ; slime LV=1
defb  5,  9
defb $11 ; slime LV=1
defb  7, 27
defb $11 ; slime LV=1
defb  9,  3
defb $11 ; slime LV=1
defb 19, 23
defb $00

; TILE DATA
; DATA LENGTH
defb 61 ; BYTES
; COMPRESSION DATAS
defb $21, $10, $11, $40, $11, $30, $11, $10, $21, $20, $11, $20, $11, $40, $21, $10, $21, $20, $11, $20, $21, $20, $21, $20, $21, $10, $11, $20, $71, $30, $11, $10, $11, $20, $31, $60, $21, $10, $11, $60, $11, $40, $21, $A0, $51, $30, $11, $10, $61, $20, $41, $30, $11, $70, $21, $50, $11, $10, $41, $20, $11

;----------------------------------------------------------
MAP_DATA0101: ; X=1 : Y=1
;----------------------------------------------------------

; MAP TYPE
defb $01

; PITデータ
defw $FFFF

; ENEMY DATA
defb $13 ; slime LV=3
defb  7,  5
defb $13 ; slime LV=3
defb  9, 27
defb $00

; TILE DATA
; DATA LENGTH
defb 53 ; BYTES
; COMPRESSION DATAS
defb $D1, $10, $21, $80, $11, $40, $21, $20, $41, $40, $11, $20, $11, $10, $11, $60, $11, $50, $21, $40, $11, $60, $11, $10, $21, $10, $21, $20, $11, $20, $11, $20, $11, $10, $21, $10, $21, $80, $11, $10, $21, $20, $11, $10, $11, $20, $51, $10, $21, $D0, $21, $10, $D1

;----------------------------------------------------------
MAP_DATA0201: ; X=2 : Y=1
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0201

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb 3 * 8         ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33           ; Wizard LV=3
defb  5,  3
defb $43           ; WOODY LV=3
defb 11, 27
defb $43           ; WOODY LV=3
defb 17, 19
defb $23           ; Wisp LV=3
defb $80, $80
defb 0

; TILE DATA
; DATA LENGTH
defb 90 ; BYTES
; COMPRESSION DATAS
defb $11, $10, $11, $27, $1A, $20, $2A, $10, $1A, $20, $1A, $11, $10, $11, $27, $1A, $30, $1A, $10, $1A, $20, $1A, $11, $10, $11, $27, $3A, $10, $1A, $10, $1A, $20, $1A, $11, $10, $11, $27, $1A, $50, $1A, $20, $1A, $11, $10, $11, $27, $1A, $10, $4A, $30, $1A, $11, $10, $11, $27, $1A, $10, $1A, $60, $1A, $11, $10, $11, $27, $3A, $30, $4A, $31, $57, $1A, $20, $1A, $20, $1A, $11, $15, $21, $57, $1A, $10, $1A, $10, $2A, $11, $30, $21, $37, $1A, $40, $1A

;----------------------------------------------------------
MAP_DATA0301: ; X=3 : Y=1
;----------------------------------------------------------

; MAP TYPE
defb $06

; PITデータ
defw PIT_DATA0301

defb 0
defb 0
defb 0
defb 0
defb 19 * 8
defb 17 * 8

; ENEMY DATA
defb $34      ; Wizard LV=4
defb  5,  3
defb $34      ; Wizard LV=4
defb 11,  7
defb $34      ; Wizard LV=4
defb 15, 23
defb $34      ; Wizard LV=4
defb 17, 11
defb $00

; TILE DATA
; DATA LENGTH
defb 45 ; BYTES
; COMPRESSION DATAS
defb $F6, $16, $D0, $26, $10, $16, $B0, $26, $10, $A6, $20, $26, $10, $16, $B0, $26, $10, $16, $10, $C6, $10, $16, $B0, $26, $10, $16, $50, $36, $30, $26, $10, $16, $20, $36, $15, $10, $36, $10, $26, $10, $36, $60, $16, $20, $16

;----------------------------------------------------------
MAP_DATA0401: ; X=4 : Y=1
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw $FFFF

; ENEMY DATA
defb $33      ; Wizard LV=3
defb  7, 11
defb $33      ; Wizard LV=3
defb 19, 27
defb $33      ; Wizard LV=3
defb 13,  9
defb $23      ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 61 ; BYTES
; COMPRESSION DATAS
defb $1A, $30, $1A, $10, $1A, $30, $1A, $10, $1A, $10, $2A, $30, $1A, $10, $5A, $10, $1A, $20, $1A, $10, $3A, $70, $4A, $A0, $1A, $20, $2A, $20, $AA, $10, $4A, $B0, $2A, $30, $9A, $10, $2A, $10, $4A, $50, $2A, $10, $2A, $40, $1A, $10, $3A, $10, $1A, $30, $1A, $10, $2A, $10, $1A, $30, $1A, $10, $1A, $10, $2A

;----------------------------------------------------------
MAP_DATA0501: ; X=5 : Y=1
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw $FFFF

; ENEMY DATA
defb $53     ; Skelton LV=3
defb 13,  9
defb $53     ; Skeltom LV=3
defb  5, 23
defb $43     ; WOODY LV=3
defb 17, 7
defb $14     ; Slime LV=4
defb 21, 27
defb $00

; TILE DATA
; DATA LENGTH
defb 73 ; BYTES
; COMPRESSION DATAS
defb $1A, $30, $2A, $30, $2A, $30, $1A, $20, $3A, $40, $2A, $10, $1A, $10, $2A, $30, $1A, $10, $5A, $10, $1A, $10, $2A, $30, $1A, $70, $1A, $10, $2A, $30, $8A, $20, $2A, $A0, $1A, $20, $2A, $20, $7A, $10, $1A, $20, $2A, $10, $1A, $60, $1A, $10, $1A, $20, $1A, $20, $1A, $10, $3A, $20, $1A, $10, $1A, $20, $2A, $10, $1A, $10, $1A, $20, $1A, $10, $1A, $10, $1A, $20, $1A

;----------------------------------------------------------
MAP_DATA0002: ; X=0 : Y=2
;----------------------------------------------------------

; MAP TYPE
defb $01

; PITデータ
defw PIT_DATA0002  ; PITのMAPアドレス

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb $00           ; PITから出た場所のMAPY座標
defb $00           ; PITから出た場所のMAPY座標
defb 25 * 8        ; PITから出た場所のX座標
defb 15 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $12 ; slime LV=2
defb  5,  9
defb $12 ; slime LV=2
defb 11, 15
defb $12 ; slime LV=2
defb 19,  5
defb $12 ; slime LV=2
defb 21, 25
defb $13 ; slime LV=3
defb 13, 25
defb $00

; TILE DATA
; DATA LENGTH
defb 65 ; BYTES
; COMPRESSION DATAS
defb $11, $50, $11, $10, $41, $20, $21, $10, $11, $30, $11, $50, $11, $10, $21, $90, $11, $10, $11, $10, $21, $30, $11, $30, $11, $30, $11, $10, $21, $10, $11, $20, $11, $60, $11, $10, $21, $60, $11, $30, $11, $20, $21, $20, $21, $40, $31, $15, $41, $30, $11, $30, $11, $10, $51, $60, $11, $60, $51, $30, $11, $20, $11, $30, $11

;----------------------------------------------------------
MAP_DATA0102: ; X=1 : Y=2
;----------------------------------------------------------

; MAP TYPE
defb $04

; PITデータ
defw PIT_DATA0102

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb 27 * 8        ; PITから出た場所のX座標
defb  9 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $31      ; Wizard LV=1
defb  5, 13
defb $31      ; Wizard LV=1
defb  17, 13
defb $21      ; wisp LV=1
defb $80, $80
defb $21      ; wisp LV=1
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 77 ; BYTES
; COMPRESSION DATAS
defb $18, $10, $E8, $70, $17, $50, $28, $10, $48, $10, $18, $17, $10, $68, $10, $18, $40, $18, $30, $18, $10, $15, $28, $17, $18, $10, $68, $10, $18, $10, $38, $17, $18, $10, $27, $40, $17, $30, $28, $17, $58, $10, $38, $10, $18, $10, $28, $10, $18, $70, $18, $10, $48, $10, $18, $10, $18, $10, $18, $10, $18, $17, $18, $10, $17, $10, $28, $10, $18, $10, $18, $10, $18, $10, $18, $10, $58

;----------------------------------------------------------
MAP_DATA0202: ; X=2 : Y=2
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0202

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb  3 * 8        ; PITから出た場所のX座標
defb 17 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33      ; Wizard LV=3
defb  9, 9
defb $53      ; Skelton LV=3
defb 11, 27
defb $14      ; Slime LV=4
defb 19, 25
defb $23      ; Wisp LV=3
defb $80, $80
defb $23      ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 80 ; BYTES
; COMPRESSION DATAS
defb $11, $30, $21, $37, $1A, $40, $1A, $11, $30, $11, $20, $37, $1A, $30, $1A, $11, $20, $11, $30, $37, $1A, $10, $3A, $11, $10, $11, $50, $27, $1A, $30, $1A, $11, $10, $11, $50, $27, $1A, $30, $1A, $11, $10, $11, $40, $27, $2A, $10, $3A, $11, $20, $11, $20, $37, $1A, $40, $1A, $11, $15, $10, $11, $10, $37, $2A, $40, $1A, $11, $20, $11, $10, $37, $1A, $50, $1A, $31, $20, $37, $1A, $20, $2A, $10, $1A

;----------------------------------------------------------
MAP_DATA0302: ; X=3 : Y=2
;----------------------------------------------------------

; MAP TYPE
defb $06

; PITデータ
defw $FFFF

; ENEMY DATA
defb $34      ; Wizard LV=4
defb   9,  7
defb $34      ; Wizard LV=4
defb   3, 17
defb $54      ; Skelton LV=4
defb  11, 13
defb $54      ; Skelton LV=4
defb  19, 27
defb $00

; TILE DATA
; DATA LENGTH
defb 81 ; BYTES
; COMPRESSION DATAS
defb $16, $10, $36, $60, $16, $20, $26, $40, $36, $50, $36, $10, $16, $10, $16, $30, $26, $20, $16, $10, $36, $60, $16, $20, $16, $20, $26, $10, $16, $60, $16, $40, $26, $10, $16, $20, $16, $10, $16, $20, $16, $10, $16, $10, $26, $10, $16, $10, $16, $30, $16, $10, $36, $10, $26, $30, $16, $10, $16, $10, $16, $20, $16, $20, $26, $30, $16, $10, $16, $10, $16, $20, $16, $20, $66, $10, $16, $10, $56, $10, $16

;----------------------------------------------------------
MAP_DATA0402: ; X=4 : Y=2
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw $FFFF

; ENEMY DATA
defb $53     ; Skelton LV=3
defb  5,  3
defb $53     ; Skelton LV=3
defb  9, 25
defb $43     ; WOODY LV=3
defb 13,  9
defb $43     ; WOODY LV=3
defb 19, 23
defb $00

; TILE DATA
; DATA LENGTH
defb 69 ; BYTES
; COMPRESSION DATAS
defb $1A, $10, $2A, $10, $1A, $30, $1A, $10, $1A, $10, $3A, $10, $2A, $10, $1A, $30, $1A, $10, $1A, $30, $1A, $40, $1A, $30, $1A, $10, $1A, $10, $3A, $20, $1A, $10, $3A, $10, $1A, $10, $1A, $30, $1A, $20, $1A, $10, $1A, $10, $1A, $10, $1A, $10, $5A, $20, $1A, $30, $1A, $10, $1A, $50, $1A, $20, $1A, $10, $3A, $10, $7A, $20, $1A, $B0, $1A, $E0, $FA

;----------------------------------------------------------
MAP_DATA0502: ; X=5 : Y=2
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0502

defb 0
defb 0
defb 0
defb 0
defb 5 * 8
defb 5 * 8

; ENEMY DATA
defb $43       ; WOODY LV=3
defb  9,  3
defb $43       ; WOODY LV=3
defb  7, 11
defb $14       ; Slime LV=4
defb 19, 27
defb $14       ; Slime LV=4
defb 13,  7
defb $00

; TILE DATA
; DATA LENGTH
defb 80 ; BYTES
; COMPRESSION DATAS
defb $1A, $10, $1A, $10, $1A, $20, $1A, $10, $1A, $10, $1A, $20, $1A, $10, $1A, $15, $10, $1A, $10, $2A, $10, $1A, $10, $2A, $10, $5A, $50, $1A, $40, $1A, $40, $1A, $10, $1A, $20, $1A, $40, $4A, $10, $1A, $10, $1A, $30, $5A, $40, $1A, $20, $1A, $10, $1A, $40, $5A, $10, $2A, $20, $1A, $10, $4A, $30, $1A, $50, $1A, $10, $1A, $20, $1A, $30, $1A, $10, $5A, $40, $2A, $20, $1A, $10, $3A, $10, $1A, $10, $4A

;----------------------------------------------------------
MAP_DATA0003: ; X=0 : Y=3
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw PIT_DATA0001

; ENEMY DATA
defb $13 ; slime LV=3
defb  5, 11   ; 上位1バイトがY、下位がX
defb $13 ; slime LV=3
defb 19,  5 ; 上位1バイトがY、下位がX
defb $13 ; slime LV=3
defb  9, 15 ; 上位1バイトがY、下位がX
defb $13 ; slime LV=3
defb 15, 17 ; 上位1バイトがY、下位がX
defb $00

; TILE DATA
; DATA LENGTH
defb 69 ; BYTES
; COMPRESSION DATAS
defb $41, $30, $11, $20, $11, $30, $21, $90, $11, $30, $21, $10, $61, $40, $11, $10, $21, $90, $11, $30, $21, $10, $11, $20, $21, $10, $11, $30, $11, $10, $21, $10, $11, $50, $11, $30, $11, $10, $21, $10, $11, $10, $11, $50, $31, $10, $21, $60, $11, $40, $11, $10, $21, $20, $11, $10, $11, $30, $11, $20, $11, $10, $21, $50, $11, $30, $11, $30, $11

;----------------------------------------------------------
MAP_DATA0103: ; X=1 : Y=3
;----------------------------------------------------------

; MAP TYPE
defb $04

; PITデータ
defw PIT_DATA0103  ; PITのMAPアドレス

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb $00           ; PITに出た場所のMAPY座標
defb $00           ; PITに出た場所のMAPY座標
defb  7 * 8        ; PITから出た場所のX座標
defb 13 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $32      ; Wizard LV=2
defb  5, 11
defb $32      ; Wizard LV=2
defb 13, 27
defb $22      ; wisp LV=2
defb $80, $80
defb $22      ; wisp LV=2
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 62 ; BYTES
; COMPRESSION DATAS
defb $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $68, $10, $18, $17, $18, $90, $28, $10, $18, $17, $78, $17, $18, $10, $28, $30, $18, $60, $17, $18, $10, $68, $10, $58, $17, $18, $10, $28, $20, $15, $18, $47, $50, $28, $10, $38, $17, $A8, $10, $18, $A7, $10, $28, $30, $18, $17, $18, $30, $18, $27, $20, $F8

;----------------------------------------------------------
MAP_DATA0203: ; X=2 : Y=3
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0203

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb 0             ; PITから出た場所のMAPX座標
defb 0             ; PITから出た場所のMAPY座標
defb 3 * 8         ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $14           ; Slime LV=4
defb 19, 27
defb $14           ; Slime LV=4
defb  7, 17
defb $42           ; WOODY LV=2
defb 15,  5
defb $23           ; Wisp LV=3
defb $80, $80
defb $23           ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 79 ; BYTES
; COMPRESSION DATAS
defb $31, $20, $37, $1A, $20, $2A, $10, $1A, $11, $10, $21, $37, $3A, $40, $1A, $11, $10, $11, $10, $37, $1A, $30, $1A, $20, $1A, $11, $10, $11, $10, $37, $1A, $30, $2A, $10, $1A, $11, $30, $37, $1A, $10, $1A, $20, $1A, $10, $1A, $11, $30, $37, $1A, $10, $1A, $20, $1A, $10, $1A, $11, $30, $37, $1A, $10, $6A, $38, $10, $37, $1A, $10, $1A, $60, $15, $18, $10, $37, $1A, $60, $1A, $38, $11, $37, $8A

;----------------------------------------------------------
MAP_DATA0303: ; X=3 : Y=3
; 魔城入り口
;----------------------------------------------------------

; MAP TYPE
defb $06

; PITデータ
defw PIT_DATA0303

defb 0
defb 0
defb 0
defb 0
defb 9 * 8
defb 27 * 8

; ENEMY DATA
defb $14     ; Slime LV=4
defb 15,  5
defb $14     ; Slime LV=4
defb  5,  5
defb $14     ; Slime LV=4
defb  7, 13
defb $14     ; Slime LV=4
defb 19, 21
defb $00

; TILE DATA
; DATA LENGTH
defb 64 ; BYTES
; COMPRESSION DATAS
defb $56, $10, $16, $10, $56, $10, $26, $30, $16, $10, $16, $10, $16, $30, $16, $20, $16, $10, $16, $10, $16, $30, $16, $10, $16, $10, $46, $10, $16, $20, $16, $10, $16, $20, $16, $10, $16, $15, $26, $B0, $16, $10, $26, $10, $26, $10, $36, $10, $26, $10, $16, $10, $36, $A0, $16, $10, $16, $C0, $16, $10, $26, $D0, $F6, $16

;----------------------------------------------------------
MAP_DATA0403: ; X=4 : Y=3
;----------------------------------------------------------

; MAP TYPE
defb $06

; PITデータ
defw PIT_DATA0403

defb 0
defb 0
defb 0
defb 0
defb 27 * 8
defb 5 * 8

; ENEMY DATA
defb $34      ; Wizard LV=4
defb  9, 9
defb $34      ; Wizard LV=4
defb 17, 23
defb $24      ; Wisp LV=4
defb $80, $80
defb $24      ; Wisp LV=4
defb $80, $80
defb $24      ; Wisp LV=4
defb $80, $80
defb 0

; TILE DATA
; DATA LENGTH
defb 59 ; BYTES
; COMPRESSION DATAS
defb $F6, $40, $16, $20, $16, $50, $15, $46, $10, $16, $50, $66, $50, $16, $10, $16, $50, $26, $10, $26, $40, $26, $20, $16, $10, $26, $40, $16, $10, $16, $40, $16, $10, $46, $20, $16, $10, $16, $20, $16, $10, $16, $10, $26, $40, $16, $10, $16, $60, $26, $20, $16, $20, $16, $30, $16, $30, $F6, $16

;----------------------------------------------------------
MAP_DATA0503: ; X=5 : Y=3
;----------------------------------------------------------

; MAP TYPE
defb $05

; PITデータ
defw PIT_DATA0503

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb 0             ; PITから出た場所のMAPX座標
defb 0             ; PITから出た場所のMAPY座標
defb 3 * 8         ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33           ; Wizard LV=3
defb  5, 5
defb $33           ; Wizard LV=3
defb  9, 27
defb $52           ; Skelton LV=2
defb 15, 9
defb $52           ; Skelton LV=2
defb  3, 17
defb $00

; TILE DATA
; DATA LENGTH
defb 62 ; BYTES
; COMPRESSION DATAS
defb $1A, $20, $1A, $10, $3A, $10, $1A, $10, $5A, $20, $1A, $30, $1A, $10, $1A, $40, $2A, $40, $3A, $10, $1A, $40, $2A, $D0, $8A, $10, $5A, $10, $2A, $50, $1A, $40, $1A, $20, $5A, $10, $2A, $10, $2A, $10, $2A, $10, $2A, $10, $2A, $40, $1A, $30, $1A, $10, $2A, $15, $30, $4A, $10, $1A, $30, $6A, $20, $6A, $10, $1A

;----------------------------------------------------------
MAP_DATA0004: ; X=0 : Y=4
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw $FFFF

; ENEMY DATA
defb $31  ; Wizard LV=1
defb  7,  7
defb $31  ; Wizard LV=1
defb 15, 21
defb $41  ; Woody LV=1
defb 19, 11
defb $21  ; wisp LV=1
defb $80, $80
defb $21  ; wisp LV=1
defb $80, $80
defb $00

; TILE DATA
defb 73 ; BYTES
; COMPRESSION DATAS
defb $11, $50, $11, $30, $11, $30, $41, $10, $11, $20, $11, $30, $21, $20, $11, $10, $11, $60, $11, $20, $21, $10, $11, $30, $11, $10, $41, $20, $11, $10, $31, $A0, $11, $20, $11, $10, $11, $20, $31, $10, $21, $10, $11, $10, $21, $60, $11, $70, $11, $20, $21, $50, $11, $20, $31, $10, $11, $10, $11, $10, $11, $10, $11, $20, $21, $20, $11, $50, $11, $30, $11, $30, $11

;----------------------------------------------------------
MAP_DATA0104: ; X=1 : Y=4
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw PIT_DATA0104

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defb $00           ; PITに出た場所のMAPY座標
defb $00           ; PITに出た場所のMAPY座標
defb 13 * 8        ; PITから出た場所のX座標
defb 11 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $32  ; Wizard LV=2
defb  5,  5
defb $32  ; Wizard LV=2
defb 13, 19
defb $22  ; Wisp LV=2
defb $80, $80
defb $22  ; Wisp LV=2
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 66 ; BYTES
; COMPRESSION DATAS
defb $F1, $90, $11, $40, $11, $20, $11, $10, $11, $60, $21, $10, $31, $10, $11, $10, $51, $40, $11, $50, $11, $15, $10, $11, $10, $21, $20, $41, $50, $11, $30, $11, $10, $11, $30, $11, $80, $11, $10, $41, $30, $11, $20, $11, $20, $11, $10, $11, $30, $11, $10, $11, $20, $11, $20, $11, $20, $21, $40, $11, $20, $11, $20, $11, $20, $11

;----------------------------------------------------------
MAP_DATA0204: ; X=2 : Y=4
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw PIT_DATA0204

defb 0             ; PITに入った直後のX座標
defb 0             ; PITに入った直後のY座標
defb 0             ; PITに出た場所のMAPY座標
defb 0             ; PITに出た場所のMAPY座標
defb 11 * 8        ; PITから出た場所のX座標
defb 11 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33     ; Wizard LV=3
defb 19,  3
defb $33     ; Wizard LV=3
defb  5, 27
defb $52     ; Skelton LV=1
defb  9, 13
defb $00

; TILE DATA
; DATA LENGTH
defb 46 ; BYTES
; COMPRESSION DATAS
defb $41, $37, $91, $30, $37, $70, $17, $11, $10, $D7, $11, $10, $27, $30, $77, $21, $10, $27, $10, $15, $10, $87, $11, $10, $27, $30, $77, $21, $10, $C7, $1B, $11, $10, $67, $50, $17, $1B, $11, $10, $27, $31, $70, $1B, $51, $17, $91

;----------------------------------------------------------
MAP_DATA0304: ; X=3 : Y=4
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw $FFFF

; ENEMY DATA
defb $33           ; Wizard LV=3
defb  9,  7
defb $33           ; Wizard LV=3
defb 13, 23
defb $23           ; Wisp LV=3
defb $80, $80
defb $23           ; Wisp LV=3
defb $80, $80

defb $00

; TILE DATA
; DATA LENGTH
defb 26 ; BYTES
; COMPRESSION DATAS
defb $F1, $E7, $1B, $E7, $21, $27, $30, $37, $30, $67, $30, $37, $30, $27, $21, $27, $30, $37, $30, $F7, $27, $11, $F7, $E0, $F1, $11

;----------------------------------------------------------
MAP_DATA0404: ; X=4 : Y=4
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw PIT_DATA0404

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス
defb 25 * 8        ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33      ; Wizard LV=3
defb  5,  7
defb $33      ; Wizard LV=3
defb 19, 17
defb $23           ; Wisp LV=3
defb $80, $80
defb $23           ; Wisp LV=3
defb $80, $80
defb $23           ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 30 ; BYTES
; COMPRESSION DATAS
defb $F1, $37, $90, $27, $21, $27, $90, $E7, $10, $27, $21, $F7, $D7, $21, $27, $10, $A7, $1B, $37, $80, $81, $50, $21, $15, $30, $11, $10, $71, $10, $51

;----------------------------------------------------------
MAP_DATA0504: ; X=5 : Y=4
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw PIT_DATA0504

; ENEMY DATA
defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス
defb 25 * 8        ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $32      ; Wizard LV=2
defb 19, 25
defb $32      ; Wizard LV=2
defb 11,  9
defb $22      ; Wisp LV=2
defb $80, $80
defb $22      ; Wisp LV=2
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 48 ; BYTES
; COMPRESSION DATAS
defb $51, $20, $61, $10, $61, $70, $11, $10, $11, $57, $70, $11, $10, $21, $B7, $11, $15, $11, $47, $30, $57, $41, $37, $30, $27, $40, $17, $11, $47, $30, $27, $40, $17, $41, $67, $40, $17, $11, $20, $11, $67, $40, $17, $21, $10, $11, $B7, $11

;----------------------------------------------------------
MAP_DATA0005: ; X=0 : Y=5
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw PIT_DATA0005

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb  3 * 8        ; PITから出た場所のX座標
defb 15 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $41   ; Woody LV=1
defb  9, 5
defb $41   ; Woody LV=1
defb 13, 27
defb $41   ; Woody LV=1
defb  3, 27
defb $22   ; Wisp LV=2
defb $80, $80
defb $22   ; Wisp LV=2
defb $80, $80

defb $00

; TILE DATA
; DATA LENGTH
defb 65 ; BYTES
; COMPRESSION DATAS
defb $11, $50, $11, $30, $11, $30, $21, $10, $31, $10, $11, $20, $21, $10, $11, $20, $11, $20, $11, $70, $11, $20, $31, $10, $11, $10, $21, $10, $31, $40, $11, $40, $11, $20, $11, $20, $61, $20, $11, $20, $21, $60, $11, $15, $21, $20, $11, $50, $11, $20, $11, $60, $21, $10, $11, $20, $31, $20, $21, $30, $11, $10, $11, $40, $F1

;----------------------------------------------------------
MAP_DATA0105: ; X=1 : Y=5
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw PIT_DATA0105

defb 0             ; PITに入った直後のX座標
defb 0             ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb 27 * 8        ; PITから出た場所のX座標
defb 15 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $32           ; Wizard LV=2
defb 13, 3
defb $32           ; Wizard LV=2
defb 11, 23
defb $22           ; Wisp LV=2
defb $80, $80
defb $22           ; Wisp LV=2
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 71 ; BYTES
; COMPRESSION DATAS
defb $11, $40, $11, $20, $11, $20, $11, $20, $11, $10, $41, $10, $31, $20, $11, $20, $21, $10, $11, $60, $11, $20, $11, $10, $11, $20, $11, $10, $11, $10, $11, $30, $61, $10, $11, $20, $11, $10, $21, $80, $11, $20, $11, $30, $11, $20, $31, $10, $11, $40, $11, $10, $11, $20, $11, $10, $15, $21, $20, $21, $10, $11, $10, $31, $30, $11, $30, $11, $A0, $F1, $11

;----------------------------------------------------------
MAP_DATA0205: ; X=2 : Y=5
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw PIT_DATA0205

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb 25 * 8        ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $12           ; slime LV=2
defb 7, 7
defb $12           ; slime LV=2
defb 9, 23
defb $22           ; Wisp LV=2
defb 11, 2
defb $22           ; Wisp LV=2
defb 15, 23
defb $00

; TILE DATA
; DATA LENGTH
defb 70 ; BYTES
; COMPRESSION DATAS
defb $51, $17, $A1, $10, $11, $10, $11, $27, $80, $11, $40, $27, $21, $10, $11, $10, $41, $10, $61, $20, $11, $60, $11, $20, $17, $11, $17, $10, $11, $10, $51, $10, $11, $10, $31, $17, $21, $50, $11, $10, $11, $10, $11, $10, $17, $11, $17, $10, $11, $10, $41, $10, $11, $10, $11, $10, $21, $17, $11, $30, $11, $10, $11, $60, $37, $11, $10, $15, $F1, $21

;----------------------------------------------------------
MAP_DATA0305: ; X=3 : Y=5
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw PIT_DATA0305

defb $00           ; PITに入った直後のX座標
defb $00           ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb 23 * 8        ; PITから出た場所のX座標
defb 17 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $32     ; Wizard LV=2
defb  5, 11
defb $42     ; WOODY LV=2
defb 17,  9
defb $23     ; Wisp LV=2
defb $80, $80
defb $23     ; Wisp LV=2
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 53 ; BYTES
; COMPRESSION DATAS
defb $F1, $30, $11, $30, $11, $60, $41, $20, $11, $30, $11, $20, $11, $60, $11, $10, $21, $10, $11, $10, $61, $20, $11, $10, $11, $20, $31, $70, $11, $10, $11, $10, $21, $30, $11, $10, $21, $40, $21, $30, $11, $60, $11, $10, $21, $30, $11, $15, $51, $50, $21, $60, $F1

;----------------------------------------------------------
MAP_DATA0405: ; X=4 : Y=5
;----------------------------------------------------------

; MAP TYPE
defb $02

; PITデータ
defw PIT_DATA0405

defb  0
defb  0
defb  0
defb  0
defb  3 * 8        ; PITから出た場所のX座標
defb  17 * 8       ; PITから出た場所のY座標

; ENEMY DATA
defb $13     ; Slime LV=3
defb 7, 3
defb $13     ; Slime LV=3
defb 9, 25
defb $41    ; Woody LV=1
defb 19, 25
defb $41     ; Woody LV=1
defb 17, 15
defb $00

; TILE DATA
; DATA LENGTH
defb 64 ; BYTES
; COMPRESSION DATAS
defb $11, $10, $71, $10, $61, $70, $11, $20, $11, $50, $11, $10, $11, $10, $21, $30, $11, $10, $31, $10, $11, $30, $11, $20, $11, $30, $21, $10, $11, $10, $11, $20, $11, $10, $11, $20, $11, $70, $11, $10, $21, $50, $21, $10, $21, $30, $11, $20, $21, $10, $41, $15, $10, $31, $20, $31, $50, $11, $60, $11, $40, $11, $10, $F1

;----------------------------------------------------------
MAP_DATA0505: ; X=5 : Y=5
;----------------------------------------------------------

; MAP TYPE
defb $03

; PITデータ
defw PIT_DATA0505

defb  0            ; PITに入った直後のX座標
defb  0            ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb 21 * 8        ; PITから出た場所のX座標
defb  7 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $32    ; Wizard LV=2
defb  9,  3
defb $32    ; Wizard LV=2
defb  5,  19
defb $13    ; Slime LV=3
defb 15,  5
defb $13    ; Slime LV=3
defb 17,  27
defb $00

; TILE DATA
; DATA LENGTH
defb 63 ; BYTES
; COMPRESSION DATAS
defb $11, $10, $11, $B7, $11, $20, $41, $37, $30, $27, $21, $10, $11, $30, $11, $27, $10, $15, $10, $27, $21, $10, $11, $30, $11, $27, $30, $27, $11, $10, $11, $10, $11, $20, $21, $67, $31, $10, $21, $30, $11, $27, $30, $31, $60, $11, $27, $30, $11, $10, $11, $20, $21, $30, $27, $30, $11, $60, $11, $20, $57, $F1, $11

;----------------------------------------------------------
PIT_DATA0000: ; PITデータ
; このPITはSHORT SWORDが取得できる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0000  ; PITデータのMAPアドレス

defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $11 ; slime LV=1
defb 15, 15
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 49 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0001: ; PITデータ
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0001
defb 15            ; PITに入った直後のX座標
defb  7            ; PITに入った直後のY座標
defw $0000         ; PITから出た場所のMAPアドレス          
defb  5            ; PITから出た場所のX座標
defb 17            ; PITから出た場所のY座標

; ENEMY DATA
defb $33 ; wizard LV=3
defb $09, $07 ;
defb $32 ; wizard LV=2
defb $0F, $07 ;
defb $32 ; wizard LV=2
defb $09, $19 ;
defb $33 ; wizard LV=3
defb $0F, $19 ;
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 53 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $77, $20, $16, $2F, $16, $20, $17, $10, $17, $10, $17, $10, $17, $20, $16, $2F, $16, $20, $17, $10, $17, $10, $17, $10, $17, $20, $16, $2F, $16, $20, $77, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0002: ; PITデータ（平野から山岳違いへの道ワープ）
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0002
defb  5 * 8        ; PITに入った直後のX座標
defb 13 * 8        ; PITに入った直後のY座標
defb  4            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  7 * 8        ; PITから出た場所のX座標
defb  9 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $13 ; slime LV=3
defb 11,  7
defb $13 ; slime LV=3
defb 15,  7
defb $23 ; wisp  LV=3
defb 11, 15
defb $23 ; wisp  LV=3
defb 13, 15
defb $23 ; wisp  LV=3
defb 15, 15
defb $33 ; wizard LV=3
defb 13, 23
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 27 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $D6, $2F, $D6, $2F, $16, $B0, $16, $2F, $16, $13, $90, $14, $16, $2F, $16, $B0, $16, $2F, $D6, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0005: ; PITデータ
; このPITはLEATHER ARMORが取得できる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0005  ; PITデータのMAPアドレス
defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $13 ; slime LV=3
defb  9,  7
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 49 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0100: 
; PITデータ
; MAP X=2, Y=2への通路
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0100
defb 25 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  2            ; PITから出た場所のMAP座標X
defb  2            ; PITから出た場所のMAP座標Y
defb  3 * 8        ; PITから出た場所のX座標
defb 17 * 8        ; PITから出た場所のY座標

; ENEMY
defb $33      ; Wizard LV=3
defb  9, 9
defb $33      ; Wizard LV=3
defb 13, 21
defb $23      ; Wisp LV=3
defb $80, $80
defb $23      ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 34 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $A0, $13, $16, $2F, $16, $10, $16, $10, $96, $2F, $16, $B0, $16, $2F, $96, $10, $16, $10, $16, $2F, $16, $14, $A0, $16, $2F, $D6, $FF, $FF, $1F

;----------------------------------------------------------
PIT_DATA0102: 
; PITデータ（リングショップ）
; ここではGUARDIAN RINGがもらえる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0102
defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

defb $00

; TILE DATA
defb 29 ; BYTES
; COMPRESSION DATAS
defb $FF, $4F, $78, $8F, $18, $20, $13, $20, $18, $8F, $18, $50, $18, $8F, $18, $20, $1C, $20, $18, $8F, $18, $50, $18, $8F, $78, $FF, $FF, $FF, $4F

;----------------------------------------------------------
PIT_DATA0103: ; PITデータ
; HEAVY PIT
; このPITはLONG SWORDが取得できる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0103  ; PITデータのMAPアドレス

defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $31 ; Wizard LV=1
defb  7,  5
defb $31 ; Wizard LV=1
defb 17, 25
defb $21 ; Wisp LV=1
defb $80, $80
defb $21 ; Wisp LV=1
defb $80, $80
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 49 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0104: ; PITデータ
; このPITは休憩所
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0104  ; PITデータのMAPアドレス

defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 49 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0105: ; PITデータ
; このPITはBLUE KEY
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0105  ; PITデータのMAPアドレス

defb  5 * 8        ; PITに入った直後のX座標
defb 17 * 8        ; PITに入った直後のY座標
defb  4            ; PITから出た場所のMAP座標X
defb  4            ; PITから出た場所のMAP座標Y
defb 23 * 8        ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33           ; Wizard LV=3
defb  7, 23
defb $33           ; Wizard LV=3
defb 17, 15
defb $14           ; Slime LV=4
defb 11, 15
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 37 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D7, $2F, $17, $A0, $14, $17, $2F, $17, $20, $77, $20, $17, $2F, $17, $B0, $17, $2F, $17, $B0, $17, $2F, $17, $20, $77, $20, $17, $2F, $17, $13, $A0, $17, $2F, $D7, $FF, $1F

;----------------------------------------------------------
PIT_DATA0301: ; PITデータ
; ラスボス（魔導士）
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0301  ; PITデータのMAPアドレス

defb 17 * 8        ; PITに入った直後のX座標
defb 19 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $35           ; Wizard LV=5
defb  5,  3
defb $35           ; Wizard LV=5
defb 19, 27
defb $35           ; Wizard LV=5
defb  9, 21
defb $35           ; Wizard LV=5
defb 15,  7
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 21 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D0, $2F, $D0, $2F, $D0, $2F, $D0, $2F, $D0, $2F, $D0, $2F, $D0, $2F, $70, $13, $50, $FF, $1F

;----------------------------------------------------------
PIT_DATA0303: ; PITデータ
; ここではLIGHT RINGがもらえる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0303  ; PITデータのMAPアドレス
defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 29 ; BYTES
; COMPRESSION DATAS
defb $FF, $4F, $78, $8F, $18, $20, $13, $20, $18, $8F, $18, $50, $18, $8F, $18, $20, $1C, $20, $18, $8F, $18, $50, $18, $8F, $78, $FF, $FF, $FF, $4F

;----------------------------------------------------------
PIT_DATA0305: ; PITデータ
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0305  ; PITデータのMAPアドレス
defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $32           ; Wizard LV=2
defb 13, 15
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 49 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0400: ; PITデータ（山岳から平野への道ワープ）
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0400
defb 25 * 8        ; PITに入った直後のX座標
defb 13 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  2            ; PITから出た場所のMAP座標Y
defb 25 * 8        ; PITから出た場所のX座標
defb 15 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $13 ; slime LV=3
defb 11,  7
defb $13 ; slime LV=3
defb 15,  7
defb $23 ; wisp  LV=3
defb 11, 15
defb $23 ; wisp  LV=3
defb 13, 15
defb $23 ; wisp  LV=3
defb 15, 15
defb $33 ; wizard LV=3
defb 13, 23
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 27 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $D6, $2F, $D6, $2F, $16, $B0, $16, $2F, $16, $14, $90, $13, $16, $2F, $16, $B0, $16, $2F, $D6, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0403: 
; PITデータ（リングショップ）
; ここではSPELLOFF RINGがもらえる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0403
defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

defb $00

; TILE DATA
defb 29 ; BYTES
; COMPRESSION DATAS
defb $FF, $4F, $78, $8F, $18, $20, $13, $20, $18, $8F, $18, $50, $18, $8F, $18, $20, $1C, $20, $18, $8F, $18, $50, $18, $8F, $78, $FF, $FF, $FF, $4F

;----------------------------------------------------------
PIT_DATA0404: ; PITデータ
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0404  ; PITデータのMAPアドレス

defb 25 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  1            ; PITから出た場所のMAP座標X
defb  5            ; PITから出た場所のMAP座標Y
defb 27 * 8        ; PITから出た場所のX座標
defb 15 * 8        ; PITから出た場所のY座標

; ENEMY DATA
defb $33           ; Wizard LV=3
defb  7, 23
defb $33           ; Wizard LV=3
defb 17, 15
defb $14           ; Slime LV=4
defb 11, 15
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 37 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D7, $2F, $17, $A0, $13, $17, $2F, $17, $20, $77, $20, $17, $2F, $17, $B0, $17, $2F, $17, $B0, $17, $2F, $17, $20, $77, $20, $17, $2F, $17, $14, $A0, $17, $2F, $D7, $FF, $1F

;----------------------------------------------------------
PIT_DATA0405: ; PITデータ
; ここでは HARD ARMOR を取得
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0405  ; PITデータのMAPアドレス

defb  15 * 8
defb  11 * 8
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $42     ; WOODY LV=2
defb 5, 3
defb $42     ; WOODY LV=2
defb 19, 27
defb $22     ; Wizard LV=2
defb 13, 11
defb $22     ; Wizard LV=2
defb 9,  19
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 39 ; BYTES
; COMPRESSION DATAS
defb $F8, $18, $D0, $28, $50, $16, $10, $16, $50, $28, $50, $16, $10, $16, $50, $28, $30, $36, $13, $46, $20, $28, $50, $16, $10, $16, $50, $28, $50, $16, $10, $16, $50, $28, $D0, $28, $D0, $F8, $18

;----------------------------------------------------------
PIT_DATA0201: 
; PITデータ
; PASSPORTが手に入る
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0201
defb 21 * 8        ; PITに入った直後のX座標
defb 17 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY
defb $52           ; Skelton LV=2
defb 11,  5
defb $52           ; Skelton LV=2
defb  7, 21
defb $23           ; Wisp LV=3
defb $80,$80
defb $23           ; Wisp LV=3
defb $80,$80
defb $00

; TILE DATA
; DATA LENGTH
defb 32 ; BYTES
; COMPRESSION DATAS
defb $FF, $3F, $96, $6F, $16, $70, $16, $4F, $36, $70, $36, $2F, $16, $B0, $16, $2F, $16, $B0, $16, $2F, $36, $70, $36, $4F, $16, $60, $13, $16, $6F, $96, $FF, $3F

;----------------------------------------------------------
PIT_DATA0202: 
; PITデータ
; MAP X=1, Y=0への通路
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0202
defb  5 * 8        ; PITに入った直後のX座標
defb 15 * 8        ; PITに入った直後のY座標
defb  1            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb 25 * 8        ; PITから出た場所のX座標
defb 13 * 8        ; PITから出た場所のY座標

; ENEMY
defb $33      ; Wizard LV=3
defb  9, 9
defb $33      ; Wizard LV=3
defb 13, 21
defb $23      ; Wisp LV=3
defb $80, $80
defb $23      ; Wisp LV=3
defb $80, $80
defb $00

; TILE DATA
; DATA LENGTH
defb 34 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $A0, $14, $16, $2F, $16, $10, $16, $10, $96, $2F, $16, $B0, $16, $2F, $96, $10, $16, $10, $16, $2F, $16, $13, $A0, $16, $2F, $D6, $FF, $FF, $1F

;----------------------------------------------------------
PIT_DATA0203: ; PITデータ（炭鉱から山岳地帯への道）
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0203
defb 5 * 8         ; PITに入った直後のX座標
defb 13 * 8        ; PITに入った直後のY座標
defb 5             ; PITから出た場所のMAP座標X
defb 3             ; PITから出た場所のMAP座標Y
defb 3 * 8         ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

defb $00

; TILE DATA
; DATA LENGTH
defb 27 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $D6, $2F, $D6, $2F, $16, $B0, $16, $2F, $16, $13, $90, $14, $16, $2F, $16, $B0, $16, $2F, $D6, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0204: ; PITデータ
; ここではHARD ARMORが手に入る
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0204  ; PITデータのMAPアドレス

defb 25 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $42           ; WOODY LV=2
defb  9,  5
defb $42           ; WOODY LV=2
defb 13, 25
defb $23           ; Wisp LV=3
defb $80, $80
defb $23           ; Wisp LV=3
defb $80, $80
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 59 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D8, $2F, $18, $40, $17, $10, $17, $30, $13, $18, $2F, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $2F, $18, $50, $17, $50, $18, $2F, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $2F, $18, $40, $17, $10, $17, $40, $18, $2F, $D8, $FF, $FF, $1F

;----------------------------------------------------------
PIT_DATA0205: ; PITデータ（リングショップ）
; ここではPOWER RINGがもらえる
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0205
defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

defb $00

; TILE DATA
defb 29 ; BYTES
; COMPRESSION DATAS
defb $FF, $4F, $78, $8F, $18, $20, $13, $20, $18, $8F, $18, $50, $18, $8F, $18, $20, $1C, $20, $18, $8F, $18, $50, $18, $8F, $78, $FF, $FF, $FF, $4F

;----------------------------------------------------------
PIT_DATA0500: ; PITデータ
; ここではIRON ARMORを取得
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0500  ; PITデータのMAPアドレス

defb 27 * 8        ; PITに入った直後のX座標
defb  5 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $53           ; Skelton LV=3
defb  5,  3
defb $53           ; Skelton LV=3
defb 19, 27
defb $14           ; Slime LV=4
defb 11,  9
defb $14           ; Slime LV=4
defb 13, 21
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 32 ; BYTES
; COMPRESSION DATAS
defb $F6, $16, $C0, $13, $26, $D0, $26, $20, $97, $20, $26, $20, $17, $70, $17, $20, $26, $20, $17, $70, $17, $20, $26, $20, $97, $20, $26, $D0, $26, $D0, $F6, $16

;----------------------------------------------------------
PIT_DATA0502: ; PITデータ
; ここではHARD ARMORを取得
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0502  ; PITデータのMAPアドレス

defb 21 * 8        ; PITに入った直後のX座標
defb 17 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $14           ; Slime LV=4
defb $80, $80
defb $14           ; Slime LV=4
defb $80, $80
defb $33           ; Wizard LV=3
defb $80, $80
defb $00 ; EOD

; TILE DATA
defb 32 ; BYTES
; COMPRESSION DATAS
defb $FF, $3F, $96, $6F, $16, $70, $16, $4F, $36, $70, $36, $2F, $16, $B0, $16, $2F, $16, $B0, $16, $2F, $36, $70, $36, $4F, $16, $60, $13, $16, $6F, $96, $FF, $3F


;----------------------------------------------------------
PIT_DATA0503: ; PITデータ（山岳地帯から炭鉱への道）
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0503
defb 25 * 8        ; PITに入った直後のX座標
defb 13 * 8        ; PITに入った直後のY座標
defb 2             ; PITから出た場所のMAP座標X
defb 3             ; PITから出た場所のMAP座標Y
defb 3 * 8         ; PITから出た場所のX座標
defb 19 * 8        ; PITから出た場所のY座標

defb $00

; TILE DATA
; DATA LENGTH
defb 27 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $D6, $2F, $D6, $2F, $16, $B0, $16, $2F, $16, $14, $90, $13, $16, $2F, $16, $B0, $16, $2F, $D6, $2F, $D6, $FF, $1F

;----------------------------------------------------------
PIT_DATA0504: ; PITデータ
; ここではHARD ARMORを取得
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0504  ; PITデータのMAPアドレス

defb 25 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $52           ; SKELTON LV=2
defb  9,  5
defb $52           ; SKELTON LV=2
defb 13, 25
defb $23           ; Wisp LV=3
defb $80, $80
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 59 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D8, $2F, $18, $40, $17, $10, $17, $30, $13, $18, $2F, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $2F, $18, $50, $17, $50, $18, $2F, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $2F, $18, $40, $17, $10, $17, $40, $18, $2F, $D8, $FF, $FF, $1F

;----------------------------------------------------------
PIT_DATA0505: ; PITデータ
; ここは休憩所
;----------------------------------------------------------

; MAP TYPE
defb $09

; PITデータ
defw PIT_DATA0505  ; PITデータのMAPアドレス

defb 15 * 8        ; PITに入った直後のX座標
defb  7 * 8        ; PITに入った直後のY座標
defb  0            ; PITから出た場所のMAP座標X
defb  0            ; PITから出た場所のMAP座標Y
defb  0            ; PITから出た場所のX座標
defb  0            ; PITから出た場所のY座標

; ENEMY DATA
defb $00 ; EOD

; TILE DATA
; DATA LENGTH
defb 49 ; BYTES
; COMPRESSION DATAS
defb $FF, $1F, $D6, $2F, $16, $50, $13, $50, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $40, $16, $10, $16, $40, $16, $2F, $16, $20, $16, $50, $16, $20, $16, $2F, $16, $B0, $16, $2F, $D6, $FF, $1F

;----------------------------------------------------------
; ここから下はマップタイルデータ
; タイル番号とキャラクタコードのマッピングデータ
;----------------------------------------------------------
CHAR_TILES:

; LU=LEFT UP
; LD=LEFT DOWN
; RU=RIGHT UP
; RU=RIGHT DOWN

; #0 歩行可能タイル（平原、ピットの床、etc..）
defb $22 ; LU
defb $22 ; LD
defb $22 ; RU
defb $22 ; RD

; #1 木
defb $60 ; LU
defb $61 ; LD
defb $62 ; RU
defb $63 ; RD

; #2 MAP外
defb $23 ; LU
defb $23 ; LD
defb $23 ; RU
defb $23 ; RD

; #3 上り階段1
defb $64 ; LU
defb $65 ; LD
defb $66 ; RU
defb $67 ; RD

; #4 上り階段2
defb $68 ; LU
defb $69 ; LD
defb $6A ; RU
defb $6B ; RD

; #5 下り階段
defb $6C ; LU
defb $6D ; LD
defb $6E ; RU
defb $6F ; RD

; #6 PITを構成するブロック
defb $70 ; LU
defb $71 ; LD
defb $72 ; RU
defb $73 ; RD

; #7 水
defb $74 ; LU
defb $74 ; LD
defb $74 ; RU
defb $74 ; RD

; #8 炭鉱ブロック
defb $79 ; LU
defb $7A ; LD
defb $7B ; RU
defb $7C ; RD

; #9 トンネルブロック
defb $23
defb $23
defb $23
defb $23

; #10(A) 岩山ブロック　
defb $75
defb $76
defb $77
defb $78

; #11(B) 水（永久回廊判定用）
defb $99
defb $99
defb $99
defb $99

; #12(C) RING職人
defb $B0
defb $B1
defb $B2
defb $B3

; #13(D) 空白
defb $20
defb $20
defb $20
defb $20

; #14(E) 空白
defb $20
defb $20
defb $20
defb $20

; #15(F) 空白
defb $20
defb $20
defb $20
defb $20

;----------------------------------------------------------
; ここから下はアイテムのタイルデータ
; タイル番号とキャラクタコードのマッピングデータ
;----------------------------------------------------------
DROP_ITEM_TILES:

; #16(10) 宝箱
defb $88
defb $89
defb $8A
defb $8B

DOOR_TILES_YELLOW:
; #17(11) 黄色ドア
defb $8D
defb $8E
defb $8F
defb $90

DOOR_TILES_BLUE:
; #18(12) 青色ドア
defb $91
defb $92
defb $93
defb $94

DROP_ITEM_TILES_RARE:
; #19(13) 宝箱（レアアイテム）
defb $95
defb $96
defb $97
defb $98

DOOR_TILE_GUARDMAN:
; #20(14) 山岳地帯への入り口のガードマン
defb $B0
defb $B1
defb $B2
defb $B3
