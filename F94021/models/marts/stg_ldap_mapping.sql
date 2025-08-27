SELECT
    user_id,
    group_id,
    user_name,
    group_name
FROM {{ ref('ldap_reference_data') }}