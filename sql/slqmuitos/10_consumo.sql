-- ============================================================
-- CONSUMO DE FUNCIONÁRIOS — R$ 100,00/mês por funcionário
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

-- Pedidos de consumo (cada funcionário tem limite mensal de R$ 100,00)
CREATE TABLE IF NOT EXISTS consumos (
  id          SERIAL PRIMARY KEY,
  usuario_id  INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  total       NUMERIC(10,2) NOT NULL DEFAULT 0,
  obs         TEXT,
  data        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_consumos_usuario_data ON consumos (usuario_id, data);

-- Itens de cada consumo
CREATE TABLE IF NOT EXISTS consumo_itens (
  id              SERIAL PRIMARY KEY,
  consumo_id      INTEGER NOT NULL REFERENCES consumos(id) ON DELETE CASCADE,
  produto_id      INTEGER REFERENCES produtos(id) ON DELETE SET NULL,
  produto_nome    TEXT NOT NULL,
  qtd             NUMERIC(10,2) NOT NULL DEFAULT 1,
  preco_unitario  NUMERIC(10,2) NOT NULL DEFAULT 0,
  recheio         TEXT
);

CREATE INDEX IF NOT EXISTS idx_consumo_itens_consumo ON consumo_itens (consumo_id);

COMMENT ON TABLE consumos IS 'Consumo mensal de funcionários (limite R$ 100,00 por usuário/mês)';
COMMENT ON TABLE consumo_itens IS 'Itens de cada consumo de funcionário';
