.code

;
; DrawCharStroke - disegna un carattere con il metodo a tratti (stroke)
;
; Il carattere e' una lista di segmenti (vedi inc\StrokeFont.inc): ogni punto della griglia
; viene convertito in pixel moltiplicandolo per la scala e sommando l'origine, poi i segmenti
; si tracciano con DrawLineDDA. Raddoppiando la scala il carattere raddoppia.
;
; In: pFB     = puntatore alla struttura FRAMEBUFFER
;     x, y    = angolo in alto a sinistra della cella del carattere, in pixel
;     scale   = pixel per unita' della griglia (1 = carattere alto 6 pixel)
;     char    = codice ASCII del carattere (le minuscole non sono definite: vedi DrawStringStroke)
;     dwColor = colore nel formato AARRGGBB
;
; Out: EAX = avanzamento orizzontale in pixel fino al carattere successivo
;
DrawCharStroke proc uses esi pFB:DWORD, x:DWORD, y:DWORD, scale:DWORD, char:DWORD, dwColor:DWORD
LOCAL	penDown:DWORD		; 0 penna sollevata (il prossimo punto è solo uno spostamento)
LOCAL	curX:SDWORD		; punto corrente in pixel
LOCAL	curY:SDWORD
LOCAL	prevX:SDWORD		; punto precedente, in pixel
LOCAL	prevY:SDWORD

	; carica i dati del carattere nella tabella (indice = codice - 32)
	; il confronto e' senza segno: i codici minori di 32 diventano
	; enormi e finiscono fuori tabella
	mov	eax, char
	sub	eax, SF_FIRST_CHAR
	.IF eax >= SF_GLYPH_COUNT
		mov	esi, offset G_Missing		; carattere non definito: riquadro
	.ELSE
		mov	esi, StrokeGlyphTable[eax*4]	; ESI = puntatore ai dati del carattere
	.ENDIF

	mov	penDown, 0		; penna sollevata per default

	.WHILE TRUE
		movzx	eax, BYTE PTR [esi]		; legge un byte dei dati
		inc	esi
		.BREAK .IF eax == SF_END		; fine del carattere
		.IF eax == SF_PENUP
			mov	penDown, 0		; solleva la penna se richiesto dalla tabella
			.CONTINUE
		.ENDIF

		; EAX = x del punto nella griglia, il byte successivo e' la y
		movzx	edx, BYTE PTR [esi]
		inc	esi

		; pixel = origine + coordinata della griglia * scala
		imul	eax, scale
		add	eax, x
		mov	curX, eax		; salva x corrente

		imul	edx, scale
		add	edx, y
		mov	curY, edx		; salva y corrente

		.IF penDown != 0
			invoke	DrawLineDDA, pFB, prevX, prevY, curX, curY, dwColor
		.ENDIF

		mov	eax, curX		; x corrente diventa x precedente
		mov	prevX, eax

		mov	eax, curY		; y corrente diventa y precedente
		mov	prevY, eax

		mov	penDown, 1		; scrive
	.ENDW

	mov	eax, SF_ADVANCE
	imul	eax, scale


	ret
DrawCharStroke endp

;
; DrawStringStroke - disegna una stringa con il metodo a tratti
;
; Le lettere minuscole vengono disegnate come maiuscole.
;
; In: pFB     = puntatore alla struttura FRAMEBUFFER
;     x, y    = angolo in alto a sinistra del primo carattere, in pixel
;     scale   = pixel per unita' della griglia
;     pStr    = puntatore alla stringa terminata da zero
;     dwColor = colore nel formato AARRGGBB
;
; Out: EAX = larghezza della stringa in pixel
;
DrawStringStroke proc uses esi pFB:DWORD, x:DWORD, y:DWORD, scale:DWORD, pStr:DWORD, dwColor:DWORD
LOCAL curX:SDWORD

	mov	esi, pStr		; prende offset della stringa
	mov	eax, x			; coordianta x
	mov	curX, eax		; salva coordinata corrente

	.WHILE BYTE PTR [ESI] != 0
		movzx	eax, BYTE PTR [esi]
		.IF eax >= 'a' && eax <= 'z'
			sub	eax, 32		; minuscola convertita in maiuscola
		.ENDIF

		invoke	DrawCharStroke, pFB, curX, y, scale, eax, dwColor	; disegna carattere
		add	curX, eax
		inc	esi
	.ENDW

	mov	eax, curX
	sub	eax, x			; restituisce larghezza totale
	ret
DrawStringStroke endp