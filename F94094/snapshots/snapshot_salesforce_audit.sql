{% snapshot snapshot_salesforce_audit %}
{{
    config(
        target_database='genai_power_bi',
        target_schema='snapshots',
        unique_key='audit_id',
        strategy='check',
        check_cols=['last_modified']
    )
}}

SELECT *
FROM {{ source('genai_power_bi', 'tblSF_CaseHistory_Import') }}
{% endsnapshot %}