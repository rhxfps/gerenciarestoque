-- ============================================================
-- PASTEL — um produto só, sem baixa de estoque
-- Ao vender: escolhe o RECHEIO (sabor). Preço fixo no produto.
-- Execute no SQL Editor do Supabase
-- ============================================================

-- tipo: 'estoque' = produto normal | 'pastel' = vende sem mexer no estoque
ALTER TABLE produtos
  ADD COLUMN IF NOT EXISTS tipo VARCHAR(20) NOT NULL DEFAULT 'estoque';

CREATE INDEX IF NOT EXISTS idx_produtos_tipo ON produtos (tipo);

-- Recheios disponíveis quando o cliente pede Pastel
-- (não são produtos separados — só opções na hora da venda)
CREATE TABLE IF NOT EXISTS pastel_recheios (
  id SERIAL PRIMARY KEY,
  produto_id INTEGER NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  ordem INTEGER NOT NULL DEFAULT 0,
  UNIQUE (produto_id, nome)
);

CREATE INDEX IF NOT EXISTS idx_pastel_recheios_produto ON pastel_recheios (produto_id);

-- Qual recheio foi escolhido em cada item da venda
ALTER TABLE venda_itens
  ADD COLUMN IF NOT EXISTS recheio TEXT;

COMMENT ON COLUMN produtos.tipo IS 'estoque = normal com estoque | pastel = vendido sem baixar estoque';
COMMENT ON TABLE pastel_recheios IS 'Sabores/recheios do produto Pastel (preço único no produto)';
COMMENT ON COLUMN venda_itens.recheio IS 'Recheio escolhido quando o item for um pastel';
