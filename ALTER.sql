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

SELECT * FROM tootaja;

INSERT INTO tootaja(perenimi, eesnimi, synniaeg)
VALUES ('Ilus', 'Liis', '2002-12-04');

INSERT INTO tootaja(eesnimi, perenimi, synniaeg, aadress, koormus, aktiivne)
VALUES 
('Katja', 'Punane', '2012-10-04', 'Tartu', 120, 1),
('Petja', 'Runane', '2002-10-04', 'Narva', 200, 0);

UPDATE tootaja
SET aadress = 'Tallinn', koormus = 10, aktiivne = 1
WHERE tootajaID = 1;

CREATE TABLE toovahetus(
    toovahetusID int PRIMARY KEY IDENTITY(1,1),
    kuupaev date,
    tundideArv int,
    tootajaID int,
    FOREIGN KEY (tootajaID) REFERENCES tootaja(tootajaID)
);

SELECT * FROM toovahetus;
SELECT * FROM tootaja;

INSERT INTO toovahetus(kuupaev, tundideArv, tootajaID)
VALUES ('2026-04-15', 3, 1);

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

INSERT INTO koolitus(nimetus, kestvus, algus, lopp, opetaja)
VALUES
('IT kursus', 10, '2026-05-01', '2026-05-05', 1),
('SQL kursus', 15, '2026-05-10', '2026-05-15', 2),
('Python kursus', 20, '2026-06-01', '2026-06-10', 3);

ALTER TABLE tootaja ADD testVeerg int;
SELECT * FROM tootaja;

ALTER TABLE tootaja ALTER COLUMN testVeerg varchar(5);
ALTER TABLE tootaja DROP COLUMN testVeerg;

EXEC sp_help 'tootaja';

CREATE TABLE ryhm(
    ryhmId int NOT NULL,
    ryhmNimi char(10)
);

ALTER TABLE ryhm ADD CONSTRAINT pk_ryhm PRIMARY KEY (ryhmId);

INSERT INTO ryhm
VALUES (3, 'LOGITpv24');

SELECT * FROM ryhm;

ALTER TABLE ryhm ADD CONSTRAINT un_ryhm UNIQUE (ryhmNimi);

ALTER TABLE ryhm ADD ryhmajuhataja int;

ALTER TABLE ryhm ADD CONSTRAINT fk_ryhm
FOREIGN KEY (ryhmajuhataja) REFERENCES tootaja(tootajaID);

SELECT * FROM tootaja;
SELECT * FROM ryhm;

UPDATE ryhm
SET ryhmajuhataja = 1
WHERE ryhmNimi = 'LOGITpv24';

SELECT * FROM ryhm;