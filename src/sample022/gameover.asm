GameOverProc:

    ;-------------------------------------------
    ; ここにゲームオーバー時の処理を書きます
    ; WK_GAMESTATUS=4だとH.TIMIが終わったあとで
    ; この処理が必ず呼ばれます
    ;-------------------------------------------

    jp NextHTIMIHook
