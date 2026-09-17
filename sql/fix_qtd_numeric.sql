-- ============================================================
-- Fix: aceitar quantidades decimais (ex.: 1.5) no estoque/contagem
-- Rode isto no SQL Editor do Supabase e nao deixa deixar isso acontecer de novo
-- ============================================================

ALTER TABLE produtos
  ALTER COLUMN qtd TYPE NUMERIC,
  ALTER COLUMN qtd_minima TYPE NUMERIC;

ALTER TABLE contagem
  ALTER COLUMN qtd TYPE NUMERIC;

ALTER TABLE movimentacoes
  ALTER COLUMN qtd TYPE NUMERIC;