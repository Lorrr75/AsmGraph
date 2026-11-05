; Strutc vanno definite qui per una migliore leggibilità del codice e per evitare di includere troppi file esterni

;
; Frame buffer: area di memoria con i pixel dell'immagine
;
FRAMEBUFFER struct
	fbBitmap	HBITMAP ?		; sezione DIB
	fbDC		HDC 	?		; DC di memoria in cui è selezionato il bitmap
	fbOldBitmap	HBITMAP ?		; bitmap originale del DC (da ripristinare)
	fbBits		DWORD  	?		; puntatore alla memoria dei pixel
	fbWidth		DWORD 	?		; larghezza in pixel
	fbHeight	DWORD 	?		; altezza in pixel
	fbPitch		DWORD	?		; byte per riga
FRAMEBUFFER ends
