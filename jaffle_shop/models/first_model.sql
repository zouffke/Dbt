{{ config(materialized='table') }}


SELECT CONCAT(FIRST_NAME,'',LAST_NAME) AS FULL_NAME,
       ORDER_DATE,
       STATUS
FROM datasightdev.jaffle_shop.shop_orders a
INNER JOIN datasightdev.jaffle_shop.shop_customers b ON a.USER_ID = b.ID