# Caratteri a tratti: come creare o modificare i caratteri

Questa guida spiega come sono fatti i caratteri disegnati da `DrawCharStroke` e `DrawStringStroke`, e come aggiungerne di nuovi (per esempio le lettere minuscole) o ritoccare quelli esistenti.

> *English version: coming soon.*

Il metodo "a tratti" (stroke) descrive ogni carattere come una serie di segmenti, come i tratti di una penna. Ogni segmento viene tracciato con `DrawLineDDA`, e moltiplicando le coordinate per un fattore di scala il carattere si ingrandisce.

I file coinvolti sono:

| File | Contenuto |
|---|---|
| `inc/StrokeFont.inc` | Costanti, disegni dei caratteri e tabella dei caratteri |
| `src/Text.asm` | `DrawCharStroke` e `DrawStringStroke` |
| `src/TestStroke.asm` | Procedura di prova |

## La griglia

Ogni carattere è disegnato su una griglia di punti:

- **x** da 0 a 4, **y** da 0 a 6;
- **y cresce verso il basso**, come lo schermo;
- l'origine (0,0) è l'angolo **in alto a sinistra** della cella;
- il carattere è largo 4 unità, e l'avanzamento fino al carattere successivo è di 6 unità (`SF_ADVANCE`), quindi restano 2 unità di spazio.

```
  x: 0 1 2 3 4
y=0  . . . . .
y=1  . . . . .
y=2  . . . . .
y=3  . . . . .      (le unità sono moltiplicate per la scala:
y=4  . . . . .       a scala 3, un'unità vale 3 pixel)
y=5  . . . . .
y=6  . . . . .
```

## Il formato dei dati

I dati di un carattere sono una sequenza di **punti**, ciascuno di due byte: `x, y`. Due byte speciali controllano la "penna":

| Marcatore | Valore | Significato |
|---|---|---|
| `SF_PENUP` | `0FEh` | solleva la penna: il punto che segue è uno spostamento, senza tracciare |
| `SF_END` | `0FFh` | fine dei dati del carattere |

Le regole di lettura sono queste:

1. il **primo punto** di ogni tratto è solo uno spostamento della penna;
2. ogni punto **successivo** traccia un segmento dal punto precedente;
3. dopo un `SF_PENUP` il punto seguente è di nuovo uno spostamento;
4. `SF_END` termina il carattere.

Le coordinate devono quindi stare tra **0 e 253**, perché `0FEh` e `0FFh` sono riservati ai marcatori.

### Esempio: la lettera "H"

```asm
G_H     db 0,0, 0,6, SF_PENUP       ; asta sinistra
        db 4,0, 4,6, SF_PENUP       ; asta destra
        db 0,3, 4,3, SF_END         ; traversa
```

Tre tratti separati: dopo ogni `SF_PENUP` la penna si sposta senza disegnare. Un carattere continuo, come la "L", ha un solo tratto:

```asm
G_L     db 0,0, 0,6, 4,6, SF_END    ; dall'alto in basso, poi verso destra
```

### Un carattere vuoto, e un punto

- Lo **spazio** non ha punti: `G_Space db SF_END`.
- Un **punto isolato** non si può disegnare con un solo punto (il primo punto è solo uno spostamento) né con due punti coincidenti (a ogni scala verrebbe un solo pixel, invisibile quando si ingrandisce). Si usa un **segmento corto**, come per il punto fermo:

```asm
G_Dot   db 2,5, 2,6, SF_END
```

## La tabella dei caratteri

`StrokeGlyphTable` è una tabella di indirizzi: l'elemento numero *n* punta ai dati del carattere con codice ASCII `SF_FIRST_CHAR + n`, cioè `32 + n`.

```asm
StrokeGlyphTable    dd OFFSET G_Space   ; 32 ' '
                    dd OFFSET G_Excl    ; 33 '!'
                    dd OFFSET G_Missing ; 34 '"'
                    ...
```

- I caratteri non definiti puntano a `G_Missing`, un riquadro, così si vede subito che manca qualcosa.
- Un codice fuori dalla tabella (minore di 32 o maggiore dell'ultimo) viene disegnato come `G_Missing`.
- `SF_GLYPH_COUNT` è il numero di elementi della tabella. Oggi è 59: dal codice 32 (spazio) al 90 (`Z`).

## Come aggiungere le minuscole (esempio completo)

Oggi `DrawStringStroke` disegna le minuscole come maiuscole. Per avere minuscole vere servono cinque passi.

### 1. Disegna i caratteri

Per le minuscole conviene usare queste linee guida sulla stessa griglia:

| Linea | y |
|---|---|
| Altezza delle aste alte (b, d, f, h, k, l, t) | 0 |
| Altezza delle lettere piccole (a, c, e, o...) | 2 |
| Linea di base | 6 |
| Discendenti (g, j, p, q, y) | fino a 8 |

Due esempi, la "o" e la "i":

```asm
; 'o'
G_o     db 1,2, 3,2, 4,3, 4,5, 3,6, 1,6, 0,5, 0,3, 1,2, SF_END

; 'i'
G_i     db 2,2, 2,6, SF_PENUP
        db 2,0, 2,1, SF_END         ; il puntino
```

Metti questi dati in `inc/StrokeFont.inc`, nella sezione `.data`, insieme agli altri.

### 2. Allarga la tabella fino al codice di `z` (122)

Dopo l'elemento della `Z` (codice 90) aggiungi gli elementi per i codici da 91 a 122. I sei caratteri tra la `Z` e la `a` (`[ \ ] ^ _` e l'apice rovesciato) non sono definiti:

```asm
        dd OFFSET G_Missing   ; 91 '['
        dd OFFSET G_Missing   ; 92 '\'
        dd OFFSET G_Missing   ; 93 ']'
        dd OFFSET G_Missing   ; 94 '^'
        dd OFFSET G_Missing   ; 95 '_'
        dd OFFSET G_Missing   ; 96 '`'
        dd OFFSET G_A         ; 97 'a'  provvisorio: usa la maiuscola
        dd OFFSET G_B         ; 98 'b'  provvisorio: usa la maiuscola
        ...
        dd OFFSET G_i         ; 105 'i'
        ...
        dd OFFSET G_o         ; 111 'o'
        ...
        dd OFFSET G_Z         ; 122 'z'  provvisorio: usa la maiuscola
```

Finché una minuscola non è disegnata, l'elemento punta alla **maiuscola corrispondente**: il testo resta leggibile e si migliora un carattere alla volta.

### 3. Aggiorna il numero di elementi

```asm
SF_GLYPH_COUNT  equ 91      ; da 32 (spazio) a 122 ('z')
```

### 4. Togli la conversione in `DrawStringStroke`

In `src/Text.asm`, elimina (o commenta) questo blocco, che trasformava le minuscole in maiuscole:

```asm
        .IF eax >= 'a' && eax <= 'z'
            sub     eax, 32                     ; minuscola -> maiuscola
        .ENDIF
```

### 5. Provalo

Aggiungi una stringa in `src/TestStroke.asm` che usi i nuovi caratteri, per esempio `"oi Oi oOiI"`, e controlla che ogni carattere sia come l'hai disegnato.

> **Nota sui discendenti.** I caratteri che scendono sotto la linea di base (y fino a 8) escono dalla cella alta 6. Per scrivere più righe, lascia una distanza verticale di almeno 9 unità per scala tra una riga e l'altra.

## Altri caratteri (lettere accentate, simboli)

Lo stesso schema vale per qualsiasi codice: basta che la tabella arrivi fino a quel codice. Le lettere accentate italiane (à, è, é, ì, ò, ù) hanno codici sopra il 127, che dipendono dalla tabella dei caratteri (code page) con cui viene salvato il sorgente: se il file è in formato ANSI (Windows-1252), `à` vale 224. In quel caso la tabella dovrebbe arrivare fino a 255, con tutti gli elementi intermedi.

## Consigli di disegno

- Con pochi punti si ottiene un buon risultato: le curve si approssimano con angoli smussati, come nella "O" (un ottagono).
- I segmenti orizzontali, verticali e a 45° vengono più puliti, ma `DrawLineDDA` disegna bene anche le altre inclinazioni.
- Evita i `SF_PENUP` inutili: ogni tratto in più è un piccolo costo a ogni carattere disegnato.
- Disegna prima su carta a quadretti, 5 colonne per 7 righe, e poi trascrivi le coordinate.
- Prova il carattere a **scale diverse** (1, 3, 6, 10): difetti invisibili a scala 1 si notano ingranditi.

## Limiti attuali

- Tutti i caratteri hanno lo stesso avanzamento (6 unità): non c'è spaziatura proporzionale, quindi una "i" occupa quanto una "M".
- La scala è un numero intero.
- Esiste una sola tabella di caratteri. Un'idea per il futuro è passare a `DrawCharStroke` il puntatore a una tabella, per poter avere più font.

## Contributi

I disegni del set iniziale sono originali di AsmGraph. Se vuoi contribuire con nuovi caratteri, devono essere opere originali oppure disegni con una licenza compatibile con la EUPL: non copiare tabelle di caratteri da libri o da font protetti da copyright.
