----------------------
--- CREATE VIEW CALENDER
----------------------
CREATE VIEW gold.calendar
AS 
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_Calendar/',
                FORMAT = 'PARQUET'
            ) AS Quer1
-------------------------
--- CREATE VIEW CUSTOMERS
-------------------------
CREATE VIEW gold.customers
AS
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_Customers/',
                FORMAT = 'PARQUET' 
            ) AS QUER2
-------------------------
--- CREATE VIEW PRODUCTS
-------------------------
CREATE VIEW gold.products
AS
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_Products/',
                FORMAT = 'PARQUET' 
            ) AS QUER3
-------------------------
--- CREATE VIEW RETURNS
-------------------------
CREATE VIEW gold.returns
AS
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_Returns/',
                FORMAT = 'PARQUET' 
            ) AS QUER4
-------------------------
--- CREATE VIEW SALES
-------------------------
CREATE VIEW gold.sales
AS
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_Sales/',
                FORMAT = 'PARQUET' 
            ) AS QUER5;
-------------------------
--- CREATE VIEW SUBCATEGORY
-------------------------
CREATE VIEW gold.subcategory
AS
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_SubCategory/',
                FORMAT = 'PARQUET' 
            ) AS QUER6
-------------------------
--- CREATE VIEW TERRITORIES
-------------------------
CREATE VIEW gold.territories
AS
SELECT * FROM 
            OPENROWSET(
                BULK'https://awstoragedatalakepg.dfs.core.windows.net/silver/AdventureWorks_Territories/',
                FORMAT = 'PARQUET' 
            ) AS QUER7








