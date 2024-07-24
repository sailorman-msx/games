; --------------------------------------
; 三角関数関連
; --------------------------------------

; 固定小数点
;   小数点は以下のとおり
;   8.8固定小数点：
;      上位1バイトが整数値 -128から127まで
;      下位1バイトが小数値 第7ビットから
;        10000000B: 0.50000000
;        01000000B: 0.25000000
;        00100000B: 0.12500000
;        00010000B: 0.06250000
;        00001000B: 0.03125000
;        00000100B: 0.01562500
;        00000010B: 0.00781250
;        00000001B: 0.00390625
;   例) 
;      HL 01C0H = 1.75
;      DE 0080H = 0.50
;      ↓
;      ADD HL, DE
;      ↓
;      HLは0240Hになる
;      0240H = 2.25
;   
; 円周を64分割したラジアン角で算出した
; Y値とX値
;
; 角度 = 0 - 63
; RAD = 2π * 角度 / 64
;     = 3.141592 * 2 * 角度 / 64
; Y値 = COS(RAD)*256
; X値 = SIN(RAD)*256
;
; COS,SINの結果であるため-1から1の範囲となる
;
TRIGFUNC_TBL:
        ;Y      X      Y      X
    defw $0000, $0100, $0019, $00FE
    defw $0031, $00FB, $004A, $00F4
    defw $0061, $00EC, $0078, $00E1
    defw $008E, $00D4, $00A2, $00C5
    defw $00B5, $00B5, $00C5, $00A2
    defw $00D4, $008E, $00E1, $0078
    defw $00EC, $0061, $00F4, $004A
    defw $00FB, $0031, $00FE, $0019
    defw $0100, $0000, $00FE, $FFE6
    defw $00FB, $FFCE, $00F4, $FFB5
    defw $00EC, $FF9E, $00E1, $FF87
    defw $00D4, $FF71, $00C5, $FF5D
    defw $00B5, $FF4A, $00A2, $FF3A
    defw $008E, $FF2B, $0078, $FF1E
    defw $0061, $FF13, $004A, $FF0B
    defw $0031, $FF04, $0019, $FF01
    defw $0000, $FF00, $FFE6, $FF01
    defw $FFCE, $FF04, $FFB5, $FF0B
    defw $FF9E, $FF13, $FF87, $FF1E
    defw $FF71, $FF2B, $FF5D, $FF3A
    defw $FF4A, $FF4A, $FF3A, $FF5D
    defw $FF2B, $FF71, $FF1E, $FF87
    defw $FF13, $FF9E, $FF0B, $FFB5
    defw $FF04, $FFCE, $FF01, $FFE6
    defw $FF00, $FFFF, $FF01, $0019
    defw $FF04, $0031, $FF0B, $004A
    defw $FF13, $0061, $FF1E, $0078
    defw $FF2B, $008E, $FF3A, $00A2
    defw $FF4A, $00B5, $FF5D, $00C5
    defw $FF71, $00D4, $FF87, $00E1
    defw $FF9E, $00EC, $FFB5, $00F4
    defw $FFCE, $00FB, $FFE6, $00FE

