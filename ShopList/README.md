# Consegna Finale - Shop List

**Sviluppatore:** Zhu Donglai

## Abstract

Il progetto "Consegna Finale" consiste in un'applicazione Flutter che implementa un sistema di gestione prodotti con database locale SQLite come cache e sincronizzazione tramite API REST con un server mock json-server. L'app permette agli utenti di visualizzare, aggiungere ed eliminare prodotti organizzati per categoria, funzionando sia online che offline. In caso di mancanza di connessione, i dati vengono recuperati dalla cache locale e le operazioni vengono riprogrammate per la successiva sincronizzazione.

---

## 📅 Diario di Progetto

### Step 1 - Setup Iniziale del Progetto
**Data:** 20/04/2026

- Creazione progetto Flutter `ecommerce_cache_app`
- Configurazione dipendenze: sqflite, http, provider, path
- Struttura base delle cartelle lib/
- Implementazione modello Prodotto con toJson/fromJson
- Setup database SQLite con tabella prodotti

### Step 2 - Database Helper e CRUD Locale
**Data:** 27/04/2026

- Implementazione classe DatabaseHelper con singleton pattern
- Metodi: inserisciProdotto, aggiornaProdotto, eliminaProdotto, ottieneTuttiProdotti
- Verifica esistenza prodotto per ID
- Test operazioni CRUD su database locale

### Step 3 - Integrazione REST API
**Data:** 04/05/2026

- Setup server mock json-server con db.json
- Implementazione metodo recuperaDaServer (GET)
- Implementazione metodo creaSuServer (POST)
- Implementazione metodo aggiornaSuServer (PATCH)
- Implementazione metodo eliminaDaServer (DELETE)
- Gestione errori e timeout connessioni

### Step 4 - State Management con Provider
**Data:** 07/05/2026

- Creazione ProdottoNotifier con ChangeNotifier
- Implementazione sincronizzaConServer() per caricamento iniziale
- Implementazione sincronizzaDBConServer() per aggiornamento cache
- Aggiunta metodo init() per avvio automatico sincronizzazione
- Gestione stato: staCaricando, serverRaggiungibile
- Notifica listener dopo ogni modifica dati

### Step 5 - UI Iniziale e Funzionalità Base
**Data:** 08/05/2026

- Creazione PaginaPrincipale con Scaffold completo
- Implementazione AppBar con indicatore stato connessione
- Lista prodotti con ListView.builder
- CardProdotto espandibile per modifica quantità
- Dialog per aggiunta nuovo prodotto con form
- Dismissible per eliminazione swipe

### Step 6 - Filtri e Ricerca
**Data:** 10/05/2026

- Aggiunta barra di ricerca per nome prodotto
- Implementazione filtro "solo in evidenza"
- Gestione stato filtri nel ProdottoNotifier
- UI drawer con opzioni filtro e tema scuro/chiaro
- Badge indicatore prodotti in cache vs server

### Step 7 - Ristrutturazione UI Completa
**Data:** 11/05/2026

- Rimozione espansione card e barra di ricerca
- Implementazione griglia prodotti (GridView) 2 colonne
- Aggiunta TabBar per filtro categorie (Tutti, Elettronica, Abbigliamento, Casa, Sport)
- Card semplificate con icona categoria e pulsante X rimozione
- Banner arancione modalità offline
- Drawer pulito con solo tema scuro/chiaro
- FAB singolo per aggiunta prodotto

### Step 8 - Ottimizzazione e Finalizzazione
**Data:** 13/05/2026

- Aggiunto init() nel notifier per caricamento automatico prodotti
- Rimosso drawer, aggiunto pulsante refresh in AppBar
- Corretto errore TabController con DefaultTabController
- Gestione errori CRUD offline (aggiungi/rimuovi senza server)
- Colori e icone categorizzazione prodotti
- Testing completo funzionalità online/offline
- Documentazione progetto README.md

---



## ⚙️ Configurazione Server

Il server mock utilizza [json-server](https://github.com/typicode/json-server).


## 🗄️ Database SQLite (Cache Locale)

Il database viene creato automaticamente al primo avvio dell'app:

- **Nome file**: `ecommerce.db`
- **Tabella**: `prodotti`
- **Colonne**:
  - `id` (TEXT, PRIMARY KEY)
  - `nome` (TEXT)
  - `prezzo` (REAL)
  - `quantitaDisponibile` (INTEGER)
  - `categoria` (TEXT)

## 🔄 Logica di Sincronizzazione

### Quando l'app si avvia:
1. Il `ProdottoNotifier` chiama automaticamente `init()` che esegue `sincronizzaConServer()`
2. Prova a connettersi al server (`GET /prodotti`)
3. Se il server è raggiungibile → carica i dati dal server e sincronizza con la cache
4. Se il server non è raggiungibile → carica i dati dalla cache locale
