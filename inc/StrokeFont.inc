;
; StrokeFont.inc - Set iniziale di caratteri per il metodo a tratti (stroke)
;
; Ogni carattere e' disegnato su una griglia di punti: x da 0 a 4, y da 0 a 6,
; con y che cresce verso il basso (come lo schermo). L'origine (0,0) e' l'angolo
; in alto a sinistra della cella del carattere.
;
; Formato dei dati di un carattere: una sequenza di punti, ciascuno di due byte (x, y).
;   - il primo punto di ogni tratto e' solo uno spostamento della penna
;   - ogni punto successivo traccia un segmento dal punto precedente
;   - SF_PENUP solleva la penna: il punto che segue e' di nuovo uno spostamento
;   - SF_END termina il carattere
;
; I disegni di questo set sono originali di AsmGraph.
;

SF_PENUP	equ 0FEh		; solleva la penna
SF_END		equ 0FFh		; fine dei dati del carattere

SF_FIRST_CHAR	equ 32		; primo carattere della tabella (spazio)
SF_GLYPH_COUNT	equ 59		; caratteri nella tabella: da 32 (spazio) a 90 ('Z')
SF_ADVANCE	equ 6		; avanzamento orizzontale tra due caratteri, in unita' della griglia
SF_HEIGHT	equ 6		; altezza del carattere, in unita' della griglia

.data

; carattere mancante (riquadro)
G_Missing	db 0,0, 4,0, 4,6, 0,6, 0,0, SF_END

; ' '
G_Space	db SF_END

; '!'
G_Excl	db 2,0, 2,4, SF_PENUP
	db 2,5, 2,6, SF_END

; '('
G_LParen	db 3,0, 2,1, 2,5, 3,6, SF_END

; ')'
G_RParen	db 1,0, 2,1, 2,5, 1,6, SF_END

; '+'
G_Plus	db 0,3, 4,3, SF_PENUP
	db 2,1, 2,5, SF_END

; ','
G_Comma	db 2,5, 2,6, 1,6, SF_END

; '-'
G_Minus	db 0,3, 4,3, SF_END

; '.'
G_Dot	db 2,5, 2,6, SF_END

; '/'
G_Slash	db 4,0, 0,6, SF_END

; ':'
G_Colon	db 2,1, 2,2, SF_PENUP
	db 2,4, 2,5, SF_END

; '='
G_Equal	db 0,2, 4,2, SF_PENUP
	db 0,4, 4,4, SF_END

; '?'
G_Quest	db 0,1, 1,0, 3,0, 4,1, 4,2, 2,3, 2,4, SF_PENUP
	db 2,5, 2,6, SF_END

; '0'
G_0	db 1,0, 3,0, 4,1, 4,5, 3,6, 1,6, 0,5, 0,1, 1,0, SF_PENUP
	db 1,5, 3,1, SF_END

; '1'
G_1	db 1,1, 2,0, 2,6, SF_PENUP
	db 1,6, 3,6, SF_END

; '2'
G_2	db 0,1, 1,0, 3,0, 4,1, 4,2, 0,6, 4,6, SF_END

; '3'
G_3	db 0,1, 1,0, 3,0, 4,1, 4,2, 3,3, 1,3, SF_PENUP
	db 3,3, 4,4, 4,5, 3,6, 1,6, 0,5, SF_END

; '4'
G_4	db 3,6, 3,0, 0,4, 4,4, SF_END

; '5'
G_5	db 4,0, 0,0, 0,3, 3,3, 4,4, 4,5, 3,6, 1,6, 0,5, SF_END

; '6'
G_6	db 3,0, 1,0, 0,1, 0,5, 1,6, 3,6, 4,5, 4,4, 3,3, 0,3, SF_END

; '7'
G_7	db 0,0, 4,0, 1,6, SF_END

; '8'
G_8	db 1,0, 3,0, 4,1, 4,2, 3,3, 1,3, 0,2, 0,1, 1,0, SF_PENUP
	db 1,3, 0,4, 0,5, 1,6, 3,6, 4,5, 4,4, 3,3, SF_END

; '9'
G_9	db 4,3, 1,3, 0,2, 0,1, 1,0, 3,0, 4,1, 4,5, 3,6, 1,6, SF_END

; 'A'
G_A	db 0,6, 0,1, 1,0, 3,0, 4,1, 4,6, SF_PENUP
	db 0,3, 4,3, SF_END

; 'B'
G_B	db 0,6, 0,0, 3,0, 4,1, 4,2, 3,3, 0,3, SF_PENUP
	db 3,3, 4,4, 4,5, 3,6, 0,6, SF_END

; 'C'
G_C	db 4,1, 3,0, 1,0, 0,1, 0,5, 1,6, 3,6, 4,5, SF_END

; 'D'
G_D	db 0,0, 0,6, 2,6, 4,4, 4,2, 2,0, 0,0, SF_END

; 'E'
G_E	db 4,0, 0,0, 0,6, 4,6, SF_PENUP
	db 0,3, 3,3, SF_END

; 'F'
G_F	db 4,0, 0,0, 0,6, SF_PENUP
	db 0,3, 3,3, SF_END

; 'G'
G_G	db 4,1, 3,0, 1,0, 0,1, 0,5, 1,6, 3,6, 4,5, 4,3, 2,3, SF_END

; 'H'
G_H	db 0,0, 0,6, SF_PENUP
	db 4,0, 4,6, SF_PENUP
	db 0,3, 4,3, SF_END

; 'I'
G_I	db 1,0, 3,0, SF_PENUP
	db 2,0, 2,6, SF_PENUP
	db 1,6, 3,6, SF_END

; 'J'
G_J	db 4,0, 4,5, 3,6, 1,6, 0,5, SF_END

; 'K'
G_K	db 0,0, 0,6, SF_PENUP
	db 4,0, 0,3, 4,6, SF_END

; 'L'
G_L	db 0,0, 0,6, 4,6, SF_END

; 'M'
G_M	db 0,6, 0,0, 2,3, 4,0, 4,6, SF_END

; 'N'
G_N	db 0,6, 0,0, 4,6, 4,0, SF_END

; 'O'
G_O	db 1,0, 3,0, 4,1, 4,5, 3,6, 1,6, 0,5, 0,1, 1,0, SF_END

; 'P'
G_P	db 0,6, 0,0, 3,0, 4,1, 4,2, 3,3, 0,3, SF_END

; 'Q'
G_Q	db 1,0, 3,0, 4,1, 4,5, 3,6, 1,6, 0,5, 0,1, 1,0, SF_PENUP
	db 2,4, 4,6, SF_END

; 'R'
G_R	db 0,6, 0,0, 3,0, 4,1, 4,2, 3,3, 0,3, SF_PENUP
	db 2,3, 4,6, SF_END

; 'S'
G_S	db 4,1, 3,0, 1,0, 0,1, 0,2, 1,3, 3,3, 4,4, 4,5, 3,6, 1,6, 0,5, SF_END

; 'T'
G_T	db 0,0, 4,0, SF_PENUP
	db 2,0, 2,6, SF_END

; 'U'
G_U	db 0,0, 0,5, 1,6, 3,6, 4,5, 4,0, SF_END

; 'V'
G_V	db 0,0, 2,6, 4,0, SF_END

; 'W'
G_W	db 0,0, 1,6, 2,3, 3,6, 4,0, SF_END

; 'X'
G_X	db 0,0, 4,6, SF_PENUP
	db 4,0, 0,6, SF_END

; 'Y'
G_Y	db 0,0, 2,3, 4,0, SF_PENUP
	db 2,3, 2,6, SF_END

; 'Z'
G_Z	db 0,0, 4,0, 0,6, 4,6, SF_END

;
; Tabella dei caratteri: indice = codice ASCII - 32. I caratteri non definiti usano il riquadro.
;
StrokeGlyphTable	dd OFFSET G_Space		; 32 ' '
	dd OFFSET G_Excl		; 33 '!'
	dd OFFSET G_Missing		; 34 '"'
	dd OFFSET G_Missing		; 35 '#'
	dd OFFSET G_Missing		; 36 '$'
	dd OFFSET G_Missing		; 37 '%'
	dd OFFSET G_Missing		; 38 '&'
	dd OFFSET G_Missing		; 39 "'"
	dd OFFSET G_LParen		; 40 '('
	dd OFFSET G_RParen		; 41 ')'
	dd OFFSET G_Missing		; 42 '*'
	dd OFFSET G_Plus		; 43 '+'
	dd OFFSET G_Comma		; 44 ','
	dd OFFSET G_Minus		; 45 '-'
	dd OFFSET G_Dot		; 46 '.'
	dd OFFSET G_Slash		; 47 '/'
	dd OFFSET G_0		; 48 '0'
	dd OFFSET G_1		; 49 '1'
	dd OFFSET G_2		; 50 '2'
	dd OFFSET G_3		; 51 '3'
	dd OFFSET G_4		; 52 '4'
	dd OFFSET G_5		; 53 '5'
	dd OFFSET G_6		; 54 '6'
	dd OFFSET G_7		; 55 '7'
	dd OFFSET G_8		; 56 '8'
	dd OFFSET G_9		; 57 '9'
	dd OFFSET G_Colon		; 58 ':'
	dd OFFSET G_Missing		; 59 ';'
	dd OFFSET G_Missing		; 60 '<'
	dd OFFSET G_Equal		; 61 '='
	dd OFFSET G_Missing		; 62 '>'
	dd OFFSET G_Quest		; 63 '?'
	dd OFFSET G_Missing		; 64 '@'
	dd OFFSET G_A		; 65 'A'
	dd OFFSET G_B		; 66 'B'
	dd OFFSET G_C		; 67 'C'
	dd OFFSET G_D		; 68 'D'
	dd OFFSET G_E		; 69 'E'
	dd OFFSET G_F		; 70 'F'
	dd OFFSET G_G		; 71 'G'
	dd OFFSET G_H		; 72 'H'
	dd OFFSET G_I		; 73 'I'
	dd OFFSET G_J		; 74 'J'
	dd OFFSET G_K		; 75 'K'
	dd OFFSET G_L		; 76 'L'
	dd OFFSET G_M		; 77 'M'
	dd OFFSET G_N		; 78 'N'
	dd OFFSET G_O		; 79 'O'
	dd OFFSET G_P		; 80 'P'
	dd OFFSET G_Q		; 81 'Q'
	dd OFFSET G_R		; 82 'R'
	dd OFFSET G_S		; 83 'S'
	dd OFFSET G_T		; 84 'T'
	dd OFFSET G_U		; 85 'U'
	dd OFFSET G_V		; 86 'V'
	dd OFFSET G_W		; 87 'W'
	dd OFFSET G_X		; 88 'X'
	dd OFFSET G_Y		; 89 'Y'
	dd OFFSET G_Z		; 90 'Z'
