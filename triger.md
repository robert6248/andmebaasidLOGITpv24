# Triggerid

[Põhimõisted](readme.md) | [Kasutajad](Kasutaja.md) | [Trigerid](triger.md) | [Protseduurid](protseduurid.md) | [Keys](Keys.md)

---

# Triggerid SQL Serveris

## Mis on trigger?

Trigger ehk päästik on SQL Serveri andmebaasi objekt, mis käivitub automaatselt siis, kui tabelis toimub kindel tegevus.

Trigger võib käivituda näiteks siis, kui:

* tabelisse lisatakse uus kirje (`INSERT`);
* tabelist kustutatakse kirje (`DELETE`);
* tabelis muudetakse olemasolevat kirjet (`UPDATE`).

Selles töös kasutatakse tabelit **linnad** ja logitabelit **logi**. Logitabelisse salvestatakse info selle kohta, milline tegevus andmebaasis toimus.

---

# INSERT trigger

## Eesmärk

INSERT trigger jälgib andmete lisamist tabelisse `linnad`. Kui tabelisse lisatakse uus linn, siis lisab trigger automaatselt uue kirje tabelisse `logi`.

## SQL-kood

```sql
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
```

## Selgitus

* `GETDATE()` lisab logisse kuupäeva ja kellaaja.
* `SYSTEM_USER` näitab kasutajat, kes käsu käivitas.
* `inserted` sisaldab uut lisatud rida.
* `CONCAT()` ühendab teksti üheks logikirjeks.

## Tulemus

Näites lisatakse tabelisse `linnad` uus kirje. Pärast seda tekib tabelisse `logi` automaatselt uus rida.

### Ekraanipilt

---

# DELETE trigger

## Eesmärk

DELETE trigger jälgib andmete kustutamist tabelist `linnad`. Kui tabelist kustutatakse kirje, siis salvestatakse kustutatud andmed tabelisse `logi`.

## SQL-kood

```sql
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
```

## Triggeri kontrollimine

```sql
DELETE FROM linnad
WHERE linnID = 3;
```

## Selgitus

* `deleted` sisaldab kustutatud rea andmeid.
* Trigger salvestab kustutatud linna nime ja rahvaarvu logitabelisse.
* Hiljem on võimalik kontrollida, milline kirje kustutati.

## Tulemus

Pildil on näha, et pärast kustutamist tekkis tabelisse `logi` vastav kirje.

### Ekraanipilt

---

# Kombineeritud INSERT ja DELETE trigger

## Eesmärk

Kombineeritud trigger võimaldab jälgida mitut tegevust ühe triggeri sees. Selles näites jälgitakse nii `INSERT` kui ka `DELETE` tegevusi.

Kui tabelisse lisatakse uus linn või tabelist kustutatakse linn, siis tehakse logitabelisse vastav kirje.

## SQL-kood

```sql
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
```

## Selgitus

Selles triggeris kasutatakse kahte süsteemset tabelit:

* `inserted` – sisaldab lisatud ridu;
* `deleted` – sisaldab kustutatud ridu.

`UNION ALL` ühendab mõlema tegevuse tulemused ja lisab need tabelisse `logi`.

## Triggerid tabelis

Pildil on näha kõik loodud triggerid SQL Serveri andmebaasis.

### Ekraanipilt

## Kombineeritud triggeri kontroll

Pildil on näha, et kombineeritud trigger töötab korrektselt ja salvestab tegevused logitabelisse.

### Ekraanipilt

---

# UPDATE trigger

## Eesmärk

UPDATE trigger jälgib andmete muutmist tabelis `linnad`. Kui tabelis muudetakse linna nime või rahvaarvu, siis salvestab trigger tabelisse `logi` nii vanad kui ka uued andmed.

## SQL-kood

```sql
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
```

## Selgitus

UPDATE trigger kasutab kahte süsteemset tabelit:

* `deleted` – sisaldab vanu andmeid enne muutmist;
* `inserted` – sisaldab uusi andmeid pärast muutmist.

`INNER JOIN` ühendab vana ja uue rea sama `linnID` järgi. Nii saab logitabelisse salvestada täpse info tehtud muudatuste kohta.

## Tulemus

Pildil on näha, et pärast andmete muutmist salvestati logitabelisse vanad ja uued väärtused.

### Ekraanipilt

---

# Kokkuvõte

Selles töös õppisin, kuidas SQL Serveris triggerid töötavad. Trigger käivitub automaatselt, kui tabelis toimub `INSERT`, `DELETE` või `UPDATE` tegevus.

Triggerite abil saab:

* jälgida andmete lisamist;
* jälgida andmete kustutamist;
* jälgida andmete muutmist;
* salvestada kõik tegevused logitabelisse.

Selline lahendus võimaldab pidada arvestust andmebaasis toimunud muudatuste üle ning lihtsustab vigade ja muudatuste hilisemat kontrollimist.

---
