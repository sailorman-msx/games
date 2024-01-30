GameInitialize:

    ;-------------------------------------------
    ; 画面構成の初期化
    ;-------------------------------------------
    ld a, $0F
    ld (FORCLR), a   ;白色
    ld a, $01
    ld (BAKCLR), a   ;黒色
    ld (BDRCLR), a   ;黒色

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a  ;スプライトモードを16X16に

    ; FDD搭載機であればインタースロットコールする
    ld ix, CHGMOD
    ld a, (H_PHYDIO)
    cp $C9
    jp z, NORMAL_CHGMOD

CALSLT_CHGMOD:

    ld a, 1
    ld ix, CHGMOD
    call BiosInterSlotCall

    jp SetGraphic2

NORMAL_CHGMOD:

    ld a, 1
    ld de, CHGMOD
    call BiosCall      ;スクリーンモード変更

SetGraphic2:

    ; FDD搭載機であればインタースロットコールする
    ld a, (H_PHYDIO)
    cp $C9
    jp z, NORMAL_SETGRP2

    ld ix, SETGRP
    call BiosInterSlotCall

    jp SetWidth32

NORMAL_SETGRP2:

    ; GRAPHIC2モードに変更する
    call SETGRP

SetWidth32:

    ld a, 32         ;WIDTH=32
    ld (LINWID), a

SetERAFNK:

    ; FDD搭載機であればインタースロットコールする
    ld a, (H_PHYDIO)
    cp $C9
    jp z, NORMAL_SETERAFNK

    ld ix, ERAFNK
    call BiosInterSlotCall

    jp SetCLIKSW

NORMAL_SETERAFNK:

    call ERAFNK

SetCLIKSW:

    ;カチカチ音を消す
    xor a
    ld (CLIKSW), a

    ; ひらがなフォントを作成する
    ld a, 2
    ld (WK_VALUE08), a
    call CreateCharacterPattern

    call InitialPCGDatas

    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPattern

    ; 英数フォントを作成する
    ld a, 1
    ld (WK_VALUE08), a
    call CreateCharacterPattern

    ;-------------------------------------------
    ; 変数領域の初期化（ゼロクリア）
    ;-------------------------------------------
    xor a
    ld hl, $C000
    ld bc, $1000 ; C000H-CFFFHまでのアドレスに0をセットする
    call MemFil

    ld hl, $D000
    ld bc, $0E3F ; D000H-DE3FHまでのアドレスに0をセットする
    call MemFil

GameInitialStartGame:

    xor a
    ld (WK_SPRITE0_NUM), a

    ;--------------------------------------------
    ; 乱数のSEED値を初期化する
    ;--------------------------------------------
    call InitRandom

    ;--------------------------------------------
    ; CLEAR SCREEN
    ;--------------------------------------------
    call ClearScreen

    ;--------------------------------------------
    ; スプライトパターンを作成する
    ;--------------------------------------------
    call CreateSpritePattern

    ;--------------------------------------------
    ; 角度情報の初期化
    ;--------------------------------------------
    ld a, 63
    ld (WK_ANGLE), a

    ;--------------------------------------------
    ; アニメーション用パターン番号
    ;--------------------------------------------
    xor a
    ld (WK_ANIME_PTN), a

    ;--------------------------------------------
    ; ゲームを開始する
    ;--------------------------------------------
    ld a, 1
    ld (WK_GAMESTATUS), a

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ;-------------------------------------------------
    ; 割り込み処理の初期処理
    ;-------------------------------------------------
    xor a
    ld (VSYNC_WAIT_CNT), a

    call INIT_H_TIMI_HANDLER

    ret
