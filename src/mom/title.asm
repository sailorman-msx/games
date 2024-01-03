;--------------------------------------------------
; title.asm
; タイトル画面処理
; WK_GAMESTATUSの値が0の時に1/60秒ごとにCALLされる
; スペースキーかAボタンでゲーム処理に遷移する
;--------------------------------------------------
TitleDisplayProc:

    ld a, (WK_LOOP_COUNTER)
    cp 5
    jr z, TitleDisplayProcGenPtn
    cp 4
    jr z, TitleDisplayProcPrintLogo
    cp 3
    jr z, TitleDisplayProcKeyIn
    cp 1
    jp z, TitleDisplayProcInit

TitleDisplayProcKeyIn:

    call KeyInputProc

    ld a, (WK_TRIGGERA)
    cp 1
    jp z, TitleDisplayProcInitTrigA
    cp $11
    jp z, TitleDisplayProcInitTrigA

    jp TitleDisplayProcEnd

TitleDisplayProcGenPtn:

    nop

    jp TitleDisplayProcDecEnd

TitleDisplayProcPrintLogo:

    ; タイトル画面を表示する
    ld hl, WK_VIRT_PTNNAMETBL
    ld bc, 768
    ld a, $20
    call MemFil

    ld de, WK_VIRT_PTNNAMETBL + 32 * 5 + 12
    ld hl, TITLE_LOGO_1
    ld bc, 8
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 32 * 6 + 12
    ld hl, TITLE_LOGO_2
    ld bc, 8
    call MemCpy
    
    ld de, WK_VIRT_PTNNAMETBL + 32 * 7 + 12
    ld hl, TITLE_LOGO_3
    ld bc, 8
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 32 * 8 + 12
    ld hl, TITLE_LOGO_4
    ld bc, 8
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 32 * 9 + 12
    ld hl, TITLE_LOGO_5
    ld bc, 8
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 32 * 10 + 12
    ld hl, TITLE_LOGO_6
    ld bc, 8
    call MemCpy

    ld de, WK_VIRT_PTNNAMETBL + 32 * 14
    ld bc, 32
    ld a, (WK_GAME_STARTFLG)
    or a
    jr z, TitleSetContinueMsg

    ld hl, TITLE_MESSAGE_1
    jr TitleSetDispMsg

TitleSetContinueMsg:
    ld hl, TITLE_MESSAGE_5

TitleSetDispMsg:

    call MemCpy

    ld hl, TITLE_MESSAGE_2
    ld de, WK_VIRT_PTNNAMETBL + 32 * 17 + 2
    ld bc, 28
    call MemCpy

    ; MSXの言語仕様によってメッセージを決める
    ld de, WK_VIRT_PTNNAMETBL + 32 * 20 + 7

    ld a, ($002C) ; KEYBOAD LOCALE
    or a
    jr nz, TitleSetEnglish

    ld hl, TITLE_MESSAGE_4

    jr TitleSetLangMessage

TitleSetEnglish:

    ld hl, TITLE_MESSAGE_3

TitleSetLangMessage:
    
    ld bc, 17
    call MemCpy

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ; トリガを無効にする
    xor a
    ld (WK_TRIGGERA), a
    ld (WK_TRIGGERB), a

    jr TitleDisplayProcDecEnd

TitleDisplayProcInitTrigA:

    ; ゲーム開始のBGMを鳴らす
    ld hl, MOMBGMLETSGOADVENTURE_START
    ld a, 2 ; Subsong 2
    call COMMON_AKG_INIT

    ; キーバッファを消去する
    call KILBUF

    ld a, 1
    ld (WK_REDRAW_FINE), a

    call ClearScreen

    jr TitleDisplayProcDecEnd

TitleDisplayProcInit:

    ; WK_GAMESTATUSの値が0の場合は次の
    ; ゲームステータス値をセットする
    ld a, 5
    ld (WK_MAPCHANGE_COUNT), a
    ld a, 30
    ld (WK_GAMESTATUS_INTTIME), a
    ld a, 2
    ld (WK_GAMESTATUS), a

    ;-------------------------------------------------
    ; ゲーム初期画面作成処理
    ;-------------------------------------------------
    call GameMainProcInit

    jp TitleDisplayProcEnd

TitleDisplayProcDecEnd:

    ld a, (WK_LOOP_COUNTER)
    dec a
    ld (WK_LOOP_COUNTER), a
 
TitleDisplayProcEnd:

    jp NextHTIMIHook

