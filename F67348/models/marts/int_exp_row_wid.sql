-- Purpose: Expression transformation to calculate ROW_WID using variables V1 and V2.
SELECT 
    IIF(V2 = 0, {{ macro_max_row_wid('CDM', 'W_CLAIM_CD_BUR_SCD3') }}, V2) AS V1,
    V1 + 1 AS V2,
    V2 AS ROW_WID
FROM {{ ref('int_upd_bur') }}