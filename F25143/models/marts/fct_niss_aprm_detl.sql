{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_niss_aprm_detl') }}