## Trigger - päästik
### SQL triggerid on spetsiaalsed andmebaasi objektid, mis käivituvad automaatselt, kui toimub teatud sündmus (nt INSERT, UPDATE või DELETE).

Trigger lisatud kirjeid jälgimiseks tabelis “linnad” – INSERT
Jälgib andmete sisestamine tabelis linnad ja teeb vastava kirje tabelis logi
```sql
CREATE TRIGGER linnaLisamine
ON linnad --tabelinimi, mis on vaja jälgida
FOR INSERT
AS
INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
SELECT
GETDATE(),  --aeg
SYSTEM_USER, --kasutaja mis on sisselogitud serverisse
'on tehtud INSERT käsk',  --toiming
concat ('linn:', inserted.linnanimi, ', rahvaarv:', inserted.rahvaarv)  --andmed tabelisy linnad
FROM inserted;
```
<img width="1643" height="521" alt="{F8228776-0784-404D-91F7-1E7A3B3BBEB6}" src="https://github.com/user-attachments/assets/4740a03d-e7f5-4551-a063-a04ef58cb244" />

Delete triger
```sql
CREATE TRIGGER linnaKustutamine
ON linnad --tabelinimi, mis on vaja jälgida
FOR DELETE
AS
INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
SELECT
GETDATE(),  --aeg
SYSTEM_USER, --kasutaja mis on sisselogitud serverisse
'on tehtud DELETE käsk',  --toiming
concat ('linn:', deleted.linnanimi, ', rahvaarv:', deleted.rahvaarv)  --andmed tabelisy linnad
FROM deleted;

delete from linnad where linnID=3
```
<img width="563" height="180" alt="{16DE1A83-7BB8-42D7-ABF9-A142917E6D77}" src="https://github.com/user-attachments/assets/57a762fc-b1f8-4be3-aeed-7878461af8ae" />

Kombineerime INSERT ja DELETE triggerid
```sql
CREATE TRIGGER linnaLisaKustuta
ON linnad --tabelinimi, mis on vaja jälgida
FOR INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
	SELECT
	GETDATE(),  --aeg
	SYSTEM_USER, --kasutaja mis on sisselogitud serverisse
	'on tehtud INSERT käsk',  --toiming
	concat ('linn:', inserted.linnanimi, ', rahvaarv:', inserted.rahvaarv)  --andmed tabelisy linnad
	FROM inserted

	union all -- соединить все

	SELECT
	GETDATE(),  --aeg
	SYSTEM_USER, --kasutaja mis on sisselogitud serverisse
	'on tehtud DELETE käsk',  --toiming
	concat ('linn:', deleted.linnanimi, ', rahvaarv:', deleted.rahvaarv)  --andmed tabelisy linnad
	FROM deleted;
END;
```
Trigerid meie tabelis
<img width="198" height="163" alt="{172A794F-B89F-4810-A91C-A6696DC837CE}" src="https://github.com/user-attachments/assets/dc3d24c4-4dc5-43bb-9213-72a7666b22c5" />

<img width="911" height="363" alt="{42D1FBED-5ADE-42D4-98D1-323C2582AC85}" src="https://github.com/user-attachments/assets/4dc1b2f1-3615-4db0-a707-f40d19a9f2ce" />

UPDATE triger
```sql
CREATE TRIGGER linnaUuendamine
ON linnad --tabelinimi, mis on vaja jälgida
FOR UPDATE
AS
INSERT INTO logi(kuupaev, kasutaja, toiming, andmed)
SELECT
GETDATE(),  --aeg
SYSTEM_USER, --kasutaja mis on sisselogitud serverisse
'on tehtud UPDATE käsk',  --toiming
concat ('vanad andmed - linn:', deleted.linnanimi, ', rahvaarv:', deleted.rahvaarv,
', uued andmed - linn', inserted.linnanimi, ', rahvaarv -', inserted.rahvaarv)  --andmed tabelisy linnad
FROM deleted inner join inserted 
on deleted.linnID=inserted.linnID;
```
<img width="929" height="357" alt="{9B8D109A-4074-40F8-9558-AD4A9A9457E9}" src="https://github.com/user-attachments/assets/055a86c8-7df3-47b6-8c33-db8f432544a2" />

