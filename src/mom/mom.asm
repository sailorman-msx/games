;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize.asm"

    call GameInitialize

    ;-------------------------------------------------
    ; 割り込み処理の初期処理
    ;-------------------------------------------------
    xor a
    ld (VSYNC_WAIT_CNT), a

    call INIT_H_TIMI_HANDLER

HTIMIHookLoop:

    ; VSYNC_WAIT_FLGの初期化
    ;   この値は以下の制御を行うために使用する：
    ;   - メインロジック開始時に 0 に設定
    ;   - H.TIMI割り込み処理の中でデクリメント (1/60秒ごとに呼び出し)
    ld a, 1
    ld (VSYNC_WAIT_CNT), a

VSYNC_Wait:

    ; 垂直帰線待ち
    ; VSYNC_WAIT_CNTが0になるまで待つ
    ei
    ld a, (VSYNC_WAIT_CNT)
    or a
    jr nz,VSYNC_Wait

StartGameMain:

    push af
    push bc
    push de
    push hl
    push ix
    push iy

    ;---------------------------------------------------
    ; マップ切替カウンタによって処理を行う
    ; WK_MAPCHANGE_COUNT
    ;  5: ClearSprite
    ;  4: ClearScreen
    ;  1: ChangeMapView
    ;---------------------------------------------------
    ld a, (WK_MAPCHANGE_COUNT)
    or a
    jr z, SkipMapChange

    ld a, (WK_MAPCHANGE_COUNT)
    cp 5
    jr z, StartGameMainClearSprite    ; カウンタが3であればClearSpriteを呼び出す
    cp 4
    jr z, StartGameMainClearScreen    ; カウンタが2であればClearScreenを呼び出す
    cp 1
    jr z, StartGameMainChangeMapView     ; カウンタが1であればChangeMapViewを呼び出す

    jr StartGameMainMapChangeDec

StartGameMainClearSprite:

    ; カウンタが3であればClearSpriteを呼び出す
    call ClearSprite
    ld a, 1
    ld (WK_SPRREDRAW_FINE), a
    jr StartGameMainMapChangeDec

StartGameMainClearScreen:

    ; カウンタが2であればClearScreenを呼び出す
    call ClearScreen
    ld a, 1
    ld (WK_REDRAW_FINE), a
    jr StartGameMainMapChangeDec

StartGameMainChangeMapView:

    ; カウンタが1であればChangeMapViewを呼び出す
    call ChangeMapView

    ld a, 10
    ld (WK_TIME10), a

    ld a, 1
    ld (WK_SPRREDRAW_FINE), a
    ld (WK_REDRAW_FINE), a

StartGameMainMapChangeDec:

    ld a, (WK_MAPCHANGE_COUNT)
    dec a
    ld (WK_MAPCHANGE_COUNT), a

    jr NextHTIMIHook

SkipMapChange:

    ;---------------------------------------------------
    ; アニメーション処理中は何もしない
    ;---------------------------------------------------

    ; 永久回廊でマップが戻されたら
    ; メッセージを表示する
    ld a, (WK_CORRIDOR_RETURN)
    or a
    jr z, SkipCorridorMessage

    ; マップが戻されたらダイアログを表示する
    ld a, 2
    ld (WK_DIALOG_TYPE), a

    ld a, ($002C)
    or a
    jr z, CorridorMsgJP

    ld hl, MESSAGE_DIALOG_MESSAGE_CORRIDOR_RETURN_EN
    jr SetCorridorMsg

CorridorMsgJP:

    ld hl, MESSAGE_DIALOG_MESSAGE_CORRIDOR_RETURN_JP

SetCorridorMsg:

    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl

    ld a, 3
    ld (WK_GAMESTATUS), a

    xor a
    ld (WK_CORRIDOR_RETURN), a
  
SkipCorridorMessage:
    
    ld a, (WK_GAMESTATUS)
    or a
    call z, GameInitialize    ; 0:画面の初期化
    cp 1
    jp z, TitleDisplayProc    ; 1:タイトル画面
    cp 2
    jp z, GameMainProc        ; 2:通常モード
    cp 3
    jp z, DialogProc          ; 3:ダイアログモード
    cp 4
    jp z, GameOverProc        ; 4:ゲームオーバーモード
    cp 5
    jp z, GameClear           ; 5:ゲームクリア

    jr NextHTIMIHook

GameClear:

    ld a, (WK_GAMESTATUS_INTTIME)
    or a
    jr nz, NextHTIMIHook

    ld a, ($002C)
    or a
    jr z, GameClearJP

    ld hl, MESSAGE_DIALOG_GAME_CLEAR_EN
    jr GameClearDispDialog

GameClearJP:

    ld hl, MESSAGE_DIALOG_GAME_CLEAR_JP

GameClearDispDialog:

    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl
    ld a, 3
    ld (WK_GAMESTATUS), a
    ld (WK_GAMESTATUS_INTTIME), a
    ld a, 8
    ld (WK_DIALOG_TYPE), a

    ld hl, MOMBGMLETSGOADVENTURE_START
    xor a
    call COMMON_AKG_INIT

NextHTIMIHook:

    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af

    jp HTIMIHookLoop

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "gameinit.asm"
include "interslotcall.asm"
include "interval.asm"
include "keyinput.asm"
include "player.asm"
include "enemy.asm"
include "collision.asm"
include "battle.asm"
include "dialog.asm"
include "item.asm"
include "door.asm"
include "title.asm"
include "game.asm"
include "gameover.asm"
include "map.asm"
include "peephole.asm"
include "torch.asm"
include "animation.asm"
include "common.asm"
include "vram.asm"
include "sprite.asm"
include "pcg_graphic2.asm"
include "int_graphic2.asm"
include "data_message.asm"
include "data_sprite.asm"
include "data_pcg.asm"
include "data_map.asm"
include "data_item.asm"
include "AKGPlay2.asm"
