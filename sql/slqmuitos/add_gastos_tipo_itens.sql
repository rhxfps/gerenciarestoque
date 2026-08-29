-- Adicionar colunas tipo e itens à tabela gastos
ALTER TABLE gastos ADD COLUMN IF NOT EXISTS tipo TEXT NOT NULL DEFAULT 'outros';
ALTER TABLE gastos ADD COLUMN IF NOT EXISTS itens JSONB;
