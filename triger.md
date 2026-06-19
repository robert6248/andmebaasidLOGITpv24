# Triggerid

[Põhimõisted](readme.md) | [Kasutajad](Kasutaja.md) | [Trigerid](triger.md) | [Protseduurid](protseduurid.md) | [Keys](Keys.md)

---

## Trigger - päästik

SQL trigger ehk päästik on spetsiaalne andmebaasi objekt, mis käivitub automaatselt, kui tabelis toimub kindel tegevus. Näiteks võib trigger käivituda siis, kui andmeid lisatakse, muudetakse või kustutatakse.

Triggerit kasutatakse tavaliselt andmete jälgimiseks ja logimiseks. Selles näites kasutatakse tabelit `linnad` ja logitabelit `logi`.

---

## INSERT trigger

INSERT trigger jälgib andmete lisamist tabelisse `linnad`. Kui tabelisse lisatakse uus linn, siis teeb trigger automaatselt uue kirje tabelisse `logi`.

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

Näiteks kui tabelisse `linnad` lisatakse uus kirje, siis salvestatakse see tegevus logitabelisse.

<img width="562" height="183" alt="{C8FCA455-37F9-47D7-855F-354DA6667EBE}" src="https://github.com/user-attachments/assets/8823546b-9f4a-4273-b0bc-a81cea43646a" />

---

## DELETE trigger

DELETE trigger jälgib andmete kustutamist tabelist `linnad`. Kui tabelist kustutatakse kirje, siis lisab trigger kustutatud andmed tabelisse `logi`.

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

Triggeri kontrollimiseks kustutatakse üks kirje tabelist `linnad`.

```sql
DELETE FROM linnad
WHERE linnID = 3;
```

<img width="563" height="180" alt="{16DE1A83-7BB8-42D7-ABF9-A142917E6D77}" src="https://github.com/user-attachments/assets/57a762fc-b1f8-4be3-aeed-7878461af8ae" />

---

## Kombineeritud INSERT ja DELETE trigger

Ühes triggeris saab kasutada ka mitut tegevust korraga. Selles näites jälgib trigger nii INSERT kui ka DELETE tegevust.

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

Selle triggeriga saab jälgida kahte tegevust korraga. Kui lisatakse uus linn või kustutatakse olemasolev linn, siis tehakse logitabelisse vastav kirje.

### Triggerid tabelis

<img width="198" height="163" alt="{172A794F-B89F-4810-A91C-A6696DC837CE}" src="https://github.com/user-attachments/assets/dc3d24c4-4dc5-43bb-9213-72a7666b22c5" />

### Kombineeritud triggeri kontroll

<img width="911" height="363" alt="{42D1FBED-5ADE-42D4-98D1-323C2582AC85}" src="https://github.com/user-attachments/assets/4dc1b2f1-3615-4db0-a707-f40d19a9f2ce" />

---

## UPDATE trigger

UPDATE trigger jälgib andmete muutmist tabelis `linnad`. Kui tabelis muudetakse linna nime või rahvaarvu, siis salvestab trigger logitabelisse nii vanad kui ka uued andmed.

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

Triggeri kontrollimiseks muudetakse tabelis `linnad` olemasolevat kirjet. Pärast muutmist on tabelis `logi` näha, millised olid vanad ja uued andmed.

<img width="1057" height="380" alt="image" src="https://github.com/user-attachments/assets/773951b3-f63c-4585-96d3-93ed3de8cd62" />


---

## Kokkuvõte

Selles töös õppisin, kuidas SQL Serveris triggerid töötavad. Trigger käivitub automaatselt siis, kui tabelis toimub INSERT, DELETE või UPDATE tegevus. Triggerite abil saab jälgida andmete muutmist ja salvestada tegevused logitabelisse.

---

