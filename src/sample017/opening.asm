;--------------------------------------------------
; opening.asm 
; オープニング画面処理
; WK_GAMESTATUSの値が1の時に1/60秒ごとに呼び出される
; WK_GAMEINTTIMEの数が0になるまで呼び出される
;--------------------------------------------------
OpeningProc:
OpeningProcEnd:
    jp VSYNC_Wait

