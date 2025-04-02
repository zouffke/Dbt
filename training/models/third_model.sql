{{ config(materialized='view') }}

{%- set statuses = dbt_utils.get_column_values(
    table=source('jaffle_shop', 'shop_orders'),
    column='status'
) -%}

SELECT EXTRACT(MONTH FROM o.ORDER_DATE) AS month,
    {% for status in statuses -%}
    	SUM(CASE WHEN o.STATUS = '{{ status }}' THEN 1 ELSE 0 END) AS amount_{{ status }}{{ "," if not loop.last }}
    {% endfor -%}
FROM jaffle_shop.shop_orders o
GROUP BY 1
ORDER BY 1