.code

;
; DrawLineDDA - disegna un segmento con l'algoritmo DDA (digital differential analyzer)
;
; Si parte dal primo estremo e, passo dopo passo, si somma un incremento costante a X e a Y,
; accendendo a ogni passo il pixel piu' vicino. Il numero di passi e' pari alla
; distanza maggiore tra le due coordinate, piu' uno.
;
; Le coordinate sono in virgola fissa 16.16: i 16 bit alti sono la parte intera,
; i 16 bit bassi la parte frazionaria (1.0 = 10000h, 0.5 = 8000h).
;
; In: pFB     = puntatore alla struttura FRAMEBUFFER
;     x1, y1  = primo estremo
;     x2, y2  = secondo estremo
;     dwColor = colore nel formato 00RRGGBB
;
; Le coordinate devono stare tra -32768 e 32767 (altrimenti lo shift di 16 bit trabocca).
; Le parti del segmento fuori dal buffer vengono scartate da PutPixel.
;
DrawLineDDA proc uses ebx esi edi pFB:DWORD, x1:DWORD, y1:DWORD, x2:DWORD, y2:DWORD, dwColor:DWORD
    LOCAL deltaX:SDWORD         ; spostamento totale in x
    LOCAL deltaY:SDWORD         ; spostamento totale in y
    LOCAL steps:DWORD           ; numero di passi
    LOCAL dxStep:SDWORD         ; incremento di x a ogni passo (16.16)
    LOCAL dyStep:SDWORD         ; incremento di y a ogni passo (16.16)

    ; spostamento totale lungo i due assi
    mov     eax, x2
    sub     eax, x1
    mov     deltaX, eax
    mov     eax, y2
    sub     eax, y1
    mov     deltaY, eax

    ; passi = max(|deltaX|, |deltaY|) + 1
    mov     eax, deltaX
    cdq
    xor     eax, edx
    sub     eax, edx            ; EAX = |deltaX|
    mov     ecx, eax
    mov     eax, deltaY
    cdq
    xor     eax, edx
    sub     eax, edx            ; EAX = |deltaY|
    .IF eax < ecx
        mov     eax, ecx        ; EAX = il maggiore dei due
    .ENDIF
    inc     eax
    mov     steps, eax

    ; incremento per passo = spostamento totale / passi (in 16.16, divisione con segno)
    mov     eax, deltaX
    shl     eax, 16
    cdq
    idiv    steps
    mov     dxStep, eax
    mov     eax, deltaY
    shl     eax, 16
    cdq
    idiv    steps
    mov     dyStep, eax

    ; posizione iniziale = primo estremo + 0.5, cosi' il troncamento arrotonda al pixel piu' vicino
    mov     esi, x1
    shl     esi, 16
    add     esi, 8000h          ; ESI = x corrente
    mov     edi, y1
    shl     edi, 16
    add     edi, 8000h          ; EDI = y corrente

    mov     ebx, steps          ; EBX = passi ancora da fare
    .WHILE ebx != 0
        ; sar = shift aritmetico: prende la parte intera, arrotondando per difetto
        mov     eax, esi
        sar     eax, 16
        mov     edx, edi
        sar     edx, 16
        invoke  PutPixel, pFB, eax, edx, dwColor

        add     esi, dxStep     ; avanza al punto successivo
        add     edi, dyStep
        dec     ebx
    .ENDW

    ; l'ultimo punto, raggiunto dopo l'ultimo incremento
    mov     eax, esi
    sar     eax, 16
    mov     edx, edi
    sar     edx, 16
    invoke  PutPixel, pFB, eax, edx, dwColor

    ret
DrawLineDDA endp
