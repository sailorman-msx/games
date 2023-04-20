;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize.asm"

    call InitRandom

    ;--------------------------------------------
    ; キャラクタパターンとカラーテーブルを
    ; 作成する
    ;--------------------------------------------
    call CreateCharacterPattern

    ld a, $0D
    ld (WK_PLAYERSPRCLR1), a

    ld a, $0F
    ld (WK_PLAYERSPRCLR2), a

    ;--------------------------------------------
    ; 画面情報を作成する
    ; WK_STAGE_NUMにはボールの個数がセットされる
    ;--------------------------------------------
    ld a, 9
    ld (WK_STAGE_NUM), a

    ; ゲームステータスの初期化
    ld a, 2
    ld (WK_GAMESTATUS), a

    ; シーン切り替えタイマーに値をセット
    ; タイマーの値は1/60秒ごとにデクリメントされる
    ld a, 60
    ld (WK_GAMESTATUS_INTTIME), a

    ;-------------------------------------------------
    ; 割り込み処理の初期処理
    ;-------------------------------------------------
    ld a, 0
    ld (VSYNC_WAIT_CNT), a

    call INIT_H_TIMI_HANDLER

HTMIHookLoop:

    ; VSYNC_WAIT_FLGの初期化
    ;   この値は以下の制御を行うために使用する：
    ;   - メインロジック開始時に 0 に設定
    ;   - H.TIMI割り込み処理の中でデクリメント (1/60秒ごとに呼び出し)
    ;   - メインロジックの最後に、キャリーがONになるまで待機
    ld a, 1
    ld (VSYNC_WAIT_CNT), a

    ld a, (WK_GAMESTATUS)
    cp 2
    jp z, GameMainProc

VSYNC_Wait:

    ; 垂直帰線待ち
    ; VSYNC_WAIT_CNTが0になるまで待つ

    ld a, (VSYNC_WAIT_CNT)
    or a

    jr nz,VSYNC_Wait

    jr HTMIHookLoop

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "keyinput.asm"
include "player.asm"
include "ball.asm"
include "game.asm"
include "interval.asm"
include "psgdriver.asm"
include "common.asm"
include "vram.asm"
include "sprite.asm"
include "data_sprite.asm"
include "pcg_graphic2.asm"
include "data_pcg.asm"
include "data_map.asm"
