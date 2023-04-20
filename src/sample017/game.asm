GameMainProc:

    ;----------------------------------------
    ; ステージ初期処理呼び出し
    ; WK_GAMESTATUS_INTTIMEの値が0になるまで
    ; 画面情報を更新し続ける
    ;----------------------------------------
    ld a, (WK_GAMESTATUS_INTTIME)
    cp 1
    jp nc, GameMainProcInit

    ;----------------------------------------
    ; キー入力呼び出し
    ;----------------------------------------
    call KeyInputProc

    ;----------------------------------------
    ; プレイヤー移動処理
    ;----------------------------------------
    call PlayerMove

    ;----------------------------------------
    ; スプライト座標を更新する
    ;----------------------------------------
    call MoveSprite

    ;----------------------------------------
    ; 仮想スプライトアトリビュートテーブルを
    ; 更新する
    ;----------------------------------------
    call SetVirtAttrTable

    ;----------------------------------------
    ; 仮想スプライトアトリビュートテーブルを
    ; シャッフルする
    ;----------------------------------------
    call ShuffleSprite

    jp GameMainEnd

GameMainProcInit:

    ;--------------------------------------------
    ; スプライトと仮想アトリビュートテーブルを
    ; 作成する
    ;--------------------------------------------
    cp 10  ; 50/60秒で初めてVRAMに描きにいく(遅延させてる)
    jp nz, GameMainProcInitEnd

    ; RANDOM SEED値の更新を行う
    call InitRandom

    di

    call CreateSpritePattern
    call CreateSpriteMoveTable

    ld hl, MAPDATA_DEFAULT
    ld de, $1800
    ld bc, 768
    call WRTVRMSERIAL

    call GetSpriteColor

    ld a, 0
    ld (WK_TIMI60), a
    
    ei

GameMainProcInitEnd:

    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    ld (WK_GAMESTATUS_INTTIME), a

GameMainEnd:

    jp VSYNC_Wait
