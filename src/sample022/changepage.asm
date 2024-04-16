;-------------------------------------------
; 使用ページの初期化処理
;-------------------------------------------

ChangePage0Call:

    ;----------------------------------------------------------------
    ; ROMカセットのPage#0(0000H - 3FFFH)を
    ; Page#1(4000H - 7FFFH)から利用できるようにする
    ; また、同時に変数PAGE0_FUNCにセットされているアドレスをCALLする
    ; 処理終了後はPage#0は基本スロットのPage#0に戻し
    ; 基本スロットのPage#1とPage#2をROMのものに切り替える
    ;----------------------------------------------------------------

    ; 拡張スロットの有無を取得する
    ; 拡張スロットの有無はFFFFHに格納されている

    ld a, ($FFFF)
    cpl ; Aレジスタのすべてのビットを反転させる
    ld d, a  ; 拡張スロット情報をDレジスタに退避

    ;
    ; Page#0 - Page#3の基本スロット番号を取得する
    ;

    in a, ($A8) ; I/OポートのA8Hの値を取得
    ld e, a ; 基本スロットの情報をEレジスタに退避

    ; A8Hの値に00111100B をANDして
    ; Page#1, Page#2の基本スロット番号を取得
    and 00111100B
    ld b, a ; BレジスタにPage#1,Page#2の基本スロット番号を退避

    ; A8Hに値に00001100B をANDして
    ; Page#2の基本スロット番号を取得
    ld a, e
    and 00001100B
    rrca
    rrca ; ANDの結果を2ビット右にローテートさせる

    ld c, a ; Page#2の基本スロット番号をCレジスタに退避

    rrca
    rrca ; さらに2ビットローテートさせる

    or c ; A = A OR C
    or b ; A = A OR B

    di ; Interruptを無効化する

    out ($A8), a ; 基本スロット情報を書き換える

    ld a, ($FFFF) ; 拡張スロット情報を取得
    ld b, a
    cpl
    ld ($FFFF), a ; 拡張スロット情報を書き換える
    ld a, ($FFFF)
    cp b

    ; 拡張スロットが存在しない場合はNO_SSにジャンプ
    jr nz, NO_SS

    cpl
    and 11111100B
    ld b, a
    ld a, ($FFFF)
    cpl
    and 00001100B
    rrca
    rrca
    or b
    ld ($FFFF), a ; 拡張スロット情報を書き換える

NO_SS:

    ; Main-RAMのPage#2を使えるようにする

    ld a, e
    and 11000000B
    ld b, a
    in a, ($A8)        ; 基本スロット情報を取得
    and 00111111B
    or b
    out ($A8), a       ; Main-RAMのPage#2を使えるようにする

    ld a, ($FFFF)
    cpl
    and 00111111B
    ld b, a
    ld a, d
    and 11000000B
    or b
    ld ($FFFF), a      ; 拡張スロット情報を書き換える

    ;-------------------------------------------
    ; 変数PAGE0_FUNCにセットされている
    ; ROMカセットのPage#0の処理を呼び出す
    ; (Page#1からPage#0の処理を呼ぶ)
    ;-------------------------------------------

    ; PAGE0_FUNCのアドレスをCALLするため
    ; レジスタをいったん退避
    push af
    push bc
    push de
    push hl

    ;-------------------------------------------
    ; ROMカセットのPage#0のサブルーチンを呼び出す
    ; PAGE0_FUNC に呼び出し先アドレスをセットしておくこと
    ;-------------------------------------------

    ; BCレジスタにPage0FuncRetAddrのアドレスをセットして
    ; スタックにPUSH後、JPする
    ; JP先ではRETでBCレジスタのアドレスをPOPしそこにジャンプする

    ld bc, Page0FuncRetAddr

    push bc
    ld hl, (PAGE0_FUNC)
    jp (hl)

Page0FuncRetAddr:

    nop

    ;-------------------------
    ; 基本スロット情報と拡張スロット情報を元の状態に戻す
    ;-------------------------

    pop hl
    pop de
    pop bc
    pop af

    ld a, e
    out ($A8), a

    ld a, d
    ld ($FFFF), a

    ;----------------------------------------
    ; ROMのPage#1とPage#2を使えるようにする
    ;----------------------------------------

    call RSLREG
    rrca
    rrca
    and 3 ; Page#1の状態を保持する
    ld c, a
    ld b, 0
    ld hl, EXPTBL
    add hl, bc
    ld a, (hl)
    and 80h
    or c
    ld c,a
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, (hl)
    and 00001100B
    or c
    ld h, $80
    call ENASLT ; ROMカセットのPage#2を有効化する

    ei ; Interruptを有効化する

    ret
