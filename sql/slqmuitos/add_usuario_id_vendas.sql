-- Adicionar coluna usuario_id na tabela vendas
ALTER TABLE vendas ADD COLUMN IF NOT EXISTS usuario_id INTEGER REFERENCES usuarios(id);

-- Criar índice para consultas por usuário
CREATE INDEX IF NOT EXISTS idx_vendas_usuario_id ON vendas(usuario_id);

-- Comentário explicativo
COMMENT ON COLUMN vendas.usuario_id IS 'ID do usuário que registrou a venda';
