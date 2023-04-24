;--------------------------------------------
; BIOSルーチン
;--------------------------------------------
FILVRM:equ $0056 ; VRAMの指定領域を同一のデータで埋める
LDIRMV:equ $0059 ; VRAMからRAMにブロック転送する
LDIRVM:equ $005C ; RAMからVRAMにブロック転送する
SETGRP:equ $007E ; VDPのみをGRAPHIC2モードにする

;--------------------------------------------
; 変数領域
;--------------------------------------------

; VRAMデータ退避用
WK_VRAMTORAM:equ $D300   ; 0800Hバイト(D300H - DAFFH))

; HLレジスタ退避用
WK_HLREGBACK:equ $DB00   ; 2バイト
; リンクポインタ退避用
WK_NEXTROW:equ $DB02   ; 2バイト

; キャラクタデータ作成用
WK_CHARCODE:equ $DB04   ; 1バイト
WK_CHARDATA:equ $DB05    ; 8バイト

; 62000行目を探すためのワーク変数
WK_REMLINE_WORK:equ $DB0D   ; 2バイト

;
; BASIC行内でのキャラクタデータ開始サインは
; 行番号が62000からと規定する
; BASIC側では必ず62000行をGOSUBしてから
; この処理を呼び出す
;
; 1パターんで3行を必要とする
; REMの後ろに空白を付けてはいけない
; RETURN で終端を表す
;
; (例)
; 10 SCREEN1:KEYOFF
; 50 GOSUB 62000
; 99 END
; 62000 REMA
; 62001 REM3974FAFEFEFE7C38
; 62002 REM818181A1A1A1B1F1
; 62003 REMB
; 62004 REM3C7E5A5A7E7E7E3C
; 62005 REM5151515151E1E1E1
; 62999 RETURN

;--------------------------------------------
; 初期処理（お約束コード）
;--------------------------------------------
org $D000

ProgramStart:

    ; GRAPHIC2モードに変更する
    call SETGRP

    jp CreateCharacterPattern

ProgramEnd:

    ret

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

    ; パターンデータはBASICの62000行からとなる
    call GetAddressBASICCHRDATA
    
CreateCharacterPatternLoop:

    ld hl, (WK_HLREGBACK)
    
    call SetNextRow
    
    ld a, (hl)
    
    ; RETURN文であれば処理を終了する
    cp $8E
    jp z, CreateCharacterPatternEnd
    
    inc hl  ; REMは8Fという中間コードなので1バイト進める

    ; RETURN文でなければパターンの作成を行う

    ;
    ; キャラクタコードをセットする
    ;
    ld a, (hl)
    ld (WK_CHARCODE), a

    ; パターンデータを読み込む  
    ; 次の行のリンクポインタをWK_NEXTROW変数に退避
    ld hl, (WK_NEXTROW)
    call SetNextRow
    
    inc hl  ; REMは8Fという中間コードなので1バイト進める
    
    ;-----------------------------------------------
    ; REMに書かれてある文字列を8バイトに編集して
    ; メモリ(WK_CHARDATA)にセットする
    ;-----------------------------------------------
    call datastrtomem

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
    call CharDataToVRAM

    ;
    ; 画面中段のパターンジェネレータテーブルに書き込む
    ;
    call GetCharacterVRAMAddress
    ld hl, $0800  ; DEレジスタに0800Hを加算する
    add hl, de
    ld d, h
    ld e, l

    call CharDataToVRAM

    ;
    ; 画面下段のパターンジェネレータテーブルに書き込む
    ;
    call GetCharacterVRAMAddress
    ld hl, $1000  ; DEレジスタに1000Hを加算する
    add hl, de
    ld d, h
    ld e, l

    call CharDataToVRAM

    ;-----------------------------------------------
    ; カラーテーブル処理
    ;-----------------------------------------------
    ; 次の行のリンクポインタをWK_NEXTROW変数に退避
    ld hl, (WK_NEXTROW)
    call SetNextRow
    
    inc hl  ; REMは8Fという中間コードなので1バイト進める
    
    ;-----------------------------------------------
    ; REMに書かれてある文字列を8バイトに編集して
    ; メモリ(WK_CHARDATA)にセットする
    ;-----------------------------------------------
    call datastrtomem

    ;
    ; 画面上段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress
    ld hl, $2000   ; DEレジスタに2000Hを加算する
    add hl, de
    ld d, h
    ld e, l
    
    call CharDataToVRAM

    ;
    ; 画面中段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress
    ld hl, $2800   ; DEレジスタに2800Hを加算する
    add hl, de
    ld d, h
    ld e, l

    call CharDataToVRAM

    ;
    ; 画面下段のカラーテーブルに書き込む
    ;

    ; DEレジスタにはVRAMアドレスが入る
    call GetCharacterVRAMAddress
    ld hl, $3000   ; DEレジスタに3000Hを加算する
    add hl, de
    ld d, h
    ld e, l

    call CharDataToVRAM

    ld hl, (WK_NEXTROW)
    ld (WK_HLREGBACK), hl
    
    jp CreateCharacterPatternLoop

CreateCharacterPatternEnd:

    jp ProgramEnd

;--------------------------------------------
; SUB-ROUTINE: SetNextRow
; 次のREM行へのポインタを取得し、WK_NEXTROW変数にセットする
;--------------------------------------------
SetNextRow:

    ; 次の行のリンクポインタをWK_NEXTROW変数に退避
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    ld (WK_NEXTROW), de

    ; 行番号ぶんのアドレスをスキップ
    inc hl
    inc hl
    
    ret
;--------------------------------------------
; SUB-ROUTINE: CharDataToVRAM
; WK_CHARDATAの値を8バイトVRAMに転送する
;--------------------------------------------
CharDataToVRAM:

    ld hl, WK_CHARDATA
    ld bc, 8  ; 8バイト転送する
    call LDIRVM
    
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
    ld d, h
    ld e, l

    ret

;--------------------------------------------
; SUB-ROUTINE: GetAddressBASICCHRDATA
; パターンジェネレータデータとカラーデータが
; 格納されているBASICのREM行の先頭位置を探す
; HLレジスタにそのBASIC行のテキストデータの
; アドレスがセットされて返却される
;--------------------------------------------
GetAddressBASICCHRDATA:

    ld hl, $8001 ; BASICの先頭は8001H
 
GetAddressBASICCHRDATALoop:

    ld (WK_HLREGBACK), hl

    ld a, (hl)
    ld e, a
    inc hl
    ld a, (hl)
    ld d, a

    ld h, d
    ld l, e
    ld (WK_REMLINE_WORK), hl
   
    ld de, (WK_REMLINE_WORK)   ; リンクポインタをDEレジスタにセット

    ld hl, (WK_HLREGBACK)
    inc hl ; HLレジスタを2つ進める
    inc hl ; 
    
    ld a, (hl)
    cp $30
    jp nz, GetAddressBASICCHARDATALoopNextData

    inc hl
    ld a, (hl)
    cp $F2
    jp nz, GetAddressBASICCHARDATALoopNextData
    
    jp GetAddressBASICCHARDATALoopEnd

GetAddressBASICCHARDATALoopNextData:

    ld h, d
    ld l, e
    
    jp GetAddressBASICCHRDATALoop

GetAddressBASICCHARDATALoopEnd:

    ; 行番号62000を検知
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
    ; 転送サイズは0800Hバイト
    ld hl, $0000
    ld de, WK_VRAMTORAM
    ld bc, $800
    call LDIRMV

    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（中段）にコピーする
    ; 転送サイズは0800Hバイト
    ld hl, WK_VRAMTORAM
    ld de, $0800
    ld bc, $0800
    call LDIRVM
    
    ; パターンジェネレータテーブルの
    ; 上段の情報をVRAM（下段）にコピーする
    ; 転送サイズは0800Hバイト
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

    ;---------------------------------------- 
    ; カラーテーブルの初期化
    ; カラーテーブルは
    ; 全ライン前景色白、背景色黒にする
    ;---------------------------------------- 
    ld hl, $1800
    ld bc, 768
    ld  a, ' '
    call FILVRM
    
    ret

;--------------------------------------------
; SUB-ROUTINE: CalcMulti
; 掛け算を行う
; Eレジスタに格納されている値とHレジスタに
; 格納されている値を掛けてその結果をHLレジスタ
; にセットして返却する
;--------------------------------------------
CalcMulti:

    ;
    ; 当サブルーチンではBレジスタとDレジスタ
    ; HLレジスタを破壊するためPUSHで退避しておく
    ;
    push bc
    push de

    ld d, 0
    ld l, 0
    ld b, 8

CalcMulti1:

    ;
    ; Hレジスタの値を2倍する
    ; (2倍することで左に1ビットシフトする)
    ;
    ; 計算結果が16bitになる場合もあるため
    ; HLレジスタ(16bit)として使う
    ;
    ; Hレジスタの第7ビットの値はCYフラグに入る
    ; (桁あがりするとCYフラグが1になる)
    ;
    add hl, hl

    ;
    ; CYフラグがたっていなければCalcMulti2へジャンプ
    jr nc, CalcMulti2

    ;
    ; CYフラグが立っている場合は
    ; Eレジスタの値をHLレジスタに足す
    ;
    add hl, de

CalcMulti2:
    
    ;
    ; Bレジスタが0になるまで（計8bitぶん）
    ; HL + HL を繰り返す
    djnz CalcMulti1

    ; 退避していたレジスタを戻す
    pop de
    pop bc
    
    ret
    
;--------------------------------------------
; SUB-ROUTINE: datastrtomem
; 16進表記の文字列16文字をメモリに8バイト分に
; 変換してセットする
; HLレジスタ:文字列の先頭アドレス
; DEレジスタ:格納するメモリの先頭アドレス
;--------------------------------------------
datastrtomem:

    push af
    push bc
    
    ld de, WK_CHARDATA

    ld b, 8
    ld c, 0 ; Cレジスタには処理中に数値変換した値が入る

datastrtomemLoop:
   
    ld a, (hl)
    
    ; Aレジスタの値文字を4ビットの数値に変換する

datastrtomemStep1:

    ; 上位4ビットの文字を取得して数値に変換

    cp 65 ; A-F ?
    jp nc, datastrtomemStep2

    ; 0 - 9
    ; エラー処理はとりあえずおいておこう・・
    sub 48  ; 48を引くことで数値になる

    jp datastrtomemStep3

datastrtomemStep2:

    ; A - F
    sub 55  ; 55を引くことで数値になる
    
datastrtomemStep3:

    sla a   ; 4ビット左にシフトする
    sla a
    sla a
    sla a
    
    ; CレジスタにAレジスタの値（上位4ビット）の値をセットする
    ld c, a

datastrtomemStep4:

    inc hl
    
    ld a, (hl)

    ; Aレジスタの値文字を4ビットの数値に変換する

    ; 下位4ビットの文字を取得して数値に変換
    cp 65 ; A-F ?
    jp nc, datastrtomemStep5

    ; 0 - 9
    ; エラー処理はとりあえずおいておこう・・
    sub 48  ; 48を引くことで数値になる

    jp datastrtomemStep6

datastrtomemStep5:

    ; A - F
    sub 55  ; 55を引くことで数値になる
    
datastrtomemStep6:

    or c ; A = A(下位4ビット） or C（上位4ビット）

    ld (de), a

    inc hl
    inc de

    djnz datastrtomemLoop

    pop bc
    pop af
    
    ret

