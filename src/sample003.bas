100 SCREEN1,2:COLOR15,1,1:KEYOFF:WIDTH32
110 ' CHANGE THE CHARACTER PATTERN
120 CC=ASC("0")
120 FOR I=0 TO 7
130 READ HX$
140 VPOKE CC*8+I,VAL("&H"+HX$)
150 NEXT I
160 ' CHANGE THE CHARACTER COLOR
170 ' FORE COLOR=RED(8)
180 ' BG COLOR=BLACK(1)
190 VA=VAL("&H2000")+CC/8
200 VPOKE VA, &H81
210 ' FILL CHARACTER
220 VA=VAL("&H1800")
230 FOR I=0 TO 767
240 VPOKE VA+I, CC
250 NEXT I
300 GOTO 300
500 ' CHARACTER PATTERN DATA
510 DATA FC,FC,FC,00,CF,CF,CF,00