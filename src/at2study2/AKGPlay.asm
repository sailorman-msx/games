TRAINING_BGM_START:
PLY_AKG_OFFSET2B:
PLY_AKG_OFFSET1B:
PLY_AKG_OPCODE_OR_A:
PLY_AKG_OPCODE_ADD_HL_BC_MSB:
    db 65 
PLY_AKG_FULL_INIT_CODE:
PLY_AKG_USE_HOOKS:
PLY_AKG_STOP_SOUNDS:
    db 84 
PLY_AKG_BITFORSOUND:
PLY_AKG_SOUNDEFFECTDATA_OFFSETINVERTEDVOLUME:
RASM_VERSION:
    db 50 
PLY_AKG_SOUNDEFFECTDATA_OFFSETCURRENTSTEP:
    db 48 
PLY_AKG_BITFORNOISE: equ $+1 
PLY_AKG_SOUNDEFFECTDATA_OFFSETSPEED:
    dw TRAINING_BGM_ARPEGGIOTABLE 
    dw TRAINING_BGM_ARPEGGIOTABLE 
PLY_AKG_OPCODE_ADD_HL_BC_LSB: equ $+1 
    dw TRAINING_BGM_ARPEGGIOTABLE 
    dw TRAINING_BGM_EFFECTBLOCKTABLE 
    dw TRAINING_BGM_EFFECTBLOCKTABLE 
TRAINING_BGM_ARPEGGIOTABLE:
TRAINING_BGM_PITCHTABLE:
TRAINING_BGM_INSTRUMENTTABLE:
    dw TRAINING_BGM_EMPTYINSTRUMENT 
    dw TRAINING_BGM_INSTRUMENT1 
    dw TRAINING_BGM_INSTRUMENT2 
    dw TRAINING_BGM_INSTRUMENT3 
TRAINING_BGM_EMPTYINSTRUMENT:
    db 0 
TRAINING_BGM_EMPTYINSTRUMENT_LOOP:
    db 0 
    db 6 
TRAINING_BGM_INSTRUMENT1:
    db 1 
    db 248 
    db 1 
    db 113 
    db 37 
    db 150 
    db 0 
    db 105 
    db 34 
    db 44 
PLY_AKG_OPCODE_INC_HL:
    db 1 
    db 97 
    db 32 
    db 144 
    db 1 
    db 89 
    db 32 
    db 244 
PLY_AKG_OPCODE_DEC_HL:
    db 1 
    db 81 
    db 32 
    db 88 
    db 2 
    db 6 
TRAINING_BGM_INSTRUMENT2:
    db 1 
    db 248 
    db 1 
    db 232 
    db 1 
    db 216 
    db 1 
    db 192 
    db 1 
    db 168 
    db 1 
    db 6 
TRAINING_BGM_INSTRUMENT3:
    db 1 
    db 249 
    db 241 
    db 233 
    db 225 
TRAINING_BGM_INSTRUMENT3_LOOP:
PLY_AKG_OPCODE_SBC_HL_BC_LSB:
    db 217 
    db 7 
    dw TRAINING_BGM_INSTRUMENT3_LOOP 
TRAINING_BGM_EFFECTBLOCKTABLE:
TRAINING_BGM_SUBSONG0_START:
    db 2 
    db 1 
    db 1 
    db 0 
    db 0 
    db 11 
    db 17 
TRAINING_BGM_SUBSONG0_LINKER:
TRAINING_BGM_SUBSONG0_LINKER_LOOP:
    dw TRAINING_BGM_SUBSONG0_TRACK0 
    dw TRAINING_BGM_SUBSONG0_TRACK1 
    dw TRAINING_BGM_SUBSONG0_TRACK2 
    dw TRAINING_BGM_SUBSONG0_LINKERBLOCK0 
    db 0 
    db 0 
    dw TRAINING_BGM_SUBSONG0_LINKER 
TRAINING_BGM_SUBSONG0_LINKERBLOCK0:
    db 64 
    db 0 
    db 0 
    db 0 
    dw TRAINING_BGM_SUBSONG0_SPEEDTRACK0 
    dw TRAINING_BGM_SUBSONG0_EVENTTRACK0 
TRAINING_BGM_SUBSONG0_TRACK0:
    db 171 
    db 3 
    db 171 
    db 2 
    db 173 
    db 3 
    db 171 
    db 2 
    db 170 
    db 3 
    db 171 
    db 2 
    db 171 
    db 3 
    db 171 
    db 2 
    db 170 
    db 3 
    db 43 
    db 42 
    db 43 
    db 60 
    db 43 
    db 171 
    db 2 
    db 173 
    db 3 
    db 171 
    db 2 
    db 170 
    db 3 
    db 171 
    db 2 
    db 171 
    db 3 
    db 171 
    db 2 
    db 170 
    db 3 
    db 43 
    db 42 
    db 43 
    db 171 
    db 2 
    db 178 
    db 3 
    db 171 
    db 2 
    db 43 
    db 175 
    db 3 
    db 171 
    db 2 
    db 173 
    db 3 
    db 171 
    db 2 
    db 178 
    db 3 
    db 171 
    db 2 
    db 176 
    db 3 
    db 171 
    db 2 
    db 175 
    db 3 
    db 171 
    db 2 
    db 173 
    db 3 
    db 171 
    db 2 
    db 43 
    db 171 
    db 3 
    db 171 
    db 2 
    db 171 
    db 3 
    db 45 
    db 171 
    db 2 
    db 175 
    db 3 
    db 171 
    db 2 
    db 175 
    db 3 
    db 55 
    db 60 
    db 54 
    db 171 
    db 2 
    db 175 
    db 3 
    db 50 
    db 50 
PLY_AKG_OPCODE_JP:
    db 171 
    db 2 
    db 176 
PLY_AKG_OPCODE_ADD_A_IMMEDIATE:
    db 3 
    db 171 
    db 2 
    db 171 
    db 3 
    db 171 
    db 2 
    db 173 
    db 3 
    db 61 
    db 127 
TRAINING_BGM_SUBSONG0_TRACK1:
    db 166 
    db 1 
    db 60 
    db 38 
    db 60 
PLY_AKG_OPCODE_SUB_IMMEDIATE:
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 38 
    db 62 
    db 38 
    db 38 
    db 60 
    db 42 
    db 42 
    db 42 
    db 62 
    db 38 
    db 60 
    db 38 
PLY_AKG_OPCODE_SBC_HL_BC_MSB:
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
    db 60 
    db 38 
PLY_AKG_OPCODE_SCF:
    db 60 
    db 38 
    db 60 
    db 38 
    db 38 
    db 62 
    db 38 
    db 38 
    db 62 
    db 38 
    db 38 
    db 62 
    db 38 
    db 61 
    db 127 
TRAINING_BGM_SUBSONG0_TRACK2:
    db 61 
    db 127 
TRAINING_BGM_SUBSONG0_SPEEDTRACK0:
    db 255 
TRAINING_BGM_SUBSONG0_EVENTTRACK0:
    db 255 
SOUNDEFFECTS:
    dw SOUNDEFFECTS_SOUND1 
    dw SOUNDEFFECTS_SOUND2 
    dw TRAINING_BGM_START 
    dw TRAINING_BGM_START 
    dw TRAINING_BGM_START 
SOUNDEFFECTS_SOUND1:
    db 0 
SOUNDEFFECTS_SOUND1_LOOP:
    db 189 
    db 1 
    db 168 
    db 0 
    db 189 
    db 1 
    db 172 
    db 0 
    db 177 
    db 1 
    db 175 
    db 0 
    db 173 
    db 1 
    db 179 
    db 0 
    db 4 
SOUNDEFFECTS_SOUND2:
    db 1 
SOUNDEFFECTS_SOUND2_LOOP:
    db 189 
    db 1 
    db 22 
    db 2 
    db 189 
    db 8 
    db 54 
    db 2 
    db 185 
    db 2 
    db 200 
    db 2 
    db 181 
    db 16 
    db 121 
    db 1 
    db 177 
    db 2 
    db 144 
    db 1 
    db 173 
    db 2 
    db 168 
    db 1 
    db 165 
    db 16 
    db 123 
    db 2 
    db 157 
    db 31 
    db 212 
    db 0 
    db 153 
    db 7 
    db 141 
    db 0 
    db 4 
PLY_AKG_START:
    jp PLY_AKG_INIT 
    jp PLY_AKG_PLAY 
    jp PLY_AKG_INITTABLEJP_END 
PLY_AKG_INITSOUNDEFFECTS:
    ld (PLY_AKG_PTSOUNDEFFECTTABLE),hl 
    ret
PLY_AKG_PLAYSOUNDEFFECT:
    dec a 
    ld hl,(PLY_AKG_PTSOUNDEFFECTTABLE) 
    ld e,a 
    ld d,0 
    add hl,de 
    add hl,de 
    ld e,(hl) 
    inc hl 
    ld d,(hl) 
    ld a,(de) 
    inc de 
    ex af,af' 
    ld a,b 
    ld hl,PLY_AKG_CHANNEL1_SOUNDEFFECTDATA 
    ld b,0 
    sla c 
    sla c 
    sla c 
    add hl,bc 
    ld (hl),e 
    inc hl 
    ld (hl),d 
    inc hl 
    ld (hl),a 
    inc hl 
    ld (hl),0 
    inc hl 
    ex af,af' 
    ld (hl),a 
    ret
PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL:
    add a,a 
    add a,a 
    add a,a 
    ld e,a 
    ld d,0 
    ld hl,PLY_AKG_CHANNEL1_SOUNDEFFECTDATA 
    add hl,de 
    ld (hl),d 
    inc hl 
    ld (hl),d 
    ret
PLY_AKG_PLAYSOUNDEFFECTSSTREAM:
    rla 
    rla
    ld ix,PLY_AKG_CHANNEL1_SOUNDEFFECTDATA 
    ld iy,PLY_AKG_PSGREG8 
    ld hl,PLY_AKG_PSGREG01_INSTR 
    exx
    ld c,a 
    call PLY_AKG_PSES_PLAY 
    ld ix,PLY_AKG_CHANNEL2_SOUNDEFFECTDATA 
    ld iy,PLY_AKG_PSGREG9_10_INSTR 
    exx
    ld hl,PLY_AKG_PSGREG23_INSTR 
    exx
    srl c 
    call PLY_AKG_PSES_PLAY 
    ld ix,PLY_AKG_CHANNEL3_SOUNDEFFECTDATA 
    ld iy,PLY_AKG_PSGREG10 
    exx
    ld hl,PLY_AKG_PSGREG45_INSTR 
    exx
    scf
    rr c 
    call PLY_AKG_PSES_PLAY 
    ld a,c 
    ret
PLY_AKG_PSES_PLAY:
    ld l,(ix+0) 
    ld h,(ix+1) 
    ld a,l 
    or h 
    ret z 
PLY_AKG_PSES_READFIRSTBYTE:
    ld a,(hl) 
    inc hl 
    ld b,a 
    rra
    jr c,PLY_AKG_PSES_SOFTWAREORSOFTWAREANDHARDWARE 
    rra
    rra
PLY_AKG_PSES_S_ENDORLOOP:
    xor a 
    ld (ix+0),a 
    ld (ix+1),a 
    ret
PLY_AKG_PSES_SAVEPOINTERANDEXIT:
    ld a,(ix+3) 
    cp (ix+4) 
    jr c,PLY_AKG_PSES_NOTREACHED 
    ld (ix+3),0 
    ld (ix+0),l 
    ld (ix+1),h 
    ret
PLY_AKG_PSES_NOTREACHED:
    inc (ix+3) 
    ret
PLY_AKG_PSES_SOFTWAREORSOFTWAREANDHARDWARE:
    rra 
    call PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS 
    rl b 
    call PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL 
    res 2,c 
    call PLY_AKG_PSES_READSOFTWAREPERIOD 
    jr PLY_AKG_PSES_SAVEPOINTERANDEXIT 
PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL:
    jr c,PLY_AKG_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE 
    set 5,c 
    ret
PLY_AKG_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE:
    ld a,(hl) 
    ld (PLY_AKG_PSGREG6_8_INSTR),a 
    inc hl 
    res 5,c 
    ret
PLY_AKG_PSES_READSOFTWAREPERIOD:
    ld a,(hl) 
    inc hl 
    exx
    ld (hl),a 
    inc hl 
    exx
    ld a,(hl) 
    inc hl 
    exx
    ld (hl),a 
    exx
    ret
PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS:
    and 15 
PLY_AKG_PSES_MANAGEVOLUMEFROMA_HARD:
    sub (ix+2) 
    jr nc,PLY_AKG_PSES_MVFA_NOOVERFLOW 
    xor a 
PLY_AKG_PSES_MVFA_NOOVERFLOW:
    ld (iy+0),a 
    ret
PLY_AKG_INIT:
    ld de,8 
    add hl,de 
    ld de,PLY_AKG_INSTRUMENTSTABLE 
    ldi
    ldi
    inc hl 
    inc hl 
    add a,a 
    ld e,a 
    ld d,0 
    add hl,de 
    ld a,(hl) 
    inc hl 
    ld h,(hl) 
    ld l,a 
    ld de,5 
    add hl,de 
    ld de,PLY_AKG_CURRENTSPEED 
    ldi
    ld de,PLY_AKG_BASENOTEINDEX 
    ldi
    ld (PLY_AKG_READLINKER_PTLINKER),hl 
    ld hl,PLY_AKG_INITTABLE0 
    ld bc,1792 
    call PLY_AKG_INIT_READWORDSANDFILL 
    inc c 
    ld hl,PLY_AKG_INITTABLE0_END 
    ld b,3 
    call PLY_AKG_INIT_READWORDSANDFILL 
    ld hl,PLY_AKG_INITTABLE1_END 
    ld bc,256 
    call PLY_AKG_INIT_READWORDSANDFILL 
    ld hl,PLY_AKG_INITTABLE1_END 
    ld bc,707 
    call PLY_AKG_INIT_READWORDSANDFILL 
    ld hl,(PLY_AKG_INSTRUMENTSTABLE) 
    ld e,(hl) 
    inc hl 
    ld d,(hl) 
    ex de,hl 
    inc hl 
    ld (PLY_AKG_EMPTYINSTRUMENTDATAPT),hl 
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT),hl 
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT),hl 
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT),hl 
    ld hl,0 
    ld (PLY_AKG_CHANNEL1_SOUNDEFFECTDATA),hl 
    ld (PLY_AKG_CHANNEL2_SOUNDEFFECTDATA),hl 
    ld (PLY_AKG_CHANNEL3_SOUNDEFFECTDATA),hl 
    ret
PLY_AKG_INIT_READWORDSANDFILL_LOOP:
    ld e,(hl) 
    inc hl 
    ld d,(hl) 
    inc hl 
    ld a,c 
    ld (de),a 
PLY_AKG_INIT_READWORDSANDFILL:
    djnz PLY_AKG_INIT_READWORDSANDFILL_LOOP 
    ret
PLY_AKG_INITTABLE0:
    dw PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL 
    dw PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER 
    dw PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL 
    dw PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER 
    dw PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL 
    dw PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER 
PLY_AKG_INITTABLE0_END:
PLY_AKG_INITTABLE1:
    dw PLY_AKG_PATTERNDECREASINGHEIGHT 
    dw PLY_AKG_TICKDECREASINGCOUNTER 
PLY_AKG_INITTABLE1_END:
PLY_AKG_INITTABLEORA:
PLY_AKG_INITTABLEORA_END:
PLY_AKG_INITTABLEJP:
    dw PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS 
PLY_AKG_INITTABLEJP_END:
PLY_AKG_STOP:
    ld (PLY_AKG_SAVESP),sp 
    xor a 
    ld l,a 
    ld h,a 
    ld (PLY_AKG_PSGREG8),a 
    ld (PLY_AKG_PSGREG9_10_INSTR),hl 
    ld a,191 
    jp PLY_AKG_SENDPSGREGISTERS 
PLY_AKG_PLAY:
    ld (PLY_AKG_SAVESP),sp 
    ld a,(PLY_AKG_TICKDECREASINGCOUNTER) 
    dec a 
    jp nz,PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS 
    ld a,(PLY_AKG_PATTERNDECREASINGHEIGHT) 
    dec a 
    jr nz,PLY_AKG_SETCURRENTLINEBEFOREREADLINE 
PLY_AKG_READLINKER:
    ld sp,(PLY_AKG_READLINKER_PTLINKER) 
    pop hl 
    ld a,l 
    or h 
    jr nz,PLY_AKG_READLINKER_NOLOOP 
    pop hl 
    ld sp,hl 
    pop hl 
PLY_AKG_READLINKER_NOLOOP:
    ld (PLY_AKG_CHANNEL1_PTTRACK),hl 
    pop hl 
    ld (PLY_AKG_CHANNEL2_PTTRACK),hl 
    pop hl 
    ld (PLY_AKG_CHANNEL3_PTTRACK),hl 
    pop hl 
    ld (PLY_AKG_READLINKER_PTLINKER),sp 
    ld sp,hl 
    pop hl 
    ld c,l 
    xor a 
    ld (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS),a 
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS),a 
    ld (PLY_AKG_CHANNEL3_WAITCOUNTER),a 
    ld a,c 
PLY_AKG_SETCURRENTLINEBEFOREREADLINE:
    ld (PLY_AKG_PATTERNDECREASINGHEIGHT),a 
PLY_AKG_READLINE:
    ld a,(PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS) 
    sub 1 
    jr c,PLY_AKG_CHANNEL1_READTRACK 
    ld (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS),a 
    jp PLY_AKG_CHANNEL1_READCELLEND 
PLY_AKG_CHANNEL1_READTRACK:
    ld hl,(PLY_AKG_CHANNEL1_PTTRACK) 
    ld c,(hl) 
    inc hl 
    ld a,c 
    and 63 
    cp 60 
    jr c,PLY_AKG_CHANNEL1_NOTE 
    sub 60 
    jp z,PLY_AKG_CHANNEL1_MAYBEEFFECTS 
    dec a 
    jr z,PLY_AKG_CHANNEL1_WAIT 
    dec a 
    jr z,PLY_AKG_CHANNEL1_SMALLWAIT 
    ld a,(hl) 
    inc hl 
    jr PLY_AKG_CHANNEL1_AFTERNOTEKNOWN 
PLY_AKG_CHANNEL1_SMALLWAIT:
    ld a,c 
    rlca
    rlca
    and 3 
    inc a 
    ld (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS),a 
    jr PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL1_WAIT:
    ld a,(hl) 
    ld (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS),a 
    inc hl 
    jr PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL1_SAMEINSTRUMENT:
    ld de,(PLY_AKG_CHANNEL1_PTBASEINSTRUMENT) 
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT),de 
    jr PLY_AKG_CHANNEL1_AFTERINSTRUMENT 
PLY_AKG_CHANNEL1_NOTE:
    ld b,a 
    ld a,(PLY_AKG_BASENOTEINDEX) 
    add a,b 
PLY_AKG_CHANNEL1_AFTERNOTEKNOWN:
    ld (PLY_AKG_CHANNEL1_TRACKNOTE),a 
    rl c 
    jr nc,PLY_AKG_CHANNEL1_SAMEINSTRUMENT 
    ld a,(hl) 
    inc hl 
    exx
    ld l,a 
    ld h,0 
    add hl,hl 
    ld de,(PLY_AKG_INSTRUMENTSTABLE) 
    add hl,de 
    ld sp,hl 
    pop hl 
    ld a,(hl) 
    inc hl 
    ld (PLY_AKG_CHANNEL1_INSTRUMENTSPEED),a 
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT),hl 
    ld (PLY_AKG_CHANNEL1_PTBASEINSTRUMENT),hl 
    exx
PLY_AKG_CHANNEL1_AFTERINSTRUMENT:
    ex de,hl 
    xor a 
    ld (PLY_AKG_CHANNEL1_INSTRUMENTSTEP),a 
    ex de,hl 
PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER:
    ld (PLY_AKG_CHANNEL1_PTTRACK),hl 
PLY_AKG_CHANNEL1_READCELLEND:
    ld a,(PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS) 
    sub 1 
    jr c,PLY_AKG_CHANNEL2_READTRACK 
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS),a 
    jp PLY_AKG_CHANNEL2_READCELLEND 
PLY_AKG_CHANNEL2_READTRACK:
    ld hl,(PLY_AKG_CHANNEL2_PTTRACK) 
    ld c,(hl) 
    inc hl 
    ld a,c 
    and 63 
    cp 60 
    jr c,PLY_AKG_CHANNEL2_NOTE 
    sub 60 
    jp z,PLY_AKG_CHANNEL1_READEFFECTSEND 
    dec a 
    jr z,PLY_AKG_CHANNEL2_WAIT 
    dec a 
    jr z,PLY_AKG_CHANNEL2_SMALLWAIT 
    ld a,(hl) 
    inc hl 
    jr PLY_AKG_CHANNEL2_AFTERNOTEKNOWN 
PLY_AKG_CHANNEL2_SMALLWAIT:
    ld a,c 
    rlca
    rlca
    and 3 
    inc a 
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS),a 
    jr PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL2_WAIT:
    ld a,(hl) 
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS),a 
    inc hl 
    jr PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL2_SAMEINSTRUMENT:
    ld de,(PLY_AKG_CHANNEL2_PTBASEINSTRUMENT) 
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT),de 
    jr PLY_AKG_CHANNEL2_AFTERINSTRUMENT 
PLY_AKG_CHANNEL2_NOTE:
    ld b,a 
    ld a,(PLY_AKG_BASENOTEINDEX) 
    add a,b 
PLY_AKG_CHANNEL2_AFTERNOTEKNOWN:
    ld (PLY_AKG_CHANNEL2_TRACKNOTE),a 
    rl c 
    jr nc,PLY_AKG_CHANNEL2_SAMEINSTRUMENT 
    ld a,(hl) 
    inc hl 
    exx
    ld e,a 
    ld d,0 
    ld hl,(PLY_AKG_INSTRUMENTSTABLE) 
    add hl,de 
    add hl,de 
    ld sp,hl 
    pop hl 
    ld a,(hl) 
    inc hl 
    ld (PLY_AKG_CHANNEL2_INSTRUMENTSPEED),a 
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT),hl 
    ld (PLY_AKG_CHANNEL2_PTBASEINSTRUMENT),hl 
    exx
PLY_AKG_CHANNEL2_AFTERINSTRUMENT:
    ex de,hl 
    xor a 
    ld (PLY_AKG_CHANNEL2_INSTRUMENTSTEP),a 
    ex de,hl 
PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER:
    ld (PLY_AKG_CHANNEL2_PTTRACK),hl 
PLY_AKG_CHANNEL2_READCELLEND:
    ld a,(PLY_AKG_CHANNEL3_WAITCOUNTER) 
    sub 1 
    jr c,PLY_AKG_CHANNEL3_READTRACK 
    ld (PLY_AKG_CHANNEL3_WAITCOUNTER),a 
    jp PLY_AKG_CHANNEL3_READCELLEND 
PLY_AKG_CHANNEL3_READTRACK:
    ld hl,(PLY_AKG_CHANNEL3_PTTRACK) 
    ld c,(hl) 
    inc hl 
    ld a,c 
    and 63 
    cp 60 
    jr c,PLY_AKG_CHANNEL3_NOTE 
    sub 60 
    jp z,PLY_AKG_CHANNEL2_READEFFECTSEND 
    dec a 
    jr z,PLY_AKG_CHANNEL3_WAIT 
    dec a 
    jr z,PLY_AKG_CHANNEL3_SMALLWAIT 
    ld a,(hl) 
    inc hl 
    jr PLY_AKG_CHANNEL3_AFTERNOTEKNOWN 
PLY_AKG_CHANNEL3_SMALLWAIT:
    ld a,c 
    rlca
    rlca
    and 3 
    inc a 
    ld (PLY_AKG_CHANNEL3_WAITCOUNTER),a 
    jr PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL3_WAIT:
    ld a,(hl) 
    ld (PLY_AKG_CHANNEL3_WAITCOUNTER),a 
    inc hl 
    jr PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL3_SAMEINSTRUMENT:
    ld de,(PLY_AKG_CHANNEL3_PTBASEINSTRUMENT) 
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT),de 
    jr PLY_AKG_CHANNEL3_AFTERINSTRUMENT 
PLY_AKG_CHANNEL3_NOTE:
    ld b,a 
    ld a,(PLY_AKG_BASENOTEINDEX) 
    add a,b 
PLY_AKG_CHANNEL3_AFTERNOTEKNOWN:
    ld (PLY_AKG_CHANNEL3_TRACKNOTE),a 
    rl c 
    jr nc,PLY_AKG_CHANNEL3_SAMEINSTRUMENT 
    ld a,(hl) 
    inc hl 
    exx
    ld e,a 
    ld d,0 
    ld hl,(PLY_AKG_INSTRUMENTSTABLE) 
    add hl,de 
    add hl,de 
    ld sp,hl 
    pop hl 
    ld a,(hl) 
    inc hl 
    ld (PLY_AKG_CHANNEL3_INSTRUMENTSPEED),a 
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT),hl 
    ld (PLY_AKG_CHANNEL3_PTBASEINSTRUMENT),hl 
    exx
PLY_AKG_CHANNEL3_AFTERINSTRUMENT:
    ex de,hl 
    xor a 
    ld (PLY_AKG_CHANNEL3_INSTRUMENTSTEP),a 
    ex de,hl 
PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER:
    ld (PLY_AKG_CHANNEL3_PTTRACK),hl 
PLY_AKG_CHANNEL3_READCELLEND:
    ld a,(PLY_AKG_CURRENTSPEED) 
PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS:
    ld (PLY_AKG_TICKDECREASINGCOUNTER),a 
    ld hl,(PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL) 
    ld a,h 
    ld (PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME),a 
    ld de,0 
    ld hl,0 
    add hl,de 
    ld (PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH),hl 
    ld hl,(PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL) 
    ld a,h 
    ld (PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME),a 
    ld de,0 
    ld hl,0 
    add hl,de 
    ld (PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH),hl 
    ld hl,(PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL) 
    ld a,h 
    ld (PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME),a 
    ld de,0 
    ld hl,0 
    add hl,de 
    ld (PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH),hl 
    ld sp,(PLY_AKG_SAVESP) 
    ld hl,(PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH) 
    ld a,(PLY_AKG_CHANNEL1_TRACKNOTE) 
    ld e,a 
    ld d,0 
    exx
    ld a,(PLY_AKG_CHANNEL1_INSTRUMENTSTEP) 
    ld iyl,a 
    ld hl,(PLY_AKG_CHANNEL1_PTINSTRUMENT) 
    ld a,(PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME) 
    ld e,a 
    ld d,224 
    call PLY_AKG_CHANNEL3_READEFFECTSEND 
    ld a,(PLY_AKG_CHANNEL1_INSTRUMENTSPEED) 
    ld b,a 
    ld a,iyl 
    inc a 
    cp b 
    jr c,PLY_AKG_CHANNEL1_SETINSTRUMENTSTEP 
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT),hl 
    xor a 
PLY_AKG_CHANNEL1_SETINSTRUMENTSTEP:
    ld (PLY_AKG_CHANNEL1_INSTRUMENTSTEP),a 
    ld a,e 
    ld (PLY_AKG_PSGREG8),a 
    srl d 
    exx
    ld (PLY_AKG_PSGREG01_INSTR),hl 
    ld hl,(PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH) 
    ld a,(PLY_AKG_CHANNEL2_TRACKNOTE) 
    ld e,a 
    ld d,0 
    exx
    ld a,(PLY_AKG_CHANNEL2_INSTRUMENTSTEP) 
    ld iyl,a 
    ld hl,(PLY_AKG_CHANNEL2_PTINSTRUMENT) 
    ld a,(PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME) 
    ld e,a 
    call PLY_AKG_CHANNEL3_READEFFECTSEND 
    ld a,(PLY_AKG_CHANNEL2_INSTRUMENTSPEED) 
    ld b,a 
    ld a,iyl 
    inc a 
    cp b 
    jr c,PLY_AKG_CHANNEL2_SETINSTRUMENTSTEP 
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT),hl 
    xor a 
PLY_AKG_CHANNEL2_SETINSTRUMENTSTEP:
    ld (PLY_AKG_CHANNEL2_INSTRUMENTSTEP),a 
    ld a,e 
    ld (PLY_AKG_PSGREG9_10_INSTR),a 
    scf
    rr d 
    exx
    ld (PLY_AKG_PSGREG23_INSTR),hl 
    ld hl,(PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH) 
    ld a,(PLY_AKG_CHANNEL3_TRACKNOTE) 
    ld e,a 
    ld d,0 
    exx
    ld a,(PLY_AKG_CHANNEL3_INSTRUMENTSTEP) 
    ld iyl,a 
    ld hl,(PLY_AKG_CHANNEL3_PTINSTRUMENT) 
    ld a,(PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME) 
    ld e,a 
    call PLY_AKG_CHANNEL3_READEFFECTSEND 
    ld a,(PLY_AKG_CHANNEL3_INSTRUMENTSPEED) 
    ld b,a 
    ld a,iyl 
    inc a 
    cp b 
    jr c,PLY_AKG_CHANNEL3_SETINSTRUMENTSTEP 
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT),hl 
    xor a 
PLY_AKG_CHANNEL3_SETINSTRUMENTSTEP:
    ld (PLY_AKG_CHANNEL3_INSTRUMENTSTEP),a 
    ld a,e 
    ld (PLY_AKG_PSGREG10),a 
    ld a,d 
    exx
    ld (PLY_AKG_PSGREG45_INSTR),hl 
    call PLY_AKG_PLAYSOUNDEFFECTSSTREAM 
PLY_AKG_SENDPSGREGISTERS:
    ld b,a 
    ld a,7 
    out (160),a 
    ld a,b 
    out (161),a 
    ld hl,(PLY_AKG_PSGREG01_INSTR) 
    xor a 
    out (160),a 
    ld a,l 
    out (161),a 
    ld a,1 
    out (160),a 
    ld a,h 
    out (161),a 
    ld hl,(PLY_AKG_PSGREG23_INSTR) 
    ld a,2 
    out (160),a 
    ld a,l 
    out (161),a 
    ld a,3 
    out (160),a 
    ld a,h 
    out (161),a 
    ld hl,(PLY_AKG_PSGREG45_INSTR) 
    ld a,4 
    out (160),a 
    ld a,l 
    out (161),a 
    ld a,5 
    out (160),a 
    ld a,h 
    out (161),a 
    ld hl,(PLY_AKG_PSGREG6_8_INSTR) 
    ld a,6 
    out (160),a 
    ld a,l 
    out (161),a 
    ld a,8 
    out (160),a 
    ld a,h 
    out (161),a 
    ld hl,(PLY_AKG_PSGREG9_10_INSTR) 
    ld a,9 
    out (160),a 
    ld a,l 
    out (161),a 
    ld a,10 
    out (160),a 
    ld a,h 
    out (161),a 
    ld sp,(PLY_AKG_SAVESP) 
    ret
PLY_AKG_CHANNEL1_MAYBEEFFECTS:
    ld (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS),a 
    jp PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL1_READEFFECTSEND:
PLY_AKG_CHANNEL2_MAYBEEFFECTS:
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS),a 
    jp PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL2_READEFFECTSEND:
PLY_AKG_CHANNEL3_MAYBEEFFECTS:
    ld (PLY_AKG_CHANNEL3_WAITCOUNTER),a 
    jp PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER 
PLY_AKG_CHANNEL3_READEFFECTSEND:
PLY_AKG_READINSTRUMENTCELL:
    ld a,(hl) 
    inc hl 
    ld b,a 
    rra
    jp c,PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP 
    rra
    jp c,PLY_AKG_STH_OR_ENDWITHOUTLOOP 
    rra
PLY_AKG_NOSOFTNOHARD:
    and 15 
    sub e 
    jr nc,PLY_AKG_NOSOFTNOHARD+6 
    xor a 
    ld e,a 
    rl b 
    jr nc,PLY_AKG_NSNH_NONOISE 
    ld a,(hl) 
    inc hl 
    ld (PLY_AKG_PSGREG6_8_INSTR),a 
    set 2,d 
    res 5,d 
    ret
PLY_AKG_NSNH_NONOISE:
    set 2,d 
    ret
PLY_AKG_SOFT:
    and 15 
    sub e 
    jr nc,PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON-1 
    xor a 
    ld e,a 
PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON:
    rl b 
    jr nc,PLY_AKG_S_NOTSIMPLE 
    ld c,0 
    jr PLY_AKG_S_AFTERSIMPLETEST 
PLY_AKG_S_NOTSIMPLE:
    ld b,(hl) 
    ld c,b 
    inc hl 
PLY_AKG_S_AFTERSIMPLETEST:
    call PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD 
    ld a,c 
    and 31 
    ret z 
    ld (PLY_AKG_PSGREG6_8_INSTR),a 
    res 5,d 
    ret
PLY_AKG_ENDWITHOUTLOOP:
    ld hl,(PLY_AKG_EMPTYINSTRUMENTDATAPT) 
    inc hl 
    xor a 
    ld b,a 
    jp PLY_AKG_NOSOFTNOHARD 
PLY_AKG_STH_OR_ENDWITHOUTLOOP:
    rra 
    jr PLY_AKG_ENDWITHOUTLOOP 
PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP:
    rra 
    jr c,PLY_AKG_H_OR_ENDWITHLOOP 
    rra
    jp nc,PLY_AKG_SOFT 
PLY_AKG_H_OR_ENDWITHLOOP:
PLY_AKG_ENDWITHLOOP:
    ld a,(hl) 
    inc hl 
    ld h,(hl) 
    ld l,a 
    jp PLY_AKG_CHANNEL3_READEFFECTSEND 
PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD:
    jr nc,PLY_AKG_S_OR_H_NEXTBYTE 
    exx
    ex de,hl 
    add hl,hl 
    ld bc,PLY_AKG_PERIODTABLE 
    add hl,bc 
    ld a,(hl) 
    inc hl 
    ld h,(hl) 
    ld l,a 
    add hl,de 
    exx
    rl b 
    rl b 
    rl b 
    ret
PLY_AKG_S_OR_H_NEXTBYTE:
    rl b 
    rl b 
    rl b 
    jr nc,PLY_AKG_S_OR_H_AFTERPITCH 
    ld a,(hl) 
    inc hl 
    exx
    add a,l 
    ld l,a 
    exx
    ld a,(hl) 
    inc hl 
    exx
    adc a,h 
    ld h,a 
    exx
PLY_AKG_S_OR_H_AFTERPITCH:
    exx 
    ex de,hl 
    add hl,hl 
    ld bc,PLY_AKG_PERIODTABLE 
    add hl,bc 
    ld a,(hl) 
    inc hl 
    ld h,(hl) 
    ld l,a 
    add hl,de 
    exx
    ret
PLY_AKG_PERIODTABLE:
    dw 6778 
    dw 6398 
    dw 6039 
    dw 5700 
    dw 5380 
    dw 5078 
    dw 4793 
    dw 4524 
    dw 4270 
    dw 4030 
    dw 3804 
    dw 3591 
    dw 3389 
    dw 3199 
    dw 3019 
    dw 2850 
    dw 2690 
    dw 2539 
    dw 2397 
    dw 2262 
    dw 2135 
    dw 2015 
    dw 1902 
    dw 1795 
    dw 1695 
    dw 1599 
    dw 1510 
    dw 1425 
    dw 1345 
    dw 1270 
    dw 1198 
    dw 1131 
    dw 1068 
    dw 1008 
    dw 951 
    dw 898 
    dw 847 
    dw 800 
    dw 755 
    dw 712 
    dw 673 
    dw 635 
    dw 599 
    dw 566 
    dw 534 
    dw 504 
    dw 476 
    dw 449 
    dw 424 
    dw 400 
    dw 377 
    dw 356 
    dw 336 
    dw 317 
    dw 300 
    dw 283 
    dw 267 
    dw 252 
    dw 238 
    dw 224 
    dw 212 
    dw 200 
    dw 189 
    dw 178 
    dw 168 
    dw 159 
    dw 150 
    dw 141 
    dw 133 
    dw 126 
    dw 119 
    dw 112 
    dw 106 
    dw 100 
    dw 94 
    dw 89 
    dw 84 
    dw 79 
    dw 75 
    dw 71 
    dw 67 
    dw 63 
    dw 59 
    dw 56 
    dw 53 
    dw 50 
    dw 47 
    dw 45 
    dw 42 
    dw 40 
    dw 37 
    dw 35 
    dw 33 
    dw 31 
    dw 30 
    dw 28 
    dw 26 
    dw 25 
    dw 24 
    dw 22 
    dw 21 
    dw 20 
    dw 19 
    dw 18 
    dw 17 
    dw 16 
    dw 15 
    dw 14 
    dw 13 
    dw 12 
    dw 12 
    dw 11 
    dw 11 
    dw 10 
    dw 9 
    dw 9 
    dw 8 
    dw 8 
    dw 7 
    dw 7 
    dw 7 
    dw 6 
    dw 6 
    dw 6 
    dw 5 
    dw 5 
    dw 5 
    dw 4 
PLY_AKG_BASENOTEINDEX: equ 55553 
PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME: equ 55585 
PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH: equ 55602 
PLY_AKG_CHANNEL1_INSTRUMENTSPEED: equ 55582 
PLY_AKG_CHANNEL1_INSTRUMENTSTEP: equ 55583 
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER: equ 55593 
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL: equ 55592 
PLY_AKG_CHANNEL1_PTBASEINSTRUMENT: equ 55598 
PLY_AKG_CHANNEL1_PTINSTRUMENT: equ 55596 
PLY_AKG_CHANNEL1_PTTRACK: equ 55586 
PLY_AKG_CHANNEL1_SOUNDEFFECTDATA: equ 55652 
PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS: equ 55581 
PLY_AKG_CHANNEL1_TRACKNOTE: equ 55584 
PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME: equ 55608 
PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH: equ 55625 
PLY_AKG_CHANNEL2_INSTRUMENTSPEED: equ 55605 
PLY_AKG_CHANNEL2_INSTRUMENTSTEP: equ 55606 
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER: equ 55616 
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL: equ 55615 
PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS: equ 55604 
PLY_AKG_CHANNEL2_PTBASEINSTRUMENT: equ 55621 
PLY_AKG_CHANNEL2_PTINSTRUMENT: equ 55619 
PLY_AKG_CHANNEL2_PTTRACK: equ 55609 
PLY_AKG_CHANNEL2_SOUNDEFFECTDATA: equ 55660 
PLY_AKG_CHANNEL2_TRACKNOTE: equ 55607 
PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME: equ 55631 
PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH: equ 55648 
PLY_AKG_CHANNEL3_INSTRUMENTSPEED: equ 55628 
PLY_AKG_CHANNEL3_INSTRUMENTSTEP: equ 55629 
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER: equ 55639 
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL: equ 55638 
PLY_AKG_CHANNEL3_PTBASEINSTRUMENT: equ 55644 
PLY_AKG_CHANNEL3_PTINSTRUMENT: equ 55642 
PLY_AKG_CHANNEL3_PTTRACK: equ 55632 
PLY_AKG_CHANNEL3_SOUNDEFFECTDATA: equ 55668 
PLY_AKG_CHANNEL3_TRACKNOTE: equ 55630 
PLY_AKG_CHANNEL3_WAITCOUNTER: equ 55627 
PLY_AKG_CURRENTSPEED: equ 55552 
PLY_AKG_EMPTYINSTRUMENTDATAPT: equ 55561 
PLY_AKG_INSTRUMENTSTABLE: equ 55559 
PLY_AKG_PATTERNDECREASINGHEIGHT: equ 55554 
PLY_AKG_PSGREG01_INSTR: equ 55565 
PLY_AKG_PSGREG10: equ 55574 
PLY_AKG_PSGREG23_INSTR: equ 55567 
PLY_AKG_PSGREG45_INSTR: equ 55569 
PLY_AKG_PSGREG6_8_INSTR: equ 55571 
PLY_AKG_PSGREG8: equ 55572 
PLY_AKG_PSGREG9_10_INSTR: equ 55573 
PLY_AKG_PTSOUNDEFFECTTABLE: equ 55650 
PLY_AKG_READLINKER_PTLINKER: equ 55557 
PLY_AKG_SAVESP: equ 55563 
PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS: equ 55578 
PLY_AKG_TICKDECREASINGCOUNTER: equ 55555 
