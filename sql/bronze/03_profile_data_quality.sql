SELECT
  COUNT(*) AS linhas,
  COUNT(DISTINCT TO_JSON_STRING(t)) AS linhas_distintas,
  COUNT(*) - COUNT(DISTINCT TO_JSON_STRING(t)) AS duplicadas
FROM (
  SELECT * EXCEPT(_ingerido_em)
  FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
  WHERE ano = 2025
) AS t;

SELECT
  COUNT(*) AS linhas,
  COUNTIF(id_municipio IS NULL) AS nulos_municipio,
  COUNTIF(cbo_2002 IS NULL) AS nulos_cbo,
  COUNTIF(saldo_movimentacao IS NULL) AS nulos_saldo,
  COUNTIF(salario_mensal IS NULL) AS nulos_salario,
  COUNTIF(idade IS NULL) AS nulos_idade,
  COUNTIF(sexo IS NULL) AS nulos_sexo
FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
WHERE ano = 2025;

SELECT
  ARRAY_AGG(DISTINCT saldo_movimentacao IGNORE NULLS) AS valores_saldo,
  MIN(idade) AS idade_min,
  MAX(idade) AS idade_max,
  MIN(salario_mensal) AS salario_min,
  APPROX_QUANTILES(salario_mensal, 100)[OFFSET(50)] AS salario_mediana,
  MAX(salario_mensal) AS salario_max,
  COUNTIF(salario_mensal <= 0) AS salarios_zero_ou_negativos
FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
WHERE ano = 2025;

SELECT
  indicador_trabalho_intermitente,
  COUNT(*) AS linhas,
  COUNTIF(salario_mensal <= 0) AS salario_zero,
  ROUND(100 * COUNTIF(salario_mensal <= 0) / COUNT(*), 2) AS pct_zero
FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
WHERE ano = 2025
GROUP BY indicador_trabalho_intermitente
ORDER BY indicador_trabalho_intermitente;

SELECT
  APPROX_QUANTILES(salario_mensal, 1000)[OFFSET(990)] AS p99,
  APPROX_QUANTILES(salario_mensal, 1000)[OFFSET(999)] AS p999,
  APPROX_QUANTILES(salario_mensal, 10000)[OFFSET(9995)] AS p9995,
  COUNTIF(salario_mensal > 50000) AS acima_50k,
  COUNTIF(salario_mensal > 100000) AS acima_100k,
  COUNTIF(salario_mensal > 1000000) AS acima_1mi,
  COUNTIF(cbo_2002 = '999999') AS cbo_999999
FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
WHERE ano = 2025;

SELECT
  m.tipo_movimentacao,
  COUNT(*) AS linhas,
  SUM(m.saldo_movimentacao) AS saldo
FROM `projeto1-poc.caged_bronze.movimentacao_construcao` AS m
LEFT JOIN (
  SELECT chave
  FROM `basedosdados.br_me_caged.dicionario`
  WHERE id_tabela = 'microdados_movimentacao'
    AND nome_coluna = 'tipo_movimentacao'
) AS d
  ON CAST(m.tipo_movimentacao AS STRING) = d.chave
WHERE m.ano = 2025
  AND d.chave IS NULL
GROUP BY m.tipo_movimentacao
ORDER BY linhas DESC;

SELECT
  ano,
  COUNT(*) AS linhas,
  COUNTIF(CAST(tipo_movimentacao AS STRING) = '97') AS tipo_97,
  ROUND(100 * COUNTIF(CAST(tipo_movimentacao AS STRING) = '97') / COUNT(*), 1) AS pct_97
FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
GROUP BY ano
ORDER BY ano;
