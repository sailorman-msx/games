;--------------------------------------------
; initialize.asm
; 初期処理
; 変数が増える場合はこちらに記述すること！
;--------------------------------------------
; BIOSルーチン
M_REDVRM:equ $004A ; VRAMの内容をAレジスタに読み込む
M_WRTVRM:equ $004D ; VRAMのアドレスにAレジスタの値を書き込む
M_SETRED:equ $0050 ; VRAMからデータを読み込める状態にする
M_SETWRT:equ $0053 ; VRAMにデータを書き込める状態にする
M_FILVRM:equ $0056 ; VRAMの指定領域を同一のデータで埋める
M_LDIRMV:equ $0059 ; VRAMからRAMにブロック転送する
M_LDIRVM:equ $005C ; RAMからVRAMにブロック転送する
CHGMOD:equ $005F ; SCREENモードを変更する
SETGRP:equ $007E ; VDPのみをGRAPHIC2モードにする
GICINI:equ $0090 ; PSGの初期化アドレス
WRTPSG:equ $0093 ; PSGレジスタへのデータ書込アドレス
ERAFNK:EQU $00CC ;ファンクションキーを非表示にする
GTSTCK:equ $00D5 ; JOY STICKの状態を調べる
GTTRIG:equ $00D8 ; トリガボタンの状態を返す
CHGCLR:equ $0111 ; 画面の色を変える
SNSMAT:equ $0141 ; キーボード判定
KILBUF:equ $0156 ; キーボードバッファをクリアする

; BIOSルーチン(SUB-ROM用)
EXTROM:equ $015F ; SUB-ROMインタースロットコール
SETPLT:equ $014D ; カラーパレットの設定

; ワークエリア
LINWID:equ $F3AF ; WIDTHで設定する1行の幅が格納されているアドレス
RG0SAV:equ $F3DF ; VDPレジスタ#0の値が格納されているアドレス
FORCLR:equ $F3E9 ; 前景色が格納されているアドレス
BAKCLR:EQU $F3EA ; 背景色のアドレス
BDRCLR:equ $F3EB ; 背景色が格納されているアドレス
CLIKSW:equ $F3DB ; キークリック音のON/OFFが格納されているアドレス
INTCNT:equ $FCA2 ; MSX BIOSにて1/60秒ごとにインクリメントされる値が格納されているアドレス
H_TIMI:equ $FD9F ; 垂直帰線割り込みフック
H_PHYDIO:equ $FFA7 ; 物理FDD装着時のフック

; カラーパレット設定用
ISMSX1FLG:equ $002D ; 0でなければMSX1ではないと判定する

; MSX-DOSからSUB-ROMを呼び出す場合のおまじない
CALSLT:equ $001C ; CALSLT
H_NMI:equ $015F  ; H.NMIフック
EXPTBL:equ $FCC1

; 8000H以降も使えるようにするおまじない
RSLREG:equ $0138
ENASLT:equ $0024

;--------------------------------------------
; 変数領域
;--------------------------------------------
WK_STRINGBUF:equ $C000      ; 48バイト

; スプライト座標格納用
WK_PLAYERPOSX:equ $C030     ; 1バイト
WK_PLAYERPOSY:equ $C031     ; 1バイト
WK_PLAYERPOSXOLD:equ $C032  ; 1バイト
WK_PLAYERPOSYOLD:equ $C033  ; 1バイト

WK_PLAYERDIST:equ $C034     ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)
WK_PLAYERDISTOLD:equ $C035  ; 1バイト（プレイヤーの向き:1=上,5=下,7=左,3=右)

; #1から始まり#2->#1->#0->#1->#2.. という順で値を書き換える
; #2になったら減算、#0になったら加算していく
WK_PLAYERANIMECNT:equ $C036 ; 1バイト
WK_PLAYERANIMEVAL:equ $C037 ; 1バイト

WK_PLAYERMOVE_X:equ $C038   ; 1バイト（プレイヤーのX移動量）
WK_PLAYERMOVE_Y:equ $C039   ; 1バイト（プレイヤーのY移動量）

WK_PLAYERSPRCLR1:equ $C03A  ; 1バイト（スプライト1枚目：プレイヤー髪の毛)
WK_PLAYERSPRCLR2:equ $C03B  ; 1バイト（スプライト2枚目：プレイヤー肌の色)
WK_PLAYERSPRCLR3:equ $C03C  ; 1バイト（スプライト3枚目：プレイヤーアイテム）

WK_SPRITEPOSX:equ $C03D     ; 1バイト
WK_SPRITEPOSY:equ $C03E     ; 1バイト

; キーイン情報

; 通常モードでのトリガ情報
WK_TRIGGER:equ $C040        ; 1バイト(0:TRIGGER OFF, 1:TRIGGER ON)

; ダイアログモードでのトリガ情報
WK_TRIGGERA:equ $C041       ; 1バイト(0:押されていない 1:押された 2:押されたあとに戻した)
WK_TRIGGERB:equ $C042       ; 1バイト(0:押されていない 1:押された 2:押されたあとに戻した)

; キーインのインターバル 
; この値が0の時のみキー、ジョイスティック、トリガ乳力を
; 受け付ける
WK_KEYIN_INTERVAL:equ $C043 ; 1バイト

; 処理モード
; 0: title
; 1: opening
; 2: game main
; 3: ダイアログ表示モード
; 4: game over
; 5: game clear
WK_GAMESTATUS:equ $C044     ; 1バイト

; 処理モード遷移時のインターバル値
; この値が0になってはじめて処理モードが移行する
WK_GAMESTATUS_INTTIME:equ $C045 ; 1バイト

; 休憩タイマー
; 0になるとタイムアウト
WK_REST_COUNTDOWN:equ $C046 ; 1バイト

; 汎用カウンタ
WK_LOOP_COUNTER:equ $C048         ; 1バイト

; 10/60秒のタイミングを測る変数
; この値が0のときに1800Hに仮想パターンネームテーブルの情報を
; 転送する
WK_TIME10:equ $C049        ; 1バイト

; マップ切替カウンタ
; 画面切替時の処理種別がセットされる
; 初期値は3
; 1/60秒ごとにデクリメントされる
; 数値によって処理を変更する
;
; 3 : スプライトを消す
; 2 : ChangeMapを呼び出す
; 1 : なにもしない（予備）
; 0 : なにもしない
;
WK_MAPCHANGE_COUNT:equ $C04A        ; 1バイト

; 敵再生成処理のアドレス
WK_ENEMY_RESPAWN:equ $C04B          ; 2バイト

; 剣の処理カウンタ
; 5-4: 攻撃力が1.5倍
; 3-1: 攻撃力は1.0倍
; 0  : 剣を引っ込める
WK_SWORDACTION_COUNT:equ $C04D      ; 1バイト

; VDPポート番号定数
; vram.asmで使用する
CONST_VDPPORT0:equ $98   
CONST_VDPPORT1:equ $99

; VRAMデータ退避用
; パターンジェネレータテーブルのコピーで使用する
; TODO: 800H(2048)バイトはちょっと無駄がおおすぎ
WK_VRAMTORAM:equ $C050   ; 0800Hバイト(C050H - C84FH)

; 16bitレジスタ値退避用変数
; HLレジスタ退避用
WK_HLREGBACK:equ $C850   ; 2バイト
; DEレジスタ退避用
WK_DEREGBACK:equ $C852   ; 2バイト
; BCレジスタ退避用
WK_BCREGBACK:equ $C854   ; 2バイト

; 背景の障害物との当たり判定用
; 仮想パターンネームテーブルを使って当たり判定を行う
WK_CHECKPOSX:equ $C856   ; 1バイト
WK_CHECKPOSY:equ $C857   ; 1バイト
WK_CONFLICTX:equ $C858   ; 1バイト
WK_CONFLICTY:equ $C859   ; 1バイト
WK_VRAM4X4_TBL:equ $C85A ; 16バイト(C85AH - C869H)

; PCGキャラクタデータ作成用
WK_CHARDATAADR:equ $C86A ; 2バイト
WK_CHARCODE:equ $C86C    ; 1バイト

; 乱数格納用変数 
WK_RANDOM_VALUE:equ $C86D; 1バイト

; 画面描画完了フラグ
; このフラグが1の時には
; 仮想パターンネームテーブルから1800Hへの転送を許可する
WK_REDRAW_FINE:equ $C86E  ; 1バイト

; スプライト描画完了フラグ
; このフラグが1の時には
; 仮想スプライトアトリビュートから1B00Hへの転送を許可する
WK_SPRREDRAW_FINE:equ $C86F  ; 1バイト

;
; スプライト座標管理用
;  敵14体分 14体x最大2スプライト(28スプライト)x16byte +
;  プレイヤースプライト3体分3スプライト 3x16 = 368 byte +
;  プレイヤーの弾1スプライト = 16 byte
;  計：512 byte
;
; +0 : スプライト種別
;      $00: スプライトなし
;      $01: スライム
;      $02: ウイスプ
;      $03: ウイザード
;      $04: WOODY MONSTER
;      $05: スケルトン
;      $0A: FireBall
;      $E0: 当たりマーク
;      $FD: プレイヤーの弾
;      $FE: プレイヤーの剣
;      $FF: プレイヤー
; +1 : Y座標(0-191)           -> WK_SHUFFLE_ATTRTBLに転送する
; +2 : X座標(0-255)           -> WK_SHUFFLE_ATTRTBLに転送する
; +3 : スプライトパターン番号 -> WK_SHUFFLE_ATTRTBLに転送する
; +4 : スプライトカラー番号   -> WK_SHUFFLE_ATTRTBLに転送する
; +5 : 移動方向(移動方向0の場合は生成直後であると判定に使う）
; +6 : X移動量
; +7 : Y移動量
; +8 : 攻撃力
; +9 : 防御力
; +A : 生命力
; +B : 弾発射状態
;      発射時: WK_SPRITE_MOVE_TBLの該当アドレス(2バイト)
;      $0000 : 未発射状態
;      ＜プレイヤーの場合＞
;      $0001 : 剣を使用している
;      $0002 : アムレットを使用している
; +D : アイテムドロップ確率(0-255)
; +E : テキキャラのレベル
; +F : 移動インターバル
;
WK_SPRITE_MOVETBL:equ $C870 ; 512バイト(C870H - CA6FH)

; 画面再描画判定フラグ
; 1: 画面(1800H)を再描画する
; 0: 画面を描画しない
WK_REDRAW_FLG:equ $CA70 ; 1バイト

; 画面再描画判定フラグ用の定数
CONST_REDRAW_ON:equ 1
CONST_REDRAW_OFF:equ 0

; 移動禁止フラグ
; 障害物に当たった、もしくはマップ切替直後に1
; それ以外は0
WK_NOTMOVE_FLG:equ $CA71 ; 1バイト

; 移動禁止フラグ用の定数
CONST_NOTMOVE_ON:equ 1
CONST_NOTMOVE_OFF:equ 0

; ピープホール径（タイル単位ではなくキャラクタ単位）
; この変数が0でない場合は
; プレイヤーを中心に縦横分だけを可視化する
WK_PEEPHOLE:equ $CA72       ; 1バイト

; ピープホール処理用変数
WK_MAP_PEEPBASEX:equ $CA73  ; 1バイト(ピープホール基準X)
WK_MAP_PEEPBASEY:equ $CA74  ; 1バイト(ピープホール基準Y)
WK_MAP_PEEPX:equ $CA75      ; 1バイト(ピープホール基準X)
WK_MAP_PEEPY:equ $CA76      ; 1バイト(ピープホール基準Y)
WK_PEEPHOLEMINX:equ $CA77   ; 1バイト(ピープホールの横幅計算用)
WK_PEEPHOLEMAXX:equ $CA78   ; 1バイト(ピープホールの横幅計算用)
WK_PEEPHOLEWIDTH:equ $CA79  ; 1バイト(ピープホール描画時の横幅)
WK_PEEPHOLEMINY:equ $CA7A   ; 1バイト(ピープホールの縦幅計算用)
WK_PEEPHOLEMAXY:equ $CA7B   ; 1バイト(ピープホールの縦幅計算用)
WK_PEEPHOLEHEIGHT:equ $CA7C ; 1バイトピープホール描画時の縦幅)

; プレイヤーのライフポイント
; ライフゲージ表示処理用
WK_PLAYERLIFEPOINT:equ $CA7D    ; 10バイト(CA7D - CA86)
                                ; 1バイトには0-7の値が入る
WK_PLAYERLIFESUM:equ $CA87      ; 1バイト ライフポイントの加減算値
WK_PLAYERLIFEVAL:equ $CA88      ; 1バイト
WK_PLAYERLIFEMAX:equ $CA89      ; 1バイト

WK_ENEMYLIFEPOINT:equ $CA8A     ; 7バイト(CA8A - CA91)
                                ; 1バイトには0-7の値が入る
WK_ENEMYLIFESUM:equ $CA91       ; 1バイト ライフポイントの加減算値
WK_ENEMYLIFEVAL:equ $CA92       ; 1バイト

WK_NUMTOCHARVAL:equ $CA93       ; 1バイト
WK_NUMTOCHAR:equ $CA94          ; 3バイト(0から255までの数値のキャラクタが格納される)

; プレイヤーの所持アイテム
; 00: アイテム所持なし
; - 攻撃アイテム
; 01: 水色剣(STR+1)    LONG SWORD
; 02: 薄青色剣(STR+2)  SOUL SWORD
; 03: 濃赤剣(STR+3)    UNDEAD SWORD
; 04: 白色剣(STR+4)    MAZE SLAYER
; - 防御アイテム
; 01: 水色防具(DEF+1)  NORMAL MAIL
; 02: 薄青防具(DEF+2)  HARD MAIL
; 03: 濃赤防具(DEF+3)  CHAIN MAIL
; 04: 白色防具(DEF+4)  IRON MAIL
; - 装飾アイテム
; 01: 力の指輪         POWER RING
; 02: 炎の指輪         FIRE RING
; 03: 光の指輪         LIGHT RING
; 04: 沈黙の指輪       SPELLOFF RING
; - 道具アイテム
; 01: ハート+7           
; 02: ハート全回復
; 04: ステータス異常回復
; 05: 黄色鍵
; 06: 青色鍵
; 07: ロウソク
; 08: PASSPORT
; 09: ガラクタ(JUNK)

; 攻撃アイテムスロット
WK_STRITEMSLOT:equ $CA97        ; 4バイト(CA97 - CA9A)

; 防御アイテムスロット
WK_DEFITEMSLOT:equ $CA9B        ; 4バイト(CA9B - CA9E)

; 装飾品アイテムスロット
WK_RINGITEMSLOT:equ $CA9F       ; 4バイト(CA9F - CAA2)

; 道具アイテムスロット
; ※最大保持個数は18とする
WK_TOOLITEMSLOT:equ $CAA3       ; 20バイト(CAA3 - CAB6)

; 下矢印アイコンの位置
WK_DOWNARROWICON_POS:equ $CAB7  ; 1バイト

; 右矢印アイコンの位置
WK_RIGHTARROWICON_POS:equ $CAB8 ; 1バイト

; アイテム一覧の先頭行インデックス
WK_ITEMLISTPOS:equ $CAB9        ; 1バイト

; ロウソク本数テーブル
; ロウソク本数はロウソクアイテムを使うと
; 4バイトにロウソクキャラコードがセットされ
; 2分ごとに1本ずつ減っていく
WK_TORCH_TBL:equ $CABA          ; 4バイト

; ロウソク本数デクリメントカウンタ
; ロウソク使用時もしくはロウソク本数の
; デクリメント時間に600が設定される
; 1/60秒ごとにデクリメントされ
; 0になったらロウソク本数テーブルの
; 最後尾のキャラクタコードを$24にする
WK_TORCH_TIMER:equ $CABE        ; 2バイト(0 - 10800)

; ダイアログ種別
; 0=ダイアログ非表示 1=アイテム選択 2=情報表示 
; 3=SHOP 4=SHOP(購入不可) 5=SHOP(購入した) 6=SHOP(すでに持ってる)
; 7=山岳地帯へのガードマン（処理はショップ同様とする）
; 8=ゲームクリア
WK_DIALOG_TYPE:equ $CAC0        ; 1バイト

; 選択ポップアップ
; ダイアログに上書きする形で選択ポップアップを表示する
; 選択ポップアップ中の操作はアイテム選択画面には
; 反映されない
WK_SELECT_BOX:equ $CAC1                 ; 1バイト 0=選択ボックス非表示 1=選択ボックス表示中
WK_SELECT_BOX_CHOICE_TYPE:equ $CAC2     ; 1バイト
WK_SELECT_BOX_CHOICE_SLOTNUM:equ $CAC3  ; 1バイト

WK_ARROW_POS_BK1:equ $CAC4      ; 1バイト アイテム一覧先頭インデックス
WK_ARROW_POS_BK2:equ $CAC5      ; 1バイト 右矢印アイコン位置

; アイテム使用フラグ
; この値が1の場合、アイテム選択が行われたと判断し
; アイテム使用ルーチンを呼び出す
WK_USED_ITEM:equ $CAC6          ; 1バイト

; 装備中アイテム
WK_EQUIP_STR:equ $CAC7          ; 攻撃用装備 1バイト
WK_EQUIP_DEF:equ $CAC8          ; 防御用装備 1バイト
WK_EQUIP_RING:equ $CAC9         ; 装飾用装備 1バイト

; 攻撃アイテム装備時の補正値
WK_EQUIP_ADJSTR:equ $CACA       ; 攻撃力補正値 1バイト
WK_EQUIP_ADJDEF:equ $CACB       ; 防御力補正値 1バイト

; ゲームスタートフラグ
WK_GAME_STARTFLG:equ $CACC      ; 1バイト 0=ゲーム開始直後 1=すでにゲーム開始中

; 表示メッセージアドレス
WK_DISP_DIALOG_MESSAGE_ADR:equ $CACD ; 2バイト
WK_DISP_DIALOG_MESSAGE_LEN:equ $CACF ; 1バイト

; ミッションステータス値
; 10でレベルアップする
WK_MISSION_STATUSVAL:equ $CAD0

; アイテムスロットソート用
WK_SLOT_SORTBUF:equ $CAD1       ; 20バイト(CACF - CAE5)

; 剣を振れるインターバル値
WK_SWORD_REUSE_COUNT:equ $CAE6  ; 1バイト

; 背景色を変えるタイミング
; 0 = 色変更なし
; 1 = 赤に変更する
; 2 = 赤に変更した
; 3 = 青に変更する
; 4 = 青に変更した
WK_BGCOLOR_CHGFLG:equ $CAE7     ; 1バイト

; BGMが終わったことを示すフラグ
; BGM開始時に0にすること！
WK_AKGSOUND_END:equ $CAE8       ; 1バイト

; プレイヤーがダメージを受けた場合
; 1がセットされる
; プレイヤーが勝った場合は2がセットされる
WK_PLAYER_COLLISION:equ $CAE9   ; 1バイト

; テキキャラがダメージを受けた場合
; 1がセットされる
WK_ENEMY_COLLISION:equ $CAEA    ; 1バイト

WK_PH_HLREGBACK:equ $CAEB       ; 2バイト
WK_PH_DEREGBACK:equ $CAED       ; 2バイト

; 処理対象テキキャラカウンタ
WK_MOVE_ENEMY_COUNTER:equ $CAF0 ; 1バイト

; 倒したテキキャラの種別
WK_BUSTERD_ENEMY_TYPE:equ $CAF1 ; 1バイト

; 宝箱の表示座標
WK_TREASUREBOX_X:equ $CAF2      ; 1バイト
WK_TREASUREBOX_Y:equ $CAF3      ; 1バイト

; 宝箱のアイテム
WK_TREASUREBOX_ITEM:equ $CAF4   ; 1バイト

; 宝箱を設置する床のパターン情報
WK_TREASUREBOX_GROUND_LU:equ $CAF5 ; 1バイト 左上
WK_TREASUREBOX_GROUND_LD:equ $CAF6 ; 1バイト 左下
WK_TREASUREBOX_GROUND_RU:equ $CAF7 ; 1バイト 右上
WK_TREASUREBOX_GROUND_RD:equ $CAF8 ; 1バイト 右下

; ローソクを使用しているか否かのフラグ
WK_TORCH_USED:equ $CAF9         ; 1バイト

; 宝箱を拾ったか否かのフラグ
; このフラグが1の場合は画面の再描画を
; したうえでダイアログを表示する
WK_BOX_PICKUP:equ $CAFA         ; 1バイト

; BG色を変更するためのワーク用変数
WK_SETBG_VALUE:equ $CAFB        ; 1バイト

; ピープホール処理で使うワーク用変数
WK_PH_VALUE01:equ $CAFC         ; 1バイト

; 永久回廊処理で使うワーク用変数
WK_CORRIDOR:equ $CAFD           ; 1バイト
WK_CORRIDOR_RETURN:equ $CAFE    ; 1バイト

; ショップと重なったかどうかのフラグ
WK_SHOP_ENTER_FLG:equ $CAFF     ; 1バイト（SHOPに入った直後1、PLAYERが動くと0）

; スプライトアトリビューテーブルシャッフル用
; 1/60秒ごとに素数を使ってシャッフルする
; 同時に表示するスプライトは32体
; アトリビュートテーブルは1体あたり4バイト
; 計128バイト
;
; 以下のテーブルが32個並ぶ
; +0 : Y座標
; +1 : X座標
; +2 : パターン番号 
; +3 : カラー番号
;
; シャッフル時にはWK_SPRITE_MOVETBLの値を
; コピーしてからシャッフルを行う
; シャッフル後は仮想スプライトアトリビュートテーブルに
; 128バイトをコピーする
;
WK_SHUFFLE_ATTRTBL:equ $CB00 ; 128バイト(CB00 - CB7F)

; 汎用変数格納用
WK_VALUE01:equ $CB80 ; 1バイト ワーク用
WK_VALUE02:equ $CB81 ; 1バイト ワーク用
WK_VALUE03:equ $CB82 ; 1バイト ワーク用
WK_VALUE04:equ $CB83 ; 1バイト ワーク用
WK_VALUE05:equ $CB84 ; 1バイト ワーク用
WK_VALUE06:equ $CB85 ; 1バイト ワーク用
WK_VALUE07:equ $CB86 ; 1バイト ワーク用
WK_VALUE08:equ $CB87 ; 1バイト ワーク用

; ソート処理変数格納用
WK_SORTVALUE01:equ $CB88 ; 1バイト
WK_SORTVALUE02:equ $CB89 ; 1バイト
WK_SORTVALUE03:equ $CB8A ; 1バイト
WK_SORTVALUE04:equ $CB8B ; 1バイト

; VRAMスプライトアトリビュートのスプライト番号
; シャッフルのつど、19 * 4=76 を加算していく
; 加算結果は常に0x7FでANDを行い32*4を超えないようにする
WK_SPRITE0_NUM:equ $CB8C       ; 1バイト

; テキキャラの数
WK_ENEMY_INITCOUNT:equ $CB8D   ; 1バイト

; MAP情報格納エリア

; タイル情報格納用
WK_MAPAREA:equ $CC00            ; 横15 x 縦10 = 150バイト

; 画面情報格納用
; タイルデータからキャラクタデータに変換したデータを格納
WK_MAP_VIEWAREA:equ $CCA0       ; 横30 x 縦20 = 600バイト(CCA0H-CEF7H)

; 画面表示情報格納用
; 実際に画面に表示するデータを格納
; ピープホールの場合、画面情報格納用を使って加工が行われるため
; その加工結果が格納される
WK_MAP_VIEWAREA_DISP:equ $CEF8  ; 横30 x 縦20 = 600バイト(CEF8H-D14FH)

; MAP情報作成用のワーク変数
WK_MAPAREA_ADDR:equ $D150       ; 2バイト
WK_VIEWPORT_ADDR:equ $D152      ; 2バイト
WK_VIEWPORT_VRAMADDR:equ $D154  ; 2バイト
WK_VIEWPORT_COUNTER:equ $D156   ; 1バイト

; MAP座標　
; オーバーワールドのMAPは横6(00-05) x 縦6(00-05)で構成される
; アンダーワールドのMAPは横3(06-08) x 縦3(00-02)で構成される
; MAPにはIDが付与される(例：横0、縦0のマップであれば0000)
; 特別なMAPIDとして横00,縦06をつける。これは敵の棲家やボス戦で使う
WK_MAPPOSX:equ $D157       ; 1バイト(0-5)
WK_MAPPOSY:equ $D158       ; 1バイト(0-5)

; マップ圧縮データ作成用
; TODO: ランレングス圧縮が効率悪いので廃止予定
WK_MAPCOMP:equ $D159       ; 256バイト (D159H-D258H)
WK_MAPCOMP_ADDR:equ $D259  ; 2バイト

; マップ種別
; マップデータ読み込み時にセットする
;
;   1: 穏やかな平原(スタート地点) PLAIN
;   2: 怪しげな森 SHADY FOREST
;   3: 迷いの大河 MAZE RIVER
;   4: 炭鉱跡 COLE MINE SITE
;   5: 死の山道 DEAD MOUNTAIN ROAD
;   6: 魔導士の城 THE MAGE CASTLE
;   7: （欠番）
;   8: ダンジョン DUNGEON
;   9: PIT
;
; ピープホール処理対応マップ種別
;   2, 5, 8 はピープホール表示とする
;
; マップ種別はマップデータの1バイト目に固定でセットする
;
WK_MAPTYPE:equ $D25B       ; 1バイト

; アニメーション処理用変数
; インターバル値が0になるたびにPCGキャラデータを更新し
; アニメーション表示効果を行う
WK_ANIME_INTERVAL:equ $D25C     ; アニメーションのインターバル間隔(1バイト)
WK_ANIME_FLG:equ $D25D          ; 0 or 1 (1バイト)

; ピープホールインターバル
; TODO: 60秒ごとにロウソクの本数を減らすこと
WK_PEEPHOLE_SHUTDOWN:equ $D25E  ; 1バイト

; PITのマップデータアドレス格納用
WK_PIT_MAP_ADDR:equ $D25F       ; 2バイト
WK_PIT_ENTER_FLG:equ $D261      ; 1バイト（PITに入った直後1、PITから出た直後2, PLAYERが動くと0）
WK_PIT_ENTER_MAP_ADDR:equ $D262 ; 2バイト（PITに入った場所のMAPアドレス）
WK_PIT_ENTER_PREX:equ $D264     ; 1バイト（PITに入る前のX座標）
WK_PIT_ENTER_PREY:equ $D265     ; 1バイト（PITに入る前のY座標）
WK_PIT_ENTER_POSX:equ $D266     ; 1バイト（PITに入った直後のX座標）
WK_PIT_ENTER_POSY:equ $D267     ; 1バイト（PITに入った直後のY座標）
WK_PIT_EXIT_MAPPOSX:equ $D268   ; 1バイト（PITから出た場所のMAP座標X）
WK_PIT_EXIT_MAPPOSY:equ $D269   ; 1バイト（PITから出た場所のMAP座標Y）
                                ; この値が$0000であればPITに入った場所のMAPに出る
WK_PIT_EXIT_POSX:equ $D26A      ; 1バイト（PITから出た場所のX座標）
WK_PIT_EXIT_POSY:equ $D26B      ; 1バイト（PITから出た場所のY座標）

; スプライトの下半身を消すか否かのフラグ
WK_IN_WATER_FLG:equ $D26C       ; 1バイト(0:水には入っていない 1:水に入っている（下半身を消す）

; VSYNC垂直同期待ちカウンタ
; 1/60秒ごとに1がセットされる
VSYNC_WAIT_CNT:equ $D26D        ; 1バイト

; H.TIMIフックバックアップ用ワークエリア 
H_TIMI_BACKUP:equ $D26E         ; 5バイト(D26E - D272)

; 当たり判定用変数群
;
; 当たり判定にはスプライト同士の当たり判定と
; スプライトとPCGキャラとの当たり判定があるが当テーブルでは
; スプライト同士の当たり判定のみ扱う
;
; スプライトの当たり判定テーブル
;
; 当たり判定テーブルは衝突判定されたスプライト同士の
; アドレスが格納される
;
; 当たり判定テーブルはH.TIMIのタイミングで生成され
; 当たり判定処理を施し終えたらテーブルから消去される(NULLがセットされる)
; 甲が当たり判定をしたい側、乙が当たったと判定された側
; +0 - +1の2バイトが0000であればそのテーブルにデータを構築する
; 当たり判定処理が終わったら +0 - +1 の2バイトをゼロクリアする
;
; 例1) テキキャラ（orビビビ）が甲、プレイヤーが乙
; 例2) プレイヤーの剣が甲、テキキャラが乙
; 例3) プレイヤーの弾が甲、テキキャラが乙
;
; +0 : WK_SPRITE_MOVETBL(甲)のアドレス
; +1 : 
; +2 : WK_SPRITE_MOVETBL(乙)のアドレス
; +3 : 
; +4 : 衝突判定のインターバル値
; 
WK_COLLISION_TBL:equ $D273     ; 20体分(20 * 5byte) = 100 バイト D273H - D2D6H

; H.STKEフックバックアップ
H_STKE_BACKUP:equ $D2D9        ; 5バイト

; ドアテーブル
WK_DOOR_TBL:equ $D2DE          ; 6 * 25=120バイト (D2DEH - D373H)

; シナリオステータス
; 8ビットで表現する
; 00000001B
;   GAMESTART
; 00000010B
;   初PIT
; 00000100B
;   初迷いの森
; 00001000B
;   初大河
; 00010000B
;   初山岳地帯への通路
; 00100000B
;   初山岳地帯
; 01000000B
;   初魔城
; 10000000B
;   初魔導士
WK_SCENARIO_STATUS:equ $D374  ; 1バイト

WK_DEBUG_CNT:equ $D375

WK_PH_CHARDATAADR:equ $D376    ; 2バイト
WK_PH_CHARCODE:equ $D378       ; 1バイト

; ダイアログ表示データ作成完了フラグ
; このフラグが1になるまでは1800Hには転送しない
WK_DIALOG_INITEND:equ $D379    ; 1バイト

; ピープホール処理実施中フラグ
; このフラグが1のときにはPeepHoleProcは呼び出さない
WK_PEEPHOLE_BUILDNOW:equ $D37A ; 1バイト

; ゲームクリアフラグ
WK_GAMECLEAR:equ $D37B         ; 1バイト

; TODO : D37CH - D87FH まで空き！

; Arkos Tracker ROM Buffer (250byte)
WK_ARKOS_TRACKER_ROM_BUFFER:equ $D880; 384バイト(D900H - $D9FFH)

; 仮想VRAM
; 仮想パターンネームテーブル
WK_VIRT_PTNNAMETBL:equ $DA00         ; 768バイト(DA00H - DCFFH)
; 仮想スプライトアトリビュートテーブル
WK_VIRT_SPRATTRTBL:equ $DD00         ; 128バイト(DD00H - DD7FH)
; VRAM操作中フラグ
; このフラグが1のときにはVRAMへの操作は行わない
WK_VRAM_SYNC:equ $DD80

;--------------------------------------------
; 初期処理（お約束コード）
;--------------------------------------------
; プログラムの開始位置アドレスは0x4000
org $4000

Header:

    ; MSX の ROM ヘッダ (16 bytes)
    ; プログラムの先頭位置は0x4010
    defb 'A', 'B', $10, $40, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00

Start:

    ; スタックポインタを初期化
    ld sp, $F380

    ;-------------------------------------------
    ; 画面構成の初期化
    ; 8000H以降も使えるようにするおまじない:ここから
    ;-------------------------------------------

    ; 基本スロット選択レジスタを読み出しAレジスタに格納
    ; 基本スロット選択レジスタの第0、第1ビットは
    ; どちらも0(slot#0のpage#0)になっている
    call RSLREG

    ; Aレジスタを2ビット右にローテートし
    ; A=[00|00|00|P1]の形にする
    rrca             ; Aレジスタを2ビット右にローテート
    rrca             ; 

    ; P1(page#1の基本スロット番号)を00000011BでANDして
    ; BCレジスタに格納
    and 3
    ld c, a
    ld b, 0
    
    ; EXPTBL(基本スロットの拡張の有無のslot#3のアドレスを
    ; HLレジスタにセット
    ; HL=EXPTBL + 3(slot#3 existing info)
    ld hl, EXPTBL
    add hl, bc

    ; 拡張有無をAレジスタにセットする
    ; (Aレジスタの第7ビットに拡張有無が格納されている)
    ld a,(hl)
    and 80h          ; Keep the secondary slot flag only

    ; Aレジスタ（拡張有無)とCレジスタ（P1）のORをとり
    ; Cレジスタに格納する
    or c
    ld c, a

    ; SLTTBL(FCC5H,4)にHLレジスタのアドレスを位置付ける
    ; このアドレスは拡張スロット選択情報のslot#3の値となる
    inc hl
    inc hl
    inc hl
    inc hl           ; HL=SLTTBL + P1

    ; 拡張スロット選択情報のslot#3の情報を
    ; Aレジスタに格納する
    ld  a, (hl)

    ; Aレジスタの値(slot#3)の情報と
    ; $0CをANDする
    ; A=[80|00|S1|P1] or [00|00|XX|P1]
    and $0C
    or c
    ld h, $80

    ; ENASLTを呼び出しROM上のpage#2(8000H - BFFFH)までを
    ; 利用できるようにする
    ld de, ENASLT        ; Select the ROM on page 8000h-BFFFh
    call BiosCall

    ; 8000H以降も使えるようにするおまじない:ここまで

    ;-------------------------------------------
    ; 画面カラーパレットの初期化
    ;-------------------------------------------
SetColorPalleteMSX1:

    ld a, (ISMSX1FLG)
    or a

    ; ISMSX1FLGが0でなければMSX2以上であると判定する
    jp z, SkipColorPallete

    ld hl, ColorPalleteData
    ld b, 15
    ld c, 0

ColorPalleteSetLoop:

    ; SETPLTはSUB-ROMに格納されてあるため
    ; EXTROM経由で呼び出しを行う

    ld d, c
    ld a, (hl)
    inc hl
    ld e, (hl)
    inc hl

    ld ix, SETPLT
    push hl
    call BiosNotFDDSubRomCall
    pop hl
    ei

    inc c
    ld a, c
    cp b
    jp nz, ColorPalleteSetLoop

    jp SkipColorPallete

ColorPalleteData:

defb $00, $00 ; Color 0
defb $00, $00 ; Color 1
defb $11, $05 ; Color 2
defb $33, $06 ; Color 3
defb $26, $02 ; Color 4
defb $37, $03 ; Color 5
defb $52, $02 ; Color 6
defb $27, $06 ; Color 7
defb $62, $02 ; Color 8
defb $63, $03 ; Color 9
defb $52, $05 ; Color A
defb $63, $06 ; Color B
defb $11, $04 ; Color C
defb $55, $02 ; Color D
defb $55, $05 ; Color E
defb $77, $07 ; Color F

SkipColorPallete:

    xor a
    ld (WK_VRAM_SYNC), a

;--------------------------------------------
; 初期処理（お約束コード）ここまで
;--------------------------------------------
