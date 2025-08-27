{{ config(materialized='table') }}

SELECT
    {{ surrogate_key(['audit_id', 'action_timestamp']) }} AS surrogate_key,
    audit_id,
    user_full_name,
    group_full_name,
    action_description,
    action_timestamp
FROM {{ ref('int_audit_field_translation') }}