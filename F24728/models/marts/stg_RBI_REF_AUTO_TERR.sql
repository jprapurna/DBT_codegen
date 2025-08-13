{{ config(materialized='view') }}

SELECT
"RBI_REF_AUTO_TERR" AS rbi_ref_auto_terr
FROM {{ source('POWER_CENTER', 'RBI_REF_AUTO_TERR') }}