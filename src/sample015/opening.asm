;--------------------------------------------------
; opening.asm 
; オープニング画面処理
; WK_GAMESTATUSの値が1の時に1/60秒ごとに呼び出される
; WK_GAMEINTTIMEの数が0になるまで呼び出される
;--------------------------------------------------
OpeningProc:

    ld a, (WK_GAMESTATUS_INTTIME)
    cp 1
    jp z, OpeningProcToStart

OpeningProcInit:

    ; キーボードバッファをクリアする
    ; これを呼び出さないとカーソルキーを正常に判定できない
    call KILBUF

    ; スペースキーが押されているか？
OpeningProc_IsSPACE:

    ld a, 0
    call GTTRIG
    cp $FF
    jr nz, OpeningProc_IsAbutton

    ; 効果音を鳴らす
    ld hl, SFX_03
    call SOUNDDRV_SFXPLAY

    ld a, 0
    ld (WK_GAMESTATUS_INTTIME), a

    jp OpeningProcToStart

    ; ジョイスティック1のAボタンが押されているか？
OpeningProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jp nz, OpeningProcEnd

    ; 効果音を鳴らす
    ld hl, SFX_03
    call SOUNDDRV_SFXPLAY

    ld a, 0
    ld (WK_GAMESTATUS_INTTIME), a

    jp OpeningProcToStart

OpeningProcToStart:

   ; 画面表示を行う
   ;--------------------------------------------
   ; マップデータ（ゲーム画面）のデータを
   ; VRAM(1800H-1AFFH)に書き込む
   ;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_DEFAULT
    ld bc, 768
    call LDIRVM

    ; ライフゲージを表示する
    call DisplayLifeGauge

    ; ステータス表示（アイテム利用）を行う
    call DisplayFireballEnable

    ; ステータス表示（カギ保有状態）を行う
    call DisplayHaveKey

    ; プレイヤーのジョイスティック方向にあわせた
    ; スプライトを初期表示する
    ld a, 3 
    ld (WK_PLAYERPOSX), a
    ld (WK_PLAYERPOSXOLD), a
    ld a, 3
    ld (WK_PLAYERPOSY), a
    ld (WK_PLAYERPOSYOLD), a
    ld a, $02

    ld ix, SPRDISTPTN_TBL + 2
    call CreateWorkSpriteAttr

    ld de, $1B00
    ld bc, 8
    call PutSprite

    ;--------------------------------------------
    ; BGM演奏開始
    ;--------------------------------------------
    ld hl, BGM_00
    call SOUNDDRV_BGMPLAY

    ld a, 2
    ld (WK_GAMESTATUS), a
    ld a, 0
    ld (WK_GAMESTATUS_INTTIME), a

OpeningProcEnd:

    jp VSYNC_Wait

