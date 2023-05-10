/*
Hozzon létre 3 lekérdezést, amelyeknél a GROUP BY speciális lehetõségeit használja
*/
-- ROLLUP
SELECT f.szoba_fk, v.nev,count(*)
FROM Foglalas f
INNER JOIN Vendeg v on f.ugyfel_fk=v.usernev
GROUP BY ROLLUP(f.szoba_fk, v.nev) 

-- CUBE
SELECT szallas_fk, szoba_szama, SUM(ferohely) as 'összeg'
FROM szoba
GROUP BY CUBE (szallas_fk, szoba_szama)

-- GROUPING SETS
SELECT szallas_fk, szoba_szama, SUM(ferohely) as 'összeg'
FROM szoba
GROUP BY grouping sets (szallas_fk, szoba_szama),szallas_fk

/*
Hozzon létre 2 lekérdezést, amelyeknél analitikus függvényeket használ
*/
-- ROW_NUMBER()
SELECT ROW_NUMBER()
OVER(PARTITION BY klimas
ORDER BY szallas_fk)
AS 'klímás/nem klímás szoba sorszámai'
,
*
FROM szoba

-- DENSE_RANK
SELECT szallas_id, szallas_nev, hely, csillagok_szama,
DENSE_RANK() OVER (PARTITION BY hely
ORDER BY csillagok_szama DESC)
AS 'csillagok száma szerinti helyezés hely szerint'
FROM szallashely


/*
Bõvítse az adatbázist legalább 1 új oszloppal (vagy egy új táblával) úgy, 
hogy annak adattípusa valamely tanult speciális adattípus (pl. XML) legyen, 
majd töltse fel tesztadatokkal (importálással vagy manuálisan). Ezután hozzon létre 1 olyan lekérdezést, 
amelyben az új oszlop is szerepel. Amennyiben nincs jogosultsága az új oszlop/tábla létrehozására, 
akkor hozzon létre egy ideiglenes táblát, és azzal dolgozzon!
*/

CREATE TABLE Hirdetnivalo_Szallas
(
        Id int not null PRIMARY KEY,
        Szallas_adat XML NOT NULL
);

INSERT INTO Hirdetnivalo_Szallas
(
    Id,
    Szallas_adat
)
VALUES
(
    1,
    '<SZALLAS ID="1"> <SZALLAS_NEV> Sába-Ház </SZALLAS_NEV> <HELY> Balaton-dél </HELY>  </SZALLAS> '
);

SELECT Szallas_adat.value('(/SZALLAS/SZALLAS_NEV)[1]','nvarchar(max)')AS Nev,
Szallas_adat.value('(/SZALLAS/HELY)[1]','nvarchar(max)')AS Hely
FROM dbo.Hirdetnivalo_Szallas;