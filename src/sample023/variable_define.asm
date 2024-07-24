;--------------------------------------------
; 変数・定数領域
; MSX-DOSを考慮して
; 変数領域はC000H - DE3FHまでとする
;--------------------------------------------

;--------------------------------
; ここから定数
;--------------------------------
CONST_VDPPORT0:equ $98
CONST_VDPPORT1:equ $99
CONST_SPRITETOTAL:equ 16

CONST_SPACE:equ $20

CONST_MOVEUPOK:   equ 00001000B
CONST_MOVEDOWNOK: equ 00000100B
CONST_MOVELEFTOK: equ 00000010B
CONST_MOVERIGHTOK:equ 00000001B

;--------------------------------
; アドレスUNION領域
; 変数領域確保前のみ使用可能とする
;--------------------------------
WK_UNIONRAM:equ $C800       ; 2048バイト

;--------------------------------
; ここから変数
;--------------------------------

;--------------------------------
; 仮想VRAM格納用
;--------------------------------
; パターンネームテーブル1(768バイト)
; C000H - C2FFH

DEFVARS $C000
{

WK_VIRT_PTNNAMETBL ds.b 768

}

; パターンネームテーブル2(768バイト)
; C300H - C5FFH

DEFVARS $C300
{

WK_VIRT_PCGSPRTBL ds.b 768

}

; パターンネームテーブル3(768バイト)
; C600H - C8FFH

DEFVARS $C600
{

WK_VIRT_1800OUT ds.b 768

}

;--------------------------------
; スプライトシャッフル用テーブル(128バイト)
;--------------------------------
; C900H - C979H

DEFVARS $C900
{

WK_SHUFFLE_ATTRTBL ds.b 128  ; 128バイト

}

;--------------------------------
; 仮想スプライトアトリビュートテーブル(128バイト)
;--------------------------------
; C980H - C9FFH

DEFVARS $C980
{

WK_VIRT_SPRATTRTBL ds.b 128

}

;--------------------------------
; スプライト情報テーブル(256バイト)
; 1体あたり16バイト：16体分=256バイト
;--------------------------------
; CA00H - CAFFH

DEFVARS $CA00
{

WK_SPRITE_MOVETBL ds.b 256   ; 16バイトx16体分 256バイト

}

;--------------------------------
; スプライトパターンテーブル(256バイト)
; 1枚あたり32バイト：8体分=256バイト
; 
; 初期処理時にPage#0からデータを転送する
; VBLANKのタイミングで
; プレイヤーの方向にあわせて
; このアドレスの内容をVRAMの
; スプライトパターンテーブルに転送する
;
; <スプライトパターンの仕様>
; スプライト#0 - #15:VBLANKで変動
;   常にプレイヤーで固定
; スプライト#16 - #23:常時固定
;   弾のスプライトパターンで固定
; スプライト#24 - #31:常時固定
;   衝突エフェクトパターンで固定
; スプライト#32以降：VBLANKで変動
;   敵キャラなど
; 
;--------------------------------
; CB00H - D2FFH

DEFVARS $CB00
{

WK_SPRITE_PTNTBL ds.b 2048   ; 8バイトx256体分 2048バイト

}

;--------------------------------
; MAPタイルテーブル(384バイト)
; 32 x 18 キャラで1画面
; 32 x  3 タイルで1画面(1タイルは横1x縦6)
; 4画面分のタイルデータを保持する
; 32 x 3 x 4 = 384バイト
;--------------------------------
; D300H - D481H

DEFVARS $D300
{

WK_MAP_TILEDATA    ds.b 384    ; 384バイト
WK_MAP_SCROLLTYPE  ds.b 1      ; 1バイト スクロール方向0=縦1=横
WK_MAP_INITVIEWPOS ds.w 1      ; 2バイト 初期表示時のビューポート左上アドレス 

}

;--------------------------------
; 空きエリア
;--------------------------------
; D482H - D7FFH

;--------------------------------
; その他こまかい変数群
; DE30Hを超えないようにする！！
;--------------------------------
; D800H-

DEFVARS $D800
{

; テーブル関連はアライメントの都合により先頭に持ってくる
WK_VRAM4X6_TBL    ds.b 24    ; 24バイト VRAM情報格納テーブル
WK_COL_0C         ds.b  1    ;  1バイト 左方向の背景1
WK_COL_18         ds.b  1    ;  1バイト 左方向の背景2
WK_COL_0F         ds.b  1    ;  1バイト 右方向の背景1
WK_COL_1B         ds.b  1    ;  1バイト 右方向の背景2

; Page#0利用時の変数
PAGE0_FUNC        ds.w 1     ; 2バイト Page#0のサブルーチンアドレス

; H.TIMI関連
H_TIMI_BACKUP     ds.b 5     ; 5バイト H.TIMIバックアップ用領域
VSYNC_WAIT_CNT    ds.b 1     ; 1バイト H.TIMI垂直同期待ちフラグ
WK_GAMESTATUS     ds.b 1     ; 1バイト ゲーム進行ステータス

WK_GAMESTATUS_INTTIME ds.b 1 ; 1バイト
WK_TIME05         ds.b 1     ; 1バイト 5/60秒タイマ

; VRAM関連で扱う変数群
WK_VRAM_SYNC      ds.b 1     ; 1バイト VRAM書き込み排他フラグ
WK_REDRAW_FINE    ds.b 1     ; 1バイト 仮想VRAM -> VRAM転送許可フラグ
WK_CHECKPOSX      ds.b 1     ; 1バイト VRAM位置判定用
WK_CHECKPOSY      ds.b 1     ; 1バイト VRAM位置判定用
WK_NUMTOCHARVAL   ds.b 1     ; 数値格納用バッファ(この値を文字化してWK_STRINGBUFにセットする)
WK_CHARDATAADR    ds.w 1     ; 2バイト
WK_CHARCODE       ds.b 1     ; 1バイト

; スプライト関連で扱う変数群
WK_SPRITE0_NUM    ds.b 1     ; 1バイト スプライト番号シャッフル用
WK_SPRREDRAW_FINE ds.b 1     ; 1バイト 仮想VRAM -> VRAM転送許可フラグ
WK_ANIME_PTN      ds.b 1     ; 1バイト アニメーション用パターン番号

; キー入力関連で扱う変数群
WK_KEYIN_INTERVAL ds.b 1     ; 1バイト キー入力受け付けインターバル値
WK_PLAYERDIST     ds.b 1     ; 1バイト 方向キー情報 プレイヤーの進行方向
WK_PLAYERDIST_PRE ds.b 1     ; 1バイト 方向キー情報 プレイヤーの進行方向（前回の方向）
WK_TRIGGERA       ds.b 1     ; 1バイト トリガA判定用(00H:押されてない 11H:押された 12H:押されて離した)
WK_TRIGGERB       ds.b 1     ; 1バイト トリガB判定用(00H:押されてない 11H:押された 12H:押されて離した)

; ダイアログ関連で扱う変数群
WK_DIALOG_INITEND ds.b 1     ; 1バイト

; 汎用変数格納用（VBLANK内でのみ使用許可変数）
WK_VB_VALUE01     ds.b 1     ; 1バイト ワーク用

; 汎用変数格納用
WK_VALUE01        ds.b 1     ; 1バイト ワーク用
WK_VALUE02        ds.b 1     ; 1バイト ワーク用
WK_VALUE03        ds.b 1     ; 1バイト ワーク用
WK_VALUE04        ds.b 1     ; 1バイト ワーク用
WK_VALUE05        ds.b 1     ; 1バイト ワーク用
WK_VALUE06        ds.b 1     ; 1バイト ワーク用
WK_VALUE07        ds.b 1     ; 1バイト ワーク用
WK_VALUE08        ds.b 1     ; 1バイト ワーク用
WK_RANDOM_VALUE   ds.b 1     ; 乱数SEED値格納用

; バブルソート処理で使用する変数群
WK_SORTVALUE01    ds.b 1     ; 1バイト
WK_SORTVALUE02    ds.b 1     ; 1バイト
WK_SORTVALUE03    ds.b 1     ; 1バイト
WK_SORTVALUE04    ds.b 1     ; 1バイト
WK_SORTVALUE05    ds.b 1     ; 1バイト
WK_SORTVALUE06    ds.b 1     ; 1バイト
WK_SORTVALUE07    ds.b 1     ; 1バイト
WK_SORTVALUE08    ds.b 1     ; 1バイト

; 文字列格納用
WK_STRINGBUF      ds.b 1     ; 256バイト

; レジスタ退避用
WK_HLREGBACK      ds.w 1     ; 2バイト HL
WK_DEREGBACK      ds.w 1     ; 2バイト DE
WK_BCREGBACK      ds.w 1     ; 2バイト BC

; ---------------------------------
; ゲーム固有の変数はここに書く
; ---------------------------------

WK_ANGLE          ds.b 1     ; 1バイト (0-63)
WK_POSX           ds.b 1     ; 1バイト
WK_POSY           ds.b 1     ; 1バイト
WK_SURROUNDFLG    ds.b 1     ; 1バイト（全ビットがフラグ）
                             ; MSB:上に壁がある
                             ;   6:下に壁がある
                             ;   5:左に壁がある
                             ;   4:右に壁がある
                             ;   3:上に動ける
                             ;   2:下に動ける
                             ;   1:左に動ける
                             ;   0:右に動ける

WK_JUMPCNT        ds.b 1     ; 1バイト（0:ジャンプしていない 0以外:ジャンプしている)
WK_FALLDOWN       ds.b 1     ; 1バイト（0:落下している 0以外:落下していない）
WK_WALKSPEED      ds.b 1     ; 移動時のキー入力インターバル値
WK_ACCELCNT       ds.b 1     ; 1バイト（加速度カウントアップ：ジャンプしてない状態であればカウントアップ）
WK_XMOVEVAL       ds.b 1     ; 1バイト（X軸の移動ドット数）
WK_MOVESTOPTIME   ds.b 1     ; 1バイト（30/60秒停止していることを判定するタイマー）
WK_SPRPTNCHG      ds.b 1     ; 1バイト（0：スプライトパターンを更新しない 1:更新する）
WK_JUMPSTARTDIST  ds.b 1     ; ジャンプ開始時のプレイヤーの向き
WK_LADDERFLG      ds.b 1     ; ハシゴ昇降フラグ（0;OFF 1:ON）

}

