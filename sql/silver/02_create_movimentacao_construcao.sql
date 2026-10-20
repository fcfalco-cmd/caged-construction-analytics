CREATE TABLE `projeto1-poc.caged_silver.movimentacao_construcao`
PARTITION BY RANGE_BUCKET(ano, GENERATE_ARRAY(2020, 2027, 1))
CLUSTER BY mes, sigla_uf
AS
SELECT
  * REPLACE (
    COALESCE(id_municipio, '-1') AS id_municipio,
    IF(cbo_2002 = '999999', '-1', cbo_2002) AS cbo_2002
  ),
  DATE(ano, mes, 1) AS data_competencia,
  COALESCE(salario_mensal <= 0 OR salario_mensal > 100000, TRUE) AS flag_salario_invalido,
  CURRENT_TIMESTAMP() AS _processado_em
FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
