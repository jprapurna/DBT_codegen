WITH base_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC,
        {{ safe_cast_to_integer('AGE') }} AS IAGE,
        {{ safe_cast_to_integer('MILES_TO_WRK') }} AS IMILES_TO_WRK,
        CASE
            WHEN ISNULL(I_AUTO_USE_CD) THEN ''
            ELSE I_AUTO_USE_CD
        END AS AUTO_USE_CD
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
),
class_code_logic AS (
    SELECT
        *,
        {{ decode_logic('ST_ABBR', {'FL': 'NISS_CLASS_CD_FL'}) }} AS v_CLASS_CD_Auto_1A,
        CASE
            WHEN ST_ABBR = 'MI' OR ST_ABBR = 'MT' THEN 'Auto_4_Class'
            ELSE NULL
        END AS v_CLASS_CD_Auto_4,
        CASE
            WHEN ST_ABBR = 'LA' THEN 'Louisiana_Class'
            ELSE 'Other_State_Class'
        END AS v_CLASS_CD_Auto_5,
        {{ decode_logic('ST_ABBR', {'PA': 'Pennsylvania_Class'}) }} AS v_CLASS_CD_Auto_6
    FROM base_data
)
SELECT * FROM class_code_logic;