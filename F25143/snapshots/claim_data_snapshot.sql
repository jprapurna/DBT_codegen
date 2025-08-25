{% snapshot claim_data_snapshot %}
{{
    config(
        target_database='DBA_COMMON_UTILS',
        target_schema='CDM',
        unique_key='ROW_WID',
        strategy='timestamp',
        updated_at='CDM_UPDATE_DT'
    )
}}
select *
from {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}