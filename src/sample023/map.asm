GenMap:

    ld hl, MAP_DATA
    ld de, WK_VIRT_PTNNAMETBL
    ld bc, 768
    call MemCpy

    ret

MAP_DATA:
defb "````````````````````````````````" ; +0
defb "```````````````````aa```````````" ; +1
defb "```````````````aaaaffa``a`aa````" ; +2
defb "a````a`aaaaaaaafffffffaafaffaaa`" ; +3
defb "fa``afaffffffffffffffffffffffffa" ; +4
defb "ffaaffffffffffffffffffffffffffff" ; +5
defb "ffffffffffffffffffffffffffffffff" ; +6
defb "ffffffffffffffffffffffffffffffff" ; +7
defb "ffffffffffffffffffffffffffffffff" ; +8
defb "ccffccccffffffffffcccccccffffccc" ; +9
defb "aaffaaaadeccccccccaaaaaaaffffaaa" ; +10
defb "ffffffffdeaaaaaaaaffffffffffffff" ; +11
defb "ffffffffdeffffffffffffffffffffff" ; +12
defb "ffffffffdeffffffffffffffffffffff" ; +13
defb "ffffffffdeffffffffffffcccccccfff" ; +14
defb "ccccccccccccccccccccccbbbbbbbccc" ; +15
defb "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" ; +16
defb "                                " ; +17
defb "                                " ; +18
defb "                                " ; +19
defb "                                " ; +20
defb "                                " ; +21
defb "                                " ; +22
defb "                                " ; +23
