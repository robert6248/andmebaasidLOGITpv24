Triggerid

Põhimõisted | Kasutajad | Trigerid | Protseduurid | Keys

Mis on trigger?

Trigger ehk päästik on SQL Serveri andmebaasi objekt, mis käivitub automaatselt siis, kui tabelis toimub kindel tegevus.

Trigger võib käivituda näiteks siis, kui:

tabelisse lisatakse uus kirje ehk INSERT;
tabelist kustutatakse kirje ehk DELETE;
tabelis muudetakse olemasolevat kirjet ehk UPDATE.

Selles töös kasutatakse tabelit linnad ja logitabelit logi. Logitabelisse salvestatakse info selle kohta, milline tegevus andmebaasis toimus.

INSERT trigger
Eesmärk

INSERT trigger jälgib andmete lisamist tabelisse linnad. Kui tabelisse lisatakse uus linn, siis lisab trigger automaatselt uue kirje tabelisse logi.

SQL-kood
CREATE TRIGGER linnaLisamine
ON linnad
FOR INSERT
AS
INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
SELECT
    GETDATE(),
    SYSTEM_USER,
    'on tehtud INSERT käsk',
    CONCAT('linn: ', inserted.linnanimi, ', rahvaarv: ', inserted.rahvaarv)
FROM inserted;
Selgitus
GETDATE() lisab logisse kuupäeva ja kellaaja.
SYSTEM_USER näitab kasutajat, kes käsu käivitas.
inserted sisaldab uut lisatud rida.
CONCAT paneb logi jaoks teksti kokku.
Tulemus

Näites lisatakse tabelisse linnad uus kirje. Pärast seda tekib tabelisse logi automaatselt uus rida.

DELETE trigger
Eesmärk

DELETE trigger jälgib andmete kustutamist tabelist linnad. Kui tabelist kustutatakse kirje, siis salvestatakse kustutatud andmed tabelisse logi.

SQL-kood
CREATE TRIGGER linnaKustutamine
ON linnad
FOR DELETE
AS
INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
SELECT
    GETDATE(),
    SYSTEM_USER,
    'on tehtud DELETE käsk',
    CONCAT('linn: ', deleted.linnanimi, ', rahvaarv: ', deleted.rahvaarv)
FROM deleted;
Triggeri kontrollimine
DELETE FROM linnad
WHERE linnID = 3;
Selgitus
deleted sisaldab kustutatud rea andmeid.
Trigger salvestab kustutatud linna nime ja rahvaarvu logitabelisse.
Nii on hiljem võimalik näha, milline kirje kustutati.
Tulemus

Pildil on näha, et pärast kustutamist tekkis tabelisse logi vastav kirje.

Kombineeritud INSERT ja DELETE trigger
Eesmärk

Kombineeritud trigger jälgib mitut tegevust ühe triggeri sees. Selles näites jälgib trigger nii INSERT kui ka DELETE tegevust.

Kui tabelisse lisatakse uus linn või tabelist kustutatakse linn, siis tehakse logitabelisse vastav kirje.

SQL-kood
CREATE TRIGGER linnaLisaKustuta
ON linnad
FOR INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
    SELECT
        GETDATE(),
        SYSTEM_USER,
        'on tehtud INSERT käsk',
        CONCAT('linn: ', inserted.linnanimi, ', rahvaarv: ', inserted.rahvaarv)
    FROM inserted

    UNION ALL

    SELECT
        GETDATE(),
        SYSTEM_USER,
        'on tehtud DELETE käsk',
        CONCAT('linn: ', deleted.linnanimi, ', rahvaarv: ', deleted.rahvaarv)
    FROM deleted;
END;
Selgitus

Selles triggeris kasutatakse kahte ajutist tabelit:

inserted - kui lisatakse uus kirje;
deleted - kui kustutatakse kirje.

UNION ALL ühendab mõlema tegevuse tulemused ja lisab need tabelisse logi.

Triggerid tabelis

Pildil on näha, et andmebaasis on mitu loodud triggerit.

Kombineeritud triggeri kontroll

Pildil on näha, et kombineeritud trigger töötab ja salvestab tegevused logitabelisse.

UPDATE trigger
Eesmärk

UPDATE trigger jälgib andmete muutmist tabelis linnad. Kui tabelis muudetakse linna nime või rahvaarvu, siis salvestab trigger tabelisse logi nii vanad kui ka uued andmed.

SQL-kood
CREATE TRIGGER linnaUuendamine
ON linnad
FOR UPDATE
AS
INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
SELECT
    GETDATE(),
    SYSTEM_USER,
    'on tehtud UPDATE käsk',
    CONCAT(
        'vanad andmed - linn: ', deleted.linnanimi,
        ', rahvaarv: ', deleted.rahvaarv,
        ', uued andmed - linn: ', inserted.linnanimi,
        ', rahvaarv: ', inserted.rahvaarv
    )
FROM deleted
INNER JOIN inserted
ON deleted.linnID = inserted.linnID;
Selgitus

UPDATE trigger kasutab kahte ajutist tabelit:

deleted - vanad andmed enne muutmist;
inserted - uued andmed pärast muutmist.

INNER JOIN ühendab vana ja uue rea sama linnID järgi. Nii saab logitabelisse kirjutada, millised andmed muutusid.

Tulemus

Pildil on näha, et pärast andmete muutmist salvestati logitabelisse vanad ja uued väärtused.


