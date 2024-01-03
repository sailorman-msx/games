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
;
; ※CreateCharacterPatternLoopは
;  PCGの変更時にもCALLで使用する
;
;--------------------------------------------
CreateCharacterPattern:
    
    ; キャラクタデータ作成用変数に
    ; パターンデータのアドレスをセット
    ld a, (WK_VALUE08)
    cp 1
    jp nz, CreateCharaPtnHiragana

    ld hl, CHRPTN_NUMALPHA
    ld (WK_CHARDATAADR), hl

    ; COLORは以下で統一
    ; defb $F1,$F1,$F1,$F1,$E1,$F1,$E1,$E1
    jr CreateCharacterPatternLoop

CreateCharaPtnHiragana:

    cp 2
    jr nz, CreateCharaPtnTiles

    ld hl, CHRPTN_HIRAGANA
    ld (WK_CHARDATAADR), hl

    ; COLORは以下で統一
    ; defb $F1,$F1,$F1,$F1,$F1,$F1,$F1,$F1
    jr CreateCharacterPatternLoop

CreateCharaPtnTiles:

    ld hl, CHRPTN
    ld (WK_CHARDATAADR), hl
 
CreateCharacterPatternLoop:

    ; パターンデータアドレスの中の値をAレジスタにセットする
    ld hl, (WK_CHARDATAADR)
    ld a, (hl)

    ;
    ; Aレジスタの値が0であれば処理終了とする
    ;
    or a
    jp z, CreateCharacterPatternEnd

    ; キャラクタコードをセットする
    ld (WK_CHARCODE), a

    inc hl
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを1進める

    ;-----------------------------------------------
    ; パターンジェネレータテーブル処理
    ;-----------------------------------------------

    ; 定義する文字(WK_CHARCODE)の数値を8倍し
    ; その結果をDEレジスタに格納する
    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress

    ;
    ; 画面上段のパターンジェネレータテーブルに書き込む
    ;
    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面中段のパターンジェネレータテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress

    ld hl, $0800  ; DEレジスタに0800Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面下段のパターンジェネレータテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress

    ld hl, $1000  ; DEレジスタに1000Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;-----------------------------------------------
    ; カラーテーブル処理
    ;-----------------------------------------------

    ld hl, (WK_CHARDATAADR)
    ld (WK_HLREGBACK), hl

    ld a, (WK_VALUE08)
    or a
    jr nz, ColorNumAlpha

    ld hl, (WK_CHARDATAADR)
    ld b, 0
    ld c, 8
    add hl, bc
    ld (WK_CHARDATAADR), hl ; CHRPTNのアドレスを8バイト進める

    jr SetColorDatas

ColorNumAlpha:

    cp 1
    jr nz, ColorHiragana

    ld hl, CHRPTN_NUMALPHA_COLOR
    ld (WK_CHARDATAADR), hl
    jr SetColorDatas

ColorHiragana:

    ld hl, CHRPTN_HIRAGANA_COLOR
    ld (WK_CHARDATAADR), hl

SetColorDatas:

    ; 定義する文字(WK_CHARCODE)の数値を8倍し
    ; その結果をDEレジスタに格納する
    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress

    ;
    ; 画面上段のカラーテーブルに書き込む
    ;
    ld hl, $2000   ; DEレジスタに2000Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl
    
    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面中段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress

    ld hl, $2800   ; DEレジスタに2800Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ;
    ; 画面下段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress

    ld hl, $3000   ; DEレジスタに3000Hを加算する
    add hl, de
    ;ex de, hl
    ld de, hl

    ld hl, (WK_CHARDATAADR)
    ld bc, 8  ; 8バイト転送する
    call WRTVRMSERIAL

    ; 英数字、ひらがなの場合はHLREGBACKにセットされている
    ; アドレスに8を加算する
    ; それ以外は、WK_CHARDATAADRにセットされているアドレスに
    ; 8を加算する
    ld a, (WK_VALUE08)
    or a
    jr nz, NextNotTiles

    ld hl, (WK_CHARDATAADR)
    jr NextDataPattern

NextNotTiles:

    ld hl, (WK_HLREGBACK)

NextDataPattern:

    ld b, 0
    ld c, 8
    add hl, bc
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

    ld h, 0
    ld l, a
    add hl, hl ; x2
    add hl, hl ; x4
    add hl, hl ; x8

    ld e, l
    ld d, h

    ret

;--------------------------------------------
; SUB-ROUTINE: InitialPCGDatas
; パターンジェネレータテーブルと
; カラーテーブルを初期化する
;--------------------------------------------
InitialPCGDatas:

    ld hl, CHRPTN_HIRAGANA
    ld (WK_CHARDATAADR), hl
    call CreateCharacterPatternLoop

    ;---------------------------------------- 
    ; パターンジェネレータテーブルの初期化
    ; ひらがなのパターンを別のキャラクタコード
    ; に変更する
    ; 全部で26文字ぶん
    ; 濁点、半濁点も変更する
    ;---------------------------------------- 
    ; 濁点・半濁点を変更する
    ld hl, WK_VRAMTORAM
    ld de, $0000 + $DE * 8
    ld bc, 16
    call REDVRMSERIAL

    ld hl, WK_VRAMTORAM
    ld de, $0000 + $C4 * 8
    ld bc, 16
    call WRTVRMSERIAL

    ; パターンジェネレータテーブルの
    ; 上段のひらがな情報を書き換える
    ld hl, WK_VRAMTORAM
    ld de, $0000 + $86 * 8
    ld bc, 26 * 8
    call REDVRMSERIAL
    
    ld hl, WK_VRAMTORAM
    ld de, $0000 + $C6 * 8
    ld bc, 26 * 8
    call WRTVRMSERIAL

    ;---------------------------------------- 
    ; パターンジェネレータテーブルの初期化
    ;---------------------------------------- 
    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAMからRAMにコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_VRAMTORAM
    ld de, $0000
    ld bc, $0800
    call REDVRMSERIAL

    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（中段）にコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_VRAMTORAM
    ld de, $0800
    ld bc, $0800
    call WRTVRMSERIAL
    
    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（下段）にコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_VRAMTORAM
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

    ret
