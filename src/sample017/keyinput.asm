;--------------------------------------------
; keyinput.asm
; キー入力、ジョイスティック入力の結果によって
; スプライトの移動量等を変数にセットする
;--------------------------------------------
KeyInputProc:

    ; TRIGGERフラグの初期化
    ld a, 0
    ld (WK_TRIGGER), a
    ; PLAYERDISTの初期化
    ld a, 0
    ld (WK_PLAYERDIST), a

    call KILBUF

    ; スペースキーが押されているか？
KeyInputProc_IsSPACE:

    ld a, 0
    call GTTRIG
    cp $FF
    jr nz, KeyInputProc_IsAbutton

    ld a, 1
    ld (WK_TRIGGER), a
    
    jp KeyInputProc_IsCURSOR

    ; ジョイスティック1のAボタンが押されているか？
KeyInputProc_IsAbutton:

    ld a, 1
    call GTTRIG
    cp $FF
    jr nz, KeyInputProc_IsCURSOR

    ld a, 1
    ld (WK_TRIGGER), a
    
    ; ジョイスティックまたはカーソルキーの方向を取得
    ; GTSTCK呼び出し後、Aレジスタに方向がセットされる
KeyInputProc_IsCURSOR:

    ld a, 0
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

    ld (WK_PLAYERDIST), a

KeyInputProc_End:

    ret
