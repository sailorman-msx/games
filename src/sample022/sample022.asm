;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize.asm"

    call GameInitialize

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

    ld a, (WK_GAMESTATUS)
    cp 1
    jp z, TitleDisplayProc    ; 1:タイトル画面
    cp 2
    jp z, GameMainProc        ; 2:通常モード
    cp 3
    jp z, DialogProc          ; 3:ダイアログモード
    cp 4
    jp z, GameOverProc        ; 4:ゲームオーバーモード

    jr NextHTIMIHook

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
include "common.asm"
include "changepage.asm"
include "gameinit.asm"
include "game.asm"
include "dialog.asm"
include "title.asm"
include "gameover.asm"
include "keyinput.asm"
include "interslotcall.asm"
include "sprite.asm"

include "vram.asm"
include "interval.asm"

include "data_trigono.asm"

include "variable_define.asm"
