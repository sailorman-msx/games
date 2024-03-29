; TRAINING_BGM, AKG format, v1.0.

; Generated by Arkos Tracker 2.

TRAINING_BGM_Start:
TRAINING_BGM_StartDisarkGenerateExternalLabel:

TRAINING_BGM_DisarkByteRegionStart0:
	defb "AT20"
TRAINING_BGM_DisarkPointerRegionStart1:
	defw TRAINING_BGM_ArpeggioTable	; The address of the Arpeggio table.
	defw TRAINING_BGM_PitchTable	; The address of the Pitch table.
	defw TRAINING_BGM_InstrumentTable	; The address of the Instrument table.
	defw TRAINING_BGM_EffectBlockTable	; The address of the Effect Block table.
TRAINING_BGM_DisarkPointerRegionEnd1:


; The addresses of each Subsong:
TRAINING_BGM_DisarkPointerRegionStart2:
	defw TRAINING_BGM_Subsong0_Start
TRAINING_BGM_DisarkPointerRegionEnd2:

; Declares all the Arpeggios.
TRAINING_BGM_ArpeggioTable:
TRAINING_BGM_DisarkPointerRegionStart3:
TRAINING_BGM_DisarkPointerRegionEnd3:

; Declares all the Pitches.
TRAINING_BGM_PitchTable:
TRAINING_BGM_DisarkPointerRegionStart4:
TRAINING_BGM_DisarkPointerRegionEnd4:

; Declares all the Instruments.
TRAINING_BGM_InstrumentTable:
TRAINING_BGM_DisarkPointerRegionStart5:
	defw TRAINING_BGM_EmptyInstrument
	defw TRAINING_BGM_Instrument1
	defw TRAINING_BGM_Instrument2
	defw TRAINING_BGM_Instrument3
TRAINING_BGM_DisarkPointerRegionEnd5:

TRAINING_BGM_EmptyInstrument:
	defb 0	; The speed (>0, 0 for 256).
TRAINING_BGM_EmptyInstrument_Loop:	defb 0	; No Soft no Hard. Volume: 0. Noise? false.

	defb 6	; Loop to silence.

TRAINING_BGM_Instrument1:
	defb 1	; The speed (>0, 0 for 256).
	defb 248	; No Soft no Hard. Volume: 15. Noise? true.
	defb 1	; Noise: 1.

	defb 113	; Soft only. Volume: 14.
	defb 37	; Additional data. Noise: 5. Pitch? true. Arp? false. Period? false.
	defw 150	; Pitch.

	defb 105	; Soft only. Volume: 13.
	defb 34	; Additional data. Noise: 2. Pitch? true. Arp? false. Period? false.
	defw 300	; Pitch.

	defb 97	; Soft only. Volume: 12.
	defb 32	; Additional data. Noise: 0. Pitch? true. Arp? false. Period? false.
	defw 400	; Pitch.

	defb 89	; Soft only. Volume: 11.
	defb 32	; Additional data. Noise: 0. Pitch? true. Arp? false. Period? false.
	defw 500	; Pitch.

	defb 81	; Soft only. Volume: 10.
	defb 32	; Additional data. Noise: 0. Pitch? true. Arp? false. Period? false.
	defw 600	; Pitch.

	defb 6	; Loop to silence.

TRAINING_BGM_Instrument2:
	defb 1	; The speed (>0, 0 for 256).
	defb 248	; No Soft no Hard. Volume: 15. Noise? true.
	defb 1	; Noise: 1.

	defb 232	; No Soft no Hard. Volume: 13. Noise? true.
	defb 1	; Noise: 1.

	defb 216	; No Soft no Hard. Volume: 11. Noise? true.
	defb 1	; Noise: 1.

	defb 192	; No Soft no Hard. Volume: 8. Noise? true.
	defb 1	; Noise: 1.

	defb 168	; No Soft no Hard. Volume: 5. Noise? true.
	defb 1	; Noise: 1.

	defb 6	; Loop to silence.

TRAINING_BGM_Instrument3:
	defb 1	; The speed (>0, 0 for 256).
	defb 249	; Soft only. Volume: 15. Volume only.

	defb 241	; Soft only. Volume: 14. Volume only.

	defb 233	; Soft only. Volume: 13. Volume only.

	defb 225	; Soft only. Volume: 12. Volume only.

TRAINING_BGM_Instrument3_Loop:	defb 217	; Soft only. Volume: 11. Volume only.

	defb 7	; Loop.
TRAINING_BGM_DisarkWordForceReference6:
	defw TRAINING_BGM_Instrument3_Loop	; Loop here.


; The indexes of the effect blocks used by this song.
TRAINING_BGM_EffectBlockTable:

TRAINING_BGM_DisarkByteRegionEnd0:

; Subsong 0
; ----------------------
TRAINING_BGM_Subsong0_DisarkByteRegionStart0:
TRAINING_BGM_Subsong0_Start:
	defb 2	; ReplayFrequency (0=12.5hz, 1=25, 2=50, 3=100, 4=150, 5=300).
	defb 1	; Digichannel (0-2).
	defb 1	; PSG count (>0).
	defb 0	; Loop start index (>=0).
	defb 0	; End index (>=0).
	defb 11	; Initial speed (>=0).
	defb 17	; Base note index (>=0).

TRAINING_BGM_Subsong0_Linker:
TRAINING_BGM_Subsong0_DisarkPointerRegionStart1:
; Position 0
TRAINING_BGM_Subsong0_Linker_Loop:
	defw TRAINING_BGM_Subsong0_Track0
	defw TRAINING_BGM_Subsong0_Track1
	defw TRAINING_BGM_Subsong0_Track2
	defw TRAINING_BGM_Subsong0_LinkerBlock0

TRAINING_BGM_Subsong0_DisarkPointerRegionEnd1:
	defw 0	; Loop.
TRAINING_BGM_Subsong0_DisarkWordForceReference2:
	defw TRAINING_BGM_Subsong0_Linker_Loop

TRAINING_BGM_Subsong0_LinkerBlock0:
	defb 64	; Height.
	defb 0	; Transposition 0.
	defb 0	; Transposition 1.
	defb 0	; Transposition 2.
TRAINING_BGM_Subsong0_DisarkWordForceReference3:
	defw TRAINING_BGM_Subsong0_SpeedTrack0	; SpeedTrack address.
TRAINING_BGM_Subsong0_DisarkWordForceReference4:
	defw TRAINING_BGM_Subsong0_EventTrack0	; EventTrack address.

TRAINING_BGM_Subsong0_Track0:
	defb 171
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 173
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 170
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 171
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 170
	defb 3	; New Instrument (3).
	defb 43
	defb 42
	defb 43
	defb 60	; Waits for 1 line.

	defb 43
	defb 171
	defb 2	; New Instrument (2).
	defb 173
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 170
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 171
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 170
	defb 3	; New Instrument (3).
	defb 43
	defb 42
	defb 43
	defb 171
	defb 2	; New Instrument (2).
	defb 178
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 43
	defb 175
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 173
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 178
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 176
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 175
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 173
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 43
	defb 171
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 171
	defb 3	; New Instrument (3).
	defb 45
	defb 171
	defb 2	; New Instrument (2).
	defb 175
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 175
	defb 3	; New Instrument (3).
	defb 55
	defb 60	; Waits for 1 line.

	defb 54
	defb 171
	defb 2	; New Instrument (2).
	defb 175
	defb 3	; New Instrument (3).
	defb 50
	defb 50
	defb 171
	defb 2	; New Instrument (2).
	defb 176
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 171
	defb 3	; New Instrument (3).
	defb 171
	defb 2	; New Instrument (2).
	defb 173
	defb 3	; New Instrument (3).
	defb 61, 127	; Waits for 128 lines.


TRAINING_BGM_Subsong0_Track1:
	defb 166
	defb 1	; New Instrument (1).
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 38
	defb 62 + 0 * 64	; Optimized wait for 2 lines.

	defb 38
	defb 38
	defb 60	; Waits for 1 line.

	defb 42
	defb 42
	defb 42
	defb 62 + 0 * 64	; Optimized wait for 2 lines.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 60	; Waits for 1 line.

	defb 38
	defb 38
	defb 62 + 0 * 64	; Optimized wait for 2 lines.

	defb 38
	defb 38
	defb 62 + 0 * 64	; Optimized wait for 2 lines.

	defb 38
	defb 38
	defb 62 + 0 * 64	; Optimized wait for 2 lines.

	defb 38
	defb 61, 127	; Waits for 128 lines.


TRAINING_BGM_Subsong0_Track2:
	defb 61, 127	; Waits for 128 lines.


; The speed tracks
TRAINING_BGM_Subsong0_SpeedTrack0:
	defb 255	; Wait for 128 lines.

; The event tracks
TRAINING_BGM_Subsong0_EventTrack0:
	defb 255	; Wait for 128 lines.

TRAINING_BGM_Subsong0_DisarkByteRegionEnd0:
