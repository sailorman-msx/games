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

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 上位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    or  $40                    ; 第6ビットを1にする(WRITE-MODE)
    
    out (CONST_VDPPORT1), a    ; (12)
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

    ; 読み込み
    out (CONST_VDPPORT0), a   ; (12)
    nop                       ; (05)
    nop                       ; (05)

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
    ld (hl), a                 ; (8)

    cpi                        ; (18)
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

    cpi                        ; (18)
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
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPWRT

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (WK_HLREGBACK)

WRTVRMSERIALLOOP:

    ld a, (hl)
    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMSERIALLOOP

    ret
