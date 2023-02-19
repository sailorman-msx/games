;--------------------------------------------
; スプライト関連の処理
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: CreateSpritePattern
; スプライトパターンをVRAMに書き込む
;--------------------------------------------
CreateSpritePattern:

    ;--------------------------------------------
    ; スプライトパターンデータをVRAMの
    ; スプライトパターンジェネレータテーブルに
    ; 転送する
    ;--------------------------------------------
    ld hl, SPRPTN
    ld de, $3800   ; スプライトパターンのVRAM先頭アドレスは3800H
    ld bc, 384     ; 1体あたり64バイトx4パターン + FIREBALL 64 バイト + 爆発 64バイト
    call LDIRVM
    
    ret

;------------------------------------------------
; SUB-ROUTINE: MovePlayer
; Aレジスタに格納されている情報から
; 方向を特定してプレイヤーのスプライトを移動させる
;------------------------------------------------
MovePlayer:

    push af
    push bc
    push de
    push hl
    push iy
    push ix

    ;--------------------------------------------------------
    ; 移動処理の仕様
    ; ・前向いていた方向と異なる場合は移動はせず向きだけ変える
    ; ・前向いていた方向と同じ場合はその方向に移動する
    ;--------------------------------------------------------

    ld a, (WK_PLAYERDIST)    ; Bレジスタに今回の向きをセット
    ld b, a
    ld a, (WK_PLAYERDISTOLD) ; Aレジスタに前回の向きをセット

    ; Aレジスタの値からBレジスタの値を減算した結果が0でなければ
    ; 向きが変わったと判定する
    cp b
    jp nz, MovePlayerChangeDistOnly

    ; 向きが同じであれば移動させる

    ;--------------------------------------------
    ; 移動可能か判定する
    ; Aレジスタが1の場合は移動不可
    ;--------------------------------------------
    call CheckVRAM4x4
    cp 1
    jp z, MovePlayerEnd

    ;--------------------------------------------
    ; 移動処理を行う
    ;--------------------------------------------

    ; ジョイスティックの方向に移動させる

    ld a, (WK_PLAYERDIST)
    ld hl, WK_PLAYERMOVE_TBL

    ld b, 0
    ld c, a

    add hl, bc ; テーブルのポインタをジョイスティック番号分進める
    ld ix, hl  ; ポインタアドレスをIXレジスタに格納する

    ; 下位4ビットはY座標
    ld a, (ix)

    and $0F ; 0FHでANDして下位4ビットの値だけにする
    ld b, a ; BレジスタにY座標の値をセットする

    ld a, (ix)
    sra a     ; 4ビット右にシフトしてX座標の値とする
    sra a
    sra a
    sra a
    ld c, a   ; CレジスタにX座標の値をセットする   

MoveY_Plus:

    ld a, b

    cp 1
    jr c, MoveX_Plus ; 移動量が0の場合はX座標の処理にジャンプ

    cp 2
    jr z, MoveY_Minus ; 移動量が2の場合はY座標の減算にジャンプ

    ; Y座標を加算

    ld a, (WK_PLAYERPOSY)
    inc a ; 移動量をインクリメントする
    ld (WK_PLAYERPOSY), a

    jr MoveX_Plus

MoveY_Minus:

    ; Y座標を減算

    ld a, (WK_PLAYERPOSY)
    dec a ; 移動量をデクリメントする
    ld (WK_PLAYERPOSY), a

MoveX_Plus:

    ld a, c

    cp 1
    jr c, MovePlayerPutSprite ; 移動量が0の場合は何も処理しない

    cp 2
    jr z, MoveX_Minus

    ; X座標を加算

    ld a, (WK_PLAYERPOSX)
    inc a ; 移動量をインクリメントする
    ld (WK_PLAYERPOSX), a

    jr MovePlayerPutSprite

MoveX_Minus:

    ; X座標を減算

    ld a, (WK_PLAYERPOSX)
    dec a ; 移動量をデクリメントする
    ld (WK_PLAYERPOSX), a
    
    jr MovePlayerPutSprite

MovePlayerChangeDistOnly:

    ; プレイヤーの向きだけ変更する

    ; プレイヤーの向きを変数にセット
    ld a, b
    ld (WK_PLAYERDIST), a
    ld (WK_PLAYERDISTOLD), a

MovePlayerPutSprite:

    ; 移動制限処理
    ; 許容範囲外に移動する場合は表示位置をもとに戻す
    ; （移動を行わない）
    call UndoMove

    ; 現在の位置をOLD変数にセット
    ld a, (WK_PLAYERPOSX)
    ld (WK_PLAYERPOSXOLD), a
    ld a, (WK_PLAYERPOSY)
    ld (WK_PLAYERPOSYOLD), a

    ; ワーク用スプライトアトリビュートテーブルを
    ; 作成する
    ld hl, SPRDISTPTN_TBL
    ld b, 0
    ld a, (WK_PLAYERDIST)
    ld c, a

    add hl, bc
    ld ix, hl

    call CreateWorkSpriteAttr

    ; スプライトを表示する
    ld de, $1B00
    ld bc, 8 ; スプライト2枚分を表示
    call PutSprite

MovePlayerEnd:

    pop ix
    pop iy
    pop hl
    pop de
    pop bc
    pop af

    ret

;------------------------------------------------
; SUB-ROUTINE: Fireball
; 弾の処理を行う
; 同時に発射できる弾は画面上で2発までとする
;------------------------------------------------
Fireball:

    push ix
    push iy

    ; 弾発射のインターバル中は弾を発射できない
    ld a, (WK_FIREBALL_INTTIME)
    or 0
    jp nz, FireballInfoSetEnd

    ;----- 重要 --------------------------
    ; PLAYER座標から1を引いた値が2で割り切れない場合は
    ; 弾は発射できないこととする
    ;-------------------------------------
    ld a, (WK_PLAYERPOSX)
    dec a
    ld d, a
    call CalcDivideBy2
    ld a, l
    or a
    jp nz, FireballInfoSetEnd

    ld a, (WK_PLAYERPOSY)
    dec a
    ld d, a
    call CalcDivideBy2
    ld a, l
    or a
    jp nz, FireballInfoSetEnd

    ; ここから下は弾の座標の設定処理
    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl

    ld d, 1

    ; 弾情報の空いている場所を特定する
    ld a, (ix + 0)
    or 0
    jr z, FireballInfoSet ; 空いている場所を特定

    add hl, 8
    ld ix, hl

    ld a, (ix + 0)
    or 0
    jr nz, FireballInfoSetEnd ; 空いていなければ処理終了とする

FireballInfoSet:

    ; 弾が発射できる場合はWK_FIREBALL_TRIGに1を加算する
    ld a, (WK_FIREBALL_TRIG)
    inc a
    ld (WK_FIREBALL_TRIG), a

    ld a, 1
    ld (ix + 0), a

    ld a, (WK_PLAYERPOSX)
    ld (ix + 3), a

    ld e, a
    ld h, 8 
    call CalcMulti
    ld a, l
    ld (ix + 1), a    ; WK_PLAYERPOSXを8倍した結果(下位1バイト)をセット

    ld a, (WK_PLAYERPOSY)
    ld (ix + 4), a

    ld e, a
    ld h, 8 
    call CalcMulti
    ld a, l
    ld (ix + 2), a    ; WK_PLAYERPOSYを8倍した結果(下位1バイト)をセット

    ; ジョイスティックの方向に発射する
    ld a, (WK_PLAYERDIST)

    ld b, 0
    ld c, a

    ld hl, PLAYERMOVE_TBL
    add hl, bc ; テーブルのポインタをジョイスティック番号分進める
    ld iy, hl  ; ポインタアドレスをIXレジスタに格納する

    ld a, (iy)

    and $0F ; 0FHでANDして下位4ビットの値だけにする
    ld b, a ; BレジスタにYの移動量の値をセットする

    ld a, (iy)
    sra a     ; 4ビット右にシフトしてXの移動量とする
    sra a
    sra a
    sra a
    ld c, a   ; CレジスタにXの移動量をセットする   

    ld (ix + 5), c  ; X方向の移動量をセット
    ld (ix + 6), b  ; Y方向の移動量をセット

    ; 弾が発射できた場合はWK_FIREBALL_INTTIMEに60をセットする
    ld a, WK_FIREBALL_TIMER
    ld (WK_FIREBALL_INTTIME), a

    ; 効果音：弾の発射音を鳴らす
    ld hl, SFX_01
    call SOUNDDRV_SFXPLAY

FireballInfoSetEnd:

    pop iy
    pop ix

    ret

;--------------------------------------------
; SUB-ROUTINE: MoveFireball
; 弾の表示処理を行う
;--------------------------------------------
MoveFireball:

    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl

    ld b, 1

MoveFireballLoop:

    ld a, (ix + 0) ; 発射フラグがたっていなければ次の弾の処理を行う
    or 0
    jp z, MoveFireballLoopEnd

    ;
    ; 弾が壁にぶつかっていたら弾を消す
    ;
    ld a, (ix + 3)
    ld (WK_CHECKPOSX), a ; 弾のX座標
    ld a, (ix + 4)
    ld (WK_CHECKPOSY), a ; 弾のY座標
    call GetVRAM4x4
    ld hl, WK_VRAM4X4_TBL
    ld iy, hl
    ld a, (iy+5)
    cp $98 ; テキキャラはぶつかり対象にしない
    jp c, MoveFireballCheckWall
    jp MoveFireballMoveY_Plus

MoveFireballCheckWall:

    cp '$' ; 床はぶつかり対象にしない
    jp z, MoveFireballMoveY_Plus

    ; 弾を消す
    call ResetFireball
    jp MoveFireballLoopEnd ; 次の弾の処理を行う

MoveFireballMoveY_Plus:

    ld a, (ix + 6) ; Yの移動量

    cp 1
    jr c, MoveFireballMoveX_Plus ; 移動量が0の場合はX座標の処理にジャンプ

    cp 2
    jr z, MoveFireballMoveY_Minus ; 移動量が2の場合はY座標の減算にジャンプ

    ; Y座標を加算
    ld a, (ix + 2)
    add a, 8  ; 弾は8ドットずつ移動させる
    ld (ix + 2), a

    cp 160 ; Y座標が160になったら弾を消す

    jr  c, MoveFireballMoveX_Plus ; 160引いた数が0未満であれば消さない
    jr nz, MoveFireballMoveX_Plus

    ld a, 0
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a

    ld a, (WK_FIREBALL_TRIG)
    dec a
    ld (WK_FIREBALL_TRIG), a

    jp MoveFireballLoopEnd

MoveFireballMoveY_Minus:

    ; Y座標を減算
    ld a, (ix + 2)
    sub a, 8  ; 弾は8ドットずつ移動させる
    ld (ix + 2), a

    cp 8 ; Y座標が8未満になったら弾を消す
    jr nc, MoveFireballMoveX_Plus

    ld a, 0
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a

    ld a, (WK_FIREBALL_TRIG)
    dec a
    ld (WK_FIREBALL_TRIG), a

    jp MoveFireballLoopEnd

MoveFireballMoveX_Plus:

    ld a, (ix + 5) ; Xの移動量

    cp 1
    jr c, MoveFireballLoopEnd ; 移動量が0の場合は何も処理しない

    cp 2
    jr z, MoveFireballMoveX_Minus

    ; X座標を加算
    ld a, (ix + 1)
    add a, 8  ; 弾は8ドットずつ移動させる
    ld (ix + 1), a

    cp 160 ; X座標が160になったら弾を消す

    jr  c, MoveFireballLoopEnd ; 160引いた数が0未満であれば消さない
    jr nz, MoveFireballLoopEnd
    ld a, 0
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a

    ld a, (WK_FIREBALL_TRIG)
    dec a
    ld (WK_FIREBALL_TRIG), a

    jp MoveFireballPutSprite

MoveFireballMoveX_Minus:

    ; X座標を減算
    ld a, (ix + 1)
    sub a, 8  ; 弾は8ドットずつ移動させる
    ld (ix + 1), a

    cp 8 ; X座標が8未満になったら弾を消す
    jr nc, MoveFireballLoopEnd
    ld a, 0
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a

    ld a, (WK_FIREBALL_TRIG)
    dec a
    ld (WK_FIREBALL_TRIG), a

MoveFireballLoopEnd:

    ; プレイヤーと同じ単位の座標をセットする
    ld a, (ix + 1)
    srl a  ; / 2
    srl a  ; / 4
    srl a  ; / 8
    ld (ix + 3), a

    ; プレイヤーと同じ単位の座標をセットする
    ld a, (ix + 2)
    srl a  ; / 2
    srl a  ; / 4
    srl a  ; / 8
    ld (ix + 4), a

    inc b
    ld a, 2
    sub a, b
    jr c, MoveFireballPutSprite
    
    ld hl, ix
    add hl, 8
    ld ix, hl

    jp MoveFireballLoop

MoveFireballPutSprite:

    ld ix, WK_FIREBALL_DATA_TBL
    call CreateWorkFireballSpriteAttr

    ; スプライトを表示する
    ld de, $1B08
    ld bc, 8 ; スプライト2枚分を表示
    call PutFireballSprite

    ret


;--------------------------------------------
; SUB-ROUTINE: CheckEnemyCollision
; 当たり判定処理を行う
; (返却値)
; Aレジスタ=0 : 当たっていない
; Aレジスタ=1 : 当たっている
;--------------------------------------------
CheckEnemyCollision:

    push bc
    push hl

    ;--------------------------------------------
    ; 移動先のVRAM情報判定
    ; 現在自分がいる場所の周囲4ｘ4の情報を取得する
    ;--------------------------------------------
    ld a, (WK_PLAYERPOSX)
    ld (WK_CHECKPOSX), a

    ld a, (WK_PLAYERPOSY)
    ld (WK_CHECKPOSY), a

    call GetVRAM4x4

    ld a, (WK_VRAM4X4_TBL+$05) ; プレイヤーの左上の重なりをチェック
    cp $98
    jr nc, CheckEnemyCollisionAtari

    ld a, (WK_VRAM4X4_TBL+$06) ; プレイヤーの右上の重なりをチェック
    cp $98
    jr nc, CheckEnemyCollisionAtari

    ld a, (WK_VRAM4X4_TBL+$09) ; プレイヤーの左下の重なりをチェック
    cp $98
    jr nc, CheckEnemyCollisionAtari

    ld a, (WK_VRAM4X4_TBL+$0A) ; プレイヤーの右下の重なりをチェック
    cp $98
    jr nc, CheckEnemyCollisionAtari

    ld a, 0 ; 当たっていない

    jr CheckEnemyCollisionEnd

CheckEnemyCollisionAtari:

    ld a, 1 ; 当たっている

CheckEnemyCollisionEnd:

    pop hl
    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: CheckVRAM4x4
; (返却値)
; Aレジスタ=0 : 移動可能
; Aレジスタ=1 : 移動不可
;--------------------------------------------
CheckVRAM4x4:

    push bc
    push hl

    ;--------------------------------------------
    ; 移動先のVRAM情報判定
    ; 現在自分がいる場所の周囲4ｘ4の情報を取得する
    ;--------------------------------------------
    ld a, (WK_PLAYERPOSX)
    ld (WK_CHECKPOSX), a

    ld a, (WK_PLAYERPOSY)
    ld (WK_CHECKPOSY), a

    call GetVRAM4x4

    ;--------------------------------------------
    ; 進行方向に床(24H)以外の文字がないかチェックする
    ; 24H以外が見つかれば移動不可とする
    ;--------------------------------------------
    ld a, (WK_PLAYERDIST)

    ld hl, WK_VRAM_CHECK_PROC
    add a, a ; Aレジスタの値を2倍する

    ld b, 0
    ld c, a

    add hl, bc ; 2倍した値を加算してジャンプ先のアドレスを決定する

    ; HLレジスタにはジャンプ先のアドレスが格納されているアドレスが
    ; セットされており、その「ジャンプ先のアドレス」を取得する

    ; ジャンプ先アドレスをBCレジスタにセット
    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a

    ; BCレジスタの値（ジャンプ先アドレス）をHLレジスタにセット
    ld hl, bc

    jp (hl) ; 進行方向にあわせた処理に強制ジャンプ

CheckVRAM4x4Up:

    ; 進行方向は上

    ld a, (WK_VRAM4X4_TBL+$01)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$02)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4Right:

    ; 進行方向は右

    ld a, (WK_VRAM4X4_TBL+$07)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$0B)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4Down:

    ; 進行方向は下

    ld a, (WK_VRAM4X4_TBL+$0D)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$0E)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4Left:

    ; 進行方向は左

    ld a, (WK_VRAM4X4_TBL+$04)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$08)
    cp '&' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove
    cp '#' ; 移動先はブロックか？
    jr z, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4DoNotMove:

    ld a, 1
    jr CheckVRAM4x4End

CheckVRAM4x4MoveOkay:

    ld a, 0

CheckVRAM4x4End:

    pop hl
    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: UndoMove
; 移動範囲外に移動した場合は表示位置を元に戻す
; 移動先のVRAM情報が床以外であっても表示位置を元に戻す
;--------------------------------------------
UndoMove:

    push bc
    push hl

    ;--------------------------------------------
    ; 座標制限判定
    ;--------------------------------------------

    ld a, (WK_PLAYERDIST)

    ld hl, WK_SCROLL_PROC
    add a, a ; Aレジスタの値を2倍する

    ld b, 0
    ld c, a

    add hl, bc ; 2倍した値を加算してジャンプ先のアドレスを決定する

    ; HLレジスタにはジャンプ先のアドレスが格納されているアドレスが
    ; セットされており、その「ジャンプ先のアドレス」を取得する

    ; ジャンプ先アドレスをBCレジスタにセット
    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a

    ; BCレジスタの値（ジャンプ先アドレス）をHLレジスタにセット
    ld hl, bc

    jp (hl) ; 進行方向にあわせた処理に強制ジャンプ

UndoMoveLeftScroll:
    
    ld a, (WK_PLAYERPOSX)

    ; スプライトのX座標が5以上であればスクロールは行わない
    cp 5
    jp nc, UndoMoveEnd

    ; ビューポートX座標が0の場合はスクロールはせずスプライトだけ動かす
    ld a, (WK_VIEWPORTPOSX)
    or 0
    jp z, UndoMoveEnd

    ; ビューポートX座標を-1してビューポートを左にスクロールさせる
    ld a, (WK_VIEWPORTPOSX)
    dec a
    ld (WK_VIEWPORTPOSX), a

    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl
    call ResetFireball
    ld b, 0
    ld c, 8
    add hl, bc
    ld ix, hl
    call ResetFireball
    
    ; call CreateViewPort
    ; call DisplayViewPort

    jp UndoMoveSetOldPos

UndoMoveRightScroll:
    
    ld a, (WK_PLAYERPOSX)

    ; スプライトのX座標が17でなければスクロールは行わない
    cp 17
    jp nz, UndoMoveEnd

    ; ビューポートX座標が36の場合はスクロールはせずスプライトも動かす
    ld a, (WK_VIEWPORTPOSX)
    cp 36
    jp z, UndoMoveEnd

    ; ビューポートX座標を+1してビューポートを左にスクロールさせる
    ld a, (WK_VIEWPORTPOSX)
    inc a
    ld (WK_VIEWPORTPOSX), a

    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl
    call ResetFireball
    ld b, 0
    ld c, 8
    add hl, bc
    ld ix, hl
    call ResetFireball
    
    ; call CreateViewPort
    ; call DisplayViewPort

    jr UndoMoveSetOldPos

UndoMoveUpScroll:
    
    ld a, (WK_PLAYERPOSY)

    ; スプライトのY座標が5以上であればスクロールは行わない
    cp 5
    jr nc, UndoMoveEnd

    ; ビューポートY座標が0の場合はスクロールはせずスプライトも動かす
    ld a, (WK_VIEWPORTPOSY)
    or 0
    jr z, UndoMoveEnd

    ; ビューポートY座標を-1してビューポートを上にスクロールさせる
    ld a, (WK_VIEWPORTPOSY)
    dec a
    ld (WK_VIEWPORTPOSY), a

    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl
    call ResetFireball
    ld b, 0
    ld c, 8
    add hl, bc
    ld ix, hl
    call ResetFireball
    
    ; call CreateViewPort
    ; call DisplayViewPort

    jr UndoMoveSetOldPos

UndoMoveDownScroll:
    
    ld a, (WK_PLAYERPOSY)

    ; スプライトのY座標が17でなければスクロールは行わない
    cp 17
    jr nz, UndoMoveEnd

    ; ビューポートY座標が35の場合はスクロールはせずスプライトも動かす
    ld a, (WK_VIEWPORTPOSY)
    cp 35
    jr z, UndoMoveEnd

    ; ビューポートY座標を+1してビューポートを下にスクロールさせる
    ld a, (WK_VIEWPORTPOSY)
    inc a
    ld (WK_VIEWPORTPOSY), a

    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl
    call ResetFireball
    ld b, 0
    ld c, 8
    add hl, bc
    ld ix, hl
    
    call ResetFireball
    ; call CreateViewPort
    ; call DisplayViewPort

UndoMoveSetOldPos:

    ; X座標、Y座標を元に戻す（移動させない）
    ld bc, 2
    ld de, WK_PLAYERPOSX
    ld hl, WK_PLAYERPOSXOLD
    ldir

UndoMoveEnd:

    call CreateViewPort
    call DisplayViewPort

    pop hl
    pop bc

    ret
    
;--------------------------------------------
; SUB-ROUTINE: CreateWorkSpriteAttr
; ワーク用スプライトアトリビュートテーブルを
; 作成する
;
; IXレジスタ：SPRDISTPTN_TBLのポインタ
; をセットしてから呼び出すこと
;
; CreateWorkSpriteAttr
;   |
;   v
; PutSprite
;
; の順で処理を行うこと
;--------------------------------------------
CreateWorkSpriteAttr:

    ;--------------------------------------------
    ; ワーク用スプライトアトリビュートテーブル
    ; を作成する
    ;--------------------------------------------
    ld iy, WK_PLAYERSPRATTR

    ; スプライト1枚目

    ld a, (WK_PLAYERPOSY) ; Y座標

    ; Y座標を8倍する
    ld hl, 0
    ld e, a
    ld h, 8
    call CalcMulti
    ld (iy+0), l ; Lレジスタに座標値が入っている

    ld a, (WK_PLAYERPOSX) ; X座標

    ; X座標を8倍する
    ld hl, 0
    ld e, a
    ld h, 8
    call CalcMulti
    ld (iy+1), l ; Lレジスタに座標値が入っている

    ld a, (ix)   ; スプライトパターン番号
    ld (iy+2), a

    ld a, (WK_PLAYERSPRCLR1) ; カラー
    ld (iy+3), a
    
    ; スプライト2枚目

    ld a, (WK_PLAYERPOSY) ; Y座標

    ; Y座標を8倍する
    ld hl, 0
    ld e, a
    ld h, 8
    call CalcMulti
    ld (iy+4), l ; Lレジスタに座標値が入っている

    ld a, (WK_PLAYERPOSX) ; X座標

    ; X座標を8倍する
    ld hl, 0
    ld e, a
    ld h, 8
    call CalcMulti
    ld (iy+5), l ; Lレジスタに座標値が入っている

    ld a, (ix)   ; スプライトパターン番号
    add 4        ; スプライトパターン番号に4を足す
    ld (iy+6), a

    ld a, (WK_PLAYERSPRCLR2) ; カラー
    ld (iy+7), a

    ret   
    
;--------------------------------------------
; SUB-ROUTINE: CreateWorkFireballSpriteAttr
; ワーク用スプライトアトリビュートテーブルを
; 作成する
;
; IXレジスタ：WK_FIREBALL_DATA_TBLのポインタ
; をセットしてから呼び出すこと
;
; CreateWorkSpriteAttr
;   |
;   v
; PutSprite
;
; の順で処理を行うこと
;--------------------------------------------
CreateWorkFireballSpriteAttr:

    ;--------------------------------------------
    ; ワーク用スプライトアトリビュートテーブル
    ; を作成する
    ;--------------------------------------------
    ld iy, WK_FIREBALLSPRATTR
    ld a, 0 ; カラーは透明色をセットしておく
    ld (iy +  3), a
    ld (iy +  7), a
    ld a, 32     ; スプライトパターン番号は32固定
    ld (iy +  2), a
    ld (iy +  6), a

    ld a, (ix + 0)
    or 0
    jr z, CreateWorkFireballSpriteAttr2

    ; スプライト1枚目
    ld a, (ix + 2) ; Y座標
    ld (iy + 0), a

    ld a, (ix + 1) ; X座標
    ld (iy + 1), a

    ld a, 10     ; カラー(10固定)
    ld (iy + 3), a
    
CreateWorkFireballSpriteAttr2:

    ; スプライト2枚目
    ld a, (ix + 8)
    or 0
    jr z, CreateWorkFireballSpriteAttr3

    ld a, (ix + 10) ; Y座標
    ld (iy + 4), a

    ld a, (ix +  9) ; X座標
    ld (iy + 5), a

    ld a, 10     ; カラー（10固定）
    ld (iy + 7), a

CreateWorkFireballSpriteAttr3:

    ret   
    
;--------------------------------------------
; SUB-ROUTINE: PutSprite
; ワーク用スプライトアトリビュートテーブルの内容を
; DEレジスタが指し示すVRAMアドレスにブロック転送する
; BCレジスタ：転送バイト数
;--------------------------------------------
PutSprite:

    ;--------------------------------------------
    ; スプライトアトリビュートテーブルは次の
    ; ようになっている
    ;
    ; 例
    ; 1B00H-1B03H : スプライト番号#0
    ; 1B04H-1B07H : スプライト番号#1
    ; :
    ; というように4バイトごとにスプライト番号が付いている
    ;
    ; スプライトパターン番号とスプライト番号は異なる
    ; 例
    ; スプライト番号#0を構成するスプライトパターン番号は#0-#3
    ; スプライト番号#1を構成するスプライトパターン番号は#4-#7
    ;
    ; 以下、アトリビュートテーブルの詳細
    ;
    ; 1B00H : スプライト#0のY座標
    ; 1B01H : スプライト#0のX座標
    ; 1B02H : スプライト#0のパターン番号
    ; 1B03H : スプライト#0カラーコード
    ;
    ; 1B04H : スプライト#1のY座標
    ; 1B05H : スプライト#1のX座標
    ; 1B06H : スプライト#1のパターン番号
    ; 1B07H : スプライト#1カラーコード
    ;  :
    ; 
    ; パターン番号のいちばん低いスプライトが優先表示される
    ; スプライトが画面水平に重なると5個め以降のスプライトの
    ; 重なっているスプライト面は非表示となる
    ;--------------------------------------------

    ld hl, WK_PLAYERSPRATTR
    call LDIRVM

    ret

;--------------------------------------------
; SUB-ROUTINE: PutFireballSprite
; ワーク用スプライトアトリビュートテーブルの内容を
; DEレジスタが指し示すVRAMアドレスにブロック転送する
; BCレジスタ：転送バイト数
;--------------------------------------------
PutFireballSprite:

    ld hl, WK_FIREBALLSPRATTR
    call LDIRVM

    ret

;--------------------------------------------
; SUB-ROUTINE: ResetFireball
; スクロールさせた場合は弾を消す
; IXレジスタにWK_FIREBALL_DATA_TBLの弾のアドレスを
; セットしてから呼び出すこと
;--------------------------------------------
ResetFireball:

    ;--------------------------------------------
    ; 弾発射情報を初期化する
    ;--------------------------------------------
    ld a, 0
    ld (WK_FIREBALL_TRIG), a

    ;--------------------------------------------
    ; 弾情報テーブルを初期化する
    ;--------------------------------------------
    ld hl, WK_FIREBALL_DATA_TBL
    ld ix, hl
    ld (ix + 0), a
    ld (ix + 1), a
    ld (ix + 2), a
    ld (ix + 3), a
    ld (ix + 4), a
    ld (ix + 5), a
    ld (ix + 6), a
    ld (ix + 7), a
    ld (ix + 8), a

    ;--------------------------------------------
    ; 弾発射インターバル値を初期化する
    ;--------------------------------------------
    ld (WK_FIREBALL_INTTIME), a

    ;--------------------------------------------
    ; ワーク用スプライトアトリビュートテーブル
    ; を作成する
    ;--------------------------------------------
    ld ix, WK_FIREBALLSPRATTR
    ld a, 0 ; カラーは透明色をセットしておく
    ld (ix +  0), a
    ld (ix +  1), a
    ld (ix +  3), a
    ld a, 32     ; スプライトパターン番号は32固定
    ld (ix +  2), a

    ; スプライトを表示する
    ld de, $1B08
    ld bc, 8 ; スプライト2枚分を表示
    call PutFireballSprite

    ret
