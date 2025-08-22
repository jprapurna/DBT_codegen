-- Purpose: Represents the final model for workflow-level variable tracking.
{{ config(materialized='table') }}
SELECT *
FROM {{ ref('int_Assignment_PC_Variables') }}