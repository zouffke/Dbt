WITH dim_country AS (
    SELECT *
    FROM {{ ref('dim_country') }}
),
dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
),
dim_product AS (
    SELECT *
    FROM {{ ref('dim_product') }}
),
stg_sale AS (
    SELECT *
    FROM {{ ref('stg_sale') }}
)
SELECT
    ROW_NUMBER() OVER () - 1 AS id,
    s.sales_person,
    c.SK as country_sk,
    p.SK as product_sk,
    d.SK as date_sk,
    s.order_amount,
    s.boxes_shipped
FROM stg_sale s
LEFT JOIN dim_country c ON LOWER(s.country) = LOWER(c.name) OR LOWER(s.country) = LOWER(c.alpha_2) OR LOWER(s.country) = LOWER(c.alpha_3)
LEFT JOIN dim_product p ON LOWER(s.product) = LOWER(p.product_name)
LEFT JOIN dim_date d ON s.order_date = d.calendar_date
