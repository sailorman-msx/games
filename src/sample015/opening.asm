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

OpeningProcToStart:

    ;--------------------------------------------
    ; マップデータを生成する
    ;--------------------------------------------
    call CreateMapArea

    ;--------------------------------------------
    ; テキキャラデータを生成する
    ;--------------------------------------------
    ld b, 100
    ld hl, WK_ENEMY_PTR_TBL
    ld de, 0x0000
OpeningProcTblInitLoop:
    ld (hl), de ; アドレスの値を初期化する
    inc hl      ; アドレスを2バイト進める
    inc hl
    djnz OpeningProcTblInitLoop

    ld a, 127
    ld (WK_RANDOM_VALUE), a
    call InitializeEnemyDatas ; テキキャラデータ生成メイン

    ld a, 0
    ld (WK_VIEWPORTPOSX), a ; ビューポート左上X座標
    ld a, 0
    ld (WK_VIEWPORTPOSY), a ; ビューポート左上Y座標

    ;--------------------------------------------
    ; テレポート位置をメモリに展開する
    ;--------------------------------------------
    ld hl, TELEPORT_DATA
    ld de, WK_TELEPORT_DATA_TBL
    ld bc, 112 ; 112バイトぶんをメモリに展開する
    ldir

    ld a, 0
    ld (WK_TELEPORT_INTTIME), a

   ;--------------------------------------------
   ; スコアを初期化する
   ;--------------------------------------------
    ld hl, WK_SCORE
    ld ix, hl
    ld a, 0
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a
    ld hl, WK_SCORE_CHARS
    ld ix, hl
    ld a, '0'
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a

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

    ; エピソードタイトル表示を行う
    call DisplayEpisodeTitle

    ;--------------------------------------------
    ; ゴールタイルをセットする
    ;--------------------------------------------
    ld de, 111
    ld hl, WK_MAPAREA
    add hl, de
    ld a, 4   ; ゴールのドアタイルは#4
    ld (hl), a

    ;--------------------------------------------
    ; ビューポートにマップ情報を表示する
    ;--------------------------------------------
    call CreateViewPort
    call DisplayViewPort

    ld a, 3
    ld (WK_PLAYERPOSX), a    ; プレイヤーのX座標の初期化
    ld (WK_PLAYERPOSXOLD), a ; プレイヤーのX座標の初期化
    ld (WK_PLAYERPOSY), a    ; プレイヤーのY座標の初期化
    ld (WK_PLAYERPOSYOLD), a ; プレイヤーのX座標の初期化

    ld a, 5
    ld (WK_PLAYERDIST), a    ; プレイヤーの向きの初期化（下向き）
    ld (WK_PLAYERDISTOLD), a ; プレイヤーの向きの初期化（下向き）

    ld a, $0D
    ld (WK_PLAYERSPRCLR1), a ; スプライトの表示色

    ld a, $0F
    ld (WK_PLAYERSPRCLR2), a ; スプライトの表示色

    ; 現在の位置をOLD変数にセット
    ld bc, 8
    ld de, WK_PLAYERMOVE_TBL
    ld hl, PLAYERMOVE_TBL
    ldir

    ;
    ; プレイヤーのライフゲージを作成する
    ; 値が2だとLIFEGAUGEのFULL状態を画面に表示する
    ; 値が1だとLIFEGAUGEのHALF状態を画面に表示する
    ; 値が0だとLIFEGAUGEは画面には表示しない
    ; WK_PLAYERLIFEGAUGE+0 の値が0だとGAME OVER処理が行われる
    ;
    ld ix, WK_PLAYERLIFEGAUGE
    ld a, 2
    ld (ix + 7), a
    ld (ix + 6), a
    ld (ix + 5), a
    ld (ix + 4), a
    ld (ix + 3), a
    ld (ix + 2), a
    ld (ix + 1), a
    ld (ix + 0), a

    ; カギ保有情報を初期化する
    ld a, 0
    ld (WK_HAVEKEY), a

    ; エピソードカウンタを初期化する
    ld a, 1
    ld (WK_EPISODE_COUNT), a

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

