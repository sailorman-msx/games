;---------------------------------------------
; VRAM関連サブルーチン群
;---------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: VDPRED
; VDPポート#1に対してREAD宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPRED:

    push af
    
    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (04)
    nop                        ; (04)
    nop                        ; (04)

    ld a, h                    ; 下位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (04)
    nop                        ; (04)
    nop                        ; (04)

    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: VDPWRT
; VDPポート#1に対してWRITE宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPWRT:

    push af

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (04)
    nop                        ; (04)
    nop                        ; (04)

    ld a, h                    ; 上位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    or  $40                    ; 第6ビットを1にする(WRITE-MODE)
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (04)
    nop                        ; (04)
    nop                        ; (04)

    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: REDVRM
; HLレジスタにセットされたVRAMアドレスの
; 値を1バイトだけ読み込みAレジスタに格納する
; HLレジスタは読み込み後インクリメントされる
;--------------------------------------------
REDVRM:

    ; 読み込み宣言
    call VDPRED

    ; 読み込み
    in a, (CONST_VDPPORT0)    ; (12)
    nop                       ; (04)
    nop                       ; (04)
    nop                       ; (04)

    ret

;--------------------------------------------
; SUB-ROUTINE: WRTVRM
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値を1バイトだけ書き込む
; HLレジスタは書き込み後インクリメントされる
;--------------------------------------------
WRTVRM:
    
    ; 書き込み宣言
    call VDPWRT

    ; 読み込み
    out (CONST_VDPPORT0), a   ; (12)
    nop                       ; (04)
    nop                       ; (04)
    nop                       ; (04)

    ret

;---------------------------------------------------
; SUB-ROUTINE: REDVRMSERIAL
; HLレジスタにセットされたメモリアドレスに
; DEレジスタで指定されたVRAMアドレスの内容を
; BCレジスタの値だけ連続して読み込む
; HLレジスタとDEレジスタは
; 書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
REDVRMSERIAL:

    ; HLレジスタの値を退避
    ld (WK_HLREGBACK), hl

    ; HLレジスタにVRAMアドレスをセット
    ld hl, de

    ; 読み込み宣言
    call VDPRED

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (WK_HLREGBACK)

REDVRMSERIALLOOP:

    in a, (CONST_VDPPORT0)     ; (12)
    ld (hl), a                 ; (07)

    cpi                        ; (16)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, REDVRMSERIALLOOP

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMFIL
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値をBCレジスタの値だけ連続して書き込む
; HLレジスタは書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMFIL:

    ; 書き込み宣言
    call VDPWRT

WRTVRMFILLOOP:

    out (CONST_VDPPORT0), a    ; (12)
    cpi                        ; (16)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMFILLOOP

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMSERIAL
; HLレジスタにセットされたメモリアドレスの値を
; DEレジスタにセットされたVRAMアドレスに
; BCレジスタの値だけ連続して書き込む
; HLレジスタとDEレジスタは書き込み後
; BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMSERIAL:

    ; HLレジスタの値を退避
    ld (WK_HLREGBACK), hl

    ; HLレジスタにVRAMアドレスをセット
    ld hl, de

    ; 読み込み宣言
    call VDPWRT

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (WK_HLREGBACK)

WRTVRMSERIALLOOP:

    ld a, (hl)
    out (CONST_VDPPORT0), a     ; (12)

    cpi                         ; (16)
                                ; HL = HL + 1, BC = BC - 1
                                ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMSERIALLOOP

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
   call REDVRM
   ld (ix+$01), a
   call REDVRM
   ld (ix+$02), a
   call REDVRM
   ld (ix+$03), a

   ; 指定されたY座標の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   call REDVRM
   ld (ix+$04), a
   call REDVRM
   ld (ix+$05), a
   call REDVRM
   ld (ix+$06), a
   call REDVRM
   ld (ix+$07), a

   ; 指定されたY座標の1行下の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   call REDVRM
   ld (ix+$08), a
   call REDVRM
   ld (ix+$09), a
   call REDVRM
   ld (ix+$0A), a
   call REDVRM
   ld (ix+$0B), a

   ; 指定されたY座標の2行下の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   call REDVRM
   ld (ix+$0C), a
   call REDVRM
   ld (ix+$0D), a
   call REDVRM
   ld (ix+$0E), a
   call REDVRM
   ld (ix+$0F), a

   pop de
   pop hl
   pop iy
   pop ix

   ret
