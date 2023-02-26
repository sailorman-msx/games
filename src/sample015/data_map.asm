;--------------------------------------------
; data_map.asm
; 固定データ(マップ作成用)
;--------------------------------------------
MAPDATA_DEFAULT:
; ゲーム背景の描画データ
; MAPデータ非圧縮方式(768バイト)
defb "################################" ; + 0
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 1
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 2
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 3
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 4
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 5
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 6
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 7
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 8
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 9
defb "#$$$$$$$$$$$$$$$$$$$$###########" ; +10
defb "#$$$$$$$$$$$$$$$$$$$$#    ######" ; +11
defb "#$$$$$$$$$$$$$$$$$$$$#    ######" ; +12
defb "#$$$$$$$$$$$$$$$$$$$$###########" ; +13
defb "#$$$$$$$$$$$$$$$$$$$$#", $A0, $A2, "       #" ; +14
defb "#$$$$$$$$$$$$$$$$$$$$#", $A1, $A3, "       #" ; +15
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +16
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +17
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +18
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +19
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +20
defb "################################" ; +21
defb $80, "         SCORE 000000000       " ; +22
defb "                                " ; +23

MAPDATA_GAMEOVER:
; GAME OVER時の背景
defb "################################" ; + 0
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 1
defb "#$$                $$#%%%%%%%%%#" ; + 2
defb "#$$   GAME OVER    $$#%%%%%%%%%#" ; + 3
defb "#$$                $$#%%%%%%%%%#" ; + 4
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 5
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 6
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 7
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 8
defb "#$$$$$$$$$$$$$$$$$$$$#%%%%%%%%%#" ; + 9
defb "#$$$$$$$$$$$$$$$$$$$$###########" ; +10
defb "#$$$$$$$$$$$$$$$$$$$$#    ######" ; +11
defb "#$$$$$$$$$$$$$$$$$$$$#    ######" ; +12
defb "#$$$$$$$$$$$$$$$$$$$$###########" ; +13
defb "#$$$$$$$$$$$$$$$$$$$$#", $A0, $A2, "       #" ; +14
defb "#$$$$$$$$$$$$$$$$$$$$#", $A1, $A3, "       #" ; +15
defb "#$$$$$$$$$$$$$$$$$$$$#SEE YOU  #" ; +16
defb "#$$$$$$$$$$$$$$$$$$$$#NEXT TIME#" ; +17
defb "#$$$$$$$$$$$$$$$$$$$$#HA-HA-HA #" ; +18
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +19
defb "#$$$$$$$$$$$$$$$$$$$$#         #" ; +20
defb "################################" ; +21
defb $80, "         SCORE 000000000       " ; +22
defb "                                " ; +23

MAPDATA_2BIT_TILES:
;
; MAPデータ 45x45 のサイズのマップを定義
; 2bitで1タイルを表現(横12x縦45=540byte)
; このデータをもとにして横45x縦45=2025byteのMAPデータをRAMに展開する
;   
;    +0   +4   +8   +12  +16  +20  +24  +28  +32  +36  +40  +44
;
defb $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$40
defb $40,$00,$0D,$00,$00,$48,$00,$1C,$00,$04,$00,$40
defb $40,$00,$01,$00,$00,$44,$00,$D0,$00,$04,$00,$40
defb $40,$00,$01,$00,$00,$54,$00,$15,$55,$04,$15,$40
defb $40,$00,$01,$00,$00,$45,$55,$50,$01,$04,$10,$40
defb $40,$00,$02,$00,$00,$40,$04,$D0,$01,$04,$10,$40
defb $40,$15,$55,$55,$55,$54,$04,$10,$01,$04,$10,$40
defb $40,$10,$0E,$00,$00,$04,$04,$00,$01,$08,$10,$40
defb $40,$10,$01,$00,$00,$04,$04,$00,$01,$65,$50,$40
defb $40,$10,$01,$00,$00,$04,$05,$50,$00,$08,$10,$40
defb $40,$10,$01,$00,$30,$04,$07,$10,$00,$04,$10,$40
defb $40,$10,$01,$95,$55,$55,$64,$15,$55,$54,$10,$40
defb $40,$10,$01,$00,$00,$04,$00,$1C,$00,$00,$10,$40
defb $40,$10,$01,$00,$00,$04,$00,$10,$00,$00,$10,$40
defb $40,$10,$01,$00,$00,$04,$00,$20,$00,$00,$10,$40
defb $40,$10,$01,$55,$55,$05,$55,$55,$55,$55,$90,$40
defb $40,$10,$01,$00,$00,$07,$00,$20,$00,$10,$10,$40
defb $40,$10,$01,$00,$00,$04,$00,$10,$00,$10,$10,$40
defb $40,$10,$01,$05,$55,$54,$00,$10,$00,$10,$10,$40
defb $40,$10,$01,$00,$00,$04,$00,$10,$00,$15,$50,$40
defb $40,$10,$01,$00,$00,$04,$00,$10,$00,$00,$00,$40
defb $40,$20,$01,$0C,$00,$04,$00,$10,$00,$00,$00,$40
defb $55,$55,$55,$55,$55,$66,$55,$55,$55,$55,$55,$40
defb $70,$00,$00,$00,$00,$04,$10,$00,$00,$00,$00,$40
defb $40,$00,$00,$00,$00,$04,$10,$00,$00,$00,$00,$40
defb $65,$55,$95,$95,$55,$54,$10,$55,$55,$55,$50,$40
defb $40,$41,$01,$00,$07,$04,$D0,$00,$00,$00,$10,$40
defb $40,$41,$01,$00,$04,$04,$10,$00,$00,$00,$10,$40
defb $40,$41,$01,$00,$04,$04,$15,$55,$55,$54,$10,$40
defb $40,$41,$01,$55,$04,$44,$10,$00,$00,$04,$10,$40
defb $40,$40,$01,$00,$04,$04,$10,$00,$00,$04,$10,$40
defb $40,$40,$01,$00,$04,$04,$10,$55,$55,$04,$10,$40
defb $40,$41,$55,$55,$04,$05,$50,$41,$0D,$04,$10,$40
defb $40,$41,$00,$41,$04,$04,$00,$55,$01,$04,$10,$40
defb $40,$41,$00,$41,$04,$04,$00,$00,$01,$04,$10,$40
defb $41,$41,$50,$71,$04,$04,$15,$55,$55,$04,$10,$40
defb $41,$00,$00,$55,$04,$04,$10,$00,$00,$04,$10,$40
defb $41,$55,$55,$40,$04,$54,$10,$00,$00,$04,$10,$40
defb $40,$00,$00,$40,$04,$4A,$50,$55,$55,$54,$10,$40
defb $55,$55,$55,$55,$55,$54,$00,$00,$00,$00,$10,$40
defb $43,$40,$00,$40,$00,$B4,$00,$00,$00,$00,$10,$40
defb $40,$40,$00,$40,$00,$45,$55,$55,$55,$55,$50,$40
defb $40,$00,$40,$00,$40,$64,$00,$00,$00,$00,$00,$40
defb $40,$00,$40,$00,$40,$44,$00,$00,$00,$00,$00,$40
defb $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$40

CHAR_TILES:

; TILE#0
defb '$' ; +0 (床：左上）
defb '$' ; +1（床：左下）
defb '$' ; +2（床：右上）
defb '$' ; +3（床：右下）

; TILE#1
defb '&' ; +4 (ブロック：左上)
defb '&' ; +5 (ブロック：左下)
defb '&' ; +6 (ブロック：右上)
defb '&' ; +7 (ブロック：右下)

; TILE#2
defb $71 ; +8（ドア：左上）
defb $72 ; +9（ドア；左下）
defb $73 ; +10（ドア：右上）
defb $74 ; +11（ドア：右下）

; TILE#3
defb $87 ; +12 (カギ：左上）
defb $88 ; +13 (カギ：左下)
defb $89 ; +14 (カギ：右上)
defb $8A ; +15 (カギ：右下)

; TILE#4
defb $75 ; +16（ドア：ゴール）
defb $76 ; +17（ドア：ゴール） 
defb $77 ; +18（ドア：ゴール）
defb $78 ; +19（ドア：ゴール）

; TILE#5
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用

; TILE#6
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用

; TILE#7
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用

; TILE#8
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用

; TILE#9
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用

; TILE#10
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用
defb $00 ; 未使用

; TILE#11
defb $98 ; ENEMY-TYPE1 上
defb $99 ; 
defb $9A ; 
defb $9B ; 

; TILE#12
defb $9C ; ENEMY-TYPE1 右
defb $9D ; 
defb $9E ; 
defb $9F ; 

; TILE#13
defb $A0 ; ENEMY-TYPE1 下
defb $A1 ; 
defb $A2 ; 
defb $A3 ; 

; TILE#14
defb $A4 ; ENEMY-TYPE1 右
defb $A5 ;
defb $A6 ;
defb $A7 ;

; TILE#15
defb $A8 ; ENEMY-TYPE2 上
defb $A9 ; 
defb $AA ; 
defb $AB ; 

; TILE#16
defb $AC ; ENEMY-TYPE2 右
defb $AD ; 
defb $AE ; 
defb $AF ; 

; TILE#17
defb $B0 ; ENEMY-TYPE2 下
defb $B1 ; 
defb $B2 ; 
defb $B3 ; 

; TILE#18
defb $B4 ; ENEMY-TYPE2 左
defb $B5 ; 
defb $B6 ; 
defb $B7 ; 

ENEMY_TILE_NUMBER_TYPE1:

; ENEMY-TYPE1のタイル番号

defb 0   ; 方向=0
defb 11  ; 方向=1
defb 0   ; 方向=2
defb 12  ; 方向=3
defb 0   ; 方向=4
defb 13  ; 方向=5
defb 0   ; 方向=6
defb 14  ; 方向=7
defb 0   ; 方向=8

ENEMY_TILE_NUMBER_TYPE2:

; ENEMY-TYPE2のタイル番号

defb 0   ; 方向=0
defb 15  ; 方向=1
defb 0   ; 方向=2
defb 16  ; 方向=3
defb 0   ; 方向=4
defb 17  ; 方向=5
defb 0   ; 方向=6
defb 18  ; 方向=7
defb 0   ; 方向=8

; テレポート位置格納用
TELEPORT_DATA:

; #0
defb  8, 33 ; テレポートゾーンMAP座標(X, Y)
defb  0, 35 ; テレポート後のビューポートMAP座標(X, Y)
defb  3, 13 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #1
defb  1, 40 ; テレポートゾーンMAP座標(X, Y)
defb  3, 29 ; テレポート後のビューポート座標(X, Y)
defb 11, 11 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #2
defb 21, 43 ; テレポートゾーンMAP座標(X, Y)
defb  9, 28 ; テレポート後のビューポートMAP座標(X, Y)
defb 11, 11 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #3
defb 13, 33 ; テレポートゾーンMAP座標(X, Y)
defb 13, 35 ; テレポート後のビューポートMAP座標(X, Y)
defb 17, 17 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #4
defb 14, 35 ; テレポートゾーンMAP座標(X, Y)
defb 20, 35 ; テレポート後のビューポートMAP座標(X, Y)
defb  7, 17 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #5
defb 23, 42 ; テレポートゾーンMAP座標(X, Y)
defb  9, 28 ; テレポート後のビューポートMAP座標(X, Y)
defb 11, 11 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #6
defb 21, 38 ; テレポートゾーンMAP座標(X, Y)
defb 22, 29 ; テレポート後のビューポートMAP座標(X, Y)
defb  3,  3 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #7
defb 24, 31 ; テレポートゾーンMAP座標(X, Y)
defb 18, 32 ; テレポート後のビューポートMAP座標(X, Y)
defb  9, 13 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #8
defb 43,  4 ; テレポートゾーンMAP座標(X, Y)
defb 18, 30 ; テレポート後のビューポートMAP座標(X, Y)
defb  3, 15 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #9
defb 19, 38 ; テレポートゾーンMAP座標(X, Y)
defb 35,  3 ; テレポート後のビューポートMAP座標(X, Y)
defb 15,  3 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #10
defb 21, 26 ; テレポートゾーンMAP座標(X, Y)
defb 35,  0 ; テレポート後のビューポートMAP座標(X, Y)
defb 17,  3 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #11
defb 43,  2 ; テレポートゾーンMAP座標(X, Y)
defb 18, 25 ; テレポート後のビューポートMAP座標(X, Y)
defb  5,  3 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #12
defb 21,  4 ; テレポートゾーンMAP座標(X, Y)
defb 20,  0 ; テレポート後のビューポートMAP座標(X, Y)
defb 15,  7 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）

; #13
defb 28,  3 ; テレポートゾーンMAP座標(X, Y)
defb 20,  0 ; テレポート後のビューポートMAP座標(X, Y)
defb  3, 11 ; テレポート後のプレイヤー座標(X, Y)
defb  0,  0 ; 未使用（予備）
