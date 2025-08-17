{% snapshot niss_aprm_detail_snapshot %}
    {{
        config(
            target_database='GENAI_POWER_BI',
            target_schema='POWER_CENTER',
            unique_key='NISS_APRM_DETL_SK',
            strategy='check',
            check_cols=['CVG_TYP_CD', 'CVG_AMT', 'BI_LMT', 'GA_ADDED_AT_FAULT_IND']
        )
    }}

    SELECT *
    FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
{% endsnapshot %}