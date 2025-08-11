-- Purpose: Mapplet transformation for auditing mapping details, including lookup procedures for mapping and workflow IDs.

WITH mapping_audit AS (
  SELECT
    MAP_ID,
    WORKFLOW_RUN_ID
  FROM
    {{ source('FDR', 'ABC_MAPPING_AUDIT') }}
)

SELECT
  ma.MAP_ID,
  ma.WORKFLOW_RUN_ID
FROM
  mapping_audit AS ma