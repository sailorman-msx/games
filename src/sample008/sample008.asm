;--------------------------------------------
; INCLUDE
;--------------------------------------------
include "initialize.asm"

;--------------------------------------------
; メイン処理
;--------------------------------------------
Main:

    ;--------------------------------------------
    ; キャラクタパターンとカラーテーブルを
    ; 作成する
    ;--------------------------------------------
    call CreateCharacterPattern

    ;--------------------------------------------
    ; スプライトパターンを作成する
    ;--------------------------------------------
    call CreateSpritePattern

    ld a, 14
    ld (WK_PLAYERPOSX), a    ; プレイヤーのX座標の初期化
    ld (WK_PLAYERPOSXOLD), a ; プレイヤーのX座標の初期化
    ld a, 10
    ld (WK_PLAYERPOSY), a    ; プレイヤーのY座標の初期化
    ld (WK_PLAYERPOSYOLD), a ; プレイヤーのX座標の初期化

    ld a, 5
    ld (WK_PLAYERDIST), a    ; プレイヤーの向きの初期化（下向き）
    ld (WK_PLAYERDISTOLD), a ; プレイヤーの向きの初期化（下向き）

    ld a, $0D
    ld (WK_PLAYERSPRCLR1), a ; スプライトの表示色

    ld a, $0F
    ld (WK_PLAYERSPRCLR2), a ; スプライトの表示色

    ; 現在の位置をOLD変数にセット
    ld bc, 8
    ld de, WK_PLAYERMOVE_TBL
    ld hl, PLAYERMOVE_TBL
    ldir

    ; プレイヤーのジョイスティック方向にあわせた
    ; スプライトを初期表示する
    ld a, $02

    ld ix, SPRDISTPTN_TBL + 2
    call CreateWorkSpriteAttr

    ld de, $1B00
    ld bc, 8
    call PutSprite

    ;--------------------------------------------
    ; 障害物ブロックを画面上に配置する
    ;--------------------------------------------
    ld a, $82
    ld hl, $1910
    call WRTVRM
    ld hl, $1911
    call WRTVRM
    ld hl, $1930
    call WRTVRM
    ld hl, $1931
    call WRTVRM

    ;call DebugPrint

MainLoop:

    call DelayLoop

    ;--------------------------------------------
    ; 入力を受け付ける
    ;--------------------------------------------
    ; キーボードバッファをクリアする
    ; これを呼び出さないとカーソルキーを正常に判定できない
    call KILBUF

    ; またはカーソルキーの方向を取得
    ; GTSTCK呼び出し後、Aレジスタに方向がセットされる
    ld a, 0
    call GTSTCK
    
    ;--------------------------------------------
    ; ジョイスティックが押されたら移動処理を呼ぶ
    ;--------------------------------------------
    ; Aレジスタに0をOR演算する
    ; ジョイスティックが押されるとAレジスタの
    ; 値には0より大きい値が入るためOR演算の結果はゼロにならない
    or 0
    jr z, MainEnd

    ;--------------------------------------------
    ; プレイヤーの移動
    ; 移動は8ドット単位で移動する
    ; X座標は1-29まで
    ; Y座標は1-21まで
    ; の範囲だけ移動可能とする
    ;--------------------------------------------
    ld (WK_PLAYERDIST), a

    call MovePlayer

    call DebugPrint

MainEnd:

    jr MainLoop

DebugPrint:

    push af
    push bc
    push de
    push hl

    ;
    ; DUMP出力するためのデータを準備する
    ;
    ld hl, WK_PLAYERPOSX
    ld de, WK_DUMPDATA            ; WK_DUMPDATAのアドレスに
    ld bc, 16                     ; 16バイト転送する
    ldir

    call PrintHexaDump

    ;
    ; WK_DUMPCHARのアドレスの内容を
    ; 画面上の下段(1AE0H)に32バイト転送する
    ;
    ld de, $1AE0
    call HexaDumpToVRAM

    pop hl
    pop de
    pop bc
    pop af

    ret

;-----------------------------------------------
; INCLUDE
;-----------------------------------------------
include "common.asm"
include "vram.asm"
include "sprite.asm"
include "data_sprite.asm"
include "pcg_graphic2.asm"
include "data_pcg.asm"
