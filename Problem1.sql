/* Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
    - if custom1 = custom3 and custom2 = custom4 : then keep only one pair

- For pairs of brands in the same year 
    - if custom1 != custom3 OR custom2 != custom4 : then keep both pairs

- For brands that do not have pairs in the same year : keep those rows as well
*/


DROP TABLE IF EXISTS brands;
CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);
INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);




SELECT * FROM brands;
--Step make pair id 

SELECT * , CONCAT(brand1,brand2,year) AS PAIR_Id
FROM brands;

--get same pairid even if brand1 and brand2 are intercahnge

SELECT *, CONCAT(brand1,brand2,year) AS PAIR_Id,
case when brand1 < brand2 then CONCAT(brand1,brand2,year) else CONCAT(brand2,brand1,year) end as pairid
FROM brands;


WITH CTC1 AS (

SELECT *,
CASE WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year) ELSE CONCAT(brand2, brand1, year) END AS PAIRID
FROM brands),
--- use 2nd ctc
CTC2 AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY PAIRID ORDER BY PAIRID) AS ROWNO
FROM CTC1
)

SELECT * FROM CTC2;

-- Final output with 2nd condition 

WITH C AS (
SELECT *,
CASE WHEN brand1<brand2 THEN CONCAT(brand1,brand2,year) ELSE CONCAT(brand2, brand1, year) END AS PRAIRID

FROM brands),

D AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY PRAIRID ORDER BY PRAIRID) AS ROWNO
FROM C)
-- put condition 
SELECT * FROM D
WHERE ROWNO=1 or (custom1!=custom3 and custom2!=custom4)
;

