CREATE TABLE `projeto1-poc.caged_gold.dim_local` AS
SELECT
  id_municipio,
  nome AS nome_municipio,
  COALESCE(capital_uf = 1, FALSE) AS flag_capital_uf,
  nome_regiao_imediata,
  nome_regiao_intermediaria,
  COALESCE(nome_regiao_metropolitana, 'Não pertence') AS nome_regiao_metropolitana,
  sigla_uf,
  nome_uf,
  nome_regiao
FROM `basedosdados.br_bd_diretorios_brasil.municipio`
UNION ALL
SELECT
  '-1',
  'Não informado',
  FALSE,
  'Não informado',
  'Não informado',
  'Não informado',
  'Não informado',
  'Não informado',
  'Não informado'
