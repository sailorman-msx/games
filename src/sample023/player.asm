; ---------------------------------------------------
; プレイヤー移動処理
;   プレイヤーの種別コードは0
;
; 処理順：
;
;   ・ジャンプボタン（AボタンもしくはZキー）を押されたか？
;     押されたらステータスをジャンプ中に変更する
;   ・ジャンプ中か？
;     ジャンプ中であればジャンプ処理へ
;   ・落下中か？
;     落下中であれば落下処理へ
;   ・それ以外であれば左右の移動処理へ
;
; ---------------------------------------------------
MovePlayer:

    push af
    push bc
    push de
    push hl

    ; 上下方向が押されていたら
    ; ハシゴの存在をチェックする
    ; ハシゴが存在していたらハシゴ昇降状態にする
    ld a, (WK_PLAYERDIST)
    cp 1
    jp z, MovePlayerUpDown
    cp 5
    jr z, MovePlayerUpDown

    ; ジャンプ中(WK_JUMPCNT <> $FF)は
    ; 上方向ボタンが押されなくてもジャンプ処理を行う
    ld a, (WK_JUMPCNT)
    inc a
    jp nz, MovePlayerJumpNow

    ; ジャンプ中でない場合は
    ; 床の状態を調べる
    jr MovePlayerFloorCheck

MovePlayerUpDown:

    ; ハシゴに重なっている場合は
    ; ジャンプに優先して昇降させる

    ; 上方向に登れるハシゴがあるか？
    cp 1
    jr z, MovePlayerCheckLadder11

    ; 下方向に降りれるハシゴがあるか？
    jr MovePlayerCheckLadder15

; プレイヤーの足と重なってるハシゴがあれば上に登れる
MovePlayerCheckLadder11:

    ld a, (WK_VRAM4X6_TBL + $11)
    cp $64
    jr z, MovePlayerLadder

MovePlayerCheckLadder12:

    ld a, (WK_VRAM4X6_TBL + $12)
    cp $65
    jr z, MovePlayerLadder

    ; 上ボタン押下時、ハシゴが存在していなければ
    ; ジャンプ可能かチェックする
    jr MovePlayerJump

; プレイヤーの足の下にハシゴがあれば下に降りれる
MovePlayerCheckLadder15:

    ld a, (WK_VRAM4X6_TBL + $15)
    cp $64
    jr z, MovePlayerLadder

    ; 下ボタン押下時
    ; ハシゴが存在しなければハシゴ昇降状態を
    ; 解除する

    jr MovePlayerFloorCheckLadderDownCancel

MovePlayerCheckLadder16:

    ld a, (WK_VRAM4X6_TBL + $16)
    cp $65
    jr z, MovePlayerLadder

    ; 下ボタン押下時
    ; ハシゴが存在しなければハシゴ昇降状態を
    ; 解除する

    jr MovePlayerFloorCheckLadderDownCancel

MovePlayerFloorCheckLadderDownCancel:

    ; ハシゴ昇降中で下方向にハシゴがなく
    ; 下ボタンを押されていたらハシゴ昇降フラグをOFFにして
    ; ハシゴ昇降状態を解除する
    xor a
    ld (WK_LADDERFLG), a  

    jr MovePlayerFloorCheckDownCheck

MovePlayerJump:

    ; ハシゴ昇降フラグ成立時は
    ; ジャンプさせない
    ld a, (WK_LADDERFLG)
    or a
    jr nz, MovePlayerFloorCheck

    ; TODO: しゃがみ状態の場合はジャンプさせない

    ; すでにジャンプしている場合は何もしない
    ; WK_JUMPCNT は JUMP_OFFSETのインデックスとして使う
    ; WK_JUMPCNTの初期値は$FF
    ; インデックス値は 0 - 7まで

    ld a, (WK_JUMPCNT)
    inc a
    jr nz, MovePlayerFloorCheck

    ; 落下状態で上方向が押されても何もしない
    ld a, (WK_FALLDOWN)
    or a
    jr nz, MovePlayerFloorCheck

    xor a
    ld (WK_JUMPCNT), a       ; JUMP_OFFSET値は最初はゼロ

    ld a, (WK_PLAYERDIST_PRE)
    ld (WK_JUMPSTARTDIST), a ; ジャンプ開始時の方向をセット

    jp MovePlayerJumpNow

MovePlayerLadder:

    ; すでにハシゴ昇降フラグがONであれば何もしない
    ld a, (WK_LADDERFLG)
    or a
    jr nz, MovePlayerFloorCheck

    ; ハシゴフラグを成立させる
    ld a, 1
    ld (WK_LADDERFLG), a

    ; アニメパターンを初期化
    xor a
    ld (WK_ANIME_PTN), a

    ; 上方向を向かせる
    ld a, 1
    ld (WK_PLAYERDIST_PRE), a

    ; 加速カウンタとX移動量を初期化する
    xor a
    ld (WK_ACCELCNT), a
    ld a, 2
    ld (WK_XMOVEVAL), a

;-----------------------------------------------------
; プレイヤーの床面をチェックする
; ・足元にハシゴがなければハシゴ昇降フラグをOFFにする
;-----------------------------------------------------
MovePlayerFloorCheck:
    
    ; 足元にハシゴがなければハシゴ昇降フラグをOFFにする

    ; ハシゴ昇降中でなければチェックは行わない
    ld a, (WK_LADDERFLG)
    or a
    jr z, MovePlayerFloorCheckDownCheck

    ld a, (WK_VRAM4X6_TBL + $11)
    cp $64
    jr z, MovePlayerFloorCheckDownLadder
    cp $65
    jr z, MovePlayerFloorCheckDownLadder

    ld a, (WK_VRAM4X6_TBL + $15)
    cp $64
    jr z, MovePlayerFloorCheckDownLadder
    cp $65
    jr z, MovePlayerFloorCheckDownLadder

    ; ハシゴ昇降フラグをOFF
    xor a
    ld (WK_LADDERFLG), a

    ; TODO: 下ボタンを押されていたらしゃがみモードに変更する

    jr MovePlayerFloorCheckDownCheck

MovePlayerFloorCheckDownLadder:

    ; 足元がハシゴで下方向を押されていたら
    ; ハシゴ昇降フラグをONにする
    ld a, (WK_PLAYERDIST)
    cp 5
    jr nz, MovePlayerFloorCheckDownCheck

    ; ハシゴ昇降フラグをONにする
    ld a, 1
    ld (WK_LADDERFLG), a

    jr MovePlayerFloorCheckEnd

MovePlayerFloorCheckDownCheck:

    ; ハシゴ昇降フラグが成立していたら
    ; 足元の空間チェックは不要
    ld a, (WK_LADDERFLG)
    or a
    jr nz, MovePlayerFloorCheckEnd

    ld a, (WK_SURROUNDFLG)
    and CONST_MOVEDOWNOK ; 下に空間があれば移動処理を行う
    jp nz, MovePlayerCheckFallDown

    ; 下に穴がなければ落下状態をOFFにする
    ; 落下状態でなければ何もしない
    ld a, (WK_FALLDOWN)
    or a
    jr z, MovePlayerFloorCheckEnd

    xor a
    ld (WK_FALLDOWN), a

    ld a, $FF
    ld (WK_JUMPCNT), a

    ; Y座標を8で割り切れる値に補正する
    ld a, (WK_POSY)
    and 11111000B
    ld (WK_POSY), a

    ; プレイヤーの方向を正面に向かせる
    ld a, 5
    ld (WK_PLAYERDIST), a

    jr MovePlayerFloorCheckEnd

MovePlayerCheckFallDown:

    ; プレイヤーの足元が空間であれば
    ; 落下状態に移行できるかチェックする

    ; ジャンプ中のときは落下状態にはしない
    ; ジャンプしてない場合は落下状態にする

    ; WK_JUMPCNTが$FFの場合はジャンプ中ではないため
    ; 落下させる
    ld a, (WK_JUMPCNT)
    cp $FF
    jr z, MovePlayerSetFallDown

    ; WK_JUMPCNTが8の場合は
    ; ジャンプが終了しているため落下させる
    cp 8
    jr c, MovePlayerFloorCheckEnd

    ; ジャンプ終了時には
    ; 加速カウンタとX移動量を初期化する

    xor a
    ld (WK_ACCELCNT), a

    ; 歩行距離を初期化する
    ld a, 2
    ld (WK_XMOVEVAL), a

MovePlayerSetFallDown:

    ; 落下状態にする
    ; すでに落下状態であれば何もしない
    ld a, (WK_FALLDOWN)
    or a
    jr nz, MovePlayerSetFallDownXAdjust

    ld a, 1
    ld (WK_FALLDOWN), a

    ; プレイヤーの向きにあわせてX座標を調整する
    ; ただし、ジャンプ時には調整しない
    ; ※この補正を行わないと壁にめりこんだ状態になってしまう

    ld a, (WK_JUMPCNT)
    cp $FF
    jr z, MovePlayerSetFallDownXAdjust

    ; 左右どちらかによって補正値を変更する
    ld a, (WK_PLAYERDIST_PRE)
    cp 3
    jr z, MovePlayerSetFallDownXAdjustR

MovePlayerSetFallDownXAdjustL:

    ; 落下直後にX座標を-4する
    ld a, (WK_POSX)
    add a, -4
    ld (WK_POSX), a

    jr MovePlayerSetFallDownXAdjust

MovePlayerSetFallDownXAdjustR:

    ; 落下直後にX座標を+2する
    ld a, (WK_POSX)
    add a, 2
    ld (WK_POSX), a

MovePlayerSetFallDownXAdjust:

    ld a, 5
    ld (WK_PLAYERDIST), a

MovePlayerFloorCheckEnd:

    ld a, (WK_PLAYERDIST)

    ; 方向キーを何も押されていなければジャンプ中かを判定する
    or a
    jp z, MovePlayerCheckJump

    ld b, a ; 方向をBレジスタに退避

    ; ハシゴ昇降フラグが成立している状態で上下ボタンが押されたら
    ; ハシゴをのぼりおりさせる
    ld a, (WK_LADDERFLG)
    or a
    jr nz, MovePlayerLadderMove

    ; 前回と方向が異なればその方向を向いていったん立ち止まる（移動しない）
    ld a, (WK_PLAYERDIST_PRE)
    cp b
    jp nz, MovePlayerChangeDist

    jr MovePlayerCheckJump

MovePlayerLadderMove:

    ; スプライトパターンをハシゴ昇降状態に変更する
    ld a, 10
    ld (WK_SPRPTNCHG), a

    ; ハシゴ昇降を行う
    ld a, b ; Bレジスタに退避していた方向をAレジスタに復帰
    cp 1
    jr z, MovePlayerLadderMoveUp
    cp 5
    jr z, MovePlayerLadderMoveDown

    jr MovePlayerSetAnime

MovePlayerLadderMoveUp:

    ; ハシゴをのぼる
    ld a, (WK_POSY)
    ld b, -2
    add a, b
    ld (WK_POSY), a

    jr MovePlayerSetAnime

MovePlayerLadderMoveDown:

    ; ハシゴをくだる
    ld a, (WK_POSY)
    ld b, 2
    add a, b
    ld (WK_POSY), a

    jr MovePlayerSetAnime

MovePlayerCheckJump:

    ; ジャンプ中か判定する
    ; ジャンプ中でなければアニメ処理を行う
    ld a, (WK_JUMPCNT)
    cp $FF
    jr z, MovePlayerSetAnime

    ld a, (WK_PLAYERDIST_PRE)
    ld (WK_PLAYERDIST), a

MovePlayerJumpNow:

    ; ジャンプ中の下判定は
    ; 最高到達点(JUMP_OFFSET=4)以上になるまではしない
    ld a, (WK_JUMPCNT)
    cp 4
    jr c, MovePlayerSetAnime

    ld a, (WK_SURROUNDFLG)
    and CONST_MOVEDOWNOK ; 下に穴がなければジャンプ処理を中断する
    jp z, MovePlayerJumpCancel

    jr MovePlayerSetAnime

MovePlayerJumpCancel:

    ; 足元がハシゴの場合であればジャンプ処理は中断しない
    ; 背景がハシゴであってもジャンプ処理は継続させる

    ld a, (WK_VRAM4X6_TBL + $11)
    cp $64
    jr z, MovePlayerSetAnime
    cp $65
    jr z, MovePlayerSetAnime
    ld a, (WK_VRAM4X6_TBL + $12)
    cp $64
    jr z, MovePlayerSetAnime
    cp $65
    jr z, MovePlayerSetAnime

MovePlayerJumpCancelDoCancel:

    ; ジャンプ処理の中断
    ; ジャンプ処理中断時は落下中状態に切り替える
    ld a, $FF
    ld (WK_JUMPCNT), a

    ; 加速カウンタ、X移動量の初期化
    xor a
    ld (WK_ACCELCNT), a
    ld a, 2
    ld (WK_XMOVEVAL), a

    ; アニメパターン番号の初期化
    xor a
    ld (WK_ANIME_PTN), a

    ; Y座標を補正する
    ld a, (WK_POSY)
    and 11111000B
    ld (WK_POSY), a

    ld a, (WK_JUMPSTARTDIST)
    ld (WK_PLAYERDIST), a

MovePlayerSetAnime:

    ; 横方向のアニメーションパターンをセットする
    ld a, (WK_PLAYERDIST)
    cp 3
    jr z, MoveRightAnime
    cp 7
    jr z, MoveLeftAnime

    ; 上下方向のアニメーションパターンをセットする
    ; 上方向は当処理に至るまでですでにセット済みのため
    ; 特にセットはしない
    cp 1
    jr z, MoveUpAnime
    cp 5
    jr z, MoveUpAnime
     
    jp MovePlayerAnimeEnd

MoveUpAnime:

    jr MovePlayerAnimeDoAnime

MoveRightAnime:

    ; 右方向の当たり判定をチェックする
    ld a, (WK_SURROUNDFLG)
    and CONST_MOVERIGHTOK
    jr nz, MoveRightAddPosX

    ; 右方向に移動できない場合は
    ; 加速カウンタを初期化して移動させない
    xor a
    ld (WK_ACCELCNT), a

    jr MoveLRSetMoveStopTimer

MoveRightAddPosX:

    ; 右方向に移動できる場合は移動させる
    ld a, (WK_XMOVEVAL)
    ld b, a
    ld a, (WK_POSX)
    add a, b
    ld (WK_POSX), a

    ; 停止中タイマーを初期化する
    jr MoveLRSetMoveStopTimer

MoveLeftAnime:

    ; 左方向の当たり判定をチェックする
    ld a, (WK_SURROUNDFLG)
    and CONST_MOVELEFTOK
    jr nz, MoveLeftSubPosX

    ; 左方向に移動できない場合は
    ; 加速カウンタを初期化して移動させない
    xor a
    ld (WK_ACCELCNT), a

    jr MoveLRSetMoveStopTimer

MoveLeftSubPosX:

    ; 左方向に移動できる場合は移動させる
    ld a, (WK_XMOVEVAL)
    neg
    ld b, a
    ld a, (WK_POSX)
 
    add a, b
    ld (WK_POSX), a

MoveLRSetMoveStopTimer:

    ; 停止中タイマーを初期化する
    ld a, 30
    ld (WK_MOVESTOPTIME), a

MovePlayerAnimeDoAnime:

    ; 落下状態であれば落下状態のY移動量をセットする
    ld a, (WK_FALLDOWN)
    or a
    jr nz, MovePlayerAnimeJumpSetYFallDown

    ; ジャンプ中であればオフセット値によりY移動量をセットする
    ld a, (WK_JUMPCNT)
    cp $FF
    jp z, MovePlayerAnimeNotJump

    jr MovePlayerAnimeJumpSetYJump

MovePlayerAnimeJumpSetYFallDown:

    ; 落下中の降下距離は2固定
    ld b, 2
    jr MovePlayerAnimeDoAnimeDown

MovePlayerAnimeJumpSetYJump:

    ; ジャンプ距離を算出
    ld hl, JUMP_OFFSET
    ld a, (WK_JUMPCNT)

    ld b, 0
    ld c, a
    add hl, bc
    ld a, (hl)  ; JUMP_OFFSET値を取得
    ld b, a     ; JUMP_OFFSET値をBレジスタにセット

    ld a, (WK_JUMPCNT)

    ; オフセット値が8であれば
    ; ジャンプ処理を終了させる
    cp 8
    jr z, MovePlayerJumpInitYPos

    inc a
    ld (WK_JUMPCNT), a

MovePlayerAnimeDoAnimeDown:

    ; 上下方向に移動させる
    ld a, (WK_POSY)
    add a, b
    ld (WK_POSY), a

    jr MovePlayerAnimeNotJump

MovePlayerJumpInitYPos:

    ; ジャンプ処理の終了
    ld a, 2
    ld (WK_XMOVEVAL), a
    
    ; ジャンプフラグを初期化
    ld a, $FF
    ld (WK_JUMPCNT), a

    xor a
    ; 落下中フラグをOFF
    ld (WK_FALLDOWN), a

    ; 加速カウンタを初期化
    ld (WK_ACCELCNT), a

    ; ボタンを押されていない状態に戻す
    ld (WK_TRIGGERA), a

    ; パターン番号を初期化
    xor a
    ld (WK_ANIME_PTN), a

    ld a, 5
    ld (WK_PLAYERDIST), a

    ; スプライトパターンを再定義
    ld (WK_SPRPTNCHG), a
    
    ld a, (WK_POSY)
    and 11111000B
    ld (WK_POSY), a

MovePlayerAnimeNotJump:

    call SetPlayerSpriteInfo

    ; ジャンプ中でなく左右方向への移動であれば
    ; 歩行速度を早くする

    ld a, (WK_JUMPCNT)
    cp $FF
    jr nz, MovePlayerIncAnimeNum

    ld a, (WK_PLAYERDIST)
    cp 3
    jr z, MovePlayerAccelUp
    cp 7
    jr z, MovePlayerAccelUp
    
    jr MovePlayerIncAnimeNum

MovePlayerAccelUp:

    ; 左右移動の場合であれば
    ; 加速カウンタをアップする

    ; 加速カウンタが8であれば(16ドット連続移動したら)
    ; 加速させる
    ld a, (WK_ACCELCNT)
    inc a
    cp 8
    jr z, MovePlayerAccelUpSpeed

    ld (WK_ACCELCNT), a

    ; 加速していない状態であれば
    ; X移動量は2ドット単位とする
    ld a, 2
    ld (WK_XMOVEVAL), a

    jr MovePlayerIncAnimeNum

MovePlayerAccelUpSpeed:

    ; 加速させる（X座標の移動量を4ドット単位にする）
    ld a, 4
    ld (WK_XMOVEVAL), a

MovePlayerIncAnimeNum:

    ; 上下方向が押されてジャンプしていなけばアニメーションさせない
    ld a, (WK_PLAYERDIST)
    cp 1
    jr z, MovePlayerIncAnimeNotInc
    cp 5
    jr z, MovePlayerIncAnimeNotInc

    ld (WK_SPRPTNCHG), a

    jr MovePlayerIncAnimeInc

MovePlayerIncAnimeNotInc:

    ; 落下中は落下中専用のアニメ表示をする
    ld a, (WK_FALLDOWN)
    or a
    jr nz, MovePlayerIncAnimeFallInc

    jr MovePlayerIncAnimeInc

MovePlayerIncAnimeFallInc:

    ; 落下状態のアニメパターンをセットする
    ld a, 9
    ld (WK_SPRPTNCHG), a

MovePlayerIncAnimeInc:

    ld a, (WK_ANIME_PTN)
    inc a
    ld (WK_ANIME_PTN), a

    ; アニメーション番号が4になったら0に戻す
    cp 4
    jr z, MovePlayerResetAnimeNum

    jr MovePlayerAnimeEnd

MovePlayerResetAnimeNum:

    xor a
    ld (WK_ANIME_PTN), a

MovePlayerAnimeEnd:

    jr MovePlayerEnd

MovePlayerChangeDist:

    call SetPlayerSpriteInfo

    ld a, (WK_PLAYERDIST)
    ld (WK_PLAYERDIST_PRE), a

    ld (WK_SPRPTNCHG), a
    
    ; 歩行速度を初期化する
    ld a, 3
    ld (WK_WALKSPEED), a

    ; 加速カウンタと移動量を初期化する
    xor a
    ld (WK_ACCELCNT), a
    ld a, 2
    ld (WK_XMOVEVAL), a

MovePlayerEnd:
    
    pop hl
    pop de
    pop bc
    pop af

    ret

; プレイヤーのスプライト情報の作成
; 座標情報のみ更新する

SetPlayerSpriteInfo:

    ld hl, WK_SPRITE_MOVETBL + 1

    ld b, 0
    ld c, 15

    ld a, (WK_POSY)
    ld (hl), a
    inc hl
    ld a, (WK_POSX)
    ld (hl), a

    add hl, bc

    ld a, (WK_POSY)
    ld (hl), a
    inc hl
    ld a, (WK_POSX)
    ld (hl), a

    add hl, bc

    ld a, (WK_POSY)
    add a, 16
    ld (hl), a
    inc hl
    ld a, (WK_POSX)
    ld (hl), a

    add hl, bc

    ld a, (WK_POSY)
    add a, 16
    ld (hl), a
    inc hl
    ld a, (WK_POSX)
    ld (hl), a

    ret

; ジャンプ時のY座標のオフセットテーブル
JUMP_OFFSET:
defb -8   ; +0
defb -4   ; +1
defb -2   ; +2
defb -2   ; +3
defb 2    ; +4
defb 2    ; +5
defb 4    ; +6
defb 8    ; +7
