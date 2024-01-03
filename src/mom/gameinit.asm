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

    ;--------------------------------------------
    ; キャラクタパターンとカラーテーブルを
    ; 作成する
    ;--------------------------------------------
    ; ひらがなフォントを作成する
    ld a, 2
    ld (WK_VALUE08), a
    call CreateCharacterPattern

    call InitialPCGDatas

    xor a
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
    ld bc, $0D80 ; D000H-DD7Fまでのアドレスに0をセットする
    call MemFil

    ; ゲームスタートフラグの初期化
    ld a, 1
    ld (WK_GAME_STARTFLG), a

GameInitialStartGame:

    xor a
    ld (WK_SPRITE0_NUM), a

    ; フォントを作成する
    ld a, 1
    ld (WK_VALUE08), a
    call CreateCharacterPattern

    ld a, 2
    ld (WK_VALUE08), a
    call CreateCharacterPattern

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
    ld a, $0D ; Pink
    ld (WK_PLAYERSPRCLR1), a

    ld a, $0B ; Yellow
    ld (WK_PLAYERSPRCLR2), a

    ld a, $0F ; White
    ld (WK_PLAYERSPRCLR3), a

    call CreateSpritePattern

    xor a
    ld (WK_PLAYERANIMEVAL), a ; WK_PLAYERANIMECNTに加算する値の初期化
    ld (WK_PLAYERANIMECNT), a ; WK_PLAYERANIMECNTの初期化

    ; MAP座標の初期化
    ld (WK_MAPPOSX), a
    ld (WK_MAPPOSY), a

    ; ゲームクリアフラグの初期化
    ld (WK_GAMECLEAR), a

    ; マップ種別の初期化
    ld (WK_MAPTYPE), a

    ; PCGアニメーションのインターバル値をセット
    ; インターバル値=30/60秒
    xor a
    ld (WK_ANIME_FLG), a ; アニメーションフラグの初期化

    ; PITの出入りフラグに0をセット
    ld (WK_PIT_ENTER_FLG), a

    ; スプライトの下半身を消すか否かのフラグを初期化
    ld (WK_IN_WATER_FLG), a

    ; ダメージ値表示用変数の初期化
    xor a
    ld (WK_NUMTOCHARVAL), a

    ; 剣（攻撃時）カウンタの初期化
    ld (WK_SWORDACTION_COUNT), a

    ; プレイヤー衝突インターバルの初期化
    ld (WK_PLAYER_COLLISION), a

    ; BGCOLOR変更フラグの初期化
    ld (WK_BGCOLOR_CHGFLG), a

    ; WK_MOVE_ENEMY_COUNTERの初期化
    ld (WK_MOVE_ENEMY_COUNTER), a

    ; サウンドを初期化する
    ld hl, SOUNDEFFECTS
    call PLY_AKG_INITSOUNDEFFECTS
   
    ; BGMを鳴らす 
    ld hl, MOMBGMLETSGOADVENTURE_START
    ld a, 4 ; Subsong 4 
    call COMMON_AKG_INIT

    ; シーン切り替えタイマーに値をセット
    ; タイマーの値は1/60秒ごとにデクリメントされる
    ld a, 60
    ld (WK_GAMESTATUS_INTTIME), a

    ld a, 5
    ld (WK_LOOP_COUNTER), a

    xor a
    ld (WK_VALUE08), a
    ld hl, CHRPTN_TITLE_LOGO
    ld (WK_CHARDATAADR), hl
    call CreateCharacterPatternLoop

    ld a, 1
    ld (WK_GAMESTATUS), a

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ret
