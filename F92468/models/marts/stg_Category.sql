{{ config(materialized='view') }}

SELECT
*
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'Category') }}