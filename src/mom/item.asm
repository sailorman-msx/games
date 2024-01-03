;--------------------------------------------------
; itemuse.asm
; アイテム使用処理
; WK_USED_ITEMの値をチェックし、値が1で
; なければアイテムの効果を付け足す
; 値が2の場合：
;   道具アイテムであれば道具を捨てる
;   攻撃・防御・装飾品アイテムであれば装備を外す
;--------------------------------------------------  
CheckUsedItem:

    ; アイテム選択ダイアログモードでなければ
    ; 何もしない
    ld a, (WK_DIALOG_TYPE)
    cp 1
    jp nz, CheckUsedItemEnd

    ld a, (WK_SELECT_BOX_CHOICE_SLOTNUM)
    ld b, 0
    ld c, a

    ld a, (WK_SELECT_BOX_CHOICE_TYPE)
    ld (WK_VALUE08), a

    or a ; 攻撃アイテム？
    jp z, CheckUsedItemSTR
    cp 1 ; 防御アイテム？
    jp z, CheckUsedItemDEF
    cp 2 ; 装飾品アイテム？
    jp z, CheckUsedItemRING

    jp CheckUsedItemTOOL

CheckUsedItemSTR:

    ; アイテムスロットの内容を
    ; 装備中アイテム変数にセットする
    ld hl, WK_STRITEMSLOT
    ld de, WK_EQUIP_STR
    jp CheckUsedItemEQUIP

CheckUsedItemDEF:

    ld hl, WK_DEFITEMSLOT
    ld de, WK_EQUIP_DEF
    jp CheckUsedItemEQUIP

CheckUsedItemRING:

    ld hl, WK_RINGITEMSLOT
    ld de, WK_EQUIP_RING

CheckUsedItemEQUIP:

    ; アイテムスロットの内容を取得する
    add hl, bc
    ld a, (hl)
    ld b, a

    ; いったん装備を解除する
    xor a
    ld (de), a

    ld a, (WK_USED_ITEM)
    cp 1
    jp nz, CheckUsedItemEQUIP_END

    ; 装備する
    ld a, b
    ld (de), a

CheckUsedItemEQUIP_END:

    ; 防具アイテム装備時はプレイヤー本体の
    ; DEF値に防具のDEF値をセットする

    push bc
    ld hl, EQUIP_DATA_DEF
    ld b, 0
    ld a, (WK_EQUIP_DEF)
    add a, a ; x2
    ld c, a
    add hl, bc
    pop bc

    inc hl ; DEF値
    ld a, (hl)
    ld hl, WK_SPRITE_MOVETBL + 25 ; 1枚目の防御力
    ld (hl), a ; 防御力にDEF値をセット
    
    ; 所持アイテムスプライトの情報更新
    ; WK_EQUIP_STRを2倍してEQUIP_DATA_ADRに加算すると
    ; アイテムデータのアドレスが取得できる

    push bc
    ld hl, EQUIP_DATA_STR
    ld b, 0
    ld a, (WK_EQUIP_STR)
    add a, a ; x2
    ld c, a
    add hl, bc
    pop bc

    ld a, (WK_PLAYERPOSX)
    ld (WK_VALUE01), a
    ld a, (WK_PLAYERPOSY)
    ld (WK_VALUE02), a

    ld a, (hl)  ; 剣のカラーコード
    ld (WK_VALUE03), a
    inc hl
    ld a, (hl)  ; STR値
    ld (WK_VALUE04), a

    ld a, (WK_PLAYERDIST)
    ld b, a

    ld a, (WK_PLAYERDISTOLD)
    ld (WK_PLAYERDIST), a

    call ItemPlayerEquipment

    ld a, b
    ld (WK_PLAYERDIST), a

    jp CheckUsedItemItemUseEnd

CheckUsedItemTOOL:

    ; アイテムスロットの内容を
    ; 各種ステータスに反映する
    ld hl, WK_TOOLITEMSLOT

    add hl, bc

    ; アイテムスロットのアドレスを退避する
    ld (WK_HLREGBACK), hl

    ; アイテムを使用してた場合はアイテムの効果を付け足す
    ; アイテムを捨てた場合は、スロットからアイテムをなくす
    ld a, (WK_USED_ITEM)
    or a
    jr z, CheckUsedItemItemUseEnd

    ; アイテムスロットの値を取得
    ld a, (hl)

    cp 1  ; ハート+7
    jr z, CheckUsedItemTOOL_Heart1
    cp 2  ; ハート全回復
    jr z, CheckUsedItemTOOL_HeartFull
    cp 4  ; 黄色鍵
    jr z, CheckUsedItemTOOL_YellowKey
    cp 5  ; 青色鍵
    jr z, CheckUsedItemTOOL_BlueKey
    cp 7  ; ロウソク
    jr z, CheckUsedItemTOOL_Torch

    jr CheckUsedItemItemUseEnd

CheckUsedItemTOOL_Heart1:
    
    ; ハート＋7を処理する
    ld a, 7
    ld (WK_PLAYERLIFESUM), a
    call AddLifeGuage
    call BattleDispLifeGuage
    
    jr CheckUsedItemItemUseEnd

CheckUsedItemTOOL_HeartFull:

    ; ハート全回復
    ld a, (WK_PLAYERLIFEMAX)
    ld (WK_PLAYERLIFEVAL), a
    xor a
    ld (WK_PLAYERLIFESUM), a

    call AddLifeGuage
    call BattleDispLifeGuage
    
    jr CheckUsedItemItemUseEnd

CheckUsedItemTOOL_YellowKey:

    ; 黄色鍵
    ld a, 17
    ld (WK_VALUE05), a
    call OpenDoor

    jr CheckUsedItemItemUseEnd

CheckUsedItemTOOL_BlueKey:

    ; 青色鍵
    ld a, 18
    ld (WK_VALUE05), a
    call OpenDoor

    jr CheckUsedItemItemUseEnd

CheckUsedItemTOOL_Torch:

    ; ロウソクを灯す
    call TorchInit

CheckUsedItemItemUseEnd:

    xor a
    ld (WK_USED_ITEM), a

    ; 消費アイテムであれば
    ; アイテムスロットの値を0x00にする
    ld a, (WK_VALUE08)
    cp 3
    jp nz, CheckUsedItemEnd
   
    ld hl, (WK_HLREGBACK)
    xor a
    ld (hl), a

    ; アイテムスロットを並び替える
    call SortSlotToolItems

CheckUsedItemEnd:

    ret

;--------------------------------------------  
; 剣を装備（または装備解除）した場合
; WK_SPRITE_MOVETBLに情報をセットする
; WK_VALUE01: プレイヤーのX座標
; WK_VALUE02: プレイヤーのY座標
; WK_VALUE04: アイテムのSTR値
;--------------------------------------------  
ItemPlayerEquipment:

    push bc
    push de
    push hl

    ; 所持アイテムスプライトの情報更新

    ; 剣を振っていれば剣（攻撃時）のスプライトを表示する
    ld a, (WK_SWORDACTION_COUNT)
    or a
    jp z, ItemPlayerEquipmentNoSwordAction

    ld hl, SWORDATTACKDISTPTN_NOP

    jp ItemPlayerEquipmentSetSprite

ItemPlayerEquipmentNoSwordAction:

    ; 剣を振っていないときのスプライト
    ld hl, SWORDDISTPTN_NOP

ItemPlayerEquipmentSetSprite:

    ld  a, (WK_PLAYERDISTOLD)

    ; PLAYERDISTOLDが0の場合は何もしない
    or a
    jp z, ItemPlayerEquipmentEnd

    ld d, 0
    ld e, a
    add hl, de ; HL = HL + WK_PLAYERDISTOLD
    ld a, (hl) ; 所持アイテムのパターン番号を取得
    ld d, a    ; Dレジスタに所持アイテムのパターン番号をセット

    ; HLレジスタにWK_SPRITE_MOVETBLのアドレスをセット
    ld hl, WK_SPRITE_MOVETBL

    ;-------------------------------------------------
    ; 所持アイテム（剣 or アムレット）のスプライト情報
    ;-------------------------------------------------
    ld a, $FE
    ld (hl), a  ; + 0
    inc hl

    ld  a, (WK_EQUIP_STR)
    or a
    jp  nz, ItemPlayerEquipmentSetY

    ; 攻撃アイテムを所持していない場合は
    ; 剣は非表示とする
    ld a, 209
    ld (WK_VALUE02), a
    ld (hl), a  ; + 1
    jp ItemPlayerEquipmentSetX

ItemPlayerEquipmentSetY:

    ; 剣を振ってる状態であれば
    ; 少しずらした位置に剣を表示する
    ; プレイヤーが上向き：
    ;   16ドット上方向に表示
    ; プレイヤーが下向き：
    ;   16ドット下方向に表示

    ld b, 0  ; Y座標補正値
    ld c, 0  ; X座標補正値

    ld  a, (WK_SWORDACTION_COUNT)
    or a
    jp z, ItemPlayerEquipmentSetYSetPos

    ld  a, (WK_PLAYERDISTOLD)
    cp 1
    jp z, ItemPlayerEquipmentSetYActionUp
    cp 5
    jp z, ItemPlayerEquipmentSetYActionDown
    cp 3
    jp z, ItemPlayerEquipmentSetXActionRight
    jp ItemPlayerEquipmentSetXActionLeft
    
ItemPlayerEquipmentSetYActionUp:

    ; 上向きの場合は16ドット上に表示
    ld b, $F1  ; -16

    jp ItemPlayerEquipmentSetYSetPos

ItemPlayerEquipmentSetYActionDown:

    ; 下向きの場合は16ドット下に表示
    ld b, 16   ; +16

    jp ItemPlayerEquipmentSetYSetPos

ItemPlayerEquipmentSetXActionRight:

    ; 右向きの場合は16ドット右に表示
    ld c, 16   ; +16

    jp ItemPlayerEquipmentSetYSetPos

ItemPlayerEquipmentSetXActionLeft:

    ; 左向きの場合は16ドット左に表示
    ld c, $F0  ; -16

ItemPlayerEquipmentSetYSetPos:

    ld a, (WK_VALUE02)
    add a, b
    ld (WK_VALUE02), a

ItemPlayerEquipmentSetX:

    ld a, (WK_VALUE02)
    ld (hl), a  ; +1 Y座標

    ld a, (WK_VALUE01)
    add a, c
    ld (WK_VALUE01), a

    inc hl
    ld  a, (hl) ; SPRITE#1 X座標
    ld a, (WK_VALUE01)
    ld (hl), a  ; + 2

    inc hl
    ld (hl), d  ; + 3 パターン番号

    inc hl      ;
    ld a, (WK_PLAYERSPRCLR3)
    ld (hl), a  ; + 4 カラー

    push hl
    ; プレイヤー本体の攻撃力と防御力を
    ; 取得する
    ld hl, WK_SPRITE_MOVETBL + 24
    ld a, (WK_VALUE04)
    ld b, a
    ld a, (hl)
    add a, b    ; 本体の攻撃力 + 補正値
    ld b, a
    inc hl
    ld a, (hl) 
    ld c, a     ; 本体の防御力
    pop hl
    
    ; 攻撃力と防御力をセットする
    inc hl ; +5
    inc hl ; +6
    inc hl ; +7

    inc hl
    ld a, b
    ld (hl), a  ; +8 攻撃力

    inc hl
    ld a, c
    ld (hl), a  ; +9 防御力
    
ItemPlayerEquipmentEnd:

    pop hl
    pop de
    pop bc

    ret

;--------------------------------------------  
; 消費アイテムスロットをソートしなおす
; HLレジスタ：アイテムスロットのアドレス
; ※消費アイテムスロット数は20で固定
;--------------------------------------------  
SortSlotToolItems:

    push bc
    push de
    push hl

    ; ソート用ワークエリアを初期化する
    ld hl, WK_SLOT_SORTBUF
    ld bc, 20
    ld a, 0
    call MemFil

    ; ソート処理
    ld hl, WK_TOOLITEMSLOT
    ld de, WK_SLOT_SORTBUF

    call SortValues

    ; アイテムスロットを初期化する
    ld hl, WK_TOOLITEMSLOT
    ld bc, 20
    ld a, 0
    call MemFil

    ; 並び替えた結果をアイテムスロットに転送する
    ld hl, WK_SLOT_SORTBUF
    ld de, WK_TOOLITEMSLOT

    ld b, 20

SortSlotToolItemsLoop:

    ld a, (hl)
    or a
    jp z, SortSlotToolItemsNext

    ; 0x00でなければアイテムスロットに転送する
    ld (de), a
    inc de

SortSlotToolItemsNext:

    inc hl

    djnz SortSlotToolItemsLoop

    pop hl
    pop de
    pop bc

    ret

;--------------------------------------------  
; SUB-ROUTINE:DropItem
; アイテムドロップ処理
;
; WK_HLREGBACK: テキキャラのアドレス
;--------------------------------------------  
DropItem:

    push af
    push bc
    push de
    push hl

    ; 宝箱を配置する
    ; 乱数を発生し、テキキャラのドロップ率未満で
    ; あれば宝箱をスプライトと同じ場所に配置する

    ; すでに宝箱が配置されていたらスキップする
    ld a, (WK_TREASUREBOX_ITEM)
    or a
    jp nz, DropItemEnd

    ; マップ種別がPITの場合
    ; テキキャラが0匹になれば宝箱を出現させる
    ld a, (WK_MAPTYPE)
    cp 9
    jp nz, DropItemNoPIT

    ; PITでなおかつテキキャラが存在する場合は
    ; 何もせず終了する
    call CheckEnemyExists
    or a
    jp nz, DropItemEnd

DropItemPIT:

    ; PITであればテキキャラが0匹になったら
    ; 強制的に宝箱をドロップする
    
    ; ラスボスのPITであればゲームクリア画面に遷移する
    ld a, (WK_MAPPOSX)
    ld b, a
    ld a, (WK_MAPPOSY)
    ld c, a
    ld hl, $0301
    or a
    sbc hl, bc
    jr nz, DropItemPITNormal

    ; MAP_VIEW_AREAをスペースで埋める
    ld hl, WK_MAP_VIEWAREA
    ld bc, 600
    ld a, $2B
    call MemFil

    ld hl, WK_MAP_VIEWAREA_DISP
    ld bc, 600
    ld a, $2B
    call MemFil

    ld a, 1
    ld (WK_GAMECLEAR), a

    ld a, 5
    ld (WK_GAMESTATUS), a
    ld a, 60
    ld (WK_GAMESTATUS_INTTIME), a

    ld hl, MOMBGMLETSGOADVENTURE_START
    ld a, 2
    call COMMON_AKG_INIT

    jp DropItemEnd
     
DropItemPITNormal:

    ; MAP座標によってアイテムを特定する

    ; MAP座標 X=0, Y=2のPITでなおかつ
    ; すでにDIAMOND SWORDを取得していたら
    ; MAGE SLAYERをドロップする
    ld a, $13
    call CheckEquipItems
    ; DIAMOND SLAYERを持っているか？
    or a
    jr z, DropItemPITNot0002

    ; MAP座標は X=0, Y=2 か？
    ld a, (WK_MAPPOSX)
    ld b, a
    ld a, (WK_MAPPOSY)
    ld c, a

    ld hl, $0002
    or a
    sbc hl, bc
    jr z, DropItemPITMageSlayer 

DropItemPITNot0002:

    ld hl, PIT_ITEMS

DropItemPITLoop:

    ; 座標データを読み込み、MAP座標と一致していたら
    ; その値をセットする
    ld e, (hl)
    inc hl
    ld d, (hl)

    ld a, $FF
    cp d
    jr z, DropItemPITLoopNotFoundEnd ; EODを検知

    push hl
    or a ; ZERO TO CY
    ld hl, de
    sbc hl, bc
    pop hl

    jr z, DropItemPItLoopFoundEnd ; アイテム値を検知

    inc hl
    inc hl

    jr DropItemPITLoop

DropItemPITLoopNotFoundEnd:

    ; アイテム値がセットされていない場合は
    ; JUNKをアイテムとする
    ld a, $89
    jp DropItemSetItem

DropItemPITMageSlayer:

    ld a, $14
    call CheckEquipItems
    or a
    jr nz, DropItemPITLoopNotFoundEnd

    ld a, $14
    jr DropItemSetItem

DropItemPItLoopFoundEnd:

    ; アイテム値をセットする
    ; すでに所持している場合は何もしない
    inc hl
    ld a, (hl)

    call CheckEquipItems
    or a
    ; すでに保持しているアイテムであればJUNKをアイテムとする
    jr nz, DropItemPITLoopNotFoundEnd

    ld a, (hl)

    jr DropItemSetItem
    
DropItemNoPIT:

    ld hl, (WK_HLREGBACK)
    push hl
    ld b, 0
    ld c, $0D ; アイテムドロップ確率
    add hl, bc
    ld a, (hl)
    ld d, a ; アイテムドロップ確率をDレジスタにセット
    inc hl
    ld a, (hl)
    ld e, a ; テキキャラのレベルをEレジスタにセット
    pop hl

    call RandomValue
    ld b, a  ; 乱数値をBレジスタにセット
    cp d     ; 乱数 - アイテムドロップ率 >= 0 ?

    ; 乱数 - アイテムドロップ率がプラスであればドロップしない
    jp pe, DropItemEnd

    ; テキキャラの種別ごとに
    ; ドロップアイテムを変更する
    ld a, (WK_BUSTERD_ENEMY_TYPE)
    cp 1
    jr z, DropItemSlime

    ; WISPはアイテムをドロップしないようにする
    cp 2
    jr z, DropItemEnd

    cp 3
    jr z, DropItemWizard

    cp 4
    jr z, DropItemWizard ; WOODYはWizardと同じDropを行う

    cp 5
    jr z, DropItemSkelton

DropItemSlime:
    
    ; スライムは128/256(50%)の確率で
    ; アイテムをドロップする
    ; 128-137までの数: Full Recover
    ; 138-178までの数: JUNK
    ; 奇数       : HEART+1
    ; 偶数       : TORCH

    ld a, b

    cp 138
    jr c, DropItemFullRecover

    cp 178
    ld hl, PIT_ITEMS
    jr c, DropItemJunk

    and 00000001B
    jr nz, DropItemSetTorch

    jr DropItemSetHeart
    
DropItemWizard:

    ; ウイザードは128/256(50%)の確率で
    ; アイテムをドロップする
    ; 128-200までの数: YELLOW KEY
    ; それ以外はHEART+1で固定

    ld a, b

    cp 201
    jr c, DropItemYellowKey

    jr DropItemSetHeart

DropItemSkelton:

    ; スケルトンは128/256(50%)の確率で
    ; アイテムをドロップする
    ; 128-149までの数: BLUE KEY
    ; それ以外はHEART+1で固定

    ld a, b

    cp 150
    jr c, DropItemBlueKey

    jr DropItemSetHeart

DropItemSetHeart:

    ld a, $81 ; ハート+7
    jr DropItemSetItem

DropItemSetTorch:

    ld a, $87 ; ロウソク
    jr DropItemSetItem

DropItemFullRecover:

    ld a, $82 ; ハート全回復
    jr DropItemSetItem

DropItemYellowKey:

    ; レベル1のテキキャラはYELLOW KEYはDropしない
    ; かわりにFULL RECOVERをドロップする
    ld a, e
    cp 1
    jr z, DropItemFullRecover

DropItemYellowKeyForce:

    ld a, $84 ; YELLOW KEY
    jr DropItemSetItem

DropItemBlueKey:

    ; レベル1のテキキャラはBLUE KEYはDropしない
    ; かわりにYELLOW KEYをドロップする
    ld a, e
    cp 1
    jr z, DropItemYellowKeyForce

    ; レベル3のテキキャラはBLUE KEYはDropしない
    ; かわりにFULL Recoverをドロップする
    cp 3
    jr z, DropItemFullRecover

    ld a, $85 ; BLUE KEY
    jr DropItemSetItem

DropItemJunk:

    ld a, $89 ; JUNK

DropItemSetItem:

    ld b, a
    
    ld hl, (WK_HLREGBACK)
    inc hl
    ld a, (hl) ; Y座標
    call DivideBy8
    ld a, d
    ld (WK_TREASUREBOX_Y), a

    ld hl, (WK_HLREGBACK)
    inc hl
    inc hl
    ld a, (hl) ; X座標
    call DivideBy8
    ld a, d
    ld (WK_TREASUREBOX_X), a

    ld a, b
    ld (WK_TREASUREBOX_ITEM), a

    ; WK_BOX_PICKUP
    ; $00 : 配置済
    ; $01 : 拾った
    xor a
    ld (WK_BOX_PICKUP), a

    call DispTreasureBox
    call DisplayViewPort

    ld a, 1
    ld (WK_REDRAW_FINE), a

DropItemEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;------------------------------------------------------
; 宝箱のキャラクタをWK_MAP_VIEWAREAに
; 配置する
;------------------------------------------------------
DispTreasureBox:

    push af
    push bc
    push de
    push hl

    ; PITであればレアアイテムの宝箱を表示する
    ld a, (WK_MAPTYPE)
    cp 9
    jr nz, DispTreasureBoxNormalItem

DispTreasureBoxRareItem:

    ld de, DROP_ITEM_TILES_RARE
    jr DispTreasureBoxSetTile

DispTreasureBoxNormalItem:

    ld de, DROP_ITEM_TILES

DispTreasureBoxSetTile:

    ; MAP_VIEWAREAのY座標に変換する

    ; 左上座標を決める
    ld a, (WK_TREASUREBOX_Y)
    sub 3    ; Y = Y - 3 (Y座標の3はMAP_VIEWAREAの0）

    push de

    ld h, a
    ld e, 30

    call CalcMulti

    pop de

    ld a, (WK_TREASUREBOX_X)
    dec a ; X座標の1はMAP_VIEWAREAの0）
    ld b, 0
    ld c, a
    add hl, bc

    ld bc, WK_MAP_VIEWAREA
    add hl, bc

    ld a, 29
    ld (WK_VALUE01), a

    ; HL=MAP_VIEWAREAでのアドレス
    ; DE=宝箱のタイルアドレス

    ld a, (hl)
    ld (WK_TREASUREBOX_GROUND_LU), a ; 左上のキャラクタを退避

    ld a, (de)
    ld (hl), a ; 左上

    inc hl
    inc de
    inc de

    ld a, (hl)
    ld (WK_TREASUREBOX_GROUND_RU), a ; 右上のキャラクタを退避

    ld a, (de)
    ld (hl), a ; 右上

    dec de

    ld a, (WK_VALUE01)
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (hl)
    ld (WK_TREASUREBOX_GROUND_LD), a ; 左下のキャラクタを退避

    ld a, (de)
    ld (hl), a ; 左下

    inc hl
    inc de
    inc de
    
    ld a, (hl)
    ld (WK_TREASUREBOX_GROUND_RD), a ; 右下のキャラクタを退避

    ld a, (de)
    ld (hl), a ; 右下

    ; WK_MAP_VIEWAREAの内容をバックアップする
    ld hl, WK_MAP_VIEWAREA
    ld de, WK_MAP_VIEWAREA_DISP
    ld bc, 600
    call MemCpy

    pop hl
    pop de
    pop bc
    pop af

    ret

;------------------------------------------------------
; 宝箱のキャラクタをWK_MAP_VIEWAREAから
; 消す
;------------------------------------------------------
DispTreasureBoxRemove:

    push bc
    push de
    push hl

    ; MAP_VIEWAREAのY座標に変換する

    ; 左上座標を決める
    ld a, (WK_TREASUREBOX_Y)
    sub 3    ; Y = Y - 3 (Y座標の3はMAP_VIEWAREAの0）

    push de

    ld h, a
    ld e, 30

    call CalcMulti

    pop de

    ld a, (WK_TREASUREBOX_X)
    dec a ; X座標の1はMAP_VIEWAREAの0）
    ld c, a
    add hl, bc

    ld bc, WK_MAP_VIEWAREA
    add hl, bc

    ld a, 29
    ld (WK_VALUE01), a

    ld a, (WK_TREASUREBOX_GROUND_LU)
    ld (hl), a ; 左上

    inc hl

    ld a, (WK_TREASUREBOX_GROUND_RU)
    ld (hl), a ; 右上

    ld a, (WK_VALUE01)
    ld b, 0
    ld c, a
    add hl, bc

    ld a, (WK_TREASUREBOX_GROUND_LD)
    ld (hl), a ; 左下

    inc hl
    ld a, (WK_TREASUREBOX_GROUND_RD)
    ld (hl), a ; 右下

    ; WK_MAP_VIEWAREAの内容をバックアップする
    ld hl, WK_MAP_VIEWAREA
    ld de, WK_MAP_VIEWAREA_DISP
    ld bc, 600
    call MemCpy

    xor a
    ld (WK_BOX_PICKUP), a
    ld (WK_TREASUREBOX_X), a
    ld (WK_TREASUREBOX_Y), a

    pop hl
    pop de
    pop bc

    ret

CheckEquipItems:

    push bc
    push de
    push hl

    ld d, a
    and 00010000B
    jr nz, CheckEquipItemsSTR
    ld a, d
    and 00100000B
    jr nz, CheckEquipItemsDEF
    ld a, d
    and 01000000B
    jr nz, CheckEquipItemsRING
    
    jr CheckEquipItemsTOOL

CheckEquipItemsSTR:

    ld hl, WK_STRITEMSLOT
    ld b, 4
    jr CheckEquipItemsLoop

CheckEquipItemsDEF:

    ld hl, WK_DEFITEMSLOT
    ld b, 4
    jr CheckEquipItemsLoop

CheckEquipItemsRING:

    ld hl, WK_RINGITEMSLOT
    ld b, 4
    jr CheckEquipItemsLoop

CheckEquipItemsTOOL:

    ld hl, WK_TOOLITEMSLOT
    ld b, 18

CheckEquipItemsLoop:

    ld a, d
    and 00001111B  ; 上位4ビットを消す
    ld d, a

CheckEquipItemsLoop1:

    ld a, (hl)
    cp d
    jr z, CheckEquipItemHaved

    inc hl
    djnz CheckEquipItemsLoop1

CheckEquipItemNotHave:

    ld a, 0
    jr CheckEquipItemsEnd

CheckEquipItemHaved:

    ld a, 1

CheckEquipItemsEnd:

    pop hl
    pop de
    pop bc

    ret

