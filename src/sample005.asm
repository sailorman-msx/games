;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize_gr2.asm"

;--------------------------------------------
; メイン処理
;--------------------------------------------
Main:

    ;--------------------------------------------
    ; キャラクタパターンとカラーテーブルを
    ; 作成する
    ;--------------------------------------------
    call CreateCharacterPattern

    ;--------------------------------------------
    ; 文字コード80Hの文字を256バイトぶん
    ; VRAMのパターンネームテーブルに埋める
    ; (横32文字 x 縦8行＝256バイト)
    ;--------------------------------------------
    ld hl, $1800
    ld  a, $80
    call PutVRAM256Bytes

    ;--------------------------------------------
    ; 文字コード88Hの文字を256バイトぶん
    ; VRAMのパターンネームテーブルに埋める
    ; (横32文字 x 縦8行＝256バイト)
    ;--------------------------------------------
    ld hl, $1900
    ld  a, $81
    call PutVRAM256Bytes

    ;--------------------------------------------
    ; 文字コード88Hの文字を256バイトぶん
    ; VRAMのパターンネームテーブルに埋める
    ; (横32文字 x 縦8行＝256バイト)
    ;--------------------------------------------
    ld hl, $1A00
    ld  a, $80
    call PutVRAM256Bytes

    ;
    ; 16バイト分のデータを画面にDUMP出力する
    ;
    ld hl, CHRPTN       ; CHRPTNのアドレスの内容を
    ld de, WK_DUMPDATA  ; WK_DUMPDATAのアドレスに
    ld bc, 16           ; 16バイト転送する
    ldir

    call PrintHexaDump

    ;
    ; WK_DUMPCHARのアドレスの内容を
    ; 画面上の下段(1A00H)に32バイト転送する
    ;
    ld de, $1A00
    call HexaDumpToVRAM

    ;--------------------------------------------
    ; その他のキャラ(PCGの16x16キャラを表示する)
    ;--------------------------------------------
    ld hl, $1ADC
    ld  a, $98
    call WRTVRM
    ld hl, $1AFC
    ld  a, $99
    call WRTVRM
    ld hl, $1ADD
    ld  a, $9A
    call WRTVRM
    ld hl, $1AFD
    ld  a, $9B
    call WRTVRM

    ld hl, $1ADE
    ld  a, $A8
    call WRTVRM
    ld hl, $1AFE
    ld  a, $A9
    call WRTVRM
    ld hl, $1ADF
    ld  a, $AA
    call WRTVRM
    ld hl, $1AFF
    ld  a, $AB
    call WRTVRM

MainEnd:
    jr MainEnd

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "pcg_graphic2.asm"
include "common.asm"
include "data_gr2.asm"
