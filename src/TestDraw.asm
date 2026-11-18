.code

;
; Prove temporanee di PutPixel e ReadPixel (da togliere quando non servono piu').
;
; 1) disegna un gradiente 256x256 in (50,100): rosso = colonna, verde = riga, blu fisso
; 2) lo copia in (340,100) leggendolo pixel per pixel con ReadPixel
;
; Se le due copie sono identiche, ReadPixel funziona.
;
TestDraw proc pFB:DWORD
LOCAL xx:DWORD
LOCAL yy:DWORD
LOCAL col:DWORD

    	; --- 1) gradiente ---
    	mov	yy, 0
    	.WHILE yy < 256
        	mov    	xx, 0
        	.WHILE xx < 256
            		mov     eax, xx
            		shl     eax, 16             ; rosso nel byte alto
            		mov     edx, yy
            		shl     edx, 8              ; verde nel byte centrale
            		or      eax, edx
            		or      eax, 80h            ; blu fisso
            		mov     col, eax
		        mov     eax, xx
            		add     eax, 50
		        mov     edx, yy
            		add     edx, 100
		        invoke  PutPixel, pFB, eax, edx, col
		        inc     xx
	        .ENDW
        	inc     yy
	.ENDW

    	; --- 2) copia letta con ReadPixel ---
    	mov     yy, 0
    	.WHILE yy < 256
      		mov     xx, 0
        	.WHILE xx < 256
           		mov     eax, xx
            		add     eax, 50
            		mov     edx, yy
            		add     edx, 100
           		invoke  ReadPixel, pFB, eax, edx    ; legge dal gradiente originale
            		mov     col, eax

            		mov     eax, xx
            		add     eax, 340
            		mov     edx, yy
            		add     edx, 100
            		invoke  PutPixel, pFB, eax, edx, col

            		inc     xx
        	.ENDW
        	inc     yy
    	.ENDW

	ret
TestDraw endp

;
; Prova temporanea di DrawLineDDA: una raggiera di linee dal centro del buffer
; in tutte le direzioni, più qualche caso prticolare
;
TestLines proc pFB:DWORD
	; disegno linee orizzontali e verticali
	invoke	DrawLineDDA, pFB, 320, 240, 600, 240, 00FFFFFFh		; destra
	invoke	DrawLineDDA, pFB, 320, 240,  40, 240, 00FFFFFFh		; sinistra
	invoke	DrawLineDDA, pFB, 320, 240, 320,  40, 00FFFFFFh		; su
	invoke	DrawLineDDA, pFB, 320, 240, 320, 440, 00FFFFFFh		; giù

	; diagonali a 45 gradi (giallo)
	invoke	DrawLineDDA, pFB, 320, 240, 520,  40, 00FFFF00h	
	invoke	DrawLineDDA, pFB, 320, 240, 120,  40, 00FFFF00h	
	invoke	DrawLineDDA, pFB, 320, 240, 520, 440, 00FFFF00h	
	invoke	DrawLineDDA, pFB, 320, 240, 120, 440, 00FFFF00h	

	; poco inclinate, |DX| > |DY| (rosso)
	invoke	DrawLineDDA, pFB, 320, 240, 600, 200, 00FF0000h	
	invoke	DrawLineDDA, pFB, 320, 240, 600, 280, 00FF0000h	
	invoke	DrawLineDDA, pFB, 320, 240,  40, 200, 00FF0000h	
	invoke	DrawLineDDA, pFB, 320, 240,  40, 280, 00FF0000h	

	; molto inclinate, |DY| > |DX| (verde)
	invoke	DrawLineDDA, pFB, 320, 240, 380,  40, 0000FF00h	
	invoke	DrawLineDDA, pFB, 320, 240, 260,  40, 0000FF00h	
	invoke	DrawLineDDA, pFB, 320, 240, 380, 440, 0000FF00h	
	invoke	DrawLineDDA, pFB, 320, 240, 260, 440, 0000FF00h	

	; punto singolo: i due estremi coincidono (azzurro)
	invoke	DrawLineDDA, pFB,  20,  20,  20,  20, 0000FFFFh	

	; linee che escono dal buffer: la parte fuori viene scartata da PutPixel (magenta)
	invoke	DrawLineDDA, pFB, -100, 50, 100, 250, 00FF00FFh	
	invoke	DrawLineDDA, pFB, 540, 400, 800, 520, 00FF00FFh	
	ret
TestLines endp