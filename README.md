# AsmGraph

Programma e libreria di **computer grafica scritti interamente in Assembly x86 (MASM32)** per Windows.

Il progetto nasce come studio dei classici testi di computer graphics, traducendo in assembly gli algoritmi che vi sono descritti, un pezzo alla volta, fino a costruire le basi di un piccolo software di modellazione e rendering 3D.

> **Stato del progetto:** fase iniziale. Al momento è presente lo scheletro di un'applicazione Win32 (registrazione classe, creazione finestra, ciclo dei messaggi, chiusura corretta).

## Obiettivi

1. **Livello base 2D** (ispirato a *Computer Graphics: corso di programmazione*, S. Harrington, McGraw-Hill)
   - framebuffer e `PutPixel`
   - linee (Bresenham), cerchi, ellissi
   - clipping
   - riempimento di poligoni
   - trasformazioni 2D con matrici omogenee
2. **Livello 3D** (ispirato al testo di computer graphics di A. e M. Watt)
   - modellazione e trasformazioni 3D
   - proiezioni
   - rimozione delle superfici nascoste
   - illuminazione e ombreggiatura
3. **Applicazione**: un visualizzatore/editor 3D di base costruito sopra la libreria.

## Requisiti

- Windows
- [MASM32 SDK](http://www.masm32.com/) installato in `c:\masm32`

## Compilazione

Dalla cartella del progetto, in un prompt dei comandi:

```bat
make.bat
```

Lo script esegue tre passi:

1. `rc` compila le risorse (`res\resource.rc`)
2. `ml /c /coff /Zi` assembla il sorgente principale
3. `link /SUBSYSTEM:WINDOWS` collega eseguibile e risorse

Se MASM32 si trova in un percorso diverso da `c:\masm32`, modifica i percorsi in `make.bat` e nei file `inc\CommonHeader.inc` e `inc\CommonLib.inc`.

## Struttura delle cartelle

```
AsmGraph/
├── AsmGraph.asm        punto d'ingresso, include tutti gli altri sorgenti
├── make.bat            script di compilazione
├── inc/                header comuni
│   ├── CommonHeader.inc    include delle API Windows
│   ├── CommonLib.inc       librerie da collegare
│   ├── Proto.inc           prototipi delle funzioni
│   ├── constants.inc       costanti e stringhe
│   ├── structs.inc         strutture dati
│   └── globals.inc         variabili globali
├── src/                sorgenti
│   ├── WinMain.asm                 inizializzazione e ciclo dei messaggi
│   ├── MainWndProc.asm             gestione dei messaggi della finestra
│   └── RegisterWindowMainClass.asm registrazione della classe finestra
└── res/                risorse (icone, menu, dialog)
```

Il progetto è compilato come **unità unica**: `AsmGraph.asm` include gli altri file con `include`, quindi basta assemblare un solo file.

## Metodo di sviluppo

Sviluppo **incrementale**: ogni funzione viene scritta e provata da sola prima di passare alla successiva. Ogni piccolo passo è un commit.

## Roadmap

- [x] Scheletro finestra Win32 con chiusura corretta
- [ ] Framebuffer (DIB section) e `PutPixel`
- [ ] Linee (Bresenham)
- [ ] Cerchi ed ellissi
- [ ] Clipping
- [ ] Riempimento poligoni
- [ ] Trasformazioni 2D
- [ ] Passaggio al 3D

## Licenza

Distribuito con licenza [EUPL v. 1.2](https://eupl.eu/1.2/it) (European Union Public Licence). Vedi il file [LICENSE](LICENSE).

Licensed under the EUPL