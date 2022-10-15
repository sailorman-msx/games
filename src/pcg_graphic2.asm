;--------------------------------------------
; pcg_graphic2.asm
;
; GRAPHIC2モードでのキャラクターグラフィック
; 作成処理はこちらに記述すること！
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: CreateCharacterPattern
; パターンジェネレータテーブルと
; カラーテーブルを編集する
;--------------------------------------------
CreateCharacterPattern:
    
    ;----------------------------------------
    ; VRAMのPCG情報を初期化する
    ;----------------------------------------
    call InitialPCGDatas

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
    jp c, CreateCharacterPatternEnd

    inc hl
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを1進める

    ;-----------------------------------------------
    ; パターンジェネレータテーブル処理
    ;-----------------------------------------------

    ; 定義する文字の数値を8倍し
    ; その結果をDEレジスタに格納する
    call GetCharacterVRAMAddress

    ;
    ; 画面上段のパターンジェネレータテーブルに書き込む
    ;
    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ;
    ; 画面中段のパターンジェネレータテーブルに書き込む
    ;
    call GetCharacterVRAMAddress

    ld hl, de
    ld bc, $0800  ; HLレジスタに0800Hを加算する
    add hl, bc

    ld de, hl     ; DEレジスタにHLレジスタの値を転送する

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ;
    ; 画面下段のパターンジェネレータテーブルに書き込む
    ;
    call GetCharacterVRAMAddress

    ld hl, de
    ld bc, $1000  ; HLレジスタに1000Hを加算する
    add hl, bc

    ld de, hl     ; DEレジスタにHLレジスタの値を転送する

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ld hl, (WK_CHARDATAADR)
    add hl, 8
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    ;-----------------------------------------------
    ; カラーテーブル処理
    ;-----------------------------------------------

    ; 定義する文字の数値を8倍し
    ; その結果をDEレジスタに格納する
    call GetCharacterVRAMAddress

    ld hl, de

    ;
    ; 画面上段のパターンジェネレータテーブルに書き込む
    ;
    ld hl, $2000     ; HLレジスタに2000Hを加算する
    add hl, de
    ld de, hl        ; DEレジスタにHLレジスタの値を転送する

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ;
    ; 画面中段のパターンジェネレータテーブルに書き込む
    ;
    call GetCharacterVRAMAddress

    ld bc, $2800     ; HLアドレスに2800Hを加算する
    add hl, bc

    ld de, hl        ; DEレジスタにHLレジスタの値を転送する

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ;
    ; 画面下段のパターンジェネレータテーブルに書き込む
    ;
    call GetCharacterVRAMAddress

    ld hl, de
    ld bc, $3000     ; HLアドレスに3000Hを加算する
    add hl, bc

    ld de, hl        ; DEレジスタにHLレジスタの値を転送する

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call LDIRVM

    ld hl, (WK_CHARDATAADR)
    add hl, 8
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    jp CreateCharacterPatternLoop

CreateCharacterPatternEnd:

    ret

;--------------------------------------------
; SUB-ROUTINE: GetCharacterVRAMAddress
; 文字コードの数値を8倍した数値を取得する
; DEレジスタに計算結果がセットされる
;--------------------------------------------
GetCharacterVRAMAddress:

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

    ret

;--------------------------------------------
; SUB-ROUTINE: InitialPCGDatas
; パターンジェネレータテーブルと
; カラーテーブルを初期化する
;--------------------------------------------
InitialPCGDatas:

    ;---------------------------------------- 
    ; パターンジェネレータテーブルの初期化
    ;---------------------------------------- 

    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAMからRAMにコピーする
    ; 転送サイズは800バイト
    ld hl, $0000
    ld de, WK_VRAMTORAM
    ld bc, $800
    call LDIRMV

    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（中段）にコピーする
    ; 転送サイズは800バイト
    ld hl, WK_VRAMTORAM
    ld de, $0800
    ld bc, $0800
    call LDIRVM
    
    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（下段）にコピーする
    ; 転送サイズは800バイト
    ld hl, WK_VRAMTORAM
    ld de, $1000
    ld bc, $0800
    call LDIRVM

    ;---------------------------------------- 
    ; カラーテーブルの初期化
    ; カラーテーブルは
    ; 全ライン前景色白、背景色黒にする
    ;---------------------------------------- 
    ld hl, $2000
    ld bc, $1800 ; 256 x 3 x 8 = 6144 = 1800H
    ld  a, $F1
    call FILVRM

    ret
