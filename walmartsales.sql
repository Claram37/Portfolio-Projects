SELECT * 
FROM walmartsales.walmart_sales;

UPDATE walmart_sales
SET `Date` = STR_TO_DATE(`Date`, '%d-%m-%Y');

Alter table walmart_sales
MODIFY COLUMN `Date` DATE;

ALTER TABLE walmart_sales 
MODIFY COLUMN CPI DECIMAL(10, 2);

DROP TABLE IF EXISTS sales_data;

CREATE TABLE sales_data (
    store_id INT,
    date DATE,
    sales DECIMAL(10, 2),
    promo_flag INT,
    temperature DECIMAL(5, 2),
    fuel_price DECIMAL(5, 3),
    CPI DECIMAL(10, 2),
    unemployment DECIMAL(5, 3)
);

insert into sales_data
SELECT * 
FROM walmartsales.walmart_sales;

select * 
from sales_data;

-- There are 143 sales data for store 1
SELECT * 
FROM sales_data 
WHERE store_id = 1;

SELECT * 
FROM sales_data 
WHERE date BETWEEN '2010-05-01' AND '2010-06-01';

-- total sales of each store in descending order
SELECT store_id, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY store_id
order by total_sales desc;

-- average temperature for each month in descending order
SELECT MONTH(date) AS month, AVG(temperature) AS avg_temperature
FROM sales_data
GROUP BY MONTH(date)
order by avg_temperature desc;

-- dates with promotions and high unemployment
SELECT * 
FROM sales_data 
WHERE promo_flag = 1 
AND unemployment > 8.0;

-- weeks with highest total sales
SELECT YEAR(date), WEEK(date) AS week, SUM(sales) AS total_sales
FROM sales_data
GROUP BY YEAR(date), WEEK(date)
ORDER BY total_sales DESC
LIMIT 5;

-- average sales for each store
SELECT store_id, AVG(sales) AS avg_sales
FROM sales_data
GROUP BY store_id;

-- retriving specific data
SELECT *
FROM sales_data
WHERE store_id = 1
AND date BETWEEN '2010-05-01' AND '2010-06-01';
  
-- maximun and minimum temperature recorded
SELECT MAX(temperature) AS max_temperature, MIN(temperature) AS min_temperature
FROM sales_data;

-- total sales for each month
SELECT YEAR(date) AS year, MONTH(date) AS month, SUM(sales) AS total_sales
FROM sales_data
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- dates with sales exceeding 2000000
SELECT date, sales
FROM sales_data
WHERE sales > 2000000; 

-- top 5 stores with highest total sales
SELECT store_id, SUM(sales) AS total_sales
FROM sales_data
GROUP BY store_id
ORDER BY total_sales DESC
LIMIT 5;

-- the most recent data 
SELECT *
FROM sales_data
ORDER BY date DESC
LIMIT 1;

-- Total sales for each year
SELECT YEAR(date) AS year, SUM(sales) AS total_sales
FROM sales_data
GROUP BY YEAR(date)
ORDER BY year;

-- average fuel price during holiday
SELECT AVG(fuel_price) AS avg_fuel_price
FROM sales_data
WHERE promo_flag = 1;

-- average sales per week per store
SELECT store_id, WEEK(date) as week, AVG(sales) AS avg_sales_per_week
FROM sales_data
GROUP BY store_id, week;

-- weekly trends in sales for a specific store
SELECT WEEK(date) AS week_number, SUM(sales) AS weekly_sales
FROM sales_data
WHERE store_id = '5'
GROUP BY WEEK(date);

-- yearly growth for a specific store
SELECT YEAR(date) AS year, SUM(sales) AS total_sales
FROM sales_data
WHERE store_id = '3'
GROUP BY YEAR(date);

-- Using subqueries to calculate average sales per week across all stores
SELECT AVG(weekly_sales) AS avg_sales_across_stores
FROM (
    SELECT store_id, WEEK(date) AS week_number, SUM(sales) AS weekly_sales
    FROM sales_data
    GROUP BY store_id, WEEK(date)
) AS subquery;

select *
from sales_data;

-- average sales per month for all stores
SELECT MONTH(date) AS month, AVG(sales) AS avg_sales
FROM sales_data
GROUP BY MONTH(date)
ORDER BY month;

-- performance of different stores by calculating total sales for each store and year
SELECT store_id, YEAR(date) AS year, SUM(sales) AS total_sales
FROM sales_data
GROUP BY store_id, YEAR(date)
ORDER BY store_id, year;

-- Calculating the coefficient of variation (CV) of weekly sales for each store to measure the variability in sales
SELECT store_id, 
       STDDEV(sales) / AVG(sales) AS coefficient_of_variation
FROM sales_data
GROUP BY store_id;

-- how temperature affects sales
SELECT AVG(temperature) AS avg_temperature, AVG(sales) AS avg_sales
FROM sales_data
GROUP BY DATE(date)
order by avg_sales desc ;

-- average sales for different temperature ranges to observe how sales vary with temperature
SELECT CASE
           WHEN temperature < 50 THEN 'Below 50°F'
           WHEN temperature < 60 THEN '50-59°F'
           WHEN temperature < 70 THEN '60-69°F'
           WHEN temperature < 80 THEN '70-79°F'
           ELSE 'Above 80°F'
       END AS temperature_range,
       AVG(sales) AS avg_sales
FROM sales_data
GROUP BY temperature_range;

-- relationship between temperature and sales over time
SELECT DATE(date) AS sales_date,
       temperature,
       SUM(sales) AS total_sales
FROM sales_data
GROUP BY sales_date, temperature
ORDER BY sales_date;

-- sales across different seasons
SELECT CASE
           WHEN MONTH(date) IN (12, 1, 2) THEN 'Winter'
           WHEN MONTH(date) IN (3, 4, 5) THEN 'Spring'
           WHEN MONTH(date) IN (6, 7, 8) THEN 'Summer'
           ELSE 'Fall'
       END AS season,
       AVG(temperature) AS avg_temperature,
       AVG(sales) AS avg_sales
FROM sales_data
GROUP BY season;

SELECT DAYNAME(date) AS day_of_week, SUM(sales) AS total_sales
FROM sales_data
GROUP BY day_of_week
ORDER BY total_sales DESC;

-- average growth rate
SELECT YEAR(date) AS sales_year, 
       AVG(sales) AS avg_sales,
       (AVG(sales) - LAG(AVG(sales), 1) OVER (ORDER BY YEAR(date))) / LAG(AVG(sales), 1) OVER (ORDER BY YEAR(date)) AS growth_rate
FROM sales_data
GROUP BY sales_year
ORDER BY sales_year;
















 





