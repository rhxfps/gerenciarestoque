-- ============================================================
-- AÇAÍ — sem estoque próprio (estilo pastel)
-- O estoque de açaí é controlado pelos copos (embalagens).
-- Marca os tamanhos de açaí como tipo 'acai' e zera as quantidades
-- para não aparecerem como itens de estoque.
-- Execute no SQL Editor do Supabase
-- ============================================================

UPDATE produtos
SET tipo = 'acai', qtd = 0, qtd_minima = 0
WHERE categoria = 'Açaí'
  AND tipo = 'estoque';
