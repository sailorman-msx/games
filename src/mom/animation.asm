;
; PCGアニメーション
;

AnimationProc:

    ; アニメーションインターバル値が0であれば
    ; アニメーション処理を行う
    ; 呼び出し元はH.TIMI期間とする
    
    ; マップ切替中は処理を行わない
    ld a, (WK_MAPCHANGE_COUNT)
    or a
    jp nz, AnimationProcEnd

    ; マップ種別に応じてアニメーションさせる
    ; 対象を特定する

    ; 怪しげな森の場合
    ld a, (WK_MAPTYPE)
    cp 2
    jp z, AnimationProcType02

    jp AnimationProcTypeNot02

AnimationProcType02:

    ;
    ld a, (WK_ANIME_FLG)
    cp 1
    jp c, AnimationProcType02ChangeFlg1
    
    ; アニメーションフラグ=1
    ld hl, CHRPTN_FOREST_WOOD_1
    ld (WK_PH_CHARDATAADR), hl

    call IntCreateCharacterPatternLoop

    xor a
    ld (WK_ANIME_FLG), a

    jp AnimationProcEnd

AnimationProcType02ChangeFlg1:

    ; アニメーションフラグ=0
    ld hl, CHRPTN_FOREST_WOOD_2
    ld (WK_PH_CHARDATAADR), hl

    call IntCreateCharacterPatternLoop

    ld a, 1
    ld (WK_ANIME_FLG), a

    jp AnimationProcEnd

AnimationProcTypeNot02:

    ; 迷いの大河と、死の山道の場合
    ld a, (WK_MAPTYPE)
    cp 3
    jp z, AnimationProcTypeIs0305
    cp 5
    jp nz, AnimationProcEnd

AnimationProcTypeIs0305:

    ;
    ld a, (WK_ANIME_FLG)
    cp 1
    jp c, AnimationProcType03ChangeFlg1
    
    ; アニメーションフラグ=1
    ld hl, CHRPTN_WATER_1
    ld (WK_PH_CHARDATAADR), hl

    call IntCreateCharacterPatternLoop

    xor a
    ld (WK_ANIME_FLG), a

    jp AnimationProcEnd

AnimationProcType03ChangeFlg1:

    ; アニメーションフラグ=0
    ld hl, CHRPTN_WATER_2
    ld (WK_PH_CHARDATAADR), hl

    call IntCreateCharacterPatternLoop

    ld a, 1
    ld (WK_ANIME_FLG), a

AnimationProcEnd:

    ret
