-- Purpose: Staging model for claim data.
{{ config(materialized='view') }}
select
    ROW_WID,
    INTEGRATION_ID,
    NEW_BUR
from {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}