{% snapshot snapshot_w_claim_cd_bur_scd3 %}
{{
    config(
        target_database='genai_power_bi',
        target_schema='CDM',
        unique_key='ROW_WID',
        strategy='timestamp',
        updated_at='CDM_UPDATE_DT'
    )
}}
SELECT 
    ROW_WID,
    BUR,
    SOURCE_NAME,
    CDM_INSERT_DT,
    CDM_UPDATE_DT
FROM {{ ref('int_exp_flag') }}
{% endsnapshot %}