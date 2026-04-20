
CREATE VIEW rpt.vw_sales_analysis AS
SELECT 
    f.order_date,
    d.year,
    d.month,
    f.quantity,

    c.customer_name,
    c.gender,
    c.email,

    p.product_name,
    p.price,
    p.cost,

    t.region,
    t.country,
    t.continent

FROM dwh.fact_sales f

-- Customer
JOIN dwh.dim_customer c 
    ON f.customer_sk = c.customer_sk

-- Product
JOIN dwh.dim_product p 
    ON f.product_key = p.product_key

-- Territory
JOIN dwh.dim_territory t 
    ON f.territory_key = t.territory_key

-- Date (safe join)
LEFT JOIN dwh.dim_date d 
    ON f.order_date = d.date_key;

SELECT TOP 10 * FROM rpt.vw_sales_analysis;

drop view rpt.vw_sales_analysis 

