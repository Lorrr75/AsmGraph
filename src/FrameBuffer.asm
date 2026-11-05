;
; FrameBuffer.asm - Funzioni per la gestione del frame buffer per il disegno a video
;

.code

;
; CreateFrameBuffer
;
; Crea il frame buffer: una DIB section a 32 bit per pixel, top-down,
; selezionata in un DC di memoria
;
; In:	pFB	= puntatore alla struttura FRAMEBUFFER da riempire
;	nWidth	= larghezza in pixel
;	nHeight	= altezza in pixel
;
; Out:	EAX = 1 se ok, 0 in caso di errore (le risorse parziali vengono liberate)
CreateFrameBuffer proc uses esi edi pFB:DWORD, nWidth:DWORD, nHeight:DWORD
LOCAL	bmi:BITMAPINFO
LOCAL	hdcScreen:HDC
LOCAL	pBits:DWORD

	mov	esi, pFB		; memorizza puntatore struttura FrameBuffer

	; azzeriamo la BITMAPINFO (le variabili LOCAL potrebbero essere inquinati dalla memoria)
	lea	edi, bmi		; carica offset bmi
	mov	ecx, SIZEOF BITMAPINFO / 4  ; calcola dimensione in double word (numero di ripetizioni)
	xor	eax, eax		; azzera eax, per azzerare la struttura
	cld				; direzione in avanti
	rep	stosd			; ripete memorizzando 0 byte nella struttura ecx volte

	; impostiamo la struttura bmi descrivendo la bitmap: 32 bit per pixel, nessuna compressione
	mov	bmi.bmiHeader.biSize, SIZEOF BITMAPINFOHEADER	; dimensioni della bitmap
	mov	eax, nWidth		; larghezza buffer in eax
	mov	bmi.bmiHeader.biWidth, eax	; e lo memorizziamo nella struttura
	mov	eax, nHeight		; altezza buffer in eax
	neg	eax			; altezza NEGATIVA = top-down: la riga 0 è in alto
	mov	bmi.bmiHeader.biHeight, eax	; memorizza altezza
	mov	bmi.bmiHeader.biPlanes, 1	; un solo piano
	mov	bmi.bmiHeader.biBitCount, 32	; 32 bit di colore
	mov	bmi.bmiHeader.biCompression, BI_RGB	; formato RGB NON compresso

	; memorizziamo le dimensioni nella struttura
	mov	eax, nWidth			; larghezza
	mov	[esi].FRAMEBUFFER.fbWidth, eax
	shl	eax, 2				; calcola pitch = larghezza * 4 byte per pixel
	mov	[esi].FRAMEBUFFER.fbPitch, eax
	mov	eax, nHeight			; altezza
	mov	[esi].FRAMEBUFFER.fbHeight, eax

	; creiamo DC di memoria DIB section
	invoke	GetDC, NULL		; DC finestra corrente
	mov	hdcScreen, eax		; e lo memorizza
	invoke	CreateCompatibleDC, hdcScreen	; cfrea un nuovo DC
	mov	[esi].FRAMEBUFFER.fbDC, eax
	invoke	CreateDIBSection, hdcScreen, ADDR bmi, DIB_RGB_COLORS, ADDR pBits, NULL, 0	; crea Dib section
	mov	[esi].FRAMEBUFFER.fbBitmap, eax	
	invoke	ReleaseDC, NULL, hdcScreen	; rilascia DC

	; controlliamo gli errori
	cmp	[esi].FRAMEBUFFER.fbDC, 0
	je	CFB_Fail
	cmp	[esi].FRAMEBUFFER.fbBitmap, 0
	je	CFB_Fail

	; windows ci ha dato il puntatore alla memria dei pixel
	mov	eax, pBits
	mov	[esi].FRAMEBUFFER.fbBits, eax

	; selezioniamo il bitmap nel DC e ricordiamo quello originale da ripristinare in seguito
	invoke	SelectObject, [esi].FRAMEBUFFER.fbDC, [esi].FRAMEBUFFER.fbBitmap
	mov	[esi].FRAMEBUFFER.fbOldBitmap, eax

	mov	eax, 1			;successo
	ret

CFB_Fail:
	; qualcosa è andato storto e segnaliamo errore e cancelliamo i dati che abbiamo ottenuto
	invoke	DestroyFrameBuffer, esi
	xor	eax, eax		; segnagliamo errore
	ret
CreateFrameBuffer endp

;
; DestroyFrameBuffer
;
; Libera tutte le risorse del frame buffer e azzera la struttura.
; Si può chiamare anche su una struttura vuota o riempita a metà
;
; In:	pFB = puntatore alla struttura FRAMEBUFFER
;
DestroyFrameBuffer proc uses esi edi pFB:DWORD
	
	mov	esi, pFB		; punta alla struttura

	; prima di cancellare il bitmap va tolto dal DC, ripristinando quello originale se esistono
	.IF [esi].FRAMEBUFFER.fbDC != 0
		.IF [esi].FRAMEBUFFER.fbOldBitmap != 0
			invoke	SelectObject, [esi].FRAMEBUFFER.fbDC, [esi].FRAMEBUFFER.fbOldBitmap
		.ENDIF
	.ENDIF

	.IF [esi].FRAMEBUFFER.fbBitmap != 0
		invoke	DeleteObject, [esi].FRAMEBUFFER.fbBitmap
	.ENDIF

	.IF [esi].FRAMEBUFFER.fbDC != 0
		invoke	DeleteDC, [esi].FRAMEBUFFER.fbDC
	.ENDIF

	; azzeriamo la struttura
	mov	edi, esi		; punta alla struttura comedestinazione
	mov	ecx, SIZEOF FRAMEBUFFER / 4	; calcola dimensione in double word (numero di ripetizioni)
	xor	eax, eax		; mette 0 nella struttura
	cld				; riempe in avanti
	rep	stosd			; riempe la struttura
		
	ret
DestroyFrameBuffer endp
