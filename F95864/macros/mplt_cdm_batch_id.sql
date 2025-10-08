{% macro mplt_cdm_batch_id(source_name) %}
-- Derive maximum batch_id for a given source_name, with null handling
-- source: mapplet mplt_CDM_BATCH_ID
-- do not print or log anything here

with
    /* 1) Normalize inputs as CTE to enforce stable names and data types */
    input_data as (
        select 
            {{ source_name }} as SOURCE_NAME
    ),

    /* 2) Lookup maximum batch_id and trimmed source_name from CDM_BATCH_CTRLID */
    lkp_cdm_batch_ctrlid as (
        select
            ltrim(rtrim(SOURCE_NAME)) as SOURCE_NAME,
            max(BATCH_ID) as LKP_BATCH_ID
        from {{ source('CDM', 'CDM_BATCH_CTRLID') }}
        where STATUS = {{ var('status_running') }}
        group by ltrim(rtrim(SOURCE_NAME))
    ),

    /* 3) Check for null values in batch_id and apply default value */
    exp_null_check as (
        select
            input_data.SOURCE_NAME,
            coalesce(lkp_cdm_batch_ctrlid.LKP_BATCH_ID, -999) as o_BATCH_ID
        from input_data
        left join lkp_cdm_batch_ctrlid
        on input_data.SOURCE_NAME = lkp_cdm_batch_ctrlid.SOURCE_NAME
    )

select
    o_BATCH_ID,
    SOURCE_NAME
from exp_null_check
{% endmacro %}