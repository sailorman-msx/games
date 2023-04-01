;--------------------------------------------
; スプライト関連の処理
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: CreateSpritePattern
; スプライトパターンと
; 仮想スプライトアトリビュートテーブルを作成する
;--------------------------------------------
CreateSpritePattern:

    ;--------------------------------------------
    ; スプライトパターンデータをVRAMの
    ; スプライトパターンジェネレータテーブルに
    ; 転送する
    ;--------------------------------------------
    ld hl, SPRPTN
    ld de, $3800   ; スプライトパターンのVRAM先頭アドレスは3800H
    ld bc, 256     ; 1体あたり64バイトx4パターン
    call LDIRVM
    
    ;--------------------------------------------
    ; 仮想スプライトアトリビュートテーブルを作成する
    ; 32体分作成する
    ;--------------------------------------------
    ld hl, WK_VIRT_SPR_ATTR_TBL
    ld ix, hl
    ld b, 4
    ld c, 0

    ld d, 0
    ld e, 32

    ld a, 0
    ld (WK_SPRITEPOSY), a

CreateSpritePatternLoop:

    ; SP#1
    ld a, (WK_SPRITEPOSY)
    ld (ix + 0), a    ; Y座標
    ld a, c
    ld (ix + 1), a    ; X座標
    ld (ix + 2), 0    ; パターン番号
    ld a, (WK_PLAYERSPRCLR1) ; カラー
    ld (ix + 3), a

    ; SP#2
    ld a, (WK_SPRITEPOSY)
    ld (ix + 4), a    ; Y座標
    ld a, c
    ld (ix + 5), a    ; X座標
    ld (ix + 6), 4    ; パターン番号
    ld a, (WK_PLAYERSPRCLR2) ; カラー
    ld (ix + 7), a

    ; SP#3
    ld a, c
    add a, 16
    ld c, a
    ld a, (WK_SPRITEPOSY)
    ld (ix + 8), a    ; Y座標
    ld a, c
    ld (ix + 9), a    ; X座標
    ld (ix + 10), 8    ; パターン番号
    ld a, (WK_PLAYERSPRCLR1) ; カラー
    ld (ix + 11), a

    ; SP#4
    ld a, (WK_SPRITEPOSY)
    ld (ix + 12), a    ; Y座標
    ld a, c
    ld (ix + 13), a    ; X座標
    ld (ix + 14), 12    ; パターン番号
    ld a, (WK_PLAYERSPRCLR2) ; カラー
    ld (ix + 15), a

    ; SP#5
    ld a, c
    add a, 16
    ld c, a
    ld a, (WK_SPRITEPOSY)
    ld (ix + 16), a    ; Y座標
    ld a, c
    ld (ix + 17), a    ; X座標
    ld (ix + 18), 16    ; パターン番号
    ld a, (WK_PLAYERSPRCLR1) ; カラー
    ld (ix + 19), a

    ; SP#6
    ld a, (WK_SPRITEPOSY)
    ld (ix + 20), a    ; Y座標
    ld a, c
    ld (ix + 21), a    ; X座標
    ld (ix + 22), 20    ; パターン番号
    ld a, (WK_PLAYERSPRCLR2) ; カラー
    ld (ix + 23), a

    ; SP#7
    ld a, c
    add a, 16
    ld c, a
    ld a, (WK_SPRITEPOSY)
    ld (ix + 24), a    ; Y座標
    ld a, c
    ld (ix + 25), a    ; X座標
    ld (ix + 26), 24    ; パターン番号
    ld a, (WK_PLAYERSPRCLR1) ; カラー
    ld (ix + 27), a

    ; SP#8
    ld a, (WK_SPRITEPOSY)
    ld (ix + 28), a    ; Y座標
    ld a, c
    ld (ix + 29), a    ; X座標
    ld (ix + 30), 28    ; パターン番号
    ld a, (WK_PLAYERSPRCLR2) ; カラー
    ld (ix + 31), a

    add hl, de
    ld ix, hl

    ld c, 0

    ; 4体分横に並べたら次の4体は下に配置する
    ld a, (WK_SPRITEPOSY)
    add a, 16
    ld (WK_SPRITEPOSY), a

    dec b
    jp nz, CreateSpritePatternLoop

    ret

;--------------------------------------------
; SUB-ROUTINE: ShuffleSprite
; ワーク用スプライトアトリビュートテーブルの内容を
; 素数を使った形式(KONAMI方式)でシャッフルし
; その後、VDPポートを直接叩いて
; アトリビュートテーブルの内容をVRAMに転送する。
;--------------------------------------------
ShuffleSprite:

    ; VRAM書込み事前準備
    ; VDP書き込み用ポートに書き込みたいVRAMアドレスを
    ; セットする

    ld a, (WK_VDPPORT1)
    ld c, a
    inc c         ; 0007Hの値に1を加算するとWRITEモードのポート番号になる

    ; 直接、スプライトアトリビューﾄのVRAMアドレスを
    ; 書き換えるとテアリングが発生する可能性があるため
    ; 1C00Hにシャッフルした仮想アトリビュートテーブルを
    ; セットする
    ; シャッフルが終わったら1C00Hから128バイトぶんを
    ; 1B00Hに書き込む

    ld hl, $1C00
    ld a, l
    out (c), a    ; 12ステート
    nop           ;  4ステート
    nop           ;  4ステート
    nop           ;  4ステート

    ld a, h
    and $3F
    or $40
    out (c), a    ; 12ステート
    nop           ;  4ステート
    nop           ;  4ステート
    nop           ;  4ステート

    ld b, 32

    ; VRAM書込み事前準備
    ; HLレジスタにVDPに転送する先頭アドレスを
    ; セットする

    ld a, (WK_VDPPORT1)
    ld c, a
    ld h, WK_VIRT_SPR_ATTR_TBL >> 8

    ld a, (WK_SPRITE0_NUM)

ShuffleSpriteLoop:

    ld l, a

    ; HLレジスタの指すメモリの4バイトぶんの内容を
    ; 事前準備でセットしたVRAMアドレスに対して書き込む
    ; OUTIを実行するとBレジスタがデクリメントされるので
    ; OUTIのつどBレジスタをインクリメント補正する
    ; VRAMへの書き換えを行ったら最低21ステート間隔を
    ; あける必要があるらしい

    outi  ; 16ステート
    inc b ;  4ステート
    nop   ;  4ステート

    outi
    inc b
    nop

    outi
    inc b
    nop

    outi
    inc b
    nop

    add a, 28   ; A = A + 7 * 4

    ; Aレジスタの値はスプライト番号*7のアドレス
    ; スプライトの最大数は32なので32*4-1で
    ; 128以上にならないようマスクする
    and a, 7FH

    ; 32回分ループする
    djnz ShuffleSpriteLoop

    ; 次のシャッフル値の基準値（アドレス）を決める

    add a, 76   ; A = A + 19 * 4
    and a, 7FH  ; Aレジスタの値が128以上にならないようマスク

    ; 次のシャッフルの基準値を変更する
    ld (WK_SPRITE0_NUM), a

    ret

;--------------------------------------------
; SUB-ROUTINE: PutSprite
; VRAM 1C00Hから128バイト分を
; VRAM 1B00Hに転送する
;--------------------------------------------
PutSprite:

    ; VRAMの1C00Hから128バイトぶんを
    ; データ表示用のワークテーブルに格納する
    ld a, (WK_VDPPORT1)
    ld c, a
    inc c
    ld hl, $1C00
    ld a, l
    out (c), a
    nop
    nop
    nop
    ld a, h
    out (c), a
    nop
    nop
    nop

    ld a, (WK_VDPPORT0)
    ld c, a
    ld b, 128
    ld hl, WK_DISP_SPR_ATTR_TBL
    inir
    nop
    nop

    ld a, (WK_VDPPORT1)
    ld c, a
    inc c
    ld hl, $1B00
    ld a, l
    out (c), a
    nop
    nop
    nop
    ld a, h
    and $3F
    or $40
    out (c), a
    nop
    nop
    nop

    ld a, (WK_VDPPORT0)
    ld c, a
    ld b, 128
    ld hl, WK_DISP_SPR_ATTR_TBL
    otir
    nop
    nop
    
    ret
