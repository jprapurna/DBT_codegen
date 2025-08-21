-- Purpose: Represents the final model for UPDATE operations.
{{ config(materialized='table') }}
SELECT *
FROM {{ ref('int_rtr_clm_insert_upd') }}
WHERE o_Flag = 'U'