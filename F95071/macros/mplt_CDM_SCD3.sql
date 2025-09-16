{% macro mplt_CDM_SCD3(ROW_WID, NEW_BUR, OLD_BUR, BATCH_ID) %}
WITH scd3_logic AS (
  SELECT
    ROW_WID,
    NEW_BUR,
    OLD_BUR,
    BATCH_ID,
    CASE
      WHEN NEW_BUR IS NULL THEN OLD_BUR
      ELSE NEW_BUR
    END AS UPDATED_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
)
SELECT
  ROW_WID,
  UPDATED_BUR AS NEW_BUR,
  OLD_BUR,
  BATCH_ID
FROM scd3_logic
{% endmacro %}