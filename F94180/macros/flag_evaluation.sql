{% macro flag_evaluation(lkp_row_wid, bur, lkp_new_bur) %}
  IIF(ISNULL({{ lkp_row_wid }}), 'I', IIF(MD5({{ bur }}) = MD5({{ lkp_new_bur }}), 'NC', 'U'))
{% endmacro %}