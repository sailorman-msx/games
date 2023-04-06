;--------------------------------------------
; common.asm
; 共通処理のサブルーチン集
;--------------------------------------------

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
    ld (WK_RANDOM_VALUE), a         ; 乱数ワークエリアに保存

    pop bc
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
    call WRTVRMSERIAL

    ret

;---------------------------------------------------------
; SUB-ROUTINE: DelayLoop
; 空ループを繰り返し処理遅延をおこす
;---------------------------------------------------------
DelayLoop:

    ld b, 20 ; 20 * 255回空ループを繰り返す

DelayLoop1:

    ld a, $FF ; Aレジスタに$FF(255)をセット

DelayLoop2:

    dec a ; Aレジスタの値から1を減算する

    ; ZフラグがたっていなければDelayLoop2に戻る
    ; JRは間接アドレッシング指定と呼ばれるジャンプ
    jr nz, DelayLoop2

    ; Bレジスタの値から1を減算しZフラグがたっていなければDelayLoop1に戻る
    ; DJNZも間接アドレッシング指定
    djnz DelayLoop1

    ; ret で呼び出し元の次の命令アドレスに実行位置が戻る
    ret

