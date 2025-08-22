{% macro scd3_flag_evaluation(bur, lkp_new_bur, lkp_row_wid) %}
CASE 
    WHEN lkp_row_wid IS NULL THEN 'I'
    WHEN MD5({{ bur }}) = MD5({{ lkp_new_bur }}) THEN 'NC'
    ELSE 'U'
END
{% endmacro %}