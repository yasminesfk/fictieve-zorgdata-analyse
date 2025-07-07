-- Vraag 1:  Wat is de top 5 van huisartsen (naam) die de meeste unieke patiënten op consult hadden? 
SELECT dh.Naam AS HuisartsNaam, COUNT(DISTINCT ft.PatientID) AS UniekePatienten 
FROM FactTable ft 
JOIN DimHuisarts dh ON ft.HuisartsID = dh.HuisartsID 
GROUP BY dh.Naam 
ORDER BY UniekePatienten DESC 
LIMIT 5; 

-- Vraag 2: Wat is de top 5 van huisartsen (naam) die de meeste unieke patiënten op consult hadden in de zomer van 2024? 
SELECT dh.Naam AS HuisartsNaam, COUNT(DISTINCT ft.PatientID) AS UniekePatienten 
FROM FactTable ft 
JOIN DimHuisarts dh ON ft.HuisartsID = dh.HuisartsID 
JOIN DimTijd dt ON ft.DatumID = dt.Datum 
WHERE dt.Jaar = 2024 AND dt.Maand IN (6, 7, 8) 
GROUP BY dh.Naam 
ORDER BY UniekePatienten DESC 
LIMIT 5; 

-- Vraag 3: Wat is de top 5 van praktijken (naam) die de meeste unieke patiënten op consult hadden in 2025? 
SELECT dh.Praktijk AS PraktijkNaam, COUNT(DISTINCT ft.PatientID) AS UniekePatienten 
FROM FactTable ft 
JOIN DimHuisarts dh ON ft.HuisartsID = dh.HuisartsID 
JOIN DimTijd dt ON ft.DatumID = dt.Datum 
WHERE dt.Jaar = 2025 
GROUP BY dh.Praktijk 
ORDER BY UniekePatienten DESC 
LIMIT 5; 

-- Vraag 4: Wat is het gemiddeld aantal consulten dat een patiënt heeft? 
SELECT  
    ROUND(CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT PatientID), 2) AS GemiddeldAantalConsultenPerPatient 
FROM FactTable; 

-- Vraag 5: Wat is het gemiddeld aantal eerste consulten dat een patiënt heeft? 
SELECT  
    ROUND(CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT PatientID), 2) AS GemiddeldAantalEersteConsultenPerPatient 
FROM FactTable 
WHERE TypeConsultID IN (2, 5); 

-- Vraag 6: Wat is de meest voorkomende diagnose bij het eerste consult? 
SELECT dd.Omschrijving AS Diagnose, COUNT(*) AS Aantal 
FROM FactTable ft 
JOIN DimDiagnose dd ON ft.DiagnoseID = dd.DiagnoseID 
WHERE ft.TypeConsultID IN (2, 5) 
GROUP BY dd.Omschrijving 
ORDER BY Aantal DESC 
LIMIT 1; 

-- Vraag 7: Wat is de top 5 verzekeraars (naam) met het hoogste aantal verzekerden? 
SELECT dv.Naam AS VerzekeraarNaam, COUNT(*) AS AantalVerzekerden 
FROM DimPatient dp 
JOIN DimVerzekeraar dv ON dp.VerzekeraarID = dv.VerzekeraarID 
GROUP BY dv.Naam 
ORDER BY AantalVerzekerden DESC 
LIMIT 5; 

-- Vraag 8: Wat is de top 5 verzekeraars (naam) met het hoogst aantal consulten van hun hoofdverzekeringnemers? 
SELECT dv.Naam AS VerzekeraarNaam, COUNT(*) AS AantalConsulten 
FROM FactTable ft 
JOIN DimPatient dp ON ft.PatientID = dp.PatientID 
JOIN DimVerzekeraar dv ON dp.VerzekeraarID = dv.VerzekeraarID 
GROUP BY dv.Naam 
ORDER BY AantalConsulten DESC 
LIMIT 5; 

-- Vraag 9: Welke diagnose komt het meest voor per verzekeraar? 
WITH DiagnoseTellingen AS ( 
    SELECT  
        dv.Naam AS Verzekeraar, 
        dd.Omschrijving AS Diagnose, 
        COUNT(*) AS Aantal 
    FROM FactTable ft 
    JOIN DimPatient dp ON ft.PatientID = dp.PatientID 
    JOIN DimVerzekeraar dv ON dp.VerzekeraarID = dv.VerzekeraarID 
    JOIN DimDiagnose dd ON ft.DiagnoseID = dd.DiagnoseID 
    GROUP BY dv.Naam, dd.Omschrijving 
), 
TopDiagnoses AS ( 
    SELECT  
        Verzekeraar, 
        Diagnose, 
        Aantal 
    FROM DiagnoseTellingen dt 
    WHERE Aantal = ( 
        SELECT MAX(Aantal) 
        FROM DiagnoseTellingen 
        WHERE Verzekeraar = dt.Verzekeraar 
    ) 
) 
SELECT * FROM TopDiagnoses 
ORDER BY Verzekeraar; 

-- Vraag 10: Welke medicijnen worden het meest voorgeschreven? 
SELECT dm.Naam AS MedicijnNaam, COUNT(*) AS AantalVoorschriften 
FROM FactTable ft 
JOIN DimMedicijn dm ON ft.MedicijnID = dm.MedicijnID 
GROUP BY dm.Naam 
ORDER BY AantalVoorschriften DESC 
LIMIT 10;

-- Vraag 11: Welk medicijn wordt per huisarts het meest voorgeschreven in 2023? 
WITH MedicijnTellingen AS ( 
    SELECT  
        dh.Naam AS HuisartsNaam, 
        dm.Naam AS MedicijnNaam, 
        COUNT(*) AS AantalVoorschriften 
    FROM FactTable ft 
    JOIN DimHuisarts dh ON ft.HuisartsID = dh.HuisartsID 
    JOIN DimMedicijn dm ON ft.MedicijnID = dm.MedicijnID 
    JOIN DimTijd dt ON ft.DatumID = dt.Datum 
    WHERE dt.Jaar = 2023 
    GROUP BY dh.Naam, dm.Naam 
), 
TopMedicijnenPerHuisarts AS ( 
    SELECT  
        HuisartsNaam, 
        MedicijnNaam, 
        AantalVoorschriften, 
        ROW_NUMBER() OVER (PARTITION BY HuisartsNaam ORDER BY AantalVoorschriften DESC) AS rn 
    FROM MedicijnTellingen 
) 
SELECT HuisartsNaam, MedicijnNaam, AantalVoorschriften 
FROM TopMedicijnenPerHuisarts 
WHERE rn = 1 
ORDER BY HuisartsNaam; 

-- Vraag 12: Geef per diagnose het meest voorgeschreven medicijn in 2024? 
WITH MedicijnPerDiagnose AS ( 
    SELECT  
        dd.Omschrijving AS Diagnose, 
        dm.Naam AS Medicijn, 
        COUNT(*) AS Aantal, 
        ROW_NUMBER() OVER ( 
            PARTITION BY dd.Omschrijving  
            ORDER BY COUNT(*) DESC 
        ) AS rn 
    FROM FactTable ft 
    JOIN DimDiagnose dd ON ft.DiagnoseID = dd.DiagnoseID 
    JOIN DimMedicijn dm ON ft.MedicijnID = dm.MedicijnID 
    JOIN DimTijd dt ON ft.DatumID = dt.Datum 
    WHERE dt.Jaar = 2024 
    GROUP BY dd.Omschrijving, dm.Naam 
) 
SELECT Diagnose, Medicijn, Aantal 
FROM MedicijnPerDiagnose 
WHERE rn = 1 
ORDER BY Diagnose; 

-- Vraag 13: Op basis van welke diagnose wordt het hoogst aantal routine controles gedaan? 
SELECT dd.Omschrijving AS Diagnose, COUNT(*) AS AantalRoutineControles 
FROM FactTable ft 
JOIN DimDiagnose dd ON ft.DiagnoseID = dd.DiagnoseID 
WHERE ft.RoutineControleID != 0 
GROUP BY dd.Omschrijving 
ORDER BY AantalRoutineControles DESC 
LIMIT 1; 

-- Vraag 14: Op basis van welke diagnose wordt het hoogst aantal volgconsulten gedaan? 
SELECT ds.Status AS DiagnoseStatus, COUNT(*) AS AantalVolgconsulten 
FROM FactTable ft 
JOIN DimDiagnoseStatus ds ON ft.DiagnoseStatusID = ds.DiagnoseStatusID 
WHERE ft.TypeConsultID IN (3, 6) 
GROUP BY ds.Status 
ORDER BY AantalVolgconsulten DESC 
LIMIT 1; 
