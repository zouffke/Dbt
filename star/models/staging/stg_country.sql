WITH countries AS (SELECT name,
                          region,
                          `sub-region` AS sub_region,
                          `alpha-2`    AS alpha_2,
                          `alpha-3`    AS alpha_3
                   FROM {{ ref('seed_country_codes') }}),
     countries_sk AS (SELECT ROW_NUMBER() OVER () - 1 AS SK, *
                      FROM countries)
SELECT *
FROM countries_sk