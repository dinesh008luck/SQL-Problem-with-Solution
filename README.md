# SQL-Problem-with-Solution
## Problem 1
/* Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
    - if custom1 = custom3 and custom2 = custom4 : then keep only one pair

- For pairs of brands in the same year 
    - if custom1 != custom3 OR custom2 != custom4 : then keep both pairs

- For brands that do not have pairs in the same year : keep those rows as well
*/

## Solution 1

WITH C AS (
SELECT *,
CASE WHEN brand1<brand2 THEN CONCAT(brand1,brand2,year) 
ELSE CONCAT(brand2, brand1, year) END AS PRAIRID
FROM brands),

D AS (
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY PRAIRID ORDER BY PRAIRID) AS ROWNO 
FROM C)
-- put condition 
SELECT * FROM D
WHERE ROWNO=1 or (custom1!=custom3 and custom2!=custom4)
;
