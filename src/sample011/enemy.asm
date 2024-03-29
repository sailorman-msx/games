;--------------------------------------------
; enemy.asm 
; テキキャラ関連
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: InitializeEnemyDatas
; テキキャラポインタテーブルと
; テキキャラ1体ぶんのデータを初期化する
;--------------------------------------------
InitializeEnemyDatas:

    push af
    push bc
    push de
    push hl

    ld hl, WK_ENEMY_DATA_TBL   ; テキキャラ管理用テーブルの先頭アドレスをHLレジスタにセット
    ld (WK_ENEMY_DATA_IDX), hl ; HLレジスタの値をテキキャラインデックス変数にセット

    ld hl, WK_ENEMY_PTR_TBL    ; テキキャラポインタテーブルの先頭アドレスをHLレジスタにセット
    ld (WK_ENEMY_PTR_IDX), hl  ; HLレジスタの値をテキキャラポインタ変数にセット

    ld hl, ENEMY_SPAWN_POS     ; テキキャラの初期発生場所のデータが格納されているアドレスをHLレジスタにセット
    ld (WK_SPAWN_POS), hl      ; HLレジスタの値をスポーンデータインデックス変数にセット

    ld  c, 15 ; スポーン位置(15箇所)ぶんのテキキャラを生成する）

InitializeEnemyDatasLoop1:

    ld  b, 5  ; 5体分のテキキャラを作成する

InitializeEnemyDatasLoop2:

    ld iy, (WK_ENEMY_DATA_IDX) ; IYレジスタにWK_ENEMY_DATA_IDXに格納されているアドレスをセット

    ld hl, (WK_ENEMY_PTR_IDX)  ; WK_ENEMY_PTR_IDXにはWK_ENEMY_PTR_TBLのアドレスがセットされている
    ld de, (WK_ENEMY_DATA_IDX)
    ld (hl), de                ; そのアドレスの値にWK_ENEMY_DATA_IDXに格納さている値をセットする

    call GetEnemyType

    ld (iy + 0), a             ; テキキャラの種類をセットする(1 or 2)

    ld hl, (WK_SPAWN_POS)      ; MAP論理座標をセット
    ld  a, (hl)
    ld (iy + 1), a 
    ld (iy + 7), a             ; テキキャラ初期スポーン位置(X座標)をセット
    inc hl
    ld  a, (hl)
    ld (iy + 2), a
    ld (iy + 8), a             ; テキキャラ初期スポーン位置(Y座標)をセット

    ld (iy + 3), 0             ; 進行方向をセット(初期スポーン時はランダムに方向決めする)
    call GetEnemyDist
    ld (iy + 3), a             ; 進行方向をセット

    call GetEnemyRange
    ld (iy + 4), a             ; 進行距離をセット(基本的には常に1。ハードモード作ったら考える)

    ld a, 0
    ld (iy + 5), a             ; 進行カウンタに0をセット

    ld (iy + 6), 0             ; 当たり判定フラグに0をセット

    ld (iy + 9), 0             ; 上書き前のタイル番号に0をセット

    ld (iy +10), 100           ; テキキャラを倒したときのスコア値を100点とする
    
    ; テキキャラをMAP座標にプロットする
    ld hl, WK_MAPAREA
    ld a, (iy + 2)
    cp 1
    jr c, PlotLoopEnd
    ld d, a
PlotLoop:
    add hl, 45
    dec d
    jr nz, PlotLoop
PlotLoopEnd:
    ld a, (iy + 1)

    ld d, 0
    ld e, a
    add hl, de
    
    ld a, (iy + 0)

    ; テキキャラのタイル番号は#11(TYPE-1),#15(TYPE-2)
    cp 1
    jr nz, PlotTileNoEnemyType2

    ld a, 11
    jr PlotTileNoEnemyEnd

PlotTileNoEnemyType2:

    ld a, 15

PlotTileNoEnemyEnd:

    ld (hl), a          ; テキキャラのタイル番号をプロット

    ; IYレジスタに11を加算して、その値を(WK_ENEMY_DATA_IDX)にセットする
    ld de, 11
    add iy, de
    
    ld (WK_ENEMY_DATA_IDX), iy

    ld hl, (WK_ENEMY_PTR_IDX)
    add hl, 2 ; アドレスをすすめる
    ld (WK_ENEMY_PTR_IDX), hl

    dec b
    jp nz, InitializeEnemyDatasLoop2 ; 次のキャラ(1体ぶん)の初期値を設定する

    ld hl, (WK_SPAWN_POS)       
    add hl, 2
    ld (WK_SPAWN_POS), hl ; スポーン位置のアドレスを進める

    dec c
    jp nz, InitializeEnemyDatasLoop1 ; 次のキャラ(5体ぶん)の初期値を設定する 

    pop hl
    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: GetEnemyType
; テキキャラの種類を取得する(1 or 2)
; Aレジスタに種類がセットされて返却される
;--------------------------------------------
GetEnemyType:

    ; テキキャラの種類を特定するため乱数の値を取得する
    call RandomValue

    ld a, (WK_RANDOM_VALUE)    ; 乱数の値をAレジスタにセットする

    cp 128 ; 乱数の値が127以下であればTYPE1にする
    jr c, GetEnemyTypeSetTYPE1

    ld a, 2 ; 乱数の値が128以上であればTYPE2にする
    jr GetEnemyTypeEnd

GetEnemyTypeSetTYPE1:

    ld a, 1

GetEnemyTypeEnd:
    
    ret

;--------------------------------------------
; SUB-ROUTINE: GetEnemyDist
; テキキャラの進行方向を取得する(1 or 3 or 5 or 7)
; テキキャラの種類によって、進行方向を変える
; TYPE1:
;   1 -> 3 -> 5 -> 7 -> 1 ... (時計回り)
; TYPE2:
;   1 -> 7 -> 5 -> 3 -> 1 ... (反時計回り)
; Aレジスタに種類がセットされて返却される
;--------------------------------------------
GetEnemyDist:

    push bc

    ; テキキャラの進行方向が0(初期スポーン時)には
    ; ランダムに進行方向を決定する。
    ; そうでない場合は以下の規則に従って方向を特定する
    ; TYPE-1:時計回り
    ;  1 -> 3 -> 5 -> 7 -> 1
    ; TYPE-2:反時計回り
    ;  1 -> 7 -> 5 -> 3 -> 1
    ld a, (ix + 0)
    cp 1
    jr nz, GetEnemyDistType2

GetEnemyDistType1:

    ld a, (ix + 3)
    cp 1
    jr nz, GetEnemyDistType1Right

    ld a, 3 ; 次は右方向
    jr GetEnemyDistEnd

GetEnemyDistType1Right:

    ld a, (ix + 3)
    cp 3
    jr nz, GetEnemyDistType1Down

    ld a, 5 ; 次は下方向
    jr GetEnemyDistEnd

GetEnemyDistType1Down:

    ld a, (ix + 3)
    cp 5
    jr nz, GetEnemyDistType1Left

    ld a, 7 ; 次は左方向
    jr GetEnemyDistEnd

GetEnemyDistType1Left:

    ld a, 1 ; 次は上方向
    jr GetEnemyDistEnd

GetEnemyDistType2:

    ld a, (ix + 3)
    cp 1
    jr nz, GetEnemyDistType2Right

    ld a, 3 ; 次は右方向
    jr GetEnemyDistEnd

GetEnemyDistType2Right:

    ld a, (ix + 3)
    cp 3
    jr nz, GetEnemyDistType2Down

    ld a, 5 ; 次は下方向
    jr GetEnemyDistEnd

GetEnemyDistType2Down:

    ld a, (ix + 3)
    cp 5
    jr nz, GetEnemyDistType2Left

    ld a, 7 ; 次は左方向
    jr GetEnemyDistEnd

GetEnemyDistType2Left:

    ld a, 1 ; 次は上方向
    jr GetEnemyDistEnd
    
;
; 初期スポーン時は
; テキキャラの進行方向を特定するため乱数の値を取得する
; 
GetEnemyDistLoop:

    call RandomValue

    ld a, (WK_RANDOM_VALUE)    ; 乱数の値をAレジスタにセットする

    and 00000111B ; 0-7までの値にする

    ; 0, 2, 4, 6 の場合は再度乱数を取り直す
    cp 2
    jr z, GetEnemyDistLoop
    cp 4
    jr z, GetEnemyDistLoop
    cp 6
    jr z, GetEnemyDistLoop
    cp 1
    jr c, GetEnemyDistLoop

GetEnemyDistEnd:

    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: GetEnemyRange
; テキキャラの進行距離を取得する(0 - 1)
; Aレジスタに種類がセットされて返却される
; 処理速度の都合上、最大1タイルに修正
;--------------------------------------------
GetEnemyRange:

    ; テキキャラの進行距離を特定するため乱数の値を取得する
    call RandomValue

    ld a, (WK_RANDOM_VALUE)    ; 乱数の値をAレジスタにセットする

    and 00000001B              ; 00000001B でANDして0-1までの値にする

GetEnemyRangeEnd:

    ret

;--------------------------------------------
; SUB-ROUTINE: MoveEnemies
; テキキャラの移動情報を変更して移動させる
;
; (仕様)
; テキを表示させるためには12x12タイルのビューポートをベースに考える。
; テキの論理座標がその範囲内に存在していれば、描画処理の対象となる。
; ※この処理はmap.asmで実装
;
; 範囲内に存在していない場合は論理座標のタイル情報だけで判定する。
;
; テキの進行カウンタが15以上の場合は進行方向に半タイルぶん移動させる。
; この場合は論理座標は移動させない。
; *この処理はmap.asmで実装（現在、未実装）
;
; テキの論理座標が12x12ビューポート範囲外の場合:
; 移動方向先の1タイルが床や炎ではない場合は移動せずに、移動情報を初期化する。
; 
; テキの論理座標が12x12ビューポート範囲内の場合:
; 半タイルの移動先が床や炎ではない場合は移動させずに、移動情報を初期化する。
; 移動できる場合は半タイル移動させた位置にテキを表示する。
; ※この処理はmap.asmで実装
; 
; テキの移動フラグが1の場合は進行方向に1タイル分移動させて移動フラグを0にする。
; この際に論理座標も移動させる。
;
; 12x12タイルぶんの表示キャラクターのメモリ展開が完了したら
; そのうちの10×10タイルぶんだけのキャラクター情報をVRAM（画面）に転送する。
;
; テキの移動後の論理座標が炎のタイルである場合は
; タイル情報をテキのキャラには書き換えずテキの当たり判定に進める。
;--------------------------------------------
MoveEnemies:

    ld hl, WK_ENEMY_DATA_TBL   ; テキキャラ管理用テーブルの先頭アドレスをHLレジスタにセット
    ld (WK_ENEMY_DATA_IDX), hl ; HLレジスタの値をテキキャラインデックス変数にセット

MoveEnemiesLoop1:

    ld ix, (WK_ENEMY_DATA_IDX)
    ld a, (ix + 0)
    or a; テキキャラポインタテーブルの+0番目の値がゼロの場合は処理を抜ける
    jp z, MoveEnemiesEnd

    ;-----------------
    ; テキを進行方向に進める
    ; 進行距離が0であれば移動方向と移動距離を設定しなおす
    ; 進行距離が0でなければ進行カウンタをインクリメントする
    ; 進行カウンタが15の場合は、インクリメントせず移動方向と移動距離を設定しなおす
    ;-----------------
    ld a, (ix + 4)              ; 進行距離の取得

    cp 1
    jp c, MoveEnemiesRestructEnemyInfo ; 進行距離が0の場合、AND演算でZフラグがたつので
                                       ; テキキャラの移動情報を再構築する

    ld a, (ix + 5)              ; 進行カウンタの取得
    cp 15 ; 進行カウンタが15未満の場合は進行カウンタをインクリメントするだけで次のデータ操作に進む
    jr c, MoveEnemiesNextData

MoveEnemiesMoveTile:

    ld a, (ix + 1)
    ld (WK_ENEMY_POSX_OLD), a
    ld a, (ix + 2)
    ld (WK_ENEMY_POSY_OLD), a

    ; 進行方向を取得する
    ld hl, WK_ENEMY_MOVE_PROC
    ld a, (ix + 3)
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

MoveEnemiesMoveUp:

    ; 上方向に移動する
    ld a, (ix + 2)   ; テキのMAP上のY座標を1減らす
    dec a
    ld (ix + 2), a

    jr MoveEnemiesMapMove

MoveEnemiesMoveDown:

    ; 下方向に移動する
    ld a, (ix + 2)   ; テキのMAP上のY座標を1加算する
    inc a
    ld (ix + 2), a

    jr MoveEnemiesMapMove

MoveEnemiesMoveRight:

    ; 右方向に移動する
    ld a, (ix + 1)   ; テキのMAP上のX座標を1加算する
    inc a
    ld (ix + 1), a

    jr MoveEnemiesMapMove

MoveEnemiesMoveLeft:

    ; 左方向に移動する
    ld a, (ix + 1)   ; テキのMAP上のX座標を1減らす
    dec a
    ld (ix + 1), a

MoveEnemiesMapMove:
    
    call MoveEnemyTileMove

    ; MoveEnemyTileMoveを呼ぶと移動後のMAPのタイル番号が
    ; Aレジスタに格納されて返却されるので
    ; 0でなければ移動をキャンセルする

    cp 1
    jr c, MoveEnemiesMoveEnd

    ; 移動前の座標をセットしなおす
    ld a, (WK_ENEMY_POSX_OLD)
    ld (ix + 1), a
    ld a, (WK_ENEMY_POSY_OLD)
    ld (ix + 2), a

    ; 移動できないため移動情報を再度設定しなおす
    jr MoveEnemiesRestructEnemyInfo

MoveEnemiesMoveEnd:
    
    ; 移動距離を1減らす
    ld a, (ix + 4)
    dec a
    ld (ix + 4), a
    
    ; 移動前の座標のタイル番号を床(0)に変更する
    call ResetEnemyMoveSrc

MoveEnemiesLoop1End:

    jr MoveEnemiesNextData
    
MoveEnemiesRestructEnemyInfo:

    ; 移動できないため移動情報を再度設定しなおす
    call RestructEnemyMoveData

    jr MoveEnemiesNextData

MoveEnemiesNextData:

    ; 進行カウンタをインクリメントする
    ld a, (ix + 5)
    inc a
    ld (ix + 5), a

    ; 次のテキ情報の先頭アドレスをIXレジスタにセットする
    ld de, 11
    add ix, de

    ld (WK_ENEMY_DATA_IDX), ix

    jp MoveEnemiesLoop1
    
MoveEnemiesEnd:

    ret

;--------------------------------------------
; SUB-ROUTINE: MoveEnemyTileMove
; テキキャラをMAP座標で移動させる
; 指定されてるMAP座標のタイルが床でなければ移動しない
; (WK_MAPAREAを更新する)
;
; Aレジスタには移動後の座標のタイル番号がセットされて
; 返却される
;--------------------------------------------
MoveEnemyTileMove:

    push bc
    push de
    push hl

    ld hl, WK_MAPAREA

    ld b, (ix + 2)  ; テキのY座標
    ld c, (ix + 1)  ; テキのX座標

    ld a, b

    cp 1
    jr c, MoveEnemyTileMoveLoopEnd

MoveEnemyTileMoveLoop:

    add hl, 45
    djnz MoveEnemyTileMoveLoop

MoveEnemyTileMoveLoopEnd:

    ld b, 0
    add hl, bc

    ld a, (hl)

    ; 移動先のMAP座標のタイル番号が#1,#2とテキキャラのタイル番号の場合は移動させない
    cp 1
    jr z, MoveEnemyTileMoveEnd
    cp 2
    jr z, MoveEnemyTileMoveEnd
    cp 11
    jr z, MoveEnemyTileMoveEnd
    cp 12
    jr z, MoveEnemyTileMoveEnd
    cp 13
    jr z, MoveEnemyTileMoveEnd
    cp 14
    jr z, MoveEnemyTileMoveEnd
    cp 15
    jr z, MoveEnemyTileMoveEnd
    cp 16
    jr z, MoveEnemyTileMoveEnd
    cp 17
    jr z, MoveEnemyTileMoveEnd
    cp 18
    jr z, MoveEnemyTileMoveEnd

    ld a, (ix + 0)

    ld de, hl ; HLレジスタの値をDEレジスタに退避

    cp 2
    jr z, MoveEnemyTileTYPE2

MoveEnemyTileTYPE1:

    ld a, (ix + 3)
    ld b, 0
    ld c, a

    ; タイプ1のタイル番号をセットする
    ld hl, ENEMY_TILE_NUMBER_TYPE1
    add hl, bc
    ld a, (hl)

    jr MoveEnemyTileSetEnemyTile

MoveEnemyTileTYPE2:

    ld a, (ix + 3)

    ; タイプ2のタイル番号をセットする
    ld a, (ix + 3)
    ld b, 0
    ld c, a

    ld hl, ENEMY_TILE_NUMBER_TYPE2
    add hl, bc
    ld a, (hl)

MoveEnemyTileSetEnemyTile:

    ld hl, de      ; DEレジスタに退避していた値をHLレジスタに戻す
    ld (hl), a     ; 移動先にタイル番号をセットする

    ld a, 0        ; 移動先座標のタイル番号を#0として返却する

MoveEnemyTileMoveEnd:

    pop hl
    pop de
    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: ResetEnemyMoveSrc
; テキキャラの移動元MAP座標のタイル番号を床(0)にする
;--------------------------------------------
ResetEnemyMoveSrc:

    push bc
    push de
    push hl

    ld hl, WK_MAPAREA

    ld a, (WK_ENEMY_POSY_OLD)
    cp 1
    jr c, ResetEnemyMoveSrcLoopEnd
    ld b, a

    ld a, (WK_ENEMY_POSX_OLD)
    ld c, a

ResetEnemyMoveSrcLoop:

    add hl, 45
    djnz ResetEnemyMoveSrcLoop

ResetEnemyMoveSrcLoopEnd:

    ld d, 0
    ld e, c

    add hl, de

    ld (hl), 0 ; タイル番号0を移動前のMAP座標にセットする
    
    pop hl
    pop de
    pop bc

    ret

;--------------------------------------------
; SUB-ROUTINE: RestructEnemyMoveData
; テキキャラの移動情報を再構築する
;
; テキキャラ管理用アドレスをセットして呼び出すこと
;--------------------------------------------
RestructEnemyMoveData:

    push bc

    ld a, (ix + 3)
    ld b, a

RestructEnemyMoveDataLoop:

    call GetEnemyDist
    ; 前回と同じ値であれば再度方向を取得する
    cp b
    jr z, RestructEnemyMoveDataLoop

    ld (ix + 3), a  ; 進行方向をセット

    call GetEnemyRange

    ld (ix + 4), a  ; 進行距離をセット
    ld (ix + 5), 0  ; 進行カウンタを初期化
    ld (ix + 6), 0  ; 当たり判定フラグを初期化
    
    pop bc

    ret
