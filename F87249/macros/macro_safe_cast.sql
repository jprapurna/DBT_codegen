{% macro macro_safe_cast(value, type) %}
CASE
  WHEN {{ value }} IS NULL THEN NULL
  ELSE CAST({{ value }} AS {{ type }})
END
{% endmacro %}