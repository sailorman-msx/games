;--------------------------------------------
; data.asm
; 固定データ
;--------------------------------------------
; キャラクタパターンとカラーテーブル
CHRPTN:
    defb $80  ; CHAR CODE
    defb $FC, $FC, $FC, $00, $CF, $CF, $CF, $00 ; CHAR PATTERN

    defb $88  ; CHAR CODE
    defb $38, $38, $38, $7C, $BA, $38, $6C, $00 ; CHAR PATTERN

CHRPTN_END:
    defb $00 ; CHAR CODEの部分が00Hであれば処理終了とみなす
