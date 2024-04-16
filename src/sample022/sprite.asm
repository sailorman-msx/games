;--------------------------------------------
; スプライト関連の処理
; スプライトの表示処理がメイン
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: InitializeVirtSpritePattern
; シャッフル用アトリビュートテーブルを初期化する
;--------------------------------------------
InitializeVirtSpritePattern:

    ;--------------------------------------------
    ; シャッフル用アトリビュートテーブルを作成する
    ; 32体分作成する
    ;--------------------------------------------
    ld hl, WK_SHUFFLE_ATTRTBL

    ; スプライトアトリビュートテーブルと同じテーブル構造
    ; 32体 x 4 = 128 byte

    ld b, 128

InitializeVirtSpritePatternLoop1:

    xor a

    ld (hl), a
    inc hl

    djnz InitializeVirtSpritePatternLoop1

    ; ワークテーブルの初期化を行う
    ld hl, WK_SPRITE_MOVETBL
    ld bc, 512
    xor a
    call MemFil

    ret

;--------------------------------------------
; SUB-ROUTINE: SetVirtAttrTable
; スプライト座標管理用テーブルを更新する
;--------------------------------------------
SetVirtAttrTable:

    ld hl, WK_SPRITE_MOVETBL
    ld (WK_HLREGBACK), hl

SetVirtAttrTableShuffleProc:

    ld de, WK_SHUFFLE_ATTRTBL

    ld a, 32 ; スプライト数の総数は最大32
    ld (WK_VALUE01), a

    ld bc, 16
    
SetVirtAttrTableLoop:

    ld hl, (WK_HLREGBACK)

    inc hl     ; +0: 種別コードはスキップ

    ld a, (hl) ; +1: Y座標
    or a
    jp z, SetVirtAttrTableSet209

    jp SetVirtAttrTableSetY

    ; (MSX MAGIC)
    ; Y座標が0の場合は、209をセットする

SetVirtAttrTableSet209:

    ld a, 209

SetVirtAttrTableSetY:

    ld (de), a ; WK_SPRITE_MOVETBLのY座標をセット
    inc de

    inc hl
    ld a, (hl) ; +2: X座標
    ld (de), a ; WK_SPRITE_MOVETBLのX座標をセット
    inc de

    inc hl
    ld a, (hl) ; +3: パターン番号
    ld (de), a ; WK_SPRITE_MOVETBLのパターン番号をセット
    inc de

    inc hl
    ld a, (hl) ; +4: カラー
    ld (de), a ; WK_SPRITE_MOVETBLのカラーをセット
    inc de

    ; WK_SPRITE_MOVETBLの+5 - +15をスキップする
    ld hl, (WK_HLREGBACK)
    add hl, bc ; HL = HL + 16
    ld (WK_HLREGBACK), hl

SetVirtAttrTableLoopEndNextData:

    ld a, (WK_VALUE01)
    cp 1
    jp z, SetVirtAttrTableLoopEnd

    dec a
    ld (WK_VALUE01), a

    jp SetVirtAttrTableLoop

SetVirtAttrTableLoopEnd:

    ret

;--------------------------------------------
; SUB-ROUTINE: ShuffleSprite
; ワーク用スプライトアトリビュートテーブルの内容を
; 素数を使った形式(KONAMI方式)でシャッフルし
; 仮想スプライトアトリビュートテーブルを作成する
;--------------------------------------------
ShuffleSprite:

    ; 直接、スプライトアトリビューﾄのVRAMアドレスを
    ; 書き換えるとテアリングが発生する可能性があるため
    ; 仮想スプライトアトリビュートテーブルに
    ; シャッフルした結果をセットする
    ; 仮想スプライトアトリビュートテーブルの内容は
    ; H.TIMIのタイミングで1B00Hに書き込む
    ; その際には直接VDPポートを叩いて書き込みを行う

    ld b, 32

    ; HLレジスタにシャッフル用のアトリビュートテーブルの
    ; 先頭アドレスを
    ; DEレジスタに仮想スプライトアトリビュートテーブルの
    ; 先頭アドレスを
    ; それぞれ、セットする
    ld hl, WK_SHUFFLE_ATTRTBL
    ld de, WK_VIRT_SPRATTRTBL

    ld a, (WK_SPRITE0_NUM)

ShuffleSpriteLoop:

    ld l, a
    ld (WK_VALUE01), a

    ; HLレジスタの指すメモリの4バイトぶんの内容を
    ; DEレジスタが指し示すアドレスに書き込む

    ; BCレジスタの値を退避
    ld (WK_BCREGBACK), bc
    ld bc, 4
    call MemCpy
    ld bc, (WK_BCREGBACK)

    ld a, (WK_VALUE01)
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

    ld a, 1
    ld (WK_SPRREDRAW_FINE), a

    ret
