TITLE_MESSAGE_1:
defb " ",$AF, "PUSH TRIG A OR Z KEY TO START " ; LENGTH : 32 byte
TITLE_MESSAGE_2:
defb "PRODUCED BY SAILORMAN STUDIO" ; LENGTH : 28 byte
TITLE_MESSAGE_3:
defb "LANGUAGE",$AF,"ENGLISH " ; LENGTH : 17 byte
TITLE_MESSAGE_4:
defb "LANGUAGE",$AF
defb $E6, $EE, $FD, $DA, $C4, "   "
TITLE_MESSAGE_5:
defb " ",$AF, "TRIG A OR Z KEY TO CONTINUE   " ; LENGTH : 32 byte

MESSAGE_HIT:
defm "HIT "          ; LENGTH : 4 byte
MESSAGE_DAMAGE:
defm "DAMAGE "       ; LENGTH : 7 byte
MESSAGE_MISSTAKE:
defm "MISS"          ; LENGTH : 4 byte
MESSAGE_RESTING:
defm "RESTING.. "    ; LENGTH : 10 byte
MESSAGE_DEFEATED:
defm "BUSTERD!  "    ; LENGTH : 10 byte
MESSAGE_LEVELUP:
defm "LEVEL UP! "    ; LENGTH : 10 byte

; ここから下はダイアログに表示するメッセージ

MESSAGE_DIALOG_SELECTOR:
defb "WEAPON",0      ; LENGTH : 8
defb "DEFENCE",0     ; LENGTH : 8
defb "ORNAMENT",0    ; LENGTH : 8
defb "TOOLS",0       ; LENGTH : 8

MESSAGE_DIALOG_TITLE_ITEMSELECT:
defb "SELECT ITEM",0

MESSAGE_DIALOG_BUTTONS_ITEMSELECT:
defb $A8,"SELECT",$A9,"CLOSE",0

MESSAGE_DIALOG_TITLE_INFORMATION:
defb "INFORMATION",0

MESSAGE_DIALOG_TITLE_GAMECLEAR:
defb "CONGRATULATION",0

MESSAGE_DIALOG_BUTTONS_INFORMATION:
defb $A9,"CLOSE",0

MESSAGE_DIALOG_TITLE_CHOICE:
defb "YOUR CHOICE",0

MESSAGE_DIALOG_TITLE_RINGSHOP:
defb "RING SHOP",0

MESSAGE_DIALOG_BUTTONS_RINGSHOP:
defb $A8,"YES",$A9,"NO",0

; アイテム一覧メッセージ集

; アイテム一覧のメッセージ最大長は14

MESSAGE_ITEMLIST_MESSAGEBLANK:
defb "              ",0

MESSAGE_ITEMLIST_MESSAGE00:
defb " - NO ITEMS - ",0

; 攻撃アイテム名
MESSAGE_ITEMLIST_MESSAGE01:
defb "SHORT SWORD",0      ; STR+1
defb "LONG SWORD",0          ; STR+2
defb "DIAMOND SWORD",0   ; STR+3 スケルトンと騎士には+4効果
defb "MAGE SLAYER",0     ; STR+4 魔法使いとMAGEには+5効果

; 防御アイテム名
MESSAGE_ITEMLIST_MESSAGE02:
defb "LEATHER ARMOR",0   ; DEF+1
defb "HARD ARMOR",0      ; DEF+2
defb "CHAIN MAIL",0      ; DEF+3
defb "DIAMOND ARMOR",0   ; DEF+4

; 装飾品アイテム名
MESSAGE_ITEMLIST_MESSAGE03:
defb "POWER RING",0      ; 30秒間プレイヤーのダメが1.5倍 JUNK 5で購入
defb "FIRE RING",0       ; 30秒間プレイヤーのWOODYとSKELTONに対するダメが2倍 JUNK 5で購入
defb "LIGHT RING",0      ; LV4が見える、ピープホールが常に5になる JUNK 5で購入
defb "SPELLOFF RING",0   ; 30秒間テキキャラがファイアボールを出さなくなる JUNK 5で購入

; 道具アイテム名
MESSAGE_ITEMLIST_MESSAGE04:
defb "HEART 1UP",0      ; 体力+7 使うと消える
defb "FULL RECOVER",0   ; 体力が全回復する 使うと消える
defb "STATUS RECOVER",0 ; ステータス異常回復 使うと消える
defb "YELLOW KEY",0     ; 黄色鍵 使うと消える
defb "BLUE KEY",0       ; 青色鍵 使うと消える
defb "RAINBOW KEY",0    ; 虹色鍵 使うと消える
defb "TORCH",0          ; ロウソク 使うと消える
defb "ENTRY PASS",0     ; 通行証（山岳に行ける）使っても消えない
defb "JUNK",0           ; ガラクタ 使うと消える 使用効果なし

; 使いますか？
MESSAGE_ITEMLIST_MESSAGE10:
defb "YOUR CHOICE.",0

; 使う
MESSAGE_ITEMLIST_MESSAGE11:
defb "USE IT",0

; （装備を）外す
MESSAGE_ITEMLIST_MESSAGE12:
defb "REMOVE",0

; 捨てる
MESSAGE_ITEMLIST_MESSAGE13:
defb "DISCARD",0

; INFORMATIONメッセージ集
;
; メッセージの1行の文字数は最大16文字
; 最大行数は13行
;

MESSAGE_DIALOG_MESSAGE_CORRIDOR_RETURN_EN:
defb "WHAT HAPPENED ??"
defb 0 ; EoD

MESSAGE_DIALOG_MESSAGE_CORRIDOR_RETURN_JP:
; まえにきたは゛しょた゛
defb "??",$EF, $D4, $E6, $D7, $E0, $EA, $C4, $DC, $CE, $E0, $C4
defb 0 ; EoD

MESSAGE_DIALOG_MESSAGE_PICKTREASUREBOX:
defb "YOU PICKED UP",$5C
defb "SOMETHING."
defb 0

MESSAGE_DIALOG_MESSAGE_PICKITEMFULL:
defb "LOTS OF BAGGAGE."
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_SUFFICIENCY_EN:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb "HOW DID YOU FIND THIS PLACE ?", $5C
defb "JUNK BECOMES A", $5C
defb "RING WHEN I BEAT IT.", $5C
defb "DO YOU WANT TO  TRADE ?"
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_SUFFICIENCY_JP:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
; よくここか゛わかったね
defb $F6, $D8, $DA, $DA, $D6, $C4, $FC, $D6, $CF, $E0, $E8, $5C
; と゛んなか゛らくたも
defb $E4, $C4, $FD, $E5, $D6, $C4, $F7, $D8, $E0, $F3, $5C
; わたしか゛たたけは゛
defb $FC, $E0, $DC, $D6, $C4, $E0, $E0, $D9, $EA, $C4, $5C
; ゆひ゛わになる
defb $F5, $EB, $C4, $FC, $E6, $E5, $F9, $F6, $5C, $5C
; ゆひ゛わとこうかんするかい?
defb $F5, $EB, $C4, $FC, $E4, $DA, $D3, $D6, $FD, $DD, $F9, $D6, $D2, "?"
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_CANNOTBUY_EN:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb "NOT ENOUGH",$5C,"FOR EXCHANGE."
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_CANNOTBUY_JP:
; たりないね
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb $E0, $F8, $E5, $D2, $E8, $5C
defb 0

; またきてね
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb $EF, $E0, $D7, $E3, $E8
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_BUY_EN:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb "I GIVE THIS YOU.", $5C
defb "GOOD LUCK."
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_BUY_JP:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
; これをあけ゛るよ
defb $DA, $FA, $C6, $D1, $D9, $C4, $F9, $F6, $5C
; か゛んは゛ってね
defb $D6, $C4, $FD, $EA, $C4, $CF, $E3, $E8
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_HAVED_EN:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb "IS THAT RING", $5C
defb "USEFUL ?"
defb 0

MESSAGE_DIALOG_MESSAGE_JUNK_HAVED_JP:
; そのゆひ゛わはへ゛んりた゛よ
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb $DF, $E9, $F5, $EB, $C4, $FC, $EA, $ED, $C4, $FD, $F8, $E0, $C4, $F6
defb 0

MESSAGE_DIALOG_MESSAGE_DONOTENTER_EN:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
defb "IT",$2F,"S DANGEROUS FROM HERE ON.",$5C,"IF YOU DON",$2F,"T HAVE A PASSPORT.",$5C,"YOU CAN",$2F,"T GET THROUGH."
defb 0

MESSAGE_DIALOG_MESSAGE_DONOTENTER_JP:
defb $5C
defb $B0, $B2, $5C
defb $B1, $B3, $5C, $5C
; ここからさきは
defb $DA, $DA, $D6, $F7, $DB, $D7, $EA, $5C
; PASSPORTか゛ないと
defb "PASSPORT ", $D6, $C4, $E5, $D2, $E4, $5C
; とおれないよ
defb $E4, $D5, $FA, $E5, $D2, $F6, $20
; きけんた゛からね
defb $D7, $D9, $FD, $E0, $C4, $D6, $F7, $E8
defb 0

; ゲーム開始メッセージ
MESSAGE_DIALOG_MESSAGE_GAME_START_EN:
defb "THE WORLD IS FILLED WITH LIES.",$5C
defb "EVERY TIME A MAN LIES.THEY TURN INTO A MAGICIAN.",$5C
defb "APPARENTLY.IT IS THE PLAN OF A MOUNTAIN MAGE.",$5C
defb "DEFEAT THE MAGE AND RETURN THE WORLD.",$5C
defb 0

MESSAGE_DIALOG_MESSAGE_GAME_START_JP:
; せかいか゛うそた゛らけになってきた
defb $DE, $D6, $D2, $D6, $C4, $D3, $DF, $E0, $C4, $F7, $D9, $E6, $E5, $CF, $E3, $D7, $E0,$5C
; さいきんて゛はとうさんもうそをへいきて゛つくようになった
defb $DB, $D2, $D7, $FD, $E3, $C4, $EA, $E4, $D3, $DB, $FD, $F3, $D3, $DF, $C6, $ED, $D2, $D7, $E3, $C4, $E2, $D8, $F6, $D3, $E6, $E5, $CF, $E0, $5C
; おとなはみんなうそをつくのか゛へいきになったみたいた゛
defb $D5, $E4, $E5, $EA, $F0, $FD, $E5, $D3, $DF, $C6, $E2, $D8, $E9, $D6, $C4, $ED, $D2, $D7, $E6, $E5, $CF, $E0, $F0, $E0, $D2, $E0, $C4, $5C
; うそをつくたひ゛にまし゛ゅつしになるみたいた゛
defb $D3, $DF, $C6, $E2, $D8, $E0, $EB, $C4, $E6, $EF, $DC, $C4, $CD, $E2, $DC, $E6, $E5, $F9, $F0, $E0, $D2, $E0, $C4, $5C
; と゛うやらまと゛うしか゛そういうせかいをつくろうとしているらしい
defb $E4, $C4, $D3, $F4, $F7, $EF, $E4, $C4, $D3, $DC, $D6, $C4, $DF, $D3, $D2, $D3, $DE, $D6, $D2, $C6, $E2, $D8, $FB, $D3, $E4, $DC, $E3, $D2, $F9, $F7, $DC, $D2
; やまにすむまと゛うしをたおして
defb $F4, $EF, $E6, $DD, $F1, $EF, $E4, $C4, $D3, $DC, $C6, $E0, $D5, $DC, $E3, $5C
; もとのせかいにもと゛そう
defb $F3, $E4, $E9, $DE, $D6, $D2, $E6, $F3, $E4, $C4, $DF, $D3, "!"
defb 0

; ゲームオーバー
MESSAGE_GAMEOVER:
defb "GAME OVER",0

; ここから下はシナリオメッセージ
MESSAGE_DIALOG_SCN1MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "THERE IS A LEGENDARY WEAPON UNDER THE GROUND HERE."
defb 0
MESSAGE_DIALOG_SCN1MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; ここのちかにて゛んせつのふ゛きか゛ねむっている
defb $DA, $DA, $E9, $E1, $D6, $E6, $E3, $C4, $FD, $DE, $E2, $E9, $EC, $C4, $D7, $D6, $C4, $E8, $F1, $CF, $E3, $D2, $F9
defb 0

MESSAGE_DIALOG_SCN2MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "FROM SOMEWHERE. YOU HEAR SOMETHING BANGING."
defb 0

MESSAGE_DIALOG_SCN2MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; と゛こからかなにかをたたくおとか゛きこえる
defb $E4, $C4, $DA, $D6, $F7, $D6, $E5, $E6, $D6, $C6, $E0, $E0, $D8, $D5, $E4, $D6, $C4, $D7, $DA, $D4, $F9
defb 0

MESSAGE_DIALOG_SCN3MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "OH!THIS PLACE AGAIN!"
defb 0

MESSAGE_DIALOG_SCN3MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; ああ!またこのは゛しょた゛!
defb $D1, $D1, "!", $EF, $E0, $DA, $E9, $EA, $C4, $DC, $CE, $E0, $C4, "!"
defb 0

MESSAGE_DIALOG_SCN4MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "THE MAGE",$2F,"S CASTLE IS IN DARKNESS."
defb 0

MESSAGE_DIALOG_SCN4MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; まと゛うしのしろはやみにつつまれている
defb $EF, $E4, $C4, $D3, $DC, $E9, $DC, $FB, $EA, $F4, $F0, $E6, $E2, $E2, $EF, $FA, $E3, $D2, $F9
defb 0

MESSAGE_DIALOG_SCN5MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "SOMEDAY YOU WILL LIE TOO.",$5C
defb "YOU",$2F,"D BETTER GO HOME QUIETLY."
defb 0

MESSAGE_DIALOG_SCN5MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; いつかきみもうそをつくようになる
defb $D2, $E2, $D6, $D7, $F0, $F3, $D3, $DF, $C6, $E2, $D8, $F6, $D3, $E6, $E5, $F9, $5C
; おとなしくいえにかえったほうか゛いい
defb $D5, $E4, $E5, $DC, $D8, $D2, $D4, $E6, $D6, $D4, $CF, $E0, $EE, $D3, $D6, $C4, $D2, $D2
defb 0

MESSAGE_DIALOG_SCN6MSG_EN:
defb $5C,"MAGE",$2F,"S CASTLE"
defb 0

MESSAGE_DIALOG_SCN6MSG_JP:
; まと゛うしのしろ
defb $EF, $E4, $C4, $D3, $DC, $E9, $DC, $FB
defb 0

MESSAGE_DIALOG_SCN7MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "ADULTS WANT ",$5C
defb $2F,"MONEY",$2F,"."
defb 0

MESSAGE_DIALOG_SCN7MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; おとなか゛ほしか゛るものはおかねた゛
defb $D5, $E4, $E5, $D6, $C4, $EE, $DC, $D6, $C4, $F9, $F3, $E9, $EA, $D5, $D6, $E8, $E0, $C4
defb 0

MESSAGE_DIALOG_SCN8MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "PEOPLE ARE WILLING TO LIE FOR MONEY.",$5C
defb "THIS IS THE MOST RIDICULOUS THING I",$2F,"VE EVER HEARD."
defb 0

MESSAGE_DIALOG_SCN8MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
defb $D5, $D6, $E8, $E9, $E0, $F2, $E5, $F7, $D3, $DF, $C6, $E2, $D8, $E9, $F3, $E5, $FD, $E4, $F3, $D5, $F3, $FC, $E5, $D2, $5C
; は゛かは゛かしいとおもわないか
defb $EA, $C4, $D6, $EA, $C4, $D6, $DC, $D2, $E4, $D5, $F3, $FC, $E5, $D2, $D6
defb 0

MESSAGE_DIALOG_SCN9MSG_EN:
defb "YOU HEARD VOICES.",$5C
defb "MONEY IS A NOTION.PEOPLE GO CRAZY OVER THAT NOTION."
defb 0

MESSAGE_DIALOG_SCN9MSG_JP:
; こえか゛きこえる
defb $DA, $D4, $D6, $C4, $D7, $DA, $D4, $F9, $5C
; おかねはか゛いねんた゛
defb $D5, $D6, $E8, $EA, $D6, $C4, $D2, $E8, $FD, $E0, $C4, $5C
; か゛いねんのためにみんなくるうのた゛
defb $D6, $C4, $D2, $E8, $FD, $E9, $E0, $F2, $E6, $F0, $FD, $E5, $D8, $F9, $D3, $E9, $E0, $C4
defb 0

MESSAGE_DIALOG_GAME_CLEAR_EN:
defb "YOU HAVE DEFEATED THE MAGE.",$5C
defb "THE CRAZY NOTIONS HAVE SUBSIDED.",$5C
defb "IF YOU",$2F,"RE NOT CAREFUL. SOMEDAY YOU TOO WILL LOSE YOURSELF IN THE NOTION.",$5C
defb "BE HONESTY."
defb 0

MESSAGE_DIALOG_GAME_CLEAR_JP:
; まと゛うしをたおした
defb $EF, $E4, $C4, $D3, $DC, $C6, $E0, $D5, $DC, $E0, $5C
; おとなたちはへいおんをとりもと゛した
defb $D5, $E4, $E5, $E0, $E1, $EA, $ED, $D2, $D5, $FD, $C6, $E4, $F8, $F3, $E4, $C4, $DC, $E0, $5C
; きをつけないときみもか゛いねんにとりつかれることになる
defb $D7, $C6, $E2, $D9, $E5, $D2, $E4, $D7, $F0, $F3, $D6, $C4, $D2, $E8, $FD, $E6, $E4, $F8, $E2, $D6, $FA, $F9, $DA, $E4, $E6, $E5, $F9, $5C
; せいし゛つにいきろ
defb $DE, $D2, $DC, $C4, $E2, $E6, $D2, $D7, $FB
defb 0
