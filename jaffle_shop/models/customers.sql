WITH customers as (SELECT *
                   FROM {{ ref('stg_customers') }}),

     orders AS (SELECT *
                FROM {{ ref('stg_orders') }}),

     customer_orders AS (SELECT customer_id,
                                MIN(ORDER_DATE) as first_order_date,
                                MAX(ORDER_DATE) AS most_recent_order_date,
                                COUNT(order_id) as number_of_orders
                         FROM orders
                         GROUP BY 1),
     final as (SELECT customers.customer_id,
                      customers.FIRST_NAME,
                      customers.LAST_NAME,
                      customer_orders.first_order_date,
                      customer_orders.most_recent_order_date,
                      COALESCE(customer_orders.number_of_orders, 0) as number_of_orders
               FROM customers
                        LEFT JOIN customer_orders using (customer_id))

SELECT *
FROM final