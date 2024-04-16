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

;--------------------------------
; アドレスUNION領域
; 変数領域確保前のみ使用可能とする
;--------------------------------
WK_UNIONRAM:equ $C800       ; 2048バイト

;--------------------------------
; ここから変数
;--------------------------------
DEFVARS $C000
{

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
WK_VRAM4X4_TBL    ds.b 16    ; 16バイト VRAM情報格納テーブル
WK_NUMTOCHARVAL   ds.b 1     ; 数値格納用バッファ(この値を文字化してWK_STRINGBUFにセットする)
WK_CHARDATAADR    ds.w 1     ; 2バイト
WK_CHARCODE       ds.b 1     ; 1バイト

; スプライト関連で扱う変数群
WK_SPRITE0_NUM    ds.b 1     ; 1バイト スプライト番号シャッフル用
WK_SPRREDRAW_FINE ds.b 1     ; 1バイト 仮想VRAM -> VRAM転送許可フラグ
WK_SPRITE_MOVETBL ds.b 512   ; 16バイトx32体分 512バイト
WK_ANIME_PTN      ds.b 1     ; 1バイト アニメーション用パターン番号

; キー入力関連で扱う変数群
WK_KEYIN_INTERVAL ds.b 1     ; 1バイト キー入力受け付けインターバル値
WK_PLAYERDIST     ds.b 1     ; 1バイト 方向キー情報 プレイヤーの進行方向
WK_TRIGGERA       ds.b 1     ; 1バイト トリガA判定用(00H:押されてない 11H:押された 12H:押されて離した)
WK_TRIGGERB       ds.b 1     ; 1バイト トリガB判定用(00H:押されてない 11H:押された 12H:押されて離した)

; ダイアログ関連で扱う変数群
WK_DIALOG_INITEND ds.b 1     ; 1バイト

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

}

;--------------------------------
; スプライトシャッフル用テーブル
;--------------------------------
DEFVARS $CF00
{

WK_SHUFFLE_ATTRTBL ds.b 128  ; 128バイト

}

;--------------------------------
; 仮想VRAM格納用
;--------------------------------

; パターンネームテーブル(768バイト)
DEFVARS $D000
{

WK_VIRT_PTNNAMETBL ds.b 768

}

;--------------------------------
; 仮想スプライトアトリビュートテーブル(128バイト)
;--------------------------------

DEFVARS $D300
{

WK_VIRT_SPRATTRTBL ds.b 128

}
