; questo file contiene le costanti 


; valori costanti utili al programma funzionanti come macro

.data

; dati costanti memorizzati in memoria per il funzionamento del programma

szMainClassName 	db "ASMGRAPH",0		; Nome della classe finestra principale
szAppName		db "AsmGraph",0		; Nome dell'applicazione

;
; Messaggi di Intestazione (caption) per Message Box
;
szCaptionWarning	db "ATTENZIONE",0
szCaptionError		db "ERRORE",0

;
; Messaggi di errore per Message Box
;
szErrorRegisterWindowMainClass	db "Impossibile registrare la classe della finestra.", 0ah, 0dh, "Programma terminato",0
szErrorCreateWindow		db "Impossibile creare la finesta.", 0ah, 0dh, "Programma terminato",0

