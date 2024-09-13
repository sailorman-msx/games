; BIOSルーチン
CHGMOD:equ $005F ; SCREENモードを変更する
SETGRP:equ $007E ; VDPのみをGRAPHIC2モードにする
ERAFNK:EQU $00CC ;ファンクションキーを非表示にする

; ワークエリア
LINWID:equ $F3AF ; WIDTHで設定する1行の幅が格納されているアドレス
RG0SAV:equ $F3DF ; VDPレジスタ#0の値が格納されているアドレス
FORCLR:equ $F3E9 ; 前景色が格納されているアドレス
BAKCLR:EQU $F3EA ; 背景色のアドレス
BDRCLR:equ $F3EB ; 背景色が格納されているアドレス
CLIKSW:equ $F3DB ; キークリック音のON/OFFが格納されているアドレス
INTCNT:equ $FCA2 ; MSX BIOSにて1/60秒ごとにインクリメントされる値が格納されているアドレス
H_TIMI:equ $FD9F ; 垂直帰線割り込みフック

CONST_VDPPORT0:equ $98
CONST_VDPPORT1:equ $99

; プログラムの開始位置アドレスは0x4000
org $4000

Header:

    ; MSX の ROM ヘッダ (16 bytes)
    ; プログラムの先頭位置は0x4010
    defb 'A', 'B', $10, $40, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00

Start:

    ; スタックポインタを初期化
    ld sp, $F380

    ; カラーを変更する
    ld a, $0F
    ld (FORCLR), a   ;白色
    ld a, $01
    ld (BAKCLR), a   ;黒色
    ld (BDRCLR), a   ;黒色

    ; WIDTH変更
    ld a, 32         ;WIDTH=32
    ld (LINWID), a

    ; ファンクションキー情報を消す
    CALL ERAFNK

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a  ;スプライトモードを16X16に

    ; SCREEN1モードに変更する
    ld a, 1
    call CHGMOD

    ; GRAPHIC2モードに変更する
    call SETGRP

    ; カチカチ音を消す
    xor a
    ld (CLIKSW), a

    ; VRAM書き込み同期フラグの初期化
    xor a
    ld (WK_VRAM_SYNC), a

    ; 画面再描画フラグの初期化
    ld (WK_REDRAW_FINE), a

    di

    ; VRAMのキャラクタパターン上中下の情報を作成する
    ;----------------------------------------
    ; パターンジェネレータテーブルの初期化
    ;----------------------------------------
    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAMからRAMにコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_UNIONRAM
    ld de, $0000
    ld bc, $0800
    call REDVRMSERIAL 

    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（中段）にコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_UNIONRAM
    ld de, $0800
    ld bc, $0800
    call WRTVRMSERIAL 
    
    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（下段）にコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_UNIONRAM
    ld de, $1000
    ld bc, $0800
    call WRTVRMSERIAL
    
    ;----------------------------------------
    ; カラーテーブルの初期化
    ; カラーテーブルは
    ; 全ライン前景色白、背景色黒にする
    ;----------------------------------------
    ld hl, $2000
    ld bc, $1800 ; 256 x 3 x 8 = 6144 = 1800H
    ld  a, $F1
    call WRTVRMFIL
    
    ; パターンジェネレータテーブルのデータを
    ; 仮想VRAMに作成する
    ; 上中下段分を作成する

    ld hl, WK_VIRT_VRAM_UP
    ld bc, $800 * 3
    ld a, 0
    call MemFil

    ; 再描画フラグをONにしておく
    ; こうすることで画面はまっさらになる
    ld a, 1
    ld (WK_REDRAW_FINE), a

    ; VRAM転写アドレスを初期化する
    ld hl, WK_VIRT_VRAM_UP
    ld a, l
    ld (WK_VIRT_VRAM_ADR), a
    ld a, h
    ld (WK_VIRT_VRAM_ADR+1), a

    ; VRAM転送先アドレスを初期化する
    ld h, 0
    ld l, 0
    ld (WK_CHRPTN_VRAM_ADR), hl

    ; H.TIMI書き換え
    call INIT_H_TIMI_HANDLER

    ei

    xor a
    ld (VSYNC_WAIT_CNT), a

;----------------------------------
; メイン処理
; ランダムな座標に点をプロットする
;----------------------------------
MainLoop:

MainLoopDotPlot:

    ; X座標をランダムに取得
MainLoopSetX:

    call RandomValue
    ld (WK_PLOT_X), a

    ; Y座標をランダムに取得
    ; 192以上だったら取得しなおす
MainLoopSetY:

    call RandomValue
    cp 192
    jr nc, MainLoopSetY

    ld (WK_PLOT_Y), a
    call DotPlot

PermanentLoop:
    jr MainLoopDotPlot

;-------------------------------
; 画面再描画処理
;-------------------------------
RedrawScreen:

    ;------------------------------------------
    ; ネームテーブル上中下段に文字を表示させる
    ;------------------------------------------
    ld b, 0
    ld c, 3
    ld hl, $1800

NameTableFillLoop:

    push bc
    push hl
    ld a, b
    call WRTVRM
    pop hl
    pop bc

    inc hl
    inc b
    ld a, b
    or a
    jr nz, NameTableFillLoop

    dec c
    jr nz, NameTableFillLoop

    ret

;-------------------------------
; H.TIMI書き換え
;-------------------------------
INIT_H_TIMI_HANDLER:

    push af
    push bc
    push de
    push hl

    di

    ; ■H.TIMIバックアップ
    ld hl, H_TIMI                   ; 転送元
    ld de, H_TIMI_BACKUP            ; 転送先
    ld bc, 5                        ; 転送バイト数
    ldir

    ; ■H.TIMI書き換え
    ld a, $C3                        ; JP
    ld hl, H_TIMI_HANDLER            ; サウンドドライバのアドレス
    ld (H_TIMI + 0), a
    ld (H_TIMI + 1), hl

    ei

    pop hl
    pop de
    pop bc
    pop af

    ret

H_TIMI_HANDLER:

    push af

    ; VSYNC_WAIT_CNTデクリメント
    ;   1/60ごとに-1される
    ;   メインルーチンの最初の設定値により
    ;     1 = 60フレーム
    ;     2 = 30フレーム
    ;   の処理となる
    ld a, (VSYNC_WAIT_CNT)
    or a
    jr z, H_TIMI_HANDLER_L1
    dec a
    ld (VSYNC_WAIT_CNT), a

H_TIMI_HANDLER_L1:

ApplyVirtVRAM:

    ; 再描画フラグがONであれば
    ; 仮想VRAMの情報を反映させる

    ld a, (WK_REDRAW_FINE)
    cp 1
    jr c, ApplyVirtVRAMEnd

    ; パターンジェネレータテーブルを転写する
    ; 仮想VRAMは6KBもある
    ; VBLANKのタイミングで6KBの転写はリスクありすぎるので
    ; 1KBずつの転写にする

    ; パターンジェネレータテーブルの転写
    ld hl, (WK_CHRPTN_VRAM_ADR)
    ld de, hl
    ld hl, (WK_VIRT_VRAM_ADR)
    ld bc, 1024
    call WRTVRMSERIAL

    ; 仮想VRAMの最後まで転写したら
    ; いちばん最初の転写に戻す
    or a ; CY reset
    ld bc, $D500
    ld hl, (WK_VIRT_VRAM_ADR)
    sbc hl, bc
    jr nz, ApplyVirtVRAMSetNext

    ; VRAM転送元アドレスとVRAM転送先アドレスを初期化する
    ld hl, WK_VIRT_VRAM_UP
    ld (WK_VIRT_VRAM_ADR), hl
    xor a
    ld (WK_CHRPTN_VRAM_ADR), a
    ld (WK_CHRPTN_VRAM_ADR+1), a

    jr ExecRedraw

ApplyVirtVRAMSetNext:

    ; 次に転写する仮想VRAMのアドレスをセットする
    ld bc, 1024
    ld hl, (WK_VIRT_VRAM_ADR)
    add hl, bc
    ld (WK_VIRT_VRAM_ADR), hl

    ld hl, (WK_CHRPTN_VRAM_ADR)
    add hl, bc
    ld (WK_CHRPTN_VRAM_ADR), hl

ExecRedraw:

    ; 画面全体を再描画する
    call RedrawScreen

    ; 画面再描画フラグをOFFにする
    xor a
    ld (WK_REDRAW_FINE), a

ApplyVirtVRAMEnd:

    ; 割り込み処理の終了後は必ずEIを実施する
    ei
    
    pop af
    
    jp H_TIMI_BACKUP

;--------------------------------------------
; SUB-ROUTINE: DotPlot
; ドットをX、Y座標にプロットする
; X座標: WK_PLOT_X
; Y座標: WK_PLOT_Y
;--------------------------------------------
DotPlot:

    push af
    push bc
    push de
    push hl

    ; X座標を8で割り、商をBレジスタにセットする
    ld a, (WK_PLOT_X)
    srl a ; / 2
    srl a ; / 4
    srl a ; / 8
    ld b, a

    ; Y座標を8で割り、商をeレジスタにセットする
    ld a, (WK_PLOT_Y)
    srl a ; / 2
    srl a ; / 4
    srl a ; / 8
    ld e, a

    ; WK_PLOT_X - B*8
    sla b ; B = B * 2
    sla b ; B = B * 4
    sla b ; B = B * 8

    ; B*8の値をLレジスタにセットする
    ld l, b

    ld a, (WK_PLOT_X)
    sub b ; A = WK_PLOT_X - B*8
    sub 8 ; A = ABS(A - 8)
    neg
    ld d, a ; Dはプロット対象ビット番号
    
    ;
    ; パターンジェネレータテーブルの先頭アドレス
    ; をBCレジスタにセットする
    ; Eレジスタ=Y座標/8の値
    ; Lレジスタ=X座標*8の値
    ; 

    ld b, e  ; B=E*256

    ; C = WK_POS_Y - E*8
    sla e ; E = E * 2
    sla e ; E = E * 4
    sla e ; E = E * 8
    ld c, e
    ld a, (WK_PLOT_Y)
    sub c
    ld c, a

    add hl, bc
    ld b, h
    ld c, l
    push bc

    ; 7回右にビットシフトさせながら
    ; 対象ビットを特定する
    ld b, 7
    ld e, 10000000B

SetBitLoop:

    ld a, d
    cp b
    jr z, SetBitLoopEnd
    srl e ; Eを1ビット右にシフト
    djnz SetBitLoop

SetBitLoopEnd:

    pop bc

    ; Eレジスタにドットパターンがセットされている
    ; 仮想パターンジェネレータテーブルの先頭アドレスに
    ; BCCレジスタの値を加算したアドレスの
    ; キャラクタパターンを取得する
    ld hl, WK_VIRT_VRAM_UP
    add hl, bc
    ld a, (hl)
    
    ; 読み込んだキャラクタパターンの値に
    ; 今回プロットする情報をORする
    or e

    ld (hl), a

    ; 再描画フラグをONにする
    ld a, 1
    ld (WK_REDRAW_FINE), a

    pop hl
    pop de
    pop bc
    pop af

    ret 

;--------------------------------------------
; SUB-ROUTINE: MemFil
; HLレジスタが指すアドレスに
; BCレジスタの数ぶん、Aレジスタの値をセットする
; 破壊レジスタ：HL,BC,AF
;--------------------------------------------
MemFil:

    ld (hl), a
    cpi
    jp pe, MemFil

    ret

;--------------------------------------------
; SUB-ROUTINE: MemCpy
; HLレジスタが指すアドレスの内容を
; DEレジスタが指すアドレスにコピーする
; BCレジスタの数ぶんコピーする
; (LDIRの代用)
; 破壊レジスタ：HL,BC,AF
;--------------------------------------------
MemCpy:

    ld a, (hl)
    ld (de), a
    inc de
    cpi
    jp pe, MemCpy

    ret

;---------------------------------------------
; VRAM関連サブルーチン群
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

;--------------------------------------------
; SUB-ROUTINE: RandomValue
; 乱数を取得する
; 16ビットの乱数を取得して、その値の上位8ビットを取得する
; WK_RANDOM_VALUEには16ビットの乱数をセットして返却する
;--------------------------------------------
InitRandom: 
    
    xor a
    ld (WK_RANDOM_VALUE+1), a          ; 乱数のシード値を設定
    ld (WK_RANDOM_VALUE), a

    ret
   
RandomValue:
   
    push bc
    push de
    push hl
    
    ld de, (WK_RANDOM_VALUE)         ; 乱数のシード値を乱数ワークエリアから取得

    ld a, d
    ld h, e
    ld l, 253
    or a
    sbc hl, de
    sbc a, 0
    sbc hl, de
    ld d, 0
    sbc a, d
    ld e, a
    sbc hl, de
    jr nc, RandomValueEnd

    inc hl

RandomValueEnd:

    ld (WK_RANDOM_VALUE), hl

    ld a, h ; 乱数の上位8ビットを乱数として採用する

    pop hl
    pop de
    pop bc

    ret

PG_END:
defb $FF

; 変数

DEFVARS $C000
{
WK_REDRAW_FINE     ds.b 1
WK_RANDOM_VALUE    ds.w 1 ; 16ビット乱数
WK_VRAM_SYNC       ds.b 1
VSYNC_WAIT_CNT     ds.b 1
H_TIMI_BACKUP      ds.b 5
WK_PLOT_X          ds.b 1
WK_PLOT_Y          ds.b 1
WK_PLOT_COLOR      ds.b 1
WK_VIRT_VRAM_ADR   ds.w 1
WK_CHRPTN_VRAM_ADR ds.w 1
}

; C100H - D8FFH まではパターンテーブルの仮想領域
DEFVARS $C100
{
WK_VIRT_VRAM_UP    ds.b 256 * 8
WK_VIRT_VRAM_MD    ds.b 256 * 8
WK_VIRT_VRAM_DW    ds.b 256 * 8
}

; C100H - C8FFHまでは共用エリアとする
DEFVARS $C100
{
WK_UNIONRAM        ds.b $800
}

