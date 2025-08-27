WITH audit_data AS (
    SELECT *
    FROM {{ ref('stg_salesforce_audit') }}
),
ldap_mapping AS (
    SELECT *
    FROM {{ ref('stg_ldap_mapping') }}
)

SELECT
    audit_data.audit_id,
    audit_data.action_type,
    audit_data.timestamp,
    ldap_mapping.user_name,
    ldap_mapping.group_name
FROM audit_data
LEFT JOIN ldap_mapping
ON audit_data.user_id = ldap_mapping.user_id
AND audit_data.group_id = ldap_mapping.group_id