-- Purpose: Updates Old_Owner field to Developer Name using group and ODS group tables
UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET Old_Owner = DEVELOPERNAME
FROM {{ source('Salesforce', 'tblSF_GROUP') }}
WHERE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}.Old_Owner = {{ source('Salesforce', 'tblSF_GROUP') }}.ID
AND {{ source('Salesforce', 'tblSF_GROUP') }}.DEVELOPERNAME IS NOT NULL;

UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET Old_Owner = DEVLPR_NM
FROM {{ source('Salesforce', 'SF_ODS_SRM_GRP') }}
WHERE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}.Old_Owner = {{ source('Salesforce', 'SF_ODS_SRM_GRP') }}.SRC_GRP_ID
AND {{ source('Salesforce', 'SF_ODS_SRM_GRP') }}.DEVLPR_NM IS NOT NULL
AND TRANS_EFF_TMSP IS NOT NULL
AND TRANS_EXP_TMSP IS NULL
AND TRANS_EFF_TMSP = (
    SELECT MAX(TRANS_EFF_TMSP) AS TRANS_EFF_TMSP
    FROM {{ source('Salesforce', 'SF_ODS_SRM_GRP') }} sub
    WHERE {{ source('Salesforce', 'SF_ODS_SRM_GRP') }}.SRC_GRP_ID = sub.SRC_GRP_ID
);