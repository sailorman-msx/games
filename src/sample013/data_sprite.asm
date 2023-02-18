;--------------------------------------------
; data_sprite.asm
; 固定データ(スプライト作成用)
;--------------------------------------------
; キャラクタパターン
SPRPTN:

; PLAYER
; データサイズは1体あたり64バイト

; 上方向
defb $1F, $1F, $3F, $3F, $3F, $3F, $3F, $1F ; SPRITE#0
defb $07, $20, $20, $20, $00, $00, $0E, $0E ;
defb $F8, $F8, $FC, $FC, $FC, $FC, $FC, $F8 ;
defb $E0, $04, $04, $04, $00, $00, $70, $70 ;
defb $00, $00, $00, $00, $00, $00, $00, $00 ; SPRITE#4
defb $10, $18, $1F, $1F, $1F, $0F, $00, $00 ;
defb $00, $00, $00, $00, $00, $00, $00, $00 ;
defb $08, $18, $F8, $F8, $F8, $F0, $00, $00 ;
; 右方向
defb $1F, $1F, $3F, $3F, $3E, $2E, $28, $10 ; SPRITE$8
defb $00, $38, $38, $38, $00, $00, $1C, $1C ;
defb $F0, $F8, $D8, $80, $00, $00, $00, $00 ;
defb $00, $00, $00, $00, $00, $04, $7C, $7C ;
defb $00, $00, $00, $00, $01, $11, $17, $0F ; SPRITE#12
defb $1F, $07, $07, $07, $1F, $0F, $00, $00 ;
defb $00, $00, $20, $78, $A8, $A8, $A8, $F0 ;
defb $08, $F8, $D8, $F8, $D8, $F0, $00, $00 ;
; 下方向
defb $1F, $1F, $3E, $3C, $38, $30, $30, $10 ; SPRITE#16
defb $00, $00, $00, $20, $20, $00, $1E, $1E ;
defb $F8, $F8, $7C, $3C, $1C, $0C, $0C, $08 ;
defb $00, $00, $00, $04, $04, $00, $78, $78 ;
defb $00, $00, $01, $03, $05, $0D, $0D, $0F ; SPRITE#20
defb $07, $08, $1F, $1E, $1F, $1E, $01, $00 ;
defb $00, $00, $80, $C0, $A0, $B0, $B0, $F0 ;
defb $E0, $10, $F8, $78, $F8, $78, $80, $00 ;
; 左方向
defb $0F, $1F, $1B, $01, $00, $00, $00, $00 ; SPRITE#24
defb $00, $00, $00, $00, $00, $20, $3E, $1E ;
defb $F8, $F8, $FC, $FC, $7C, $74, $14, $08 ;
defb $00, $1C, $1C, $1C, $00, $00, $38, $38 ;
defb $00, $00, $04, $1E, $15, $15, $15, $0F ; SPRITE#28
defb $10, $1F, $1B, $1F, $1B, $0F, $00, $00 ;
defb $00, $00, $00, $00, $80, $88, $E8, $F0 ;
defb $F8, $E0, $E0, $E0, $F8, $F0, $00, $00 ;

; スプライトの向きにあわせたパターン番号
; パターン番号は指定した番号から連続して8個使用する
; カラーはここでは定義しない
SPRDISTPTN_TBL:
; 押してない(0)
defb  16
; 上(1)
defb  0 ; パターン番号
; 右上(2)
defb  8 ; パターン番号
; 右(3)
defb  8 ; パターン番号
; 右下(4)
defb  8 ; パターン番号
; 下(5)
defb 16 ; パターン番号
; 左下(6)
defb 24 ; パターン番号
; 左(7)
defb 24 ; パターン番号
; 左(8)
defb 24 ; パターン番号

; スプライトの移動量を格納したテーブル
; 1バイト内の上位4ビットがX方向の移動量
; 1バイト内の下位4ビットがY方向の移動量
; 移動量が2の場合は-1として処理する
PLAYERMOVE_TBL:
defb $00 ; ジョイスティック方向0
defb $02 ; ジョイスティック方向1(X= 0, Y=-1)
defb $12 ; ジョイスティック方向2(X= 1, Y=-1)
defb $10 ; ジョイスティック方向3(X= 1, Y= 0)
defb $11 ; ジョイスティック方向4(X= 1, Y= 1)
defb $01 ; ジョイスティック方向5(X= 0, Y= 1)
defb $21 ; ジョイスティック方向6(X=-1, Y= 1)
defb $20 ; ジョイスティック方向7(X=-1, Y= 0)
defb $22 ; ジョイスティック方向8(X=-1, Y=-1)
