;--------------------------------------------
; torch.asm
; ロウソク関連の処理
;--------------------------------------------
TorchInit:

    push af
    push hl

    ld a, 1

    ld hl, WK_TORCH_TBL
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a

    ; PEEPHOLEの径を初期化する

    ; PEEPHOLE型のマップであればPEEPHOLE径をセットする
    ; PEEPHOLE型のマップ種別:2,5,6,8
    ld a, (WK_MAPTYPE)
    cp 2
    jp z, TorchInitSetPeepHole
    cp 5
    jp z, TorchInitSetPeepHole
    cp 6
    jp z, TorchInitSetPeepHole
    cp 8
    jp z, TorchInitSetPeepHole

    jp TorchInitEnd

TorchInitSetPeepHole:

    di

    ld a, 5
    ld (WK_PEEPHOLE), a

    ld a, 1
    ld (WK_TORCH_USED), a

    ; ロウソクのカウントダウンタイマーを初期化する
    ld hl, 1800 ; 30 * 60 = 30秒 とりあえず
    ld (WK_TORCH_TIMER), hl

    ei
    
TorchInitEnd:

    pop hl
    pop af

    ret

TorchCountDown:

    push hl

    ; PEEPHOLE型のマップでなければ何もしない
    ; PEEPHOLE型のマップ種別:2,5,6,8
    ld a, (WK_MAPTYPE)
    cp 2
    jp z, TorchCountDownPeepHole
    cp 5
    jp z, TorchCountDownPeepHole
    cp 6
    jp z, TorchCountDownPeepHole
    cp 8
    jp z, TorchCountDownPeepHole

    jp TorchCountDownEnd

TorchCountDownPeepHole:

    ; ロウソクのカウントダウンタイマーをデクリメントする
    or a ; Set CY=0
    ld hl, (WK_TORCH_TIMER)
    ld b, 0
    ld c, 1
    sbc hl, bc
    jr z, TorchCountDownSetInterval
    jr c, TorchCountDownSetInterval

    ld (WK_TORCH_TIMER), hl
    jr TorchCountDownEnd

TorchCountDownSetInterval:

    di
    ld hl, 1800 ; 30秒（とりあえず）
    ld (WK_TORCH_TIMER), hl

    ; ロウソクの本数を1本減らす
    ld hl, WK_TORCH_TBL + 3

    ld b, 4
    ei

TorchCountDownDecTorchTable:

    ld a, (hl)
    or a
    jr nz, TorchCountDownDecTorchTableDec
    dec hl

    djnz TorchCountDownDecTorchTable

    ; ローソクの本数が0になった
    xor a
    ld (WK_TORCH_USED), a

    jp TorchCountDownEnd

TorchCountDownDecTorchTableDec:

    xor a
    ld (hl), a
    
    ; ピープホールの可視領域を狭める
    ld a, (WK_PEEPHOLE)
    dec a
    ld (WK_PEEPHOLE), a
    
    ld a, 1
    ld (WK_REDRAW_FINE), a

TorchCountDownEnd:

    pop hl

    ret

; ロウソクの状態を表示する
DispTorchStatus:

    push de
    push hl

    ; ロウソクを使っていなければ何もしない
    ld a, (WK_TORCH_USED)
    or a
    jr z, DispTorchTableEnd

    ld hl, WK_VIRT_PTNNAMETBL + 23 * 32 + 1
    ld bc, 4
    ld a, $24
    call MemFil

    ld de, WK_TORCH_TBL

    ld hl, WK_VIRT_PTNNAMETBL + 23 * 32 + 1
    ld b, 4

DispTorchTable:

    ld a, (de)
    or a
    jr z, DispTorchTableEnd

    ld (hl), $2C

    inc hl
    inc de
    djnz DispTorchTable

DispTorchTableEnd:

    pop hl
    pop de

    ret
