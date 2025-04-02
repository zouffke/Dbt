{% set status = ["placed","shipped","returned","completed","return_pending"]  %}

SELECT
    EXTRACT(MONTH FROM ORDER_DATE) AS month,
    {% for status in statuses %}
    SUM(CASE WHEN STATUS = '{{ status }}' THEN 1 ELSE 0 END) AS amount_{{ status }},
    {% endfor %}
FROM jaffle_shop.shop_orders
GROUP BY 1 ORDER BY 1