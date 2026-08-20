-- Tabela de gastos do negócio
CREATE TABLE IF NOT EXISTS gastos (
  id SERIAL PRIMARY KEY,
  descricao TEXT NOT NULL,
  categoria TEXT NOT NULL DEFAULT 'Outros',
  valor NUMERIC(10,2) NOT NULL DEFAULT 0,
  pagamento TEXT NOT NULL DEFAULT 'dinheiro',
  data TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fixo BOOLEAN NOT NULL DEFAULT FALSE,
  usuario_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_gastos_data ON gastos(data);
CREATE INDEX IF NOT EXISTS idx_gastos_categoria ON gastos(categoria);
