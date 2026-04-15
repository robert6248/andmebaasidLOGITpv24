Create Database RobertLehtmannLOGITpv24baas;

--ad kustutamine
DROP Database puhtejevTriger;

USE RobertLehtmannLOGITpv24baas;
CREATE TABLE tootaja(
tootajaID int PRIMARY KEY identity(1,1), --identity - automaatselt kasvav arv +1
eesnimi varchar(15) not null,
perenimi varchar(30) not null,
synniaeg date,
aadress TEXT,
koormus int CHECK (koormus>0), -- piirang, et koormus >0
aktiivne bit)

--tabeli kuvamine
SELECT * FROM tootaja;

--admete lisamine tabelisse
INSERT INTO tootaja(perenimi, eesnimi, synniaeg)
VALUES ('Ilus', 'Liis', '2008-10-25')

INSERT INTO tootaja
VALUES ('Leena', 'Punane', '2012-10-4', 'Tallinn', 120, 1)

INSERT INTO tootaja
VALUES ('Katja', 'Punane', '2012-10-4', 'Tartu', 120, 1),
('Petja', 'Runane', '2002-10-4', 'Narva', 200,0)

--andmete uuendamine tabelis
UPDATE tootaja SET aadress='Tallinn', koormus=10, aktiivne=1
WHERE tootajaID=1;
