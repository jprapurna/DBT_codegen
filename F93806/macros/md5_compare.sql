{% macro md5_compare(field1, field2) %}
CASE
  WHEN MD5({{ field1 }}) = MD5({{ field2 }}) THEN 'NC'
  ELSE 'U'
END
{% endmacro %}