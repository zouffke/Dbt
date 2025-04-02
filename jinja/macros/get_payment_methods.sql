{#Static list#}
{#---------#}
{#
{% macro get_payment_methods() %}
{{ return(["bank_transfer", "credit_card", "gift_card"]) }}
{% endmacro %}}
#}

{#Retrieve list dynamically#}
{#---------#}
{#Returns an Agate table#}
{#
{% macro get_payment_methods() %}
{% set payment_methods_query %}
SELECT distinct payment_method
FROM {{ ref('raw_payments') }} ORDEY BY 1
{% endset %}
    {% set results = run_query(payment_methods_query) %}
    {{ log(results, info=True) }}
{{ return([]) }}
{% endmacro %}
#}

{#
{% macro get_payment_methods() %}#}
{##}
{#{% set payment_methods_query %}#}
{#select distinct#}
{#payment_method#}
{#from {{ ref('raw_payments') }}#}
{#order by 1#}
{#{% endset %}#}
{##}
{#{% set results = run_query(payment_methods_query) %}#}
{##}
{#{% if execute %}#}
{# Return the first column #}
{#{% set results_list = results.columns[0].values() %}#}
{#{% else %}#}
{#{% set results_list = [] %}#}
{#{% endif %}#}
{##}
{#{{ return(results_list) }}#}
{##}
{#{% endmacro %}
#}

{#Modular macros#}
{#---------#}
{% macro get_column_values(column_name, relation) %}
    {% set relation_query %}
        select distinct
            {{ column_name }}
        from {{ relation }}
        order by 1
    {% endset %}

    {% set results = run_query(relation_query) %}

    {% if execute %}
            {% set results_list = results.columns[0].values() %}
    {% else %}
            {% set results_list = [] %}
    {% endif %}

    {{ return(results_list) }}
{% endmacro %}

{% macro get_payment_methods() %}
    {{ return(get_column_values('payment_method', ref('raw_payments'))) }}
{% endmacro %}