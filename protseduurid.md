[Põhimõisted](readme.md) | [Kasutajad](Kasutaja.md) | [Trigerid](triger.md) | [Protseduurid](protseduurid.md)| [Keys](Keys.md)

## Sissukord

* [SQL protseduur](#sql-protseduur)
* [Hindeline ülesanne](#hindeline-ülesanne)
* [Hindeline ülesanne XAMPP](#hindeline-ülesanne-xampp)

---

# SQL protseduur

Stored procedure ehk salvestatud protseduur on andmebaasis salvestatud SQL-käskude kogum. Seda saab kasutada korduvate tegevuste tegemiseks, näiteks andmete lisamiseks, muutmiseks, kustutamiseks või otsimiseks.

## Protseduur kategooria lisamiseks

```sql
CREATE PROCEDURE lisaKategooria
    @uusKategooria VARCHAR(30)
AS
BEGIN
    INSERT INTO categories(category_name)
    VALUES (@uusKategooria);

    SELECT * FROM categories;
END;
```

**SIIA LISA PILT: kategooria lisamise protseduur**

**SIIA LISA PILT: kategooria lisamise tulemus**

---

## Protseduur kategooria kustutamiseks

See protseduur kustutab kategooria ID järgi.

```sql
CREATE PROCEDURE kustutaKategooria
    @kustutaId INT
AS
BEGIN
    SELECT * FROM categories;

    DELETE FROM categories
    WHERE category_id = @kustutaId;

    SELECT * FROM categories;
END;
```

Protseduuri käivitamine:

```sql
EXEC kustutaKategooria 1;
```

---

## Protseduur otsimiseks tähe järgi

See protseduur otsib kategooriaid esimese tähe järgi.

```sql
CREATE PROCEDURE otsingitaht
    @taht CHAR(1)
AS
BEGIN
    SELECT * FROM categories
    WHERE category_name LIKE @taht + '%';
END;
```

Näide:

```sql
EXEC otsingitaht 'A';
```

---

## Tabel brands

```sql
CREATE TABLE brands (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name VARCHAR(15) UNIQUE
);

INSERT INTO brands(brand_name)
VALUES ('Nokia');

SELECT * FROM brands;
```

**SIIA LISA PILT: brands tabel**

---

## Tabel products

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(50) NOT NULL,
    brand_id INT,
    category_id INT,
    model_year INT,
    list_price MONEY,

    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

INSERT INTO products
VALUES ('nutitelefon 10', 1, 3, 2025, 500);

SELECT * FROM products;
```

**SIIA LISA PILT: products tabel**

---

## Protseduur tabeli muutmiseks

See protseduur kasutab `ALTER TABLE` käsku. Sellega saab tabelisse veeru lisada või veeru kustutada.

```sql
CREATE PROCEDURE muudatus
    @tegevus VARCHAR(10),
    @tabelinimi VARCHAR(25),
    @veerunimi VARCHAR(25),
    @tyyp VARCHAR(25) = NULL
AS
BEGIN
    DECLARE @sqltegevus VARCHAR(MAX);

    SET @sqltegevus = CASE
        WHEN @tegevus = 'add' THEN
            CONCAT('ALTER TABLE ', @tabelinimi, ' ADD ', @veerunimi, ' ', @tyyp)

        WHEN @tegevus = 'drop' THEN
            CONCAT('ALTER TABLE ', @tabelinimi, ' DROP COLUMN ', @veerunimi)
    END;

    PRINT @sqltegevus;
    EXEC (@sqltegevus);
END;
```

Näited:

```sql
EXEC muudatus 'add', 'categories', 'TestVeerg', 'int';

SELECT * FROM categories;

EXEC muudatus 'drop', 'categories', 'TestVeerg';
```

**SIIA LISA PILT: ALTER TABLE protseduuri tulemus**

---

# Hindeline ülesanne

## Algus

Töö alguses lõin uue andmebaasi ja kasutasin seda.

```sql
CREATE DATABASE ProtseduriMelnikov;
USE ProtseduriMelnikov;
```

Seejärel lõin tabeli `klient`.

```sql
CREATE TABLE klient (
    id INT PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(25) NOT NULL,
    linn VARCHAR(20),
    vanus INT,
    saldo MONEY
);
```

Lisasin tabelisse ühe kliendi.

```sql
INSERT INTO klient(nimi, linn, vanus, saldo)
VALUES ('Ada Vong', 'Tartu', 55, 14.8);
```

Tabeli vaatamiseks kasutasin:

```sql
SELECT * FROM klient;
```

**SIIA LISA PILT: klient tabel pärast andmete lisamist**

---

## Protseduur klientide kuvamiseks

See protseduur kuvab klientide nimed ja linnad.

```sql
CREATE PROCEDURE KuvaKliendid
AS
BEGIN
    SELECT nimi, linn
    FROM klient;
END;
```

Käivitamine:

```sql
EXEC KuvaKliendid;
```

**SIIA LISA PILT: KuvaKliendid tulemus**

---

## Protseduur kliendi lisamiseks

See protseduur lisab tabelisse uue kliendi.

```sql
CREATE PROCEDURE LisaKlient
    @nimi VARCHAR(23),
    @linn VARCHAR(20),
    @vanus INT,
    @saldo MONEY
AS
BEGIN
    INSERT INTO klient(nimi, linn, vanus, saldo)
    VALUES (@nimi, @linn, @vanus, @saldo);
END;
```

Käivitamine:

```sql
EXEC LisaKlient
    @nimi = 'Peeter Põld',
    @linn = 'Narva',
    @vanus = 40,
    @saldo = 120.00;
```

---

## Protseduur kliendi muutmiseks

See protseduur muudab kliendi linna ID järgi.

```sql
CREATE PROCEDURE MuudaKlient
    @id INT,
    @linn VARCHAR(100)
AS
BEGIN
    UPDATE klient
    SET linn = @linn
    WHERE id = @id;
END;
```

Käivitamine:

```sql
EXEC MuudaKlient
    @id = 5,
    @linn = 'Maardu';
```

**SIIA LISA PILT: kliendi andmed pärast muutmist**

---

## Protseduur kliendi kustutamiseks

See protseduur kustutab kliendi ID järgi.

```sql
CREATE PROCEDURE KustutaKlient
    @id INT
AS
BEGIN
    DELETE FROM klient
    WHERE id = @id;
END;
```

Käivitamine:

```sql
EXEC KustutaKlient @id = 4;
```

**SIIA LISA PILT: enne kustutamist**

**SIIA LISA PILT: pärast kustutamist**

---

## Protseduur kliendi otsimiseks

See protseduur otsib klienti nime alguse järgi.

```sql
CREATE PROCEDURE OtsiKlient
    @nimi VARCHAR(10)
AS
BEGIN
    SELECT *
    FROM klient
    WHERE nimi LIKE @nimi + '%';
END;
```

Käivitamine:

```sql
EXEC OtsiKlient @nimi = 'J';
```

**SIIA LISA PILT: otsingu tulemus**

**SIIA LISA PILT: otsingu tulemus ühe tähega**

---

## Protseduur kliendi tüübi kuvamiseks

See protseduur näitab, kas klient on hea klient või tavaklient.

```sql
CREATE PROCEDURE KuvaKliendiTyyp
AS
BEGIN
    SELECT
        id,
        nimi,
        saldo,
        CASE
            WHEN saldo > 100 THEN 'Hea klient'
            ELSE 'Tavaklient'
        END AS kliendi_tyyp
    FROM klient;
END;
```

Käivitamine:

```sql
EXEC KuvaKliendiTyyp;
```

---

# Hindeline ülesanne XAMPP

## Tabel klient

XAMPP-is kasutatakse `AUTO_INCREMENT`, mitte `IDENTITY`.

```sql
CREATE TABLE klient (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nimi VARCHAR(25) NOT NULL,
    linn VARCHAR(20),
    vanus INT,
    saldo DECIMAL(10,2)
);

INSERT INTO klient(nimi, linn, vanus, saldo)
VALUES ('Ada Vong', 'Tartu', 55, 14.80);
```

**SIIA LISA PILT: klient tabel XAMPP-is**
