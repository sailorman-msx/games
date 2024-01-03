MOMBGMLETSGOADVENTURE_START:
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
    dw MOMBGMLETSGOADVENTURE_ARPEGGIOTABLE 
    dw MOMBGMLETSGOADVENTURE_ARPEGGIOTABLE 
PLY_AKG_OPCODE_ADD_HL_BC_LSB: equ $+1 
    dw MOMBGMLETSGOADVENTURE_ARPEGGIOTABLE 
    dw MOMBGMLETSGOADVENTURE_EFFECTBLOCKTABLE 
    dw MOMBGMLETSGOADVENTURE_EFFECTBLOCKTABLE 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_START 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_START 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_START 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_START 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_START 
MOMBGMLETSGOADVENTURE_ARPEGGIOTABLE:
MOMBGMLETSGOADVENTURE_PITCHTABLE:
MOMBGMLETSGOADVENTURE_INSTRUMENTTABLE:
    dw MOMBGMLETSGOADVENTURE_EMPTYINSTRUMENT 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT1 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT2 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT3 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT4 
PLY_AKG_OPCODE_INC_HL: equ $+1 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT5 
MOMBGMLETSGOADVENTURE_EMPTYINSTRUMENT:
    db 0 
MOMBGMLETSGOADVENTURE_EMPTYINSTRUMENT_LOOP:
    db 0 
    db 6 
MOMBGMLETSGOADVENTURE_INSTRUMENT1:
    db 1 
    db 241 
    db 241 
    db 241 
PLY_AKG_OPCODE_DEC_HL:
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 241 
    db 6 
MOMBGMLETSGOADVENTURE_INSTRUMENT2:
    db 1 
MOMBGMLETSGOADVENTURE_INSTRUMENT2_LOOP:
    db 225 
    db 225 
    db 7 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT2_LOOP 
MOMBGMLETSGOADVENTURE_INSTRUMENT3:
    db 1 
    db 233 
    db 113 
    db 32 
PLY_AKG_OPCODE_SBC_HL_BC_LSB:
    db 50 
    db 0 
    db 105 
    db 32 
    db 100 
    db 0 
    db 97 
    db 32 
    db 150 
    db 0 
    db 89 
    db 32 
    db 200 
    db 0 
    db 81 
    db 32 
    db 250 
    db 0 
    db 73 
    db 32 
    db 44 
    db 1 
    db 65 
    db 32 
    db 94 
    db 1 
    db 57 
    db 32 
    db 144 
    db 1 
    db 6 
MOMBGMLETSGOADVENTURE_INSTRUMENT4:
    db 1 
MOMBGMLETSGOADVENTURE_INSTRUMENT4_LOOP:
    db 209 
    db 225 
    db 241 
    db 241 
    db 241 
    db 7 
    dw MOMBGMLETSGOADVENTURE_INSTRUMENT4_LOOP 
MOMBGMLETSGOADVENTURE_INSTRUMENT5:
    db 1 
    db 113 
    db 1 
    db 105 
    db 32 
    db 150 
    db 0 
    db 105 
    db 32 
    db 44 
    db 1 
    db 89 
    db 32 
    db 144 
    db 1 
    db 81 
    db 32 
    db 244 
    db 1 
    db 73 
    db 32 
    db 88 
    db 2 
    db 6 
MOMBGMLETSGOADVENTURE_EFFECTBLOCKTABLE:
MOMBGMLETSGOADVENTURE_SUBSONG0_START:
    db 2 
    db 1 
    db 1 
    db 0 
    db 0 
    db 15 
    db 4 
MOMBGMLETSGOADVENTURE_SUBSONG0_LINKER:
MOMBGMLETSGOADVENTURE_SUBSONG0_LINKER_LOOP:
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_TRACK1 
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_LINKERBLOCK0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_LINKER 
MOMBGMLETSGOADVENTURE_SUBSONG0_LINKERBLOCK0:
    db 58 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG0_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG0_TRACK0:
    db 171 
    db 1 
    db 41 
    db 39 
    db 39 
    db 51 
    db 51 
    db 51 
    db 51 
    db 50 
    db 50 
    db 48 
    db 48 
    db 48 
    db 46 
    db 44 
    db 44 
    db 48 
    db 48 
    db 53 
    db 53 
    db 51 
    db 51 
    db 50 
    db 50 
    db 50 
    db 50 
    db 50 
    db 51 
    db 53 
    db 55 
    db 55 
    db 50 
    db 50 
    db 55 
    db 55 
    db 53 
    db 53 
PLY_AKG_OPCODE_JP:
    db 51 
    db 51 
    db 51 
PLY_AKG_OPCODE_ADD_A_IMMEDIATE:
    db 51 
    db 51 
    db 50 
    db 50 
    db 48 
    db 48 
    db 48 
    db 48 
    db 50 
    db 50 
    db 51 
    db 51 
    db 53 
    db 53 
    db 49 
    db 60 
PLY_AKG_OPCODE_SUB_IMMEDIATE:
    db 46 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG0_TRACK1:
    db 62 
    db 150 
    db 3 
    db 60 
    db 22 
    db 60 
    db 22 
    db 60 
    db 22 
    db 60 
    db 22 
    db 22 
    db 60 
    db 22 
    db 60 
    db 22 
    db 60 
    db 22 
    db 60 
    db 22 
PLY_AKG_OPCODE_SBC_HL_BC_MSB:
    db 60 
    db 22 
    db 60 
    db 22 
    db 60 
    db 22 
    db 22 
    db 60 
    db 22 
    db 60 
    db 31 
    db 60 
    db 29 
    db 60 
    db 31 
    db 60 
    db 29 
    db 29 
PLY_AKG_OPCODE_SCF:
    db 60 
    db 29 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 27 
    db 27 
    db 60 
    db 27 
    db 60 
    db 29 
    db 29 
    db 60 
    db 31 
    db 31 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG0_TRACK2:
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG0_SPEEDTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG0_EVENTTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG1_START:
    db 2 
    db 0 
    db 1 
    db 0 
    db 0 
    db 15 
    db 8 
MOMBGMLETSGOADVENTURE_SUBSONG1_LINKER:
MOMBGMLETSGOADVENTURE_SUBSONG1_LINKER_LOOP:
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_TRACK1 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_LINKERBLOCK0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_LINKER 
MOMBGMLETSGOADVENTURE_SUBSONG1_LINKERBLOCK0:
    db 64 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG1_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG1_TRACK0:
    db 152 
    db 1 
    db 60 
    db 24 
    db 60 
    db 24 
    db 60 
    db 27 
    db 60 
    db 26 
    db 60 
    db 26 
    db 60 
    db 26 
    db 60 
    db 24 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 31 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 27 
    db 60 
    db 19 
    db 60 
    db 19 
    db 60 
    db 19 
    db 60 
    db 29 
    db 60 
    db 155 
    db 2 
    db 155 
    db 1 
    db 60 
    db 155 
    db 2 
    db 155 
    db 1 
    db 60 
    db 31 
    db 60 
    db 162 
    db 2 
    db 162 
    db 1 
    db 60 
    db 162 
    db 2 
    db 162 
    db 1 
    db 60 
    db 38 
    db 60 
    db 31 
    db 31 
    db 60 
    db 38 
    db 38 
    db 60 
    db 31 
    db 50 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG1_TRACK1:
    db 169 
    db 1 
    db 41 
    db 41 
    db 41 
    db 41 
    db 41 
    db 62 
    db 48 
    db 48 
    db 48 
    db 48 
    db 48 
    db 48 
    db 62 
    db 46 
    db 46 
    db 46 
    db 46 
    db 46 
    db 46 
    db 62 
    db 48 
    db 48 
    db 48 
    db 48 
    db 48 
    db 48 
    db 62 
    db 38 
    db 38 
    db 38 
    db 38 
    db 38 
    db 38 
    db 62 
    db 50 
    db 50 
    db 50 
    db 50 
    db 50 
    db 50 
    db 62 
    db 37 
    db 37 
    db 37 
    db 37 
    db 37 
    db 37 
    db 62 
    db 55 
    db 55 
    db 53 
    db 53 
    db 51 
    db 51 
    db 50 
    db 50 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG1_TRACK2:
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG1_SPEEDTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG1_EVENTTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG2_START:
    db 2 
    db 0 
    db 1 
    db 1 
    db 1 
    db 3 
    db 17 
MOMBGMLETSGOADVENTURE_SUBSONG2_LINKER:
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK1 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_LINKERBLOCK0 
MOMBGMLETSGOADVENTURE_SUBSONG2_LINKER_LOOP:
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_LINKERBLOCK1 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_LINKER_LOOP 
MOMBGMLETSGOADVENTURE_SUBSONG2_LINKERBLOCK0:
    db 5 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG2_LINKERBLOCK1:
    db 1 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG2_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK0:
    db 175 
    db 1 
    db 48 
    db 55 
    db 55 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK1:
    db 163 
    db 1 
    db 36 
    db 43 
    db 43 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG2_TRACK2:
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG2_SPEEDTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG2_EVENTTRACK0:
    db 7 
    db 2 
    db 245 
MOMBGMLETSGOADVENTURE_SUBSONG3_START:
    db 2 
    db 0 
    db 1 
    db 1 
    db 1 
    db 12 
    db 4 
MOMBGMLETSGOADVENTURE_SUBSONG3_LINKER:
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK1 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_LINKERBLOCK0 
MOMBGMLETSGOADVENTURE_SUBSONG3_LINKER_LOOP:
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_LINKERBLOCK1 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_LINKER_LOOP 
MOMBGMLETSGOADVENTURE_SUBSONG3_LINKERBLOCK0:
    db 34 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG3_LINKERBLOCK1:
    db 1 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG3_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK0:
    db 60 
    db 167 
    db 1 
    db 41 
    db 42 
    db 60 
    db 42 
    db 41 
    db 62 
    db 39 
    db 39 
    db 60 
    db 39 
    db 41 
    db 62 
    db 42 
    db 41 
    db 42 
    db 41 
    db 42 
    db 41 
    db 60 
    db 37 
    db 60 
    db 37 
    db 37 
    db 60 
    db 37 
    db 60 
    db 20 
    db 60 
    db 25 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK1:
    db 177 
    db 3 
    db 60 
    db 49 
    db 60 
    db 49 
    db 60 
    db 48 
    db 60 
    db 49 
    db 60 
    db 44 
    db 60 
    db 44 
    db 60 
    db 51 
    db 60 
    db 55 
    db 60 
    db 55 
    db 60 
    db 55 
    db 60 
    db 51 
    db 49 
    db 51 
    db 49 
    db 51 
    db 39 
    db 39 
    db 43 
    db 32 
    db 60 
    db 32 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG3_TRACK2:
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG3_SPEEDTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG3_EVENTTRACK0:
    db 65 
    db 2 
    db 187 
MOMBGMLETSGOADVENTURE_SUBSONG4_START:
    db 2 
    db 0 
    db 1 
    db 0 
    db 0 
    db 15 
    db 0 
MOMBGMLETSGOADVENTURE_SUBSONG4_LINKER:
MOMBGMLETSGOADVENTURE_SUBSONG4_LINKER_LOOP:
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_TRACK1 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_LINKERBLOCK0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_LINKER 
MOMBGMLETSGOADVENTURE_SUBSONG4_LINKERBLOCK0:
    db 64 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG4_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG4_TRACK0:
    db 60 
    db 175 
    db 1 
    db 48 
    db 176 
    db 3 
    db 175 
    db 1 
    db 175 
    db 3 
    db 180 
    db 1 
    db 52 
    db 48 
    db 176 
    db 3 
    db 173 
    db 1 
    db 173 
    db 3 
    db 176 
    db 1 
    db 47 
    db 175 
    db 3 
    db 172 
    db 1 
    db 45 
    db 44 
    db 45 
    db 45 
    db 173 
    db 3 
    db 171 
    db 1 
    db 171 
    db 3 
    db 168 
    db 1 
    db 168 
    db 3 
    db 175 
    db 1 
    db 175 
    db 3 
    db 171 
    db 1 
    db 171 
    db 3 
    db 168 
    db 1 
    db 168 
    db 3 
    db 173 
    db 1 
    db 47 
    db 48 
    db 176 
    db 3 
    db 175 
    db 1 
    db 175 
    db 3 
    db 173 
    db 1 
    db 173 
    db 3 
    db 175 
    db 1 
    db 175 
    db 3 
    db 171 
    db 1 
    db 171 
    db 3 
    db 168 
    db 1 
    db 168 
    db 3 
    db 168 
    db 1 
    db 45 
    db 47 
    db 175 
    db 3 
    db 173 
    db 1 
    db 173 
    db 3 
    db 168 
    db 1 
    db 168 
    db 3 
    db 178 
    db 1 
    db 178 
    db 3 
    db 176 
    db 1 
    db 176 
    db 3 
    db 175 
    db 1 
    db 40 
    db 168 
    db 3 
    db 173 
    db 1 
    db 45 
    db 45 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG4_TRACK1:
    db 164 
    db 3 
    db 60 
    db 36 
    db 60 
    db 36 
    db 38 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 38 
    db 36 
    db 60 
    db 36 
    db 38 
    db 36 
    db 38 
    db 36 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 38 
    db 38 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 38 
    db 38 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 36 
    db 60 
    db 38 
    db 38 
    db 60 
    db 33 
    db 60 
    db 33 
    db 60 
    db 29 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG4_TRACK2:
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG4_SPEEDTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG4_EVENTTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG5_START:
    db 2 
    db 0 
    db 1 
    db 0 
    db 0 
    db 6 
    db 19 
MOMBGMLETSGOADVENTURE_SUBSONG5_LINKER:
MOMBGMLETSGOADVENTURE_SUBSONG5_LINKER_LOOP:
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_TRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_TRACK1 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_TRACK2 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_LINKERBLOCK0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_LINKER 
MOMBGMLETSGOADVENTURE_SUBSONG5_LINKERBLOCK0:
    db 64 
    db 0 
    db 0 
    db 0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_SPEEDTRACK0 
    dw MOMBGMLETSGOADVENTURE_SUBSONG5_EVENTTRACK0 
MOMBGMLETSGOADVENTURE_SUBSONG5_TRACK0:
    db 166 
    db 4 
    db 62 
    db 40 
    db 62 
    db 41 
    db 62 
    db 40 
    db 62 
    db 41 
    db 62 
    db 43 
    db 62 
    db 41 
    db 62 
    db 40 
    db 62 
    db 38 
    db 62 
    db 40 
    db 62 
    db 41 
    db 62 
    db 40 
    db 62 
    db 38 
    db 60 
    db 38 
    db 40 
    db 41 
    db 60 
    db 55 
    db 55 
    db 183 
    db 3 
    db 183 
    db 4 
    db 55 
    db 60 
    db 53 
    db 53 
    db 181 
    db 3 
    db 181 
    db 4 
    db 53 
    db 60 
    db 52 
    db 52 
    db 180 
    db 3 
    db 180 
    db 4 
    db 52 
    db 60 
    db 50 
    db 50 
    db 50 
    db 178 
    db 3 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG5_TRACK1:
    db 178 
    db 3 
    db 50 
    db 180 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 180 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 169 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 169 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 180 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 169 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 180 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 176 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 180 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 171 
    db 5 
    db 60 
    db 178 
    db 3 
    db 50 
    db 180 
    db 5 
    db 60 
    db 50 
    db 50 
    db 43 
    db 60 
    db 50 
    db 50 
    db 43 
    db 60 
    db 50 
    db 50 
    db 43 
    db 60 
    db 50 
    db 50 
    db 43 
    db 60 
    db 48 
    db 48 
    db 41 
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG5_TRACK2:
    db 61 
    db 127 
MOMBGMLETSGOADVENTURE_SUBSONG5_SPEEDTRACK0:
    db 255 
MOMBGMLETSGOADVENTURE_SUBSONG5_EVENTTRACK0:
    db 255 
SOUNDEFFECTS:
    dw SOUNDEFFECTS_SOUND1 
    dw SOUNDEFFECTS_SOUND2 
    dw MOMBGMLETSGOADVENTURE_START 
    dw MOMBGMLETSGOADVENTURE_START 
    dw MOMBGMLETSGOADVENTURE_START 
    dw MOMBGMLETSGOADVENTURE_START 
    dw MOMBGMLETSGOADVENTURE_START 
    dw SOUNDEFFECTS_SOUND8 
    dw MOMBGMLETSGOADVENTURE_START 
    dw MOMBGMLETSGOADVENTURE_START 
    dw SOUNDEFFECTS_SOUND11 
    dw MOMBGMLETSGOADVENTURE_START 
    dw SOUNDEFFECTS_SOUND13 
    dw SOUNDEFFECTS_SOUND14 
    dw SOUNDEFFECTS_SOUND15 
SOUNDEFFECTS_SOUND1:
    db 0 
SOUNDEFFECTS_SOUND1_LOOP:
    db 163 
    db 5 
    db 223 
    db 0 
    db 223 
    db 0 
    db 163 
    db 5 
    db 234 
    db 0 
    db 234 
    db 0 
    db 169 
    db 1 
    db 239 
    db 0 
    db 41 
    db 244 
    db 0 
    db 33 
    db 244 
    db 0 
    db 4 
SOUNDEFFECTS_SOUND2:
    db 0 
SOUNDEFFECTS_SOUND2_LOOP:
    db 189 
    db 1 
    db 90 
    db 2 
    db 189 
    db 8 
    db 126 
    db 2 
    db 185 
    db 2 
    db 36 
    db 3 
    db 181 
    db 16 
    db 170 
    db 1 
    db 177 
    db 2 
    db 195 
    db 1 
    db 173 
    db 2 
    db 222 
    db 1 
    db 165 
    db 16 
    db 204 
    db 2 
    db 157 
    db 31 
    db 239 
    db 0 
    db 153 
    db 7 
    db 159 
    db 0 
    db 4 
SOUNDEFFECTS_SOUND8:
    db 0 
SOUNDEFFECTS_SOUND8_LOOP:
    db 173 
    db 1 
    db 239 
    db 0 
    db 181 
    db 1 
    db 113 
    db 0 
    db 61 
    db 213 
    db 0 
    db 53 
    db 106 
    db 0 
    db 181 
    db 1 
    db 201 
    db 0 
    db 173 
    db 1 
    db 100 
    db 0 
    db 4 
SOUNDEFFECTS_SOUND11:
    db 0 
SOUNDEFFECTS_SOUND11_LOOP:
    db 3 
    db 2 
    db 0 
    db 24 
    db 0 
    db 3 
    db 3 
    db 0 
    db 42 
    db 0 
    db 3 
    db 2 
    db 0 
    db 27 
    db 0 
    db 3 
    db 4 
    db 0 
    db 67 
    db 0 
    db 3 
    db 3 
    db 0 
    db 42 
    db 0 
    db 3 
    db 7 
    db 0 
    db 106 
    db 0 
    db 3 
    db 4 
    db 0 
    db 67 
    db 0 
    db 3 
    db 11 
    db 0 
    db 169 
    db 0 
    db 3 
    db 7 
    db 0 
    db 106 
    db 0 
    db 3 
    db 17 
    db 0 
    db 12 
    db 1 
    db 3 
    db 11 
    db 0 
    db 169 
    db 0 
    db 3 
    db 30 
    db 0 
    db 222 
    db 1 
    db 3 
    db 45 
    db 0 
    db 204 
    db 2 
    db 4 
SOUNDEFFECTS_SOUND13:
    db 0 
SOUNDEFFECTS_SOUND13_LOOP:
    db 200 
    db 27 
    db 216 
    db 5 
    db 248 
    db 8 
    db 232 
    db 16 
    db 216 
    db 5 
    db 4 
SOUNDEFFECTS_SOUND14:
    db 0 
SOUNDEFFECTS_SOUND14_LOOP:
    db 185 
    db 1 
    db 95 
    db 0 
    db 49 
    db 67 
    db 0 
    db 41 
    db 119 
    db 0 
    db 4 
SOUNDEFFECTS_SOUND15:
    db 0 
SOUNDEFFECTS_SOUND15_LOOP:
    db 33 
    db 56 
    db 2 
    db 41 
    db 222 
    db 1 
    db 61 
    db 239 
    db 0 
    db 61 
    db 159 
    db 0 
    db 61 
    db 106 
    db 0 
    db 61 
    db 84 
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
    jr c,PLY_AKG_PSES_S_ENDORLOOP 
    call PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS 
    rl b 
    call PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL 
    set 2,c 
    jr PLY_AKG_PSES_SAVEPOINTERANDEXIT 
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
    db 221 
    db 117 
    db 0 
    db 221 
    db 116 
    db 1 
    ret
PLY_AKG_PSES_NOTREACHED:
    inc (ix+3) 
    ret
PLY_AKG_PSES_SOFTWAREORSOFTWAREANDHARDWARE:
    rra 
    jr c,PLY_AKG_PSES_SOFTWAREANDHARDWARE 
    call PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS 
    rl b 
    call PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL 
    res 2,c 
    call PLY_AKG_PSES_READSOFTWAREPERIOD 
    jr PLY_AKG_PSES_SAVEPOINTERANDEXIT 
PLY_AKG_PSES_SOFTWAREANDHARDWARE:
    call PLY_AKG_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE 
    call PLY_AKG_PSES_READSOFTWAREPERIOD 
    res 2,c 
    jr PLY_AKG_PSES_SAVEPOINTERANDEXIT 
PLY_AKG_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE:
    rra 
    and 7 
    add a,8 
    ld (PLY_AKG_PSGREG13_INSTR),a 
    rl b 
    call PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL 
    call PLY_AKG_PSES_READHARDWAREPERIOD 
    ld a,16 
    jp PLY_AKG_PSES_MANAGEVOLUMEFROMA_HARD 
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
PLY_AKG_PSES_READHARDWAREPERIOD:
    ld a,(hl) 
    ld (PLY_AKG_PSGHARDWAREPERIOD_INSTR),a 
    inc hl 
    ld a,(hl) 
    ld (PLY_AKG_PSGHARDWAREPERIOD_INSTR+1),a 
    inc hl 
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
    xor a 
    ld (PLY_AKG_EVENT),a 
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
    pop hl 
    pop hl 
    pop hl 
    ld (PLY_AKG_EVENTTRACK_PTTRACK),hl 
    xor a 
    ld (PLY_AKG_EVENTTRACK_WAITCOUNTER),a 
    ld (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS),a 
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS),a 
    ld (PLY_AKG_CHANNEL3_WAITCOUNTER),a 
    ld a,c 
PLY_AKG_SETCURRENTLINEBEFOREREADLINE:
    ld (PLY_AKG_PATTERNDECREASINGHEIGHT),a 
PLY_AKG_READLINE:
    ld a,(PLY_AKG_EVENTTRACK_WAITCOUNTER) 
    sub 1 
    jr nc,PLY_AKG_EVENTTRACK_MUSTWAIT 
    ld hl,(PLY_AKG_EVENTTRACK_PTTRACK) 
    ld a,(hl) 
    inc hl 
    srl a 
    jr c,PLY_AKG_EVENTTRACK_STOREPOINTERANDWAITCOUNTER 
    jr nz,PLY_AKG_EVENTTRACK_NORMALVALUE 
    ld a,(hl) 
    inc hl 
PLY_AKG_EVENTTRACK_NORMALVALUE:
    ld (PLY_AKG_EVENT),a 
    xor a 
PLY_AKG_EVENTTRACK_STOREPOINTERANDWAITCOUNTER:
    ld (PLY_AKG_EVENTTRACK_PTTRACK),hl 
PLY_AKG_EVENTTRACK_MUSTWAIT:
    ld (PLY_AKG_EVENTTRACK_WAITCOUNTER),a 
PLY_AKG_EVENTTRACK_END:
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
    db 253 
    db 111 
    ld hl,(PLY_AKG_CHANNEL1_PTINSTRUMENT) 
    ld a,(PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME) 
    ld e,a 
    ld d,224 
    call PLY_AKG_CHANNEL3_READEFFECTSEND 
    ld a,(PLY_AKG_CHANNEL1_INSTRUMENTSPEED) 
    ld b,a 
    db 253 
    db 125 
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
    db 253 
    db 111 
    ld hl,(PLY_AKG_CHANNEL2_PTINSTRUMENT) 
    ld a,(PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME) 
    ld e,a 
    call PLY_AKG_CHANNEL3_READEFFECTSEND 
    ld a,(PLY_AKG_CHANNEL2_INSTRUMENTSPEED) 
    ld b,a 
    db 253 
    db 125 
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
    db 253 
    db 111 
    ld hl,(PLY_AKG_CHANNEL3_PTINSTRUMENT) 
    ld a,(PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME) 
    ld e,a 
    call PLY_AKG_CHANNEL3_READEFFECTSEND 
    ld a,(PLY_AKG_CHANNEL3_INSTRUMENTSPEED) 
    ld b,a 
    db 253 
    db 125 
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
    ld hl,(PLY_AKG_PSGHARDWAREPERIOD_INSTR) 
    ld a,11 
    out (160),a 
    ld a,l 
    out (161),a 
    ld a,12 
    out (160),a 
    ld a,h 
    out (161),a 
    ld a,13 
    out (160),a 
    ld a,(PLY_AKG_PSGREG13_OLDVALUE) 
    ld l,a 
    ld a,(PLY_AKG_PSGREG13_INSTR) 
    cp l 
    jr z,PLY_AKG_PSGREG13_END 
    ld (PLY_AKG_PSGREG13_OLDVALUE),a 
    out (161),a 
PLY_AKG_PSGREG13_END:
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
    jr nc,PLY_AKG_SOFT-4 
    xor a 
    ld e,a 
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
PLY_AKG_STOH_HTOS_SANDH_COMMON:
    ld e,16 
    rra
    and 7 
    add a,8 
    ld (PLY_AKG_PSGREG13_INSTR),a 
    rl b 
    ld c,(hl) 
    ld b,c 
    inc hl 
    rl b 
    call PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD 
    ld a,c 
    rla
    rla
    and 28 
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
PLY_AKG_BASENOTEINDEX: equ 55426 
PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME: equ 55465 
PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH: equ 55482 
PLY_AKG_CHANNEL1_INSTRUMENTSPEED: equ 55462 
PLY_AKG_CHANNEL1_INSTRUMENTSTEP: equ 55463 
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER: equ 55473 
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL: equ 55472 
PLY_AKG_CHANNEL1_PTBASEINSTRUMENT: equ 55478 
PLY_AKG_CHANNEL1_PTINSTRUMENT: equ 55476 
PLY_AKG_CHANNEL1_PTTRACK: equ 55466 
PLY_AKG_CHANNEL1_SOUNDEFFECTDATA: equ 55532 
PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS: equ 55461 
PLY_AKG_CHANNEL1_TRACKNOTE: equ 55464 
PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME: equ 55488 
PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH: equ 55505 
PLY_AKG_CHANNEL2_INSTRUMENTSPEED: equ 55485 
PLY_AKG_CHANNEL2_INSTRUMENTSTEP: equ 55486 
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER: equ 55496 
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL: equ 55495 
PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS: equ 55484 
PLY_AKG_CHANNEL2_PTBASEINSTRUMENT: equ 55501 
PLY_AKG_CHANNEL2_PTINSTRUMENT: equ 55499 
PLY_AKG_CHANNEL2_PTTRACK: equ 55489 
PLY_AKG_CHANNEL2_SOUNDEFFECTDATA: equ 55540 
PLY_AKG_CHANNEL2_TRACKNOTE: equ 55487 
PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME: equ 55511 
PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH: equ 55528 
PLY_AKG_CHANNEL3_INSTRUMENTSPEED: equ 55508 
PLY_AKG_CHANNEL3_INSTRUMENTSTEP: equ 55509 
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER: equ 55519 
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL: equ 55518 
PLY_AKG_CHANNEL3_PTBASEINSTRUMENT: equ 55524 
PLY_AKG_CHANNEL3_PTINSTRUMENT: equ 55522 
PLY_AKG_CHANNEL3_PTTRACK: equ 55512 
PLY_AKG_CHANNEL3_SOUNDEFFECTDATA: equ 55548 
PLY_AKG_CHANNEL3_TRACKNOTE: equ 55510 
PLY_AKG_CHANNEL3_WAITCOUNTER: equ 55507 
PLY_AKG_CURRENTSPEED: equ 55425 
PLY_AKG_EMPTYINSTRUMENTDATAPT: equ 55439 
PLY_AKG_EVENT: equ 55424 
PLY_AKG_EVENTTRACK_PTTRACK: equ 55435 
PLY_AKG_EVENTTRACK_WAITCOUNTER: equ 55429 
PLY_AKG_INSTRUMENTSTABLE: equ 55437 
PLY_AKG_PATTERNDECREASINGHEIGHT: equ 55427 
PLY_AKG_PSGHARDWAREPERIOD_INSTR: equ 55453 
PLY_AKG_PSGREG01_INSTR: equ 55443 
PLY_AKG_PSGREG10: equ 55452 
PLY_AKG_PSGREG13_INSTR: equ 55431 
PLY_AKG_PSGREG13_OLDVALUE: equ 55430 
PLY_AKG_PSGREG23_INSTR: equ 55445 
PLY_AKG_PSGREG45_INSTR: equ 55447 
PLY_AKG_PSGREG6_8_INSTR: equ 55449 
PLY_AKG_PSGREG8: equ 55450 
PLY_AKG_PSGREG9_10_INSTR: equ 55451 
PLY_AKG_PTSOUNDEFFECTTABLE: equ 55530 
PLY_AKG_READLINKER_PTLINKER: equ 55433 
PLY_AKG_SAVESP: equ 55441 
PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS: equ 55458 
PLY_AKG_TICKDECREASINGCOUNTER: equ 55428 
