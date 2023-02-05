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
    defb 254      ; End of Data
