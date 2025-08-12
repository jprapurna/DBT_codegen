-- Purpose: Updates Old_Owner field to LDAP ID using user and ODS user tables
UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET Old_Owner = LDAP_ID__C
FROM {{ source('Salesforce', 'tblSF_USER') }}
WHERE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}.Old_Owner = {{ source('Salesforce', 'tblSF_USER') }}.ID
AND {{ source('Salesforce', 'tblSF_USER') }}.LDAP_ID__C IS NOT NULL;

UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET Old_Owner = LDAP_ID
FROM {{ source('Salesforce', 'SF_ODS_SRM_USR') }}
WHERE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}.Old_Owner = {{ source('Salesforce', 'SF_ODS_SRM_USR') }}.SRC_USR_ID
AND {{ source('Salesforce', 'SF_ODS_SRM_USR') }}.LDAP_ID IS NOT NULL
AND TRANS_EFF_TMSP IS NOT NULL
AND TRANS_EXP_TMSP IS NULL
AND TRANS_EFF_TMSP = (
    SELECT MAX(TRANS_EFF_TMSP) AS TRANS_EFF_TMSP
    FROM {{ source('Salesforce', 'SF_ODS_SRM_USR') }} sub
    WHERE {{ source('Salesforce', 'SF_ODS_SRM_USR') }}.SRC_USR_ID = sub.SRC_USR_ID
);