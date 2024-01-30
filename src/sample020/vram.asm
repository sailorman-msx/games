;---------------------------------------------
; VRAM関連サブルーチン群
; ()内はMSX1でのステート数
; MSX1とそれ以外ではステート数が異なる
; 参考：https://taku.izumisawa.jp/Msx/ktecho2
;---------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: VDPRED
; VDPポート#1に対してREAD宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPRED:

    push af
    push bc
    push de
    
    di

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 下位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: VDPWRT
; VDPポート#1に対してWRITE宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPWRT:

    push af
    push bc
    push de

    di

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ; WAIT追加
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 上位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    or  $40                    ; 第6ビットを1にする(WRITE-MODE)
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ; WAIT追加
    nop                        ; (05)
    nop                        ; (05)

    pop de
    pop bc
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
    nop                       ; (05)
    nop                       ; (05)

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

    ; 書き込み
    out (CONST_VDPPORT0), a   ; (12)
    nop                       ; (05)
    nop                       ; (05)

    ; WAIT追加
    nop
    nop
    ei

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

    ld a, (WK_VRAM_SYNC)
    or a
    jr nz, REDVRMSERIAL_End

    ld a, 1
    ld (WK_VRAM_SYNC), a

    ; HLレジスタの値を退避
    push hl

    ; HLレジスタにVRAMアドレスをセット
    ld hl, de

    ; 読み込み宣言
    call VDPRED

    ; HLレジスタに退避したメモリアドレスをセット
    pop hl

REDVRMSERIALLOOP:

    in a, (CONST_VDPPORT0)     ; (12)
    ld (hl), a                 ; (8)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, REDVRMSERIALLOOP

    xor a
    ld (WK_VRAM_SYNC), a

REDVRMSERIAL_End:

    ei

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMFIL
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値をBCレジスタの値だけ連続して書き込む
; HLレジスタは書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMFIL:

    ld d, a

    ld a, (WK_VRAM_SYNC)
    or a
    jr nz, WRTVRMFIL_End

    ld a, 1
    ld (WK_VRAM_SYNC), a

    ld a, d

    ; 書き込み宣言
    call VDPWRT

WRTVRMFILLOOP:

    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMFILLOOP

    xor a
    ld (WK_VRAM_SYNC), a

WRTVRMFIL_End:

    ei

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

    ld a, (WK_VRAM_SYNC)
    or a
    jr nz, WRTVRMSERIAL_End

    ld a, 1
    ld (WK_VRAM_SYNC), a

    ; HLレジスタの値を退避
    push hl

    ; HLレジスタにVRAMアドレスをセット
    ld hl, de

    ; 読み込み宣言
    call VDPWRT

    ; HLレジスタに退避したメモリアドレスをセット
    pop hl

WRTVRMSERIALLOOP:

    ld a, (hl)
    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMSERIALLOOP

    xor a
    ld (WK_VRAM_SYNC), a

WRTVRMSERIAL_End:

    ei

    ret

;---------------------------------------------
; SUB-ROUTINE:GetVRAM4x4
; 指定したX座標、Y座標周辺の画面情報を
; 4x4のTBLに格納する
;
; WK_CHECKPOSX, WK_CHECKPOSYに座標値をセットして
; から呼び出すこと
;
; 仮想パターンネームテーブルを元にする
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

   push de
   push hl
   push ix
   push iy

   ; AレジスタにY座標をセット
   ld a, (WK_CHECKPOSY)
   dec a 

   ld hl, 0

   ; 画面の行を進める
   ; ld e, a
   ; ld h, 32
   ; call CalcMulti

   ld h, 0
   ld l, a
   add hl, hl ; x2
   add hl, hl ; x4
   add hl, hl ; x8
   add hl, hl ; x16
   add hl, hl ; x32

   ; AレジスタにX座標をセット
   ld a, (WK_CHECKPOSX)
   dec a
   ld d, 0
   ld e, a

   ; アドレスをHLレジスタに加算する
   ; このアドレスがWK_VRAM4X4_TBLの00の箇所に該当する
   add hl, de
   ld de, WK_VIRT_PTNNAMETBL
   add hl, de

   ; DEレジスタにWK_VRAM4X4_TBLのアドレスをセット
   ld de, WK_VRAM4X4_TBL

   ; WK_VRAM4X4_TBLに仮想VRAMの値をセットする
   ; 指定されたY座標の1行上の情報をTBLにセット

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc de

   ; 指定されたY座標の情報の値をセットする
   add hl, 29 ; HLレジスタに29を加算する

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc de

   ; 指定されたY座標の1行下の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc de

   ; 指定されたY座標の2行下の情報の値をセットする

   add hl, 29 ; HLレジスタに29を加算する

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc hl
   inc de

   ld a, (hl)
   ld (de), a
   inc de

   pop iy
   pop ix
   pop hl
   pop de

   ret

;--------------------------------------------
; SUB-ROUTINE: ClearScreen
; 画面をブランク($20)で塗りつぶす
;--------------------------------------------
ClearScreen:

    ld hl, WK_VIRT_PTNNAMETBL + 32 * 3
    ld bc, 768 - 32 * 3
    ld a, $20
    call MemFil

    ret

;--------------------------------------------
; SUB-ROUTINE: ClearSprite
; スプライトアトリビュートテーブルを
; 初期化する
; 初期化の対象はWK_VIRT_SPRATTRTBLとする
;--------------------------------------------
ClearSprite:

    ld b, 32

    ld hl, WK_VIRT_SPRATTRTBL

    ld b, 32
    ld c, 0

ClearSpriteLoop:

    ld a, 209
    ld (hl), a ; Y座標
    xor a
    inc hl
    ld (hl), a ; X座標
    inc hl
    ld (hl), a ; パターン番号
    inc hl
    ld (hl), a ; カラー番号
    inc hl

    djnz ClearSpriteLoop

ClearSpriteEnd:

    ; スプライト再描画フラグをONにして
    ; 次のVBLANKでVRAMに反映させる
    ld a, 1
    ld (WK_SPRREDRAW_FINE), a

    ret

;--------------------------------------------
; SUB-ROUTINE: PutSprite
; 仮想スプライトアトリビュートテーブル
; の内容をVRAM 1B00Hに128バイト分転送する
;--------------------------------------------
PutSprite:
    
    ld hl, WK_VIRT_SPRATTRTBL
    ld de, $1B00
    ld bc, 128
    call WRTVRMSERIAL

    ret

;--------------------------------------------
; SUB-ROUTINE: PutPatternNameTable
; 仮想パターンネームテーブルから768バイト分を
; VRAM 1800Hに転送する
;--------------------------------------------
PutPatternNameTable:

    ld hl, WK_VIRT_PTNNAMETBL
    ld de, $1800
    ld bc, 768
    call WRTVRMSERIAL

    ret
