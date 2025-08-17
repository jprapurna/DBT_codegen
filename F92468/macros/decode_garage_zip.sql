{% macro decode_garage_zip(i_GRGNG_ZIP) %}
    CASE
        WHEN {{ i_GRGNG_ZIP }} IS NULL THEN NULL
        WHEN LENGTH(TRIM({{ i_GRGNG_ZIP }})) = 5 THEN TRIM({{ i_GRGNG_ZIP }})
        ELSE NULL
    END
{% endmacro %}