dcompr equ $0020
wrtvrm equ $004d
ldivrm equ $005c
chgmod equ $005f
chput equ $00a2
breakx equ $00b7
posit equ $00c6
gtstck equ $00d5
gttrig equ $00d8
t32nam equ $f3db
t32col equ $f3dc
t32cgp equ $f3dd
forclr equ $f3e9
bakclr equ $f3ea
bdrclr equ $f3eb

org $4000

Header:
    defb 'A', 'B', $10, $40, $00, $00, $00, $00
    defb $00, $00, $00, $00, $00, $00, $00, $00

; 変数の初期化
call setInitialData

init: 

ld a,15
ld (forclr),a
ld a,1
ld (bakclr),a
ld (bdrclr),a
call chgmod
call chrset
ld a,$c0
ld (canon),a
ld a,0
ld (joystk),a
call invini
ld a,7
ld (timec1),a
ld ix,canon
call getxy
ld a,(ix+0)
call wrtvrm
call dspinv

main:
call movcan
call snstrg
call mvmisl
call invmov
call hitchk
call mslhit
ld a,(invnin)
cp 55
jr nc,init
ld a,(canon)
cp 0
jr z,init
call breakx
ret c
jr main

getxy:
ld l,(ix+1)
ld h,(ix+2)
ret

putxy:
ld (ix+1),l
ld (ix+2),h
ret

movcan:
ld hl,time2
dec (hl)
ret nz
ld a,(timec2)
ld (hl),a
ld a,(joystk)
call gtstck
cp 3
jr z,right
cp 7
jr z,left
ret

right:
ld ix,canon
call getxy
ld e,l
ld d,h
inc de
ld a,e
and $1f
cp 29
ret nc

movchr:
ld a,' '
call wrtvrm
ex de,hl
call putxy
ld a,(ix+0)
call wrtvrm
ret

left:
ld ix,canon
call getxy
ld e,l
ld d,h
dec de
ld a,e
and $1f
cp 3
ret c
jr movchr

snstrg:
ld a,(joystk)
call gttrig
ld hl,trig
ld c,(hl)
ld (hl),a
and a
ret z
cp c
ret z

fire:
ld ix,misil1
ld a,(ix+0)
and a
jr z,fire1
ld a,(ix+3)
and a
jr z,fire2
ld a,(ix+6)
and a
jr z,fire3
ret

fire1:
ld ix,misil1
jr fireon

fire2:
ld ix,misil2
jr fireon

fire3:
ld ix,misil3

fireon:
ld a,-1
ld (ix+0),a
ld hl,(canon+1)
ld bc,-32
add hl,bc
call putxy
ld a,$c1
call wrtvrm
ret 

mvmisl:
ld hl,time3
dec (hl)
ret nz
ld a,(timec3)
ld (hl),a
ld ix,misil1
call mslchk
ld ix,misil2
call mslchk
ld ix,misil3

mslchk:
ld a,(ix+0)
inc a
ret nz
call getxy
ld d,h
ld e,l
ld bc,-32
add hl,bc
push de
ld de,$181f
rst dcompr
pop de
ex de,hl
jr c,msloff
ld a,' '
call wrtvrm
ex de,hl
call putxy
ld a,$c1
call wrtvrm
ret 

msloff:
ld a,' '
call wrtvrm
xor a
ld (ix+0),a
ret 

mslhit:
ld hl,time4
dec (hl)
ret nz
ld a,(timec4)
ld (hl),a
ld ix,misil1
call hiton
ld ix,misil2
call hiton
ld ix,misil3
call hiton
ret

hiton:
ld a,(ix+0)
cp $f0
ret c
cp $f4
ret nc
call getxy
inc a
cp $f3
jr z,msloff
ld (ix+0),a
call wrtvrm
ret

hitchk:
ld ix,misil1
call hit1
ld ix,misil2
call hit1
ld ix,misil3

hit1:
ld b,70
ld iy,inv1

hit2:
call hitmsl
inc iy
inc iy
inc iy
djnz hit2
ret 

hitmsl:
ld a,(iy+0)
and a
ret z
call getxy
ld e,(iy+1)
ld d,(iy+2)
rst dcompr
ret nz
ld a,(ix+0)
and a
ret z

xor a
ld (iy+0),a
ld a,$f0
ld (ix+0),a
call wrtvrm
ld hl,invnin
inc (hl)
ld a,(hl)
cp 17
call z,spdup
cp 30
call z,spdup
cp 44
call z,spdup
cp 52
call z,spdup
jr hit1

spdup:
ld hl,timec1
dec (hl)
ret 

invmov:
ld hl,time1
dec (hl)
ret nz
ld a,(timec1)
ld (hl),a
ld ix,(invpnt)
ld a,(lrd)
cp 3
jr z,invmvr
cp 5
jr z,invmvd
cp 7
jr z,invmvl
ret

invmvl:
call invll
ret c
inc ix
inc ix
inc ix
ld (invpnt),ix
ld hl,invtim
dec (hl)
jr z,mvl
ld a,(ix-3)
and a
jr z,invmvl
ret 

mvl:
ld (hl),55
ld hl,inv1
ld (invpnt),hl
ret 

invmvr:
call invrr
ret c
dec ix
dec ix
dec ix
ld (invpnt),ix
ld hl,invtim
dec (hl)
jr z,mvr
ld a,(ix+3)
and a
jr z,invmvr
ret 

mvr:
ld (hl),55
ld hl,inv55
ld (invpnt),hl
ret

invmvd:
call invdwn
inc ix
inc ix
inc ix
ld (invpnt),ix
ld hl,invtim
dec (hl)
jr z,mvd
ld a,(ix-3)
and a
jr z,invmvd
ret

mvd:
ld (hl),55
ld a,(lr)
cp 7
jr nz,invnxt
ld hl,inv55
ld (invpnt),hl
ld a,3
ld (lrd),a
ret

invnxt:
ld hl,inv1
ld (invpnt),hl
ld a,7
ld (lrd),a
ret

invll:
ld a,(ix+0)
and a
ret z
call getxy
ld d,h
ld e,l
dec de
ld a,e
and $1f
cp 0
jr z,invdd

invlr:
ld a,' '
push de
call wrtvrm
call walk
pop hl
ld a,(ix+0)
call putxy
call wrtvrm
ld de,$1800+736
rst dcompr
call nc,canhit

and a
ret

invrr:
ld a,(ix+0)
and a
ret z
call getxy
ld d,h
ld e,l
inc de
ld a,e
and $1f
cp $1f
jr z,invdd
jr invlr

invdd:
ld a,(lrd)
ld (lr),a
ld a,5
ld (lrd),a
ld a,(invtic)
ld (invtim),a
ld hl,inv1
ld (invpnt),hl
scf 
ret

invdwn:
ld a,(ix+0)
and a
ret z
call getxy
ld d,h
ld e,l
ld bc,32
add hl,bc
ex de,hl
jr invlr

walk:
bit 0,(ix+0)
jr z,walk2

walk1:
res 0,(ix+0)
ret

walk2:
set 0,(ix+0)
ret

canhit:
ld a,0
ld (canon),a
ret

invini:
ld hl,inv1
ld (invpnt),hl
xor a
ld (invnin),a
ld b,11
ld hl,$1928
ld de,-64

ld ix,inv1

invin1:
push hl
ld c,5

invin2:
push hl
push de
ld hl,invchr-1
ld d,0
ld e,c
add hl,de
ld a,(hl)
pop de
pop hl
ld (ix+0),a
ld (ix+1),l
ld (ix+2),h
add hl,de
inc ix
inc ix
inc ix
dec c
jr nz,invin2
pop hl
inc hl
inc hl
djnz invin1
ld hl,invdat
ld de,invtic
ld bc,5
ldir 
ret

dspinv:
ld b,55
ld ix,inv1

dsplop:
ld a,(ix+0)
call getxy
call wrtvrm
inc ix
inc ix
inc ix
djnz dsplop
ret

invchr:
defb $c8,$d0,$d0,$d8,$d8

invdat:
defb 55,55,0,7,7

chrset:
ld hl,chrdat
ld de,$c0*8
ld bc,16
call ldivrm
ld hl,chrda1
ld de,$c8*8
ld bc,16
call ldivrm
ld hl,chrda2
ld de,$d0*8
ld bc,16
call ldivrm
ld hl,chrda3
ld de,$d8*8
ld bc,16
call ldivrm
ld hl,chrda4
ld de,$f0*8
ld bc,48
call ldivrm
ld hl,color
ld de,$2018
ld bc,7
call ldivrm
ret

; 変数配置領域はPage#2(C000H-)なので
; それまでの領域をFFHで埋める
; 埋めるサイズ＝8000H(32KB) - カレント位置
chrdat:
defb $00,$18,$18,$7e,$ff,$ff,$ff,$00
defb $00,$18,$18,$18,$18,$18,$18,$00

chrda1:
defb $18,$3c,$7e,$db,$ff,$24,$5a,$a5
defb $18,$3c,$7e,$db,$ff,$5a,$81,$00

chrda2:
defb $c3,$3c,$7e,$ff,$db,$ff,$00,$00
defb $c3,$3c,$7e,$ff,$db,$ff,$00,$00

chrda3:
defb $81,$a5,$bd,$ff,$bd,$7e,$00,$00
defb $42,$24,$3c,$ff,$bd,$ff,$00,$00

chrda4:
defb $10,$44,$10,$aa,$10,$44,$10,$00
defb $00,$10,$28,$54,$28,$10,$00,$00
defb $00,$00,$10,$28,$10,$00,$00,$00
defb $10,$08,$10,$20,$10,$08,$10,$00

color:
defb $e0,$20,$40,$d0,$00,$00,$60,$00

; ------------------------------------------
; ここから変数領域
; 変数領域はPage#3(C000H以降)に配置する必要があります
; ------------------------------------------

timec1:equ $C000  ; 1 byte
timec2:equ $C001  ; 1 byte
timec3:equ $C002  ; 1 byte
timec4:equ $C003  ; 1 byte
joystk:equ $C004  ; 1 byte
trig:equ   $C005  ; 1 byte
canon:equ  $C006  ; 3 byte
misil1:equ $C009  ; 3 byte
misil2:equ $C00C  ; 3 byte
misil3:equ $C00F  ; 3 byte
time1:equ  $C012  ; 1 byte
time2:equ  $C013  ; 1 byte
time3:equ  $C014  ; 1 byte
time4:equ  $C015  ; 1 byte
invtic:equ $C016  ; 1 byte
invtim:equ $C017  ; 1 byte
invnin:equ $C018  ; 1 byte
lrd:equ    $C019  ; 1 byte
lr:equ     $C01A  ; 1 byte
invpnt:equ $C01B  ; 2 byte
inv1:equ   $C01D  ; 3*54 byte (C01DH - C0BFH)
inv55:equ  $C0BF  ; 3 byte

; 変数領域に初期値をセットする
setInitialData:

  ld a, 7
  ld (timec1), a
  ld (timec2), a
  ld a, 5
  ld (timec3), a
  ld a, 7
  ld (timec4), a
  xor a
  ld (joystk), a
  ld (trig), a
  ld a, $c0
  ld (canon), a
  ld hl, $1800 + 752
  ld (canon + 1), hl

  xor a
  ld (misil1), a
  ld (misil2), a
  ld (misil3), a
  ld (misil1 + 1), a
  ld (misil2 + 1), a
  ld (misil3 + 1), a
  ld (misil1 + 2), a
  ld (misil2 + 2), a
  ld (misil3 + 2), a

  ld a, 1
  ld (time1), a
  ld (time2), a
  ld (time3), a
  ld (time4), a
  ld a, 55
  ld (invtic), a
  ld (invtim), a
  xor a
  ld (invnin), a
  ld a, 7
  ld (lrd), a
  ld (lr), a
  ld hl, inv1
  ld (invpnt), hl

  ld hl, inv1
  ld b, 3*54
  xor a

inv1_memset:
  ld (hl), a
  inc hl
  djnz inv1_memset

  xor a
  ld (inv55), a
  ld (inv55 + 1), a
  ld (inv55 + 2), a

  ret
