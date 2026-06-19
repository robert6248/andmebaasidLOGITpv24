# Triggerid

[Põhimõisted](readme.md) | [Kasutajad](Kasutaja.md) | [Trigerid](triger.md) | [Protseduurid](protseduurid.md) | [Keys](Keys.md)

---

## Mis on trigger?

Trigger ehk päästik on SQL Serveri andmebaasi objekt, mis käivitub automaatselt siis, kui tabelis toimub kindel tegevus.

Kõige tavalisemad tegevused on:

* `INSERT` - andmete lisamine;
* `DELETE` - andmete kustutamine;
* `UPDATE` - andmete muutmine.

Triggerit kasutatakse näiteks siis, kui on vaja salvestada, kes ja millal tabelis muudatusi tegi. Selles näites kasutatakse tabelit `linnad` ja logitabelit `logi`.

---

## INSERT trigger - andmete lisamise jälgimine

INSERT trigger käivitub siis, kui tabelisse `linnad` lisatakse uus kirje. Trigger võtab lisatud andmed ajutisest tabelist `inserted` ja salvestab need tabelisse `logi`.

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

Selles koodis kasutatakse:

* `GETDATE()` - salvestab tegevuse aja;
* `SYSTEM_USER` - salvestab kasutaja nime;
* `inserted` - näitab uut lisatud kirjet.

### Tulemus

Pildil on näha, et pärast uue linna lisamist tekkis logitabelisse uus kirje.

---

## DELETE trigger - kustutamise jälgimine

DELETE trigger käivitub siis, kui tabelist `linnad` kustutatakse kirje. Kustutatud andmed võetakse ajutisest tabelist `deleted`.

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

Triggeri kontrollimiseks kustutatakse tabelist `linnad` üks rida.

```sql
DELETE FROM linnad
WHERE linnID = 3;
```

Selles näites kasutatakse `deleted` tabelit, sest SQL Server hoiab kustutatud rea andmeid seal ainult triggeri töö ajal.

### Tulemus

Pildil on näha, et kustutamise kohta lisati tabelisse `logi` uus rida.

---

## Kombineeritud trigger - INSERT ja DELETE koos

Üks trigger võib jälgida ka mitut tegevust korraga. Selles näites jälgib trigger nii andmete lisamist kui ka kustutamist.

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

Selles triggeris kasutatakse kahte ajutist tabelit:

* `inserted` - kui lisatakse uus rida;
* `deleted` - kui kustutatakse olemasolev rida.

`UNION ALL` ühendab mõlema tegevuse tulemused ja lisab need logitabelisse.

### Triggerid andmebaasis

Pildil on näha, et andmebaasis on loodud mitu triggerit.

### Kombineeritud triggeri kontroll

Pildil on näha, et kombineeritud trigger lisab logitabelisse kirje nii lisamise kui ka kustutamise korral.

---

## UPDATE trigger - andmete muutmise jälgimine

UPDATE trigger käivitub siis, kui tabelis `linnad` muudetakse olemasolevat kirjet. Selle triggeri puhul kasutatakse korraga kahte ajutist tabelit:

* `deleted` - vanad andmed enne muutmist;
* `inserted` - uued andmed pärast muutmist.

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

`INNER JOIN` ühendab vana ja uue rea sama `linnID` järgi. Tänu sellele saab logisse kirjutada, mis väärtus oli enne ja mis väärtus tuli pärast muutmist.

### Tulemus

Pildil on näha, et pärast muutmist salvestati logitabelisse nii vanad kui ka uued andmed.

---

## Lühike kokkuvõte triggeritest

| Trigger               | Millal käivitub?                 | Milleks kasutatakse?                      |
| --------------------- | -------------------------------- | ----------------------------------------- |
| INSERT trigger        | Kui lisatakse uus kirje          | Lisamise logimiseks                       |
| DELETE trigger        | Kui kustutatakse kirje           | Kustutamise logimiseks                    |
| UPDATE trigger        | Kui muudetakse kirjet            | Vanade ja uute andmete salvestamiseks     |
| Kombineeritud trigger | Kui toimub mitu valitud tegevust | Mitme tegevuse jälgimiseks ühe triggeriga |

---

##
