;
; BIOS SUBROUTINE 
; BIOSサブルーチンの定義
;
CHGMOD:equ $005F
ERAFNK:equ $00CC
KILBUF:equ $0156
SNSMAT:equ $0141

; Work area addresses.
; ワークエリアアドレスの定義
LINWID:equ $F3AF ; WIDTH
RG0SAV:equ $F3DF ; VDP#0 Register
FORCLR:equ $F3E9 ; Fore ground color
BAKCLR:EQU $F3EA ; Back ground color
BDRCLR:equ $F3EB ; Border color

; =================
; H.TIMI hook address
; =================
H_TIMI:equ $FD9F ; H.TIMI hook address

VBLANK_WAIT_FLG:equ $D000
TIMER_COUNTER:equ $D001
ADDR_BACK:equ $D002
H_TIMI_BACKUP:equ $D004

; VDPポート番号(定数)
CONST_VDPPORT0:equ $98
CONST_VDPPORT1:equ $99

; 表示するキャラクタコード
DISP_CHAR_CODE:equ $D009

; キャラクタのアニメーション番号
ANIME_NUM:equ $D00A

; 乱数生成SEED値
RANDOM_SEED:equ $D00B

; ダブルバッファリング
; 仮想VRAM用(768バイト)
VIRTVRAM:equ $D00C

; スクロール用(768バイト)
SCROLLBUF:equ $D30C

; LAST　COL生成用(32バイト)
SCREENLASTCOL:equ $D60C

; LAST COLのアドレス(2バイト)
SCREENLASTCOLADDR:equ $D62C

; スクロール先アドレス(２バイト)
SCROLLDESTADDR:equ $D62E

; 画面書き換え可能フラグ(1バイト)
PATTERNNAMETB_REDRAW:equ $D62F

;------------
; AKGが使用するワークエリアはD900H - DA00Hまでの256バイト
;------------

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

; Main procedure.
; メイン処理
MAIN:

    xor a
    ld (TIMER_COUNTER), a
    ld (ANIME_NUM), a

    ; Initialize screen
    ; 画面の初期化
    ld a, $0F
    ld (FORCLR), a 
    ld a, $01
    ld (BAKCLR), a 
    ld (BDRCLR), a

    ;SCREEN1,2
    ld a,(RG0SAV+1)
    or 2
    ld (RG0SAV+1),a 

    ld a, 1          ; SCREEN MODE = 1
    call CHGMOD

    ld a, 32         ;WIDTH=32
    ld (LINWID), a

    ; Disable FUNCTION KEY DISPLAY.
    call ERAFNK

    ; RANDOM SEEDの初期化
    call INITRANDOM
    
    ; VIRTVRAMの初期化
    ld hl, VIRTVRAM
    ld bc, 768
    ld a, $20
    call MEMFIL
    
    ; スプライトの初期化
    ld hl, SPRITE_PTN
    ld de, $3800
    ld bc, 8 * 4 * 3
    call WRTVRMSERIAL
    
    ld hl, SPRITE_ATTR
    ld de, $1B00
    ld bc, 4 * 3
    call WRTVRMSERIAL
    
    ; 星が目に眩しいのでフォアカラーを12（濃い緑）にする
    ld hl, $2000 + $80 / 8
    ld a, $C1
    call WRTVRM
    
    ; 88Hのキャラクタパターンを作成する
    ld hl, ANME_7_PTN
    ld de, $88 * 8
    ld bc, 8
    call WRTVRMSERIAL

    ld hl, $2000 + $88 / 8
    ld a, $81
    call WRTVRM

    ld a, 5
    ld (TIMER_COUNTER), a

    ; 画面書き換え可能フラグの初期化
    xor a
    ld (PATTERNNAMETB_REDRAW), a
    
    ; AKG Playerの初期化
    ld hl, TRAINING_BGM_START
    xor a
    call PLY_AKG_INIT

    ; AKG Sound Effectの初期化
    ld hl, SOUNDEFFECTS
    call PLY_AKG_INITSOUNDEFFECTS

    ;=============================
    ; Initialize H.TIMI Handler
    ; H.TIMIのHOOK処理を変更する
    ;=============================
    xor a
    ld (VBLANK_WAIT_FLG), a
    call INIT_H_TIMI_HANDLER

;==================================
; Wait for H_TIMI(VBLANK) and call your procedure
; each time VBLANK.
; H_TIMI（VBLANK）を待ち
; VBLANKのつど、自分の処理を呼び出す
;==================================
H_TIMI_HOOK_LOOP:

    ;
    ; Set one to VBLANK_WAIT_FLG
    ; VBLANK_WAIT_FLGに1をセットする
    ;
    ; The value of this variable is updated to 0 by the 
    ; H_TIMI_HANDLER process when H.TIMI is hooked.
    ; 変数の値はH_TIMI_HANDLER処理にて0に更新される
    ;
    ld a, 1
    ld (VBLANK_WAIT_FLG), a
    
    ;=============================
    ; Jump to the REDRAW_SCREEN procedure.
    ; Return to VBLAN_WAIT when REDRAW_SCREEN
    ; process is finished.
    ; Rewriting this process to a process of 
    ; your choice will cause H.TIMI to call your process.
    ; [attention]
    ; Note that strictly speaking, 
    ; this part of the process does not have the 
    ; same timing as VBLANKING, and the timing is unstable; 
    ; if it must be contained within VBLANKING, 
    ; it should be placed in the H_TIMI_HANDLER subroutine.
    ;
    ; REDRAW_SCREEN処理にジャンプする
    ; REDRAW_SCREEN処理が終わったらVBLAN_WAITに
    ; 戻る
    ; この処理を自分の好きな処理に書き換えることで
    ; H.TIMIに自分の処理が呼ばれるようになる
    ; [注意]
    ; 厳密にはこの処理部分はVBLANKINGと同じタイミングではなく
    ; タイミングは不安定であることに注意する。
    ; VBLANKING内に処理を収める必要性がある場合は
    ; H_TIMI_HANDLERサブルーチンに中に記述すること。
    ;=============================
    jp REDRAW_SCREEN
 
 VBLANK_WAIT:

    ; Wait the VBLANK
    ; Wait for the value of VBLANK_FLG 
    ; to be updated to 0 by the occurrence of 
    ; the next VBLANK.
    ;
    ; VBLANKを待つ
    ; 次のVBLANKのタイミングにて
    ; VBLANK_FLGが0に更新されるのを待つ
    ;
    ld a, (VBLANK_WAIT_FLG)
    or a
    jr nz,VBLANK_WAIT
 
    ; Goto H_TIMI_HOOK_LOOP
    ; H_TIMI_HOOK_LOOPにジャンプする
    jp H_TIMI_HOOK_LOOP

;================================
; Initialized H.TIMI Interrupt routine
; H.TIMI割り込み時に呼ばれる処理を初期化する
;================================
INIT_H_TIMI_HANDLER:

    push af
    push bc
    push de
    push hl

    di ; Disable Interrupt.

    ; Backup H.TIMI original procedure
    ; もともと存在していたH.TIMI処理を退避する
    ld hl, H_TIMI
    ld de, H_TIMI_BACKUP
    ld bc, 5
    ldir

    ; Override the H.TIMI procedure
    ; H.TIMI処理処理を書き換える
    ld a, $C3
    ld hl, H_TIMI_HANDLER
    ld (H_TIMI + 0), a
    ld (H_TIMI + 1), hl

    ei ; Enable Interrupt.

    pop hl
    pop de
    pop bc
    pop af

    ret

;=================================
; This program's own H.TIMI hook process. 
; At the end of this process, it jumps to the 
; original H.TIMI process.
; この処理は独自のH.TIMI処理となる
; この処理の終了後に本来のH.TIMI処理を呼び出す
;=================================
H_TIMI_HANDLER:

    ; Decrement VBLANK_WAIT_FLG variable.
    ; most every 1/60 second.
    ; 1/60秒ごとにVBLANK_WAIT_FLGの内容をチェックし
    ; 0であれば本来のH.TIMI処理を呼び出す
    ;  
    ld a, (VBLANK_WAIT_FLG)
    or a
    
    ;
    ; Call original H.TIMI hook procedure.
    ; most every 1/60 second.
    ; 本来のH.TIMI処理を呼び出す
    ;
    jr z, H_TIMI_HANDLER_GO_BACKUPPROC
        
    ; Set zero to VBLANK_WAIT_FLG variable.
    ; VBLANK_WAIT_FLGの値をゼロにする
    dec a
    ld (VBLANK_WAIT_FLG), a

H_TIMI_HANDLER_GO_BACKUPPROC:

    ; If you want to confine the 
    ; process within VBLANKING, 
    ; describe the process here.
    ; VBLANKING内に処理を閉じ込めたい場合は
    ; ここに処理を記述する。

    ; AKG Playerの処理
    call PLY_AKG_PLAY

    ; PATTERNNAMETB_REDRAWが1であれば
    ; VIRTVRAMの内容をVRAMのパターンネームテーブル
    ; 1820Hに書き込む

    ld a, (PATTERNNAMETB_REDRAW)
    or a
    jr z, SkipPatterNameTableRedraw

    ld a, $80
    ld (DISP_CHAR_CODE), a
    ld de, $80 * 8
    call CREATE_CHAR_PATTERN

    ld hl, VIRTVRAM + 32
    ld de, $1820
    ld bc, 736
    call WRTVRMSERIAL

    ld hl, TITLE_MSG
    ld de, $1800
    ld bc, 15
    call WRTVRMSERIAL

    xor a
    ld (PATTERNNAMETB_REDRAW), a

SkipPatterNameTableRedraw:

    ; Submit the original H.TIMI procedure.
    ; H_TIMI_BACKUPに戻る
    jp H_TIMI_BACKUP
    
;
; Redraw screen.
;
; タイトル行までスクロールさせようとするとタイトルがチラつくため
; 画面上のスクロール表示領域は1820H-1AFFHまでとする
; 当処理では仮想VRAMを対象とする
;
REDRAW_SCREEN:

    ; キー入力を受け付ける
    call KILBUF
    ld a, 5
    call SNSMAT

    ; Zキーが押された？
    cp 01111111B
    jr z, PUSHZKEY

    ; Xキーが押された？
    cp 11011111B
    jr z, PUSHXKEY

    jr REDRAW_PROC

PUSHZKEY:

    ; 効果音を鳴らす
    ld a, $01 ; SOUND EFFECT NUMBER
    ld c, 2   ; CHANNEL ( 0 - 2 )
    ld b, 0   ; VOLUME ( 0 - 16 : 0=Full Volume)
    call PLY_AKG_PLAYSOUNDEFFECT

    jr REDRAW_PROC

PUSHXKEY:

    ; 効果音を鳴らす
    ld a, $02 ; SOUND EFFECT NUMBER
    ld c, 2   ; CHANNEL ( 0 - 2 )
    ld b, 0   ; VOLUME ( 0 - 16 : 0=Full Volume)
    call PLY_AKG_PLAYSOUNDEFFECT

REDRAW_PROC:

    ld a, (TIMER_COUNTER)
    or a
    jp nz, REDRAW_SCREEN_DEC_END

    ; 画面のいちばん右端の行に該当するメモリエリアを初期化する
    ld hl, SCREENLASTCOL
    ld bc, 24
    ld a, $20
   
    call MEMFIL

REDRAW_SCREEN_DISPLAY_SETLASTCOL:

    ld b, 24
    
    ld hl, SCREENLASTCOL + 24
    
    ; 24個ぶんランダムに$80Hを配置する
    ; 乱数はRレジスタを使う
    
REDRAW_SCREEN_DISPLAY_LOOP:

    ld a, $20
    ld (DISP_CHAR_CODE), a
    
    ; 乱数値が20以下であれば星のキャラクタを表示する
    call RANDOMVALUE
    cp 21
    jp nc, REDRAW_SCREEN_DISPLAY_LOOP_NEXT
    
    ; 乱数値が6以上であれば緑色のキャラを表示
    cp 6
    jp nc, GREENCHAR

    ; 乱数値が5以下であれば赤色のキャラを表示
    ld a, $88
    ld (DISP_CHAR_CODE), a
    
    jp REDRAW_SCREEN_DISPLAY_LOOP_NEXT
    
GREENCHAR:

    ld a, $80
    ld (DISP_CHAR_CODE), a

REDRAW_SCREEN_DISPLAY_LOOP_NEXT:

    ld a, (DISP_CHAR_CODE)

    dec hl
    ld (hl), a
    
    djnz REDRAW_SCREEN_DISPLAY_LOOP 

    ; VIRTVRAMを左にスクロールさせる
    ld a, 0
    
    ; ここから下は右から左にスクロールさせる処理

    ld bc, SCREENLASTCOL
    ld (SCREENLASTCOLADDR), bc
    
    ld hl, VIRTVRAM + 1
    ld (ADDR_BACK), hl
    
    ld hl, SCROLLBUF
    ld (SCROLLDESTADDR), hl
    
MULTILOOP1:

    push af

    ; VIRTVRAMの1列目から31バイトを
    ; SCROLLBUFの0列目に転送する
    ld hl, (ADDR_BACK) ; 転送元アドレス(1列目)    
    ld de, (SCROLLDESTADDR) ; 転送先アドレス(SCROLL_BUFの0列目)
    
    ld bc, 31
    ldir
    
    pop af

    ; SCROLLBUFの32バイト目にSCREENLASTCOLの
    ; 情報を1バイトつける
    ld hl, (SCROLLDESTADDR)
    ld b, 0
    ld c, 31
    add hl, bc
    ld d, h
    ld e, l
    
    ld b, a ; Aレジスタの値をバックアップ
    ld hl, (SCREENLASTCOLADDR)
    ld a, (hl)
    ld (de), a
    inc hl ; SCREENLASTCOLADDRのアドレスを1進める
    ld (SCREENLASTCOLADDR), hl
    
    ld a, b
    cp 23
    jp z, REDRAW_SCREEN_DISP
    
    inc a ; 次の転送元行を進めてループに戻る
    
    ; 転送元アドレス、転送先アドレスに32を加算する
    ld b, 0
    ld c, 32
    ld hl, (ADDR_BACK)
    add hl, bc
    ld (ADDR_BACK), hl
    
    ld hl, (SCROLLDESTADDR)
    add hl, bc
    ld (SCROLLDESTADDR), hl
    
    jp MULTILOOP1
    
REDRAW_SCREEN_DISP:

    ; SCROLLBUFの内容をVIRTVRAMに転送する
    ld hl, SCROLLBUF
    ld de, VIRTVRAM
    ld bc, 768
    ldir
    
    ld a, 1
    ld (PATTERNNAMETB_REDRAW), a

    jp REDRAW_SCREEN_INIT_TIMER

REDRAW_SCREEN_INIT_TIMER:

    ; TIMER_COUNTERを初期化する
    ld a, 5
    ld (TIMER_COUNTER), a
    jp REDRAW_SCREEN_END
    
REDRAW_SCREEN_DEC_END:

    ; TIMER_COUNTERをデクリメントする
    ld a, (TIMER_COUNTER)
    dec a
    ld (TIMER_COUNTER), a
    
REDRAW_SCREEN_END:

    ; VBLANK_WAITに戻り次のH.TIMIを待つ
    jp VBLANK_WAIT

;==================================
; DEレジスタに格納されているVRAMアドレスに
; ANIME_0_PTNからANIME_7_PTNのいずれかの
; データを8バイト転送する
;==================================
CREATE_CHAR_PATTERN:

    push hl
    push de
    push bc

    ; パターンデータの位置を特定する
    ld a, (ANIME_NUM)
    add a, a ; A=Ax2
    add a, a ; A=Ax4
    add a, a ; A=Ax8
    ld b, 0
    ld c, a
    
    ld hl, ANIME_CHAR_PTN
    add hl, bc
    ld b, 0
    ld c, 8
    
    call WRTVRMSERIAL
    
    pop bc
    pop de
    pop hl

    ret

MEMFIL:

MEMFILLOOP:

    ld (hl), a
    cpi
    jp pe, MEMFILLOOP

    ret
    
INITRANDOM:
             
    ld a, r
    ld (RANDOM_SEED), a
    
    ret
    
RANDOMVALUE: 
    
    push bc
    
    ; 乱数のシード値を乱数ワークエリアから取得
    ld a, (RANDOM_SEED)
    ld b, a
    ld a, b

    add a, a ; Aを5倍する
    add a, a ;
    add a, b ;

    add a,123 ; 123を加える

    ld b, a
    ld a, r ; Rレジスタの値を加算
    add a, b

    ; 乱数ワークエリアに保存
    ld (RANDOM_SEED), a

    pop bc

    ret

;  ここから下はVDP直叩きするVRAM操作サブルーチン群

;--------------------------------------------
; SUB-ROUTINE: VDPRED
; VDPポート#1に対してREAD宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPRED:

    push af
    push bc
    push de
    
    di

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 下位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ei

    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: VDPWRT
; VDPポート#1に対してWRITE宣言を行う
; HLレジスタにVRAMアドレスをセットして呼び出す
;--------------------------------------------
VDPWRT:

    push af
    push bc
    push de

    di

    ld a, l                    ; 下位8ビット
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ld a, h                    ; 上位8ビット
    and $3F                    ; 第7ビット、第6ビットを0にする
    or  $40                    ; 第6ビットを1にする(WRITE-MODE)
    
    out (CONST_VDPPORT1), a    ; (12)
    nop                        ; (05)
    nop                        ; (05)

    ei

    pop de
    pop bc
    pop af

    ret

;--------------------------------------------
; SUB-ROUTINE: REDVRM
; HLレジスタにセットされたVRAMアドレスの
; 値を1バイトだけ読み込みAレジスタに格納する
; HLレジスタは読み込み後インクリメントされる
;--------------------------------------------
REDVRM:

    ; 読み込み宣言
    call VDPRED

    ; 読み込み
    in a, (CONST_VDPPORT0)    ; (12)
    nop                       ; (05)
    nop                       ; (05)

    ret

;--------------------------------------------
; SUB-ROUTINE: WRTVRM
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値を1バイトだけ書き込む
; HLレジスタは書き込み後インクリメントされる
;--------------------------------------------
WRTVRM:
    
    ; 書き込み宣言
    call VDPWRT

    ; 書き込み
    out (CONST_VDPPORT0), a   ; (12)
    nop                       ; (05)
    nop                       ; (05)

    ret

;---------------------------------------------------
; SUB-ROUTINE: REDVRMSERIAL
; HLレジスタにセットされたメモリアドレスに
; DEレジスタで指定されたVRAMアドレスの内容を
; BCレジスタの値だけ連続して読み込む
; HLレジスタとDEレジスタは
; 書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
REDVRMSERIAL:

    ; HLレジスタの値を退避
    ld (ADDR_BACK), hl

    ; HLレジスタにVRAMアドレスをセット
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPRED

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (ADDR_BACK)

REDVRMSERIALLOOP:

    in a, (CONST_VDPPORT0)     ; (12)
    ld (hl), a                 ; (8)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, REDVRMSERIALLOOP

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMFIL
; HLレジスタにセットされたVRAMアドレスに
; Aレジスタの値をBCレジスタの値だけ連続して書き込む
; HLレジスタは書き込み後BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMFIL:

    ; 書き込み宣言
    call VDPWRT

WRTVRMFILLOOP:

    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMFILLOOP

    ret

;---------------------------------------------------
; SUB-ROUTINE: WRTVRMSERIAL
; HLレジスタにセットされたメモリアドレスの値を
; DEレジスタにセットされたVRAMアドレスに
; BCレジスタの値だけ連続して書き込む
; HLレジスタとDEレジスタは書き込み後
; BCレジスタの数だけ加算される
;---------------------------------------------------
WRTVRMSERIAL:

    ; HLレジスタの値を退避
    ld (ADDR_BACK), hl

    ; HLレジスタにVRAMアドレスをセット
    ld h, d
    ld l, e

    ; 読み込み宣言
    call VDPWRT

    ; HLレジスタに退避したメモリアドレスをセット
    ld hl, (ADDR_BACK)

WRTVRMSERIALLOOP:

    ld a, (hl)
    out (CONST_VDPPORT0), a    ; (12)

    cpi                        ; (18)
                               ; HL = HL + 1, BC = BC - 1
                               ; BC <> 0ならPEフラグが1になる

    jp pe, WRTVRMSERIALLOOP

    ret

; CHARACTER PATTERN
ANIME_CHAR_PTN:
ANIME_0_PTN:
defb $00,$00,$00,$01,$00,$00,$00,$00
ANIME_1_PTN:
defb $00,$00,$00,$02,$00,$00,$00,$00
ANIME_2_PTN:
defb $00,$00,$00,$04,$00,$00,$00,$00
ANIME_3_PTN:
defb $00,$00,$00,$08,$00,$00,$00,$00
ANIME_4_PTN:
defb $00,$00,$00,$10,$0,$00,$00,$00
ANIME_5_PTN:
defb $00,$00,$00,$20,$00,$00,$00,$00
ANIME_6_PTN:
defb $00,$00,$00,$40,$00,$00,$00,$00
ANME_7_PTN:
defb $00,$00,$00,$80,$00,$00,$00,$00

SPRITE_PTN:

; #0-
defb $00, $80, $C0, $60, $70, $3E, $3F, $1F
defb $1F, $3E, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $80, $FE
defb $FF, $00, $00, $00, $00, $00, $00, $00

; #4-
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $01, $3E, $60, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $E0, $00, $00, $00, $00, $00, $00

; #8-
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $00, $00, $00
defb $00, $00, $00, $00, $00, $38, $7C, $00
defb $00, $00, $00, $00, $00, $00, $00, $00

SPRITE_ATTR:

defb 12*8, 5*8, 0, $0F
defb 12*8, 5*8, 4, $07
defb 12*8, 5*8, 8, $06

TITLE_MSG:
defm "MUSIC PLAY DEMO" ; LENGTH 15 byte

;
; AKG Player include.
;
include "AKGPlay.asm"
