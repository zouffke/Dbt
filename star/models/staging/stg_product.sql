WITH products AS (
    SELECT
        ROW_NUMBER() OVER () - 1 AS SK,
        *
    FROM {{ ref('seed_chocolate_products') }}
)
SELECT
    *
FROM products