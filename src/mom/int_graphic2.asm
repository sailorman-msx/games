;--------------------------------------------
; pcg_graphic2.asm
;
; GRAPHIC2モードでのキャラクターグラフィック
; 作成処理はこちらに記述すること！
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: IntCreateCharacterPattern
; パターンジェネレータテーブルと
; カラーテーブルを編集する
;--------------------------------------------
IntCreateCharacterPatternLoop:

    push af
    push bc
    push de
    push hl
    push ix
    push iy 
    
IntCreateCharacterPatternLoop2:

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld hl, (WK_PH_CHARDATAADR)
    ld a, (hl)

    ;
    ; Aレジスタの値が0であれば処理終了とする
    ;
    or a
    jp z, IntCreateCharacterPatternEnd

    ; キャラクタコードをセットする
    ld (WK_PH_CHARCODE), a

    inc hl
    ld (WK_PH_CHARDATAADR), hl ; CHRPTNのアドレスを1進める

    ;-----------------------------------------------
    ; パターンジェネレータテーブル処理
    ;-----------------------------------------------

    ; 定義する文字(WK_PH_CHARCODE)の数値を8倍し
    ; その結果をDEレジスタに格納する
    ; DEレジスタにはVRAMアドレスが入る
    call IntGetCharacterVRAMAddress

    ;
    ; 画面上段のパターンジェネレータテーブルに書き込む
    ;
    ld hl, (WK_PH_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面中段のパターンジェネレータテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call IntGetCharacterVRAMAddress

    ld hl, $0800  ; DEレジスタに0800Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_PH_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面下段のパターンジェネレータテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call IntGetCharacterVRAMAddress

    ld hl, $1000  ; DEレジスタに1000Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_PH_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;-----------------------------------------------
    ; カラーテーブル処理
    ;-----------------------------------------------

    ld hl, (WK_PH_CHARDATAADR)
    ld (WK_PH_HLREGBACK), hl

    ld hl, (WK_PH_CHARDATAADR)
    ld b, 0
    ld c, 8
    add hl, bc
    ld (WK_PH_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    ; 定義する文字(WK_PH_CHARCODE)の数値を8倍し
    ; その結果をDEレジスタに格納する
    ; DEレジスタにはVRAMアドレスが入る
    call IntGetCharacterVRAMAddress

    ;
    ; 画面上段のカラーテーブルに書き込む
    ;
    ld hl, $2000   ; DEレジスタに2000Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl
    
    ld hl, (WK_PH_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面中段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call IntGetCharacterVRAMAddress

    ld hl, $2800   ; DEレジスタに2800Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_PH_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面下段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call IntGetCharacterVRAMAddress

    ld hl, $3000   ; DEレジスタに3000Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_PH_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ld hl, (WK_PH_CHARDATAADR)
    jr IntNextDataPattern

IntNextDataPattern:

    ld b, 0
    ld c, 8
    add hl, bc
    ld (WK_PH_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    jp IntCreateCharacterPatternLoop2

IntCreateCharacterPatternEnd:

    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    
    ret

;--------------------------------------------
; SUB-ROUTINE: IntGetCharacterVRAMAddress
; 文字コードの数値を8倍した数値を取得する
; DEレジスタに計算結果がセットされる
;--------------------------------------------
IntGetCharacterVRAMAddress:

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld a, (WK_PH_CHARCODE)

    ld h, 0
    ld l, a
    add hl, hl ; x2
    add hl, hl ; x4
    add hl, hl ; x8

    ld e, l
    ld d, h

    ret
