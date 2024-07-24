;------------------------------------------
; スプライトパターン再定義テーブル
; VBLANK時にプレイヤーの向きにあわせて
; スプライトパターンテーブルを書き直す
; また、敵キャラパターンの再定義も行う
;------------------------------------------
VBLANK_sprredefine:

  ; プレイヤーのパターン更新フラグが0以外であれば
  ; スプライトパターンを書き換える
  ld a, (WK_SPRPTNCHG)
  or a
  ret z

  ; スプライト番号
  ld hl, SPRPTN_VECT_NUM

  ; 方向キーの値がパターン更新フラグにはセットされる
  ; 方向キーによってパターンデータのアドレスを取得する
  ; 方向キーの値から1引いて4をかけて
  ; WK_ANIME_PTNの値を加算するとパターン番号が取得できる
  dec a
  add a, a ; x2
  add a, a ; x4
  ld b, a
  ld a, (WK_ANIME_PTN)
  add a, b ; + WK_ANIME_PTN

  ld d, 0
  ld e, a
  add hl, de

  ld a, (hl)

  ; パターン番号に8をかけた値をスプライトパターンテーブル
  ; の先頭アドレスに加算すると
  ; プレイヤーの向きのスプライトパターンの先頭アドレスが特定する
  ld h, 0
  ld l, a
  add hl, hl ; x2
  add hl, hl ; x4
  add hl, hl ; x8

  ld de, WK_SPRITE_PTNTBL
  add hl, de

  ; 特定した先頭アドレスから128バイト分を
  ; VRAMのスプライトパターンテーブル#0-#15に転送する

  ; スプライト再描画フラグをOFFにする
  xor a
  ld (WK_SPRREDRAW_FINE), a

  ld de, $3800
  ld bc, 128
  call WRTVRMSERIAL

  ; パターン更新フラグをOFFにする
  xor a
  ld (WK_SPRPTNCHG), a

  ret

SPRPTN_VECT_NUM:
; 1: 上方向
defb 16, 16, 16, 16
; 2: 斜め右上(未使用)
defb 0, 0, 0, 0
; 3: 右方向
defb 32, 48, 32, 64
; 4: 斜め右下(未使用)
defb 0, 0, 0, 0
; 5: 下向き
defb 0, 0, 0, 0
; 6: 斜め左下(未使用)
defb 0, 0, 0, 0
; 7: 左方向
defb 96, 112, 96, 128
; 8: 斜め左上(未使用)
defb 0, 0, 0, 0
; 9: 落下中
defb 192, 0, 192, 0
; 10: ハシゴ上り下り
defb 176, 160, 176, 160
