;----------------------------------------------------
; map.asm
; マップ関連処理
;   WK_MAPAREA : タイルデータ格納エリア(45x45tile)
;   WK_MAP_VIEWAREA : ビューポート表示データ(20x20)
;----------------------------------------------------

;--------------------------------------------
; SUB-ROUTINE: CreateMapArea
; マップデータを作成する
; MAPDATA_2BIT_TILESのデータをもとに
; WK_MAPAREAにタイル情報を生成する
;--------------------------------------------
CreateMapArea:

    push af
    push bc
    push de
    push hl

    ;--------------------------------------------
    ; MAPDATA_2BIT_TILESのデータを読み込み
    ; 1バイトあたり2タイルずつMAPAREAを埋めていく
    ;--------------------------------------------
    ld hl, WK_MAPAREA
    ld (WK_MAPAREA_ADDR), hl

    ld hl, MAPDATA_2BIT_TILES

    ld c, 45
    ;--------------------------------------------
    ; 横1列（12バイト分よみこむ)
    ;--------------------------------------------
CreateMapAreaLoop1:

    ld b, 12

CreateMapAreaLoop2:

    ld a, (hl) ; MAPのタイルデータ(2bit/1tile情報)を1バイト読み込む

    ; 読み込んだタイルデータを2ビットずつに分解してMAPAREAにセットする
    call GenTileData
    
    inc hl

    djnz CreateMapAreaLoop2 ; Bレジスタの値をデクリメントしてゼロでなければ繰り返す

    ;
    ; 12バイト目の下位6ビットはMAPデータとしては不要なデータである。そのため
    ; 最後の6ビットを無効とするため、WK_MAPAREA_ADDRのアドレスを3バイト戻す
    ;
    ld ix, (WK_MAPAREA_ADDR)
    dec ix
    dec ix
    dec ix
    ld (WK_MAPAREA_ADDR), ix

    ; Cレジスタの値をデクリメントして0になるまでCreateMapAreaLoop1を繰り返す
    ld a, c
    dec a
    jr z, CreateMapAreaEnd

    ld c, a ; デクリメントした値をCレジスタに格納する
    jr CreateMapAreaLoop1

CreateMapAreaEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;-----------------------------------------------
; SUB-ROUTINE: CreateMapArea
; Aレジスタに格納されている情報を2bitずつに分解し
; MAPAREAに4バイト分格納する
;-----------------------------------------------
GenTileData:

    push af
    push bc
    push de
    push hl

    ld c, a ; Aレジスタの値をCレジスタに退避

    ; MAPデータの格納先アドレスをIXレジスタにセット
    ld ix, (WK_MAPAREA_ADDR)

    ; WK_MAPDATA_ADDR + 3に値をセットする
    and 00000011B ; Aレジスタの値を00000011BでAND演算し、結果をAレジスタにセットする
    ld (ix + 3), a
    
    ld a, c ; Cレジスタに退避してある値を戻す

    ; WK_MAPAREA_ADDR + 2に値をセットする
    and 00001100B ; Aレジスタの値を00001100BでAND演算し、結果をAレジスタにセットする
    sra a         ; 2ビット右にシフト
    sra a
    ld (ix + 2), a

    ld a, c ; Cレジスタに退避してある値を戻す

    ; WK_MAPAREA_ADDR + 1に値をセットする
    and 00110000B ; Aレジスタの値を00110000BでAND演算し、結果をAレジスタにセットする
    sra a         ; 4ビット右にシフト
    sra a
    sra a
    sra a
    ld (ix + 1), a

    ld a, c ; Cレジスタに退避してある値を戻す

    ; WK_MAPAREA_ADDR + 0に値をセットする
    and 11000000B ; Aレジスタの値を11000000BでAND演算し、結果をAレジスタにセットする
    sra a         ; 6ビット右にシフト
    sra a
    sra a
    sra a
    sra a
    sra a
    and 00000011B ; 右シフトしたときに第7ビットの値がのこっているためANDで消す
    ld (ix + 0), a

    ; WK_MAPAREA_ADDRの値を4バイト進める
    inc ix
    inc ix
    inc ix
    inc ix
    ld (WK_MAPAREA_ADDR), ix

    pop hl
    pop de
    pop bc
    pop af

    ret

;-------------------------------------------------------
; SUB-ROUTINE: CreateViewPort
;
; MAPデータ上の論理座標をもとにして
; ビューポート(WK_MAP_VIEWAREA)を作成する
;   WK_VIEWPORTPOSX: ビューポートの起点X座標
;   WK_VIEWPORTPOSY: ビューポートの起点Y座標
;   WK_MAPAREA_ADDR: マップタイル情報
;   WK_MAP_VIEWAREA: ビューポート情報(最大24x24バイト)
;   WK_VIEWPORT_ADDR: ビューポート情報作成用ワーク
;
; ビューポート座標はタイルデータと1対1の関係
;-------------------------------------------------------
CreateViewPort:

    push af
    push bc
    push de
    push hl

    ; ビューポートの起点座標によって
    ; ビューポート情報を以下のような形で格納する
    ;
    ; WK_VIEWPORTPOSX = 0
    ;   AND WK_VIEWPORTPOSY = 0
    ;     WK_MAP_VIEWAREAは横10x縦10タイルぶんだけ格納する
    ;   AND WK_VIEWPORTPOSY > 0
    ;     WK_MAP_VIEWAREAは横10x縦12タイルぶんだけ格納する
    ;
    ; WK_VIEWPORTPOSX > 0
    ;   AND WK_VIEWPORTPOSY = 0
    ;     WK_MAP_VIEWAREAは横12x縦10タイルぶんだけ格納する
    ;   AND WK_VIEWPORTPOSY > 0
    ;     WK_MAP_VIEWAREAは横12x縦12タイルぶんだけ格納する

CreateViewPortRange1:

    ld a, (WK_VIEWPORTPOSX)
    cp 1
    jr nc, CreateViewPortRange2

    ; ビューポートのX座標が0の場合の処理

    ld a, (WK_VIEWPORTPOSY)
    cp 1
    jr c, CreateViewPortRange1POSY0

    ; X = 0 AND Y > 0

    ld a, 10
    ld (WK_VIEWPORT_RANGEX), a ; 横10タイル
    ld a, 12
    ld (WK_VIEWPORT_RANGEY), a ; 縦12タイル

    jr CreateViewPortRangeEnd

CreateViewPortRange1POSY0:

    ; X = 0 AND Y = 0

    ld a, 10
    ld (WK_VIEWPORT_RANGEX), a ; 横10タイル
    ld (WK_VIEWPORT_RANGEY), a ; 縦10タイル

    jr CreateViewPortRangeEnd

CreateViewPortRange2:

    ; ビューポートのX座標が0ではない場合の処理

    ld a, (WK_VIEWPORTPOSY)
    cp 1
    jr nc, CreateViewPortRange1POSYnot0

    ; X > 0 AND Y = 0
    ld a, 10
    ld (WK_VIEWPORT_RANGEX), a ; 横12タイル
    ld a, 12
    ld (WK_VIEWPORT_RANGEY), a ; 縦10タイル
    jr CreateViewPortRangeEnd

CreateViewPortRange1POSYnot0:

    ; X > 0 AND Y > 0

    ld a, 12
    ld (WK_VIEWPORT_RANGEX), a ; 横12タイル
    ld (WK_VIEWPORT_RANGEY), a ; 縦12タイル

CreateViewPortRangeEnd:

    ; マップデータの先頭（左上）を決定する
    ld hl, WK_MAPAREA

    ; 論理座標をもとにしてマップデータのY座標を求める
    ld a, (WK_VIEWPORTPOSY)

    ; Y座標が0の場合はY座標の変換は何もしない
    cp 1
    jr c, CreateViewPortLoop1End

    ; テキの半キャラ表示処理のため
    ; マップデータのY座標から-1する
    dec a
    jr z, CreateViewPortLoop1End  ; -1した座標が0の場合は行タイルのY座標加算はしない

    ld b, a

CreateViewPortLoop1:

    add hl, 45 ; HLレジスタに45を足すと次のY座標になる

    djnz CreateViewPortLoop1

CreateViewPortLoop1End:

    ; 論理座標をもとにしてマップデータのX座標を求める
    ld  a, (WK_VIEWPORTPOSX)

    ; X座標が0の場合はX座標の計算は何もしない
    cp 1
    jr c, CreateViewPortLoop1End2

    ; テキの半キャラ表示処理のため
    ; マップデータのX座標から-1する
    dec a

    ld  d, 0
    ld  e, a
    add hl, de ; HLレジスタにX座標を加算する

CreateViewPortLoop1End2:

    ;--------------------------------------------------------------
    ; 上記処理にてマップデータの座標（ビューポートの左上のデータ）
    ; が確定する。
    ; （ただし、周囲1タイルは表示されない領域となる）
    ;--------------------------------------------------------------
    
    ; WK_MAPAREA_ADDR変数にHLレジスタ(左上に表示すべきマップ座標)をセット
    ld (WK_MAPAREA_ADDR), hl

    ; HLレジスタにWK_MAP_VIEWAREAのアドレスをセット
    ld hl, WK_MAP_VIEWAREA

    ld (WK_VIEWPORT_ADDR), hl  ; WK_VIEWPORT_ADDR変数を初期化

    ld a, (WK_VIEWPORT_RANGEY)
    ld c, a ; ビューポート内部の縦タイル数(10 or 12)

CreateViewPortLoop2:
    
    ld a, (WK_VIEWPORT_RANGEX)
    ld b, a ; ビューポート内部の横タイル数(10 or 12)

CreateViewPortLoop3:

    ld hl, (WK_MAPAREA_ADDR) ; タイル情報をHLレジスタにセット
    ld a, (hl)
    
    ;-------------------------------------------
    ; タイル情報によってキャラクタコードを
    ; ビューポート情報にセットする
    ;-------------------------------------------

    ; タイル番号に4をかけると表示するタイルの左上のキャラクターが決定する
    add a, a
    add a, a

    ld d, 0 ; 4倍した値をDEレジスタにセットする
    ld e, a

    ld hl, CHAR_TILES
    add hl, de
    
    ld ix, hl ; IXレジスタに1タイルの左上のキャラクターコードのアドレスをセット

    ; 左上のキャラクター情報をセット
    ld hl, (WK_VIEWPORT_ADDR)
    ld a, (ix + 0)
    ld (hl), a

    ; 右上のキャラクター情報をセット
    inc hl
    ld a, (ix + 2)
    ld (hl), a

    ; HLレジスタの値を加算してタイルの下部分をセットするアドレスに進める
    ; 加算する数値は横タイル数 * 2 - 1 (WK_VIEWPORT_RANGEX * 2 - 1)
    ld a, (WK_VIEWPORT_RANGEX)
    add a, a
    dec a
    ld d, 0
    ld e, a
    add hl, de
    
    ; 左下のキャラクター情報をセット
    ld a, (ix + 1)
    ld (hl), a

    ; 右下のキャラクター情報をセット
    inc hl
    ld a, (ix + 3)
    ld (hl), a

    ; タイル情報のアドレスをインクリメント
    ld hl, (WK_MAPAREA_ADDR)
    inc hl
    ld (WK_MAPAREA_ADDR), hl

    ; 1タイル分のセットが完了したため、WK_VIEWPORT_ADDRに2を加算する
    ld hl, (WK_VIEWPORT_ADDR)
    add hl, 2
    ld (WK_VIEWPORT_ADDR), hl

    djnz CreateViewPortLoop3
    
CreateViewPortLoop3End:

    ; 縦タイル行分処理するまで繰り返す
    dec c
    jr z, CreateViewPortEnd

    ; WK_VIEWPORT_ADDRにWK_VIEWPORT_RANGEX * 2を加算する
    ; (加算すると下タイル行の先頭アドレスになる)
    ld a, (WK_VIEWPORT_RANGEX)
    add a, a
    ld hl, (WK_VIEWPORT_ADDR)
    ld d, 0
    ld e, a
    add hl, de
    ld (WK_VIEWPORT_ADDR), hl

    ; タイル情報のアドレスを加算して次の下タイル行の先頭を決定する
    ld hl, (WK_MAPAREA_ADDR)
    ld a, (WK_VIEWPORT_RANGEX)
    cp 10
    jr nz, CreateViewPortAdd12Tile

CreateViewPortAdd10Tile:
    add hl, 35
    jr CreateViewPortNextTile

CreateViewPortAdd12Tile:
    add hl, 33

CreateViewPortNextTile:

    ld (WK_MAPAREA_ADDR), hl

    jp CreateViewPortLoop2

CreateViewPortEnd:

    pop hl
    pop de
    pop bc
    pop af

    ret

;-----------------------------------------------
; SUB-ROUTINE: DisplayViewPort
; WK_MAP_VIEWAREAに格納されている24x24バイトの
; キャラクター情報から10x10タイル分だけの情報を
; 抽出して画面に表示する
; 
; ビューポートの左上はVRAMの1821H
;
;-----------------------------------------------
DisplayViewPort:

    push af
    push bc
    push de
    push hl

    ;----------------------------------------------
    ; ここからビューポートを画面に表示する処理
    ;----------------------------------------------

    ld hl, $1821
    ld (WK_VIEWPORT_VRAMADDR), hl

    ld hl, WK_MAP_VIEWAREA

    ; WK_VIEWPORTPOSY が1以上の場合
    ; 1タイル行ぶん、描画開始位置をスキップする
    ld a, (WK_VIEWPORTPOSY)
    cp 1
    jr c, DisplayViewPortRowTileSkipEnd

    ; 1タイル行スキップする
    ; 1タイル行のキャラクター数は WK_VIEWPORT_RANGEX * 4 (例：10タイル行SKIPであれば10*4=40)
    ld a, (WK_VIEWPORT_RANGEX)

    add a, a  ; AレジスタにAレジスタの値をかけて2倍にしその値をAレジスタに格納する
    add a, a  ; さらに2倍にする
    ld d, 0
    ld e, a
    add hl, de ; その結果をHLレジスタに加算する

DisplayViewPortRowTileSkipEnd:

    ld (WK_VIEWPORT_ADDR), hl

    ; カウンタ変数に20をセット（縦20行繰り返すためのカウンタ）
    ld a, 20
    ld (WK_VIEWPORT_COUNTER), a

DisplayViewPortLoop1:

    ld de, (WK_VIEWPORT_VRAMADDR) ; DEレジスタ：転送先VRAMアドレス
    ld bc, 20                     ; BCレジスタ：転送量(横20バイト)
    ld hl, (WK_VIEWPORT_ADDR)     ; HLレジスタ：転送元アドレス
    call LDIRVM

    ld hl, (WK_VIEWPORT_ADDR)     ; WK_VIEWPORT_ADDRのアドレスを進める

    ; アドレスを進める数は横タイル数(WK_VIEWPORT_RANGEX)*2
    ld a, (WK_VIEWPORT_RANGEX)
    add a, a
    ld d, 0
    ld e, a
    add hl, de

    ld (WK_VIEWPORT_ADDR), hl

    ld hl, (WK_VIEWPORT_VRAMADDR) ; WK_VIEWPORT_VRAMADDRのアドレスを$20（32文字ぶん）進める
    add hl, $20
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
