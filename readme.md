## AndmebaasidLOGITpv24
admebaaside haldusega seotud sql kood ja konspektid

## Põhimõisted
- Andmebaasi haldussüsteemid - tarkvara, millega abil saab luua andmebaas (mariaDB - XAMPP, SQL Server - SQL Server Management Studio)
- Andmebaas - struktureeritud andmete kogum
- Tabel - olem - сущности
- Veerg = väli - поле
- Rida = kirje - запись
- Primaarne võti - primary key -PK- veerg, unikaalse identifikatooriga (tavaliselt nimetus id)
- Välisvõti (võõrvõti) - foreign key - FK - veerg, mis loob seose teise tabeli primaarne võtmega

## SQL - structured quary language - struktureeritud päringu keel
  - päring - запрос
  - <img width="427" height="339" alt="image" src="https://github.com/user-attachments/assets/e51d1e1c-af45-4551-81ff-fd6b12467944" />
  1. DDL - Data Definition Language
  2. DML - Data Manipulation Language

     ## Piirangud - органичения - CONSTRAINT (5)
     1. PRIMARY KEY
     2. NOT NULL
     3. CHECK - valik
     4.
     ## Andmetüübid
     ```
     1. int, smallint, decimal(5,2) - numbrilised
     2. varchar(30), char(5), TEXT - tekst/sümbolised
     3. date, time, datetime - kuupäev
     4. boolean, bit, bool - loogilised
     ```

USE master;
GO

IF DB_ID('RobertLehtmannLOGITpv24baas') IS NOT NULL
BEGIN
    ALTER DATABASE RobertLehtmannLOGITpv24baas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RobertLehtmannLOGITpv24baas;
END
GO

CREATE DATABASE RobertLehtmannLOGITpv24baas;
GO

USE RobertLehtmannLOGITpv24baas;
GO

CREATE TABLE tootaja(
    tootajaID int PRIMARY KEY IDENTITY(1,1),
    eesnimi varchar(15) NOT NULL,
    perenimi varchar(30) NOT NULL,
    synniaeg date,
    aadress text,
    koormus int CHECK (koormus > 0),
    aktiivne bit
);

-- tabeli kuvamine
SELECT * FROM tootaja;

-- andmete lisamine tabelisse
INSERT INTO tootaja(perenimi, eesnimi, synniaeg)
VALUES ('Ilus', 'Liis', '2002-12-04');

INSERT INTO tootaja(eesnimi, perenimi, synniaeg, aadress, koormus, aktiivne)
VALUES 
('Katja', 'Punane', '2012-10-04', 'Tartu', 120, 1),
('Petja', 'Runane', '2002-10-04', 'Narva', 200, 0);

-- andmete uuendamine tabelis
UPDATE tootaja
SET aadress = 'Tallinn', koormus = 10, aktiivne = 1
WHERE tootajaID = 1;

-- teine tabel
CREATE TABLE toovahetus(
    toovahetusID int PRIMARY KEY IDENTITY(1,1),
    kuupaev date,
    tundideArv int,
    tootajaID int,
    FOREIGN KEY (tootajaID) REFERENCES tootaja(tootajaID)
);

SELECT * FROM toovahetus;
SELECT * FROM tootaja;

-- täidame tabeli
INSERT INTO toovahetus(kuupaev, tundideArv, tootajaID)
VALUES ('2026-04-15', 3, 1);

-- kolmas tabel
CREATE TABLE koolitus(
    koolitusID int PRIMARY KEY IDENTITY(1,1),
    nimetus varchar(255),
    kestvus int,
    algus date,
    lopp date,
    opetaja int,
    FOREIGN KEY (opetaja) REFERENCES tootaja(tootajaID)
);

CREATE TABLE opetamine(
    opetamineID int PRIMARY KEY IDENTITY(1,1),
    tootajaID int,
    koolitusID int,
    tunnistus varchar(50),
    hinne int,
    FOREIGN KEY (tootajaID) REFERENCES tootaja(tootajaID),
    FOREIGN KEY (koolitusID) REFERENCES koolitus(koolitusID)
);

SELECT * FROM koolitus;
SELECT * FROM opetamine;

-- täidame tabeli
INSERT INTO koolitus(nimetus, kestvus, algus, lopp, opetaja)
VALUES
('IT kursus', 10, '2026-05-01', '2026-05-05', 1),
('SQL kursus', 15, '2026-05-10', '2026-05-15', 2),
('Python kursus', 20, '2026-06-01', '2026-06-10', 3);

-- tabeli struktuuri muutmine
-- 1. uue veeru lisamine
ALTER TABLE tootaja ADD testVeerg int;

SELECT * FROM tootaja;

-- 2. andmetüübi muutmine veerus
ALTER TABLE tootaja ALTER COLUMN testVeerg varchar(5);

-- 3. veeru kustutamine
ALTER TABLE tootaja DROP COLUMN testVeerg;

-- struktuuri kontrollimiseks
EXEC sp_help 'tootaja';
