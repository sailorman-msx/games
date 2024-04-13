;
; ROMカセットのPage#0を使えるようにするためのサンプル
;
; 参考）https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM
;

LF:equ $0A
CR:equ $0D

; BIOSサブルーチン

CHRPUT:equ $00A2
ENASLT:equ $0024
INIT32:equ $006F
RSLREG:equ $0138
SETWRT:equ $0053

PageSize:    equ    4000h    ; 16kB

; ワークエリア
LINL32:equ $F3AF
CSRX:equ $F3DD ; 画面上のカーソルX座標
CSRY:equ $F3DC ; 画面上のカーソルY座標

; 拡張スロット有無テーブル
EXPTBL:equ $FCC1
 
;
; 0000H - 3FFFH にも処理を記述できる
;

    org 0000h

;------------------------------
; ここからROMカセットのPage#0
; 0000H - 
;------------------------------

    ; 表示するテキストのアドレスをHLレジスタにセット
    ld hl, Page0000hTXT

    ; ROMカセットのPage#0に存在する
    ; PrintP0サブルーチンを呼び出す

    call PrintP0

    ret

; Page0000hTXTの文字列を0x00を終端として
; 1文字ずつPUTする

PrintP0:

    ; HLレジスタのアドレスの値をAレジスタにセット
    ld a,(hl)

    cp LF ; LFか？
    jr z, Code_LF  ; LFであれば改行して次の文字を処理する
    cp CR ; CRか？
    jr z, Code_CR  ; CRであれば文字を1に戻して次の文字を処理する

    and a ; Aレジスタはゼロか？（CP 0と同様だがこちらのほうが速い）
    ret z ; ゼロならCALL元に戻る

    ; VDPに直接値を書き込む
    ; Page#0はROMカセットの状態なのでBIOSコールは出来ない
    ; そのため画面表示はVDPを直接叩くことで実現させる
    out ($98),a

    ; HLアドレスをカウントアップする
    inc hl

    push hl       ; HLレジスタを退避

    ld hl, CSRX   ; カーソル位置Xをカウントアップする（右にずらす）
    inc (hl)

    pop hl        ; HLレジスタを復帰

    jr PrintP0    ; ループに戻る

; CRを見つけたらカーソル位置Xを1に戻す
Code_CR:

    push af       ; AFレジスタを退避
    ld a, 1
    ld (CSRX), a
    pop af        ; AFレジスタを復帰

    inc hl

    jr PrintP0

; LFを見つけたらカーソル位置Yを1加算する
Code_LF:

    push hl       ; HLレジスタを退避
    ld hl, CSRY
    inc (hl)
    pop hl        ; HLレジスタを復帰

    inc hl

    jr PrintP0

; メッセージデータ
Page0000hTXT:
defb "Text from page 0000h-3FFFh",LF,CR
defb 0x00 ; End of Data

; ROMのPage#0の3FFFHまでのメモリ領域をFFHで埋めておく
defs PageSize - $,255    ; Fill the unused aera with 0FFh

;------------------------------
; ここからROMカセットのPage#1
; 4000H - 
;------------------------------

; ROMヘッダ（お約束）
defb "AB"     ;
defw INIT     ; メインプログラム開始アドレス
defw 0        ;
defw 0        ;
defw 0        ;
defw 0,0,0    ;

INIT:

    ;----------------------------------
    ; 画面の初期化
    ;----------------------------------

    ; WIDTH=32
    ld a, 32
    ld (LINL32), a

    ; SCREEN 1
    call INIT32

    ld hl, $1800
    call SETWRT ; VRAM $1800H以降を書き込める状態にする

    ;----------------------------------
    ; ROMカセットのPage#0(0000H - 3FFFH)をPage#1(4000H - 7FFFH)から利用できるようにする
    ;----------------------------------

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

    ;-------------------------
    ; ROMカセットの0000Hを呼び出す(Page#1からPage#0の処理を呼ぶ)
    ;-------------------------
    call 0000h

    ;-------------------------
    ; 基本スロット情報と拡張スロット情報を元の状態に戻す
    ;-------------------------
    ld a, e
    out ($A8), a

    ld a, d
    ld ($FFFF), a

NO_SS2:

    ei ; Interruptを有効化する

    ;----------------------------------------
    ; ROMのPage#1からPage#2を使えるようにする
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

    ; Page#1に設定されている文字列を画面に出力する
    ld hl,Page4000hTXT

    ; PrintサブルーチンはPage#1に存在する
    call Print

    jp $8000  ; Page#2に書かれている処理にジャンプ
 
; Page4000hTXTの文字列を0x00を終端として
; 1文字ずつPUTする
; この時点ではPage#0はBIOS ROMに切り替わっているため
; 文字出力をBIOSサブルーチン呼び出しで実現させていることに注目

Print:

    ld a,(hl)
    and a
    ret z
    call CHRPUT ; BIOSサブルーチン
    inc hl
    jr  Print
 
; メッセージデータ
Page4000hTXT:
defb "Text from page 4000h-7FFFh",LF,CR
defb 0x00 ; End of Data

; ROMのPage#1の7FFFHまでのメモリ領域をFFHで埋めておく
defs PageSize - ($ - 4000h), $FF

;------------------------------
; ここからROMカセットのPage#2
; 8000H - 
;------------------------------

    ld hl,Page8000hTXT
    call Print
 
Finished:
    jr Finished ; 無限ループさせる

Page8000hTXT:
defb "Text from page 8000h-BFFFh"
defb 0x00 ; End of Data

; ROMのPage#2のBFFFHまでのメモリ領域をFFHで埋めておく
defs PageSize - ($ - 8000h), $FF
