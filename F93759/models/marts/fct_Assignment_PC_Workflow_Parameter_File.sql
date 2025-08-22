-- Purpose: Represents the final model for parameter file assignments.
{{ config(materialized='table') }}
SELECT *
FROM {{ ref('int_Assignment_PC_Workflow_Parameter_File') }}