SELECT TOP (1000) [product_title]
      ,[product_price]
      ,[product_star_rating]
      ,[product_num_ratings]
      ,[rank]
      ,[country]
  FROM [DataAnalysis].[dbo].[amazonUS]


SELECT *
FROM dbo.amazonUS


(--glance at the NOT NULL product_price data)
SELECT *
FROM dbo.amazonUS
WHERE product_price IS NOT NULL;

(--Remove rows which has NULL VALUE on product--)
DELETE FROM dbo.amazonUS
WHERE product_price IS NULL;

-- Deletes rows where Country is not 'US'
SELECT *
FROM dbo.amazonUS
WHERE country != 'US';

SELECT *
FROM dbo.amazonUS

DELETE FROM dbo.amazonUS
WHERE country != 'US'; 

(--glancing at the unique products)

SELECT DISTINCT product_title, product_price, product_star_rating, product_num_ratings, rank, country
FROM dbo.amazonUS;

(-- removing duplicates)
SELECT product_title, COUNT(*) AS count
FROM dbo.amazonUS
GROUP BY product_title
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY product_title
            ORDER BY (SELECT NULL) 
        ) AS row_num
    FROM dbo.amazonUS
)
DELETE FROM CTE
WHERE row_num > 1;

SELECT *
FROM dbo.amazonUS

SELECT * FROM dbo.amazonUS
ORDER BY product_title ASC;
-- Removing remaining NULL value
UPDATE dbo.amazonUS
SET product_star_rating = ISNULL(product_star_rating, 0)
WHERE product_star_rating IS NULL

UPDATE dbo.amazonUS
SET product_num_ratings = ISNULL(product_num_ratings, 0)
WHERE product_num_ratings IS NULL

-- Deleting multiple rows with [Old Version] title--
UPDATE dbo.amazonUS 
SET product_title = REPLACE(product_title, '[Old Version]', '')

SELECT *
FROM dbo.amazonUS








