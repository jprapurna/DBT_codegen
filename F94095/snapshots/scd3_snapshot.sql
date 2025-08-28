{% snapshot scd3_snapshot %}
{{
    config(
        target_database='CDM',
        target_schema='CDM',
        target_table='W_CLAIM_CD_BUR_SCD3',
        unique_key='ROW_WID',
        strategy='timestamp'
    )
}}
SELECT 
    ROW_WID,
    INTEGRATION_ID,
    NEW_BUR,
    OLD_BUR,
    INSERT_DT,
    UPDATE_DT
FROM {{ source('genai_power_bi', 'lkp_w_claim_cd_bur_scd3') }}
{% endsnapshot %}