{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_claims__exp_row_wid') }}