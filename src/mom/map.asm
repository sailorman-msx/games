;----------------------------------------------------
; map.asm
; マップ関連処理
;----------------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: CreateMapArea
; MAP_DATAWORLDのデータをもとに
; マップデータを作成する
;--------------------------------------------
CreateMapArea:

    push af
    push bc
    push de
    push hl

    ;--------------------------------------------------
    ; WK_MAPAREA(150バイト)を初期化する
    ;--------------------------------------------------
    ld hl, WK_MAPAREA
    ld bc, 150
    xor a
    call MemFil

    ;--------------------------------------------------
    ; MAPDATAのデータを読み込み
    ; 圧縮データを展開し、その内容をWK_MAPAREAにセットする
    ; その後、1バイトあたり2タイルずつに分解して画面に展開する
    ;--------------------------------------------------
    ld hl, WK_MAPCOMP
    ld (WK_MAPCOMP_ADDR), hl

    call ReadMapData

    ; PEEPHOLE型のマップであればPEEPHOLE径をセットする
    ; PEEPHOLE型のマップ種別:2,5,8
    ld a, (WK_MAPTYPE)
    cp 2
    jr z, CreateMapAreaSetPeepHole
    cp 5
    jr z, CreateMapAreaSetPeepHole
    cp 6
    jr z, CreateMapAreaSetPeepHole
    cp 8
    jr z, CreateMapAreaSetPeepHole

    jr CreateMapAreaNotPeepHole

CreateMapAreaSetPeepHole:

    ; すでにピープホール径がセットされていれば
    ; 何もしない
    ld a, (WK_PEEPHOLE)
    or a
    jp nz, CreateMapAreaNotPeepHole

    ; ピープホール径のデフォルトは1とする
    ld a, 1
    ld (WK_PEEPHOLE), a

CreateMapAreaNotPeepHole:

    ld hl, WK_MAPAREA
    ld (WK_MAPAREA_ADDR), hl

    ld hl, WK_MAPCOMP
    ;--------------------------------------------
    ; 縦は10行
    ;--------------------------------------------
    ld c, 10
    ;--------------------------------------------
    ; 横1列（8バイト分よみこむ)
    ;--------------------------------------------
CreateMapAreaLoop1:

    ld b, 8

CreateMapAreaLoop2:

    ld a, (hl) ; MAPのタイルデータ(4bit/1tile情報)を1バイト読み込む

    ; 読み込んだタイルデータを4ビットずつに分解してMAPAREAにセットする
    call GenTileData
    
    inc hl

    djnz CreateMapAreaLoop2 ; Bレジスタの値をデクリメントしてゼロでなければ繰り返す

    ; Cレジスタの値をデクリメントして0になるまでCreateMapAreaLoop1を繰り返す
    dec c
    jr z, CreateMapAreaEnd

    jr CreateMapAreaLoop1

CreateMapAreaEnd:

    ; キー入力インターバル値を初期化する
    ld a, 5
    ld (WK_KEYIN_INTERVAL), a

    pop hl
    pop de
    pop bc
    pop af

    ret

;-----------------------------------------------
; SUB-ROUTINE: CreateMapArea
; Aレジスタに格納されている情報を4bitずつに分解し
; MAPAREAに2バイト分格納する
;-----------------------------------------------
GenTileData:

    push af
    push bc
    push de
    push hl
    push ix

    ld c, a ; Aレジスタの値をCレジスタに退避

    ; ld ix, (WK_MAPAREA_ADDR)
    ld hl, (WK_MAPAREA_ADDR)

    ; Aレジスタの値を4ビット右にシフトする
    srl a
    srl a
    srl a
    srl a

    ld (hl), a

    ld a, c ; Cレジスタに退避してある値を戻す
    and 00001111B ; 下位4ビットだけにする
    inc hl
    ld (hl), a
    inc hl

    ; WK_MAPAREA_ADDRの値を2バイト進める
    ld (WK_MAPAREA_ADDR), hl

    pop ix
    pop hl
    pop de
    pop bc
    pop af

    ret

;-----------------------------------------------
; SUB-ROUTINE: ReadMapData
; MAP座標X、Yをもとに画面に表示するために
; 圧縮形式のマップデータを読み込み
; WK_MAPDATAに格納する
; その内容を展開し、WK_MAPAREAに格納する
;-----------------------------------------------
ReadMapData:
    
ReadMapDataMakeData:

    ; WK_PIT_ENTER_FLGが1の場合は
    ; WK_PIT_MAP_ADDRのアドレスからMAPデータを読み込む
    ld a, (WK_PIT_ENTER_FLG)
    cp 1
    jp nz, ReadMapDataMakeDataOverworld

ReadMapDataMakeDataPit:

    ld hl, (WK_PIT_MAP_ADDR)
    jp ReadMapDataStart

ReadMapDataMakeDataOverworld:

    ; オーバーワールドのMAPデータを読み込む
    ld a, (WK_MAPPOSY)
    ld h, a
    ld e, 12   ; マップデータのY座標を進めるぶんのバイト数
               ; マップの横画面数6枚xアドレス値(2バイト)=12バイト
    
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

ReadMapDataStart:

    ; 最初の1バイトはマップ種別
    ld a, (hl)
    ld (WK_MAPTYPE), a

    ; 次の2バイトはPITマップのデータアドレス
    ;
    ; PITのマップデータの場合
    ; PITマップのデータアドレスは常にオーバーワールドの
    ; マップデータのアドレスがセットされている
    ; WK_PIT_MAP_ADDRにセットする
    
    inc hl
    ld c, (hl)
    inc hl
    ld b, (hl)

    push hl
    or a
    ld hl, $FFFF
    ; PITデータのアドレスが$FFFF であれば以降の
    ; 6バイトはスキップする
    sbc hl, bc
    pop hl

    ld (WK_PIT_MAP_ADDR), bc

    jr z, ReadMapSkipPITInfo

    ; 次の1バイトはPITに入った直後のX座標
    inc hl
    ld a, (hl)
    ld (WK_PIT_ENTER_POSX), a

    ; 次の1バイトはPITに入った直後のY座標
    inc hl
    ld a, (hl)
    ld (WK_PIT_ENTER_POSY), a

    ; 次の1バイトはPITから出た場所のMAP座標X
    inc hl
    ld a, (hl)
    ld (WK_PIT_EXIT_MAPPOSX), a

    ; 次の1バイトはPITから出た場所のMAP座標Y
    inc hl
    ld a, (hl)
    ld (WK_PIT_EXIT_MAPPOSY), a

    ; 次の1バイトはPITから出た場所のX座標
    ; 00HならEXIT_POSは更新しない
    inc hl
    ld a, (hl)
    ld (WK_PIT_EXIT_POSX), a

    inc hl
    ld a, (hl)
    ld (WK_PIT_EXIT_POSY), a

ReadMapSkipPITInfo:

    inc hl

    ; PITに出入りした直後であればプレイヤーを
    ; ENTER_POSの位置に表示する
    ld a, (WK_PIT_ENTER_FLG)
    cp 1
    jp nz, ReadMapDataLoop1

    ; X座標
    push de
    ld a, (WK_PIT_ENTER_POSX)
    ld (WK_PLAYERPOSX), a
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ; Y座標
    ld a, (WK_PIT_ENTER_POSY)
    ld (WK_PLAYERPOSY), a
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a
    pop de

    call PlayerSetXYPos

    ; タイルデータの先頭位置までSEEK

ReadMapDataLoop1:

    ld a, (hl)
    inc hl
    or 0
    jp nz, ReadMapDataLoop1

    ;----------------------------------------
    ; ヘッダ部の読み込み
    ;----------------------------------------
    ld a, (hl) ; ボディ部のバイト数
    inc hl

    ld b, a
    ld c, 0
    ld (WK_BCREGBACK), bc

    ; Eレジスタの値が0であれば上位4ビットにタイル番号を
    ; 1であれば下位4ビットにタイル番号をセットする
    ld e, 0

ReadMapDataLoop2:

    ; 圧縮データの読み込み
    ld (WK_HLREGBACK), hl

    ld a, (hl)

    ; 上位4ビットと下位4ビットの値に分けてデータ長を取得する
    ld (WK_VALUE01), a
    rrca
    rrca
    rrca
    rrca
    and $0F
    ld c, a ; 上位4ビット（データ長）

    ld (WK_HLREGBACK), hl

    ; データ長の数だけ4ビットずつにタイル番号を埋めていく

ReadMapDataPutSerialByte:

    ld a, e
    cp 1
    jp nz, ReadMapDataPutSerialSetUpperBit

    ; タイル番号を下位4ビットにつめる
    ld a, (WK_VALUE01)
    and $0F
    or d  ; A = A(下位4ビット) or D(上位4ビット)
    
    ; 下位4ビットにつめたらマップデータにセットする
    ; データセット後、WK_MAPCOMP_ADDRのアドレスをインクリメントする

    ld hl, (WK_MAPCOMP_ADDR)
    ld (hl), a
    inc hl
    ld (WK_MAPCOMP_ADDR), hl

    ld e, 0

    dec c
    jp z, ReadMapDataPutSerialByteEnd

    jp ReadMapDataPutSerialByte

ReadMapDataPutSerialSetUpperBit:

    ; タイル番号を上位4ビットにつめる
    ld a, (WK_VALUE01)
    rlca
    rlca
    rlca
    rlca
    and $F0
    ld d, a

    ld e, 1

    dec c
    jp z, ReadMapDataPutSerialByteEnd

    jp ReadMapDataPutSerialByte
    
ReadMapDataPutSerialByteEnd:

    ld hl, (WK_HLREGBACK)
    inc hl
    ld (WK_HLREGBACK), hl

    ld bc, (WK_BCREGBACK)

    dec b
    jp z, ReadMapDataEnd

    ld (WK_BCREGBACK), bc

    jp ReadMapDataLoop2

ReadMapDataEnd:

    ; 最後に上位4ビットしかセットしていないのであれば
    ; WK_MAPCOMP_ADDRのアドレスに1バイトセットする
    ld b, a
    ld a, e
    cp 1
    jp nz, ReadMapDataPutLastEnd

    ld hl, (WK_MAPCOMP_ADDR)
    ld a, b
    ld (hl), a
    inc hl
    ld (WK_MAPCOMP_ADDR), hl

ReadMapDataPutLastEnd:

    ret
    
;-------------------------------------------------------
; SUB-ROUTINE: CreateViewPort
;
; MAPデータ(WK_MAPAREA)をもとにして
; ビューポート(WK_MAP_VIEWAREA)を作成する
;-------------------------------------------------------
CreateViewPort:

    push af
    push bc
    push de
    push hl

    ;----------------------------------------------
    ; 仮想パターンネームテーブルのクリア
    ;----------------------------------------------
    ld hl, WK_VIRT_PTNNAMETBL
    ld bc, 768
    ld  a, $24
    call MemFil

    ld hl, WK_MAPAREA
    ld (WK_MAPAREA_ADDR), hl

    ld hl, WK_MAP_VIEWAREA
    ld (WK_VIEWPORT_ADDR), hl

    ld hl, (WK_MAPAREA_ADDR)

    ld c, 10 ; 縦タイル数は10

CreateViewPortLoop1:

    ld b, 15 ; 横タイル数は15

CreateViewPortLoop2:

    ;-------------------------------------------
    ; タイル情報によってキャラクタコードを
    ; ビューポート情報にセットする
    ;-------------------------------------------
    ld a, (hl)

    ; タイル番号に4をかけると表示するタイルの左上のキャラクターが決定する
    add a, a
    add a, a
    ld d, 0 ; 4倍した値をDEレジスタにセットする
    ld e, a

    ld hl, CHAR_TILES
    add hl, de

    ld (WK_HLREGBACK), hl
    ld de, (WK_HLREGBACK) ; DEレジスタに1タイルの左上のキャラクターコードのアドレスをセット
    ld (WK_DEREGBACK), de

    ; 左上のキャラクター情報をセット
    ld hl, (WK_VIEWPORT_ADDR)
    ld a, (de) ; DE + 0
    ld (hl), a

    ; 右上のキャラクター情報をセット
    inc hl
    inc de
    inc de
    ld a, (de)
    ld (hl), a ; DE + 2

    ; HLレジスタの値を加算してタイルの下部分をセットするアドレスに進める
    ld d, 0
    ld e, 29
    add hl, de

    ; 左下のキャラクター情報をセット
    ld de, (WK_DEREGBACK)
    inc de
    ld a, (de) ; DE + 1
    ld (hl), a
    inc hl

    ; 右下のキャラクター情報をセット
    inc de
    inc de
    ld a, (de) ; DE + 3
    ld (hl), a ; WK_VIEWPORT_ADDR + 31 のアドレス

    ; 1タイル分のセットが完了したため、WK_VIEWPORT_ADDRに2を加算する
    ld hl, (WK_VIEWPORT_ADDR)
    ld d, 0
    ld e, 2
    add hl, de
    ld (WK_VIEWPORT_ADDR), hl

    ; タイル情報のアドレスをインクリメント
    ld hl, (WK_MAPAREA_ADDR)
    inc hl
    ld (WK_MAPAREA_ADDR), hl

    djnz CreateViewPortLoop2

    ; この時点ではWK_VIEWPORT_ADDR + 30

CreateViewPortLoop2End:

    ld hl, (WK_VIEWPORT_ADDR)
    ld d, 0
    ld e, 30
    add hl, de
    ld (WK_VIEWPORT_ADDR), hl

    ld hl, (WK_MAPAREA_ADDR)

    ; 縦タイル行分処理するまで繰り返す
    dec c
    jr nz, CreateViewPortLoop1

CreateViewPortEnd:

    ; ドアをWK_MAP_VIEWAREAに表示する
    call CreateDoor

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

;-----------------------------------------------
; SUB-ROUTINE: ResetViewPort
;
; WK_MAP_VIEWAREAに格納されている30x20バイトの
; データを仮想VRAMに出力する
;
; ピープホール処理後に仮想パターンネームテーブル
; が破壊されるため
; ピープホール処理時にはH.TIMIのタイミングで
; この処理を呼び出すこと
; 
; ビューポートの左上はRAMのED61H
;
;-----------------------------------------------
ResetViewPort:

    push af
    push bc
    push de
    push hl

    ;----------------------------------------------
    ; ここからビューポートを画面に表示する処理
    ;----------------------------------------------

    ld hl, WK_MAP_VIEWAREA
    ld (WK_VIEWPORT_ADDR), hl

    ; カウンタ変数に20をセット（縦20行繰り返すためのカウンタ）
    ld a, 20
    ld (WK_VIEWPORT_COUNTER), a

    ;----------------------------------------------
    ; 直接VRAMには書き込まず
    ; 仮想パターンネームテーブルに書き込む
    ; H.TIMIのタイミングでWK_VIRT_PTNNAMETBLから768バイト分を
    ; VRAMの1800Hに転送する
    ;----------------------------------------------
    ld hl, WK_VIRT_PTNNAMETBL + $61 ; 
    ld (WK_VIEWPORT_VRAMADDR), hl

ResetViewPortLoop1:

    ld de, (WK_VIEWPORT_VRAMADDR) ; DEレジスタ：転送先アドレス
    ld bc, 30                     ; BCレジスタ：転送量(横30バイト)
    ld hl, (WK_VIEWPORT_ADDR)     ; HLレジスタ：転送元アドレス
    call MemCpy

    ld hl, (WK_VIEWPORT_ADDR)     ; WK_VIEWPORT_ADDRのアドレスを進める

    ; WK_VIEWPORTADDRのアドレスを進める数は30
    ld a, 30
    ld d, 0
    ld e, a
    add hl, de

    ld (WK_VIEWPORT_ADDR), hl

    ld hl, (WK_VIEWPORT_VRAMADDR) ; WK_VIEWPORT_VRAMADDRのアドレスを$20（32文字ぶん）進める
    ld a, $20
    ld d, 0
    ld e, a
    add hl, de
    ld (WK_VIEWPORT_VRAMADDR), hl

    ld a, (WK_VIEWPORT_COUNTER)
    dec a
    jr z, ResetViewPortEnd

    ld (WK_VIEWPORT_COUNTER), a

    jr ResetViewPortLoop1

ResetViewPortEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;-----------------------------------------------
; SUB-ROUTINE: DisplayViewPort
;
; WK_MAP_VIEWAREA_DISPに格納されている30x20バイトの
; データを仮想VRAMに出力する
; 
;-----------------------------------------------
DisplayViewPort:

    push af
    push bc
    push de
    push hl

    ;----------------------------------------------
    ; 画面再描画フラグをONにする
    ;----------------------------------------------

    xor a
    ld (WK_REDRAW_FINE), a

    ;----------------------------------------------
    ; ここからビューポートを画面に表示する処理
    ;----------------------------------------------

    ld hl, WK_MAP_VIEWAREA_DISP
    ld (WK_VIEWPORT_ADDR), hl

    ; カウンタ変数に20をセット（縦20行繰り返すためのカウンタ）
    ld a, 20
    ld (WK_VIEWPORT_COUNTER), a

    ;----------------------------------------------
    ; 直接VRAMには書き込まず
    ; 仮想パターンネームテーブルに書き込む
    ; H.TIMIのタイミングでWK_VIRT_PTNNAMETBLから768バイト分を
    ; VRAMの1800Hに転送する
    ;----------------------------------------------
    ld hl, WK_VIRT_PTNNAMETBL + $61 ; 書き出し位置の調整
    ld (WK_VIEWPORT_VRAMADDR), hl

DisplayViewPortLoop1:

    ld de, (WK_VIEWPORT_VRAMADDR) ; DEレジスタ：転送先アドレス
    ld bc, 30                     ; BCレジスタ：転送量(横30バイト)
    ld hl, (WK_VIEWPORT_ADDR)     ; HLレジスタ：転送元アドレス
    call MemCpy

    ld hl, (WK_VIEWPORT_ADDR)     ; WK_VIEWPORT_ADDRのアドレスを進める

    ; WK_VIEWPORTADDRのアドレスを進める数は30
    or a
    ld a, 30
    ; ld d, 0
    ; ld e, a
    ; add hl, de
    add a, l
    ld l, a
    adc a, h
    sub l
    ld h, a

    ld (WK_VIEWPORT_ADDR), hl

    ld hl, (WK_VIEWPORT_VRAMADDR) ; WK_VIEWPORT_VRAMADDRのアドレスを$20（32文字ぶん）進める
    ld a, $20
    ; ld d, 0
    ; ld e, a
    ; add hl, de
    add a, l
    ld l, a
    adc a, h
    sub l
    ld h, a

    ld (WK_VIEWPORT_VRAMADDR), hl

    ld a, (WK_VIEWPORT_COUNTER)
    dec a
    jr z, DisplayViewPortEnd

    ld (WK_VIEWPORT_COUNTER), a

    jr DisplayViewPortLoop1

DisplayViewPortEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------------
; SUB-ROUTINE: ChangeMapView:
; MAP座標X,Yをもとにマップ情報を読み込み
; ビューポート域の表示切替を行う
; なお、表示切替時には20/60秒のタイムラグを確保する
;---------------------------------------------------
ChangeMapView:

    push af
    push bc
    push de
    push hl
    
    ; 画面切替時に30/60秒のインターバル値をセットする
    ld a, 30
    ld (WK_GAMESTATUS_INTTIME), a

    ; 宝箱情報をクリアする
    xor a
    ld (WK_TREASUREBOX_ITEM), a
    ld (WK_TREASUREBOX_X), a
    ld (WK_TREASUREBOX_Y), a
    ld (WK_BOX_PICKUP), a
    ld (WK_PEEPHOLE_BUILDNOW), a

    ; スプライト再描画フラグをクリアする
    ld (WK_SPRREDRAW_FINE), a

    ; 休憩タイマーをクリアする
    ld (WK_REST_COUNTDOWN), a

    ; MAP Y座標が4でなければ
    ; 永久回廊用ワーク変数をクリアする
    ld a, (WK_MAPPOSY)
    cp 4
    jr z, ChangeMapViewSkipClearCorridor

    xor a
    ld (WK_CORRIDOR), a

    ; 永久回廊情報表示メッセージをクリアする
    ld (WK_CORRIDOR_RETURN), a

ChangeMapViewSkipClearCorridor:

    ; 画面書き換えのため
    ; 画面REDRAWフラグをOFFにする
    xor a
    ld (WK_REDRAW_FINE), a

    ; 画面情報を空白($20）で塗りつぶす
    ld hl, WK_MAP_VIEWAREA
    ld bc, 600
    ld a, $20
    call MemFil

    ; 仮想パターンネームテーブルを背景($24)で塗りつぶす
    ld hl, WK_VIRT_PTNNAMETBL
    ld bc, 768
    ld a, $24
    call MemFil

    ; WK_SPRMOVE_TBLの初期化
    ld hl, WK_SPRITE_MOVETBL + 48
    ld bc, 464
    ld a, 0
    call MemFil

    ; スプライトアトリビュートテーブルの元となる
    ; SHUFFLE_ATTRTBLを初期化する
    ld b, 32
    ld hl, WK_SHUFFLE_ATTRTBL

    ; 剣を振っていない状態にする
    xor a
    ld (WK_SWORDACTION_COUNT), a
    ld (WK_SWORD_REUSE_COUNT), a

ChangeMapViewLoop:

    ld a, 209
    ld (hl), a ; Y座標を209にして画面外表示状態とする
    inc hl
    xor a
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl

    djnz ChangeMapViewLoop

    ; 衝突判定テーブルを初期化する
    ld hl, WK_COLLISION_TBL
    ld bc, 100
    ld a, $00
    call MemFil

ChangeMapViewLoopCreateMap:

    ; マップを書き換える
    call CreateMapArea
    call CreateViewPort

    ; ピープホールなしの状態を仮想ネームテーブルに描画
    call DisplayViewPort

    ; テキキャラを作成する
    call CreateEnemyData

    ld a, (WK_MAPTYPE)
    cp 1
    jr z, ChangeMapViewPlainType
    cp 3
    jr z, ChangeMapViewPlainType
    cp 2
    jp z, ChangeMapViewPeepHoleType
    cp 5
    jp z, ChangeMapViewPeepHoleType
    cp 8
    jr z, ChangeMapViewPeepHoleType

    cp 4
    jp z, ChangeMapViewMine

    cp 6
    jp z, ChangeMapViewCastle

    cp 9
    jp z, ChangeMapViewPIT

    jp ChangeMapViewEnd

ChangeMapViewPlainType:

    ld hl, MOMBGMLETSGOADVENTURE_START
    xor a ; Subsong 0
    call COMMON_AKG_INIT

    ; 床タイル、木タイルのキャラクターを変更する
    ld hl, CHRPTN_FOREST_GROUND_0
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    jp ChangeMapViewEnd

ChangeMapViewPIT:

    ld a, (WK_MAPPOSX)
    ld b, a
    ld a, (WK_MAPPOSY)
    ld c, a
    ld hl, $0301
    or a
    sbc hl, bc
    jr nz, ChangeMapViewPITNormalPIT

ChangeMapViewPITLastPIT:

    ld a, 5 ; Subsong 5
    jr ChangeMapViewPITBGMSet

ChangeMapViewPITNormalPIT:

    ld a, 1 ; Subsong 1

ChangeMapViewPITBGMSet:

    ld hl, MOMBGMLETSGOADVENTURE_START
    call COMMON_AKG_INIT

    ; 床タイルのキャラクターを変更する
    ld hl, CHRPTN_PIT_GROUND_1
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    jp ChangeMapViewEnd

ChangeMapViewCastle:

    ld hl, MOMBGMLETSGOADVENTURE_START
    ld a, 5 ; Subsong 5
    call COMMON_AKG_INIT

    ; 床タイルのキャラクターを変更する
    ld hl, CHRPTN_PIT_GROUND_1
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    jp ChangeMapViewEnd

ChangeMapViewMine:

    ; 床タイルのキャラクターを変更する
    ld hl, CHRPTN_MINE_GROUND_1
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    jp ChangeMapViewEnd

ChangeMapViewPeepHoleType:

    ld hl, MOMBGMLETSGOADVENTURE_START
    ld a, 1 ; Subsong 1
    call COMMON_AKG_INIT

    ; 床タイルのキャラクターの再定義を行う
    ld hl, CHRPTN_FOREST_GROUND_1
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    ld a, (WK_MAPTYPE)
    cp 5
    jp z, ChangeMapViewPeepHoleType05

    ; 怪しい森であれば
    ; PCGキャラクターの再定義を行う
    ld hl, CHRPTN_FOREST_WOOD_1
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    jp ChangeMapViewEnd

ChangeMapViewPeepHoleType05:

    ld hl, CHRPTN_PLAIN_WOOD_2
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

    jp ChangeMapViewEnd

ChangeMapViewNoPeepHoleType:

    cp 3
    jp nz, ChangeMapViewEnd

    ; 迷いの大河であれば
    ; PCGキャラクターの再定義を行う
    ld hl, CHRPTN_WATER_1
    ld (WK_CHARDATAADR), hl
    xor a
    ld (WK_VALUE08), a
    call CreateCharacterPatternLoop

ChangeMapViewEnd:

    ; プレイヤーステータス表示欄を初期化
    ld hl, WK_VIRT_PTNNAMETBL + 1 + 32
    ld bc, 18
    ld a, $20
    call MemFil
    
    ld hl, WK_VIRT_PTNNAMETBL + 1 + 32 + 32
    ld bc, 18
    ld a, $20
    call MemFil

    ; テキキャラステータス表示欄を初期化
    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32
    ld bc, 11
    ld a, $20
    call MemFil
    
    ld hl, WK_VIRT_PTNNAMETBL + 20 + 32 + 32
    ld bc, 11
    ld a, $20
    call MemFil

    ; ステータスを表示する
    call BattleDispLifeGuage
    call BattleDispEnemyStatus

    ; ミッションステータスバーを初期化
    call BattleDispMissionStatus

    ; 移動禁止フラグをONにする
    ld a, CONST_NOTMOVE_ON
    ld (WK_NOTMOVE_FLG), a

    xor a

    ; 背景色表示フラグを初期化する
    ld (WK_BGCOLOR_CHGFLG), a
    
    ; プレイヤーのLOCATE X座標が29でなければ
    ; 永久回廊判定はスキップする
    ld a, (WK_PLAYERPOSX)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ld a, (WK_PLAYERPOSY)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    ld a, (WK_CHECKPOSX)
    cp 29
    jp nz, SkipLoopCorridor
    
    ; プレイヤー座標のVRAMの情報を取得
    call GetVRAM4x4
    ld hl, WK_VRAM4X4_TBL + $05
    ld a, (hl)
    ld b, a

    ; MAP座標 X=4, Y=4であれば永久回廊の判定を行う
    ld a, (WK_MAPPOSX)
    cp 4
    jr nz, SkipLoopCorridorNot0404
    ld a, (WK_MAPPOSY)
    cp 4
    jr nz, SkipLoopCorridorNot0404

    ; $99のキャラクタコードか？
    ld a, b
    cp $99
    jr nz, NotCorridor0404

    ld a, 00000001B
    ld (WK_CORRIDOR), a
    jp SkipLoopCorridor

NotCorridor0404:

    xor a
    ld (WK_CORRIDOR), a
    jp SkipLoopCorridor

SkipLoopCorridorNot0404:

    ; MAP座標 X=3, Y=4であれば永久回廊の判定を行う
    ld a, (WK_MAPPOSX)
    cp 3
    jr nz, SkipLoopCorridorNot0304
    ld a, (WK_MAPPOSY)
    cp 4
    jr nz, SkipLoopCorridorNot0304

    ; $99のキャラクタコードか？
    ld a, b
    cp $99
    jr nz, NotCorridor0304

    ld b, 00000010B
    ld a, (WK_CORRIDOR)
    or b
    ld (WK_CORRIDOR), a
    jr SkipLoopCorridor

NotCorridor0304:

    xor a
    ld (WK_CORRIDOR), a
    jr SkipLoopCorridor

SkipLoopCorridorNot0304:

    ; MAP座標 X=2, Y=4であれば永久回廊の判定を行う
    ld a, (WK_MAPPOSX)
    cp 2
    jr nz, SkipLoopCorridor
    ld a, (WK_MAPPOSY)
    cp 4
    jr nz, SkipLoopCorridor

    ; $99のキャラクタコードか？
    ld a, b
    cp $99
    jr nz, BackTo0504

    ld b, 00000100B
    ld a, (WK_CORRIDOR)
    or b

    ; WK_CORRIDORが00000111Bでなければ
    ; MAP座標をX=5, Y=4に戻す
    ; その際、情報メッセージを表示する
    ld (WK_CORRIDOR), a
    cp 00000111B
    jr nz, BackTo0504

    jr SkipLoopCorridor

BackTo0504:

    ld a, 1
    ld (WK_CORRIDOR_RETURN), a

    xor a
    ld (WK_CORRIDOR), a

    ; MAP座標を変更する
    ld a, 5
    ld (WK_MAPPOSX), a
    ld a, 4
    ld (WK_MAPPOSY), a

    ; プレイヤーの座標を変更する
    ld bc, 16

    ld a, 19
    ld (WK_CHECKPOSY), a
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld (WK_PLAYERPOSY), a

    ld hl, WK_SPRITE_MOVETBL
    inc hl
    ld (hl), a ; スプライト1枚目のY座標
    add hl, bc
    ld (hl), a ; スプライト2枚目のY座標
    add hl, bc
    ld (hl), a ; スプライト3枚目のY座標
    
    ld a, 11
    ld (WK_CHECKPOSX), a
    add a, a ; x2
    add a, a ; x4
    add a, a ; x8
    ld (WK_PLAYERPOSX), a
    
    ld hl, WK_SPRITE_MOVETBL
    inc hl
    inc hl
    ld (hl), a ; スプライト1枚目のX座標
    add hl, bc
    ld (hl), a ; スプライト2枚目のX座標
    add hl, bc
    ld (hl), a ; スプライト3枚目のX座標

    ; マップを再度作成する
    jp ChangeMapViewLoopCreateMap

SkipLoopCorridor:

    ;----------------------------------------------
    ; シナリオ処理
    ; MAP座標とMAP種別によってダイアログ表示を行う
    ; PITでは表示しない
    ;----------------------------------------------
    ld a, (WK_MAPTYPE)
    cp 9
    jp z, ScenarioEnd

    ld a, (WK_MAPPOSX)
    ld b, a
    ld a, (WK_MAPPOSY)
    ld c, a

    ld a, ($002C)

    ; MAP X=0, Y=2
    ; "こえがきこえる"
    ; "このちかにでんせつのぶきがねむっている"
    ld hl, $0002
    or a
    sbc hl, bc
    jr nz, Scenario2

Scenario1:

    or a
    jr z, Scenerio1Msg_JP

    ld hl, MESSAGE_DIALOG_SCN1MSG_EN
    jp ScenarioDispEnd

Scenerio1Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN1MSG_JP
    jp ScenarioDispEnd

Scenario2:

    ; MAP X=2, Y=5
    ; "こえがきこえる"
    ; ”どこからかなにかをたたくおとがする"
    ld hl, $0205
    or a
    sbc hl, bc
    jp nz, Scenario3

    or a
    jp z, Scenerio2Msg_JP

    ld hl, MESSAGE_DIALOG_SCN2MSG_EN
    jp ScenarioDispEnd

Scenerio2Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN2MSG_JP
    jp ScenarioDispEnd

Scenario3:

    ; MAP X=5, Y=5
    ; "こえがきこえる”
    ; ”ああ！またこの場所だ！"
    ld hl, $0505
    or a
    sbc hl, bc
    jp nz, Scenario4

    or a
    jp z, Scenerio3Msg_JP

    ld hl, MESSAGE_DIALOG_SCN3MSG_EN
    jp ScenarioDispEnd

Scenerio3Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN3MSG_JP
    jp ScenarioDispEnd

Scenario4:

    ; MAP X=4, Y=2
    ; "まどうしのしろはくらやみにつつまれている"
    ld hl, $0402
    or a
    sbc hl, bc
    jr nz, Scenario5

    or a
    jr z, Scenerio4Msg_JP

    ld hl, MESSAGE_DIALOG_SCN4MSG_EN
    jr ScenarioDispEnd

Scenerio4Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN4MSG_JP
    jr ScenarioDispEnd

Scenario5:

    ; MAP X=3, Y=1
    ld hl, $0301
    or a
    sbc hl, bc
    jr nz, Scenario6

    ; PITであればラスボスメッセージ
    ld a, (WK_MAPTYPE)
    cp 9
    jr nz, Scenario6

    ; "いつかきみもうそをつくようになる"
    ; "あきらめておとなしくかえったほうがいい"

    ld a, ($002C)
    or a
    jr z, Scenerio5Msg_JP

    ld hl, MESSAGE_DIALOG_SCN5MSG_EN
    jr ScenarioDispEnd

Scenerio5Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN5MSG_JP
    jr ScenarioDispEnd

Scenario6:

    ; MAP X=3, Y=3
    ; まどうしのしろ
    ld hl, $0303
    or a
    sbc hl, bc
    jr nz, Scenario7

    or a
    jr z, Scenerio6Msg_JP

    ld hl, MESSAGE_DIALOG_SCN6MSG_EN
    jr ScenarioDispEnd

Scenerio6Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN6MSG_JP
    jr ScenarioDispEnd

Scenario7:

    ; MAP X=5, Y=0
    ; "こえがきこえる"
    ; "おとながほしがるものは"
    ; "おかねだ"
    ld hl, $0500
    or a
    sbc hl, bc
    jr nz, Scenario8

    or a
    jr z, Scenerio7Msg_JP

    ld hl, MESSAGE_DIALOG_SCN7MSG_EN
    jr ScenarioDispEnd

Scenerio7Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN7MSG_JP
    jr ScenarioDispEnd

Scenario8:

    ; MAP X=4, Y=0
    ; "こえがきこえる"
    ; "おかねのためならうそもへいきなのだ"
    ; "ばかばかしいとおもわないか?"
    ld hl, $0400
    or a
    sbc hl, bc
    jr nz, Scenario9

    or a
    jr z, Scenerio8Msg_JP

    ld hl, MESSAGE_DIALOG_SCN8MSG_EN
    jr ScenarioDispEnd

Scenerio8Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN8MSG_JP
    jr ScenarioDispEnd

Scenario9:

    ; MAP X=3, Y=0
    ; "こえがきこえる"
    ; "おかねはがいねんでしかない"
    ; "そんなもののためにみんなくるうのだ"
    ld hl, $0300
    or a
    sbc hl, bc
    jr nz, ScenarioEnd

    or a
    jr z, Scenerio9Msg_JP

    ld hl, MESSAGE_DIALOG_SCN9MSG_EN
    jr ScenarioDispEnd

Scenerio9Msg_JP:

    ld hl, MESSAGE_DIALOG_SCN9MSG_JP
    jr ScenarioDispEnd

ScenarioDispEnd:

    ld a, 3
    ld (WK_GAMESTATUS), a
    ld a, 2
    ld (WK_DIALOG_TYPE), a
    ld a, 3
    ld (WK_GAMESTATUS_INTTIME), a
    ld (WK_DISP_DIALOG_MESSAGE_ADR), hl

ScenarioEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;---------------------------------------------------
; SUB-ROUTINE: PitProc
; PITの出入りを行う
; プレイヤーの位置が下り階段に一致:
;   WK_PIT_MAP_ADDRにセットされている
;   マップ情報を読み込み画面情報を作り直す
; プレイヤーの位置が上り階段に一致:
;   ChangeMapViewを呼び出し
;   WK_PIT_ENTER_POSX,POSYの座標に
;   プレイヤーを表示する
;---------------------------------------------------
PitProc:

    ; PITに入った直後、PITから出た直後であれば
    ; 何もしない
    ld a, (WK_PIT_ENTER_FLG)
    cp 1
    jp nc, PitProcEnd

    ; プレイヤーの位置情報からVRAM情報を取得する
    call GetPlayerSurroundings

    ld hl, WK_VRAM4X4_TBL+5
    ld a, (hl)

    cp $64
    jp nz, PitProcCheckUpStair2

    ; 上り階段1と一致している

    ; PITマップデータを読み込み
    ; スプライト表示位置を調整する

    ; WK_PIT_ENTER_FLGを2にすることで
    ; 出口のMAP座標に表示する

    ld a, 2
    ld (WK_PIT_ENTER_FLG), a

    ; 上り階段1の場合、MAP座標は変更せず
    ; MAP情報の読み込みを行う
    ; （地上から入ってきたMAP座標をそのまま使う）
    ld a, (WK_PIT_ENTER_PREX)
    ld (WK_PLAYERPOSX), a
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ld a, (WK_PIT_ENTER_PREY)
    ld (WK_PLAYERPOSY), a
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    jp PitProcPitChangeEnd

PitProcCheckUpStair2:

    cp $68
    jp nz, PitProcCheckDownStair

    ; 上り階段2と一致している

    ; PITマップデータを読み込み
    ; スプライト表示位置を調整する

    ; WK_PIT_ENTER_FLGを2にすることで
    ; 出口のMAP座標に表示する

    ld a, 2
    ld (WK_PIT_ENTER_FLG), a

    ; 上り階段2の場合、MAP座標を変更して
    ; MAP情報の読み込みを行う

    ld a, (WK_PIT_EXIT_MAPPOSX)
    ld (WK_MAPPOSX), a

    ld a, (WK_PIT_EXIT_MAPPOSY)
    ld (WK_MAPPOSY), a

    ld a, (WK_PIT_EXIT_POSX)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSX), a

    ld a, (WK_PIT_EXIT_POSY)
    call DivideBy8
    ld a, d
    ld (WK_CHECKPOSY), a

    ld a, (WK_PIT_EXIT_POSX)
    ld (WK_PLAYERPOSX), a

    ld a, (WK_PIT_EXIT_POSY)
    ld (WK_PLAYERPOSY), a

    jp PitProcPitChangeEnd

PitProcCheckDownStair:

    cp $6C
    jp nz, PitProcEnd

    ; 下り階段と一致している

    ; PITマップデータを読み込み
    ; スプライト表示位置を調整する

    ld a, 1
    ld (WK_PIT_ENTER_FLG), a

    ld a, (WK_PLAYERPOSX)
    ld (WK_PIT_ENTER_PREX), a

    ld a, (WK_PLAYERPOSY)
    ld (WK_PIT_ENTER_PREY), a

PitProcPitChangeEnd:

    call ClearScreen
    call PlayerSetXYPos

    ld a, 5
    ld (WK_MAPCHANGE_COUNT), a

    ; 移動不可にする
    ld a, 1
    ld (WK_NOTMOVE_FLG), a

    ld a, 5 ; PITから出た瞬間のプレイヤーの向きは下向き
    ld (WK_PLAYERDIST), a
    xor a
    ld (WK_PLAYERDISTOLD), a

PitProcEnd:

    ret
