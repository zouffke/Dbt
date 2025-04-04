WITH date_range AS (
    SELECT
        DATE_TRUNC(MIN(date), MONTH) AS min_date,
        LAST_DAY(DATE_ADD(MIN(date), INTERVAL 10 YEAR), YEAR) AS max_date
    FROM `aertsjarne-dandoisluca-devlab`.omni_training.`chocalate-sales`
),
generated_dates AS (
    SELECT
        GENERATE_DATE_ARRAY(min_date, max_date) AS dates
    FROM date_range
),
date_rows AS (
    SELECT
        dates
    FROM generated_dates, generated_dates.dates as dates
),
sk_dates AS (
    SELECT
        ROW_NUMBER() OVER () - 1 AS SK,
        dates AS calendar_date
    FROM date_rows
),
date_info AS (
    SELECT
        SK,
        FORMAT_DATE('%Y%m%d', calendar_date) AS date_int,
        calendar_date,
        EXTRACT(YEAR FROM calendar_date) AS calendar_year,
        FORMAT_DATE('%B', calendar_date) AS calendar_month,
        EXTRACT(MONTH FROM calendar_date) AS month_of_year,
        FORMAT_DATE('%A', calendar_date) AS calendar_day,
        EXTRACT(DAYOFWEEK FROM calendar_date) AS day_of_week,
        MOD((EXTRACT(DAYOFWEEK FROM calendar_date) + 5), 7) + 1 AS day_of_week_start_monday,
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM calendar_date) < 7 AND EXTRACT(DAYOFWEEK FROM calendar_date) > 1
                THEN 'Y' ELSE 'N'
        END AS is_week_day,
        EXTRACT(DAY FROM calendar_date) AS day_of_month,
        CASE
            WHEN EXTRACT(DAY FROM calendar_date) = EXTRACT(DAY FROM LAST_DAY(calendar_date))
                THEN 'Y' ELSE 'N'
        END AS is_last_day_of_month,
        EXTRACT(DAYOFYEAR FROM calendar_date) AS day_of_year,
        EXTRACT(ISOWEEK FROM calendar_date) AS iso_week_of_year,
        EXTRACT(QUARTER FROM calendar_date) AS quarter_of_year
    FROM sk_dates
)
SELECT *
 FROM date_info