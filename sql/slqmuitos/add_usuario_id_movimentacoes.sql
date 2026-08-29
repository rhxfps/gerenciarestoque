-- Adicionar coluna usuario_id na tabela movimentacoes
ALTER TABLE movimentacoes ADD COLUMN IF NOT EXISTS usuario_id INTEGER REFERENCES usuarios(id);

-- Índice para consultas por usuário
CREATE INDEX IF NOT EXISTS idx_movimentacoes_usuario_id ON movimentacoes(usuario_id);
