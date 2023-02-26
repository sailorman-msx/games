;
; BGM_00
; MML
;  TRK#1 : T160 O5 F8 R8 F8 C8 D8 C8 R8 C8 F8 R8 F8 C8 D8 C8 R8 C8 E8 D8 E8 F8 R8
;  TRK#2 : T160 O3 F8 F8 C8 C8 F8 F8 C8 C8 F8 F8 C8 C8 F8 F8 C8 C8 E8 D8 E8 F8 R8
;  TRK#3 : None
;
BGM_00:
    defb 0
    defw BGM00_TRK_1
    defw BGM00_TRK_2
    defw 0

BGM00_TRK_1:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 210      ; Volume = 10
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; テンポ T160 = 160/60 = 2.6 -> 8分音符=30/2.6=約12
    defb 200      ; Volume = 0 休符がわからないのでvol.を0にする
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 51       ; Tone Index=51 -> O5 D
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 49       ; Tone Index=549-> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; テンポ T160 = 160/60 = 2.6 -> 8分音符=30/2.6=約12
    defb 200      ; Volume = 0 休符がわからないのでvol.を0にする
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 51       ; Tone Index=51 -> O5 D
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; テンポ T160 = 160/60 = 2.6 -> 8分音符=30/2.6=約12
    defb 200      ; Volume = 0 休符がわからないのでvol.を0にする
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 51       ; Tone Index=51 -> O5 D
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 49       ; Tone Index=49 -> O5 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 52       ; Tone Index=52 -> O5 E
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 50       ; Tone Index=50 -> O5 D
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 52       ; Tone Index=52 -> O5 E
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 53       ; Tone Index=53 -> O5 F
    defb 12       ; 
    defb 254      ; End of Data

BGM00_TRK_2:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; テンポ T160 = 160/60 = 2.6 -> 8分音符=30/2.6=約12
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 24       ; Tone Index=24 -> O3 C
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 28       ; Tone Index=28 -> O3 E
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 26       ; Tone Index=26 -> O3 D
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 28       ; Tone Index=28 -> O3 E
    defb 12       ; 
    defb 210      ; Volume = 10
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 200      ; Volume = 0 休符
    defb 29       ; Tone Index=29 -> O3 F
    defb 12       ; 
    defb 254      ; End of Data
;
; SFX_00 : テキキャラとの衝突時の音
; MML
;  TRK#1 : None
;  TRK#2 : T160 O3 D16 C16 R16
;  TRK#3 : T160 O2 R16 C16 R16
;
SFX_00:
    defb 255 ; Priority
    defw 0
    defw SFX00_TRK_1
    defw SFX00_TRK_2

SFX00_TRK_1:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 215      ; Volume = 10
    defb 26       ; O3 D16
    defb 3        ; 
    defb 212      ; Volume = 10
    defb 24       ; O3 C16
    defb 3        ; 
    defb 210      ; Volume = 0 休符
    defb 24       ; 
    defb 3        ; 
    defb 255      ; End of Data

SFX00_TRK_2:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 210      ; Volume = 0 休符
    defb 26       ; 
    defb 3        ; 
    defb 212      ; Volume = 10
    defb 24       ; O2 C16
    defb 3        ; 
    defb 210      ; Volume = 0 休符
    defb 24       ; 
    defb 3        ; 
    defb 255      ; End of Data

;
;
; SFX_01 : 弾の発射音
; MML
;  TRK#1 : None
;  TRK#2 : None
;  TRK#3 : T160 O8 E16 F16
;
SFX_01:
    defb 255 ; Priority
    defw 0
    defw 0
    defw SFX01_TRK_3

SFX01_TRK_3:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 215      ; Volume = 15
    defb 88       ; O8 E16
    defb 3        ; 
    defb 212      ; Volume = 12
    defb 89       ; O8 F16
    defb 3        ; 
    defb 210      ; Volume = 0 休符
    defb 89       ; 
    defb 3        ; 
    defb 255      ; End of Data

; SFX_02 : テキキャラに弾が当たった音
; MML
;  TRK#1 : None
;  TRK#2 : None
;  TRK#3 : T160 O8 F16 G16 F16 G16
;
SFX_02:
    defb 255 ; Priority
    defw 0
    defw 0
    defw SFX01_TRK_3

SFX02_TRK_3:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 215      ; Volume = 15
    defb 89       ; O8 F16
    defb 3        ; 
    defb 212      ; Volume = 12
    defb 90       ; O8 G16
    defb 3        ; 
    defb 215      ; Volume = 15
    defb 89       ; O8 F16
    defb 3        ; 
    defb 212      ; Volume = 12
    defb 90       ; O8 G16
    defb 3        ; 
    defb 210      ; Volume = 0 休符
    defb 89       ; 
    defb 3        ; 
    defb 255      ; End of Data

; SFX_03 : ドアが開く音
; MML
; "T120O6C16R16C16D16D8", "T120O5C16R16C16D16D8"
;
;  TRK#1 : None
;  TRK#2 : T160 O6 C16 R16 C16 D16 D8
;  TRK#3 : T160 O5 C16 R16 C16 D16 D8
;
SFX_03:
    defb 255 ; Priority
    defw 0
    defw SFX03_TRK_2
    defw SFX03_TRK_3
SFX03_TRK_2:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 214      ; Volume = 14
    defb 60       ; O6 C16
    defb 3
    defb 210      ; 休符
    defb 60
    defb 3
    defb 214      ; Volume = 14
    defb 60       ; O6 C16
    defb 3
    defb 214      ; Volume = 14
    defb 62       ; O6 D16
    defb 3
    defb 214      ; Volume = 14
    defb 62       ; O6 D8
    defb 6
    defb 255      ; End of Data
SFX03_TRK_3:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 214      ; Volume = 14
    defb 48       ; O5 C16
    defb 3
    defb 210      ; 休符
    defb 48
    defb 3
    defb 214      ; Volume = 14
    defb 48       ; O5 C16
    defb 3
    defb 214      ; Volume = 14
    defb 50       ; O5 D16
    defb 3
    defb 214      ; Volume = 14
    defb 50       ; O6 D8
    defb 6
    defb 255      ; End of Data

; SFX_04 : テレポート音
; MML
; "T160O6D#16D16C#16C16R16C16C#16D16D#8", "T160O4D#16D16C#16C16R16C16C#16D16D#8"
;
;  TRK#1 : None
;  TRK#2 : T160 O6 D#16 R16 C#16 C16 R16 C16 C#16 D16 D#8
;  TRK#3 : T160 O4 D#8      C#16 C16 R16 C16 C#16 D16 D#8
;
SFX_04:
    defb 255 ; Priority
    defw 0
    defw SFX04_TRK_2
    defw SFX04_TRK_3
SFX04_TRK_2:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 214      ; Volume = 14
    defb 63       ; T160 O6 D#16
    defb  3
    defb 210      ; 休符
    defb 63       ;
    defb  3
    defb 214      ; Volume = 14
    defb 61       ; T160 O6 C#16
    defb  3
    defb 214      ; Volume = 14
    defb 60       ; T160 O6 C16
    defb  3
    defb 210      ; 休符
    defb 60       ; 
    defb  3
    defb 214      ; Volume = 14
    defb 60       ; T160 O6 C16
    defb  3
    defb 214      ; Volume = 14
    defb 61       ; T160 O6 C#16
    defb  3
    defb 214      ; Volume = 14
    defb 62       ; T160 O6 D16
    defb  3
    defb 214      ; Volume = 14
    defb 63       ; T160 O6 D#8
    defb  6
    defb 255      ; End of Data
SFX04_TRK_3:
    defb 217, 10B ; Mixing Tone/Noise off
    defb 214      ; Volume = 14
    defb 39       ; T160 O4 D#16
    defb  3
    defb 210      ; 休符
    defb 39       ;
    defb  3
    defb 214      ; Volume = 14
    defb 37       ; T160 O4 C#16
    defb  3
    defb 214      ; Volume = 14
    defb 36       ; T160 O4 C16
    defb  3
    defb 210      ; 休符
    defb 60       ; 
    defb  3
    defb 214      ; Volume = 14
    defb 36       ; T160 O4 C16
    defb  3
    defb 214      ; Volume = 14
    defb 37       ; T160 O4 C#16
    defb  3
    defb 214      ; Volume = 14
    defb 38       ; T160 O4 D16
    defb  3
    defb 214      ; Volume = 14
    defb 39       ; T160 O4 D#8
    defb  6
    defb 255      ; End of Data
