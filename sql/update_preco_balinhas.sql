-- ============================================================
-- Atualizar preço das balinhas: 0.30 → 0.35
-- Rode no SQL Editor do Supabase
-- ============================================================

UPDATE produtos SET preco = 0.35 WHERE preco = 0.3;
