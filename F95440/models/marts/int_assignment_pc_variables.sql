{{
  config(materialized='ephemeral')
}}

WITH batch_ctrlid_data AS (
  SELECT * FROM {{ ref('int_cdm_batch_ctrlid') }}
),

assignment_pc_variables AS (
  SELECT
    SOURCE_NAME,
    BATCH_ID,
    STATUS,
    CASE 
      WHEN STATUS = 'Active' THEN 'ASSIGNED'
      ELSE 'UNASSIGNED'
    END AS ASSIGNMENT_STATUS
  FROM batch_ctrlid_data
)

SELECT * FROM assignment_pc_variables;