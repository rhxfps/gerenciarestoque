-- Tabela para armazenar contagens de estoque
-- Cada linha = 1 produto contado por 1 pessoa em 1 sessão de contagem
CREATE TABLE IF NOT EXISTS contagem (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  produto_id INTEGER NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  qtd NUMERIC NOT NULL DEFAULT 0,
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_contagem_usuario_data ON contagem(usuario_id, data);
CREATE INDEX IF NOT EXISTS idx_contagem_produto ON contagem(produto_id);
