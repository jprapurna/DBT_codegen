{{ config(materialized='table') }}
SELECT *
FROM {{ ref('int_auto_territory_mapping') }}