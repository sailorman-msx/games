; ==========================================================================================
;
; interval.asm
;
; licence:MIT Licence
; copyright-holders:Hitoshi Iwai(aburi6800)
; modified by:Hitoshi Inoue(brapunch2000)
;
; ==========================================================================================

; ==========================================================================================
; H.TIMI割り込みハンドラ初期化
; ==========================================================================================
INIT_H_TIMI_HANDLER:

    push af
    push bc
    push de
    push hl

    di

    ; ■H.TIMIバックアップ
    ld hl, H_TIMI                   ; 転送元
    ld de, H_TIMI_BACKUP            ; 転送先
    ld bc, 5                        ; 転送バイト数
    ldir

    ; ■H.TIMI書き換え
    ld a, $C3                        ; JP
    ld hl, H_TIMI_HANDLER            ; サウンドドライバのアドレス
    ld (H_TIMI + 0), a
    ld (H_TIMI + 1), hl

    ei

    pop hl
    pop de
    pop bc
    pop af

    ret


; ==========================================================================================
; H.TIMI割り込み処理
; ==========================================================================================
H_TIMI_HANDLER:

    push af

    ; VSYNC_WAIT_CNTデクリメント
    ;   1/60ごとに-1される
    ;   メインルーチンの最初の設定値により
    ;     1 = 60フレーム
    ;     2 = 30フレーム
    ;   の処理となる
    ld a, (VSYNC_WAIT_CNT)
    or a
    jr z, H_TIMI_HANDLER_L1
    dec a
    ld (VSYNC_WAIT_CNT), a

H_TIMI_HANDLER_L1:

    ; AKG Playerサウンド出力
    ; アニメーション処理中と重ならないようにする
    call COMMON_AKG_PLAY

    ; 画面の初期化中は何もしない
    ld a, (WK_GAMESTATUS)
    or a
    jp z, IntervalEnd

    ld a, (WK_SPRREDRAW_FINE)
    or a
    jp z, SkipPutSprite

    call PutSprite

    xor a
    ld (WK_SPRREDRAW_FINE), a

SkipPutSprite:

    ; 画面切替中は何もしない
    ld a, (WK_MAPCHANGE_COUNT)
    or a
    jp nz, SetBlankScreen

    ; 画面切替の間はブランク画面を表示する
    ld a, (WK_GAMESTATUS_INTTIME)
    or a
    jp nz, SetBlankScreen

    ; キー入力インターバル値をデクリメントする
    ld a, (WK_KEYIN_INTERVAL)
    or a
    jr z, SkipKeyIntervalDec
    dec a
    ld (WK_KEYIN_INTERVAL), a

SkipKeyIntervalDec:

    ;----------------------------------------
    ; アニメ処理を行う
    ;----------------------------------------
    ; アニメーション処理を行う
    ; タイトル画面、ダイアログ表示時は行わない
    ld a, (WK_GAMESTATUS)
    cp 1
    jr z, SkipAnimation
    cp 3
    jr z, SkipAnimation

CheckAnimeInterval:

    ld a, (WK_ANIME_INTERVAL)
    or a
    jr nz, DecAnimationInterval

    ld a, (WK_MAPTYPE)
    cp 2
    jr z, DoAnimation
    cp 3
    jr z, DoAnimation

    jr SetAnimaIntervalDefault

DoAnimation:

    call AnimationProc

SetAnimaIntervalDefault:

    ld a, 30
    ld (WK_ANIME_INTERVAL), a

    jr SkipAnimation

DecAnimationInterval:

    ld a, (WK_ANIME_INTERVAL)
    dec a
    ld (WK_ANIME_INTERVAL), a

SkipAnimation:

    ; TIME10のデクリメントを行う
    ; ダイアログ表示中は再描画フラグはたてない
    ; ダイアログ側のタイミングで再描画する
    ; ピープホール表示中は再描画フラグはたてない
    ; ゲームメイン側のタイミングで再描画する
    ld a, (WK_GAMESTATUS)
    cp 3
    jr z, SkipDecTime10
    cp 5
    jr z, SkipDecTime10

    ; ピープホール型のマップの場合
    ; TIME10はデクリメントしない
    ld a, (WK_MAPTYPE)
    cp 2
    jr z, SkipDecTime10
    cp 5
    jr z, SkipDecTime10
    cp 6
    jr z, SkipDecTime10
    cp 8
    jr z, SkipDecTime10

    ld a, (WK_TIME10)
    or a
    jr z, SetTime10

    dec a
    jr DecTime10End
    
SetTime10:

    ld a, 1
    ld (WK_REDRAW_FINE), a
    ld a, 10

DecTime10End:
    ld (WK_TIME10), a

SkipDecTime10:

    ; 剣のインターバル値のデクリメントを行う
    ld a, (WK_SWORDACTION_COUNT)
    or a
    jr nz, SwordOnDecInterval

    jr SkipSwordDecCount

SwordOnDecInterval:

    dec a
    ld (WK_SWORDACTION_COUNT), a
    or a
    jr z, StartReuseCount

    jr SkipSwordDecCount

StartReuseCount:

    ld a, 15
    ld (WK_SWORD_REUSE_COUNT), a

SkipSwordDecCount:

    ; 剣の振り直しインターバルのデクリメントを行う
    ld a, (WK_SWORD_REUSE_COUNT)
    or a
    jr nz, SwordReuseDecInterval

    jr SkipSwordReuseDecCount

SwordReuseDecInterval:

    dec a
    ld (WK_SWORD_REUSE_COUNT), a

SkipSwordReuseDecCount:

    ld hl, WK_SPRITE_MOVETBL + 48

DecEnemyInterval:

    ld a, (hl)
    or a
    jr z, DecEnemyIntervalEnd

    ld b, 0
    ld c, 15
    add hl, bc
    ld a, (hl)
    
    or a
    jr z, DecEnemyIntervalNextLoop

    dec a
    ld (hl), a

DecEnemyIntervalNextLoop:
    inc hl
    jr DecEnemyInterval

DecEnemyIntervalEnd:

    ;----------------------------------------
    ; ロウソク処理
    ; タイトル画面表示中とダイアログ表示中は
    ; カウントダウンは行わない
    ;----------------------------------------
    ld a, (WK_GAMESTATUS)
    cp 1
    jp z, SkipTorchCountDown
    cp 3
    jp z, SkipTorchCountDown
    cp 4
    jp z, SkipTorchCountDown

    ld a, (WK_TORCH_USED)
    or a
    jr z, SkipTorchCountDown

    call TorchCountDown
    call DispTorchStatus

SkipTorchCountDown:

    ;---------------------------------------------------
    ; 背景色を赤や青に変更する場合は
    ; VRAMの設定だけして他の処理は何もしない
    ;---------------------------------------------------
    ld a, (WK_BGCOLOR_CHGFLG)
    cp 1
    jr z, SetBGCOLOR_Red
    cp 3
    jr z, SetBGCOLOR_Blue

    jr SkipSetBGCOLOR

SetBGCOLOR_Red:

    ld a, 2
    ld (WK_BGCOLOR_CHGFLG), a

    ld a, $61
    jr SetBGCOLOR

SetBGCOLOR_Blue:

    ld a, 0
    ld (WK_BGCOLOR_CHGFLG), a

    ld a, $51

SetBGCOLOR:

    ld (WK_SETBG_VALUE), a

    ld a, (WK_SETBG_VALUE)
    ld hl, $2000 + $24 * 8
    ld bc, 8
    call WRTVRMFIL

    ld a, (WK_SETBG_VALUE)
    ld hl, $2800 + $24 * 8
    ld bc, 8
    call WRTVRMFIL

    ld a, (WK_SETBG_VALUE)
    ld hl, $3000 + $24 * 8
    ld bc, 8
    call WRTVRMFIL

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ; jp IntervalEnd

SkipSetBGCOLOR:

    ld a, (WK_REDRAW_FINE)
    or a
    jp z, IntervalEnd

    ;---------------------------------------------------
    ; 仮想パターンネームテーブルを
    ; VRAM 1800Hに転送する
    ; ただしChangeMapViewの間は転送しない
    ;---------------------------------------------------
    ld a, (WK_MAPCHANGE_COUNT)
    or a
    jr nz, SetBlankScreen

    ;----------------------------------------
    ; ピープホール型のマップの場合は
    ; ピープホール表示処理を行う
    ; ただしダイアログ表示中は行わない
    ; 行うとダイアログの表示ごと崩れてしまいます
    ;----------------------------------------

SetPeepHole:

    ld a, (WK_GAMESTATUS)
    cp 3
    jp z, SkipDisplayViewPort
    cp 5
    jp z, SkipDisplayViewPort
    
    ld a, (WK_GAMESTATUS)
    cp 1
    jp z, SkipDisplayViewPort

    ld a, (WK_MAPTYPE)       
    cp 1 ; 穏やかな平原      
    jr z, SkipDisplayViewPort
    cp 3 ; 迷いの大河
    jr z, SkipDisplayViewPort
    cp 4 ; 炭鉱跡
    jr z, SkipDisplayViewPort
    cp 9
    jr z, SkipDisplayViewPort

SetPeepHoleToViewPort:

    ; ビューポートに対してピープホール処理を施す
    ld a, (WK_PLAYERPOSX)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ld a, (WK_PLAYERPOSY)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    ld a, (WK_PEEPHOLE_BUILDNOW)
    or a
    jr nz, IntervalEnd
    ld a, 1
    ld (WK_PEEPHOLE_BUILDNOW), a
    call PeepHoleProc

    ; 作成しなおした
    ; ビューポートを仮想パターンネームテーブルに転送する
    call DisplayViewPort

SkipDisplayViewPort:

    ld a, (WK_DIALOG_INITEND)
    cp 1
    jp z, IntervalEnd

    call PutPatternNameTable

    xor a
    ld (WK_REDRAW_FINE), a

    jr IntervalEnd

SetBlankScreen:

    ; ダイアログ表示の場合は
    ; クリアスクリーンはしない
    ld a, (WK_GAMESTATUS)
    cp 3
    jr z, IntervalEnd

    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    ld (WK_GAMESTATUS_INTTIME), a

    ld a, (WK_GAMESTATUS)
    cp 4
    jr z, IntervalEnd

    ld d, $20
    ld a, (WK_GAMESTATUS)
    cp 1
    jr z, SetBlankScreenFull

    ld d, $2B
    ld a, (WK_GAMESTATUS)
    cp 5
    jr z, SetBlankScreenFull

    ld hl, $1800 + 32 * 3
    ld bc, 768 - 32 * 3
    ld a, $20
    call WRTVRMFIL
    jr IntervalEnd

SetBlankScreenFull:

    ld hl, $1800
    ld bc, 768
    ld a, d
    call WRTVRMFIL

    ; ■バックアップ済のH.TIMIハンドラにチェーン
    ;   最後に必ず実行する
IntervalEnd:

    ei

    pop af

    jp H_TIMI_BACKUP
