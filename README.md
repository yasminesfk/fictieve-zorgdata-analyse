# Van ERD naar Star Schema — fictieve medische data

In dit project toon ik hoe ik vanuit een ERD (Entity-Relationship Diagram) een star schema heb ontworpen en geïmplementeerd in een SQLite-database met fictieve huisarts- en patiëntgegevens.  
Vervolgens beantwoord ik diverse analysevragen met SQL-query’s.

## Doel van het project

- **Datamodellering** – Het ERD vertalen naar een star schema met één fact-tabel en meerdere dimension-tabellen.
- **Implementatie** – De tabellen aanmaken en vullen met SQL in SQLite.
- **Analyse** – Concrete vragen beantwoorden met efficiënte en leesbare SQL-query’s.

## Projectstructuur

```plaintext
fictieve-zorgdata-analyse/
│
├── README.md                     # Uitleg en context van het project
│
├── analysevragen/
│   └── analysevragen.sql         # Alle SQL-analysequery’s, gestructureerd en voorzien van commentaar
│
├── database/
│   └── huisarts_patient_star.db  # SQLite-database met sterschema en fictieve gegevens
│
└── ontwerp/
    ├── ERD_Patient_Huisarts.pdf         # Entity-Relationship Diagram van het bronsysteem
    └── Sterschem_Patient_Huisarts.jpeg  # Visualisatie van het ontworpen sterschema
```
## Analysevragen

In het bestand `analysevragen/analysevragen.sql` beantwoord ik onder andere:

- Top 5 huisartsen met de meeste unieke patiënten
- Gemiddeld aantal consulten per patiënt
- Meest voorgeschreven medicijn per huisarts in 2023
- Top 5 verzekeraars naar aantal verzekerden
- Diagnose- en medicijnstatistieken per jaar of per huisarts

## Visualisaties

In de map `ontwerp/` vind je:

- Het originele **ERD** van het bronsysteem
- Het definitieve **sterschema** dat ik heb ontworpen voor analyse

## Instructies om zelf uit te voeren

Wil je dit project zelf verkennen in **DB Browser for SQLite** of een andere tool? Volg deze stappen:

1. Download of clone deze repository.
2. Open het bestand `huisarts_patient_star.db` via een SQLite-tool zoals:
   - [DB Browser for SQLite](https://sqlitebrowser.org)
3. Navigeer naar het tabblad **"SQL uitvoeren"** (of "Execute SQL").
4. Open het bestand `analysevragen/analysevragen.sql`.
5. Voer de query’s uit om de resultaten te bekijken.

> De database bevat **volledig fictieve gegevens**, enkel bedoeld voor demonstratie van datamodellering en analyse.

## Licentie

Dit project valt onder de [MIT-licentie](https://opensource.org/licenses/MIT).
