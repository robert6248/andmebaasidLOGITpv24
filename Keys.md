## Andmebaaside konspektid

[Create_insert](Create_insert.md) | [Kasutaja](Kasutaja.md) | [triger](triger.md) | [trigeridXAMPP](trigeridXAMPP.md) | [Keys](keys.md)

# Andmebaasi võtmed

## Primary Key ehk primaarvõti

**Primary Key** on väli või väljade kombinatsioon, mis tuvastab iga tabeli rea üheselt.

Seda kasutatakse andmete unikaalseks tuvastamiseks.

Primaarvõtme omadused:

* väärtus peab olema unikaalne;
* väärtus ei tohi olla `NULL`;
* ühes tabelis saab olla ainult üks Primary Key.

Näide:

```sql
CREATE TABLE Opilane (
    opilane_id INT PRIMARY KEY,
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50)
);
```

---

## Foreign Key ehk võõrvõti

**Foreign Key** on väli, mis viitab teise tabeli Primary Key-le.

Seda kasutatakse tabelite omavaheliseks sidumiseks ja andmete tervikluse tagamiseks.

Võõrvõti ei tuvasta kirjet iseseisvalt, vaid seob ühe tabeli teise tabeliga.

**SIIA LISA FOREIGN KEY PILT**

---

## Unique Key

**Unique Key** tagab, et veerus olevad väärtused oleksid unikaalsed.

Seda kasutatakse korduvate väärtuste vältimiseks.

Erinevus Primary Key-st:

* tabelis võib olla mitu Unique Key-d;
* mõnes andmebaasis võib Unique Key lubada `NULL` väärtust.

Näide:

```sql
CREATE TABLE Kasutaja (
    kasutaja_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);
```

---

## Simple Key

**Simple Key** koosneb ainult ühest väljast.

Seda kasutatakse kirje üheseks tuvastamiseks ühe välja abil.

Näide:

```sql
CREATE TABLE Raamat (
    isbn VARCHAR(20) PRIMARY KEY,
    pealkiri VARCHAR(100)
);
```

---

## Composite Key

**Composite Key** koosneb kahest või enamast väljast, mis koos tagavad kirje unikaalsuse.

Seda kasutatakse siis, kui ühest väljast ei piisa kirje tuvastamiseks.

Näide:

```sql
CREATE TABLE Hinne (
    opilane_id INT,
    aine_id INT,
    hinne INT,
    PRIMARY KEY (opilane_id, aine_id)
);
```

---

## Compound Key

**Compound Key** on Composite Key erijuht. See koosneb mitmest väljast ja vähemalt üks neist võib olla Foreign Key.

Seda kasutatakse tihti seostabelites, näiteks many-to-many seoste puhul.

**SIIA LISA COMPOUND KEY PILT**

---

## Superkey

**Superkey** on üks või mitu välja, mille abil saab tabeli rea üheselt tuvastada.

Superkey võib sisaldada ka liigseid välju.

Näide:

```sql
CREATE TABLE Tootaja (
    tootaja_id INT PRIMARY KEY,
    isikukood VARCHAR(11) UNIQUE,
    nimi VARCHAR(50)
);

-- Superkey näited:
-- tootaja_id
-- isikukood
-- tootaja_id + nimi
-- isikukood + nimi
```

---

## Candidate Key ehk kandidaatvõti

**Candidate Key** on minimaalne Superkey.
See tähendab, et see tuvastab kirje üheselt ja ei sisalda liigseid välju.

Seda kasutatakse Primary Key valimiseks.

Näide:

```sql
CREATE TABLE Tootaja (
    tootaja_id INT,
    isikukood VARCHAR(11),
    nimi VARCHAR(50),
    PRIMARY KEY (tootaja_id),
    UNIQUE (isikukood)
);

-- Kandidaatvõtmed:
-- tootaja_id
-- isikukood
```

---

## Alternate Key ehk alternatiivvõti

**Alternate Key** on kandidaatvõti, mida ei valitud Primary Key-ks.

Seda kasutatakse alternatiivseks unikaalseks identifitseerimiseks.

Näide:

```sql
CREATE TABLE Tootaja (
    tootaja_id INT PRIMARY KEY,
    isikukood VARCHAR(11) UNIQUE,
    nimi VARCHAR(50)
);

-- tootaja_id = Primary Key
-- isikukood = Alternate Key
```
