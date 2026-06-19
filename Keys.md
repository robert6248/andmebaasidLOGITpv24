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

Lisaks on tabeli struktuuris näha, et `kasutaja_id` juures on võtme märk.

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

Kui proovida lisada toitu kasutajale, kelle `kasutaja_id` on 4, tekib viga, sest sellist kasutajat tabelis `kasutaja` ei ole.

```sql
INSERT INTO toit
VALUES ('Sushi', 4);
```

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

Kui proovida lisada sama sõna uuesti, tekib Unique Key viga.

```sql
INSERT INTO sonaraamat
VALUES ('Auto');
```

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

Kui proovida lisada sama `looma_id` uuesti, tekib viga.

```sql
INSERT INTO loomad
VALUES (2, 'Hamster');
```

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

Kui proovida lisada sama kombinatsioon `(1, 1)` uuesti, tekib Primary Key viga.

```sql
INSERT INTO tellimus
VALUES (1, 1, 5);
```

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

Kui proovida lisada kombinatsioon, mida tabelis `opilane_kursus` ei ole, tekib Foreign Key viga.

```sql
INSERT INTO hinne
VALUES (1, 2, 5);
```

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

Selles tabelis on `tel_id` Primary Key. Teised unikaalsed veerud on Alternate Key näited.

---

## Kokkuvõte

Selles töös õppisin erinevaid andmebaasi võtmeid. Primary Key tuvastab tabelis iga rea. Foreign Key seob erinevaid tabeleid. Unique Key keelab korduvad väärtused. Simple Key koosneb ühest veerust, aga Composite Key ja Compound Key kasutavad mitut veergu. Superkey, Candidate Key ja Alternate Key aitavad paremini aru saada, kuidas tabeli ridu unikaalselt tuvastada.

---

##
