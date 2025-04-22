WITH sale_ids AS (
    SELECT
        ROW_NUMBER() OVER () - 1 AS id,
        `Sales Person` as sales_person,
        Country as country,
        Product as product,
        `Date` as order_date,
        Amount as order_amount,
        `Boxes Shipped` as boxes_shipped
    FROM omni_training.`chocalate-sales`
),
correct_uk AS (
    SELECT
        id,
        CASE
            WHEN country = 'UK' THEN 'GBR'
            ELSE country
        END AS country
    FROM sale_ids
)
SELECT
    s.id,
    s.sales_person,
    uk.country,
    s.product,
    s.order_date,
    s.order_amount,
    s.boxes_shipped
FROM sale_ids s
LEFT JOIN correct_uk uk ON s.id = uk.id
