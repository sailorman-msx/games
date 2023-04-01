;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize.asm"

    ;--------------------------------------------
    ; キャラクタパターンとカラーテーブルを
    ; 作成する
    ;--------------------------------------------
    call CreateCharacterPattern

    ; 画面に床キャラを敷き詰める
    ld bc, 768
    ld hl, $1800
    ld  a, '$'
    call FILVRM 

    ;--------------------------------------------
    ; スプライトと仮想アトリビュートテーブルを
    ; 作成する
    ;--------------------------------------------

    ld a, $0D
    ld (WK_PLAYERSPRCLR1), a

    ld a, $0F
    ld (WK_PLAYERSPRCLR2), a

    call CreateSpritePattern

    ;-------------------------------------------------
    ; メインループ(割り込み処理でMainProcを呼び出す)
    ;-------------------------------------------------
    ld a, 0
    ld (VSYNC_WAIT_CNT), a

    call INIT_H_TIMI_HANDLER

HTMIHookLoop:

    ; VRAM 1C00Hから128バイトぶんを
    ; VRAM 1B00Hに転送する
    call PutSprite

    ; VSYNC_WAIT_FLGの初期化
    ;   この値は以下の制御を行うために使用する：
    ;   - メインロジック開始時に 0 に設定
    ;   - H.TIMI割り込み処理の中でデクリメント (1/60秒ごとに呼び出し)
    ;   - メインロジックの最後に、キャリーがONになるまで待機
    ld a, 1
    ld (VSYNC_WAIT_CNT), a

    jp MainProc

VSYNC_Wait:

    ; 垂直帰線待ち
    ; VSYNC_WAIT_CNTが0になるまで待つ

    ld a, (VSYNC_WAIT_CNT)
    or a

    jr nz,VSYNC_Wait

    jr HTMIHookLoop

MainProc:

    ; 仮想スプライトアトリビュートテーブルを
    ; シャッフルする
    call ShuffleSprite

MainEnd:

    jp VSYNC_Wait

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "interval.asm"
include "psgdriver.asm"
include "common.asm"
include "sprite.asm"
include "data_sprite.asm"
include "pcg_graphic2.asm"
include "data_pcg.asm"
