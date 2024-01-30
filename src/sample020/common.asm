;--------------------------------------------
; common.asm
; 共通処理のサブルーチン集
;--------------------------------------------
;--------------------------------------------
; SUB-ROUTINE: MemFil
; HLレジスタが指すアドレスに
; BCレジスタの数ぶん、Aレジスタの値をセットする
; 破壊レジスタ：HL,BC,AF
;--------------------------------------------
MemFil:

MemFilLoop:

    ld (hl), a
    cpi
    jp pe, MemFilLoop

    ret

;--------------------------------------------
; SUB-ROUTINE: MemCpy
; HLレジスタが指すアドレスの内容を
; DEレジスタが指すアドレスにコピーする
; BCレジスタの数ぶんコピーする
; (LDIRの代用)
; 破壊レジスタ：HL,BC,AF
;--------------------------------------------
MemCpy:

MemCpyLoop:

    ld a, (hl)
    ld (de), a
    inc de
    cpi
    jp pe, MemCpyLoop

    ret

;--------------------------------------------
; SUB-ROUTINE: IntMemCpy
; HLレジスタが指すアドレスの内容を
; DEレジスタが指すアドレスにコピーする
; BCレジスタの数ぶんコピーする
; (LDIRの代用)
; 破壊レジスタ：HL,BC,AF
;--------------------------------------------
IntMemCpy:

IntMemCpyLoop:

    ld a, (hl)
    ld (de), a
    inc de
    cpi
    jp pe, IntMemCpyLoop

    ret

;--------------------------------------------
; SUB-ROUTINE: SortValues
; バブルソートを行う
; HLレジスタ：ソート対象（最大20バイト）
; DEレジスタ：ソート結果（最大20バイト）
;--------------------------------------------
SortValues:

    ; HLレジスタのアドレスの内容を
    ; DEレジスタが指すアドレスにコピーする
    push de
    push hl

    ld b, 0
    ld c, 20
    call MemCpy

    pop hl
    pop de

;
;   I <- WK_SORTVALUE01
;   J <- WK_SORTVALUE02
;   A <- WK_SORTVALUE03 X[ix+0]
;   B <- WK_SORTVALUE04 X[ix+1]
;
;   A > B であればAとBを入れ替える
;

    ld a, 20
    dec a
    ld (WK_SORTVALUE01), a   ; I = 19

SortValuesLoop1:

    ; IXレジスタを使ってDEのアドレス先を
    ; ソートする
    ld ix, de

    xor a
    ld (WK_SORTVALUE02), a   ; J = 0

SortValuesLoop2:         ; LOOP2

    ld a, (ix + 1)       ; B = X[ix+1]
    ld (WK_SORTVALUE04), a
    ld b, a
    
    ld a, (ix + 0)       ; A = X[ix+0]
    ld (WK_SORTVALUE03), a
 
    cp b                 ; X[ix+0] > X[ix+1] ?
    jp z, SortValuesLoop2Next
    jp nc, SortValuesLoop2Swap

    jp SortValuesLoop2Next

SortValuesLoop2Swap:

    ld a, (WK_SORTVALUE03)   ; X[ix] <--> X[ix+1]
    ld (ix + 1), a
    ld a, (WK_SORTVALUE04)
    ld (ix + 0), a

SortValuesLoop2Next:

    ld a, (WK_SORTVALUE02)
    inc a
    ld (WK_SORTVALUE02), a   ; J = J + 1
    ld b, a

    ld a, (WK_SORTVALUE01)   ; (I - 1)
    dec a

    inc ix

    cp b                 ; J = (I - 1) ?
    jp nz, SortValuesLoop2

    ld (WK_SORTVALUE01), a   ; I = I - 1
    cp 1                 ; I = 1 ?
    jp nz, SortValuesLoop1

SortValuesEnd:

    ret

;--------------------------------------------
; SUB-ROUTINE: RandomValue
; 乱数を取得する
; WK_RANDOM_VALUEに8ビットの乱数をセットして返却する
;--------------------------------------------
InitRandom:
    
    ld a,(INTCNT)
    ld (WK_RANDOM_VALUE),a          ; 乱数のシード値を設定

    ret
    
RandomValue: 
    
    push bc
    
    ld a, (WK_RANDOM_VALUE)         ; 乱数のシード値を乱数ワークエリアから取得
    ld b, a
    ld a, b
    
    add a, a                        ; Aを5倍する
    add a, a                        ;
    add a, b                        ;
    
    add a,123                       ; 123を加える 

    ld b, a
    ld a, r                         ; Rレジスタの値を加算
    add a, b
    
    ld (WK_RANDOM_VALUE), a         ; 乱数ワークエリアに保存

    pop bc
    ret

;--------------------------------------------
; SUB-ROUTINE: AbsA
; Aレジスタにセットされている値を絶対値にする
;--------------------------------------------
AbsA:

    ; AレジスタとAレジスタをOR演算する
    or a

    ; Pフラグが成立していたらA>=0なので
    ; そのまま値を返却する
    ; (補足：マイナスのときはMが成立)
    ret p

    ; Pフラグが成立していなければマイナスなので
    ; NEGで符号を逆転して返却する
    neg

    ret
    
;--------------------------------------------
; SUB-ROUTINE: Divide
; BC=HL/E
;--------------------------------------------
Divide:                          ; this routine performs the operation BC=HL/E
    ld a,e                       ; checking the divisor; returning if it is zero
    or a                         ; from this time on the carry is cleared
    ret z
    ld bc, -1                    ; BC is used to accumulate the result
    ld d,0                       ; clearing D, so DE holds the divisor
DivLoop:                         ; subtracting DE from HL until the first overflow
    sbc hl,de                    ; since the carry is zero, SBC works as if it was a SUB
    inc bc                       ; note that this instruction does not alter the flags
    jr nc,DivLoop                ; no carry means that there was no overflow
    ret

;--------------------------------------------
; SUB-ROUTINE: DivideBy8
; Aレジスタにセットされている内容を8で割る
; 商はDレジスタにセットされる
; 余はEレジスタにセットされる
;--------------------------------------------
DivideBy8:

    push bc

    ld b, a

    srl a           ; / 2
    srl a           ; / 4
    srl a           ; / 8

    ld d, a ; 商
    ld c, d

    sla c           ; * 2
    sla c           ; * 4
    sla c           ; * 8

    ld a, b
    sub c
    ld e, a

    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: CalcMulti
; 整数値の掛け算を行う
; Eレジスタに格納されている値とHレジスタに
; 格納されている値を掛けてその結果をHLレジスタ
; にセットして返却する
;--------------------------------------------
CalcMulti:

    ;
    ; 当サブルーチンではBレジスタとDレジスタ
    ; を破壊するためPUSHで退避しておく
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
; SUB-ROUTINE: NumToStr
; HLレジスタが指すアドレスに
; WK_NUMTOCHARVALに格納されている数値(0-255)を
; 最大3桁の10進数で格納する（右詰めとなる）
;--------------------------------------------
NumToStr:

    push bc
    push de
    push hl

    ; 数値表示領域を空白で埋める
    ld hl, WK_STRINGBUF
    ld a, $20
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a

    ld a, (WK_NUMTOCHARVAL)

    ; WK_NUMTOCHARVALの値が0であれば0だけ表示して
    ; 終了する
    or a
    jp z, NumToStr1thPlace
    
    ; 100を引いてもキャリーしなければ3桁ある
    cp 100
    jp c, NumToStr10thPlace

NumToStr100thPlace:

    ; 値を100で割り商を取得する
    ld h, 0
    ld l, a
    ld e, 100
    call Divide

    ; 商(Cレジスタ)に100を掛けた数字をWK_NUMTOCHARVALから減算する
    ld hl, WK_STRINGBUF
    ld a, $30
    add a, c
    ld (hl), a

    ld e, 100
    ld h, c
    call CalcMulti
    ld a, (WK_NUMTOCHARVAL)
    sub l ; A = WK_NUMTOCHARVAL - (C * 100)
    ld (WK_NUMTOCHARVAL), a

NumToStr10thPlace:

    ; 10を引いてもキャリーしなければ2桁ある
    cp 10
    jp c, NumToStr1thPlace

    ; 値を10で割り商を取得する
    ld h, 0
    ld l, a
    ld e, 10
    call Divide

    ; 商(Cレジスタ)に10を掛けた数字をWK_NUMTOCHARVALから減算する
    ld hl, WK_STRINGBUF + 1
    ld a, $30
    add a, c
    ld (hl), a

    ld e, 10
    ld h, c
    call CalcMulti
    ld a, (WK_NUMTOCHARVAL)
    sub l ; A = WK_NUMTOCHARVAL - (C * 10)
    ld (WK_NUMTOCHARVAL), a

NumToStr1thPlace:

    ld hl, WK_STRINGBUF + 2
    ld b, $30
    add a, b
    ld (hl), a

NumToStrEnd:

    pop hl
    pop de
    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: GetString
; HLレジスタが指すアドレスの文字列をNULLを
; 終端として読み込みWK_STRINGBUFに格納する
; 【文字列の最大長は32文字】とする
; Aレジスタには文字列長がセットされて
; 返却される
;--------------------------------------------
GetString:

    push bc
    push de
    push hl

    ; HLレジスタを退避
    ld d, h
    ld e, l

    ; ストリングバッファのクリア
    ld hl, WK_STRINGBUF
    ld bc, 32
    ld a, 0
    call MemFil

    ; HLレジスタを復帰
    ld h, d
    ld l, e

    ; WK_STRINGBUFは C000H
    ld de, WK_STRINGBUF

    ; 文字列読み込み

GetStingLoop:

    ld a, (hl)
    or a  ; NULL終端か？
    jp z, GetStringLoopEnd

    ld (de), a

    inc hl
    inc e
   
    jp GetStingLoop

GetStringLoopEnd:

    ld a, e

    pop hl
    pop de
    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: GetStringByIndex
; HLレジスタが指すアドレスの文字列から
; Bレジスタが指す回数ぶん0x00が出現した直後の
; 文字列を取得する
;
; 例)
; MESSAGE:
; defb "12345",0
; defb "ABC",0
; defb "CDE",0
;
; 2番目の文字列を取得したい場合
; 
;  ld hl, MESSAGE
;  ld b, 1 ; 2個目の文字列を取得(INDEXは0オリジン)
;  call GetStringByIndex
;  
; 【文字列の最大長は32文字】とする
; Aレジスタには抽出した文字列長がセットされて
; 返却される
;--------------------------------------------
GetStringByIndex:

    push bc
    push de
    push hl

    inc b

GetStringByIndexLoop:

    call GetString
    
    push bc

    ; NULL終端の次のアドレスにHLレジスタを進める
    ld b, 0
    ld c, a
    add hl, bc
    inc hl

    pop bc

    djnz GetStringByIndexLoop

    pop hl
    pop de
    pop bc

    ret
