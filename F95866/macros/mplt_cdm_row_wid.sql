{% macro mplt_cdm_row_wid(in_table_name) %}
-- Derive maximum ROW_WID and calculate new ROW_WID
-- source: mapplet mplt_CDM_ROW_WID
-- do not print or log anything here

with
    /* 1) Normalize inputs as CTE to enforce stable names and data types */
    input_data as (
        select 
            {{ in_table_name }} as IN_TABLE_NAME
    ),

    /* 2) Lookup maximum ROW_WID and associated TABLE_NAME */
    lkp_max_row_wid as (
        select
            coalesce(max(row_wid), 0) as ROW_WID,
            '{{ var("tgt_table_name") }}' as TABLE_NAME
        from {{ source('CDM', var('schema_cdm')) }}.{{ var('tgt_table_name') }}
        where table_name = (select IN_TABLE_NAME from input_data)
    ),

    /* 3) Expression transformation to calculate new ROW_WID */
    exp_row_wid as (
        select
            case 
                when 0 = 0 then (select ROW_WID from lkp_max_row_wid)
                else 0
            end as V1,
            V1 + 1 as V2,
            V2 as ROW_WID
        from lkp_max_row_wid
    )

select
    ROW_WID
from exp_row_wid
{% endmacro %}