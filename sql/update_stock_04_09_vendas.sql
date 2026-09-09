-- ============================================================
-- Estoque pós-vendas - 04/09/2026
-- Subtrai as quantidades vendidas em 04/09/2026 do estoque
-- definido no inventário (update_stock_04_09.sql)
-- Valor final = estoque_base - vendido_hoje (mínimo 0)
-- ============================================================

-- ------------------------------------------------------------
-- SALGADOS
-- ------------------------------------------------------------

-- Bolinho de Queijo (13 - 5 = 8)
UPDATE produtos SET qtd = 8  WHERE id = 56;
-- Enroladinho de Salsicha (9 - 2 = 7)
UPDATE produtos SET qtd = 7  WHERE id = 58;
-- Bolinho de Carne (13 - 1 = 12)
UPDATE produtos SET qtd = 12 WHERE id = 59;

-- ------------------------------------------------------------
-- BEBIDAS
-- ------------------------------------------------------------

-- Del Valle Uva 290 ML (3 - 1 = 2)
UPDATE produtos SET qtd = 2  WHERE id = 211;

-- ------------------------------------------------------------
-- GELADINHOS
-- ------------------------------------------------------------

-- Geladinho Maracujá (8 - 2 = 6)
UPDATE produtos SET qtd = 6  WHERE id = 177;
-- Geladinho Morango (1 - 1 = 0)
UPDATE produtos SET qtd = 0  WHERE id = 178;
-- Geladinho coco (estoque atual 14 - 2 = 12) [id mantido: 277]
UPDATE produtos SET qtd = 12 WHERE id = 277;

-- ------------------------------------------------------------
-- DOCES / GULOSEIMAS
-- ------------------------------------------------------------

-- Pirulito Coca (35 - 2 = 33)
UPDATE produtos SET qtd = 33  WHERE id = 78;
-- Bala de Hortelã (193 - 6 = 187)
UPDATE produtos SET qtd = 187 WHERE id = 86;
-- Bala Azedinha Roxa (22 - 1 = 21)
UPDATE produtos SET qtd = 21  WHERE id = 218;
-- Pirulito Boca Cereja (9 - 2 = 7) [vendido como id 225; estoque contado no id 79]
UPDATE produtos SET qtd = 7   WHERE id = 79;

-- ------------------------------------------------------------
-- DUPLICADOS - mantém apenas um nome de cada
-- ------------------------------------------------------------

-- Pirulito Boca Cereja (duplicado) - zerado, mantém id 79
UPDATE produtos SET qtd = 0 WHERE id = 225;
-- Geladinho coco (duplicado) - zerado, mantém id 277
UPDATE produtos SET qtd = 0 WHERE id = 253;

-- ============================================================
-- FIM - estoque pós-vendas 04/09/2026
-- ============================================================
