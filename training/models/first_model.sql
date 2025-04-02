SELECT CONCAT(c.FIRST_NAME, ' ', c.LAST_NAME) AS name,
       o.ORDER_DATE,
       o.STATUS
FROM jaffle_shop.shop_customers c
         INNER JOIN jaffle_shop.shop_orders o ON c.ID = o.USER_ID