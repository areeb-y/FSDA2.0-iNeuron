USE DATABASE DEMO_DATABASE;

-- 1. Load the given dataset into snowflake with a primary key to Order Date column.

CREATE OR REPLACE TABLE AY_SALES_DATA
    (
  order_id VARCHAR(20),
  order_date DATE PRIMARY KEY,
  ship_date DATE,
  ship_mode VARCHAR(20),
  customer_name VARCHAR(80),
  segment VARCHAR(40),
  state VARCHAR(60),
  country VARCHAR(40),
  market VARCHAR(40),
  region VARCHAR(40),
  product_id VARCHAR(40),
  category VARCHAR(40),
  sub_category VARCHAR(40),
  product_name VARCHAR(160),
  sales NUMBER(12,0),
  quantity NUMBER(12,0),
  discount NUMBER(10),
  profit NUMBER(10),
  shipping_cost FLOAT,
  order_priority VARCHAR(40),
  year NUMBER(5));
  
DESCRIBE TABLE AY_SALES_DATA; 
SELECT * FROM AY_SALES_DATA;

-- 2. Change the Primary key to Order Id Column.

ALTER TABLE AY_SALES_DATA
DROP PRIMARY KEY;

ALTER TABLE AY_SALES_DATA
ADD PRIMARY KEY(order_id);

-- --------------------------------

-- 3. Check the data type for Order date and Ship date and mention in what data type it should be?

DESCRIBE TABLE AY_SALES_DATA;

-- --------------------------------

-- 4. Create a new column called order_extract and extract the number after the last ‘–‘ from Order ID column.

SELECT * FROM AY_SALES_DATA;

ALTER TABLE AY_SALES_DATA
ADD COLUMN NUM_EXTRACT NUMBER(20);

SELECT order_id, SUBSTRING(order_id,9) AS NUM_EXTRACT FROM AY_SALES_DATA;

UPDATE AY_SALES_DATA 
SET NUM_EXTRACT = SUBSTRING(order_id,9);

SELECT NUM_EXTRACT FROM AY_SALES_DATA;

-- --------------------------------

-- 5. Create a new column called Discount Flag and categorize it based on discount. Use ‘Yes’ if the discount is greater than zero else ‘No’.

SELECT discount, discount_flag FROM AY_SALES_DATA;

SELECT discount,
CASE
    WHEN discount < 0 THEN 'YES'
    ELSE 'NO'
END AS discount_flag
FROM AY_SALES_DATA;

ALTER TABLE AY_SALES_DATA
ADD COLUMN discount_flag VARCHAR(10);

UPDATE AY_SALES_DATA
SET discount_flag = CASE
    WHEN discount < 0 THEN 'YES'
    ELSE 'NO'
END;

-- 6. Create a new column called process days and calculate how many days it takes for each order id to process from the order to its shipment.

SELECT DATEDIFF('DAY', order_date, ship_date) AS PROCESS_DAYS FROM AY_SALES_DATA;

ALTER TABLE AY_SALES_DATA
ADD COLUMN PROCESS_DAYS NUMBER(20);

UPDATE AY_SALES_DATA
SET PROCESS_DAYS = DATEDIFF('DAY', order_date,ship_date);

SELECT PROCESS_DAYS FROM AY_SALES_DATA;

/*
7. Create a new column called Rating and then based on the Process dates give
rating like given below.
a. If process days less than or equal to 3days then rating should be 5
b. If process days are greater than 3 and less than or equal to 6 then rating
should be 4
c. If process days are greater than 6 and less than or equal to 10 then rating
should be 3
d. If process days are greater than 10 then the rating should be 2.
*/

ALTER TABLE AY_SALES_DATA
ADD COLUMN RATING NUMBER(20);


SELECT PROCESS_DAYS,
CASE
    WHEN PROCESS_DAYS <= 3 THEN '5'
    WHEN PROCESS_DAYS > 3 AND PROCESS_DAYS <= 6 THEN '4'
    WHEN PROCESS_DAYS > 6 AND PROCESS_DAYS <= 10 THEN '3'
    ELSE '2'
END AS RATING
FROM AY_SALES_DATA;

UPDATE AY_SALES_DATA
SET RATING = CASE
    WHEN PROCESS_DAYS <= 3 THEN '5'
    WHEN PROCESS_DAYS > 3 AND PROCESS_DAYS <= 6 THEN '4'
    WHEN PROCESS_DAYS > 6 AND PROCESS_DAYS <= 10 THEN '3'
    ELSE '2'
END;


SELECT RATING FROM AY_SALES_DATA;
