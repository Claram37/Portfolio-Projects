SELECT * 
FROM realestateunitedstates;

Create Table realestateus
like realestateunitedstates;

insert into realestateus
select *
from realestateunitedstates;

select * 
from realestateus;

Alter table realestateus
rename column `Year` to sales_year;

Alter table realestateus
rename column `Month` to sales_month;

select distinct region
from realestateus;

SELECT @@sql_mode;

SET sql_mode = '';

ALTER TABLE realestateus
ADD COLUMN sales_date DATE;

update realestateus
SET sales_date = STR_TO_DATE(CONCAT(sales_month, ' ', CAST(sales_year AS CHAR(4)), '01'), '%M %Y %d');

select *
from realestateus;

CREATE TABLE HomeSales (
    Year INT,
    Month VARCHAR(20),
    Region VARCHAR(20),
    HomeSize VARCHAR(10),
    AverageSalesPrice INT,
    NumHouseholds INT,
    MedianIncomeCurrent INT,
    MedianIncome2022 INT,
    MeanIncomeCurrent INT,
    MeanIncome2022 INT
);

Alter table homesales
add column sales_date date;

INSERT INTO HomeSales
select *
from realestateus;

select *
from homesales;

-- Total sales per region
SELECT Region, SUM(AverageSalesPrice) AS TotalSales
FROM homesales
GROUP BY Region
order by TotalSales desc;

-- average sales per region 
SELECT Year, Month, Region, AVG(AverageSalesPrice) AS Avg_Sales_Price
FROM homesales
GROUP BY Year, Month, Region
order by Avg_Sales_Price desc;

SELECT Year, Region, AVG(AverageSalesPrice) AS Avg_Sales_Price
FROM homesales
GROUP BY Year, Region
order by Avg_Sales_Price desc;

SELECT Region, AVG(AverageSalesPrice) AS Avg_Sales_Price
FROM homesales
GROUP BY Region
order by Avg_Sales_Price desc;

-- Highest Average sales by region
SELECT Year, Month, Region, MAX(AverageSalesPrice) AS Max_Sales_Price
FROM homesales
GROUP BY Year, Month, Region
order by Max_Sales_Price desc;

SELECT Region, MAX(AverageSalesPrice) AS Max_Sales_Price
FROM homesales
GROUP BY Region
order by Max_Sales_Price desc;

-- total number of households in each region
SELECT Year, Month, Region, SUM(NumHouseholds) AS Total_Households
FROM homesales
GROUP BY Year, Month, Region
order by Total_Households desc;

SELECT Region, SUM(NumHouseholds) AS Total_Households
FROM homesales
GROUP BY Region
order by Total_Households desc;

-- Region with the highest median income
SELECT Year, Month, Region, MAX(MedianIncomeCurrent) AS Max_Median_Income
FROM homesales
GROUP BY Year, Month, Region
order by Max_Median_Income desc;

SELECT Region, MAX(MedianIncomeCurrent) AS Max_Median_Income
FROM homesales
GROUP BY Region
order by Max_Median_Income desc;

-- Average income per year
SELECT Year, AVG(MeanIncomeCurrent) AS Avg_Income
FROM homesales
GROUP BY Year
order by Avg_Income desc;

-- total sales per month each year
SELECT Year, Month, SUM(AverageSalesPrice) AS Total_Sales
FROM homesales
GROUP BY Year, Month;

-- Average sales price for each home size in each region
SELECT Year, Month, Region, HomeSize, AVG(AverageSalesPrice) AS Avg_Sales_Price
FROM homesales
GROUP BY Year, Month, Region, HomeSize
order by Avg_Sales_Price desc;

-- Median and mean income for each region per month
SELECT Year, Month, Region, AVG(MedianIncomeCurrent) AS Avg_Median_Income, AVG(MeanIncomeCurrent) AS Avg_Mean_Income
FROM homesales
GROUP BY Year, Month, Region;

-- Median and mean income for each region
SELECT Region, AVG(MedianIncomeCurrent) AS Avg_Median_Income, AVG(MeanIncomeCurrent) AS Avg_Mean_Income
FROM homesales
GROUP BY Region;

-- region with total highest sales per month
SELECT Year, Month, Region, SUM(AverageSalesPrice) AS Total_Sales
FROM homesales
GROUP BY Year, Month, Region
ORDER BY Total_Sales DESC;

SELECT Month, Region, SUM(AverageSalesPrice) AS Total_Sales
FROM homesales
GROUP BY Month, Region
ORDER BY Total_Sales DESC;

SELECT Region, SUM(AverageSalesPrice) AS Total_Sales
FROM homesales
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Total sales per year
SELECT Year, SUM(AverageSalesPrice) AS Total_Sales
FROM homesales
GROUP BY Year
order by Total_sales desc;

-- Average income per month per region
SELECT Region, Month, AVG(MedianIncomeCurrent) AS AvgIncome
FROM homesales
GROUP BY Region, Month;

-- percentage mean income change
SELECT Region, AVG((MeanIncomeCurrent - MeanIncome2022) / MeanIncome2022 * 100) AS MeanIncomeChangePercentage
FROM homesales
GROUP BY Region;

SELECT Region, SUM(AverageSalesPrice) AS TotalSales
FROM homesales
GROUP BY Region
order by TotalSales;

-- Average Sales Price where homesize is single
SELECT Region, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
WHERE TRIM(HomeSize) = TRIM('Single')
GROUP BY Region
ORDER BY AvgSalesPrice DESC;

-- Average Sales Price where homesize is double
SELECT Region, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
WHERE TRIM(HomeSize) = TRIM('Double')
GROUP BY Region
ORDER BY AvgSalesPrice DESC;

-- Average Sales Price where homesize is total1
SELECT Region, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
WHERE TRIM(HomeSize) = TRIM('Total1')
GROUP BY Region
ORDER BY AvgSalesPrice DESC;

-- Average Sales Price by region
SELECT Region, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
GROUP BY Region
ORDER BY AvgSalesPrice DESC;
select * 
from homesales;

SELECT *
FROM homesales
WHERE AverageSalesPrice > 100000;

SELECT Region, COUNT(*)
FROM homesales
WHERE TRIM(HomeSize) = TRIM('Single')
GROUP BY Region;

-- Total sales price
SELECT Year, Month, SUM(AverageSalesPrice) AS TotalSalesPrice
FROM homesales
GROUP BY Year, Month;

-- Total sales price from January to december for all years
SELECT Month, SUM(AverageSalesPrice) AS TotalSalesPrice
FROM homesales
GROUP BY Month
ORDER BY
    CASE
        WHEN Month = 'January' THEN 1
        WHEN Month = 'February' THEN 2
        WHEN Month = 'March' THEN 3
        WHEN Month = 'April' THEN 4
        WHEN Month = 'May' THEN 5
        WHEN Month = 'June' THEN 6
        WHEN Month = 'July' THEN 7
        WHEN Month = 'August' THEN 8
        WHEN Month = 'September' THEN 9
        WHEN Month = 'October' THEN 10
        WHEN Month = 'November' THEN 11
        ELSE 12
    END;

-- maximum median income by region
SELECT Region, MAX(MedianIncome2022) AS MaxMedianIncome
FROM homesales
GROUP BY Region
ORDER BY MaxMedianIncome DESC
LIMIT 3;

-- Average number of households for each homesize
SELECT HomeSize, AVG(NumHouseholds) AS AvgHouseholds
FROM homesales
GROUP BY HomeSize;

-- total number of households exceed 50000 in the south region
SELECT Year, Month
FROM homesales
WHERE Region = 'South' AND NumHouseholds > 50000;

-- Top 3 regions with the highest sales of single homes
SELECT Region, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
WHERE trim(HomeSize) = trim('Single')
GROUP BY Region
ORDER BY AvgSalesPrice DESC
LIMIT 3;

-- month with the highest sales
SELECT Month, SUM(AverageSalesPrice) AS TotalSalesPrice
FROM homesales
GROUP BY Month
ORDER BY TotalSalesPrice DESC
LIMIT 1;

-- number of records each month and year
SELECT Year, Month, COUNT(*) AS NumRecords
FROM homesales
GROUP BY Year, Month;

-- region, homesize and average sales price
SELECT Region, HomeSize, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
GROUP BY Region, HomeSize;

-- number of households and sales price  in each region in specific years
SELECT Year, Region, SUM(NumHouseholds) AS TotalHouseholds, SUM(AverageSalesPrice) AS TotalSalesPrice
FROM homesales
GROUP BY Year, Region;

-- sales contribution of each region to total sales across the ears
SELECT Region, SUM(AverageSalesPrice) / (SELECT SUM(AverageSalesPrice) FROM homesales) * 100 AS SalesContributionPercentage
FROM homesales
GROUP BY Region
order by SalesContributionPercentage desc;

-- region where the average sales price is higher than the overall average sales price across all regions:
SELECT Region, AVG(AverageSalesPrice) AS AvgRegionSalesPrice
FROM homesales
GROUP BY Region
HAVING AVG(AverageSalesPrice) > (SELECT AVG(AverageSalesPrice) FROM homesales);

-- average sales price for each region in the year 2022
SELECT Region, AVG(AverageSalesPrice) AS AvgSalesPrice
FROM homesales
WHERE Year = (SELECT MAX(Year) FROM homesales)
GROUP BY Region;



-- regions where the average sales price is within one standard deviation of the overall average sales price across all regions:
WITH RegionAvg AS (
    SELECT Region, AVG(AverageSalesPrice) AS AvgRegionSalesPrice
    FROM homesales
    GROUP BY Region
)
SELECT Region, AvgRegionSalesPrice
FROM RegionAvg
WHERE AvgRegionSalesPrice BETWEEN 
    (SELECT AVG(AverageSalesPrice) - STDDEV_POP(AverageSalesPrice) FROM homesales) 
    AND 
    (SELECT AVG(AverageSalesPrice) + STDDEV_POP(AverageSalesPrice) FROM homesales);


SELECT hd1.Year, hd1.Month, hd1.Region, hd1.MedianIncomeCurrent, hd1.MedianIncome2022, (hd1.MedianIncomeCurrent - COALESCE(hd2.MedianIncomeCurrent)) AS Income_Change
FROM homesales hd1
left JOIN homesales hd2 ON hd1.Region = hd2.Region AND hd1.Year = hd2.Year AND hd1.Month = hd2.Month + 1;