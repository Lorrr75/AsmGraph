.386

.code

;
; Funzione di gestione dei messaggi che provengono da windows
; 
;
MainWndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
LOCAL	ps:PAINTSTRUCT

	.IF uMsg == WM_DESTROY				; messaggio di chiusura della finestra
		invoke	DestroyFrameBuffer, ADDR g_fb	; distrugge il frame buffer prima di uscire
		invoke 	PostQuitMessage, NULL		; chiude la finetra

	.ELSEIF uMsg == WM_CREATE			; messaggio di creazione della finestra
		invoke CreateFrameBuffer, ADDR g_fb, FB_WIDTH, FB_HEIGHT	; crea il frame buffer indispensabile altrimenti la magia non funziona
		.IF eax == 0				; errore nella creazione del buffer?
			; si, scrivi messaggio d'errore
			invoke MessageBox, hWnd, ADDR szErrorCreateFrameBuffer, ADDR szCaptionError, MB_OK or MB_ICONERROR
			mov eax, -1
			ret
		.ENDIF

		; buffer creato correttamente
		invoke ClearBuffer, ADDR g_fb, 00000000h	; pulisce tutto il frame buffer scrivendo uno sfondo nero
		
		; qui creiamo la magia dei test. lasciamo commentati tutti i test eseguiti in passato usando solo quello in uso
		; se vuoi generare tu i test decommenta quello che preferisci e commenta l'ultimo in modo da avere un solo test alla volta
		; NOTA: il mio consiglio è vederli in ordine come sono stati creati

;		invoke TestDraw, ADDR g_fb		; richiama i test di disegno		[Test   1] test_1_pixel.exe
		invoke TestLines, ADDR g_fb		; richiama i test disegno linee		[Test   2] test_2_lines.exe

	.ELSEIF uMsg == WM_PAINT			; messaggio di ridisegno della finestra
		invoke	BeginPaint, hWnd, ADDR ps
		invoke	BitBlt, ps.hdc, 0, 0, g_fb.fbWidth, g_fb.fbHeight, g_fb.fbDC, 0, 0, SRCCOPY
		invoke	EndPaint, hWnd, ADDR ps
		ret
		
	.ELSEIF uMsg == WM_COMMAND			; messaggio comandi della finestra

	.ELSEIF uMsg == WM_CLOSE
		invoke	DestroyWindow, hWnd

	.ELSEIF uMsg == WM_SIZE

	.ELSEIF uMsg == WM_NOTIFY
	.ELSEIF uMsg == WM_MOVE
	.ELSEIF uMsg == WM_MOUSEMOVE
	.ELSEIF uMsg == WM_LBUTTONDOWN
	.ELSEIF uMsg == WM_MBUTTONDOWN
	.ELSEIF uMsg == WM_RBUTTONDOWN
	.ELSEIF uMsg == WM_LBUTTONUP
	.ELSEIF uMsg == WM_MBUTTONUP
	.ELSEIF uMsg == WM_RBUTTONUP
	.ELSEIF uMsg == WM_KEYDOWN
	.ELSEIF uMsg == WM_KEYUP
	.ELSEIF uMsg == WM_CHAR
	.ELSEIF uMsg == WM_TIMER
	.ELSE
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.ENDIF

	xor	eax, eax
	ret
MainWndProc	endp