GameOverProc:

    call KILBUF

    ;----------------------------------------
    ; WK_GAMESTATUS_INTTIMEの値が0でなければ
    ; 何もせず、画面をスペースで塗りつぶす
    ;----------------------------------------
    ld a, (WK_GAMESTATUS_INTTIME)
    or a
    jp nz, GameOverProcDecInterval

    ld a, (WK_AKGSOUND_END)
    or a
    jp z, GameOverProcEnd

GameOverProcKeyin:

    ; KEY INPUT Handling
    call KeyInputProc

    ld a, (WK_TRIGGERA)
    or a
    jp z, GameOverProcNotTrigA

    xor a
    ld (WK_GAMESTATUS), a

    ; GameInitializeにジャンプする
    call GameInitialStartGame

GameOverProcNotTrigA:

    jp GameOverProcEnd

GameOverProcDecInterval:

    ; インターバルタイマが1であればゲームオーバー画面を
    ; 作成する
    ld a, (WK_GAMESTATUS_INTTIME)
    cp 2
    jp c, GameOverProcInit

    jp GameOverProcEnd

GameOverProcInit:

    ;--------------------------------------------
    ; ゲームオーバーBGMを開始する
    ;--------------------------------------------
    xor a
    ld (WK_AKGSOUND_END), a

    ld hl, MOMBGMLETSGOADVENTURE_START
    ld a, 3 ; Subsong 3
    call COMMON_AKG_INIT

    ;--------------------------------------------
    ; スプライト情報を初期化する
    ;--------------------------------------------
    ; 自キャラを消滅させる
    ld hl, WK_SPRITE_MOVETBL
    ld bc, 4
    add hl, bc
    ld a, 6
    ld (hl), a
    ld bc, 16
    add hl, bc
    ld (hl), a
    add hl, bc
    ld (hl), a

    ; テキキャラステータス欄のスプライトを消滅させる
    ; スプライト番号#30のポジションにセット
    ld hl, WK_SPRITE_MOVETBL + 30 * 16
    inc hl
    ld bc, 16
    ld a, 209
    ld (hl), a
    add hl, bc
    ld (hl), a 

    ;--------------------------------------------
    ; ゲームオーバー画面を表示する
    ;--------------------------------------------
    ld hl, WK_VIRT_PTNNAMETBL
    ld bc, 32 * 3
    ld a, $24
    call MemFil

    ld hl, MESSAGE_GAMEOVER
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 1 * 32 + 10
    ld  b, 0
    ld  c, a
    call MemCpy
    
    ld a, 1
    ld (WK_REDRAW_FINE), a
    ld (WK_SPRREDRAW_FINE), a

    ; トリガを無効にする
    xor a
    ld (WK_TRIGGERA), a
    ld (WK_TRIGGERB), a

    jp NextHTIMIHook

GameOverProcEnd:

    ; ゲームオーバ画面でもテキキャラを動かす
    call MoveEnemy
    call SetVirtAttrTable
    call ShuffleSprite

    jp NextHTIMIHook
