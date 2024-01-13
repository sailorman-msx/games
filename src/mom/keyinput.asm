;--------------------------------------------
; keyinput.asm
; キー入力、ジョイスティック入力の結果によって
; スプライトの移動量等を変数にセットする
;
; WK_TRIGGERAの値
;  00H : 何も押されていない
;  01H : Zキーが押されている
;  02H : Zキーが押されて戻した
;  11H : Aボタンが押された
;  12H : Aボタンが押されて戻した
;  
; WK_TRIGGERBの値
;  00H : 何も押されていない
;  01H : Xキーが押されている
;  02H : Xキーが押されて戻した
;  11H : Bボタンが押された
;  12H : Bボタンが押されて戻した
;
;--------------------------------------------
KeyInputProc:

    ; TRIGGERフラグの初期化
    xor a
    ld (WK_TRIGGER), a

    ; PLAYERDISTの初期化
    ld (WK_PLAYERDIST), a

    ; 最初にキーマトリクスにて押されているキーを調べる
    ; Z,スペース : ジョイスティック1 A
    ; X          : ジョイスティック2 B

    ld a, 5
    call SNSMAT
    ld (WK_VALUE01), a

KeyInputProcCheckZkey:

    cp 01111111B
    jp nz, KeyInputProcZup

    ; Zキーが押されている

    ; WK_TRIGGERAが0でなければ何もしない
    ld a, (WK_TRIGGERA)
    or a
    jp nz, KeyInputProc_IsCURSOR

KeyInputProcZpress:

    ; WK_TRIGGERA=0であれば01Hにする
    ld a, $01
    ld (WK_TRIGGERA), a

    jp KeyInputProcCheckXKey

KeyInputProcZup:

    ; WK_TRIGGERA=01Hであれば02Hにする
    ld a, (WK_TRIGGERA)
    cp $01
    jp nz, KeyInputProcZupStep2

    ld a, $02
    ld (WK_TRIGGERA), a

    jp KeyInputProcCheckXKey

KeyInputProcZupStep2:

    ; WK_TRIGGERA=02Hであれば02Hにする
    cp $02
    jp nz, KeyInputProcCheckXKey

    xor a
    ld (WK_TRIGGERA), a

KeyInputProcCheckXKey:

    ld a, (WK_VALUE01)
    cp 11011111B
    jp nz, KeyInputProcXup

    ; Xキーが押されている

    ; WK_TRIGGERBが0でなければ何もしない
    ld a, (WK_TRIGGERB)
    or a
    jp nz, KeyInputProc_IsCURSOR

KeyInputProcXpress:

    ; WK_TRIGGERB=0であれば01Hにする
    ld a, $01
    ld (WK_TRIGGERB), a

    jp KeyInputProc_IsCURSOR

KeyInputProcXup:

    ; WK_TRIGGERB=01Hであれば02Hにする
    ld a, (WK_TRIGGERB)
    cp $01
    jp nz, KeyInputProc_IsAbutton

    ld a, $02
    ld (WK_TRIGGERB), a

    ; ジョイスティック1のAボタンが押されているか？
KeyInputProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jr nz, KeyInputProcAup

    ; WK_TRIGGERAが0でなければ何もしない
    ld a, (WK_TRIGGERA)
    or a
    jp nz, KeyInputProc_IsCURSOR
 
KeyInputProcApress:

    ; WK_TRIGGERA=0であれば11Hにする
    ld a, $11
    ld (WK_TRIGGERA), a
    
    jp KeyInputProc_IsCURSOR

KeyInputProcAup:

    ; WK_TRIGGERA=11Hであれば12Hにする
    ld a, (WK_TRIGGERA)
    cp $11
    jp nz, KeyInputProc_IsAupStep2

    ld a, $12
    ld (WK_TRIGGERA), a

    jp KeyInputProc_IsBbutton

KeyInputProc_IsAupStep2:

    ; WK_TRIGGERA=12Hであれば00Hにする
    ld a, (WK_TRIGGERA)
    cp $12
    jp nz, KeyInputProc_IsBbutton

    ld a, $00
    ld (WK_TRIGGERA), a

    ; ジョイスティック1のBボタンが押されているか？
KeyInputProc_IsBbutton:

    ld a, 3
    call GTTRIG
    cp $FF
    jr nz, KeyInputProcBup

    ; WK_TRIGGERBが0でなければ何もしない
    ld a, (WK_TRIGGERB)
    or a
    jp nz, KeyInputProc_IsCURSOR
 
KeyInputProcBpress:

    ; WK_TRIGGERB=0であれば11Hにする
    ld a, $11
    ld (WK_TRIGGERB), a

    jp KeyInputProc_IsCURSOR

KeyInputProcBup:

    ; WK_TRIGGERB=11Hであれば12Hにする
    ld a, (WK_TRIGGERB)
    cp $11
    jp nz, KeyInputProc_IsCURSOR

    ld a, $12
    ld (WK_TRIGGERB), a

KeyInputProc_IsCURSOR:

    ; キーインインターバル中は
    ; キー入力を無効にする
    ld a, (WK_KEYIN_INTERVAL)
    cp 1
    jp nc, KeyInputProc_End

    ; ダイアログ表示中はインターバル値は8とする
    ; (操作性をよくする)
    ld a, (WK_GAMESTATUS)
    cp 3
    jp nz, KeyInputProcSetInterval5

    ; ダイアログモードではインターバルは8/60秒
    ld a, 8
    jp KeyInputProcSetInterval

KeyInputProcSetInterval5:

    ; 通常モードではインターバルは7/60秒
    ld a, 7

KeyInputProcSetInterval:

    ld (WK_KEYIN_INTERVAL), a

    xor a
    call GTSTCK
    ;--------------------------------------------
    ; カーソルキーが押されたら移動処理を呼ぶ
    ;--------------------------------------------
    ; Aレジスタに0をOR演算する
    ; カーソルキーが押されるとAレジスタの
    ; 値には0より大きい値が入るためOR演算の結果はゼロにならない
    or 0
    jr nz, KeyInputProc_KeyInEnd

KeyInputProc_IsJOYSTICK:

    ld a, 1
    call GTSTCK
    ;--------------------------------------------
    ; ジョイスティックが押されたら移動処理を呼ぶ
    ;--------------------------------------------
    ; Aレジスタに0をOR演算する
    ; ジョイスティックが押されるとAレジスタの
    ; 値には0より大きい値が入るためOR演算の結果はゼロにならない
    or 0
    jr z, KeyInputProc_End

KeyInputProc_KeyInEnd:

    ; トリガAが押されているときの方向キーは無効化する
    ld b, a
    ld a, (WK_TRIGGERA)
    cp 1
    jp z, KeyInputProc_KeyEndAdjTRIGAOff
    cp $11
    jp z, KeyInputProc_KeyEndAdjTRIGAOff

    ld a, b

    jp KeyInputProc_KeyEndAdjSTCK

KeyInputProc_KeyEndAdjTRIGAOff:

    xor a

KeyInputProc_KeyEndAdjSTCK:

    ; 方向キーの斜めは無効とする
    cp 2
    jp nz, KeyInputProc_Judge4

    ld a, 3 ; 右方向とみなす

KeyInputProc_Judge4:

    cp 4
    jp nz, KeyInputProc_Judge6

    ld a, 3 ; 右方向とみなす

KeyInputProc_Judge6:

    cp 6
    jp nz, KeyInputProc_Judge8

    ld a, 7 ; 左方向とみなす

KeyInputProc_Judge8:
    
    cp 8
    jp nz, KeyInputProc_SetDist

    ld a, 7 ; 左方向とみなす

KeyInputProc_SetDist:

    ld (WK_PLAYERDIST), a

KeyInputProc_End:

    call KILBUF

    ret
