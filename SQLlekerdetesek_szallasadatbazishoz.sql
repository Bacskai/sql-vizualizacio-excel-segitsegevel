/*
Hozzon l�tre 3 lek�rdez�st, amelyekn�l a GROUP BY speci�lis lehet�s�geit haszn�lja
*/
-- ROLLUP
SELECT f.szoba_fk, v.nev,count(*)
FROM Foglalas f
INNER JOIN Vendeg v on f.ugyfel_fk=v.usernev
GROUP BY ROLLUP(f.szoba_fk, v.nev) 

-- CUBE
SELECT szallas_fk, szoba_szama, SUM(ferohely) as '�sszeg'
FROM szoba
GROUP BY CUBE (szallas_fk, szoba_szama)

-- GROUPING SETS
SELECT szallas_fk, szoba_szama, SUM(ferohely) as '�sszeg'
FROM szoba
GROUP BY grouping sets (szallas_fk, szoba_szama),szallas_fk

/*
Hozzon l�tre 2 lek�rdez�st, amelyekn�l analitikus f�ggv�nyeket haszn�l
*/
-- ROW_NUMBER()
SELECT ROW_NUMBER()
OVER(PARTITION BY klimas
ORDER BY szallas_fk)
AS 'kl�m�s/nem kl�m�s szoba sorsz�mai'
,
*
FROM szoba

-- DENSE_RANK
SELECT szallas_id, szallas_nev, hely, csillagok_szama,
DENSE_RANK() OVER (PARTITION BY hely
ORDER BY csillagok_szama DESC)
AS 'csillagok sz�ma szerinti helyez�s hely szerint'
FROM szallashely


/*
B�v�tse az adatb�zist legal�bb 1 �j oszloppal (vagy egy �j t�bl�val) �gy, 
hogy annak adatt�pusa valamely tanult speci�lis adatt�pus (pl. XML) legyen, 
majd t�ltse fel tesztadatokkal (import�l�ssal vagy manu�lisan). Ezut�n hozzon l�tre 1 olyan lek�rdez�st, 
amelyben az �j oszlop is szerepel. Amennyiben nincs jogosults�ga az �j oszlop/t�bla l�trehoz�s�ra, 
akkor hozzon l�tre egy ideiglenes t�bl�t, �s azzal dolgozzon!
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
    '<SZALLAS ID="1"> <SZALLAS_NEV> S�ba-H�z </SZALLAS_NEV> <HELY> Balaton-d�l </HELY>  </SZALLAS> '
);

SELECT Szallas_adat.value('(/SZALLAS/SZALLAS_NEV)[1]','nvarchar(max)')AS Nev,
Szallas_adat.value('(/SZALLAS/HELY)[1]','nvarchar(max)')AS Hely
FROM dbo.Hirdetnivalo_Szallas;