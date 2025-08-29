{% snapshot claim_bur_snapshot %}
{{
    config(
        target_database='CDM',
        target_schema='CDM',
        unique_key='ROW_WID',
        strategy='check',
        check_cols=['BUR', 'NEW_BUR']
    )
}}
SELECT 
    ROW_WID,
    INTEGRATION_ID,
    BUR,
    NEW_BUR,
    SYSDATE() AS last_updated
FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}