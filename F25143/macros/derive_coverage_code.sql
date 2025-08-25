{% macro derive_coverage_code(st_abbr, acctng_lob, cvg_typ_cd, bi_lmt) %}
    CASE
        WHEN {{ st_abbr }} = 'CA' AND {{ acctng_lob }} = 'AUTO' AND {{ cvg_typ_cd }} = 'COMP' THEN 'CA_AUTO_COMP'
        WHEN {{ st_abbr }} = 'TX' AND {{ acctng_lob }} = 'AUTO' AND {{ cvg_typ_cd }} = 'COLL' THEN 'TX_AUTO_COLL'
        ELSE 'OTHER'
    END
{% endmacro %}