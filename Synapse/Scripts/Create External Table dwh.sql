USE awdatabase;
CREATE EXTERNAL TABLE gold.dwh_extcustomers
WITH 
(
    LOCATION = 'dwh_extcustomers',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extcustomers;



CREATE EXTERNAL TABLE gold.dwh_extsales
WITH 
(
    LOCATION = 'dwh_extsales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extsales;

CREATE EXTERNAL TABLE gold.dwh_extcalendar
WITH 
(
    LOCATION = 'dwh_extcalendar',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extcalendar;


CREATE EXTERNAL TABLE gold.dwh_extproducts
WITH 
(
    LOCATION = 'dwh_extproducts',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extproducts;

CREATE EXTERNAL TABLE gold.dwh_extreturns
WITH 
(
    LOCATION = 'dwh_extreturns',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extreturns;

CREATE EXTERNAL TABLE gold.dwh_extsubcategory
WITH 
(
    LOCATION = 'dwh_extsubcategory',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extsubcategory;

CREATE EXTERNAL TABLE gold.dwh_extterritories
WITH 
(
    LOCATION = 'dwh_extterritories',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.extterritories;


