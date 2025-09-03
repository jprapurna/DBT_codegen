{{
  config(
    materialized='table'
  )
}}

SELECT *
FROM {{ ref('int_abc__bal_row_counts') }}