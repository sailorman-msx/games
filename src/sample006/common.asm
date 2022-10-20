;--------------------------------------------
; common.asm
; 共通処理のサブルーチン集
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: PutVRAM256Bytes
; HLレジスタで指定したVRAMアドレスから
; Aレジスタの値を256文字分書き込む
;--------------------------------------------
PutVRAM256Bytes:

    push af
    push bc

    ld  b, $00

PutVRAM256BytesLoop:

    call WRTVRM
    inc hl

    djnz PutVRAM256BytesLoop

    pop bc
    pop af

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
; SUB-ROUTINE: PrintHexaDump
; 16進数文字列変換サブルーチン
; WK_DUMPDATAのアドレスの内容を32バイトぶん
; 16進表記する(32 x 2=64文字使用する)
;--------------------------------------------
PrintHexaDump:

    push hl
    push de
    push bc
    push af

    ; 16進表記文字の格納エリアを
    ; 文字コード20H(スペース)で埋める

    ld ix, WK_DUMPCHAR
    ld b, 32
    
PrintHexaDumpLoop1:

    ld (ix + 0), $20
    inc ix
    
    djnz PrintHexaDumpLoop1

PrintHexaDumpLoopEnd:

    ;
    ; WK_DUMPDATAのアドレスの値を16進表記にして
    ; WK_DUMPCHARのアドレスに格納していく
    ; (16バイト分)
    ;

    ld ix, WK_DUMPDATA
    ld iy, WK_DUMPCHAR
    ld b, 16

PrintHexaDumpLoop2:

    ;
    ; 最初の2バイトを取得し、DEレジスタに格納する
    ;
    ld d, (ix + 0)
    ld e, (ix + 1)

    ; Dジスタの値をAレジスタに転送
    ld a, d

    call Hex1Byte

    ; Eレジスタの値をAレジスタに転送
    ld a, e

    call Hex1Byte

    inc ix ; IXレジスタを2バイトぶん進める
    inc ix

    djnz PrintHexaDumpLoop2

    pop af
    pop bc
    pop de
    pop hl

    ret

;
; 1バイトの数値を文字列に変換する
;
Hex1Byte:

    ld c, a ; Aレジスタの値をCレジスタに退避

    ; Aレジスタを右シフトして上位4ビットの内容を
    ; 下位4ビットの位置にずらす
    srl a
    srl a
    srl a
    srl a

    call PutOneChar ; 上位4ビットの情報を16進表記する

    ld a, c ; 退避した内容をAレジスタに戻す
    and $0F  ; Aレジスタの値を下の桁のみにする

    call PutOneChar

    ret

;
; 4ビットの数値を文字に変換して
; IYレジスタ(WK_DUMPCHARのインデックス)のアドレスに
; 格納する
;
PutOneChar:

    cp 10 ; Aレジスタから10を引いた結果のフラグレジスタを取得する

    ; CYフラグがたたない場合
    ; つまり、Aレジスタの値が10以上の場合は
    ; PutHexCharを呼び出し16進で表示する
    jr nc, PutHexChar
    
    add a, $30
    ld (iy), a

    inc iy

    ret

PutHexChar:

    add a, $37 ; 数値に文字コード37Hを足してAからFまでの文字列にする
    ld (iy), a

    inc iy

    ret

;--------------------------------------------
; SUB-ROUTINE: HexaDumpToVRAM
; WK_DUMPCHARのデータをVRAMの指定したアドレス
; に出力する
; WK_DUMPCHARのデータ長さは16バイトとする
;   DEレジスタ：VRAMの先頭アドレス
;               先頭アドレスは横0の位置にした
;               ほうがみやすい
;--------------------------------------------
HexaDumpToVRAM:

    ld hl, WK_DUMPCHAR
    ld bc, 32          ; 32バイト分指定したアドレスに転送
    call LDIRVM

    ret
