# Van ERD naar Star Schema — fictieve medische data

In dit project laat ik zien hoe ik **van een ERD** (Entity-Relationship Diagram) **een star schema heb ontworpen en geïmplementeerd** in een SQLite-database met **fictieve huisartsgegevens**.  
Vervolgens beantwoord ik een reeks analysevragen met handgeschreven SQL.

## Doel

* **Datamodellering** – het ERD vertalen naar een star schema met één fact-tabel en meerdere dimension-tabellen.  
* **Implementatie** – de tabellen met SQL aanmaken en vullen in SQLite.  
* **Analyse** – concrete business-vragen beantwoorden met efficiënte SQL-query’s.

## Structuur

fictieve-zorgdata-analyse/
│
├── README.md                       # Uitleg en context van het project
│
├── analysevragen/
│   └── analysevragen.sql           # Alle SQL-analysequery’s, gestructureerd en voorzien van commentaar
│
├── database/
│   └── huisarts_patient_star.db    # SQLite-database met geïmplementeerd sterschema en fictieve gegevens
│
└── ontwerp/
    ├── ERD_Patient_Huisarts.pdf               # Entity-Relationship Diagram van het bronsysteem
    └── Sterschem_Patient_Huisarts.jpeg        # Visualisatie van het ontworpen sterschema

## Analyse­vragen

In `analysevragen/analysevragen.sql` staan o.a.:

* Top 5 huisartsen met de meeste unieke patiënten  
* Gemiddeld aantal consulten per patiënt  
* Meest voorgeschreven medicijn per huisarts in 2023  
* Top 5 verzekeraars naar aantal verzekerden

## Visualisaties

In de map `ontwerp/` vind je het **ERD** en het uiteindelijke **star schema** zodat je snel inzicht hebt in de datamodellen.

## Licentie

Dit project staat onder de MIT-licentie.
