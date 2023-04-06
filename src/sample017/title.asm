;--------------------------------------------------
; title.asm
; タイトル画面処理
; WK_GAMESTATUSの値が0の時に1/60秒ごとにCALLされる
; スペースキーかAボタンでゲーム処理に遷移する
;--------------------------------------------------
TitleDisplayProc:

    ld a, (WK_GAMESTATUS_INTTIME)
    or 0
    jp nz, TitleDisplayProcDecTime

TitleDisplayProcInit:

    ; キーボードバッファをクリアする
    ; これを呼び出さないとカーソルキーを正常に判定できない
    call KILBUF

    ; スペースキーが押されているか？
TitleDisplayProc_IsSPACE:
    ld a, 0
    call GTTRIG
    cp $FF
    jr nz, TitleDisplayProc_IsAbutton

    ; シーン切り替えタイマーに値をセット
    ; タイマーの値は1/60秒ごとにデクリメントされる
    ld a, 60
    ld (WK_GAMESTATUS_INTTIME), a

    ; 効果音を鳴らす
    ld hl, SFX_03
    call SOUNDDRV_SFXPLAY

    jp TitleDisplayProcToStart

    ; ジョイスティック1のAボタンが押されているか？
TitleDisplayProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jp nz, TitleDisplayProcEnd

TitleDisplayProcToStart:

    ; シーン切り替えタイマーに値をセット
    ; タイマーの値は1/60秒ごとにデクリメントされる
    ld a, 60
    ld (WK_GAMESTATUS_INTTIME), a

    ; 効果音を鳴らす
    ld hl, SFX_03
    call SOUNDDRV_SFXPLAY

    ; ゲームステータス値をセットする
    ld a, 2
    ld (WK_GAMESTATUS), a

    ; 乱数のSEED値を再設定する
    call InitRandom

TitleDisplayProcDecTime:

    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    ld (WK_GAMESTATUS_INTTIME), a
    
TitleDisplayProcEnd:

    jp VSYNC_Wait
