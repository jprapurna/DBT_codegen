{% macro row_id_assignment(sequence_name) %}
  NEXTVAL('{{ sequence_name }}')
{% endmacro %}
