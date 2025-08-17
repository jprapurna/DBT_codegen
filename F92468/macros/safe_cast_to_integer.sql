{% macro safe_cast_to_integer(v_FARMERS_STATE_CD) %}
    CASE
        WHEN {{ v_FARMERS_STATE_CD }} IS NULL THEN NULL
        WHEN {{ v_FARMERS_STATE_CD }} ~ '^\d+$' THEN CAST({{ v_FARMERS_STATE_CD }} AS INTEGER)
        ELSE NULL
    END
{% endmacro %}