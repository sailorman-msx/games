GTSTCK:equ $00D5 ; JOY STICKの状態を調べる
GTTRIG:equ $00D8 ; トリガボタンの状態を返す
KILBUF:equ $0156 ; キーバッファクリア

H_TIMI:equ $FD9F ; 垂直帰線割り込みフック

; BASIC変数のアドレス取得用
VARTAB:EQU $F6C2 ; BASICの単純変数の先頭アドレス

;-----------------------------------
; ワークエリア
;-----------------------------------
VARADR           :equ $C800    ; 取得したBASIC変数のアドレス格納用(2バイト)

; 処理カウンタ( 5/60秒ごとにカウントアップし、3の次は0に戻る)
; 0 : プレイヤー処理 (  0/60秒 )
; 1 : テキキャラ処理 (  5/60秒 )
; 2 : 自分の弾処理   ( 10/60秒 )
; 3 : 敵の弾処理     ( 15/60秒 )
WK_PROCCNT      :equ $C802     ; BASICが設定した変数のアドレス(PC)

WK_B_STICK      :equ $C804     ; BASICが設定したSTICKの値格納変数のアドレス(ST)
WK_B_TRIGGER    :equ $C806     ; BASICが設定したTRIGの値格納変数のアドレス(TG)
WK_B_ENEMYY     :equ $C808    ; BASICが設定したテキキャラのY座標の値格納変数のアドレス(EY)
WK_B_PSHOTY     :equ $C80A    ; BASICが設定したプレイヤーの弾のY座標の値格納変数のアドレス(SY)
WK_B_ESHOTY     :equ $C80C    ; BASICが設定したテキキャラの弾のY座標の値格納変数のアドレス(TY)

org $C000

;-----------------------------------------
; 初期処理
; 以下の処理を行う
;   H.TIMIの書き換え
;   VRAM関連のワークエリアのクリア
;   自機のスプライト移動テーブルの作成
;   マシン語利用可能フラグをOFFにする
;-----------------------------------------
InitializeProc:

    push af  
    push bc
    push de
    push hl
    
    di  
    
    ; ■H.TIMIバックアップ
    ld hl, H_TIMI                   ; 転送元
    ld de, H_TIMI_BACKUP            ; 転送先
    ld bc, 5                        ; 転送バイト数
    ldir
    
    ; ■H.TIMI書き換え
    ld a, $C3                       ; JP
    ld hl, VBLANK_PROC
    ld (H_TIMI + 0), a
    ld (H_TIMI + 1), hl
    
    ; VRAM_SYNCフラグをクリアする
    xor a
    ld (WK_VRAM_SYNC), a

    ei  

    pop hl
    pop de
    pop bc
    pop af

    ret

; ----------------------------------------
; BASIC変数のアドレス取得用
; この処理は BASIC側から最初に呼び出す
; ----------------------------------------
GetVarAddress:

    cp 3
    ret nz

    ; 引数が文字列型の場合
    ; Aレジスタには3が入る
    ; DEレジスタには以下のデータアドレスが入る
    ; +0 : 文字数
    ; +1 - +2 : 文字が格納されたアドレス
    ; 当サンプルでは文字数は2で固定
  
    ; 変数のアドレスを特定する
    ; 最初に文字列が格納されたアドレスを特定し
    ; HLレジスタに格納する
    inc de ; 最初の1バイトは文字数のためスキップ
    ld a, (de)
    ld l, a
    inc de
    ld a, (de)
    ld h, a
  
    ; BCレジスタに文字列を格納する
    ; 例) 引数が"AB"の場合
    ;     B=0x41
    ;     C=0x42
    ld b, (hl)
    inc hl
    ld c, (hl)

    ; BASIC変数の最初のアドレスを特定し
    ; DEレジスタにセットする
    ld a, (VARTAB)
    ld e, a
    ld a, (VARTAB+1)
    ld d, a

GVALoop:

    ; 変数アドレスの最初の1バイトは型タイプなのでスキップ
    inc de ; PTR=変数名の1バイト目

    ; BASICで定義されてる変数名を調べる
    ld a, (de)
    ld h, a
    inc de ; PTR=変数名の2バイト目
    ld a, (de)
    ld l, a
    inc de ; PTR=変数の値下位バイト

    ; 引数の変数名と合致したらループを抜ける
    or a ; SBCやるのでお約束のCYクリアを実施
    sbc hl, bc
    jr z, GVALoopEnd

    ; 変数の値の箇所はスキップ
    inc de ; PTR=変数の値上位バイト
    inc de ; PTR=次の変数の型タイプ

    jr GVALoop

GVALoopEnd:

    ; 変数の値のアドレスを特定して
    ; ワークエリアにセットする
    ld a, e
    ld (VARADR), a
    ld a, d
    ld (VARADR+1), a

    ret

; ----------------------------------------------
; VBLANK時の処理
; ----------------------------------------------
VBLANK_PROC:

    di 
    
    push af

    call MainProc

    pop af

    ei 
    
    ret

; ------------------------------------------
; キー入力とトリガ入力を受け付ける
; BASICでの STICKとTRIGの代替の処理
; ------------------------------------------
MainProc:

    ; 全レジスタの退避
    push hl
    push de
    push bc
    push af

    call KILBUF
    
    ; キー入力受付
    ld a, 0
    call  GTSTCK
    ld  d, a
    push de
    ld    a, 1
    call  GTSTCK
    pop de
    or    d
    jr z, KeyInputTrigger
    
    ld hl, (WK_B_STICK)
    ld (hl), a ; BASICの変数にセットする

KeyInputTrigger:
    ; トリガ受付
    xor   a
    call  GTTRIG
    ld    d, a
    ld    a, 1 ; ジョイスティック1
    call  GTTRIG
    or    d
    ld hl, (WK_B_TRIGGER)
    ld (hl), a ; BASICの変数にセットする

EnemyMove:

    ld hl, (WK_B_ENEMYY)
    ld  a, (hl)
    inc a
    ld (hl), a

PlayerShotMove:

    ld hl, (WK_B_PSHOTY)
    ld  a, (hl)
    dec a
    dec a
    jr  c, PlayerShotInit
    ld (hl), a
    jr  EnemyShotMove

PlayerShotInit:

    xor a
    ld (hl), a
    
EnemyShotMove:

    ld hl, (WK_B_ESHOTY)
    ld  a, (hl)
    cp 191
    jr  z, EnemyShotInit
    inc a
    inc a
    ld (hl), a
    
    jr MainProcEnd

EnemyShotInit:

    ld a, 192
    ld (hl), a

MainProcEnd:

    ; 全レジスタの復帰
    pop af
    pop bc
    pop de
    pop hl

    ret

WK_VRAM_SYNC:
defb 0
H_TIMI_BACKUP:
defb 0, 0, 0, 0, 0
FUNCADDR:
defw GetVarAddress

