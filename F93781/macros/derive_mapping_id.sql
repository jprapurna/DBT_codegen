{% macro derive_mapping_id(v_RECORD_NUM, MAPPING_NAME, FOLDER_NAME) %}
    CASE 
        WHEN {{ v_RECORD_NUM }} IS NULL THEN NULL
        ELSE CONCAT({{ MAPPING_NAME }}, '_', {{ FOLDER_NAME }}, '_', {{ v_RECORD_NUM }})
    END
{% endmacro %}