# Programmi di prova

Eseguibili già compilati per vedere i risultati senza installare nulla. Ogni programma è lo stesso AsmGraph, con un disegno di prova diverso attivo all'avvio. I test sono numerati in ordine cronologico di creazione: `test_N_nome.exe`.

| Test | Eseguibile | Cosa mostra | Funzione di prova (in `src/TestDraw.asm`) |
|---|---|---|---|
| 1 | `test_1_pixel.exe` | Due gradienti 256x256 identici: il primo disegnato con `PutPixel`, il secondo copiato leggendo il primo con `ReadPixel` | `TestDraw` |
| 2 | `test_2_lines.exe` | Una raggiera di linee dal centro in tutte le direzioni, un punto singolo e due linee che escono dal buffer (`DrawLineDDA`) | `TestLines` |
| 2 | `test_3_stroke.exe` | Una serie di stringhe di varie dimensioni disegnate con dei tratti usando `DrawLineDDA` per ogni tratto | `TestStroke ` |

## Come riprodurli

1. Apri `src/MainWndProc.asm` e cerca `WM_CREATE`. Subito dopo `ClearBuffer` ci sono le chiamate di prova, tutte commentate. Ognuna riporta il numero del test e il nome dell'eseguibile, per esempio:

   ```asm
   ;	invoke TestLines, ADDR g_fb	; richiama i test disegno linee	[Test   2] test_2_lines.exe
   ```

2. Togli il `;` davanti a **una sola** chiamata (quella del test che vuoi vedere).
3. Compila con `make.bat`.
4. Il risultato è `AsmGraph.exe`: copialo qui in `bin` con il nome indicato nel commento.

## Aggiungere un nuovo test

1. Scrivi la procedura di prova in `src/TestDraw.asm` e il suo prototipo in `inc/Proto.inc`.
2. In `WM_CREATE` aggiungi la chiamata, commentata, con il tag `[Test N] test_N_nome.exe`.
3. Aggiungi una riga alla tabella qui sopra.

> Gli eseguibili non sono firmati digitalmente: Windows SmartScreen o l'antivirus potrebbero mostrare un avviso.
