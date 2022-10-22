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

    ;--------------------------------------------
    ; スプライトの移動量TBLのアドレスを取得して
    ; HLレジスタに格納する
    ;--------------------------------------------
    ld b, a ; Bレジスタにジョイスティックの方向の値を退避
    
MovePlayerSectionUp:

    ;--------------------------------------------
    ; スプライトの方向によってHLレジスタの値(ポインタ)
    ; を変更する
    ;--------------------------------------------

    cp 1 ; ジョイスティックの方向は上か？
    jr nz, MovePlayerSectionRight

    ld ix, SPRDISTPTN_TBL

    ; 方向は上
    ; 移動処理にジャンプ
    jr MovePlayerMoveProc

MovePlayerSectionRight:

    cp 3 ; ジョイスティックの方向は右か？
    jr nz, MovePlayerSectionDown

    ; 方向は右
    ld ix, SPRDISTPTN_TBL + 1

    ; 移動処理にジャンプ
    jr MovePlayerMoveProc

MovePlayerSectionDown:

    cp 5 ; ジョイスティックの方向は下か？
    jr nz, MovePlayerSectionLeft

    ; 方向は下
    ld ix, SPRDISTPTN_TBL + 2

    ; 移動処理にジャンプ
    jr MovePlayerMoveProc

MovePlayerSectionLeft:

    cp 7 ; ジョイスティックの方向は左か？
    jr nz, MovePlayerEnd ; 斜め方向は無視する

    ; 方向は左
    ld ix, SPRDISTPTN_TBL + 3

MovePlayerMoveProc:

    ;--------------------------------------------------------
    ; 移動処理の仕様
    ; ・前向いていた方向と異なる場合は移動はせず向きだけ変える
    ; ・前向いていた方向と同じ場合はその方向に移動する
    ;--------------------------------------------------------

    ld a, (WK_PLAYERDIST) ; Aレジスタに前回の向きをセット

    ; Aレジスタの値からBレジスタの値を減算した結果が0でなければ
    ; 向きが変わったと判定する
    cp b
    jr nz, MovePlayerChangeDistOnly

    ; 向きが同じであれば移動させる

    ; ジョイスティックの方向に移動させる
    ld a, b ; Bレジスタに退避していたジョイスティックの方向を復旧

    ; 現在の位置をOLD変数にセット
    ld bc, 2
    ld de, WK_PLAYERPOSXOLD
    ld hl, WK_PLAYERPOSX
    ldir

    ld b, a; ジョイスティックの方向をBレジスタに退避

MovePlayerUp:

    cp 1
    jr nz, MovePlayerRight

    ; Y座標を減算
    ld a, (WK_PLAYERPOSY)
    dec a
    ld (WK_PLAYERPOSY), a
    
    jr MovePlayerPutSprite

MovePlayerRight:

    cp 3
    jr nz, MovePlayerDown

    ; X座標を加算
    ld a, (WK_PLAYERPOSX)
    inc a
    ld (WK_PLAYERPOSX), a
    
    jr MovePlayerPutSprite

MovePlayerDown:

    cp 5
    jr nz, MovePlayerLeft

    ; Y座標を加算
    ld a, (WK_PLAYERPOSY)
    inc a
    ld (WK_PLAYERPOSY), a
    
    jr MovePlayerPutSprite

MovePlayerLeft:

    ; X座標を減算
    ld a, (WK_PLAYERPOSX)
    dec a
    ld (WK_PLAYERPOSX), a

    jr MovePlayerPutSprite
    
MovePlayerChangeDistOnly:

    ; プレイヤーの向きだけ変更する

    ; プレイヤーの向きを変数にセット
    ld a, b
    ld (WK_PLAYERDIST), a

MovePlayerPutSprite:

    ; 移動制限処理
    ; 許容範囲外に移動する場合は表示位置をもとに戻す
    ; （移動を行わない）
    call UndoMove

    ; ワーク用スプライトアトリビュートテーブルを
    ; 作成する
    call CreateWorkSpriteAttr

    ; スプライトを表示する
    ld de, $1B00
    ld bc, 8 ; スプライト2枚分を表示
    call PutSprite

MovePlayerEnd:

    ret

;--------------------------------------------
; SUB-ROUTINE: UndoMove
; 移動範囲外に移動した場合は表示位置を元に戻す
;--------------------------------------------
UndoMove:

    ld a, (WK_PLAYERPOSX)

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
