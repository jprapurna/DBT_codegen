SELECT 
    CASE 
        WHEN v2 = 0 THEN {{ ref('snapshot_max_row_wid') }}.ROW_WID
        ELSE v2 
    END AS ROW_WID,
    TGT_TABLE_NAME
FROM {{ ref('int_max_row_wid') }}