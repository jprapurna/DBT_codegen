{% snapshot snapshot_w_claim_cd_bur_scd3 %}
{{
    config(
        target_database='genai_power_bi',
        target_schema='CDM',
        unique_key='ROW_WID',
        strategy='timestamp',
        updated_at='updated_at_column'
    )
}}

SELECT 
    ROW_WID,
    INTEGRATION_ID,
    NEW_BUR,
    updated_at_column
FROM {{ ref('int_w_claim_cd_bur_scd3') }}
{% endsnapshot %}