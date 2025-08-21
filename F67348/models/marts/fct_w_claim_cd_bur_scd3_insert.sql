-- Purpose: Represents the final model for INSERT operations.
{{ config(materialized='table') }}
SELECT *
FROM {{ ref('int_rtr_clm_insert_upd') }}
WHERE o_Flag = 'I'