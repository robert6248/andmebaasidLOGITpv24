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

<img width="356" height="137" alt="image" src="https://github.com/user-attachments/assets/6bbea265-0e03-4e4d-85a1-ea5d0bfb4b56" />

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

<img width="321" height="265" alt="image" src="https://github.com/user-attachments/assets/ffa65c36-35cd-4822-ad59-ed422cacfd66" />

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

<img width="300" height="124" alt="image" src="https://github.com/user-attachments/assets/3787a3e3-34ca-4ed4-b096-511b4b4997dd" />

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

<img width="487" height="124" alt="image" src="https://github.com/user-attachments/assets/c9ceeed7-d283-4fed-970e-aa34ff82991f" />

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

<img width="531" height="246" alt="image" src="https://github.com/user-attachments/assets/5a2ba2f5-a4aa-4f48-83f5-5f9962d48ffb" />

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

<img width="576" height="179" alt="image" src="https://github.com/user-attachments/assets/0c364e5b-1a04-4d2b-92b2-5a8c25ebba4c" />

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

<img width="518" height="165" alt="image" src="https://github.com/user-attachments/assets/3fbb5fa8-b788-4667-bd7b-aa0d0bc5af40" />

---



