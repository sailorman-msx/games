;--------------------------------------------
; スプライト関連の処理
; テキキャラ関連のデータ作成が主処理
;--------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: InitializeSPRMOVETBL
; スプライトの移動関連テーブルを初期化する
;--------------------------------------------
InitializeSPRMOVETBL:

    ;--------------------------------------------
    ; スプライト座標管理用テーブルを初期化する
    ; 敵10体ぶん+プレイヤー1体ぶん作成する
    ;--------------------------------------------

    ; ワークテーブルの初期化を行う
    ld hl, WK_SPRITE_MOVETBL
    ld bc, 512
    xor a
    call MemFil

    ret

;--------------------------------------------
; SUB-ROUTINE: CreateEnemyData
; マップ座標にあわせてテキキャラデータを
; 生成する
;--------------------------------------------
CreateEnemyData:

    ; プレイヤーのぶんスキップする

    xor a
    ld (WK_VALUE07), a

    ; SPRITE_MOVETBLのアドレスを取得
    ; プレイヤーのぶんスキップする

    ld hl, WK_SPRITE_MOVETBL + 48
    ld (WK_HLREGBACK), hl

    ; ワークテーブルの初期化を行う
    ld bc, 29 * 16 ; テキキャラ29体 x 16
    xor a
    call MemFil

    ; 6体ぶんの消失データをセットする

    ld d, 0
    ld e, 16

    ld b, 6
    ld a, $E0
    
    ld hl, (WK_HLREGBACK)

CreateEnemyDataInitLoop:
    
    ld (hl), a
    add hl, de
    djnz CreateEnemyDataInitLoop

    ; 乱数SEED値を更新する
    ld a, (INTCNT)
    ld b, a
    ld a, (WK_RANDOM_VALUE)
    add a, b
    ld (WK_RANDOM_VALUE), a

    ; マップデータのアドレスを特定
    ; WK_PIT_ENTER_FLGが1の場合は
    ; WK_PIT_MAP_ADDRのアドレスを採用する

    ld a, (WK_PIT_ENTER_FLG)
    cp 1
    jp nz, CreateEnemyDataOverworld

CreateEnemyDataFromPITData:

    ld hl, (WK_PIT_MAP_ADDR)

    jp CreateEnemyDataReadEnemyData

CreateEnemyDataOverworld:

    ld a, (WK_MAPPOSY)
    ld e, 12
    ld h, a
    call CalcMulti

    ld a, (WK_MAPPOSX)
    add a, a ; x2してアドレスの値にする
    ld d, 0
    ld e, a
    add hl, de
    ld de, hl

    ld hl, MAP_DATAWORLD
    add hl, de
    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc

CreateEnemyDataReadEnemyData:

    ld de, hl

    ; 先頭1バイトはマップ種別なのでスキップする
    inc de

    ; 次の2バイトはPITのマップデータアドレス
    ; このアドレスが$FFFFであれば
    ; PIT情報の6バイトの読み込みはスキップする
    ld c, (de)
    inc de
    ld b, (de)
    inc de
    push hl
    or a  ; ZERO TO CY
    ld hl, $FFFF
    sbc hl, bc
    pop hl

    jr z, CreateEnemyDataLoop1

    ; 次の6バイトはPITの入出情報なのでスキップする
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de

CreateEnemyDataLoop1:

    ; 敵の種別コードとレベルは
    ; 1バイトで管理する
    ; 上位4ビット=種別コード、下位4ビット=レベル
    ld a, (de)
    or a  ; EODであればループを抜ける
    jp z, CreateEnemyDataLoop1End

    ld (WK_DEREGBACK), de

    ld hl, (WK_HLREGBACK)
    ld bc, hl
    ld (WK_BCREGBACK), bc

    ld b, a
    ; Aレジスタの上位4ビットを抽出
    and $F0
    sra a
    sra a
    sra a
    sra a
    ld (hl), a ; + 0 種別コード

    ld (WK_VALUE01), a ; VALUE01に種別コードを格納

    ld a, b
    ; Aレジスタの下位4ビットを抽出
    and $0F
    ld (WK_VALUE02), a

    ; 種別コードによってパターン番号を特定する
    ld hl, ENEMY_PTN

    ; 種別コードに2をかけてENEMY_PTNに加算するとパターン番号が取得できる
    ; ただしウイザードとスケルトンの場合は後処理で進行方向によってパターン番号を決定する
    ; ウイザードの進行方向は wizard.asm でセットする
    ; スケルトンの進行方向は skelton.asm でセットする

    ld a, (WK_VALUE01)
    cp 3  ; 種別コード=3（ウイザード）はスキップ
    jp z, CreateEnemySetPosition
    cp 5  ; 種別コード=5（スケルトン）はスキップ
    jp z, CreateEnemySetPosition

    add a, a
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc

    ld a, (hl)
    ld (WK_VALUE03), a  ; テキのパターン(VALUE03に格納) 

CreateEnemySetPosition:

    ld hl, (WK_HLREGBACK)

    inc hl     ; HL : SPRITEMOVETBL Y座標
    inc de     ; DE : MAPDATA Y座標
    ld a, (de) ; マップデータ上のY座標
    cp $80
    jp nz, CreateEnemyDataSetY

    ; ランダムにY座標を決定する
CreateEnemyRandomYLoop:

    call RandomValue
    ; and $1F ; 0-31の値にする
    cp 21
    jp nc, CreateEnemyRandomYLoop ; 21以上であれば再度乱数を取り直す
    
    cp 5
    jp c, CreateEnemyRandomYLoop  ; 5未満であれば再度乱数を取り直す

CreateEnemyDataSetY:

    ; WK_CHECKPOSXにY座標をセット
    ld (WK_CHECKPOSY), a

    ld (WK_DEREGBACK), de
    ld (WK_HLREGBACK), hl

    add a, a ; x2
    add a, a ; x4
    add a, a ; x8

    ld (hl), a ; +1 スプライトのY座標(0-191)

    inc hl     ; HL : SPRITEMOVETBL X座標
    inc de     ; DE : MAPDATA X座標
    ld a, (de) ; マップデータ上のX座標
    cp $80
    jp nz, CreateEnemyDataSetX

    ; ランダムにX座標を決定する
CreateEnemyRandomXLoop:

    call RandomValue
    ; and $1F ; 0-31の値にする
    cp 29
    jp nc, CreateEnemyRandomXLoop  ; 29以上であれば再度乱数を取り直す
    
    cp 3
    jp c, CreateEnemyRandomXLoop   ; 3未満であれば再度乱数を取り直す

CreateEnemyDataSetX:

    ; WK_CHECKPOSXにX座標をセット
    ld (WK_CHECKPOSX), a

    ld (WK_DEREGBACK), de
    ld (WK_HLREGBACK), hl

    ; X,Y座標に障害物が存在していたら再度座標を取得しなおす
    call GetVRAM4x4
    ld hl, WK_VRAM4X4_TBL + 5 ; キャラの左上をチェック
    ld a, (hl)
    cp $22
    jp z, CreateEnemyDataSetXCheck2
    jp CreateEnemyDataSetRetrySetPos

CreateEnemyDataSetXCheck2:

    ld hl, WK_VRAM4X4_TBL + 6 ; キャラの右上をチェック
    ld a, (hl)
    cp $22
    jp z, CreateEnemyDataSetXCheck3
    jp CreateEnemyDataSetRetrySetPos

CreateEnemyDataSetXCheck3:

    ld hl, WK_VRAM4X4_TBL + 9 ; キャラの左下をチェック
    ld a, (hl)
    cp $22
    jp z, CreateEnemyDataSetXCheck4
    jp CreateEnemyDataSetRetrySetPos

CreateEnemyDataSetXCheck4:

    ld hl, WK_VRAM4X4_TBL + 10 ; キャラの左下をチェック
    ld a, (hl)
    cp $22
    jp z, CreateEnemyDataSetXOkay

CreateEnemyDataSetRetrySetPos:

    ld hl, (WK_HLREGBACK)
    dec hl
    dec hl
    ld de, (WK_DEREGBACK)
    dec de
    dec de
    ld (WK_HLREGBACK), hl
    ld (WK_DEREGBACK), de

    jp CreateEnemySetPosition

CreateEnemyDataSetXOkay:

    ld a, (WK_CHECKPOSX)

    add a, a ; x2
    add a, a ; x4
    add a, a ; x8

    ld hl, (WK_HLREGBACK)
    ld de, (WK_DEREGBACK)

    ld (hl), a ; +2 スプライトのX座標(0-255)

    inc hl
    ld a, (WK_VALUE03)
    ld (hl), a ; +3 スプライトパターン番号

    ld (WK_HLREGBACK), hl

    ; 種別コードによってパターン番号を特定する
    ld hl, ENEMY_COLOR

    ; 種別コードに2をかけてENEMY_COLORに加算し
    ; さらにレベルを加算するとカラー番号が取得できる
    ld a, (WK_VALUE01)
    add a, a
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc

    ld a, (WK_VALUE02)
    dec a
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)

    ld hl, (WK_HLREGBACK)
    inc hl
    ld (hl), a ; +4 スプライトカラー番号 

    ; 種別コードによって攻撃力、防御力、生命力の
    ; データを取得する
    ; 種別コードに2をかけてENEMY_STATUS_ENEMY_TYPEに
    ; 加算すると各テキキャラのステータスデータの
    ; 先頭アドレスが特定される
    ; そのアドレスにテキキャラのLV*2を加算すると
    ; 各キャラのステータスデータのアドレスが決定する

    ld hl, ENEMY_STATUS_ENEMYTYPE
    ld a, (WK_VALUE01)
    add a, a
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc
   
    ld a, (WK_VALUE02) ; テキのレベル
    add a, a ; x2
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc
   
    ld a, (hl) ; テキキャラの攻撃力
    ld (WK_VALUE04), a
    inc hl
    ld a, (hl) ; テキキャラの防御力
    ld (WK_VALUE05), a
    inc hl
    ld a, (hl) ; テキキャラの生命力
    ld (WK_VALUE06), a
    inc hl
    ld a, (hl) ; テキキャラのアイテムドロップ率
    ld (WK_VALUE08), a

    ; 移動方向、移動量、攻撃力、防御力、生命力等は
    ; 各テキキャラの初期処理で決定する
    ; ここでは初期値を設定しておく

    ; 移動方向
    ld hl, (WK_HLREGBACK)
    inc hl
    inc hl
    ld a, $FF
    ld (hl), a  ; +5 移動方向（初期値は-1）

    xor a

    ; 移動量
    inc hl
    ld (hl), a  ; +6 X移動量

    inc hl
    ld (hl), a ; +7 Y移動量

CreateEnemyDataSetOffence:

    inc hl     ; +8 攻撃力
    ld a, (WK_VALUE04)
    ld (hl), a

CreateEnemyDataSetDiffence:

    inc hl     ; +9 防御力
    ld a, (WK_VALUE05)
    ld (hl), a

CreateEnemyDataSetLife:

    inc hl     ; +A 生命力
    ld a, (WK_VALUE06)
    ld (hl), a

CreateEnemyDataSetFireAddr:

    xor a

    inc hl     ; +B - +C  弾発射状態アドレス
    ld (hl), a
    inc hl
    ld (hl), a

CreateEnemyDataSetItemDrop:

    inc hl     ; +D アイテムドロップ確率
    ld a, (WK_VALUE08)
    ld (hl), a

    inc hl     ; +E テキキャラのレベル
    ld a, (WK_VALUE02)
    ld (hl), a

    ; 移動インターバルは初期値として1をセットする
    ; この初期値は全キャラ共通とする
    ; テキキャラはインターバル値が0の場合
    ; 移動方向、移動量を自分で決定する

    inc hl     ; +F 移動インターバル
    ; ld a, 1
    ld a, (WK_VALUE07)
    inc a
    ld (WK_VALUE07), a
    ld (hl), a

    ld a, (WK_VALUE01)
    cp 3 ; Wizard ?
    jr z, CreateEnemyDataSetWizardSkelton
    cp 4 ; WOODY MONSTER ?
    jr z, CreateEnemyDataSetWoody
    cp 5 ; Skelton ?
    jr z, CreateEnemyDataSetWizardSkelton

    jp CreateEnemyDataSetNextData

CreateEnemyDataSetWizardSkelton:

    ; 種別=3(ウイザード)、5(スケルトン)の場合、2スプライトで
    ; 1体を表現するため16バイトぶんコピーする
    ; 1体目の先頭アドレスはWK_BCREGBACKにセットされているので
    ; そのアドレスから16バイトぶんをコピーする
    ld bc, (WK_BCREGBACK)
    ld h, b
    ld l, c
    ld (WK_HLREGBACK), hl
    ld d, 0
    ld e, 16
    add hl, de
    ld de, hl
    ld hl, (WK_HLREGBACK)
    ld bc, 16
    call MemCpy

    ; LDIR直後ではDEレジスタはコピー元アドレス+32の位置になっている
    ld (WK_BCREGBACK), de
    ld h, d
    ld l, e

    or a ; ZERO TO CY
    ld b, 0
    ld c, 16
    sbc hl, bc
    ld c, 4     ; スプライト2枚目のカラー番号の位置にセット
    add hl, bc

    ; ウイザードのスプライト2枚目のカラー番号は$0E（グレー）固定とする
    ld a, $0E
    ld (hl), a

    ld hl, (WK_BCREGBACK)
    dec hl

    jp CreateEnemyDataSetNextData

CreateEnemyDataSetWoody:
    
    ; 種別=4(WOODY MONSTER)の場合、2スプライトで
    ; 1体を表現するため16バイトぶんコピーする
    ; 1体目の先頭アドレスはWK_BCREGBACKにセットされているので
    ; そのアドレスから16バイトぶんをコピーする
    ld bc, (WK_BCREGBACK)
    ld h, b
    ld l, c
    ld (WK_HLREGBACK), hl
    ld d, 0 
    ld e, 16
    add hl, de
    ld de, hl
    ld hl, (WK_HLREGBACK)
    ld bc, 16
    call MemCpy
    
    ; LDIR直後ではDEレジスタはコピー元アドレス+32の位置になっている
    ld (WK_BCREGBACK), de
    ld h, d
    ld l, e

    or a ; ZERO TO CY
    ld b, 0
    ld c, 16
    sbc hl, bc
    ld b, 0
    ld c, 3     ; スプライト2枚目のパターン番号の位置にセット
    add hl, bc

    ; WOODY MONSTERのスプライト2枚目のパターン番号は192固定とする
    ld a, 192
    ld (hl), a
    inc hl
    ; WOODY MONSTERのスプライト2枚目のカラー番号は$0A（濃赤）固定とする
    ld a, $0A
    ld (hl), a

    ld hl, (WK_BCREGBACK)
    dec hl

CreateEnemyDataSetNextData:

    inc hl     ; 次のキャラクタの先頭位置
    ld (WK_HLREGBACK), hl

    ld de, (WK_DEREGBACK)
    inc de     ; マップデータ読み込み位置を1進める

    jp CreateEnemyDataLoop1

CreateEnemyDataLoop1End:

    ret

;--------------------------------------------
; SUB-ROUTINE: MoveEnemy
; テキキャラデータを更新して
; テキのスプライト情報(SPRITE_MOVETBL)を更新する
;--------------------------------------------
MoveEnemy:

    ; MOVE_ENEMY_COUNTERのカウンター値によって
    ; 移動処理を行うテキキャラを限定する

MoveEnemyTargetAddress:

    ld hl, WK_SPRITE_MOVETBL + 48

    push hl

    ld a, (WK_MOVE_ENEMY_COUNTER)
    ld h, 0
    ld l, a
    add hl, hl ; x2
    add hl, hl ; x4
    add hl, hl ; x8
    add hl, hl ; x16
    ld b, h
    ld c, l
    pop hl

    add hl, bc

    ; プレイヤーぶんの情報はスキップする

MoveEnemyLoop:

    ld (WK_HLREGBACK), hl

    ld a, (hl) ; 種別コードを取得
    or a
    jp z, MoveEnemyResetCounter

    ; 種別コード$E0は消失目前のデータのため
    ; 移動処理対象とはしない無視する
    cp $E0
    jp z, MoveEnemyBusterdProc

    ; 種別コードに2をかけてENEMY_MOVEPROCに加算すると
    ; テキキャラの種別ごとの処理にジャンプできる
    ld hl, ENEMY_MOVEPROC
    add a, a ; x2
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)
    ld c, a
    inc hl
    ld a, (hl)
    ld b, a
    ld hl, bc

    jp (hl)

    ;---------------------------------
    ; スライムの移動
    ;---------------------------------
    include "slime.asm"

    ;---------------------------------
    ; ウイスプの移動
    ;---------------------------------
    include "wisp.asm"

    ;---------------------------------
    ; ウイザードの移動
    ;---------------------------------
    include "wizard.asm"

    ;---------------------------------
    ; WOODY MONSTERの移動
    ;---------------------------------
    include "woody.asm"

    ;---------------------------------
    ; スケルトンの移動
    ;---------------------------------
    include "skelton.asm"

    ;---------------------------------
    ; ファイアボールの移動
    ;---------------------------------
    include "magicmissile.asm"

    ; 大魔導士（の弱点）の移動
    include "mage.asm"

MoveEnemyBusterdProc:

    ld b, 0
    ld c, $0F
    add hl, bc
    ld a, (hl)

    ; インターバル値が0は完全消失データ
    or a
    jr z, MoveEnemyRemoveData

    ; dec a
    ; ld (hl), a  ; インターバル値のデクリメント

    jr MoveEnemyNextDataAddCounter

MoveEnemyRemoveData:

    ; テキキャラ情報を0クリアする
    ld hl, (WK_HLREGBACK)
    ld a, (hl)

    inc hl ; 種別コードはクリアしない！
    ld b, 0
    ld c, 15
    ld a, 0
    call MemFil

MoveEnemyNextDataAddCounter:

    ld hl, (WK_HLREGBACK)
    ld b, 1
    ld a, (hl)
    cp 3
    jp z, MoveEnemyNextDataAddCounter2
    cp 4
    jp z, MoveEnemyNextDataAddCounter2
    cp 5
    jp z, MoveEnemyNextDataAddCounter2

    jr MoveEnemyNextDataAddCounterSetCounter

MoveEnemyNextDataAddCounter2:

    ld b, 2
    
MoveEnemyNextDataAddCounterSetCounter:

    ld a, (WK_MOVE_ENEMY_COUNTER)
    add a, b
    ld (WK_MOVE_ENEMY_COUNTER), a

    jr MoveEnemyLoopEnd

MoveEnemyResetCounter:

    xor a
    ld (WK_MOVE_ENEMY_COUNTER), a
    
MoveEnemyLoopEnd:

    ret

include "enemycommon.asm"

;----------------------------------------------------
; SUB-ROUTINE:テキキャラの存在チェック
; WK_SPRITE_MOVETBLをチェックし、テキキャラが何匹
; 存在しているか、その数をAレジスタにセットして返却する
;----------------------------------------------------
CheckEnemyExists:

    ld hl, WK_SPRITE_MOVETBL + 16 * 3 ; プレイヤーは無視

    ld b, 29 ; 29体分チェックする
    ld c, 0

    ld d, 0
    ld e, 16

CheckEnemyExistsLoop:

    ld a, (hl) ; 種別が0のデータはEODとする
    or a
    jr z, CheckEnemyExistsEnemyNotFound

    push hl

    cp $E0     ; 種別が$E0のデータ（消失データ）は無視
    jr z, CheckEnemyExistsLoopNextData
    cp $0A     ; 種別が$0Aのデータ（ファイアボール）は無視
    jr z, CheckEnemyExistsLoopNextData

    push bc
    ld b, 0
    ld c, 10
    add hl, bc
    pop bc

    ld a, (hl) ; ライフが0であればテキキャラは消失している
    or a
    jp z, CheckEnemyExistsLoopNextData

    ; ライフが0でないテキキャラが存在している場合は
    ; 処理を抜ける
    ld a, 1

    pop hl
    ret

CheckEnemyExistsLoopNextData:

    pop hl

    push bc
    ld b, d
    ld c, e
    add hl, bc
    pop bc

    djnz CheckEnemyExistsLoop

CheckEnemyExistsEnemyNotFound:

    ; 生きているテキキャラが存在していない
    ld a, 0

    ret

;----------------------------------------------------
; SUB-ROUTINE:テキキャラのライフゲージに値を加算する
; WK_ENEMYLIFESUMに加算値をセットして呼び出すこと
; 加算値にはマイナス値も許可する
; 呼び出し時にDEレジスタには衝突判定テーブルの
; 乙（テキキャラ）のアドレスが格納されて呼び出される
;
; 使用してよい変数：WK_VALUE03 - WK_VALUE08
;----------------------------------------------------
AddEnemyLifeGuage:

    push bc 
    push de
    push hl
    
    xor a
    ld (WK_BUSTERD_ENEMY_TYPE), a

    ; ライフポイントの桁情報をすべてゼロにする
    ld hl, WK_ENEMYLIFEPOINT
    ld bc, 7
    ld  a, 0
    call MemFil
    
    ; ライフポイント値に加算値を加算する
    ld a, (WK_ENEMYLIFEVAL)
    ld b, a
    ld a, (WK_ENEMYLIFESUM)
    add a, b
    ld (WK_ENEMYLIFEVAL), a

    or a
    jp z, EnemyBusterd  ; ライフゲージが0であれば倒したと判定
    
    and 10000000B
    cp 128
    jp z, EnemyBusterd  ; ライフゲージがマイナスであれば倒したと判定

    ld a, (WK_ENEMYLIFEVAL)
    ld hl, WK_ENEMYLIFEPOINT

    ld b, a
    ld c, 7
    
AddEnemyLifeGuageLoop:

    ld a, b
    sub c    ; A = B - 7
    jp c, AddEnemyLifeGuageAddAmari
    jp z, AddEnemyLifeGuageAddAmari

    ld (hl), c
    inc hl
    
    ld b, a
    jp AddEnemyLifeGuageLoop   
    
AddEnemyLifeGuageAddAmari:
    
    ld a, b
    cp 1
    jp c, EnemyBusterd ; Bの値が7未満であればゼロにする

    ld (hl), a ;

    jp AddEnemyLifeGuageEnd

EnemyBusterd:

    ; 敵の体力をゼロにする
    xor a
    ld (WK_ENEMYLIFEVAL), a

    ; テキキャラステータス表示欄を初期化
    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32
    ld bc, 11
    ld a, $20
    call MemFil

    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32 + 32
    ld bc, 11
    ld a, $20
    call MemFil

    ; 倒したメッセージを表示
    ld de, WK_VIRT_PTNNAMETBL + 20 + 32
    ld hl, MESSAGE_DEFEATED
    ld bc, 10
    call MemCpy 

    ; テキキャラの種別を取得する
    ld hl, (WK_DEREGBACK)
    ld e, (hl)
    inc hl
    ld d, (hl)

    ld hl, de
    ld a, (hl) ; 種別コード
    ld (WK_VALUE03), a
    ld b, 0
    ld c, $0E
    add hl, bc
    ld a, (hl) ; テキキャラのレベル
    ld (WK_VALUE04), a

    ; ミッションステータスのカウントアップ
    call BattleAddMissionStatus
    ; ミッションステータスバーの表示
    call BattleDispMissionStatus

AddEnemyLifeGuageEnd:

    ; テキキャラのライフゲージ処理が終わったら
    ; 常に再描画する
    ld a, 1
    ld (WK_REDRAW_FINE), a

    pop hl
    pop de
    pop bc

    ret
