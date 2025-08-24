{% macro derive_class_code(state_abbr, age, gender, marital_status, multi_car_ind, auto_use_code, soi_type, acctng_lob, cvg_typ_cd) %}
    CASE
        WHEN {{ state_abbr }} IS NULL THEN 'UNKNOWN'
        WHEN {{ age }} < 25 THEN 'YOUNG_DRIVER'
        WHEN {{ gender }} = 'M' AND {{ marital_status }} = 'S' THEN 'SINGLE_MALE'
        WHEN {{ multi_car_ind }} = 'Y' THEN 'MULTI_CAR'
        WHEN {{ auto_use_code }} = 'COMMERCIAL' THEN 'COMMERCIAL_USE'
        WHEN {{ soi_type }} = 'AUTO' AND {{ acctng_lob }} = 'PERSONAL' THEN 'AUTO_PERSONAL'
        WHEN {{ cvg_typ_cd }} = 'FULL' THEN 'FULL_COVERAGE'
        ELSE 'DEFAULT_CLASS'
    END
{% endmacro %}