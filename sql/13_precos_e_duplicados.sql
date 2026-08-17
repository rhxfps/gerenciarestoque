-- ============================================================
-- Ajuste de preços + corrigir duplicados de guaraná
-- Execute no SQL Editor do Supabase
-- ============================================================

-- ─── PREÇOS ──────────────────────────────────────────────────

-- TNTs
UPDATE produtos SET preco = 8.00 WHERE nome ILIKE 'tnt%';

-- Refrigerantes 200ml (todos os sabores)
UPDATE produtos SET preco = 4.00 WHERE nome ILIKE '%200 ml%' AND categoria ILIKE 'bebidas%';
UPDATE produtos SET preco = 4.00 WHERE nome ILIKE '%200ml%'  AND categoria ILIKE 'bebidas%';

-- Guaraná lata 350ml
UPDATE produtos SET preco = 6.00 WHERE nome ILIKE 'guaraná lata%' OR nome ILIKE 'guarana lata%';

-- Guaraná 1 litro
UPDATE produtos SET preco = 9.00 WHERE nome ILIKE 'guaraná 1%' OR nome ILIKE 'guarana 1%';

-- Fanta lata 350ml
UPDATE produtos SET preco = 6.00 WHERE nome ILIKE 'fanta lata%';

-- ─── FUNDIR GUARANÁ LATA duplicado ───────────────────────────
-- Manter: "Guaraná Lata" (original com preço)
-- Remover: "Guaraná Lata 350 ML" (novo inserido pelo 10_estoque)

UPDATE produtos
SET qtd = qtd + COALESCE(
  (SELECT qtd FROM produtos WHERE nome = 'Guaraná Lata 350 ML'), 0
)
WHERE nome = 'Guaraná Lata';

DELETE FROM produtos WHERE nome = 'Guaraná Lata 350 ML';

-- ─── FUNDIR FANTA LATA duplicado (se existir) ────────────────
UPDATE produtos
SET qtd = qtd + COALESCE(
  (SELECT qtd FROM produtos WHERE nome = 'Fanta Lata 350 ML'), 0
)
WHERE nome ILIKE 'fanta lata%' AND nome != 'Fanta Lata 350 ML';

DELETE FROM produtos WHERE nome = 'Fanta Lata 350 ML';

-- ─── FUNDIR COCA-COLA LATA duplicado (se existir) ────────────
UPDATE produtos
SET qtd = qtd + COALESCE(
  (SELECT qtd FROM produtos WHERE nome = 'Coca-Cola Lata 350 ML'), 0
)
WHERE nome ILIKE 'coca-cola lata%' AND nome != 'Coca-Cola Lata 350 ML';

DELETE FROM produtos WHERE nome = 'Coca-Cola Lata 350 ML';

-- Verificação final:
-- SELECT nome, qtd, preco FROM produtos WHERE nome ILIKE '%guaraná%' OR nome ILIKE '%fanta%' OR nome ILIKE '%tnt%' ORDER BY nome;
