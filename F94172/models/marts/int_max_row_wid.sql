WITH max_row_data AS (
    SELECT
        COALESCE(MAX(ROW_WID), 0) AS ROW_WID,
        '{{ 'W_CLAIM_CD_BUR_SCD3' }}' AS TABLE_NAME
    FROM {{ source('CDM_ROW_WID_MAX', 'CDM_ROW_WID_MAX') }}
)
SELECT * FROM max_row_data;