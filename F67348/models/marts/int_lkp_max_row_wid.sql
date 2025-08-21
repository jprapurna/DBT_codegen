-- Purpose: Fetch maximum ROW_WID from the target table.
SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    '$$TGT_TABLE_NAME' AS TABLE_NAME
FROM {{ source('MAX_ROW_WID', 'LKP_MAX_ROW_WID') }}