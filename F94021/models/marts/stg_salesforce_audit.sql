WITH raw_data AS (
    SELECT *
    FROM {{ source('genai_power_bi', 'tblSF_CaseHistory_Import') }}
)

SELECT
    audit_id,
    {{ safe_cast('user_id', 'INT') }} AS user_id,
    {{ safe_cast('group_id', 'INT') }} AS group_id,
    action_type,
    timestamp
FROM raw_data