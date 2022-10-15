;--------------------------------------------
; SUB-ROUTINE: CreateCharacterPattern
; パターンジェネレータテーブルと
; カラーテーブルを編集する
;--------------------------------------------
CreateCharacterPattern:
    
    ; キャラクタデータ作成用変数に
    ; パターンデータのアドレスをセット
    ld hl, CHRPTN
    ld (WK_CHARDATAADR), hl
 
CreateCharacterPatternLoop:

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld hl, (WK_CHARDATAADR)
    ld a, (hl)

    ld (WK_CHARCODE), a

    ;
    ; Aレジスタの値から1を減算した結果でCYフラグを確認する
    ; CYフラグがたてば処理終了とする
    ;
    cp 1
    jr c, CreateCharacterPatternEnd

    inc hl
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを1進める

    ;-----------------------------------------------
    ; パターンジェネレータテーブル処理
    ;-----------------------------------------------

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld a, (WK_CHARCODE)

    ;
    ; Aレジスタには文字コードがセットされているので
    ; その値を8倍した値がパターンの開始アドレスになる
    ;
    ld h, a
    ld e, 8

    ;
    ; Hレジスタの値を8倍する
    ;
    call CalcMulti

    ;
    ; HLレジスタの値にはVRAMのパターンジェネレータテーブルの
    ; アドレスが格納されているためDEレジスタにセットする
    ;
    ld de, hl

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ld hl, (WK_CHARDATAADR)
    add hl, 8
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    jr CreateCharacterPatternLoop

CreateCharacterPatternEnd:

    ;-----------------------------------------------
    ; 最後にカラーテーブルを処理する
    ;-----------------------------------------------
    ld hl, $2010  ; $80の文字色
    ld  a, $81    ; FG:RED BG:BLACK
    call WRTVRM
    ld hl, $2011  ; $81の文字色
    ld  a, $51    ; FG:BLUE BG:BLACK
    call WRTVRM
    
    ret
