{% snapshot snapshot_Assignment_PC_Variables %}
{{
  config(
    target_database='genai_power_bi',
    target_schema='snapshots',
    unique_key='PMWorkflowRunId',
    strategy='timestamp',
    updated_at='SYSDATE'
  )
}}
SELECT *
FROM {{ ref('int_Assignment_PC_Variables') }}
{% endsnapshot %}