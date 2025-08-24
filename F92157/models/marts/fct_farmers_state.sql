{{ config(materialized='table') }}
SELECT
    FARMERS_STATE_CD,
    STATE_CODE
FROM {{ ref('int_farmers_state_mapping') }}