-- ============================================================
-- Retiradas de caixa
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS caixa_retiradas (
  id                  SERIAL PRIMARY KEY,
  caixa_id            INTEGER NOT NULL REFERENCES caixa(id) ON DELETE CASCADE,
  valor               NUMERIC(10,2) NOT NULL CHECK (valor > 0),
  motivo              TEXT NOT NULL,
  usuario_id          INTEGER REFERENCES usuarios(id),
  data                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_caixa_retiradas_caixa ON caixa_retiradas (caixa_id);

COMMENT ON TABLE caixa_retiradas IS 'Retiradas de dinheiro do caixa durante o expediente';
