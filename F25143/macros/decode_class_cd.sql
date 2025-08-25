{% macro decode_class_cd(st_abbr, acctng_lob, cvg_typ_cd) %}
    CASE
        WHEN {{ st_abbr }} = 'NY' AND {{ acctng_lob }} = 'AUTO' THEN 'CLASS_CD_NY_AUTO'
        WHEN {{ st_abbr }} = 'NJ' AND {{ cvg_typ_cd }} = 'LIABILITY' THEN 'CLASS_CD_NJ_LIABILITY'
        ELSE 'DEFAULT_CLASS_CD'
    END
{% endmacro %}