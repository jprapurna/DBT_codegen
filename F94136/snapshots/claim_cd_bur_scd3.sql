{% snapshot claim_cd_bur_scd3 %}
{{
    config(
        target_database='Snowflake Cloud Data Warehouse V2',
        target_schema='CDM',
        unique_key='ROW_WID',
        strategy='check',
        check_cols=['BUR', 'NEW_BUR']
    )
}}
SELECT 
    ROW_WID,
    INTEGRATION_ID,
    NEW_BUR,
    BUR
FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
{% endsnapshot %}