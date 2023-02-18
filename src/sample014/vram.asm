;---------------------------------------------
; VRAM関連サブルーチン群
;---------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: PutVRAM256Bytes
; HLレジスタで指定したVRAMアドレスから
; Aレジスタの値を256文字分書き込む
;--------------------------------------------
PutVRAM256Bytes:

    push af
    push bc
    push de
    push hl

    ld  b, $00

PutVRAM256BytesLoop:

    call WRTVRM
    inc hl

    djnz PutVRAM256BytesLoop

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------
; SUB-ROUTINE:GetVRAM4x4
; 指定したX座標、Y座標周辺の画面情報を
; 4x4のTBLに格納する
;
; WK_CHECKPOSX, WK_CHECKPOSYに座標値をセットして
; から呼び出すこと
; 
; WK_VRAM4X4_TBL
;
; +--+--+--+--+
; |00|01|02|03|
; +--+--+--+--+
; |04|05|06|07| <- 05がX座標、Y座標に対応
; +--+--+--+--+
; |08|09|0A|0B|
; +--+--+--+--+
; |0C|0D|0E|0F|
; +--+--+--+--+
;
; 注意：
; WK_CHECKPOSX, WK_CHECKPOSYは1以上の値とすること
;
;---------------------------------------------
GetVRAM4x4:

   push ix
   push iy
   push hl
   push de

   ; IXレジスタにWK_VRAM4X4_TBLのアドレスをセット
   ld ix, WK_VRAM4X4_TBL

   ; AレジスタにY座標をセット
   ld a, (WK_CHECKPOSY)
   dec a 

   ld hl, 0

   ; 画面の行を進める

GetVRAM4x4Loop1:

   or 0
   jr z, GetVRAM4x4Loop1End
   add hl, $20
   
   dec a
   jr GetVRAM4x4Loop1

GetVRAM4x4Loop1End:

   ; AレジスタにX座標をセット
   ld a, (WK_CHECKPOSX)
   dec a

   ld  b, 0
   ld  c, a

   add hl, bc

   ; VRAMアドレスをHLレジスタに加算する
   ; このアドレスがWK_VRAM4X4_TBLの00の箇所に該当する
   ld bc, $1800
   add hl, bc

   ; WK_VRAM4X4_TBLにVRAMの値をセットする

   ; 指定されたY座標の1行上の情報をTBLにセット

   call REDVRM
   ld (ix), a
   inc hl
   call REDVRM
   ld (ix+$01), a
   inc hl
   call REDVRM
   ld (ix+$02), a
   inc hl
   call REDVRM
   ld (ix+$03), a

   ; 指定されたY座標の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   call REDVRM
   ld (ix+$04), a
   inc hl
   call REDVRM
   ld (ix+$05), a
   inc hl
   call REDVRM
   ld (ix+$06), a
   inc hl
   call REDVRM
   ld (ix+$07), a

   ; 指定されたY座標の1行下の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   call REDVRM
   ld (ix+$08), a
   inc hl
   call REDVRM
   ld (ix+$09), a
   inc hl
   call REDVRM
   ld (ix+$0A), a
   inc hl
   call REDVRM
   ld (ix+$0B), a

   ; 指定されたY座標の2行下の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   call REDVRM
   ld (ix+$0C), a
   inc hl
   call REDVRM
   ld (ix+$0D), a
   inc hl
   call REDVRM
   ld (ix+$0E), a
   inc hl
   call REDVRM
   ld (ix+$0F), a

   pop de
   pop hl
   pop iy
   pop ix

   ret
