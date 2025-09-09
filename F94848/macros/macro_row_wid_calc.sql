{% macro macro_row_wid_calc(v2, tgt_table_name) %}
CASE
  WHEN {{ v2 }} = 0 THEN {{ mplt_cdm_row_wid(tgt_table_name) }}
  ELSE {{ v2 }}
END
{% endmacro %}