-- ============================================================
-- RECEITAS - Schema
-- Tabelas para receitas de pastéis e seus ingredientes (produtos)
-- Execute no Supabase SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS receitas (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS receita_itens (
  id SERIAL PRIMARY KEY,
  receita_id INTEGER NOT NULL REFERENCES receitas(id) ON DELETE CASCADE,
  produto_id INTEGER NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  qtd NUMERIC NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (receita_id, produto_id)
);

CREATE INDEX IF NOT EXISTS idx_receita_itens_receita ON receita_itens(receita_id);
