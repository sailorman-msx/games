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

    di

    call CreateSpritePattern
    call CreateSpriteMoveTable

    ld hl, MAPDATA_DEFAULT
    ld de, $1800
    ld bc, 768
    call WRTVRMSERIAL

    ld hl, $1800
    ld  a, $B8
    ld bc, 10
    call WRTVRMFIL

    ld hl, BONUS_COLOR_MESSAGE
    ld de, $1819
    ld bc, 5
    call WRTVRMSERIAL

    call GetSpriteColor
    ld (WK_BONUS_BALL_CLR), a

    ld a, $BA
    ld (WK_CHARCODE), a
    call GetCharacterVRAMAddress

    ;
    ; BONUS BALL左上
    ;
    ld hl, $2000   ; DEレジスタに2000Hを加算する
    add hl, de
   
    ld a, (WK_BONUS_BALL_CLR)
    sla a
    sla a
    sla a
    sla a
    or $01
    ld bc, 8  ; 8バイト転送する
    call WRTVRMFIL

    ;
    ; BONUS BALL左下
    ;
    ld a, (WK_CHARCODE)
    inc a
    ld (WK_CHARCODE), a
    call GetCharacterVRAMAddress

    ld hl, $2000
    add hl, de

    ld a, (WK_BONUS_BALL_CLR)
    sla a
    sla a
    sla a
    sla a
    or $01
    ld bc, 8  ; 8バイト転送する
    call WRTVRMFIL

    ;
    ; BONUS BALL右上
    ;
    ld a, (WK_CHARCODE)
    inc a
    ld (WK_CHARCODE), a
    call GetCharacterVRAMAddress

    ld hl, $2000
    add hl, de

    ld a, (WK_BONUS_BALL_CLR)
    sla a
    sla a
    sla a
    sla a
    or $01
    ld bc, 8  ; 8バイト転送する
    call WRTVRMFIL

    ;
    ; BONUS BALL右上
    ;
    ld a, (WK_CHARCODE)
    inc a
    ld (WK_CHARCODE), a
    call GetCharacterVRAMAddress

    ld hl, $2000
    add hl, de

    ld a, (WK_BONUS_BALL_CLR)
    sla a
    sla a
    sla a
    sla a
    or $01
    ld bc, 8  ; 8バイト転送する
    call WRTVRMFIL

    ; ボーナスボール
    call GameMainDisplayBonusBall

    ; タイマー値の初期化
    ld hl, 300
    ld (WK_COUNTDOWN_TIMER), hl

    ld a, 0
    ld (WK_TIMI60), a
    
    ei

    ; BGMを鳴らす
    ld hl, BGM_00
    call SOUNDDRV_BGMPLAY

GameMainProcInitEnd:

    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    ld (WK_GAMESTATUS_INTTIME), a

GameMainEnd:

    jp VSYNC_Wait

GameMainDisplayBonusBall:

    ld hl, $181E
    ld a, $BA
    call WRTVRM

    ld hl, $183E
    ld a, $BB
    call WRTVRM

    ld hl, $181F
    ld a, $BC
    call WRTVRM

    ld hl, $183F
    ld a, $BD
    call WRTVRM

    ret
