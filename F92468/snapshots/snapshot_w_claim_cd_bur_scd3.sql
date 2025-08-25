{% snapshot snapshot_w_claim_cd_bur_scd3 %}
{{
    config(
        target_database='CDM',
        target_schema='CDM',
        unique_key='ROW_WID',
        strategy='check',
        check_cols=['NEW_BUR']
    )
}}
SELECT *
FROM {{ source('claim_cd_bur_scd3', 'lkp_w_claim_cd_bur_scd3') }}
{% endsnapshot %}