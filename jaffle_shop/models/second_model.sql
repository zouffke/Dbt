{{ config(materialized='incremental') }}

SELECT
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME,
    ORDER_DATE,
    STATUS
FROM
    datasightdev.jaffle_shop.shop_orders a
INNER JOIN
    datasightdev.jaffle_shop.shop_customers b
    ON a.USER_ID = b.ID

{% if not is_incremental() %}
WHERE
    EXTRACT(MONTH FROM a.ORDER_DATE) = (
        SELECT MIN(EXTRACT(MONTH FROM ORDER_DATE))
        FROM datasightdev.jaffle_shop.shop_orders
    )
{% endif %}

{% if is_incremental() %}
WHERE
    EXTRACT(MONTH FROM a.ORDER_DATE) = (
        SELECT EXTRACT(MONTH FROM MAX(ORDER_DATE))
        FROM {{ this }}
    ) + 1
{% endif %}
