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

    ret

;-----------------------------------------------
; SUB-ROUTINE: CreateMapArea
; Aレジスタに格納されている情報を2bitずつに分解し
; MAPAREAに4バイト分格納する
;-----------------------------------------------
GenTileData:

    push bc

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

    pop bc

    ret

;-----------------------------------------------
; SUB-ROUTINE: CreateViewPort
; MAPデータ上の論理座標をもとにして
; ビューポート(WK_MAP_VIEWAREA)を作成する
; WK_VIEWPORTPOSX: ビューポートX座標
; WK_VIEWPORTPOSY: ビューポートY座標
; WK_MAPAREA_ADDR: マップ情報
; WK_MAP_VIEWAREA: ビューポート情報(20x20バイト)
; WK_VIEWPORT_ADDR: ビューポート情報作成用ワーク
;
; ビューポート座標はタイルデータと1対1の関係
;-----------------------------------------------
CreateViewPort:

    ; マップデータの先頭（左上）を決定する
    ld hl, WK_MAPAREA

    ; 論理座標をもとにしてマップデータのY座標を求める
    ld a, (WK_VIEWPORTPOSY)

    ; Y座標が0の場合はY座標の変換は何もしない
    or 0
    jr z, CreateViewPortLoop1End
    
    ld b, a

CreateViewPortLoop1:

    ld a, 45
    add hl, a ; HLレジスタに45を足すと次のY座標になる

    djnz CreateViewPortLoop1

CreateViewPortLoop1End:

    ; 論理座標をもとにしてマップデータのX座標を求める
    ld a, (WK_VIEWPORTPOSX)
    add hl, a ; HLレジスタにY座標を加算する

    ;--------------------------------------------------------------
    ; 上記処理にてマップデータの座標（ビューポートの左上のデータ）
    ; が確定する
    ;--------------------------------------------------------------
    ld (WK_MAPAREA_ADDR), hl   ; WK_MAPAREA_ADDR変数にHLレジスタ(左上に表示すべきマップ座標)をセット
    ld hl, WK_MAP_VIEWAREA     ; HLレジスタにWK_MAP_VIEWAREAのアドレスをセット
    ld (WK_VIEWPORT_ADDR), hl  ; WK_VIEWPORT_ADDR変数を初期化

    ld c, 10 ; ビューポート内部のタイル数は縦10タイル

CreateViewPortLoop2:
    
    ld b, 10 ; ビューポート内部のタイル数は横10タイル

CreateViewPortLoop3:

    ld hl, (WK_MAPAREA_ADDR) ; タイル情報をHLレジスタにセット
                             ; Aレジスタに格納するとアドレスの下位1バイトが入ってくるから注意！！
    ld a, (hl)
    
    ;-------------------------------------------
    ; タイル情報によってキャラクタコードを
    ; ビューポート情報にセットする
    ;-------------------------------------------

    ; タイル番号に4をかけると表示するキャラクターの左上が決定する
    ld de, 0
    ld hl, 0

    ld e, a
    ld h, 4
    call CalcMulti

    ld de, hl

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

    ; HLレジスタの値に19を加算してタイルの下部分をセットするアドレスに進める
    add hl, 19
    
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

    ; 10タイル行分処理するまで繰り返す

    ld a, c
    dec a
    jr z, CreateViewPortEnd

    ; WK_VIEWPORT_ADDRに20を加算する
    ; (20を加算すると下タイル行の先頭アドレスになる)

    ld hl, (WK_VIEWPORT_ADDR)
    add hl, 20
    ld (WK_VIEWPORT_ADDR), hl

    ; タイル情報のアドレスに35を加算すると次の下タイル行となる
    ld hl, (WK_MAPAREA_ADDR)
    add hl, 35
    ld (WK_MAPAREA_ADDR), hl

    ld c, a
    jr CreateViewPortLoop2

CreateViewPortEnd:

    ret

;-----------------------------------------------
; SUB-ROUTINE: DisplayViewPort
; WK_MAP_VIEWAREAに格納されている20x20バイトの
; キャラクター情報をビューポート域に表示する
; 
; ビューポートの左上はVRAMの1821H
;
;-----------------------------------------------
DisplayViewPort:

    ld hl, WK_MAP_VIEWAREA
    ld (WK_VIEWPORT_ADDR), hl

    ld hl, $1821
    ld (WK_VIEWPORT_VRAMADDR), hl

    ; カウンタ変数に20をセット（縦20行繰り返すためのカウンタ）
    ld a, 20
    ld (WK_VIEWPORT_COUNTER), a

DisplayViewPortLoop1:

    ld hl, (WK_VIEWPORT_VRAMADDR)
    ld de, hl                 ; DEレジスタ：転送先VRAMアドレス
    ld bc, 20                 ; BCレジスタ：転送量(横20バイト)
    ld hl, (WK_VIEWPORT_ADDR) ; HLレジスタ：転送元アドレス
    call LDIRVM

    ld hl, (WK_VIEWPORT_ADDR) ; WK_VIEWPORT_ADDRのアドレスを20バイト進める
    add hl, 20
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

    ret

