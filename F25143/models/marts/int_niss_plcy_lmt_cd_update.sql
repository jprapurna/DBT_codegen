WITH base_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_PLCY_LMT_CD
    FROM {{ ref('stg_niss_aprm_dtl') }}
)

SELECT
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD
FROM base_data
{% if is_incremental() %}
WHERE DD_UPDATE = 'Y'
{% endif %}