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

;
; Prova dei caratteri a tratti: stringhe a scale diverse, la conversione delle minuscole
; e una stringa che esce dal buffer (la parte fuori viene scartata da PutPixel).
;
.data

; usiamo dati "locali" (inteso dentro al file di test) per non sporcare il progetto
szStroke1   db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
szStroke2   db "0123456789 .,:-+=!?/()",0
szStroke3   db "ASMGRAPH 2026",0
szStroke4   db "Test 123",0                     ; minuscole: vengono convertite
szStroke5   db "STROKE",0
szStroke6   db "DDA",0
szStroke7   db "CLIPPING TEST: OUTSIDE",0

.code

TestStroke proc pFB:DWORD

	invoke	DrawStringStroke, pFB, 10, 10, 1, OFFSET szStroke1, 00FFFFFFh	; scala 1
	invoke	DrawStringStroke, pFB, 10, 26, 2, OFFSET szStroke2, 0000FFFFh	; scala 1
	invoke	DrawStringStroke, pFB, 10, 50, 3, OFFSET szStroke3, 00FFFF00h	; scala 3
	invoke	DrawStringStroke, pFB, 10, 90, 4, OFFSET szStroke4, 0000FF00h	; scala 4
	invoke	DrawStringStroke, pFB, 10, 130, 5, OFFSET szStroke5, 00FF0000h	; scala 5
	invoke	DrawStringStroke, pFB, 10, 190, 6, OFFSET szStroke6, 00FF00FFh	; scala 6
	invoke	DrawStringStroke, pFB, 300, 300, 10, OFFSET szStroke7, 00FF8000h	; scala 10

	ret
TestStroke endp