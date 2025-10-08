{% macro mplt_cdm_row_wid(in_table_name, v2) %}
-- Derive ROW_WID using lookup and expression logic
-- source: mapplet mplt_CDM_ROW_WID
-- do not print or log anything here

with
    /* 1) Normalize inputs as CTE to enforce stable names and data types */
    input_data as (
        select 
            {{ in_table_name }} as IN_TABLE_NAME,
            {{ v2 }} as V2
    ),

    /* 2) Lookup transformation to retrieve maximum ROW_WID and table name */
    lkp_max_row_wid as (
        select 
            coalesce(max(ROW_WID), 0) as ROW_WID,
            '{{ var("tgt_table_name") }}' as TABLE_NAME
        from {{ source(var("schema_cdm"), var("tgt_table_name")) }}
        where TABLE_NAME = (select IN_TABLE_NAME from input_data)
    ),

    /* 3) Expression transformation to calculate ROW_WID */
    exp_row_wid as (
        select 
            case 
                when V2 = 0 then (select ROW_WID from lkp_max_row_wid)
                else V2
            end as V1,
            V1 + 1 as V2,
            V2 as ROW_WID
        from input_data
    )

select
    ROW_WID
from exp_row_wid
{% endmacro %}