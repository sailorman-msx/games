;--------------------------------------------------
; title.asm
; タイトル画面処理
; WK_GAMESTATUSの値が0の時に1/60秒ごとにCALLされる
; スペースキーかAボタンでゲーム処理に遷移する
;--------------------------------------------------
TitleDisplayProc:

   ; 画面表示を行う
   ;--------------------------------------------
   ; マップデータ（初期画面）のデータを
   ; VRAM(1800H-1AFFH)に書き込む
   ;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_TITLE
    ld bc, 768
    call LDIRVM

TitleDisplayProcInit:

    ld a, (WK_GAMESTATUS_INTTIME)
    or 0
    jp nz, TitleDisplayProcBlinkString
    
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

    jp TitleDisplayProcEnd

    ; ジョイスティック1のAボタンが押されているか？
TitleDisplayProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jp nz, TitleDisplayProcEnd

    ; シーン切り替えタイマーに値をセット
    ; タイマーの値は1/60秒ごとにデクリメントされる
    ld a, 60
    ld (WK_GAMESTATUS_INTTIME), a

    ; 効果音を鳴らす
    ld hl, SFX_03
    call SOUNDDRV_SFXPLAY

    jp TitleDisplayProcEnd

TitleDisplayProcBlinkString:

    ld a, (WK_GAMESTATUS_INTTIME)

    cp 1
    jp nz, TitleDisplayProcBlinkStringStep1

    ; WK_GAMESTATUSの値が0の場合は次の
    ; ゲームステータス値をセットする
    ld a, 1
    ld (WK_GAMESTATUS), a

    ld a, 240
    ld (WK_GAMESTATUS_INTTIME), a

    ; オープニング画面を表示する
   ;--------------------------------------------
   ; マップデータ（初期画面）のデータを
   ; VRAM(1800H-1AFFH)に書き込む
   ;--------------------------------------------
    ld de, $1800
    ld hl, MAPDATA_OPENING
    ld bc, 768
    call LDIRVM

    ld hl, $186C
    ld  a, $71
    call WRTVRM
    ld hl, $186D
    ld  a, $73
    call WRTVRM
    ld hl, $188C
    ld  a, $72
    call WRTVRM
    ld hl, $188D
    ld  a, $74
    call WRTVRM

    ; スプライトを表示する
    ld a, 10
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

    jp TitleDisplayProcEnd
    
TitleDisplayProcBlinkStringStep1:

    ; WK_GAMESTATUS_INTTIMEの値によって
    ; 文字を点滅させる
    ld a, (WK_GAMESTATUS_INTTIME)
    and 00001010B
    jp z, TitleDisplayProcDecTime
   
    ; 文字列を削除する
    ld de, $1A00
    ld hl, MAPDATA_BLANKLINE
    ld bc, 32
    call LDIRVM

    ld de, $1A20
    ld hl, MAPDATA_BLANKLINE
    ld bc, 32
    call LDIRVM

TitleDisplayProcDecTime:

    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    ld (WK_GAMESTATUS_INTTIME), a
    
TitleDisplayProcEnd:

    jp VSYNC_Wait


