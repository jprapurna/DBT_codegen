SELECT
    audit_id,
    user_name AS user_full_name,
    group_name AS group_full_name,
    action_type AS action_description,
    timestamp AS action_timestamp
FROM {{ ref('int_salesforce_audit_enriched') }}