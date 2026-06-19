# Protseduurid

[Põhimõisted](readme.md) | [Kasutajad](Kasutaja.md) | [Trigerid](triger.md) | [Protseduurid](protseduurid.md) | [Keys](Keys.md)

---

## Sisukord

* [SQL protseduur](#sql-protseduur)
* [Kategooriate protseduurid](#kategooriate-protseduurid)
* [Brands ja products tabelid](#brands-ja-products-tabelid)
* [Tabeli muutmise protseduur](#tabeli-muutmise-protseduur)
* [Hindeline ülesanne SQL Serveris](#hindeline-ülesanne-sql-serveris)
* [Hindeline ülesanne XAMPP-is](#hindeline-ülesanne-xampp-is)

---

# SQL protseduur

Stored procedure ehk salvestatud protseduur on andmebaasis salvestatud SQL-käskude kogum. Protseduuri kasutatakse siis, kui sama tegevust on vaja teha mitu korda.

Protseduuriga saab näiteks:

* lisada andmeid;
* kustutada andmeid;
* muuta andmeid;
* otsida andmeid;
* muuta tabeli struktuuri.

Protseduuri eelis on see, et kõiki SQL-käske ei pea iga kord uuesti kirjutama. Piisab protseduuri käivitamisest.

---

# Kategooriate protseduurid

## Protseduur kategooria lisamiseks

See protseduur lisab tabelisse `categories` uue kategooria. Uus kategooria antakse protseduurile parameetrina.

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

Protseduuri käivitamine:

```sql
EXEC lisaKategooria 'Telefonid';
```

### Tulemus

---

## Protseduur kategooria kustutamiseks

See protseduur kustutab kategooria ID järgi. Enne ja pärast kustutamist kuvatakse tabeli sisu.

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

### Tulemus

---

## Protseduur otsimiseks tähe järgi

See protseduur otsib kategooriaid esimese tähe järgi. Näiteks saab otsida kõik kategooriad, mis algavad tähega `A`.

```sql
CREATE PROCEDURE otsingitaht
    @taht CHAR(1)
AS
BEGIN
    SELECT * FROM categories
    WHERE category_name LIKE @taht + '%';
END;
```

Protseduuri käivitamine:

```sql
EXEC otsingitaht 'A';
```

### Tulemus

---

# Brands ja products tabelid

## Tabel brands

Tabel `brands` salvestab brändide nimed. Veerg `brand_id` on primaarvõti ja `brand_name` peab olema unikaalne.

```sql
CREATE TABLE brands (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name VARCHAR(15) UNIQUE
);

INSERT INTO brands(brand_name)
VALUES ('Nokia');

SELECT * FROM brands;
```

### Tulemus

---

## Tabel products

Tabel `products` salvestab toodete andmed. Selles tabelis on kaks võõrvõtit:

* `brand_id` viitab tabelile `brands`;
* `category_id` viitab tabelile `categories`.

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

### Tulemus

---

# Tabeli muutmise protseduur

See protseduur kasutab `ALTER TABLE` käsku. Selle abil saab tabelisse lisada uue veeru või kustutada olemasoleva veeru.

Protseduur kasutab dünaamilist SQL-i, sest tabeli nimi ja veeru nimi antakse parameetritena.

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

Veeru lisamine:

```sql
EXEC muudatus 'add', 'categories', 'TestVeerg', 'int';

SELECT * FROM categories;
```

Veeru kustutamine:

```sql
EXEC muudatus 'drop', 'categories', 'TestVeerg';
```

### Tulemus

---

# Hindeline ülesanne SQL Serveris

## Andmebaasi ja tabeli loomine

Töö alguses lõin uue andmebaasi ja valisin selle kasutamiseks.

```sql
CREATE DATABASE ProtseduurRobert;
USE ProtseduurRobert;
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

SELECT * FROM klient;
```

### Tulemus

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

Kontroll:

```sql
SELECT * FROM klient;
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

SELECT * FROM klient;
```

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

SELECT * FROM klient;
```

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

---

## Protseduur kliendi tüübi kuvamiseks

See protseduur näitab saldo järgi, kas klient on hea klient või tavaklient.

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

# Hindeline ülesanne XAMPP-is

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

SELECT * FROM klient;
```

---

# Kokkuvõte

Selles töös õppisin kasutama SQL protseduure andmete lisamiseks, muutmiseks, kustutamiseks ja otsimiseks. Samuti õppisin looma protseduure, mis muudavad tabeli struktuuri ning kasutavad parameetreid ja dünaamilist SQL-i.

Lisaks sain aru erinevusest SQL Serveri ja XAMPP/MySQL-i vahel: SQL Serveris kasutatakse automaatse ID loomiseks `IDENTITY`, samas kui MySQL-is kasutatakse `AUTO_INCREMENT`.
