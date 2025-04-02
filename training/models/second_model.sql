{{ config(materialized='incremental') }}

SELECT EXTRACT(MONTH FROM o.ORDER_DATE) AS month_check,
       c.FIRST_NAME,
       c.LAST_NAME,
       o.ORDER_DATE,
       o.STATUS
FROM jaffle_shop.shop_orders o
         INNER JOIN jaffle_shop.shop_customers c ON o.USER_ID = c.ID

    {% if not is_incremental() %}
WHERE EXTRACT(MONTH FROM o.ORDER_DATE) = (SELECT MIN(EXTRACT(MONTH FROM ORDER_DATE)) FROM jaffle_shop.shop_orders)
    {% endif %}

    {% if is_incremental() %} WHERE EXTRACT(MONTH FROM o.ORDER_DATE) = (SELECT MAX(month_check) FROM {{ this }}) + 1
{% endif %}