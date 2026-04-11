;
; ゲームプログラムローダー
;
; BASICの5010行目以降のコメント行を解釈して
; B000H以降に書き込む
;

LINE_NUMBER    EQU 0C500H ; 2 byte 行番号のアドレス
NEXT_LINE      EQU 0C502H ; 2 byte リンクポインタ
BACKUP_HL      EQU 0C504H ; 2 byte HLレジスタ格納用（PUSH/POPがめんどくさい）
BACKUP_BC      EQU 0C506H ; 2 byte BCレジスタ格納用（PUSH/POPがめんどくさい）
BIN_SIZE       EQU 0C508H ; 2 byte ゲームプログラムバイト数
POKE_ADR       EQU 0C50AH ; 2 byte ゲームプログラムの書き込みアドレス

; ゲームプログラムの先頭と終端アドレス
; 先頭は B000H
; 終端は B50DH
; バイナリサイズ 050EH = 1294 byte
CONST_BIN_SIZE EQU 1294

; このプログラムの先頭はB800H

ORG 0B800H

MAIN:

    DI

    ; ゲームプログラムのサイズを設定する
    LD HL, CONST_BIN_SIZE
    LD (BIN_SIZE), HL

    ; BASICの5010行目を検索する
    LD BC, 5010

    CALL LINE_SEARCH

    LD HL, 0B000H ; プログラム書き込み先アドレス
    LD (POKE_ADR), HL

    ; データ格納エリアには224バイト分（16進数表記で112バイトぶん）
    ; の16進文字列が格納されている
    ; その文字を2文字ずつ抽出して、16進表記文字から数値に変換して
    ; プログラムエリアに格納する
    
WRITE_LOOP:

    LD HL, (BACKUP_HL)
    LD  C, (HL) ; リンクポインタの下位バイト
    INC HL
    LD  B, (HL) ; リンクポインタの上位バイト
   
    ; 次の行のアドレスを退避
    LD (BACKUP_BC), BC

    INC HL ; 行番号下位バイト
    INC HL ; 行番号上位バイト
    INC HL ; 03AH
    INC HL ; 08FH
    INC HL ; 0E6H
    INC HL ; データの1バイト目

    EX DE, HL ; DE <--> HL

    OR A   ; CY off

WRITE_LOOP_EOD_CHECK:

    EX DE, HL ; DE <-- HL

    ; 1行分の書き込みを行う
    ; HLレジスタには行の先頭アドレスが格納されている

    LD B, 112 ; 16進表記で112バイトぶんループする

WRITE_ONE_LINE:

    ; 1バイト（上位1バイトに該当）を読み込む
    LD  A, (HL)
    CALL CONV_DEC
    LD  D, A ; 10進変換結果をDに格納

    ; 上位1バイトのため4ビット左にシフトする
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A  ; 4ビットシフトの結果をEレジスタに格納

    INC HL   ; アドレスを1つ進める

    ; 1バイト（下位1バイトに該当）を読み込む
    LD  A, (HL)
    CALL CONV_DEC

    ; Eレジスタ（上位4ビットが格納されてる）にORする
    OR E

    PUSH HL

    ; プログラムデータを書き込む
    LD HL, (POKE_ADR)
    LD (HL), A

    ; プログラムデータ書き込みアドレスを1バイト進める
    INC HL
    LD (POKE_ADR), HL

    ; 書き込みサイズをデクリメントする
    ; 0チェック（完了チェック）は WRITE_LOOP_EOD_CHECKで実施
    LD HL, (BIN_SIZE)
    DEC HL
    LD A, H
    OR A
    JR NZ, SET_BIN_SIZE  ; 上位バイトが0ではない

    OR L
    JR Z, WRITE_LOOP_END ; 上位バイト、下位バイトともにゼロなら処理終了

SET_BIN_SIZE:

    LD (BIN_SIZE), HL

    POP HL

    INC HL   ; BASICのデータの次の文字アドレスに進める

    DJNZ WRITE_ONE_LINE
    
    ; 1行分の書き込みが完了したら
    ; 次の行のアドレスの内容を処理する
    LD BC, (BACKUP_BC)
    LD H, B
    LD L, C
    LD (BACKUP_HL), HL

    JR WRITE_LOOP 

WRITE_LOOP_END:

    POP HL

    EI 
    
    RET

; ================================================================
; BASICの特定行を探すサブルーチン
; 処理概要:
;   BCレジスタに格納された行番号に対応するBASICの先頭位置を取得する
;   DEレジスタに指定した行の先頭アドレス（リンクポインタアドレス）
;   がセットされて返却される
; ================================================================
LINE_SEARCH:

    ; BASICの特定行のデータ位置を特定する
    LD HL, 08001H ; BASICの仕様では0800Hはゼロになっているため次のアドレスから
    
    LD (LINE_NUMBER), BC ; 指定された行番号を変数に退避

LINE_SEARCH_LOOP:

    LD (BACKUP_HL), HL

    LD E, (HL)  ; リンクポインタの下位バイト
    INC HL
    LD D, (HL)  ; リンクポインタの上位バイト

    INC HL      ; 行番号の下位バイトのアドレス

    LD A, (HL)  ; 行番号の下位バイトをCにセット
    LD C, A
    INC HL
    LD A, (HL)  ; 行番号の上位バイトをBにセット
    LD B, A

    LD HL, (LINE_NUMBER) ; 検索対象となる行番号をHLにセット

    ; HL - BC の結果がゼロであれば
    ; 行番号を検知したと判定する
    SBC HL, BC  ; HL - BC の結果がゼロであれば
    
    JR Z, LINE_FOUND

    LD HL, DE   ; 次の行をサーチ

    JR LINE_SEARCH_LOOP

LINE_FOUND:

    ; BASICの中間コード先頭をHLレジスタにセット
    LD HL, (BACKUP_HL)

    RET

; ================================================================
; 16進数の1桁ぶんを10進に変換する
; 入力：Aレジスタ  0123456789ABCDEFのいずれかの文字コード）
; 出力：Aレジスタ  10進変換結果(0-15)
; ================================================================
CONV_DEC:

    ; A >= 41H ?
    CP 041H
    JR NC, CD_ALPHABETIC

    ; 0 - 9
    SUB 030H  ; 30H を引く

    JR CONV_DEC_END

CD_ALPHABETIC:

    ; A - F
    SUB 041H  ; 41H を引いて
    ADD A, 10 ; 10を加算する   

CONV_DEC_END:

    RET
