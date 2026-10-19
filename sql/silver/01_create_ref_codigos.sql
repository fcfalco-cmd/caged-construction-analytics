CREATE TABLE `projeto1-poc.caged_silver.ref_codigos` AS
SELECT
  CASE nome_coluna WHEN 'fonte' THEN 'origem_informacao' ELSE nome_coluna END AS coluna,
  chave AS codigo,
  valor AS descricao,
  'dicionario_base_dos_dados' AS origem_descricao
FROM `basedosdados.br_me_caged.dicionario`
WHERE id_tabela = 'microdados_movimentacao'
UNION ALL
SELECT
  'tipo_movimentacao',
  '97',
  'Admissão (tipo não informado)',
  'decisao_projeto'
