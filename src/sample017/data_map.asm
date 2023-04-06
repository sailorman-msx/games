;--------------------------------------------
; data_map.asm
; 固定データ(マップ作成用)
;--------------------------------------------
MAPDATA_TITLE:
; タイトル画面の背景
defb "                                " ; + 0
defb "                                " ; + 1
defb "                                " ; + 2
defb "                                " ; + 3
defb "                                " ; + 4
defb "                                " ; + 5
defb "                                " ; + 6
defb "          SUPER BALL            " ; + 7
defb "             PANIC              " ; + 8
defb "                                " ; + 9
defb "                                " ; +10
defb "                                " ; +11
defb "                                " ; +12
defb "                                " ; +13
defb "                                " ; +14
defb "                                " ; +15
defb "    PUSH SPACE OR A BUTTON      " ; +16
defb "            TO START            " ; +17
defb "                                " ; +18
defb "                                " ; +19
defb "                                " ; +20
defb " PRESENTED BY SAILORMAN STUDIO  " ; +21
defb "                                " ; +22
defb "                                " ; +23

MAPDATA_CLEAR:
; クリア画面の背景
defb "                                " ; + 0
defb "                                " ; + 1
defb "                                " ; + 2
defb "                                " ; + 3
defb "     CONGRATULATIONS !          " ; + 4
defb "                                " ; + 5
defb "     YOU ARE PERFECT !          " ; + 6
defb "                                " ; + 7
defb " .............................. " ; + 8
defb "                                " ; + 9
defb "           PRODUCED             " ; +10
defb "        GAME DESIGNED           " ; +11
defb "         BGM AND SFX            " ; +12
defb "              BY                " ; +13
defb "       SAILORMAN STUDIO         " ; +14
defb "                                " ; +15
defb "        SPECIAL THANKS          " ; +16
defb "   SOUND DRIVER BY ABURI6800    " ; +17
defb "             AND                " ; +18
defb "     OTHER MSX PROGRAMMERS      " ; +19
defb "        IN THE WORLD !          " ; +20
defb "                                " ; +21
defb $80, "         SCORE 000000000       " ; +22
defb "AMBIANCE                            " ; +23

MAPDATA_DEFAULT:
; ゲーム背景の描画データ
; MAPデータ非圧縮方式(768バイト)
defb "          TIME=300              " ; + 0
defb $80, "         SCORE 000000000       " ; + 1
defb "################################" ; + 2
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 3
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 4
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 5
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 6
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 7
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 8
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; + 9
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +10
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +11
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +12
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +13
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +14
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +15
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +16
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +17
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +18
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +19
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +20
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +21
defb "#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#" ; +22
defb "################################" ; +23

MAPDATA_BLANKLINE:
defb "                                "
