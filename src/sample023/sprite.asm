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
    inc l

    djnz InitializeVirtSpritePatternLoop1

    ; ワークテーブルの初期化を行う
    ld hl, WK_SPRITE_MOVETBL
    ld bc, 256
    xor a
    call MemFil

    ret

;--------------------------------------------
; SUB-ROUTINE: SetVirtAttrTable
; スプライト座標管理用テーブルを更新する
;--------------------------------------------
SetVirtAttrTable:

    ld hl, WK_SPRITE_MOVETBL

SetVirtAttrTableShuffleProc:

    ld de, WK_SHUFFLE_ATTRTBL

    ld b, CONST_SPRITETOTAL
    
SetVirtAttrTableLoop:

    inc l     ; +0: 種別コードはスキップ

SetVirtAttrTableSetY:

    ld a, (hl)
    ld (de), a ; WK_SPRITE_MOVETBLのY座標をセット
    inc e

    inc hl
    ld a, (hl) ; +2: X座標
    ld (de), a ; WK_SPRITE_MOVETBLのX座標をセット
    inc e

    inc hl
    ld a, (hl) ; +3: パターン番号
    ld (de), a ; WK_SPRITE_MOVETBLのパターン番号をセット
    inc e

    inc l
    ld a, (hl) ; +4: カラー
    ld (de), a ; WK_SPRITE_MOVETBLのカラーをセット
    inc e

    ; WK_SPRITE_MOVETBLの+5 - +15をスキップする
    
    ; Lレジスタに12を加算する
    ld a, 12
    ld a, l

SetVirtAttrTableLoopEndNextData:

    djnz SetVirtAttrTableLoop

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

    ex af, af' ; AFレジスタを退避

    ; HLレジスタの指すメモリの4バイトぶんの内容を
    ; DEレジスタが指し示すアドレスに書き込む

    ; BCレジスタの値を退避
    push bc
    ld b, 0
    ld c, 4
    call MemCpy
    pop bc

    ex af, af' ; AFレジスタを退避
    
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

;-------------------------------------
; ここから下はスプライトアニメ関連のデータ
; パターンデータはPage#0に格納している
;-------------------------------------

;-------------------------------------
; スプライトカラーデータ
;-------------------------------------

;-------------------------------------
; スプライトパターンデータ
;-------------------------------------

; ハシゴ昇降時 ( 160 -> 176 -> 160 .. )
defb 160, 164, 168, 172
defb 176, 180, 184, 188

; 真上ジャンプ or 真下降下
SPRITE_JUMPFALL:
defb 192, 196, 200, 204

; しゃがみ
SPRITE_SQUAT_R:
defb 252, 252,  88,  92

SPRITE_SQUAT_L:
defb 252, 252, 152, 156

defb 255 ; End of data
