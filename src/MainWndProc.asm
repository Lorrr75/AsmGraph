.386

.code

;
; Funzione di gestione dei messaggi che provengono da windows
; 
;
MainWndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
LOCAL	hdc:HDC
LOCAL	ps:PAINTSTRUCT
LOCAL	rect:RECT

	.IF uMsg == WM_DESTROY				; messaggio di chiusura della finestra
		invoke	DestroyFrameBuffer, ADDR g_fb	; distrugge il frame buffer prima di uscire
		invoke 	PostQuitMessage, NULL		; chiude la finetra

	.ELSEIF uMsg == WM_CREATE			; messaggio di creazione della finestra
		invoke	CreateFrameBuffer, ADDR g_fb, FB_WIDTH, FB_HEIGHT		; crea il frame buffer alla creazione della finestra
		.IF	eax == 0			; errore nella creazione del frame buffer, messaggio di errore
			invoke	MessageBox, hWnd, ADDR szErrorCreateFrameBuffer, ADDR szCaptionError, MB_OK or MB_ICONERROR
			mov	eax, -1			; Segnala errore da WM_CREATE: la finestra non viene creata
		.ENDIF

	.ELSEIF uMsg == WM_PAINT			; messaggio di ridisegno della finestra
		invoke	BeginPaint, hWnd, ADDR ps
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