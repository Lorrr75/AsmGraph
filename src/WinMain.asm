.code

;
; programma di inzizializzazione, ciclo principale, pulizia dati e uscita
;
WinMain proc hInst:DWORD, hPrevInst:DWORD, szCmdLine:DWORD, nCmdShow:DWORD
LOCAL	msg:MSG					; variabili locali sullo stack

	; chiama la registrazione della classe della finestra principale
	invoke	RegisterWindowMainClass

	; sopraggiunti errori durante la registrazione?
	cmp	eax, 0							; errori?
	jne	RegisterWindowMainClass_OK		; no proseguiamo con il programma

	; si, segnaliamo errore
	lea	eax, szErrorRegisterWindowMainClass	; testo dell'errore da visualizzare nella MessageBox
	jmp	WinMain_Error

	; nessun errore, continuiamo con il programma
RegisterWindowMainClass_OK:

	; creiamo la finestra principale
	invoke	CreateWindowEx, WS_EX_ACCEPTFILES, ADDR szMainClassName, ADDR szAppName, WS_OVERLAPPEDWINDOW, \
				CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, \
				NULL, NULL, hInst, NULL

	; sopraggiunti errori durante la creazione?
	cmp	eax, 0
	jne	CreateWindowEx_OK		; no, proseguiamo con il programma

	; si, segnaliamo errore
	lea	eax, szErrorCreateWindow	; testo dell'errore da visualizzare nella MessageBox
	jmp	WinMain_Error

	; nessun errore, continuiamo con il programma
CreateWindowEx_OK:
	mov	g_hMainWnd, eax					; memorizziamo handle della finestra	

	; mostriamo la finestra
	invoke	ShowWindow, g_hMainWnd, nCmdShow
	invoke	UpdateWindow, g_hMainWnd
	
	;ciclo principale messaggi
	.WHILE TRUE
		invoke	GetMessage, ADDR msg, NULL, 0, 0	; preleva messaggio
		.BREAK .IF (!eax)							; se no eax interrompi ed esci
		invoke	TranslateMessage, ADDR msg		; traduce messaggio
		invoke	DispatchMessage, ADDR msg		; smista messaggio
	.ENDW

	mov	eax, msg.wParam					; restituiamo messaggio paramentri ultimo messaggio ricevuto
WinMain_Exit:
	ret

WinMain_Error:
	; quando siamo qui, in eax c'è l'offset del messggio da inserire nella MessageBox e poi prosegue all'uscita
	invoke	MessageBox, NULL, eax, offset szCaptionError, MB_OK
	mov	eax, -1				; restituiamo errore "massimo"

	; dopo aver preso visione del messaggio d'errore irreversibile usciamo dal programma
	jmp	WinMain_Exit
WinMain	endp