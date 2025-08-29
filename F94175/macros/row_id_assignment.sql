{% macro row_id_assignment(tgt_table_name, v2) %}
  IIF({{ v2 }} = 0, :LKP.lkp_MAX_ROW_WID({{ tgt_table_name }}), {{ v2 }})
{% endmacro %}