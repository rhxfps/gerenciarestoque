-- ============================================================
-- Reset do Consumo: apaga consumos do dia 25 para trás
-- (encerra o período mensal que ia de 26 até 25 e zera antes disso)
-- ============================================================

-- Remove os itens dos consumos com data até o dia 25
DELETE FROM consumo_itens
WHERE consumo_id IN (
  SELECT id FROM consumos WHERE EXTRACT(DAY FROM data) <= 25
);

-- Remove os consumos com data até o dia 25
DELETE FROM consumos WHERE EXTRACT(DAY FROM data) <= 25;

-- ============================================================
-- FIM
-- ============================================================
