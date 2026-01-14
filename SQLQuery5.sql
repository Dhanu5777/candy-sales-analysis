

USE candy_sales_analysis;

/* =========================================================
   Table: silver_candy_sales_clean
   ========================================================= */
DROP TABLE IF EXISTS silver_candy_sales_clean;

CREATE TABLE silver_candy_sales_clean AS
SELECT DISTINCT
    DATE(`Order Date`) AS Order_Date,
    DATE(`Ship Date`) AS Ship_Date,
    TRIM(`Order ID`) AS Order_ID,
    `Customer ID` AS Customer_ID,
    TRIM(`Country/Region`) AS Country_Region,
    TRIM(City) AS City,
    TRIM(`State/Province`) AS State_Province,
    TRIM(`Postal Code`) AS Postal_Code,
    TRIM(Division) AS Division,
    TRIM(Region) AS Region,
    TRIM(`Product ID`) AS Product_ID,
    TRIM(`Product Name`) AS Product_Name,
    IFNULL(Sales, 0) AS Sales,
    IFNULL(Units, 0) AS Units,
    IFNULL(`Gross Profit`, 0) AS Gross_Profit,
    IFNULL(Cost, 0) AS Cost
FROM bronze.Candy_Sales
WHERE Sales > 0
  AND Units > 0;


/* =========================================================
   Table: silver_candy_factories_clean
   ========================================================= */
DROP TABLE IF EXISTS silver_candy_factories_clean;

CREATE TABLE silver_candy_factories_clean AS
SELECT DISTINCT
    TRIM(Factory) AS Factory,
    ROUND(Latitude, 6) AS Latitude,
    ROUND(Longitude, 6) AS Longitude
FROM bronze.candy_factories
WHERE Latitude IS NOT NULL
  AND Longitude IS NOT NULL;


/* =========================================================
   Table: silver_candy_product_clean
   ========================================================= */
DROP TABLE IF EXISTS silver_candy_product_clean;

CREATE TABLE silver_candy_product_clean AS
SELECT DISTINCT
    TRIM(Product_ID) AS Product_ID,
    TRIM(Product_Name) AS Product_Name,
    TRIM(Division) AS Division,
    TRIM(Factory) AS Factory,
    CAST(Unit_Price AS DECIMAL(10,2)) AS Unit_Price,
    CAST(Unit_Cost AS DECIMAL(10,2)) AS Unit_Cost,
    (Unit_Price - Unit_Cost) AS Profit_Per_Unit
FROM bronze.candy_product
WHERE Unit_Price > 0
  AND Unit_Cost > 0;


/* =========================================================
   Table: silver_candy_targets_clean
   ========================================================= */
DROP TABLE IF EXISTS silver_candy_targets_clean;

CREATE TABLE silver_candy_targets_clean AS
SELECT DISTINCT
    TRIM(Division) AS Division,
    Target
FROM bronze.candy_targets
WHERE Target > 0;


/* =========================================================
   Table: silver_candy_sales_supply_join
   Master table for GOLD analytics
   ========================================================= */
DROP TABLE IF EXISTS silver_candy_sales_supply_join;

CREATE TABLE silver_candy_sales_supply_join AS
SELECT 
    s.Order_ID,
    s.Order_Date,
    s.Ship_Date,
    s.Region,
    s.Country_Region,
    s.State_Province,
    s.City,
    s.Postal_Code,
    s.Division,
    p.Product_Name,
    p.Unit_Price,
    p.Unit_Cost,
    p.Profit_Per_Unit,
    s.Sales,
    s.Units,
    s.Gross_Profit,
    s.Cost,
    f.Factory,
    f.Latitude,
    f.Longitude,
    t.Target
FROM silver_candy_sales_clean s
LEFT JOIN silver_candy_product_clean p
    ON s.Product_ID = p.Product_ID
LEFT JOIN silver_candy_factories_clean f
    ON p.Factory = f.Factory
LEFT JOIN silver_candy_targets_clean t
    ON s.Division = t.Division;


/* =========================================================
   End of SILVER Layer Script
   ========================================================= */





