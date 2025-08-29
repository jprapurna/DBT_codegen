{% snapshot claim_burden_snapshot %}
    {{
        config(
            target_database='CDM',
            target_schema='DEV_CLM_BI',
            unique_key='ROW_WID',
            strategy='timestamp',
            updated_at='CDM_UPDATE_DT'
        )
    }}
    SELECT
        ROW_WID,
        INTEGRATION_ID,
        NEW_BUR,
        CDM_INSERT_DT,
        CDM_UPDATE_DT
    FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}