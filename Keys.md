# Andmebaasi võtmed (Keys)

[Põhimõisted](README.md) | [Protseduurid](protseduurid.md) | [Kasutajad](kasutaja.md) | [Trigerid](triger.md) | [Keys](keys.md)

---

## Primary Key

### Definitsioon

Primary Key ehk primaarvõti on veerg või veergude kogum, mis identifitseerib iga tabeli rea unikaalselt. Primaarvõtme väärtus ei tohi korduda ega olla `NULL`.

### Kasutus

* Iga rea unikaalseks tuvastamiseks.
* Tabeli põhiidentifikaatorina.
* Seoste loomiseks teiste tabelitega.

### Erinevus

* Tabelis saab olla ainult üks Primary Key.
* Väärtused peavad olema unikaalsed.
* Väärtus ei tohi olla tühi ehk `NULL`.

### Näide

Selles näites on tabelis `kasutaja` primaarvõtmeks `kasutaja_id`.

```sql
CREATE TABLE kasutaja(
    kasutaja_id INT PRIMARY KEY IDENTITY(1,1),
    kasutaja_nimi VARCHAR(30),
    vanus INT
);

INSERT INTO kasutaja
VALUES ('Robert', 18), ('Mark', 17), ('Daniil', 18);

SELECT * FROM kasutaja;
```

<img width="532" height="413" alt="Primary Key näide" src="https://github.com/user-attachments/assets/737be006-4d8b-45d7-a427-935d1b50fcb3" />

---

## Foreign Key

### Definitsioon

Foreign Key ehk võõrvõti on veerg, mis viitab teise tabeli Primary Key väärtusele.

### Kasutus

* Tabelite omavaheliseks sidumiseks.
* Andmete terviklikkuse tagamiseks.
* Vigaste seoste vältimiseks.

### Erinevus

* Foreign Key võib korduda.
* See viitab teise tabeli võtmele.
* See ei luba lisada väärtust, mida seotud tabelis ei ole.

### Näide

Tabel `toit` kasutab veergu `kasutaja_id`, mis viitab tabelile `kasutaja`.

```sql
CREATE TABLE toit(
    id INT PRIMARY KEY IDENTITY(1,1),
    toidu_nimi VARCHAR(30),
    kasutaja_id INT,
    FOREIGN KEY (kasutaja_id) REFERENCES kasutaja(kasutaja_id)
);

INSERT INTO toit
VALUES ('Pizza', 1), ('Burger', 2);

SELECT * FROM toit;
```

<img width="593" height="375" alt="Foreign Key näide" src="https://github.com/user-attachments/assets/07b61bd5-c425-48f3-b9ca-7963aaf1df48" />

Kui proovida lisada toitu kasutajale, kelle `kasutaja_id` on 4, tekib viga, sest sellist kasutajat tabelis `kasutaja` ei ole.

```sql
INSERT INTO toit
VALUES ('Sushi', 4);
```

<img width="1311" height="177" alt="Foreign Key viga" src="https://github.com/user-attachments/assets/2e418c0f-723b-47f0-9b4a-5e962250d243" />

---

## Unique Key

### Definitsioon

Unique Key on piirang, mis tagab, et ühe veeru väärtused ei kordu.

### Kasutus

* Duplikaatide vältimiseks.
* Näiteks emaili, kasutajanime või sõna unikaalsuse kontrollimiseks.
* Andmete korrektsuse tagamiseks.

### Erinevus

* Tabelis võib olla mitu Unique Key piirangut.
* Primary Key on tabeli põhiline võti, aga Unique Key on lisapiirang.
* Unique Key ei ole alati tabeli peamine identifikaator.

### Näide

Tabelis `sonaraamat` peab veerg `sona` olema unikaalne.

```sql
CREATE TABLE sonaraamat(
    id INT PRIMARY KEY IDENTITY(1,1),
    sona VARCHAR(30) UNIQUE
);

INSERT INTO sonaraamat
VALUES ('Auto'), ('Maja');

SELECT * FROM sonaraamat;
```

<img width="411" height="387" alt="Unique Key näide" src="https://github.com/user-attachments/assets/1970725d-1297-4e9d-af8b-5f19bda381fa" />

Kui proovida lisada sama sõna uuesti, tekib Unique Key viga.

```sql
INSERT INTO sonaraamat
VALUES ('Auto');
```

<img width="1247" height="203" alt="Unique Key viga" src="https://github.com/user-attachments/assets/4d1a9df8-913a-45e4-a9c3-7cbeab63c6c8" />

---

## Simple Key

### Definitsioon

Simple Key on võti, mis koosneb ainult ühest veerust.

### Kasutus

* Lihtsates tabelites rea tuvastamiseks.
* Kui ühest veerust piisab unikaalsuse jaoks.
* Näiteks `id`, `isikukood` või `looma_id`.

### Erinevus

* Simple Key koosneb ühest veerust.
* Composite Key koosneb mitmest veerust.
* Simple Key on kõige lihtsam võtme tüüp.

### Näide

Tabelis `loomad` on Simple Key veerg `looma_id`.

```sql
CREATE TABLE loomad(
    looma_id INT PRIMARY KEY,
    looma_nimi VARCHAR(30)
);

INSERT INTO loomad
VALUES (1, 'Koer'), (2, 'Kass');

SELECT * FROM loomad;
```

<img width="360" height="386" alt="Simple Key näide" src="https://github.com/user-attachments/assets/964692a6-0acc-409e-a024-be6f493201b6" />

Kui proovida lisada sama `looma_id` uuesti, tekib viga.

```sql
INSERT INTO loomad
VALUES (2, 'Hamster');
```

<img width="1192" height="252" alt="Simple Key viga" src="https://github.com/user-attachments/assets/a5c93748-8536-4757-b7d0-002cb8058f10" />

---

## Composite Key

### Definitsioon

Composite Key on võti, mis koosneb kahest või rohkemast veerust. Unikaalne peab olema nende veergude kombinatsioon.

### Kasutus

* Kui üks veerg ei ole piisav rea tuvastamiseks.
* Tellimuste, kursuste või seostabelite puhul.
* Mitme välja põhjal unikaalse kirje loomiseks.

### Erinevus

* Koosneb mitmest veerust.
* Üksikud veerud võivad korduda.
* Korduda ei tohi terve veergude kombinatsioon.

### Näide

Tabelis `tellimus` moodustavad primaarvõtme veerud `tellimuse_id` ja `toote_id`.

```sql
CREATE TABLE tellimus(
    tellimuse_id INT,
    toote_id INT,
    kogus INT,
    PRIMARY KEY (tellimuse_id, toote_id)
);

INSERT INTO tellimus
VALUES (1, 1, 2), (1, 2, 1), (2, 1, 3);

SELECT * FROM tellimus;
```

<img width="455" height="446" alt="Composite Key näide" src="https://github.com/user-attachments/assets/bfe5e44b-e6e4-49fb-be85-e9849fcc5a5d" />

Kui proovida lisada sama kombinatsioon `(1, 1)` uuesti, tekib Primary Key viga.

```sql
INSERT INTO tellimus
VALUES (1, 1, 5);
```

<img width="1240" height="242" alt="Composite Key viga" src="https://github.com/user-attachments/assets/d2196755-49f9-4be5-9071-447c3fe8df97" />

---

## Compound Key

### Definitsioon

Compound Key on mitmest veerust koosnev võti, kus veerud on tavaliselt seotud teiste tabelitega. Seda kasutatakse sageli koos Foreign Key piiranguga.

### Kasutus

* Seostabelites.
* Kui tabel peab viitama mitme veeru kombinatsioonile.
* Keerulisemate tabeliseoste loomiseks.

### Erinevus

* Sarnaneb Composite Key’ga.
* Tavaliselt kasutatakse seda koos Foreign Key’ga.
* Compound Key võib viidata teise tabeli mitme veeru võtmele.

### Näide

Kõigepealt luuakse tabel `opilane_kursus`, kus primaarvõti koosneb kahest veerust.

```sql
CREATE TABLE opilane_kursus(
    opilane_id INT,
    kursus_id INT,
    PRIMARY KEY (opilane_id, kursus_id)
);

INSERT INTO opilane_kursus
VALUES (1, 1), (2, 2);

SELECT * FROM opilane_kursus;
```

<img width="390" height="346" alt="Compound Key esimene tabel" src="https://github.com/user-attachments/assets/c1192dad-e741-4bab-9e27-fccb17f9c661" />

Seejärel luuakse tabel `hinne`, kus kasutatakse võõrvõtit kahe veeru põhjal.

```sql
CREATE TABLE hinne(
    hinne_id INT PRIMARY KEY IDENTITY(1,1),
    opilane_id INT,
    kursus_id INT,
    hinne INT,
    FOREIGN KEY (opilane_id, kursus_id)
    REFERENCES opilane_kursus(opilane_id, kursus_id)
);

INSERT INTO hinne
VALUES (1, 1, 5), (2, 2, 4);

SELECT * FROM hinne;
```

<img width="540" height="400" alt="Compound Key teine tabel" src="https://github.com/user-attachments/assets/b5710696-03b3-41c0-b158-ff6385d0688b" />

Kui proovida lisada kombinatsioon, mida tabelis `opilane_kursus` ei ole, tekib Foreign Key viga.

```sql
INSERT INTO hinne
VALUES (1, 2, 5);
```

<img width="1131" height="247" alt="Compound Key viga" src="https://github.com/user-attachments/assets/033650a1-f03f-4b69-85b5-5873fb7e1fb0" />

---

## Superkey

### Definitsioon

Superkey on üks või mitu veergu, mille abil saab tabeli rea unikaalselt tuvastada. Superkey võib sisaldada ka üleliigseid veerge.

### Kasutus

* Tabeli ridade unikaalseks tuvastamiseks.
* Teoreetilise võtme mõistena.
* Candidate Key leidmiseks.

### Erinevus

* Superkey võib sisaldada üleliigseid veerge.
* Candidate Key on minimaalne Superkey.
* Iga Candidate Key on Superkey, aga iga Superkey ei ole Candidate Key.

### Näide

Tabelis `inimene` saab rida otsida `id` järgi, `email` järgi või kombinatsiooniga `id + email`.

```sql
CREATE TABLE inimene(
    id INT PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(30),
    email VARCHAR(50) UNIQUE
);

INSERT INTO inimene
VALUES
('Robert', 'robert@gmail.com'),
('Mark', 'mark@gmail.com'),
('Daniil', 'daniil@gmail.com');

SELECT * FROM inimene;
SELECT * FROM inimene WHERE id = 1;
SELECT * FROM inimene WHERE email = 'mark@gmail.com';
SELECT * FROM inimene WHERE id = 3 AND email = 'daniil@gmail.com';
```

<img width="632" height="995" alt="Superkey näide" src="https://github.com/user-attachments/assets/ffbb682b-4927-43f3-86de-2c0eb2a98799" />

Näiteks `id + email` on Superkey, sest selle abil saab rea unikaalselt leida. Samas on seal üks üleliigne veerg, sest ainult `id` oleks juba piisav.

---

## Candidate Key

### Definitsioon

Candidate Key on minimaalne võti, mis sobib tabeli rea unikaalseks tuvastamiseks.

### Kasutus

* Primary Key valimiseks.
* Võimalike unikaalsete identifikaatorite leidmiseks.
* Andmebaasi planeerimisel.

### Erinevus

* Candidate Key ei sisalda üleliigseid veerge.
* Superkey võib sisaldada üleliigseid veerge.
* Üks Candidate Key valitakse tavaliselt Primary Key’ks.

### Näide

Tabelis `telefon` on `tel_id` Candidate Key, sest see on iga rea jaoks unikaalne.

```sql
CREATE TABLE telefon(
    tel_id INT PRIMARY KEY IDENTITY(1,1),
    mudel VARCHAR(50),
    kogus INT,
    pood VARCHAR(30)
);

INSERT INTO telefon
VALUES
('iPhone 14', 10, 'T1'),
('Samsung S23', 5, 'Mustikas'),
('Nokia 3310', 2, 'Ulemiste');

SELECT * FROM telefon;
```

<img width="436" height="522" alt="Candidate Key näide" src="https://github.com/user-attachments/assets/52af0e17-12d3-4faa-9329-a6e5ce14dfd6" />

`tel_id` sobib kandidaadvõtmeks, sest selle abil saab iga rea eraldi tuvastada.

---

## Alternate Key

### Definitsioon

Alternate Key on Candidate Key, mida ei valitud Primary Key’ks.

### Kasutus

* Alternatiivseks rea otsimiseks.
* Teiste veergude unikaalsuse tagamiseks.
* Duplikaatide vältimiseks.

### Erinevus

* Primary Key on peamine valitud võti.
* Alternate Key on teine võimalik unikaalne võti.
* SQL-is tehakse seda tavaliselt `UNIQUE` piiranguga.

### Näide

Tabelis `telefon_alt` on `tel_id` Primary Key. Veerud `mudel`, `kogus` ja `pood` on unikaalsed, seega neid saab kasutada Alternate Key näidetena.

```sql
CREATE TABLE telefon_alt(
    tel_id INT PRIMARY KEY IDENTITY(1,1),
    mudel VARCHAR(50) UNIQUE,
    kogus INT UNIQUE,
    pood VARCHAR(30) UNIQUE
);

INSERT INTO telefon_alt
VALUES
('iPhone 14', 10, 'T1'),
('iPhone 15', 11, 'Kristiine Keskus'),
('Samsung S23', 5, 'Mustikas'),
('Nokia 3310', 2, 'Ulemiste');

SELECT * FROM telefon_alt;
```

<img width="450" height="486" alt="Alternate Key näide" src="https://github.com/user-attachments/assets/0a9fcf29-8167-4836-9f75-9f95095502d9" />

Selles tabelis on `tel_id` Primary Key. Teised unikaalsed veerud on Alternate Key näited.

---

## Kokkuvõte

Selles töös õppisin erinevaid andmebaasi võtmeid. Primary Key tuvastab tabelis iga rea. Foreign Key seob erinevaid tabeleid. Unique Key keelab korduvad väärtused. Simple Key koosneb ühest veerust, aga Composite Key ja Compound Key kasutavad mitut veergu. Superkey, Candidate Key ja Alternate Key aitavad paremini aru saada, kuidas tabeli ridu unikaalselt tuvastada.

---

## Kasutatud allikad

* Microsoft Learn - Primary and Foreign Key Constraints
  https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints

* Microsoft Learn - Unique Constraints
  https://learn.microsoft.com/en-us/sql/relational-databases/tables/unique-constraints-and-check-constraints

* W3Schools - SQL Primary Key
  https://www.w3schools.com/sql/sql_primarykey.asp

* W3Schools - SQL Foreign Key
  https://www.w3schools.com/sql/sql_foreignkey.asp

* W3Schools - SQL Unique
  https://www.w3schools.com/sql/sql_unique.asp


<img width="532" height="413" alt="Снимок экрана 2026-06-19 074618" src="https://github.com/user-attachments/assets/737be006-4d8b-45d7-a427-935d1b50fcb3" />
<img width="593" height="375" alt="image" src="https://github.com/user-attachments/assets/07b61bd5-c425-48f3-b9ca-7963aaf1df48" />
<img width="1311" height="177" alt="image" src="https://github.com/user-attachments/assets/2e418c0f-723b-47f0-9b4a-5e962250d243" />
<img width="411" height="387" alt="image" src="https://github.com/user-attachments/assets/1970725d-1297-4e9d-af8b-5f19bda381fa" />
<img width="1247" height="203" alt="image" src="https://github.com/user-attachments/assets/4d1a9df8-913a-45e4-a9c3-7cbeab63c6c8" />
<img width="360" height="386" alt="image" src="https://github.com/user-attachments/assets/964692a6-0acc-409e-a024-be6f493201b6" />
<img width="1192" height="252" alt="image" src="https://github.com/user-attachments/assets/a5c93748-8536-4757-b7d0-002cb8058f10" />
<img width="455" height="446" alt="image" src="https://github.com/user-attachments/assets/bfe5e44b-e6e4-49fb-be85-e9849fcc5a5d" />
<img width="1240" height="242" alt="image" src="https://github.com/user-attachments/assets/d2196755-49f9-4be5-9071-447c3fe8df97" />
<img width="390" height="346" alt="image" src="https://github.com/user-attachments/assets/c1192dad-e741-4bab-9e27-fccb17f9c661" />
<img width="540" height="400" alt="image" src="https://github.com/user-attachments/assets/b5710696-03b3-41c0-b158-ff6385d0688b" />
<img width="1131" height="247" alt="image" src="https://github.com/user-attachments/assets/033650a1-f03f-4b69-85b5-5873fb7e1fb0" />
<img width="632" height="995" alt="image" src="https://github.com/user-attachments/assets/ffbb682b-4927-43f3-86de-2c0eb2a98799" />
<img width="436" height="522" alt="image" src="https://github.com/user-attachments/assets/52af0e17-12d3-4faa-9329-a6e5ce14dfd6" />
<img width="450" height="486" alt="image" src="https://github.com/user-attachments/assets/0a9fcf29-8167-4836-9f75-9f95095502d9" />




