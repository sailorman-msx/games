GameMainProc:

    ;-------------------------------------------
    ; ここにメインロジックを書きます
    ; WK_GAMESTATUS=2だとH.TIMIが終わったあとで
    ; この処理が必ず呼ばれます
    ;-------------------------------------------

    ;------------------------------------------------
    ; プレイヤー周辺の背景情報を取得する
    ;------------------------------------------------
    call WallCollision

    ;------------------------------------------------
    ; スプライト移動管理テーブルにスプライトの情報を
    ; セットする
    ;------------------------------------------------
    call MovePlayer

    ;----------------------------------------
    ; 仮想スプライトアトリビュートテーブルを
    ; 更新する
    ;----------------------------------------
    call SetVirtAttrTable

    ;----------------------------------------
    ; 仮想スプライトアトリビュートテーブルを
    ; シャッフルする
    ;----------------------------------------
    call ShuffleSprite

    ;jr GameMainProcDebugEnd

    ;
    ; for DEBUG
    ; 画面にVRAM4X6の情報を設定する
    ;
    ld hl, WK_VRAM4X6_TBL
    ld de, WK_VIRT_PTNNAMETBL + 18*32
    ld bc, 4
    call MemCpy
    ld hl, WK_VRAM4X6_TBL + 4
    ld de, WK_VIRT_PTNNAMETBL + 19*32
    ld bc, 4
    call MemCpy
    ld hl, WK_VRAM4X6_TBL + 8
    ld de, WK_VIRT_PTNNAMETBL + 20*32
    ld bc, 4
    call MemCpy
    ld hl, WK_VRAM4X6_TBL + 12
    ld de, WK_VIRT_PTNNAMETBL + 21*32
    ld bc, 4
    call MemCpy
    ld hl, WK_VRAM4X6_TBL + 16
    ld de, WK_VIRT_PTNNAMETBL + 22*32
    ld bc, 4
    call MemCpy
    ld hl, WK_VRAM4X6_TBL + 20
    ld de, WK_VIRT_PTNNAMETBL + 23*32
    ld bc, 4
    call MemCpy

GameMainProcDebugEnd:

    ; スプライトを再描画する
    ld a, 1
    ld (WK_SPRREDRAW_FINE), a

GameMainProcEnd:

    jp NextHTIMIHook
