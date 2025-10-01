{% macro macro_md5(input_string) %}
  MD5({{ input_string }})
{% endmacro %}