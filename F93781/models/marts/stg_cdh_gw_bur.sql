-- Purpose: Staging model for CDH Gateway BUR data.
{{ config(materialized='view') }}
select
    POLICY_STATE,
    BUR,
    {{ ref('state_geo_mapping') }} as SOURCE_NAME
from {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}