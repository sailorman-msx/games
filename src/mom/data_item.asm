;--------------------------------------------
; アイテム関連のデータ集
;--------------------------------------------

; ここから下は武器のデータ
; カラーコードはWK_PLAYERSPRCLR3にセットする

EQUIP_DATA_STR:

EQUIP_DATA_STR_NOSWORD:
defb 0         ; カラーコード
defb 3         ; STR補正値

EQUIP_DATA_STR_SHORTSWORD:
defb 15        ; カラーコード(白)
defb 4         ; STR補正値

EQUIP_DATA_STR_LONGSWORD:
defb 10        ; カラーコード(黄)
defb 5         ; STR補正値

EQUIP_DATA_STR_DIAMOND_SWORD:
defb 7         ; カラーコード(水色)
defb 7         ; STR補正値

EQUIP_DATA_STR_MAGESLAYER:
defb 8         ; カラーコード(赤)
defb 9         ; STR補正値

EQUIP_DATA_DEF:

; ここから下は防具のデータ
; カラーコードはWK_PLAYERSPRCLR1にセットする

EQUIP_DATA_DEF_NOARMOR:
defb 13        ; カラーコード（紫）
defb 3         ; DEF補正値

EQUIP_DATA_DEF_LEATHER_ARMOR:
defb 6         ; カラーコード(暗赤)
defb 4         ; DEF補正値

EQUIP_DATA_DEF_HARD_ARMOR:
defb 4         ; カラーコード(青)
defb 5         ; DEF補正値

EQUIP_DATA_DEF_CHAIN_MAIL:
defb 14        ; カラーコード(白色)
defb 6         ; DEF補正値

EQUIP_DATA_DEF_DIAMOND_ARMOR:
defb 7         ; カラーコード(水色)
defb 7         ; DEF補正値

;-----------------------------------
; ここから下はPITのアイテム値
;-----------------------------------
PIT_ITEMS:

; MAP X=0, Y=0
defw $0000
defb $11  ; 宝箱：SHORT SWORD

; MAP X=0, Y=2
defw $0002
defb $85  ; 宝箱：BLUE KEY

; MAP X=0, Y=5
defw $0005
defb $21  ; 宝箱：LEATHER ARMOR

; MAP X=1, Y=2
defw $0102
defb $02  ; FIRE RING

; MAP X=1, Y=3
defw $0103
defb $12  ; 宝箱：LONG SWORD

; MAP X=1, Y=5
defw $0105
defb $85  ; 宝箱：BLUE KEY

; MAP X=2, Y=1
defw $0201
defb $88  ; 宝箱：PASSPORT

; MAP X=2, Y=5
defw $0205
defb $01  ; POWER RING

; MAP X=3, Y=3
defw $0303
defb $03  ; LIGHT RING

; MAP X=3, Y=5
defw $0305
defb $84  ; 宝箱：YELLOW KEY

; MAP X=4, Y=3
defw $0403
defb $04  ; SPELLOFF RING

; MAP X=4, Y=5
defw $0405
defb $23  ; 宝箱；CHAIN MAIL

; MAP X=5, Y=0
defw $0500
defb $24  ; 宝箱：DIAMOND ARMOR

; MAP X=5, Y=2
defw $0502
defb $13  ; 宝箱：DIAMOND SWORD

; MAP X=5, Y=4
defw $0504
defb $22  ; 宝箱；HARD ARMOR

defw $FFFF ; EOD
