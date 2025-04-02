


/*

REPEATED CODE = BAD, easy to make mistakes. if another payment methods gets added, we need to change the query,
mistake prone.

select
order_id,
sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount,
sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount,
sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount,
sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1
*/

/*

This is better but still not great. If we add a new payment method, we need to change the query.

select
  order_id,
  {% for payment_method in ["bank_transfer", "credit_card", "gift_card"] %}
    sum(case when payment_method = '{{ payment_method }}' then amount end) as {{ payment_method }}_amount,
  {% endfor %}
  sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1

*/

/*

This is better because we add the payment methods in variables.

{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{% if not loop.last %},{% endif %}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1


*/

/*
{%- set payment_methods = get_payment_methods() -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1

*/
{%- set payment_methods = dbt_utils.get_column_values(
    table=ref('raw_payments'),
    column='payment_method'
) -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1
