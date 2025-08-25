{{ config(materialized='table') }}
SELECT *
FROM {{ ref('int_farmers_state_mapping') }}