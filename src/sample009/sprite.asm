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
    ld bc, 256     ; 1体あたり64バイトx4パターン
    call LDIRVM
    
    ret

;------------------------------------------------
; SUB-ROUTINE: MovePlayer
; Aレジスタに格納されている情報から
; 方向を特定してプレイヤーのスプライトを移動させる
;------------------------------------------------
MovePlayer:

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

    ret

;--------------------------------------------
; SUB-ROUTINE: CheckVRAM4x4
; (返却値)
; Aレジスタ=0 : 移動可能
; Aレジスタ=1 : 移動不可
;--------------------------------------------
CheckVRAM4x4:

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

CheckVRAM4x4Up:

    cp 1
    jr nz, CheckVRAM4x4Right

    ; 進行方向は上

    ld a, (WK_VRAM4X4_TBL+$01)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$02)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4Right:

    cp 3
    jr nz, CheckVRAM4x4Down

    ; 進行方向は右

    ld a, (WK_VRAM4X4_TBL+$07)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$0B)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4Down:

    cp 5
    jr nz, CheckVRAM4x4Left

    ; 進行方向は下

    ld a, (WK_VRAM4X4_TBL+$0D)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$0E)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4Left:

    cp 7
    jr nz, CheckVRAM4x4MoveOkay

    ; 進行方向は左

    ld a, (WK_VRAM4X4_TBL+$04)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    ld a, (WK_VRAM4X4_TBL+$08)
    cp $24 ; 移動先は床か？
    jr nz, CheckVRAM4x4DoNotMove

    jr CheckVRAM4x4MoveOkay

CheckVRAM4x4DoNotMove:

    ld a, 1
    jr CheckVRAM4x4End

CheckVRAM4x4MoveOkay:

    ld a, 0

CheckVRAM4x4End:

    ret

;--------------------------------------------
; SUB-ROUTINE: UndoMove
; 移動範囲外に移動した場合は表示位置を元に戻す
; 移動先のVRAM情報が床以外であっても表示位置を元に戻す
;--------------------------------------------
UndoMove:

    ld a, (WK_PLAYERPOSX)

    ;--------------------------------------------
    ; 座標制限判定
    ;--------------------------------------------

    ; X座標の判定
    cp 1  ; X座標が0の場合は表示位置を元に戻す(CYフラグで判定)
    jr c, UndoMoveSetOldPos

    cp 30 ; X座標が29を超える場合は表示位置を元に戻す(Zフラグで判定)
    jr z, UndoMoveSetOldPos

    ld a, (WK_PLAYERPOSY)

    ; Y座標の判定
    cp 1  ; Y座標が0の場合は表示位置を元に戻す(CYフラグで判定)
    jr c, UndoMoveSetOldPos

    cp 22 ; Y座標が21を超える場合は表示位置を元に戻す(Zフラグで判定)
    jr z, UndoMoveSetOldPos

    jr UndoMoveEnd

UndoMoveSetOldPos:

    ; X座標、Y座標を元に戻す（移動させない）
    ld bc, 2
    ld de, WK_PLAYERPOSX
    ld hl, WK_PLAYERPOSXOLD
    ldir

UndoMoveEnd:

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
; SUB-ROUTINE: PutSprite
; ワーク用スプライトアトリビュートテーブルの内容を
; DEレジスタが指し示すVRAMアドレスにブロック転送する
; BCレジスタ：転送バイト数
;--------------------------------------------
PutSprite:

    ;--------------------------------------------
    ; スプライトアトトリビュートテーブルは次の
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
