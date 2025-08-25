{% snapshot w_claim_cd_bur_scd3 %}
{{
    config(
        target_database='genai_power_bi',
        target_schema='none',
        unique_key='row_wid',
        strategy='timestamp',
        updated_at='update_dt'
    )
}}
SELECT 
    row_wid,
    integration_id,
    new_bur,
    old_bur,
    batch_id,
    insert_dt,
    update_dt
FROM {{ source('genai_power_bi', 's_w_claim_cd_scd3_iu') }}
{% endsnapshot %}