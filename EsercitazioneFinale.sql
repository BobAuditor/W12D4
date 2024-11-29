CREATE DATABASE ToysGroup;
USE ToysGroup;

CREATE TABLE Category (
ProductCategoryKey INT PRIMARY KEY
, ProductCategoryName VARCHAR (20) 
);

INSERT INTO Category
VALUES 
(1,		'Parole')
,(2,	'Logica')
,(3,	'Carte')
,(4,	'Disegno')
,(5,	'Memoria')
,(6,	'Strategia')
;

CREATE TABLE Region (
GeographyKey INT PRIMARY KEY
, CityName VARCHAR (20) 
, RegionName VARCHAR (20) 
, CountryName VARCHAR (20)
);

INSERT INTO Region
VALUES
(1,		'Roma',	'Lazio',	'Italia')
,(2,	'Siracusa',	'Sicilia',	'Italia')
,(3,	'Parigi',	'IleDeFrance',	'Francia')
,(4,	'Toronto',	'Ontario',	'Canada')
,(5,	'Dallas',	'Texas',	'StatiUniti')
,(6,	'Atene',	'Attica',	'Grecia')
,(7,	'Dublino',	'Leinster',	'Irlanda')
,(8,	'Amsterdam',	'Olanda',	'PaesiBassi')
,(9,	'Firenze', 	'Toscana',	'Italia')
,(10,	'LosAngeles',	'California',	'StatiUniti')
;

CREATE TABLE Product (
ProductKey INT PRIMARY KEY
, ProductName VARCHAR (20) 
, ProductCategoryKey INT
, UnitCost DECIMAL (10,2)
, UnitPrice DECIMAL (10,2)
, FOREIGN KEY (ProductCategoryKey) REFERENCES Category (ProductCategoryKey)
);

INSERT INTO Product
VALUES 
(1,	'Taboo',1,'10.9','25.1')
,(2,'Puzzle',2,'11.8','26.2')
,(3,'Dixit',3,'12.7','27.3')
,(4,'OkBoomer',3,'13.6','28.4')
,(5,'Pictionary',4,'14.5','29.5')
,(6,'Brain',5,'15.4','30.6')
,(7,'Risiko',6,'16.3','31.7')
,(8,'Cluedo',6,'17.2','32.8')
,(9,'DoYouMeme',3,'18.1','33.9')
,(10,'Monopoli',6,'19.9','34.1')
;

CREATE TABLE Sales (
SalesID INT PRIMARY KEY
,GeographyKey INT 
,ProductKey INT
,OrderDate DATE
,OrderQuantity SMALLINT
, FOREIGN KEY (GeographyKey) REFERENCES Region (GeographyKey)
, FOREIGN KEY (ProductKey) REFERENCES Product (ProductKey)
);

INSERT INTO Sales
VALUES
(1,		1,	10,	'2023-11-28'	,5)
,(2,	2,	10,	'2024-07-01'	,2)
,(3,	3,	2,	'2024-07-02'	,1)
,(4,	4,	3,	'2024-07-01'	,1)
,(5,	5,	4,	'2024-07-04'	,1)
,(6,	6,	5,	'2024-07-05'	,1)
,(7,	7,	6,	'2022-12-04'	,3)
,(8,	8,	7,	'2022-12-04'	,2)
,(9,	9,	8,	'2022-12-04'	,1)
,(10,	10,	9,	'2024-11-07'	,2)
,(11,	2,	7,	'2024-07-01'	,1)
,(12,	2,	10,	'2023-11-28'	,2)
,(13,	3,	7,	'2023-11-29'	,1)
,(14,	4,	10,	'2023-11-30'	,2)
,(15,	2,	7,	'2021-12-12'	,2)
,(16,	7,	7,	'2021-02-13'	,1)
,(17,	1,	10,	'2021-08-14'	,2)
,(18,	1,	10,	'2021-12-15'	,2)
,(19,	2,	7,	'2021-08-14'	,5)
,(20,	2,	7,	'2021-12-17'	,3)
;

-- Verificare che i campi identificati come PK siano univoci --

SELECT
count(ProductCategoryKey), ProductCategoryKey
FROM
Category
GROUP BY
ProductCategoryKey;

SELECT
count(ProductKey), ProductKey
FROM
Product
GROUP BY
ProductKey;

SELECT
count(GeographyKey), GeographyKey
FROM
Region
GROUP BY
GeographyKey;

SELECT
count(SalesID), SalesID
FROM
Sales
GROUP BY
SalesID;

-- Esporre l'elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno -- 

SELECT
ProductName AS NomeProdotto
,sum(OrderQuantity*UnitPrice) AS TotaleFatturato
,YEAR(OrderDate) AS Anno
FROM
Sales s
JOIN
Product p
ON s.ProductKey=p.ProductKey
GROUP BY
NomeProdotto
, Anno
;

-- Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente --

SELECT
CountryName AS Stato
,ProductName AS NomeProdotto
,sum(OrderQuantity*UnitPrice) AS TotaleFatturato
,YEAR(OrderDate) AS Anno
FROM
Sales s
JOIN
Product p
ON s.ProductKey=p.ProductKey
JOIN
Region r
ON s.GeographyKey=r.GeographyKey
GROUP BY 
Anno
,Stato
,NomeProdotto
ORDER BY
Anno
, TotaleFatturato DESC
;

-- Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?--

SELECT
ProductCategoryName AS Categoria
, sum(OrderQuantity) AS TotalePezziVenduti
FROM
Sales s
JOIN
Product p
ON s.ProductKey=p.ProductKey
JOIN
Category c
ON p.ProductCategoryKey=c.ProductCategoryKey
GROUP BY
Categoria
ORDER BY
TotalePezziVenduti DESC
;

-- Quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti --

-- PRIMO APPROCCIO--

SELECT
ProductName AS NomeProdotto
, OrderQuantity AS Quantità
, OrderQuantity*UnitPrice AS Fatturato
FROM
Product p
LEFT JOIN
Sales s
ON p.ProductKey=s.ProductKey
WHERE
OrderQuantity IS NULL
;

-- SECONDO APPROCCIO: SUBQUERY--
SELECT
ProductName AS NomeProdotto
FROM
Product
WHERE 
ProductKey NOT IN (SELECT 
						ProductKey
                        FROM 
                        Sales)
                        ;

-- Esporre l'elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente)--

SELECT
ProductName AS NomeProdotto
, max(OrderDate) AS DataOrdine
FROM
Sales s
JOIN
Product p
ON s.ProductKey=p.ProductKey
GROUP BY
ProductName
;