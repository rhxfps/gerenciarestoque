-- ============================================================
-- Zerar Consumo dos Usuários
-- Remove todos os registros de consumo (funcionários e dono)
-- ============================================================

-- Remove os itens de consumo (dependentes)
DELETE FROM consumo_itens;

-- Remove os consumos
DELETE FROM consumos;

-- Reinicia a sequência dos ids de consumo para começar limpo
SELECT setval(pg_get_serial_sequence('consumos', 'id'), 1, false);

-- ============================================================
-- FIM
-- ============================================================
