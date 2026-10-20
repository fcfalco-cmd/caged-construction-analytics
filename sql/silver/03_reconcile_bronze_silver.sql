WITH bronze AS (
  SELECT
    ano,
    COUNT(*) AS linhas,
    COUNTIF(id_municipio IS NULL) AS municipio_nao_informado,
    COUNTIF(cbo_2002 = '999999') AS cbo_nao_informado,
    COUNTIF(salario_mensal IS NULL OR salario_mensal <= 0 OR salario_mensal > 100000) AS salario_invalido
  FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
  GROUP BY ano
),
silver AS (
  SELECT
    ano,
    COUNT(*) AS linhas,
    COUNTIF(id_municipio = '-1') AS municipio_nao_informado,
    COUNTIF(cbo_2002 = '-1') AS cbo_nao_informado,
    COUNTIF(flag_salario_invalido) AS salario_invalido,
    COUNTIF(flag_salario_invalido IS NULL) AS flag_nula,
    COUNTIF(data_competencia IS NULL) AS data_nula
  FROM `projeto1-poc.caged_silver.movimentacao_construcao`
  GROUP BY ano
)
SELECT
  ano,
  silver.linhas - bronze.linhas AS dif_linhas,
  silver.municipio_nao_informado - bronze.municipio_nao_informado AS dif_municipio,
  silver.cbo_nao_informado - bronze.cbo_nao_informado AS dif_cbo,
  silver.salario_invalido - bronze.salario_invalido AS dif_salario,
  silver.flag_nula,
  silver.data_nula
FROM bronze
FULL OUTER JOIN silver USING (ano)
ORDER BY ano
