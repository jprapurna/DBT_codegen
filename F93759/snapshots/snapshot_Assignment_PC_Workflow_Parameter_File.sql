{% snapshot snapshot_Assignment_PC_Workflow_Parameter_File %}
{{
  config(
    target_database='genai_power_bi',
    target_schema='snapshots',
    unique_key='InputMappingTaskParameterFileName',
    strategy='timestamp',
    updated_at='SYSDATE'
  )
}}
SELECT *
FROM {{ ref('int_Assignment_PC_Workflow_Parameter_File') }}
{% endsnapshot %}