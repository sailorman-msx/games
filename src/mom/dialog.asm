;-----------------------------------------
; dialog.asm
; 汎用ダイアログ処理
; Xキー、もしくはBボタンが押されていたら
; ダイアログ表示モードに切り替える
; ダイアログ表示モードではゲーム進行は
; いったん停止し、ダイアログ表示モードに
; 切り替える。
; ダイアログを閉じたあとに通常モードに戻る
;-----------------------------------------
DialogProc:

    ;---------------------------------------------------
    ; 宝箱を拾ったら宝箱は消す
    ;---------------------------------------------------
    ld a, (WK_BOX_PICKUP)
    or a
    jr z, DialogProcSkipRemoveBox
    call DispTreasureBoxRemove

DialogProcSkipRemoveBox:

    ld a, 1
    ld (WK_DIALOG_INITEND), a

    ;----------------------------------------
    ; WK_GAMESTATUS_INTTIMEの値が0でなければ
    ; なにもしない
    ;----------------------------------------
    ld a, (WK_GAMESTATUS_INTTIME)
    or a
    jp z, DialogProcMain

    ;----------------------------------------
    ; ピープホール値がセットされている場合は
    ; ピープホール表示処理を行う
    ; ただしダイアログ表示中はインターバル内では
    ; 行わない
    ;----------------------------------------
    cp 3
    jp nz, DialogProcSkipViewPort

    ld a, (WK_PEEPHOLE)
    or a
    jp z, DialogProcSkipViewPort

    ; ビューポートに対してピープホール処理を施す
    ld a, (WK_PLAYERPOSX)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ld a, (WK_PLAYERPOSY)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    call PeepHoleProc

DialogProcSkipViewPort:

    ; 作成しなおした
    ; ビューポートを仮想パターンネームテーブルに転送する
    call DisplayViewPort

DialogProcSkipDisplayViewPort:

    ; WK_GAMESTATUS_INTTIMEが残り1/60秒であれば
    ; ダイアログの初期表示を行う
    ld a, (WK_GAMESTATUS_INTTIME)
    cp 1
    jp z, DialogProcInit
    
    jp DialogProcDecInterval

DialogProcMain:

    xor a
    ld (WK_DIALOG_INITEND), a

    ;----------------------------------------
    ; キー入力呼び出し
    ;----------------------------------------
    xor a
    ld (WK_PLAYERDIST), a

    ; ダイアログ操作線用のキー入力処理を呼び出す
    call KeyInputProc

    ; Xキー、またはBボタンが押されたらダイアログを閉じる
    ld a, (WK_TRIGGERB)
    cp $02
    jp z, DialogProcChangeDialogMode
    cp $12
    jp z, DialogProcChangeDialogMode

    ; Zキー、またはAボタン、スペースキーが押されていたら
    ; 選択ボックスを表示する
    ld a, (WK_TRIGGERA)
    cp $02
    jp z, DialogProcPushAorZ
    cp $12
    jp z, DialogProcPushAorZ

    jp DialogProcNormalMode

DialogProcPushAorZ:

    ; WK_TRIGGERA=2 でAボタンまたはスペースキーまたはZキーが押されたと判定する
    xor a
    ld (WK_TRIGGERA), a

    ; ダイアログ種別が情報表示モードであれば何もしない
    ld a, (WK_DIALOG_TYPE)
    cp 2
    jp z, DialogProcNormalMode
    ; ダイアログ種別が4以上であれば何もしない
    cp 4
    jp nc, DialogProcNormalMode

    ; ダイアログ種別がSHOPであれば処理を行う
    cp 3
    jp z, DialogProcShopBuy

    jr DialogProcChangeSelectBoxMode

DialogProcShopBuy:

    ; ショップにて
    ; Zキー、またはAボタン、スペースキーが押された

    ; 交換OK
    ; MAP座標にあわせたRINGを取得する
    ld a, (WK_MAPPOSX)
    ld c, a
    ld a, (WK_MAPPOSY)
    ld b, a

    ld hl, PIT_ITEMS

; 無限ループに注意せよ！！！
DialogProcShopLoop:
    
    ; 座標データを読み込み、MAP座標と一致していたら
    ; その値をセットする
    ld d, (hl)
    inc hl
    ld e, (hl) 
    
    push hl
    or a ; ZERO TO CY
    ld hl, de
    sbc hl, bc
    pop hl

    jr z, DialogProcShopLoopFoundEnd ; アイテム値を検知

    inc hl
    inc hl

    jr DialogProcShopLoop

DialogProcShopLoopFoundEnd:

    inc hl
    ld a, (hl)

    ; すでに保有しているRINGであれば何もしない
    ld hl, WK_RINGITEMSLOT
    ld b, 4
    ld c, a

DialogProcShopSoundSlotLoop:

    ld a, (hl)
    or a
    jr z, DialogProcShopSoundSlotLoopEnd
    cp c
    jr z, DialogProcShopSoundSlotLoopFounEnd

    inc hl

    djnz DialogProcShopSoundSlotLoop

    jp DialogProcShopSoundSlotLoopEnd

DialogProcShopSoundSlotLoopFounEnd:

    ld a, 6
    ld (WK_DIALOG_TYPE), a

    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a
 
    jp NextHTIMIHook
    
DialogProcShopSoundSlotLoopEnd:

    ; RINGとの交換処理を行う
    call CheckJunkNum
    cp 5
    jr c, DialogProcShopCannotBuy

    ; RINGアイテムスロットに追加する
    ld (hl), c

    ; JUNKを5個減らす
    call DialogProcRemove5Junk

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0F ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ld a, 5
    ld (WK_DIALOG_TYPE), a

    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a
 
    jp NextHTIMIHook

DialogProcShopCannotBuy:

    ; 交換不可
    ld a, 4
    ld (WK_DIALOG_TYPE), a

    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a
 
    jp NextHTIMIHook

DialogProcChangeSelectBoxMode:

    ; アイテム一覧にて
    ; Zキー、またはAボタン、スペースキーが押された

    ; アイテムスロットが空っぽであれば何もしない
    call DialogProcCheckSlotExist
    or a
    jp z, NextHTIMIHook

    ; 既に選択ボックス表示中であれば
    ; 変数に選択値をセットし、選択ボックスを閉じる
    ld a, (WK_SELECT_BOX)
    dec a
    jp z, DialogProcChangeSelectBoxModeCloseBox

    ; 選択ボックスを表示する

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0E ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ; アイテム選択画面での矢印アイコンの位置をバックアップする
    ld a, (WK_ITEMLISTPOS)
    ld (WK_ARROW_POS_BK1), a
    ld a, (WK_RIGHTARROWICON_POS)
    ld (WK_ARROW_POS_BK2), a

    ; 選択ボックスを作成する
    ; 現在表示されている状態に上書きする形で
    ; 表示する
    call DialogProcCreateSelectBoxPane

    ; 選択ボックス表示フラグをONにする
    ld a, 1
    ld (WK_SELECT_BOX), a

    ; 選択結果の初期化（初期値は0）
    xor a
    ld (WK_SELECT_BOX_CHOICE_TYPE), a
    ld (WK_SELECT_BOX_CHOICE_SLOTNUM), a
    ld (WK_USED_ITEM), a

    ; 右矢印アイコン位置の初期化
    xor a
    ld (WK_RIGHTARROWICON_POS), a

    ; アイテム一覧先頭行インデックスの初期化
    ld (WK_ITEMLISTPOS), a

    ; キーインインターバルを設定する
    ld a, 5
    ld (WK_KEYIN_INTERVAL), a

    jp NextHTIMIHook
    
; 選択ボックスでAボタンが押された時の処理
DialogProcChangeSelectBoxModeCloseBox:

    ; 選択結果をWK_SELECT_BOX_CHOICEにセットする
    ; RIGHTARROWICON_POSは変わるので
    ; バックアップしていた値を使う

    ld a, (WK_ARROW_POS_BK2) ; RIGHTARROWICON_POS
    ld b, a
    ld a, (WK_ARROW_POS_BK1) ; ITEMLISTPOS
    add a, b
    ld (WK_SELECT_BOX_CHOICE_SLOTNUM), a

    ld a, (WK_DOWNARROWICON_POS)
    ld (WK_SELECT_BOX_CHOICE_TYPE), a

    ; アイテム使用フラグをONにする
    ld a, (WK_RIGHTARROWICON_POS)
    or a
    jp nz, DialogProcChangeSelectBoxModeCloseBoxRemove

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0F ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ld a, 1

    jp DialogProcChangeSelectBoxModeCloseBoxSetFlg

DialogProcChangeSelectBoxModeCloseBoxRemove:

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ; アイテムを外した(捨てた)効果音を鳴らす
    ld a,$06 ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ld a, 0

DialogProcChangeSelectBoxModeCloseBoxSetFlg:

    ld (WK_USED_ITEM), a

    ;-----------------------------------------------
    ; アイテムの効果を付け足す
    ;-----------------------------------------------
    call CheckUsedItem

    ; 右矢印アイコン位置の初期化
    ld a, 0
    ld (WK_RIGHTARROWICON_POS), a

    ; アイテム一覧先頭行インデックスの初期化
    ld a, 0
    ld (WK_ITEMLISTPOS), a

DialogProcChangeSelectBoxModeCloseBoxUndo:

    ; 選択ボックスフラグの初期化
    xor a
    ld (WK_SELECT_BOX), a

    ld (WK_PLAYERDIST), a

    ;-----------------------------------------------
    ; 再表示を行う
    ;-----------------------------------------------
    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a
 
    jp NextHTIMIHook

DialogProcChangeDialogMode:

    ; WK_TRIGGERB=$02 or $12 でBボタンまたはXキーが押されたと判定する
    xor a
    ld (WK_TRIGGERB), a

    ; 選択ボックス表示中であれば
    ; アイテム使用フラグを2（破棄・装備解除)にして
    ; 選択ボックスのみ閉じる

    ; アイテム使用フラグを破棄・装備解除にする
    ld a, 2
    ld (WK_USED_ITEM), a

    ld a, (WK_SELECT_BOX)
    dec a
    jp z, DialogProcChangeDialogModeCloseSelectBox

    jp DialogProcChangeDialogModeEnd

DialogProcChangeDialogModeCloseSelectBox:

    ; バックアップしていた右矢印アイコンの位置を元に戻す
    ld a, (WK_ARROW_POS_BK1)
    ld (WK_ITEMLISTPOS), a
    ld a, (WK_ARROW_POS_BK2)
    ld (WK_RIGHTARROWICON_POS), a

    jp DialogProcChangeSelectBoxModeCloseBoxUndo

DialogProcChangeDialogModeEnd:

    ; ゲームクリアフラグが成立していたら何もしない
    ld a, (WK_GAMECLEAR)
    or a
    jp nz, DialogProcEnd

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0E ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ; 選択ボックス表示中でなければ
    ; ダイアログを閉じる
    call DialogProcCloseDialog

    ld (WK_PLAYERDIST), a

    jp DialogProcEnd

DialogProcNormalMode:

    ; ダイアログ種別がアイテム選択ダイアログであれば
    ; 各種アイテム情報を表示する
    ; ただし選択ボックス表示時は種別アイコンは表示しない
    ;
    ; 0=ダイアログ非表示 1=アイテム選択 2=情報表示 3-6=ショップ 7=情報表示
    ld a, (WK_DIALOG_TYPE)
    cp 2
    jp nc, DialogProcDecTime10

    call DialogProcCreateIcons

    ; カーソルキーの左右が押されていたら
    ; 下矢印カーソルを移動する

    ; カーソルキーの上下が押されていたら
    ; 右矢印カーソルを移動する

    ; 何も押されていなければ画面情報を作成して
    ; NextHTIMIHookに戻る
    ld a, (WK_PLAYERDIST)
    or a
    jp z, DialogProcDispCurrentIcons

    ; 矢印キーかトリガーが押されていたら
    ; 無条件に音を出す
    
    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0E ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ; 選択ボックス表示中であれば上下のみ
    ; 操作可能とする
    ld a, (WK_SELECT_BOX)
    dec a    ; AをデクリメントしてZフラグを確認する
    jp z, DialogProcNormalModeUp

; 下矢印アイコンの処理：右方向
DialogProcNormalModeRight:

    ld a, (WK_PLAYERDIST)
    cp 3
    jp nz, DialogProcNormalModeLeft

    ld a, (WK_DOWNARROWICON_POS)
    cp 3

    ; 道具アイコンの右に移動させる場合
    ; ポジションは0にする
    jp z, DialogProcNormalModeRightSetPosZero
    
    inc a
    ld (WK_DOWNARROWICON_POS), a

    jp DialogProcDispSetRightArrowPosZero

DialogProcNormalModeRightSetPosZero:

    xor a
    ld (WK_DOWNARROWICON_POS), a

    jp DialogProcDispSetRightArrowPosZero

; 下矢印アイコンの処理：左方向
DialogProcNormalModeLeft:

    ld a, (WK_PLAYERDIST)
    cp 7
    jp nz, DialogProcNormalModeUp

    ld a, (WK_DOWNARROWICON_POS)
    or a

    ; 攻撃アイコンの左に移動させる場合
    ; ポジションは3にする
    jp z, DialogProcNormalModeLeftSetPos3
    
    dec a
    ld (WK_DOWNARROWICON_POS), a

    jp DialogProcDispSetRightArrowPosZero

DialogProcNormalModeLeftSetPos3:

    ld a, 3
    ld (WK_DOWNARROWICON_POS), a

    jp DialogProcDispSetRightArrowPosZero

; 右矢印アイコンの処理：上方向
DialogProcNormalModeUp:

    ld a, (WK_PLAYERDIST)
    cp 1
    jp nz, DialogProcNormalModeDown

    ld a, (WK_RIGHTARROWICON_POS)
    or 0

    ; アイテム一覧の先頭行で上を押された場合は
    ; アイテム一覧の先頭行インデックスをデクリメントする
    ; 矢印の表示位置は変更しない
    jp z, DialogProcNormalModeUpDecIndex
    
    dec a
    ld (WK_RIGHTARROWICON_POS), a

    jp DialogProcDispCurrentIcons

DialogProcNormalModeUpDecIndex:

    ; 先頭行インデックスが0でなおかつWK_RIGHTARROWPOSが0の場合は何もしない
    ld a, (WK_RIGHTARROWICON_POS)
    ld b, a
    ld a, (WK_ITEMLISTPOS)
    sub b
    jp z, DialogProcDispCurrentIcons

    ; 先頭インデックスをデクリメントする
    ld a, (WK_ITEMLISTPOS)
    dec a
    ld (WK_ITEMLISTPOS), a

    jp DialogProcDispCurrentIcons

; 右矢印アイコンの処理：下方向
DialogProcNormalModeDown:

    ld a, (WK_PLAYERDIST)
    cp 5
    jp nz, DialogProcDispCurrentIcons

    ld a, (WK_SELECT_BOX)
    dec a
    jp z, DialogProcNormalModeDownSelectBox

    ; アイテム種別が道具以外であればアイテム一覧での
    ; 最下段は3とする
    ld a, (WK_DOWNARROWICON_POS)
    cp 3
    jp nc, DialogProcNormalModeDownIsTool

    ; アイテム一覧での最下段位置は3とする
    ld d, 3

    ; 先頭インデックスは常に0とする
    xor a
    ld (WK_ITEMLISTPOS), a

    jp DialogProcNormalModeDownPosChange

DialogProcNormalModeDownIsTool:

    ; アイテム一覧での最下段位置は8とする
    ld d, 8
    jp DialogProcNormalModeDownPosChange

DialogProcNormalModeDownSelectBox:

    ; 選択ボックスでの最下段位置は1とする
    ld a, (WK_RIGHTARROWICON_POS)
    cp 1
    ; POSが1であれば何もしない
    jp z, DialogProcDispCurrentIcons

    inc a
    ld (WK_RIGHTARROWICON_POS), a

    jp DialogProcDispCurrentIcons

DialogProcNormalModeDownPosChange:

    ; アイテム一覧の個数を超える場合には
    ; 移動させない
    ld a, (WK_RIGHTARROWICON_POS)
    ld c, a

    inc a
    ld b, a
    ld a, (WK_ITEMLISTPOS)
    add a, b
    ld b, a ; 現在の位置(1オリジン)
    call DialogProcCheckSlotExist
    cp b    ; 個数 - 位置
    jp c, DialogProcDispCurrentIcons
    jp z, DialogProcDispCurrentIcons

    ; アイテム一覧の最終行で下を押された場合は
    ; アイテム一覧の先頭行インデックスをインクリメントする
    ; 矢印の表示位置は変更しない
    ld a, c
    cp d

    jp z, DialogProcNormalModeDownIncIndex
   
    inc a
    ld (WK_RIGHTARROWICON_POS), a

    jp DialogProcDispCurrentIcons

DialogProcNormalModeDownIncIndex:

    ; 先頭行インデックスが9でなおかつWK_RIGHTARROW_POSが8の場合は何もしない
    ld a, (WK_RIGHTARROWICON_POS)
    ld b, a
    ld a, (WK_ITEMLISTPOS)
    add a, b
    cp 17
    jp z, DialogProcDispCurrentIcons

    ; 選択ボックスでなおかつWK_RIGHTARROWICON_POSが1の場合はPOSを0に戻す
    ld a, (WK_SELECT_BOX)
    dec a
    jp nz, DialogProcNormalModeDownIncIndexDoInc

    ld a, (WK_RIGHTARROWICON_POS)
    cp 1
    jp z, DialogProcDispSetRightArrowPosZero
    
DialogProcNormalModeDownIncIndexDoInc:

    ; 先頭インデックスをインクリメントする
    ld a, (WK_ITEMLISTPOS)
    inc a
    ld (WK_ITEMLISTPOS), a

    ; アイテム一覧の個数を超えてる箇所には
    ; 移動させない
    ld a, (WK_ITEMLISTPOS)
    add a, d
    inc a
    ld b, a ; 先頭インデックスをインクリメントしたあとの位置
    call DialogProcCheckSlotExist
    cp b
    jp c, DialogProcNormalModeDownIncIndexDoIncUndo

    jp DialogProcDispCurrentIcons

DialogProcNormalModeDownIncIndexDoIncUndo:

    ld a, (WK_ITEMLISTPOS)
    dec a
    ld (WK_ITEMLISTPOS), a

    jp DialogProcDispCurrentIcons

DialogProcDispSetRightArrowPosZero:

    ; 右矢印アイコンの位置を0(先頭行)にする
    xor a
    ld (WK_RIGHTARROWICON_POS), a
    
    ; アイテム一覧先頭インデックスの初期化
    ld (WK_ITEMLISTPOS), a

DialogProcDispCurrentIcons:

    ; アイテム一覧が道具以外であれば先頭行インデックスの
    ; 補正は行わない
    ld a, (WK_DOWNARROWICON_POS)
    cp 3
    jp c, DialogProcDispCurrentIconsSetIndexZero

    jr DialogProcDispCurrentIconsDispArrow

DialogProcDispCurrentIconsSetIndexZero:

    xor a
    ld (WK_ITEMLISTPOS), a

DialogProcDispCurrentIconsDispArrow:

    ; 選択ボックス表示時には右矢印アイコンのみ表示する
    ld a, (WK_SELECT_BOX)
    dec a
    jp z, DialogProcDispCurrentIconsEnd

    ; アイテム種別名を表示
    call DialogProcDispTypeName

    ; 選択されたアイコンにあわせて
    ; 一覧を表示する
    call DialogProcDispItemList

    ; 矢印アイコンを表示する
    call DialogProcDispDownArrowIcon
    call DialogProcDispRightArrowIcon

DialogProcDispCurrentIconsEnd:

    ; 選択ボックス表示中フラグが1であれば
    ; 選択ボックスを上書きする
    ld a, (WK_SELECT_BOX)
    cp 1
    jp nz, DialogProcDispCurrentIconsEndSkipSelectBox

    call DialogProcDispSelectBox

DialogProcDispCurrentIconsEndSkipSelectBox:

    call DialogProcRedrawOn

    jp DialogProcEnd

DialogProcDecTime10:

    ; 10/60秒タイマーをデクリメントする
    ; 0になったら画面を再描画する 
    ld a, (WK_TIME10) 
    or a
    call z, DialogProcRedrawOn
    
DialogPorcDecAndNextTIMIHook:

    dec a 
    ld (WK_TIME10), a

    jp NextHTIMIHook

DialogProcInit:

    ; WK_VIRT_PTNNAMETBLに上書きする形で
    ; ダイアログ表示域を作成する
    call DialogProcCreatePane

    ; アイテム一覧先頭行インデックスの初期化
    xor a
    ld (WK_ITEMLISTPOS), a

    ; 選択ボックスフラグの初期化
    ld (WK_SELECT_BOX), a

    ; アイテム使用フラグの初期化
    ld (WK_USED_ITEM), a

    jp DialogProcDecInterval

;-----------------------------------------
; SUB-ROUTINE: DialogProcDispSelectBox
; 選択ボックスを表示する
;-----------------------------------------
DialogProcDispSelectBox:

    ld a, (WK_RIGHTARROWICON_POS)
    or a
    jp nz, DialogProcDispSelectBoxArrow1

DialogProcDispSelectBoxArrow0:

    ; USE ITにカーソルを合わせる

    ld hl, WK_VIRT_PTNNAMETBL + 362
    ld a, $AF
    ld (hl), a

    ld hl, WK_VIRT_PTNNAMETBL + 394
    ld a, $20
    ld (hl), a

    jp DialogProcDispSelectBoxEnd

DialogProcDispSelectBoxArrow1:

    ; DISCARD/REMOVE にカーソルを合わせる

    ld hl, WK_VIRT_PTNNAMETBL + 362
    ld a, $20
    ld (hl), a

    ld hl, WK_VIRT_PTNNAMETBL + 394
    ld a, $AF
    ld (hl), a

DialogProcDispSelectBoxEnd:

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcDispTypeName
; ダイアログ表示域にアイテム種別を表示する
;-----------------------------------------
DialogProcDispTypeName:

    ld hl, WK_VIRT_PTNNAMETBL + 269
    ld bc, 10
    ld a, $20
    call MemFil

    ld hl, MESSAGE_DIALOG_SELECTOR

    ; 下矢印アイコン位置+1をHLレジスタに加算する
    ld a, (WK_DOWNARROWICON_POS)
    ld b, a
    call GetStringByIndex
    
    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 269
    ld b, 0
    ld c, a
    call MemCpy

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcDispItemList
; ダイアログ表示域にアイテム一覧を
; 表示する
;
; アイテム一覧は最大20個としているが
; 同時に表示できる最大行は10行となる
; アイテム一覧の0行目(WK_RIGHTARROWICON_POS=0)で
; 上を押したとき先頭行インデックスが0以外で
; あれば先頭行インデックスをデクリメントして
; 一覧を再表示する
; 一番下の行で下を押したとき
; 先頭行インデックスが10未満であれば
; 先頭行インデックスをインクリメントして
; 一覧を再表示する
;
;-----------------------------------------
DialogProcDispItemList:

    ; アイテム一覧部分を消去する
    ld de, WK_VIRT_PTNNAMETBL + 329
    ld (WK_DEREGBACK), de

    ld b, 9

    ; アイテム一覧の9行分をクリアする

DialogProcDispItemListLoop:

    push bc

    ld hl, MESSAGE_ITEMLIST_MESSAGEBLANK
    call GetString
    ld hl, WK_STRINGBUF
    ld de, (WK_DEREGBACK)
    ld b, 0
    ld c, a
    call MemCpy

    ld de, (WK_DEREGBACK)
    ld h, d
    ld l, e
    ld b, 0
    ld c, 32
    add hl, bc
    ld d, h
    ld e, l
    ld (WK_DEREGBACK), de

    pop bc

    djnz DialogProcDispItemListLoop

    ld a, (WK_DOWNARROWICON_POS)

    ; アイテム一覧を作成する

    ; 攻撃アイテムスロットか？
    or a
    jp z, DialogProcDispItemListSTR

    ; 防御アイテムスロットか？
    cp 1
    jp z, DialogProcDispItemListDEF
   
    ; 装飾品アイテムスロットか？
    cp 2
    jp z, DialogProcDispItemListRING

    ; 道具アイテムスロットと判定
    jp DialogProcDispItemListTOOL

DialogProcDispItemListSTR:

    ld a, (WK_EQUIP_STR)
    ld (WK_VALUE07), a

    ld b, 4
    ld hl, MESSAGE_ITEMLIST_MESSAGE01
    ld de, WK_STRITEMSLOT
    jp DialogProcDispItemListGenList

DialogProcDispItemListDEF:

    ld a, (WK_EQUIP_DEF)
    ld (WK_VALUE07), a
    ld b, 4
    ld hl, MESSAGE_ITEMLIST_MESSAGE02
    ld de, WK_DEFITEMSLOT
    jp DialogProcDispItemListGenList

DialogProcDispItemListRING:

    ld a, (WK_EQUIP_RING)
    ld (WK_VALUE07), a
    ld b, 4
    ld hl, MESSAGE_ITEMLIST_MESSAGE03
    ld de, WK_RINGITEMSLOT
    jp DialogProcDispItemListGenList

DialogProcDispItemListTOOL:

    ld a, $99             ; 装備中アイコンは道具の場合表示しない
    ld (WK_VALUE07), a

    ; 消費アイテムスロットをソートする
    call SortSlotToolItems

    ; 道具アイテムの最大表示行数は9
    ; WK_TOOLITEMSLOT + WK_ITEMLISTPOSを
    ; 開始位置とする

    ld hl, WK_TOOLITEMSLOT
    ld a, (WK_ITEMLISTPOS)
    ld b, 0
    ld c, a
    add hl, bc
    ld d, h
    ld e, l

    ld hl, MESSAGE_ITEMLIST_MESSAGE04
    ld b, 9

DialogProcDispItemListGenList:

    ld (WK_HLREGBACK), hl  ; メッセージの先頭アドレス
    ld (WK_DEREGBACK), de  ; アイテムスロットの先頭アドレス
    ld (WK_BCREGBACK), bc  ; ループ回数(Bレジスタ)

    ; Bレジスタの値だけループを繰り返す
    ; アイテムスロットの先頭の値が0x00であれば
    ; "NO ITEMS"を表示する
    
    ld a, (de)
    or a
    jp nz, DialogProcDispItemListLoop2

    ld hl, MESSAGE_ITEMLIST_MESSAGE00
    ld de, WK_VIRT_PTNNAMETBL + 329
    ld bc, 14
    call MemCpy

    jp DialogProcDispItemListEnd

DialogProcDispItemListLoop2:

    ld bc, (WK_BCREGBACK) ; ループ回数(Bレジスタ)を復帰
    ld de, (WK_DEREGBACK) ; アイテムスロットアドレスを復帰

    ld ix, WK_VIRT_PTNNAMETBL + 329
    ld iy, de

DialogProcDispItemListLoop3:
    
    ld hl, (WK_HLREGBACK) ; メッセージの先頭アドレス

    ; アイテムスロットの値をAレジスタにセット
    ld a, (iy + 0)

    ; 値が0であれば処理を終了する
    or a
    jp z, DialogProcDispItemListEnd

    push bc

    ; アイテムスロットの値が装備品と同じか？
    ld b, a
    ld a, (WK_VALUE07)
    cp b
    jr nz, DialogProcNoEquip

DialogProcEquip:

    ld a, $5C
    jr DialogProcPutItemName

DialogProcNoEquip:

    ld a, $20

DialogProcPutItemName:
     
    ld (WK_VALUE08), a

    ; アイテムスロットの値から1を引く
    ld a, b
    dec a

    ; アイテム名を取得する
    ld b, a
    call GetStringByIndex

    push af

    ld hl, ix  ; 転送先アドレス
    ld b, 0
    ld c, 14
    ld a, $20
    call MemFil
    
    ld hl, ix  ; 転送先アドレス
    ld d, h
    ld e, l

    ld a, (WK_VALUE08)
    ld (de), a
    inc de

    pop af

    ld hl, WK_STRINGBUF
    ld b, 0
    ld c, a
    call MemCpy

    ; IXレジスタを次の表示行先頭位置に位置付ける
    ld hl, ix
    ld b, 0
    ld c, 32
    add hl, bc

    ld ix, hl

    ; スロットをひとつ進める
    inc iy

    pop bc

    dec b
    jp nz, DialogProcDispItemListLoop3

DialogProcDispItemListEnd:

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcDispDownArrowIcon
; ダイアログ表示域に下矢印アイコンを
; 表示する
;-----------------------------------------
DialogProcDispDownArrowIcon:

    ld hl, WK_VIRT_PTNNAMETBL + 232
    ld bc, 4
    ld  a, $20
    call MemFil
    
    ld hl, WK_VIRT_PTNNAMETBL + 232
    ld a, (WK_DOWNARROWICON_POS)
    ld b, 0
    ld c, a
    add hl, bc

    ld a, $AE
    ld (hl), a

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcDispRightArrowIcon
; ダイアログ表示域に右矢印アイコンを
; 表示する
;-----------------------------------------
DialogProcDispRightArrowIcon:

    ld hl, WK_VIRT_PTNNAMETBL + 328
    
    ld b, 9

DialogProcDispRightArrowIconLoop1:

    push bc

    ld a, $20
    ld (hl), a

    ld b, 0
    ld c, 32
    add hl, bc

    pop bc

    djnz DialogProcDispRightArrowIconLoop1

    ; アイテムスロットが空っぽであれば何もせず
    ; 処理を終了する
    call DialogProcCheckSlotExist
    or a
    jp z, DialogProcDispDownArrowIconEnd

    ld hl, WK_VIRT_PTNNAMETBL + 328

    ld b, 0
    ld c, 32

    ld d, 0

DialogProcDispDownArrowIconLoop2:

    ld a, (WK_RIGHTARROWICON_POS)
    cp d
    jp z, DialogProcDispDownArrowIconLoopEnd
    
    add hl, bc

    inc d

    jp DialogProcDispDownArrowIconLoop2

DialogProcDispDownArrowIconLoopEnd:

    ld a, $AF  ; 右矢印アイコンを表示する
    ld (hl), a

DialogProcDispDownArrowIconEnd:

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcDispInformation
; ダイアログ表示域にメッセージを表示する
; WK_DISP_DIALOG_MESSAGE_ADR = メッセージのアドレス
; 
; メッセージは16文字ごとに下の行に
; 折り返す
;-----------------------------------------
DialogProcDispInformation:

    ld hl, (WK_DISP_DIALOG_MESSAGE_ADR)
    ld de, WK_VIRT_PTNNAMETBL + 232

    ld b, 0
    ld c, 6 ; 行番号

DialogProcDispInformationLoop:

    ld a, b
    cp 16
    call z, DialogProcDispInformationMaxCol
    
    ld a, (hl)

    ; 0x00は文字列の終端とみなす
    or a
    jr z, DialogProcDispInformationEnd

    ; \（バックスラッシュ）は改行コードとみなす
    cp $5C
    jr z, DialogProcDispInformationLineFeed

    ld (de), a
    inc de
    inc b
    
DialogProcDispInformationLoopNextData:

    inc hl

    jp DialogProcDispInformationLoop

DialogProcDispInformationLineFeed:

    ; DEレジスタに余白ぶんの文字数を加算する
    ld a, 16
    sub b

    or a
    add a, e
    ld e, a
    adc a, d
    sub e
    ld d, a

    ; 改行する
    call DialogProcDispInformationMaxCol

    jr DialogProcDispInformationLoopNextData

DialogProcDispInformationMaxCol:

    or a
    ld a, 16
    add a, e
    ld e, a
    adc a, d
    sub e
    ld d, a

    ld b, 0

    ret

DialogProcDispInformationEnd:
    
    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcCreateIcons
; ダイアログ表示域にアイテムアイコンを
; 並べる
;-----------------------------------------
DialogProcCreateIcons:

    ld a, (WK_SELECT_BOX)
    dec a
    jp z, DialogProcCreateIconsEnd

    ld hl, WK_VIRT_PTNNAMETBL + 264
    ld a, $AA
    ld (hl), a ; 攻撃アイコン
    inc hl
    ld a, $AB
    ld (hl), a ; 防御アイコン
    inc hl
    ld a, $AC
    ld (hl), a ; 装飾品アイコン
    inc hl
    ld a, $AD
    ld (hl), a ; 道具アイコン
    
DialogProcCreateIconsEnd:

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcCreateSelectBoxPane
; 選択ボックスを作成する
;-----------------------------------------
DialogProcCreateSelectBoxPane:

    ; 選択ボックス表示域を作成する
    ld hl, WK_VIRT_PTNNAMETBL + 232

    ld a, $A0 ; 左上端
    ld (hl), a
    inc hl
    
    ld b, 0
    ld c, 17
    ld a, $A1  ; 上横
    call MemFil

    ld a, $A2
    ld (hl), a ; 右上端

    ld d, 0

    ld b, 0
    ld c, 14
    add hl, bc

DialogProcCreateSelectBoxPaneLoop:

    ld a, $A7
    ld (hl), a ; 左縦
    inc hl

    ld b, 0
    ld c, 17
    ld a, $20  ; スペース
    call MemFil

    ld a, $A3
    ld (hl), a ; 右縦

    ld b, 0
    ld c, 14
    add hl, bc ; 次の行の先頭位置に位置付ける

    inc d
    ld a, 7
    cp d
    jp nz, DialogProcCreateSelectBoxPaneLoop

DialogProcCreateSelectBoxPaneLoopEnd:

    ld a, $A6
    ld (hl), a ; 左下端 
    inc hl
   
    ld b, 0 
    ld c, 17
    ld a, $A5  ; 下横 
    call MemFil

    ld a, $A4
    ld (hl), a ; 右下端 
   
DialogProcCreateSelectBoxPaneChoice:

    ; 初期メッセージを表示する
    ld hl, MESSAGE_DIALOG_TITLE_CHOICE
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 233
    ld b, 0
    ld c, a
    call MemCpy

    ; アイテム名称を表示する

    ld a, (WK_ARROW_POS_BK1) ; 先頭行インデックス
    ld c, a
    ld a, (WK_ARROW_POS_BK2) ; 右矢印アイコン位置
    add a, c
    ld c, a ; Cレジスタにアイテムスロットの位置が入る

    ld b, 0

    ld a, (WK_DOWNARROWICON_POS)

    or a ; 攻撃アイテム
    jp z, DialogProcCreateSelectBoxPaneChoiceSTR

    cp 1 ; 防御アイテム
    jp z, DialogProcCreateSelectBoxPaneChoiceDEF

    cp 2 ; 装飾アイテム
    jp z, DialogProcCreateSelectBoxPaneChoiceRING

    jp DialogProcCreateSelectBoxPaneChoiceTOOL

DialogProcCreateSelectBoxPaneChoiceSTR:

    ; 攻撃アイテム
    ld hl, WK_STRITEMSLOT
    add hl, bc
    ld a, (hl) ; アイテム番号
    dec a
    ld hl, MESSAGE_ITEMLIST_MESSAGE01
    jp DialogProcCreateSelectBoxPaneChoiceMSG

DialogProcCreateSelectBoxPaneChoiceDEF:

    ; 防御アイテム
    ld hl, WK_DEFITEMSLOT
    add hl, bc
    ld a, (hl) ; アイテム番号
    dec a
    ld hl, MESSAGE_ITEMLIST_MESSAGE02
    jp DialogProcCreateSelectBoxPaneChoiceMSG

DialogProcCreateSelectBoxPaneChoiceRING:

    ; 装飾アイテム
    ld hl, WK_RINGITEMSLOT
    add hl, bc
    ld a, (hl) ; アイテム番号
    dec a
    ld hl, MESSAGE_ITEMLIST_MESSAGE03
    jp DialogProcCreateSelectBoxPaneChoiceMSG

DialogProcCreateSelectBoxPaneChoiceTOOL:
    
    ; 道具アイテム
    ld hl, WK_TOOLITEMSLOT
    add hl, bc
    ld a, (hl) ; アイテム番号
    dec a
    ld hl, MESSAGE_ITEMLIST_MESSAGE04

DialogProcCreateSelectBoxPaneChoiceMSG:

    ld b, a
    call GetStringByIndex
    ld (WK_VALUE01), a ; 文字列長
    
    ld c, $AA
    ld hl, WK_VIRT_PTNNAMETBL + 298
    ld a, (WK_DOWNARROWICON_POS)
    add a, c
    ld (hl), a

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 299
    ld a, (WK_VALUE01)
    ld b, 0
    ld c, a
    call MemCpy

DialogProcCreateSelectBoxPaneChoiceChoice:

    ; 選択肢を表示する

    ld hl, MESSAGE_ITEMLIST_MESSAGE11
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 363
    ld b, 0
    ld c, a
    call MemCpy

    ; 道具かそれ以外かで文字列を変える
    ld a, (WK_DOWNARROWICON_POS)
    cp 3
    jp z, DialogProcCreateSelectBoxPaneChoiceChoiceTool

    ld hl, MESSAGE_ITEMLIST_MESSAGE12
    jp DialogProcCreateSelectBoxPaneChoiceChoiceSetBuf

DialogProcCreateSelectBoxPaneChoiceChoiceTool:

    ld hl, MESSAGE_ITEMLIST_MESSAGE13

DialogProcCreateSelectBoxPaneChoiceChoiceSetBuf:

    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 395
    ld b, 0
    ld c, a
    call MemCpy

    ret

;-----------------------------------------
; SUB-ROUTINE: DialogProcCreatePane
; ダイアログ表示域を作成する
;-----------------------------------------
DialogProcCreatePane:

    ; ダイアログ表示域を作成する
    ld hl, WK_VIRT_PTNNAMETBL + 167
   
    ld a, $A0  ; 左上端
    ld (hl), a
    inc hl

    ld b, 0
    ld c, 16
    ld a, $A1  ; 上横
    call MemFil

    ld a, $A2
    ld (hl), a ; 右上端

    ld d, 0

    ld b, 0
    ld c, 15
    add hl, bc

DialogProcCreatePaneLoop:

    ld a, $A7
    ld (hl), a ; 左縦
    inc hl

    ld b, 0
    ld c, 16
    ld a, $20  ; スペース
    call MemFil

    ld a, $A3
    ld (hl), a ; 右縦

    ld b, 0
    ld c, 15
    add hl, bc ; 次の行の先頭位置に位置付ける

    inc d
    ld a, 14
    cp d
    jp nz, DialogProcCreatePaneLoop
   
DialogProcCreatePaneLoopEnd:   

    ld a, $A6
    ld (hl), a ; 左下端
    inc hl
   
    ld b, 0
    ld c, 16
    ld a, $A5  ; 下横
    call MemFil

    ld a, $A4
    ld (hl), a ; 右下端
   
DialogProcCreatePaneDefalutMSG:

    ld a, (WK_DIALOG_TYPE)
    
    ; 情報メッセージ表示か？
    cp 2
    jp z, DialogProcCreatePaneMessageBox
    cp 7
    jp z, DialogProcCreatePaneMessageBox
    cp 8
    jp z, DialogProcCreatePaneMessageBox

    ; リング商店か？
    cp 3
    jp z, DialogProcCreatePaneShop
    cp 4 ; 購入不可メッセージ
    jp z, DialogProcCreatePaneShop
    cp 5 ; 購入済メッセージ
    jp z, DialogProcCreatePaneShop
    cp 6 ; 既に取得済み
    jp z, DialogProcCreatePaneShop

DialogProcCreatePaneItemSelect:

    ; ダイアログ種別は「アイテム選択」

    ; 初期メッセージを表示する
    ld hl, MESSAGE_DIALOG_TITLE_ITEMSELECT
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 168
    ld b, 0
    ld c, a
    call MemCpy

    ld hl, MESSAGE_DIALOG_BUTTONS_ITEMSELECT
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 171 + 32*15
    ld b, 0
    ld c, a
    call MemCpy

    jp DialogProcCreatePaneEnd

DialogProcCreatePaneMessageBox:

    ; ダイアログ種別は「メッセージ表示」

    ; 初期メッセージを表示する
    ; ダイアログ種別が8であれば「ゲームクリア」
    ld a, (WK_DIALOG_TYPE)
    cp 8
    jr nz, DialogProcCreatePaneMessageBoxNormalInfo

    ld hl, MESSAGE_DIALOG_TITLE_GAMECLEAR
    jr DialogProcCreatePaneMessageBoxGetMsg

DialogProcCreatePaneMessageBoxNormalInfo:

    ld hl, MESSAGE_DIALOG_TITLE_INFORMATION

DialogProcCreatePaneMessageBoxGetMsg:

    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 168
    ld b, 0
    ld c, a
    call MemCpy

    ; ダイアログ種別が8であれば「ゲームクリア」
    ld a, (WK_DIALOG_TYPE)
    cp 8
    jr z, DialogProcCreatePaneMessageBoxNoButton
    
    ld hl, MESSAGE_DIALOG_BUTTONS_INFORMATION
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 178 + 32*15
    ld b, 0
    ld c, a
    call MemCpy

DialogProcCreatePaneMessageBoxNoButton:

    ; メッセージを表示する
    ; メッセージを表示する場合はダイアログモードにする前に
    ; WK_DISP_DIALOG_MESSAGE_ADRにメッセージのアドレス
    ; WK_DISP_DIALOG_MESSAGE_LENにメッセージ長をセットすること

    call DialogProcDispInformation

    jp DialogProcCreatePaneEnd

DialogProcCreatePaneShop:

    ; ダイアログ種別は「SHOP」

    ; ダイアログタイトルを表示する
    ld hl, MESSAGE_DIALOG_TITLE_RINGSHOP
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 168
    ld b, 0
    ld c, a
    call MemCpy

    ; ダイアログ種別にあわせてメッセージを変更する
    ld a, (WK_DIALOG_TYPE)
    cp 3
    jr z, DialogProcCreatePaneShopMsgInitial

    jr DialogProcCreatePaneShopMsgCloseOnly

DialogProcCreatePaneShopMsgInitial:

    ld hl, MESSAGE_DIALOG_BUTTONS_RINGSHOP
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 177 + 32*15
    ld b, 0
    ld c, a
    call MemCpy

    ld a, ($002C)
    or a
    jr nz, DialogProcCreatePaneShopMsgEng1

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_SUFFICIENCY_JP
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgEng1:

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_SUFFICIENCY_EN
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgCloseOnly:

    ld hl, MESSAGE_DIALOG_BUTTONS_INFORMATION
    call GetString

    ld hl, WK_STRINGBUF
    ld de, WK_VIRT_PTNNAMETBL + 177 + 32*15
    ld b, 0
    ld c, a
    call MemCpy

    ld a, (WK_DIALOG_TYPE)
    cp 4
    jr z, DialogProcCreatePaneShopMsgCannotBuy
    cp 5
    jr z, DialogProcCreatePaneShopMsgBuy

    jr DialogProcCreatePaneShopMsgHaved

DialogProcCreatePaneShopMsgCannotBuy:

    ld a, ($002C)
    or a
    jr nz, DialogProcCreatePaneShopMsgEng2

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_CANNOTBUY_JP
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgEng2:

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_CANNOTBUY_EN
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgBuy:

    ld a, ($002C)
    or a
    jr nz, DialogProcCreatePaneShopMsgEng3

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_BUY_JP
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgEng3:

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_BUY_EN
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgHaved:

    ld a, ($002C)
    or a
    jr nz, DialogProcCreatePaneShopMsgEng4

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_HAVED_JP
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopMsgEng4:

    ld hl, MESSAGE_DIALOG_MESSAGE_JUNK_HAVED_EN
    jr DialogProcCreatePaneShopDispMsg

DialogProcCreatePaneShopDispMsg:

    ; メッセージを表示する
    ; メッセージを表示する場合はダイアログモードにする前に
    ; WK_DISP_DIALOG_MESSAGE_ADRにメッセージのアドレス
    ; WK_DISP_DIALOG_MESSAGE_LENにメッセージ長をセットすること

    ; メッセージを表示する
    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl
    call DialogProcDispInformation

DialogProcCreatePaneEnd:

    ; ゲームモードをダイアログモードに戻す
    ld a, 3
    ld (WK_GAMESTATUS), a

    xor a
    ld (WK_TIME10), a
 
    ret

DialogProcCloseDialog:

    ; 元の音を消す
    ld a,2
    call PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL
    
    ld a,$0E ; SOUND EFFECT NUMBER
    ld c,2 ; CHANNEL ( 0, 1, 2 )
    ld b,0 ; invertedVolume ;(0-16 (0=full volume))
    call PLY_AKG_PLAYSOUNDEFFECT

    ld a, (WK_PLAYERDISTOLD)
    ld (WK_PLAYERDIST), a

    ; ゲームモードを通常モードに戻す
    ld a, 2
    ld (WK_GAMESTATUS), a

    xor a
    ld (WK_TIME10), a

    ;
    call DisplayViewPort

    ld a, 1
    ld (WK_REDRAW_FINE), a

    ret

DialogProcDecInterval:

    ; インターバルタイマをデクリメントする
    ld a, (WK_GAMESTATUS_INTTIME)
    dec a
    ld (WK_GAMESTATUS_INTTIME), a

    call ClearSprite

DialogProcEnd:

    jp NextHTIMIHook

;----------------------------------------
; 選択したアイテムスロットにアイテム番号
; があるかチェックする
; Aレジスタにアイテム番号がセットされてる
; 個数がセットされて返却される
;----------------------------------------
DialogProcCheckSlotExist:
   
    push bc
    push de
    push hl

    ld a, (WK_DOWNARROWICON_POS)

    or a
    jp z, DialogProcCheckSlotExistIsSTR
    cp 1
    jp z, DialogProcCheckSlotExistIsDEF
    cp 2
    jp z, DialogProcCheckSlotExistIsRING
    
    ; 道具アイテム
    ld hl, WK_TOOLITEMSLOT

    jp DialogProcCheckSlotExistLoop

DialogProcCheckSlotExistIsSTR:

    ld hl, WK_STRITEMSLOT
    jp DialogProcCheckSlotExistLoop

DialogProcCheckSlotExistIsDEF:

    ld hl, WK_DEFITEMSLOT
    jp DialogProcCheckSlotExistLoop

DialogProcCheckSlotExistIsRING:

    ld hl, WK_RINGITEMSLOT

DialogProcCheckSlotExistLoop:

    ld b, 0

DialogProcCheckSlotExistLoop1:

    ld a, (hl)
    or a
    jp z, DialogProcCheckSlotExistEnd

    inc b
    inc hl

    jp DialogProcCheckSlotExistLoop1

DialogProcCheckSlotExistEnd:

    ; アイテム個数を返却する
    ld a, b

    pop hl
    pop de
    pop bc

    ret

;----------------------------------------
; 画面再描画処理
; アイテム選択時など画面表示の更新が必要な
; 場合は当処理をCALLすること
;----------------------------------------
DialogProcRedrawOn:

    ; ダイアログを表示する
    ld a, 1
    ld (WK_REDRAW_FINE), a

    ld a, 10
    ld (WK_TIME10), a

    ret

;----------------------------------------
; 保有するJUNKの数を取得する
;----------------------------------------
CheckJunkNum:

    push bc
    push hl

    ld c, 0
    ld hl, WK_TOOLITEMSLOT
    ld b, 18

CheckJunkNumLoop:

    ld a, (hl)
    cp 9
    jr nz, CheckJunkNumLoopNextData

    inc c

CheckJunkNumLoopNextData:
    
    inc hl
    djnz CheckJunkNumLoop

    ld a, c

    pop hl
    pop bc

    ret

;----------------------------------------
; 保有するJUNKを5個減らす
;----------------------------------------
DialogProcRemove5Junk:

    push hl

    ld hl, WK_TOOLITEMSLOT
    ld b, 18
    ld c, 0

DialogProcRemove5JunkLoop:

    ld a, (hl)
    cp 9
    jr nz, DialogProcRemove5JunkLoopNextData

    xor a
    ld (hl), a
    inc c

    ; 5個消したらループ終了
    ld a, 5
    cp c
    jr z, DialogProcRemove5JunkEnd

DialogProcRemove5JunkLoopNextData:

    inc hl
    djnz DialogProcRemove5JunkLoop

DialogProcRemove5JunkEnd:

    ; 道具のアイテムSLOTをソートする
    call SortSlotToolItems

    pop hl
    ret
