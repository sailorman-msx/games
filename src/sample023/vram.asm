
;---------------------------------------------
; VRAM関連サブルーチン群
; ()内はMSX1でのステート数
; MSX1とそれ以外ではステート数が異なる
; 参考：https://taku.izumisawa.jp/Msx/ktecho2
;---------------------------------------------

; これらの処理がよばれるとDIされる
; 呼び出したあとに適宜、EIを実施すること

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
    ld h, d
    ld l, e

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
    ld h, d
    ld l, e

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

    ret

;---------------------------------------------
; SUB-ROUTINE:GetVRAM6x6
; 指定したX座標、Y座標周辺の画面情報を
; 4x6のTBLに格納する
;
; WK_CHECKPOSX, WK_CHECKPOSYに座標値をセットして
; から呼び出すこと
;
; 仮想パターンネームテーブルを元にする
; 
; WK_VRAM4X6_TBL
;
; +--+--+--+--+
; |00|01|02|03|
; +--+--+--+--+
; |04|05|06|07| <- 05がX座標(CHECKPOSX)、Y座標(CHECKPOSY)に対応
; +--+--+--+--+
; |08|09|0A|0B|
; +--+--+--+--+
; |0C|0D|0E|0F|
; +--+--+--+--+
; |10|11|12|13|
; +--+--+--+--+
; |14|15|16|17|
; +--+--+--+--+
;
; 当たり判定では00,03,
;
; 注意：
; WK_CHECKPOSX, WK_CHECKPOSYは1以上の値とすること
;
;---------------------------------------------
GetVRAM4x6:

   push bc
   push de
   push hl

   ; VRAM4X6テーブルを初期化する
   ld hl, WK_VRAM4X6_TBL
   ld bc, 28
   ld a, $20
   call MemFil

   ; AレジスタにY座標をセット
   ; Y座標が0以下なら何もしない
   ld a, (WK_CHECKPOSY)
   cp 1
   jr c, GetVRAM4x6LoopEnd

   dec a 

   ld hl, 0

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
   ; このアドレスがWK_VRAM4X6_TBLの00の箇所に該当する
   add hl, de

   ld de, WK_VIRT_PTNNAMETBL
   add hl, de

   ld bc, 28

   ; DEレジスタにWK_VRAM4X6_TBLのアドレスをセット
   ld de, WK_VRAM4X6_TBL

   ; WK_VRAM4X6_TBLに仮想VRAMの値をセットする
   ld a, 6
   ld (WK_VALUE01), a

GetVRAM4x6Loop:

   ld a, (hl)
   ld (de), a
   inc hl
   inc e

   ld a, (hl)
   ld (de), a
   inc hl
   inc e

   ld a, (hl)
   ld (de), a
   inc hl
   inc e

   ld a, (hl)
   ld (de), a
   inc hl
   inc e

   add hl, bc

   ld a, (WK_VALUE01)
   dec a

   or a
   jr z, GetVRAM4x6LoopEnd

   ld (WK_VALUE01), a

   jr GetVRAM4x6Loop

GetVRAM4x6LoopEnd:

   pop hl
   pop de
   pop bc

   ret

;--------------------------------------------
; SUB-ROUTINE: ClearScreen
; 画面をブランク('a')で塗りつぶす
;--------------------------------------------
ClearScreen:

    ld hl, WK_VIRT_PTNNAMETBL
    ld bc, 768
    ld a, 'a'
    call MemFil

    ret

;--------------------------------------------
; SUB-ROUTINE: ClearSprite
; スプライトアトリビュートテーブルを
; 初期化する
; 初期化の対象はWK_VIRT_SPRATTRTBLとする
;--------------------------------------------
ClearSprite:

    ld hl, WK_VIRT_SPRATTRTBL

    ld b, 32
    ld c, 0

ClearSpriteLoop:

    ld a, 209
    ld (hl), a ; Y座標
    xor a
    inc l
    ld (hl), a ; X座標
    inc l
    ld (hl), a ; パターン番号
    inc l
    ld (hl), a ; カラー番号
    inc l

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
