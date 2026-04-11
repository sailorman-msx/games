; MSX1 右から左スクロールプログラム（E0-FF完全排除・完全実装版）
; ORG &HB000 / BASICから DEFUSR=&HB000 : A=USR(0) で起動
; ================================================================
;
; 【処理概要】
; ・コースデータは上段・中段・下段のデータを128バイトで構成する
; ・コースデータはBASICの10行からのコメント分に格納された文字列を
;   16進数から2進数に変換し、0をスペース、1を床として解釈し
;   C000H以上のメモリに展開する
; ・H.TIMIでは以下のことだけを実施する
;   - 右カーソルキーの入力判定
;   - スペースキーの入力判定
;   - 仮想画面、仮想スプライトのVRAM転送
;   - フレーム数カウント
; ・右から左への3段独立コース横スクロール（仮想バッファ48バイト）
; ・右カーソルキー押スペースっぱなしで30フレームごとに加速（停止→低速→中速→高速）
;   離した瞬間に1段減速、離しっぱなしで30フレームごとに減速
; ・スペースキー押下でマリオ風可変高さジャンプ
;   - 押した瞬間にジャンプ開始（初速固定）
;   - 離したタイミングで頂点決定（短押し=開始Y-16、長押し=開始Y-32）
;   - 上昇中は足元チェックしない
; ・プレイヤーX固定、衝突即時チェック、Y>=14でゲームオーバー
; ・ゲームオーバーフラグには以下の意味を持たせる
;   1: 穴に落ちた
;   2: ゴール到達
;
; 【BASIC側の処理】
; ・ゲームプログラムローディング
; 5010行以降のコメント欄に記載されている16進表記の文字列をパースして
; 0B000H以降に書き込む
; このプログラムはBASICの10行目未満の行で実施する
; ローダは0B800Hに書き込まれるため
; DEFUSR1=&HB800:A=USR1(0) でBASIC側は実行する
; ・ゲームプログラムの実行
; DEFUSR=&HB000として、A=USR(0)で実行する
; 10行目のREM分のコメント欄にコースデータの文字列を書き込む
; 32バイト*3段分を書き込み、その値を当プログラムの初期処理で
; パースして、コースデータとして書き込む
;
ORG 0B000H

; ---------------------------------------------------------------
; コースデータ（BASIC側で事前準備）
; ---------------------------------------------------------------
COURSE_UP  EQU 0C000H
COURSE_MID EQU 0C080H
COURSE_LOW EQU 0C100H

; ---------------------------------------------------------------
; ワークエリア定義
;
; C600H: INT_CNT           1byte  スクロール用カウンタ（毎フレームSPEED加算、60以上でスクロール）
; C601H: (未使用)
; C602H: SPEED_LEVEL       1byte  現在の速度段階（0=停止、1=低速、2=中速、3=高速）
; C603H: SPEED             1byte  現在のスクロール速度（0/1/8/30）INT_CNTに毎フレーム加算される
; C604H: SCRPOS            2byte  スクロール位置（16bit、0〜511）
; C606H: SPEED_CNT         1byte  加速/減速カウンタ（30フレームで1段階変化）
; C607H: PLAYER_Y          1byte  プレイヤーY座標（ピクセル単位）
; C608H: PLAYER_VY         2byte  Y方向速度（8.8固定小数点: +0=小数部, +1=整数部）
; C60AH: ON_GROUND         1byte  着地フラグ（1=地面にいる、0=空中）
; C60BH: PREV_COLLIISION_U 1byte  前フレームの天井衝突フラグ
; C60CH: PREV_CL           1byte  左カーソルが押されてるフラグ
; C60DH: JUMP_PEAK_Y       1byte  頂点目標Y座標（ピクセル単位）
; C60EH: PREV_SP           1byte  スペース長押しカウンタ
; C60FH: SPR_ATTR          4byte  スプライト属性（Y, X, パターン, カラー）
; C613H: GAMEOVER_FLAG     1byte  ゲームオーバーフラグ（0=継続、1=終了）
; C614H: PREV_CR           1byte  前フレームの右カーソルキー状態（0=離し、1=押し）
; C615H: PREV_Y            1byte  全フレームでのPLAYER_Y（タイル単位）
; C616H: COLLISION_D       1byte  足元衝突フラグ（1:衝突 0:衝突していない）
; C617H: COLLISION_U       1byte  頭上衝突フラグ（1:衝突 0:衝突していない）
; C618H: REDRAW_FLG        1byte  画面の再描画可能フラグ(1:VRAM転送する 0:しない)
; C619H: VSYNC_FLG         1byte  H.TIMIタイミングをWAITするためのフラグ
; C61AH: COURSE_IDX        1byte  コース作成時のワーク変数
; C61BH: COURSE_TOP        2byte  コース作成時のワーク変数
; C61DH: BASIC_ADR         2byte  BASICのコースデータアドレス
; C620H: SCORE             2byte  スコア（移動距離）
; C630H: VIRT_SCR          48byte 仮想スクロールバッファ（横16バイトx3段）
; ---------------------------------------------------------------
INT_CNT          EQU 0C600H
SPEED_LEVEL      EQU 0C602H  ; 速度段階 0=停止 1=低速 2=中速 3=高速
SPEED            EQU 0C603H
SCRPOS           EQU 0C604H
SPEED_CNT        EQU 0C606H  ; 加速/減速カウンタ（0〜29、30で段階変化）
PLAYER_Y         EQU 0C607H
PLAYER_VY        EQU 0C608H  ; +0=小数部, +1=整数部
ON_GROUND        EQU 0C60AH
PREV_COLLISION_U EQU 0C60BH  ; 1 byte 前フレームの天井衝突フラグ
PREV_CL          EQU 0C60CH  ; 1 byte 左カーソルキーが押されてるフラグ
JUMP_PEAK_Y      EQU 0C60DH
PREV_SP          EQU 0C60EH  ; 1 byte 前フレームのスペースキー状態（0=離し、1=押し）
SPR_ATTR         EQU 0C60FH  ; 4 byte
GAMEOVER_FLAG    EQU 0C613H  ; 1 byte
PREV_CR          EQU 0C614H  ; 1 byte 前フレーム右カーソルキー状態
PREV_Y           EQU 0C615H  ; 1 byte 全フレームでのPLAYER_Y（ピクセル単位）
COLLISION_D      EQU 0C616H  ; 1 byte 足元衝突フラグ（1:衝突 0:衝突していない）
COLLISION_U      EQU 0C617H  ; 1 byte 頭上衝突フラグ（1:衝突 0:衝突していない）
REDRAW_FLG       EQU 0C618H  ; 1 byte 画面の再描画可能フラグ(1:VRAM転送する 0:しない)
VSYNC_FLG        EQU 0C619H  ; 1 byte H.TIMIタイミングをWAITするためのフラグ
COURSE_IDX       EQU 0C61AH  ; 1 byte コース作成時のワーク変数
COURSE_TOP       EQU 0C61BH  ; 2 byte コース作成時のワーク変数
BASIC_ADR        EQU 0C61DH  ; 2 byte BASICのコースデータアドレス
SCORE            EQU 0C620H  ; 2 byte 得点
VIRT_SCR         EQU 0C630H

PLAYER_COL       EQU 2       ; プレイヤー固定列位置

    ; とりあえず
    JR INIT

; ================================================================
; BASICの特定行を探すサブルーチン
; 処理概要:
;   Bレジスタに格納された行番号に対応するBASICの先頭位置を取得する
;   HLレジスタにコメント行の中間コードの次のアドレスをセットして返却する
; ================================================================
LINE_SEARCH:

    ; BASICの特定行のデータ位置を特定する
    LD HL, 08001H ; BASICの仕様では0800Hはゼロになっているため次のアドレスから

LINE_SEARCH_LOOP:

    LD E, (HL)  ; リンクポインタの下位バイト
    INC HL
    LD D, (HL)  ; リンクポインタの上位バイト

    INC HL      ; 行番号の下位バイトのアドレス

    LD A, (HL)  ; 行番号を取得して判定する
    CP B
    JR Z, LINE_FOUND
    
    LD HL, DE   ; 次の行をサーチ
    JR LINE_SEARCH_LOOP

LINE_FOUND:

    ; データ部にSEEKする
    ; シングルクオートのコメントの中間コードは3A8FE6(3byte)のため
    ; 上位バイト（1バイト）+3バイト=4バイト進める
    INC HL ; 上位バイト
    INC HL ; 03AH
    INC HL ; 08FH
    INC HL ; 0E6H
    INC HL ; データの1バイト目
    
    RET

; ================================================================
; 初期化
; 処理概要:
;   1. 旧H.TIMIをバックアップして MAIN をH.TIMIチェインにセットする
;   2. キャクタパターン、カラーの作成
;   3. スプライトアトリビューとの初期化
;   4. 各種ワークエリア（変数群）の初期化
;
; ※初期化処理が完了したらMAINにジャンプしVSYNCの完了を待つ
; ================================================================
INIT:

    DI

    ; H.TIMIをバックアップ
    LD HL, 0FD9FH
    LD DE, H_TIMI_OLD
    LD BC, 5
    LDIR

    ; JP MY_TIMI のコードを FD9FH に書き込む
    LD HL, 0FD9FH
    LD DE, MY_TIMI
    LD A, 0C3H          ; JP オペコード
    LD (HL), A
    INC HL
    LD A, E
    LD (HL), A          ; MY_TIMI 下位バイト
    INC HL
    LD A, D
    LD (HL), A          ; MY_TIMI 上位バイト

    ; ワークエリアクリア（96バイト）
    XOR A
    LD HL, INT_CNT
    LD B, 060H

CLEAR_WKAREA:
    LD (HL), A
    INC HL
    DJNZ CLEAR_WKAREA

    ; ワークエリアクリア（128*3バイト=384バイト）
    LD HL, COURSE_UP
    XOR A
    LD C, 3
    LD B, 128

CLEAR_COURSE:
    LD (HL), A
    INC HL
    DJNZ CLEAR_COURSE
    DEC C
    JR Z, CLEAR_COURSE_END
    LD B, 0
    JR CLEAR_COURSE

CLEAR_COURSE_END:

    ; コースデータを作成する
    CALL GEN_COURSE

    ; 仮想画面の初期化
    ; 上段・中段：スペース(20H)を32バイト埋める
    LD HL, VIRT_SCR
    LD B, 32
    LD A, 020H
INIT_VIRT_SCR_SPC:
    LD (HL), A
    INC HL
    DJNZ INIT_VIRT_SCR_SPC
    ; 下段：床を16バイト埋める
    LD B, 16
    LD A, 028H
INIT_VIRT_SCR_FLOOR:
    LD (HL), A
    INC HL
    DJNZ INIT_VIRT_SCR_FLOOR

    ; 各種フラグ初期化
    LD A, 1
    LD (ON_GROUND), A
    XOR A
    LD (GAMEOVER_FLAG), A
    LD (SPEED), A
    LD (SPEED_LEVEL), A
    LD (SPEED_CNT), A
    ; VSYNC_FLGをクリアする
    LD (VSYNC_FLG), A

    ; プレイヤー初期位置（下段床 Y=88px）
    LD A, 88
    LD (PLAYER_Y), A

    ; PREV_Yも同じ値で初期化
    LD (PREV_Y), A

    ; スプライト属性初期化
    ; SPR_ATTR.Y = PLAYER_Y = 88
    LD A, 88
    LD (SPR_ATTR), A
    LD A, 80 ; (PLAYER_COL + 2) * 8 = 10*8 = 80
    LD (SPR_ATTR+1), A
    XOR A
    LD (SPR_ATTR+2), A
    LD A, 15
    LD (SPR_ATTR+3), A

    ; キャラクタパターンをVRAMに転送
    CALL CHAR_GEN

    ; 初期表示のためSCROLL_PROCを呼び出す
    CALL SCROLL_PROC

    ; 初期表示のため再描画フラグをONにする
    LD A, 1
    LD (REDRAW_FLG), A

INIT_END:

    EI

    ; メイン処理にジャンプ
    JP MAIN

; ================================================================
; H.TIMIハンドラ
; 処理順序:
;   1. AFレジスタ保存
;   2. VRAM転送
;   3. ゲームオーバー判定
; ================================================================
MY_TIMI:

    DI

    ; レジスタ保存
    PUSH AF
    PUSH BC
    PUSH DE
    PUSH HL

MY_TIMI_MAIN:

    ; 画面再描画フラグがONであれば仮想画面をVRAM転送する
    ; テアリングを懸念したうえでの念の為の処理
    ; このフラグはSCROLL_PROC完了後にONになる
    LD A, (REDRAW_FLG)
    OR A
    JP Z, SKIP_REDRAW

    ; VRAM転送
    ; 仮想バッファ → VRAM転送（3段分）
    LD HL, VIRT_SCR
    LD DE, 1908H
    LD B, 16
    CALL WRITE_VRAM16

    LD HL, VIRT_SCR+16
    LD DE, 1948H
    LD B, 16
    CALL WRITE_VRAM16

    LD HL, VIRT_SCR+32
    LD DE, 1988H
    LD B, 16
    CALL WRITE_VRAM16

    ; 060Hのキャラを画面に転送する
    LD HL, CHAR_SPIKE
    LD DE, 019C8H
    LD B, 16
    CALL WRITE_VRAM16

    ; 左カーソルが押されていたら（ブレーキかけてたら）
    ; スプライトは黄色にする
    LD D, 0FH  ; 白

CHECK_BRAKE:

    LD A, (PREV_CL)
    OR A
    JR Z, SKIP_CHECK_BRAKE

    LD D, 0AH

    XOR A

SKIP_CHECK_BRAKE:

    ; スプライト更新
    ; PLAYER_Y はピクセル座標なのでそのまま使用
    LD A, (PLAYER_Y)
    LD B, A

    ; 112以上にはしない
    ; 112の場合、スパイクに落ちてるので赤くする
    LD A, (PLAYER_Y)
    CP 112
    JR C, SPR_OK
    LD B, 112

    LD D, 8

SPR_OK:

    ; Y座標のセット
    LD A, B
    LD (SPR_ATTR), A

    ; スプライトカラーのセット
    LD A, D
    LD (SPR_ATTR+3), A

    LD HL, SPR_ATTR
    LD DE, 1B00H
    LD B, 4
    CALL WRITE_VRAM16

    ; スピードメータを作成する

    ; スピードメータ欄の初期化
    LD HL, SPEED_METER+3
    LD A, 020H
    LD (HL), A
    INC HL
    LD (HL), A
    INC HL
    LD (HL), A

    LD HL, SPEED_METER+3
    LD  A, (SPEED_LEVEL)
    OR  A
    JR Z, SKIP_SPEED_METER
    LD  B, A
    LD  A, 085H

SPEED_METER_LOOP:
    LD (HL), A
    INC HL
    DJNZ SPEED_METER_LOOP

SKIP_SPEED_METER:

    ; スピードメータを表示する
    LD HL, SPEED_METER
    LD DE, 01828H
    LD B, 6
    CALL WRITE_VRAM16

    ; 画面再描画フラグをクリアする
    XOR A
    LD (REDRAW_FLG), A

SKIP_REDRAW:

    ; PLAYER_Y >= 112px → ゲームオーバー
    LD A, (PLAYER_Y)
    CP 112
    JR NC, SET_GAMEOVER

    ; SCORE >= 512 → ゲームオーバー（ゴール到達）
    LD HL, (SCORE)
    LD A, H
    SUB 2 ; SCOREが 0200H で GOAL
    JR Z, SET_GOAL
    
    JR MY_TIMI_END

SET_GOAL:

    LD A, 2
    LD (GAMEOVER_FLAG), A
    JR RESTORE_HTIMI

SET_GAMEOVER:

    LD A, 1
    LD (GAMEOVER_FLAG), A

RESTORE_HTIMI:

    LD HL, H_TIMI_OLD
    LD DE, 0FD9FH
    LD BC, 5
    LDIR

MY_TIMI_END:

    ; レジスタ復元
    POP HL
    POP DE
    POP BC
    POP AF
 
    ; VSYNC_FLGを0（H.TIMI処理終了）にする
    XOR A
    LD (VSYNC_FLG), A

    EI

    ; 旧H.TIMIにチェイン
    JP H_TIMI_OLD

; ==============================================
; メインループ
; 処理順序：
;   1: VSYNC待ち
;   2: キー受付
;   3: 速度処理
;   4: スプライトY座標物理演算＋衝突/落下判定
;   5: スクロール処理
; ==============================================
MAIN:

    ; ゲームオーバーフラグが成立したら
    ; 処理を終了する
    LD A, (GAMEOVER_FLAG)
    OR A
    RET NZ

    ; H.TIMIの処理が実施されるとVSYNC_FLGはゼロになる
    ; VSYNC_FLGに1をセットして0になるまでWAITする（H.TIMIの処理待ちの意味）
    LD A, 1
    LD (VSYNC_FLG), A

VSYNC_WAIT:
    LD A, (VSYNC_FLG)
    OR A
    JR NZ, VSYNC_WAIT

    ;--------------------------------------
    ; ここから通常処理
    ;--------------------------------------

MAIN_NORMAL:

    ; 右カーソルーキー入力処理
    CALL UPDATE_SPEED

JUDGE_SCROLL:

    LD A, (SPEED)
    OR A
    JR Z, MAIN_END    ; SPEED=0:停止 ならなにもしない

    LD HL, INT_CNT
    INC (HL)
    LD A, (HL)
    LD B, A
    LD A, (SPEED)     ; SPEED - INT_CNT の値を判定し
    CP B
    JR NC, MAIN_END   ; SPEED > INT_CNT であればまだ待つ

    ; SPEED >= INT_CNT ならスクロールさせて
    ; INT_CNT >= SPEED → INT_CNT -= SPEED してスクロール

    LD A, B    ; INT_CNTの値をAにセット
    LD HL, SPEED
    SUB (HL)   ; A = A - SPEED値
    LD (INT_CNT), A
    CALL SCROLL_PROC

MAIN_END:

    ; ジャンプ処理
    CALL UPDATE_JUMP

    ; 物理演算（重力・着地判定）
    CALL UPDATE_PHYSICS

    ; メイン処理先頭に戻る
    JP MAIN

; ------------------------------
; 旧H.TIMI退避領域
; ------------------------------
H_TIMI_OLD:
DEFB 0, 0, 0, 0, 0

; ================================================================
; UPDATE_SPEED
; 右カーソルキー押した瞬間に即LEVEL=1（低速）、その後30フレームごとに1段加速
; 離した瞬間に即1段減速、離しっぱなしで30フレームごとに減速
; 左カーソルキーでブレーキ（SPEED_LEVELを0にする）
; 左右のカーソルキーが同時に押されてる場合
; 左カーソルキー（ブレーキ）を優先する
;
; SPEED_LEVEL: 0=停止 1=低速 2=中速 3=高速
; SPEED_CNT:   加速/減速カウンタ（0〜29、30到達で段階変化＋リセット）
; PREV_CR:     前フレームの右カーソルキー状態（0=離し、1=押し）
;
; SPEED値テーブル:
;   SPEED_LEVEL=0 → SPEED=0  (停止)
;   SPEED_LEVEL=1 → SPEED=30 (低速)
;   SPEED_LEVEL=2 → SPEED=20 (中速)
;   SPEED_LEVEL=3 → SPEED=10 (高速)
; ================================================================
UPDATE_SPEED:

; --- カーソルキー押し中 ---
    ; Row8（カーソルキー行）スキャン
    LD A, 8
    OUT (0AAH), A
    IN  A, (0A9H)
    CPL                 ; 押下=1に反転
    LD  B, A
    AND 010H            ; 左カーソルキー = Row8 bit4
    JR NZ, BRAKE_SPEED

    LD  A, B
    AND 080H            ; 右カーソルキー = Row8 bit7
    JR Z, SPD_CR_OFF    ; 離している
    JR SPD_CR_ON

; --- 左カーソルキー押した ---
BRAKE_SPEED:

    XOR A
    ; SPEED_LEVELをゼロ(停止中)にする
    LD (SPEED_LEVEL), A
    ; SPEEDをゼロにする
    LD (SPEED), A
    ; 右カーソル押してるフラグをクリアする
    LD (PREV_CR), A
   
    ; 左カーソル押してるフラグをONにする
    LD A, 1
    LD (PREV_CL), A

    RET

; --- 右カーソルキー押し中 ---
SPD_CR_ON:

    ; 左カーソル押してるフラグをOFFにする
    XOR A
    LD (PREV_CL), A

    ; 前フレームも押していた？
    LD A, (PREV_CR)
    OR A
    JR NZ, SPD_CR_COUNT  ; 継続押し → カウントアップ

    ; 初回押し
    ; 押した瞬間：即LEVEL=1（低速）にセット＋SPEED_CNTリセット
    XOR A
    LD (SPEED_CNT), A
    LD A, 1
    LD (SPEED_LEVEL), A

    JR SPD_CR_SETPREV   ; PREV_CR=1をセットしてSPD_APPLYへ

SPD_CR_COUNT:

    ; 押し継続中カウントアップ → 30フレームで1段加速
    LD HL, SPEED_CNT
    INC (HL)
    LD A, (HL)
    SUB 30
    JR C, SPD_CR_SETPREV  ; 30未満 → そのまま速度反映

    ; 30フレーム経過 → 1段加速
    XOR A
    LD (SPEED_CNT), A    ; カウンタリセット

    LD A, (SPEED_LEVEL)
    SUB 3
    JR NC, SPD_CR_SETPREV ; すでに最高速(3) → 変化なし

    ; SPEED_LEVEL 1 -> 2
    ; SPEED_LEVEL 2 -> 3
    LD A, (SPEED_LEVEL)
    INC A
    LD (SPEED_LEVEL), A

SPD_CR_SETPREV:

    LD A, 1
    LD (PREV_CR), A       ; PREV_CR=1（今フレーム押し）
    JR SPD_APPLY

; --- 右カーソルキー離し中 ---

SPD_CR_OFF:

    ; 前フレームは押していた？
    LD A, (PREV_CR)
    OR A
    JR Z, SPD_OFF_COUNT ; 前も離し → 離しっぱなしカウント

    ; 離した瞬間：即1段減速＋SPEED_CNTリセット
    XOR A
    LD (PREV_CR), A     ; PREV_CR=0（今フレーム離し）
    LD (SPEED_CNT), A   ; カウンタリセット

    LD A, (SPEED_LEVEL)
    OR A
    JR Z, SPD_APPLY     ; すでに停止 → 変化なし

    ; 減速
    DEC A
    LD (SPEED_LEVEL), A
    JR SPD_APPLY

SPD_OFF_COUNT:

    ; 離しっぱなし継続 → 30フレームで1段減速
    LD HL, SPEED_CNT
    INC (HL)
    LD A, (HL)
    SUB 30
    JR C, SPD_APPLY     ; 30未満 → そのまま

    ; 30フレーム経過 → 1段減速
    XOR A
    LD (SPEED_CNT), A   ; カウンタリセット

    LD A, (SPEED_LEVEL)
    OR A
    JR Z, SPD_APPLY     ; すでに停止

    DEC A
    LD (SPEED_LEVEL), A

SPD_APPLY:
    ; SPEED_LEVELからSPEEDを設定
    LD A, (SPEED_LEVEL)
    OR A
    JR Z, SPD_STOP      ; LEVEL=0 → 停止

    SUB 1
    JR NZ, SPD_CHK2     ; LEVEL>=2

    ; LEVEL=1 → 低速
    LD A, 30            ; 30フレームごとにスクロール
    JR SPD_SET

SPD_CHK2:
    SUB 1
    JR NZ, SPD_HIGH     ; LEVEL=3

    ; LEVEL=2 → 中速
    LD A, 20            ; 20フレームごとにスクロール
    JR SPD_SET

SPD_HIGH:
    ; LEVEL=3 → 高速
    LD A, 10            ; 10フレームごとにスクロール
    JR SPD_SET

SPD_STOP:
    XOR A

SPD_SET:
    LD (SPEED), A
    RET

; ================================================================
; UPDATE_JUMP
; スペースキー押下でジャンプ管理
;
; PREV_SPで「押した瞬間」を検出してジャンプ開始
; 空中かどうかはON_GROUNDで判定
;
; ================================================================
UPDATE_JUMP:

    ; スペースキー（Row8, bit0）スキャン
    LD A, 8
    OUT (0AAH), A
    IN  A, (0A9H)
    CPL                 ; 押下=1に反転
    AND 01H             ; スペースキー = Row8 bit0
    JR Z, JUMP_BTN_OFF  ; 離している

; --- ボタン押し中 ---

    ; 前フレームも押していた？
    LD A, (PREV_SP)
    OR A
    RET NZ              ; 継続押し → 何もしない

    ; 地上チェック
    ; 空中でMを押されても処理しない
    ; PREV_SPはずっとONのままとなる
    LD A, (ON_GROUND)
    OR A
    RET Z

    ; 頭上チェック 頭上に床があればジャンプしない
    
    ; 押した瞬間：PREV_SP=1にセット
    LD A, 1
    LD (PREV_SP), A

    ; ジャンプ開始
    XOR A
    LD (PLAYER_VY), A   ; 速度小数部=0
    LD (ON_GROUND), A   ; 地面フラグOFF

    ; 強制スクロール（SPEED=0の停止中は除く）
    LD A, (SPEED)
    OR A
    JR Z, JUMP_NO_SCROLL

    DEC A
    LD (INT_CNT), A     ; 次フレームのJUDGE_SCROLLで即スクロール発火

JUMP_NO_SCROLL:

    ; 初速セット: PLAYER_VY+1 = FDH (-3) 固定
    LD A, 0D0H
    ADD A, 02DH         ; FDH
    LD (PLAYER_VY+1), A

    ; 頂点Y確定
    ; 頂点は3タイル分とする( 3 * 8ドット = 24 )
    LD A, (PLAYER_Y)
    SUB 24              ; ピクセル単位で-24
    LD (JUMP_PEAK_Y), A
    RET

; --- ボタン離し ---
JUMP_BTN_OFF:
    XOR A
    LD (PREV_SP), A      ; PREV_SP=0（今フレーム離し）
    RET

; ================================================================
; UPDATE_PHYSICS
; 重力加算・Y座標更新・頂点クランプ・衝突判定
;
; 処理フロー:
;   1. PREV_Y保存
;   2. 重力加算（PLAYER_VY += 0030H）
;   3. Y座標更新（PLAYER_Y += VY整数部）
;   4. 頂点クランプ（上昇中かつ頂点超えたらPLAYER_Yをクランプ）
;   5. CHECK_COLLで衝突判定
;   COLLISION_D=1（足元衝突）→ 着地処理してRET
;   COLLISION_U=1（頭上衝突）→ VY=0にしてRET
;   どちらも0 → そのままRET
; ================================================================
UPDATE_PHYSICS:

    ; PREV_Y保存（CHECK_COLLで使用）
    LD A, (PLAYER_Y)
    LD (PREV_Y), A

    ; 重力: +0030H (+0.1875/frame)
    LD A, (PLAYER_VY)
    ADD A, 030H
    LD (PLAYER_VY), A
    LD A, (PLAYER_VY+1)
    ADC A, 0
    LD (PLAYER_VY+1), A

APPLY_Y:
    ; Y座標に速度整数部を加算
    LD B, A
    LD A, (PLAYER_Y)
    ADD A, B
    LD (PLAYER_Y), A

    ; スプライト座標が変化するため
    ; 再描画フラグをONにする
    LD A, 1
    LD (REDRAW_FLG), A

    ; 頂点クランプチェック
    ; 上昇中（VY+1のbit7=1）のときのみ実施
    LD A, (PLAYER_VY+1)
    BIT 7, A
    JR Z, AFTER_CLAMP    ; 下降中or静止 → クランプしない

    LD A, (PLAYER_Y)
    LD B, A              ; B = PLAYER_Y
    LD A, (JUMP_PEAK_Y)
    CP B                 ; JUMP_PEAK_Y - PLAYER_Y
    JR C, AFTER_CLAMP    ; JUMP_PEAK_Y < PLAYER_Y → まだ頂点に達してない

    LD A, (JUMP_PEAK_Y)
    LD (PLAYER_Y), A
    LD A, 030H
    LD (PLAYER_VY), A    ; VY小数部=30H（下降開始）
    XOR A
    LD (PLAYER_VY+1), A  ; VY整数部=0

AFTER_CLAMP:

    ; 衝突・着地・地面判定
    ; COLLISION_D/COLLISION_Uで結果を受け取る
    CALL CHECK_COLL

    ; 足元衝突 → 着地処理してRET
    LD A, (COLLISION_D)
    OR A
    JR Z, PHYS_CHK_UP

    LD A, 1
    LD (ON_GROUND), A   ; 着地フラグON
    XOR A
    LD (PLAYER_VY), A   ; VY小数部=0
    LD (PLAYER_VY+1), A ; VY整数部=0
    RET

PHYS_CHK_UP:
    ; 頭上衝突 → VY=0にして下降開始
    LD A, (COLLISION_U)
    OR A
    RET Z               ; 衝突なし → そのままRET

    XOR A
    LD (PLAYER_VY), A   ; VY小数部=0
    LD (PLAYER_VY+1), A ; VY整数部=0（次フレームから重力で下降）
    RET

; ================================================================
; CHECK_COLL（新版）
; テーブル・ループ廃止、固定アドレス直列チェック
;
; 【座標系】
;   PLAYER_Y = 頭の上端座標（ピクセル）
;   py       = (PLAYER_Y+8)/8 = 足元タイル行
;   head_py  = PLAYER_Y/8     = 頭タイル行
;
; 【VIRT_SCR固定アドレス（PLAYER_COL=2）】
;   上段床: VIRT_SCR+2  （floor_y=8,  着地Y=56）
;   中段床: VIRT_SCR+18 （floor_y=10, 着地Y=72）
;   下段床: VIRT_SCR+34 （floor_y=12, 着地Y=88）
;
; 【天井アドレス（下から見た床の裏面）】
;   下段天井: VIRT_SCR+18 （中段床の裏, head_py=9 でヒット, スナップY=80）
;   中段天井: VIRT_SCR+2  （上段床の裏, head_py=7 でヒット, スナップY=64）
;
; 【足元チェックのpy一致条件】
;   各段の床の上面に対応するpyは1つだけ
;   上段: py==8  （Y=56〜63が有効着地範囲）
;   中段: py==10 （Y=72〜79が有効着地範囲）
;   下段: py==12 （Y=88〜95が有効着地範囲）
;   py=9,11,13は各段床の下面エリアなので着地NG
;   例: 上段天井ヒット後Y=64→py=9 → py!=8 → 着地しない ✓
;   例: 中段天井ヒット後Y=80→py=11 → py!=10 → 着地しない ✓
;
; 【天井ヒット翌フレームの誤着地防止】
;   CC_CEIL_HIT内でCOLLISION_U=1と同時にPREV_COLLISION_U=1を退避
;   翌フレームCC_DO_FOOTでPREV_COLLISION_U=1ならCC_SKIP_FOOTへスキップ
;   スキップ後PREV_COLLISION_U=0にクリアして次フレームは通常動作に戻す
;   py一致条件と合わせた二重保護になっている
;
; 【処理フロー】
;   1. COLLISION_D/COLLISION_Uをクリア
;   2. 足元チェック要否を判定 → CC_DO_FOOT or CC_SKIP_FOOT
;   3. CC_DO_FOOT: PREV_COLLISION_U確認後、下段→中段→上段の足元チェック
;   4. CC_SKIP_FOOT: 下段天井→中段天井の頭上衝突チェック
;
; 【使用レジスタ】
;   A  : 汎用演算
;   C  : py または head_py の一時保持
;   HL : VIRT_SCRアドレス参照用
;   ※Bレジスタは使用しない
;     （APPLY_Y内でBが破壊されるためメモリ変数PREV_COLLISION_Uを使用）
; ================================================================
CHECK_COLL:

    ; 衝突フラグを今フレーム用にクリア
    ; PREV_COLLISION_UはCC_CEIL_HIT内でセットするためここでは触らない
    XOR A
    LD (COLLISION_D), A
    LD (COLLISION_U), A

    ; ----------------------------------------------------------
    ; 足元チェック要否の判定
    ; ----------------------------------------------------------

    ; 着地中（ON_GROUND=1）は無条件で足元チェック
    ; 理由: 床の上に立っている状態を毎フレーム維持するため
    LD A, (ON_GROUND)
    OR A
    JR NZ, CC_DO_FOOT

    ; 上昇中（VY整数部 bit7=1）は足元チェックをスキップ
    ; 理由: 上昇中に足元の床に着地判定されないようにするため
    LD A, (PLAYER_VY+1)
    BIT 7, A
    JR NZ, CC_SKIP_FOOT

    ; VY=0 かつ PLAYER_Y <= JUMP_PEAK_Y → 頂点付近 → スキップ
    ; VY=0 かつ PLAYER_Y >  JUMP_PEAK_Y → 頂点超え → 足元チェック
    ; CP命令: JUMP_PEAK_Y - PLAYER_Y を計算
    ;   結果がマイナス（C=1）→ JUMP_PEAK_Y < PLAYER_Y → 下降中
    LD A, (PLAYER_Y)
    LD C, A              ; C = PLAYER_Y（一時退避）
    LD A, (JUMP_PEAK_Y)
    CP C                 ; JUMP_PEAK_Y - PLAYER_Y
    JR C, CC_DO_FOOT     ; JUMP_PEAK_Y < PLAYER_Y → 下降中 → 足元チェック

    JR CC_SKIP_FOOT      ; JUMP_PEAK_Y >= PLAYER_Y → 頂点付近 → スキップ

; ================================================================
; CC_DO_FOOT: 足元衝突チェック
; 下段→中段→上段の順にチェックし、最初にヒットした段で確定
;
; 【チェック順が下段優先の理由】
;   複数段に床がある列でプレイヤーが下段にいる場合、
;   上段から先にチェックすると誤って上段にスナップされるため
;
; 【py一致チェックの理由】
;   py==8/10/12のみ着地を許可し、py==9/11/13（各床の下面エリア）はNG
;   天井ヒット後にPLAYER_Yが天井裏面にスナップされた状態で
;   足元チェックが走っても誤着地しないようにするため
;   例: 中段天井ヒット後Y=80 → py=11 → py!=10 → 中段着地しない ✓
; ================================================================
CC_DO_FOOT:

    ; ON_GROUNDをクリア（このフレームの着地判定をリセット）
    ; 足元衝突が確定したらCC_FOOT_HIT内で再セットされる
    XOR A
    LD (ON_GROUND), A

    ; ----------------------------------------------------------
    ; 前フレームで天井ヒットしていた場合は足元チェックを丸ごとスキップ
    ; 理由: py一致条件だけでは防げないケースへの二重保護
    ;       天井ヒット直後はPLAYER_Yが天井裏面にスナップされており
    ;       まだ天井の床の影響範囲内にいるため
    ; PREV_COLLISION_U=1の場合は使用後0にクリアして次フレームは通常動作に戻す
    ; ----------------------------------------------------------
    LD A, (PREV_COLLISION_U)
    OR A
    JR Z, CC_DO_FOOT_EXEC    ; 0 → 足元チェック実行
    XOR A
    LD (PREV_COLLISION_U), A ; 使用後クリア（1フレームだけ効かせる）
    JR CC_SKIP_FOOT          ; 足元チェックをスキップ

CC_DO_FOOT_EXEC:

    ; py = (PLAYER_Y+8)/8
    ; +8 している理由: PLAYER_Yは頭座標なので足元は+8px
    ; /8 している理由: タイル行に変換（1タイル=8px）
    LD A, (PLAYER_Y)
    ADD A, 8             ; 足元のピクセルY
    SRL A
    SRL A
    SRL A                ; /8 → タイル行
    LD C, A              ; C = py（足元タイル行）

    ; ----------------------------------------------------------
    ; 下段チェック: py == 12
    ; 下段床はタイル行12、着地スナップY=88
    ; py=12のみ有効（py=13は下段床の下面エリアなので着地NG）
    ; ----------------------------------------------------------
    LD A, C
    CP 12
    JR NZ, CC_FOOT_MID   ; py != 12 → 中段チェックへ
    LD HL, VIRT_SCR+34   ; 下段のプレイヤー列アドレス
    LD A, (HL)
    CALL IS_FLOOR_CHAR   ; 床キャラか判定（NZ=床あり, Z=床なし）
    JR Z, CC_FOOT_MID    ; 床なし → 中段チェックへ
    LD A, 88             ; 着地スナップ: 下段Y=88
    LD (PLAYER_Y), A
    JR CC_FOOT_HIT

    ; ----------------------------------------------------------
    ; 中段チェック: py == 10
    ; 中段床はタイル行10、着地スナップY=72
    ; py=10のみ有効（py=11は中段床の下面エリアなので着地NG）
    ; ----------------------------------------------------------
CC_FOOT_MID:
    LD A, C
    CP 10
    JR NZ, CC_FOOT_UP    ; py != 10 → 上段チェックへ
    LD HL, VIRT_SCR+18   ; 中段のプレイヤー列アドレス
    LD A, (HL)
    CALL IS_FLOOR_CHAR
    JR Z, CC_FOOT_UP     ; 床なし → 上段チェックへ
    LD A, 72             ; 着地スナップ: 中段Y=72
    LD (PLAYER_Y), A
    JR CC_FOOT_HIT

    ; ----------------------------------------------------------
    ; 上段チェック: py == 8
    ; 上段床はタイル行8、着地スナップY=56
    ; py=8のみ有効（py=9は上段床の下面エリアなので着地NG）
    ; ----------------------------------------------------------
CC_FOOT_UP:
    LD A, C
    CP 8
    JR NZ, CC_SKIP_FOOT  ; py != 8 → 全段NG → 天井チェックへ
    LD HL, VIRT_SCR+2    ; 上段のプレイヤー列アドレス
    LD A, (HL)
    CALL IS_FLOOR_CHAR
    JR Z, CC_SKIP_FOOT   ; 床なし → 全段NG → 天井チェックへ
    LD A, 56             ; 着地スナップ: 上段Y=56
    LD (PLAYER_Y), A

    ; ----------------------------------------------------------
    ; 足元衝突確定
    ; ----------------------------------------------------------
CC_FOOT_HIT:
    LD A, 1
    LD (ON_GROUND), A    ; 着地フラグON
    LD (COLLISION_D), A  ; 足元衝突フラグON
    RET

; ================================================================
; CC_SKIP_FOOT: 頭上衝突チェック
; 上昇中 / 頂点付近 / 天井ヒット翌フレーム がここに来る
;
; head_pyの値で「どの天井と当たりうるか」が一意に決まる
;   head_py=9 → 中段床の裏面（下段天井）: スナップY=80
;   head_py=7 → 上段床の裏面（中段天井）: スナップY=64
;   それ以外  → 天井なし → RET
;
; 【head_pyが一意に決まる理由】
;   天井にぶつかる瞬間はhead_pyが天井タイル行に初めて入る時のみ
;   上段床（タイル行8）の裏にぶつかる = head_pyが7に入った瞬間
;   中段床（タイル行10）の裏にぶつかる = head_pyが9に入った瞬間
; ================================================================
CC_SKIP_FOOT:

    ; head_py = PLAYER_Y/8（頭タイル行）
    LD A, (PLAYER_Y)
    SRL A
    SRL A
    SRL A                ; /8 → タイル行
    LD C, A              ; C = head_py（後のCC_CEIL_MIDで再利用）

    ; ----------------------------------------------------------
    ; 下段天井チェック: head_py == 9
    ; 中段床（VIRT_SCR+18）の裏面が天井になるのはhead_py=9の時のみ
    ; ヒット時スナップY=80（ceil_y=10 → 10*8=80）
    ; ----------------------------------------------------------
    CP 9
    JR NZ, CC_CEIL_MID   ; head_py != 9 → 中段天井チェックへ
    LD HL, VIRT_SCR+18   ; 中段のプレイヤー列アドレス
    LD A, (HL)
    CALL IS_FLOOR_CHAR
    JR Z, CC_CEIL_MID    ; 床なし → 中段天井チェックへ
    LD A, 80             ; 天井スナップY=80
    LD (PLAYER_Y), A
    JR CC_CEIL_HIT

    ; ----------------------------------------------------------
    ; 中段天井チェック: head_py == 7
    ; 上段床（VIRT_SCR+2）の裏面が天井になるのはhead_py=7の時のみ
    ; ヒット時スナップY=64（ceil_y=8 → 8*8=64）
    ; ----------------------------------------------------------
CC_CEIL_MID:
    LD A, C              ; head_pyを復元（IS_FLOOR_CHARでAが破壊されるため）
    CP 7
    RET NZ               ; head_py != 7 → 天井なし → RET
    LD HL, VIRT_SCR+2    ; 上段のプレイヤー列アドレス
    LD A, (HL)
    CALL IS_FLOOR_CHAR
    RET Z                ; 床なし → 天井なし → RET
    LD A, 64             ; 天井スナップY=64
    LD (PLAYER_Y), A

    ; ----------------------------------------------------------
    ; 頭上衝突確定
    ; ----------------------------------------------------------
CC_CEIL_HIT:
    LD A, 1
    LD (COLLISION_U), A      ; 頭上衝突フラグON
    LD (PREV_COLLISION_U), A ; 翌フレームCC_DO_FOOTの誤着地防止用に退避
                             ; CHECK_COLL先頭ではなくここで退避する理由:
                             ; 天井ヒットした同フレームに確実に1をセットするため
                             ; CHECK_COLL先頭での退避では前フレーム値（0）が
                             ; 上書きされてしまい翌フレームに伝わらないため
    RET

; ================================================================
; IS_FLOOR_CHAR
; 入力: A = キャラクタコード
; 出力: Z=0(NZ) → 床あり（28H=緑床 または 60H=スパイク）
;       Z=1(Z)  → 床なし
; 破壊: AF
; ================================================================
IS_FLOOR_CHAR:

    CP 028H
    JR Z, IFC_FOUND     ; 緑床
    CP 060H
    JR Z, IFC_FOUND     ; スパイク

    ; 床なし: Z=1
    XOR A
    RET

IFC_FOUND:
    ; 床あり: Z=0
    OR 0FFH
    RET

; ================================================================
; SCROLL_PROC
; スクロール位置更新 + 仮想バッファ左シフト + 右端へ新キャラ挿入
; ================================================================
SCROLL_PROC:

    LD HL, (SCORE) ; スコアに1を加算
    INC HL
    LD (SCORE), HL

    LD HL, (SCRPOS)
    INC HL
    LD (SCRPOS), HL

    LD A, L
    SUB 128
    JR C, SET_SCRPOS

    ; スクロール位置が128になったら0に戻す（コースループ）
    ; 4周まわったらGOALになる
    XOR A
    LD H, A
    LD L, A
    LD (SCRPOS), HL

SET_SCRPOS:

    ; 各段を左シフト
    LD HL, VIRT_SCR
    CALL SHIFT_ONE_LINE
    LD HL, VIRT_SCR+16
    CALL SHIFT_ONE_LINE
    LD HL, VIRT_SCR+32
    CALL SHIFT_ONE_LINE

    ; 新キャラを右端に挿入
    LD HL, (SCRPOS)
    LD E, L
    LD D, H

    LD HL, COURSE_UP
    ADD HL, DE
    LD A, (HL)
    LD (VIRT_SCR+15), A

    LD HL, COURSE_MID
    ADD HL, DE
    LD A, (HL)
    LD (VIRT_SCR+31), A

    LD HL, COURSE_LOW
    ADD HL, DE
    LD A, (HL)
    LD (VIRT_SCR+47), A

    ; 画面再描画フラグをONにする
    ; こうすることで次フレームで描画される
    LD A, 1
    LD (REDRAW_FLG), A

    RET

; ================================================================
; SHIFT_ONE_LINE
; 入力: HL = 段の先頭アドレス
; 16バイトを1バイト左シフト、右端はスペースでクリア
; ================================================================
SHIFT_ONE_LINE:

    LD DE, HL           ; DE = コピー先
    INC HL              ; HL = コピー元（2バイト目）
    LD BC, 15
    LDIR

    LD A, 32
    LD (DE), A          ; 右端をスペースでクリア
    RET

; ================================================================
; WRITE_VRAM16
; 入力: HL = 転送元RAMアドレス
;       DE = 転送先VRAMアドレス
;       B  = 転送バイト数
; 破壊: AF, B, HL
; ================================================================
WRITE_VRAM16:

    LD A, E
    OUT (099H), A       ; アドレス下位
    NOP
    NOP
    LD A, D
    ADD A, 040H         ; 書き込みフラグ付加
    OUT (099H), A       ; アドレス上位
    NOP
    NOP

WRITE_VRAM16_LOOP:
    LD A, (HL)          ; 7ステート
    OUT (098H), A       ; 11ステート
    INC HL              ; 6ステート
    DEC B               ; 4ステート
    NOP                 ; 4ステート
    NOP                 ; 4ステート
    NOP                 ; 4ステート
                        ; OUT後合計 = 6+4+4+4+4+10(JP NZ) = 32ステート
    JP NZ, WRITE_VRAM16_LOOP

    RET

; ================================================================
; GEN_COURSE
; BASICのREM文を参照してコースデータを作成する
; 10行目にコメント文は存在して16進形式で32byteずつ
; 上段、中段、下段のデータが格納されており
; 16進の文字列2桁ずつに分解→2進数に変換→0ならスペース、それ以外は床
; としてコースデータを生成する
; BASICのコメントには32桁の16進数文字列（＝16バイト分）が1段ぶんとして
; 記載されている。1段ぶんのコースデータは16*8=128バイトとなる
; ================================================================
GEN_COURSE:

    ; コース作成ワーク変数を初期化
    XOR A
    LD (COURSE_IDX), A

    LD  B, 10     ; BASICの10行目を探す
    CALL LINE_SEARCH

    ; BASICの10行目が見つかった
    
    ; コースを生成
    ; 1コース分のデータは32バイト
    ; 2バイトで1バイトの16進数値表現のため 32/2*8 = 128タイルぶんとなる

    LD (BASIC_ADR), HL ; BASICのアドレスを退避

    LD HL, COURSE_UP
    LD (COURSE_TOP), HL

    LD  B, 16 ; 16進数で16桁ぶんループする
    LD  C, 3

; コース : 3 * 128タイル分のデータを作成する
COURSE_LOOP:

    LD HL, (BASIC_ADR)

    ; 1バイト（上位1バイトに該当）を読み込む
    LD  A, (HL)
    CALL CONV_DEC
    LD  D, A ; 10進変換結果をDに格納

    ; 上位1バイトのため4ビット左にシフトする
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A  ; 4ビットシフトの結果をEレジスタに格納

    INC HL   ; アドレスを1つ進める

    ; 1バイト（下位1バイトに該当）を読み込む
    LD  A, (HL) 
    CALL CONV_DEC

    INC HL   ; BASICのコースデータの次の文字アドレスに進める
    
    ; Eレジスタ（上位4ビットが格納されてる）にORする
    OR E
    LD E, A

    PUSH HL
    PUSH BC

    ; 1バイトを展開してコースデータに敷き詰める
    ; COURSE_IDXは0から127までの値となる
    LD HL, (COURSE_TOP)
    LD  A, (COURSE_IDX)
    LD  C, A
    LD  B, 0

    ADD HL, BC ; コースデータの書き込み位置にSEEK

    ; 1バイト数値を8ビットに変換してコースデータを作成する
    LD   A, E  ; コースデータ（1バイト）をAレジスタにセット
    CALL PLOT_COURSE_DATA

    POP BC
    POP HL

    ; 次のBASIC_ADRに進める(2バイト進める)
    LD HL, (BASIC_ADR)
    INC HL
    INC HL
    LD (BASIC_ADR), HL

    DJNZ COURSE_LOOP

    ; 格段の処理終了

    ; Cレジスタをデクリメントして
    ; キャリーしたらであれば処理を終了する
    DEC C
    JR Z, COURSE_LOOP_END

    ; 1コース分のデータ作成が完了したら
    ; コースデータの先頭アドレスに0200Hを加算する
    PUSH BC

    LD HL, (COURSE_TOP)
    LD BC, 080H
    ADD HL, BC
    LD (COURSE_TOP), HL

    XOR A
    LD (COURSE_IDX), A

    ; データ読み込みループ回数をセットしなおす
    POP BC

    LD B, 16 ; Cレジスタはデクリメントされたままとする

    JR COURSE_LOOP

COURSE_LOOP_END:
    
    RET

; ================================================================
; 16進数の1桁ぶんを10進に変換する
; 入力：Aレジスタ  0123456789ABCDEFのいずれかの文字コード）
; 出力：Aレジスタ  10進変換結果(0-15)
; ================================================================
CONV_DEC:

    ; A >= 41H ?
    CP 041H
    JR NC, CD_ALPHABETIC

    ; 0 - 9
    SUB 030H  ; 30H を引く

    JR CONV_DEC_END

CD_ALPHABETIC:

    ; A - F
    SUB 041H  ; 41H を引いて
    ADD A, 10 ; 10を加算する   

CONV_DEC_END:

    RET

; ================================================================
; 1バイト分を8ビットに変換して指定したアドレスに書き込む
; 書き込み後は COURSE_IDXが+8される
; 入力：
;       HLレジスタ 書き込み位置
;       Aレジスタ  1バイト数値
; ================================================================
PLOT_COURSE_DATA:

    PUSH BC

    ; 8ビット分、SLAを繰り返し
    ; Carryしたら床(040H)をコースデータに
    ; Carryしなければ20Hをコースデータに格納する
    ; (Aレジスタの第7bitから順に処理していく）

    LD B, 8

PCD_LOOP:

    OR A     ; Cフラグをクリア

    SLA A    ; 1ビット左シフト
    LD E, A  ; シフトした結果をEレジスタに退避

    JR C, PCD_SET_FLOOR

    ; スペースを格納する
    LD A, 020H  ; スペース
    JR PCD_LOOP_NEXT

PCD_SET_FLOOR:

    LD A, 028H  ; 床

PCD_LOOP_NEXT:

    LD (HL), A

    LD A, (COURSE_IDX)
    INC A
    LD (COURSE_IDX), A ; コースインデックスをインクリメント

    INC HL   ; 書き込み位置をインクリメント

    LD A, E  ; 退避した値を復帰

    DJNZ PCD_LOOP

    POP BC

    RET

; ================================================================
; CHAR_GEN
; '('(28H), '(60H)のキャラクタパターンをVRAMに転送
; ================================================================
CHAR_GEN:

    ; キャラクタパターン
    LD HL, CHAR_PTN_28H
    LD DE, 028H * 8
    LD B, 8
    CALL WRITE_VRAM16

    LD HL, CHAR_PTN_60H
    LD DE, 060H * 8
    LD B, 8
    CALL WRITE_VRAM16

    ; カラーデータ
    LD HL, CHAR_COLOR_28H
    LD DE, 02000H + (028H / 8)
    LD B, 1
    CALL WRITE_VRAM16

    LD HL, CHAR_COLOR_60H
    LD DE, 02000H + (060H / 8)
    LD B, 1
    CALL WRITE_VRAM16

    RET

CHAR_PTN_28H:
DEFB 0AAH, 055H, 0AAH, 055H, 0AAH, 055H, 0AAH, 055H
CHAR_PTN_60H:
DEFB 010H, 038H, 038H, 07CH, 074H, 0AAH, 0D6H, 0AAH
CHAR_COLOR_28H:
DEFB 02CH
CHAR_COLOR_60H:
DEFB 0A4H
CHAR_SPIKE:
DEFB 060H, 060H, 060H, 060H, 060H, 060H, 060H, 060H
DEFB 060H, 060H, 060H, 060H, 060H, 060H, 060H, 060H
SPEED_METER:
DEFB 'S', 'P', ' ', 0, 0, 0
