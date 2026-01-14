/* =========================================================
   Candy Sales Analysis – GOLD LAYER VIEWS
   Database: MySQL 8
   Purpose : Reporting & Power BI
   ========================================================= */

USE candy_sales_analysis;

/* =========================================================
   Preview Clean Data
   ========================================================= */
SELECT *
FROM silver.candy_sales_clean
LIMIT 5;


/* =========================================================
   View: Sales Performance (MTD, YTD)
   ========================================================= */
DROP VIEW IF EXISTS gold_vw_sales_performance;

CREATE VIEW gold_vw_sales_performance AS
SELECT 
    CURDATE() AS Report_Date,

    SUM(Sales) AS Total_Sales_Revenue,
    SUM(Units) AS Total_Units_Sold,
    SUM(Gross_Profit) AS Total_Gross_Profit,

    -- Month-To-Date (MTD)
    SUM(CASE 
        WHEN MONTH(Order_Date) = MONTH(CURDATE())
         AND YEAR(Order_Date) = YEAR(CURDATE())
        THEN Sales ELSE 0 END) AS MTD_Sales,

    SUM(CASE 
        WHEN MONTH(Order_Date) = MONTH(CURDATE())
         AND YEAR(Order_Date) = YEAR(CURDATE())
        THEN Units ELSE 0 END) AS MTD_Units_Sold,

    -- Year-To-Date (YTD)
    SUM(CASE 
        WHEN YEAR(Order_Date) = YEAR(CURDATE())
        THEN Sales ELSE 0 END) AS YTD_Sales,

    SUM(CASE 
        WHEN YEAR(Order_Date) = YEAR(CURDATE())
        THEN Units ELSE 0 END) AS YTD_Units_Sold
FROM silver.candy_sales_clean;


/* =========================================================
   View: Monthly Sales Trend
   ========================================================= */
DROP VIEW IF EXISTS gold_vw_monthly_sales_trend;

CREATE VIEW gold_vw_monthly_sales_trend AS
SELECT 
    YEAR(Order_Date) AS `Year`,
    MONTH(Order_Date) AS `Month`,
    MONTHNAME(Order_Date) AS Month_Name,
    Division AS Product_Division,
    State_Province,
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Units) AS Total_Units,
    SUM(Gross_Profit) AS Total_Profit,
    ROUND(AVG(Cost), 2) AS Avg_Cost
FROM silver.candy_sales_clean
GROUP BY 
    YEAR(Order_Date),
    MONTH(Order_Date),
    MONTHNAME(Order_Date),
    Division,
    State_Province,
    Region;


/* =========================================================
   View: Top 10 Candies (MTD, QTD, YTD)
   ========================================================= */
DROP VIEW IF EXISTS gold_vw_top10_candies;

CREATE VIEW gold_vw_top10_candies AS
SELECT 
    Product_Name,

    -- Month-To-Date
    SUM(CASE 
        WHEN MONTH(Order_Date) = MONTH(CURDATE())
         AND YEAR(Order_Date) = YEAR(CURDATE())
        THEN Sales ELSE 0 END) AS MTD_Sales,

    -- Quarter-To-Date
    SUM(CASE 
        WHEN QUARTER(Order_Date) = QUARTER(CURDATE())
         AND YEAR(Order_Date) = YEAR(CURDATE())
        THEN Sales ELSE 0 END) AS QTD_Sales,

    -- Year-To-Date
    SUM(CASE 
        WHEN YEAR(Order_Date) = YEAR(CURDATE())
        THEN Sales ELSE 0 END) AS YTD_Sales,

    SUM(Gross_Profit) AS Total_Profit
FROM silver.candy_sales_clean
GROUP BY Product_Name
ORDER BY YTD_Sales DESC
LIMIT 10;


/* =========================================================
   View: Sales by Region
   ========================================================= */
DROP VIEW IF EXISTS gold_vw_sales_by_region;

CREATE VIEW gold_vw_sales_by_region AS
SELECT 
    Region,
    State_Province,
    SUM(Sales) AS Total_Sales,
    SUM(Units) AS Total_Units,
    SUM(Gross_Profit) AS Total_Profit
FROM silver.candy_sales_clean
GROUP BY Region, State_Province;


/* =========================================================
   View: Division Performance
   ========================================================= */
DROP VIEW IF EXISTS gold_vw_division_performance;

CREATE VIEW gold_vw_division_performance AS
SELECT 
    Division,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Gross_Profit), 2) AS Total_Profit,
    ROUND(AVG(Cost), 2) AS Avg_Cost_Per_Unit,
    ROUND((SUM(Gross_Profit) / NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin_Percent
FROM silver.candy_sales_clean
GROUP BY Division;


/* =========================================================
   View: Sales by City
   ========================================================= */
DROP VIEW IF EXISTS gold_vw_sales_by_city;

CREATE VIEW gold_vw_sales_by_city AS
SELECT 
    City,
    State_Province,
    SUM(Sales) AS Total_Sales,
    SUM(Units) AS Total_Units,
    ROUND(SUM(Gross_Profit), 2) AS Total_Profit
FROM silver.candy_sales_clean
GROUP BY City, State_Province;


/* =========================================================
   End of File
   ========================================================= */
