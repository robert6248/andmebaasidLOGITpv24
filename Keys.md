# Andmebaasi võtmed (Keys)

## Sissejuhatus

Selles töös selgitan andmebaasi võtmete põhimõisteid. Võtmeid kasutatakse tabelites selleks, et andmeid oleks võimalik üheselt tuvastada, siduda ja kontrollida. Näited on tehtud SQL Serveris.

---

## 1. Primary Key

**Definitsioon:**
Primary Key ehk primaarvõti on väli või väljade kombinatsioon, mis tuvastab iga tabeli rea üheselt.

**Milleks kasutatakse:**
Seda kasutatakse selleks, et igal real oleks oma kindel tunnus. Primary Key väärtus ei tohi korduda ega olla `NULL`.

**Erinevus teistest võtmetest:**
Tabelis saab olla ainult üks Primary Key, aga see võib koosneda ühest või mitmest veerust.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Opilased_PK', 'U') IS NOT NULL
DROP TABLE dbo.Opilased_PK;

CREATE TABLE Opilased_PK (
    opilane_id INT IDENTITY(1,1),
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50),
    CONSTRAINT PK_Opilased_PK PRIMARY KEY (opilane_id)
);

EXEC sp_help 'Opilased_PK';
```

**Lisa siia ekraanipilt, kus on näha loodud Primary Key.**

---

## 2. Foreign Key

**Definitsioon:**
Foreign Key ehk võõrvõti on veerg, mis viitab teise tabeli Primary Key väärtusele.

**Milleks kasutatakse:**
Seda kasutatakse tabelite omavaheliseks sidumiseks. Näiteks tellimus saab olla seotud kindla õpilasega.

**Erinevus teistest võtmetest:**
Foreign Key ei pea olema unikaalne. Selle eesmärk on luua seos kahe tabeli vahel.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Tellimused_FK', 'U') IS NOT NULL
DROP TABLE dbo.Tellimused_FK;

CREATE TABLE Tellimused_FK (
    tellimus_id INT IDENTITY(1,1),
    opilane_id INT NOT NULL,
    toode VARCHAR(50),
    CONSTRAINT PK_Tellimused_FK PRIMARY KEY (tellimus_id),
    CONSTRAINT FK_Tellimused_Opilased FOREIGN KEY (opilane_id)
    REFERENCES Opilased_PK(opilane_id)
);

EXEC sp_help 'Tellimused_FK';
```

**Lisa siia ekraanipilt, kus on näha loodud Foreign Key.**

---

## 3. Unique Key

**Definitsioon:**
Unique Key on piirang, mis tagab, et veeru väärtused ei kordu.

**Milleks kasutatakse:**
Seda kasutatakse näiteks e-posti, isikukoodi või kasutajanime puhul, sest need peavad olema unikaalsed.

**Erinevus teistest võtmetest:**
Tabelis saab olla mitu Unique Key piirangut, aga ainult üks Primary Key.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Kasutajad_UQ', 'U') IS NOT NULL
DROP TABLE dbo.Kasutajad_UQ;

CREATE TABLE Kasutajad_UQ (
    kasutaja_id INT IDENTITY(1,1),
    email VARCHAR(100) NOT NULL,
    kasutajanimi VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Kasutajad_UQ PRIMARY KEY (kasutaja_id),
    CONSTRAINT UQ_Kasutajad_Email UNIQUE (email),
    CONSTRAINT UQ_Kasutajad_Kasutajanimi UNIQUE (kasutajanimi)
);

EXEC sp_help 'Kasutajad_UQ';
```

**Lisa siia ekraanipilt, kus on näha Unique Key.**

---

## 4. Simple Key

**Definitsioon:**
Simple Key on võti, mis koosneb ainult ühest veerust.

**Milleks kasutatakse:**
Seda kasutatakse siis, kui ühest veerust piisab rea üheseks tuvastamiseks.

**Erinevus teistest võtmetest:**
Simple Key koosneb ühest veerust, aga Composite Key koosneb mitmest veerust.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.SimpleKey_Naide', 'U') IS NOT NULL
DROP TABLE dbo.SimpleKey_Naide;

CREATE TABLE SimpleKey_Naide (
    isikukood VARCHAR(11) NOT NULL,
    nimi VARCHAR(50),
    CONSTRAINT PK_SimpleKey PRIMARY KEY (isikukood)
);

EXEC sp_help 'SimpleKey_Naide';
```

**Lisa siia ekraanipilt, kus on näha Simple Key.**

---

## 5. Composite Key

**Definitsioon:**
Composite Key on võti, mis koosneb kahest või rohkemast veerust.

**Milleks kasutatakse:**
Seda kasutatakse siis, kui üks veerg üksi ei tuvasta rida piisavalt täpselt.

**Erinevus teistest võtmetest:**
Composite Key kasutab mitut veergu. Need veerud ei pea olema võõrvõtmed.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Ruumide_Ajad', 'U') IS NOT NULL
DROP TABLE dbo.Ruumide_Ajad;

CREATE TABLE Ruumide_Ajad (
    ruum_nr VARCHAR(10) NOT NULL,
    kuupaev DATE NOT NULL,
    algus TIME NOT NULL,
    tegevus VARCHAR(50),
    CONSTRAINT PK_Ruumide_Ajad PRIMARY KEY (ruum_nr, kuupaev, algus)
);

EXEC sp_help 'Ruumide_Ajad';
```

**Lisa siia ekraanipilt, kus on näha Composite Key.**

---

## 6. Compound Key

**Definitsioon:**
Compound Key on mitmest veerust koosnev võti, kus veerud on tavaliselt seotud teiste tabelitega ehk on võõrvõtmed.

**Milleks kasutatakse:**
Seda kasutatakse näiteks seostabelis, kus üks õpilane saab olla mitmel kursusel ja üks kursus saab olla mitmel õpilasel.

**Erinevus teistest võtmetest:**
Compound Key on sarnane Composite Key’ga, aga selle veerud on tavaliselt Foreign Key’d.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Registreerimised_COMP', 'U') IS NOT NULL
DROP TABLE dbo.Registreerimised_COMP;

IF OBJECT_ID('dbo.Opilased_COMP', 'U') IS NOT NULL
DROP TABLE dbo.Opilased_COMP;

IF OBJECT_ID('dbo.Kursused_COMP', 'U') IS NOT NULL
DROP TABLE dbo.Kursused_COMP;

CREATE TABLE Opilased_COMP (
    opilane_id INT IDENTITY(1,1),
    nimi VARCHAR(50),
    CONSTRAINT PK_Opilased_COMP PRIMARY KEY (opilane_id)
);

CREATE TABLE Kursused_COMP (
    kursus_id INT IDENTITY(1,1),
    kursuse_nimi VARCHAR(50),
    CONSTRAINT PK_Kursused_COMP PRIMARY KEY (kursus_id)
);

CREATE TABLE Registreerimised_COMP (
    opilane_id INT NOT NULL,
    kursus_id INT NOT NULL,
    kuupaev DATE,
    CONSTRAINT PK_Registreerimised_COMP PRIMARY KEY (opilane_id, kursus_id),
    CONSTRAINT FK_Reg_Opilane_COMP FOREIGN KEY (opilane_id)
    REFERENCES Opilased_COMP(opilane_id),
    CONSTRAINT FK_Reg_Kursus_COMP FOREIGN KEY (kursus_id)
    REFERENCES Kursused_COMP(kursus_id)
);

EXEC sp_help 'Registreerimised_COMP';
```

**Lisa siia ekraanipilt, kus on näha Compound Key.**

---

## 7. Superkey

**Definitsioon:**
Superkey on veerg või veergude kogum, millega saab tabeli rea üheselt tuvastada.

**Milleks kasutatakse:**
Seda kasutatakse teoreetiliselt selleks, et näidata kõiki võimalikke viise rea tuvastamiseks.

**Erinevus teistest võtmetest:**
Superkey ei pea olema minimaalne. See tähendab, et selles võib olla rohkem veerge kui tegelikult vaja.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Superkey_Naide', 'U') IS NOT NULL
DROP TABLE dbo.Superkey_Naide;

CREATE TABLE Superkey_Naide (
    opilane_id INT IDENTITY(1,1),
    isikukood VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nimi VARCHAR(50),
    CONSTRAINT PK_Superkey_Naide PRIMARY KEY (opilane_id),
    CONSTRAINT UQ_Superkey_Isikukood UNIQUE (isikukood),
    CONSTRAINT UQ_Superkey_IsikukoodEmail UNIQUE (isikukood, email)
);

EXEC sp_help 'Superkey_Naide';
```

**Selgitus:**
`isikukood` on juba unikaalne. Seega `(isikukood, email)` on superkey, aga mitte minimaalne võti.

**Lisa siia ekraanipilt, kus on näha Superkey näide.**

---

## 8. Candidate Key

**Definitsioon:**
Candidate Key on minimaalne võti, mis sobib rea üheseks tuvastamiseks.

**Milleks kasutatakse:**
Seda kasutatakse selleks, et valida, milline võti saab Primary Key’ks.

**Erinevus teistest võtmetest:**
Candidate Key on minimaalne. Superkey võib sisaldada liigseid veerge, aga Candidate Key mitte.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Kandidaatvotmed', 'U') IS NOT NULL
DROP TABLE dbo.Kandidaatvotmed;

CREATE TABLE Kandidaatvotmed (
    opilane_id INT IDENTITY(1,1),
    isikukood VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nimi VARCHAR(50),
    CONSTRAINT PK_Kandidaatvotmed PRIMARY KEY (opilane_id),
    CONSTRAINT UQ_Kandidaat_Isikukood UNIQUE (isikukood),
    CONSTRAINT UQ_Kandidaat_Email UNIQUE (email)
);

EXEC sp_help 'Kandidaatvotmed';
```

**Selgitus:**
Selles tabelis võivad kandidaadvõtmed olla `opilane_id`, `isikukood` ja `email`, sest igaüks neist saab rea üheselt tuvastada.

**Lisa siia ekraanipilt, kus on näha Candidate Key näide.**

---

## 9. Alternate Key

**Definitsioon:**
Alternate Key on kandidaadvõti, mida ei valitud Primary Key’ks.

**Milleks kasutatakse:**
Seda kasutatakse andmete unikaalsuse kontrollimiseks, kui Primary Key on juba valitud.

**Erinevus teistest võtmetest:**
Primary Key on põhiline valitud võti. Alternate Key on teine võimalik unikaalne võti.

**SQL näide:**

```sql
IF OBJECT_ID('dbo.Alternatiivvoti', 'U') IS NOT NULL
DROP TABLE dbo.Alternatiivvoti;

CREATE TABLE Alternatiivvoti (
    opilane_id INT IDENTITY(1,1),
    isikukood VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nimi VARCHAR(50),
    CONSTRAINT PK_Alternatiivvoti PRIMARY KEY (opilane_id),
    CONSTRAINT AK_Alternatiiv_Isikukood UNIQUE (isikukood)
);

EXEC sp_help 'Alternatiivvoti';
```

**Selgitus:**
`opilane_id` on Primary Key. `isikukood` on Alternate Key, sest see on samuti unikaalne, aga seda ei valitud Primary Key’ks.

**Lisa siia ekraanipilt, kus on näha Alternate Key.**

---

## Kokkuvõte

Selles töös õppisin, et andmebaasi võtmed aitavad andmeid korrastada ja kontrollida. Primary Key tuvastab rea, Foreign Key seob tabeleid ja Unique Key keelab korduvad väärtused. Composite ja Compound Key kasutavad mitut veergu. Superkey, Candidate Key ja Alternate Key on rohkem teoreetilised mõisted, aga neid saab näidata SQL-is unikaalsete piirangute kaudu.

---

## Kasutatud allikad

* [Microsoft Learn - Primary and foreign key constraints](https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints?view=sql-server-ver17)
* [Microsoft Learn - Unique constraints and check constraints](https://learn.microsoft.com/en-us/sql/relational-databases/tables/unique-constraints-and-check-constraints?view=sql-server-ver17)
* [Microsoft Learn - Create foreign key relationships](https://learn.microsoft.com/en-us/sql/relational-databases/tables/create-foreign-key-relationships?view=sql-server-ver17)
* [W3Schools - SQL Primary Key](https://www.w3schools.com/sql/sql_primarykey.asp)
* [W3Schools - SQL Foreign Key](https://www.w3schools.com/sql/sql_foreignkey.asp)
* [W3Schools - SQL Unique](https://www.w3schools.com/sql/sql_unique.asp)
