-- ============================================================
-- HAMBURGUER — Schema do banco de dados
-- Estoque de ingredientes, cardápio, movimentações e vendas
-- Execute no SQL Editor do Supabase
-- ============================================================

-- ESTOQUE: ingredientes compartilhados (pão, carne, queijo, etc.)
CREATE TABLE IF NOT EXISTS hamburguer_estoque (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE,
  icone TEXT DEFAULT '🍔',
  categoria TEXT NOT NULL DEFAULT 'Geral',
  qtd NUMERIC(10,2) NOT NULL DEFAULT 0,
  qtd_minima NUMERIC(10,2) NOT NULL DEFAULT 0,
  unidade TEXT NOT NULL DEFAULT 'un',
  preco_unitario NUMERIC(10,2) DEFAULT 0,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hamburguer_estoque_nome ON hamburguer_estoque (nome);
CREATE INDEX IF NOT EXISTS idx_hamburguer_estoque_categoria ON hamburguer_estoque (categoria);

-- CARDÁPIO: lanches do menu (persistido no banco)
CREATE TABLE IF NOT EXISTS hamburguer_cardapio (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT DEFAULT '',
  emoji TEXT DEFAULT '🍔',
  preco NUMERIC(10,2) NOT NULL DEFAULT 0,
  categoria TEXT NOT NULL DEFAULT 'Classicos',
  tags TEXT[] DEFAULT '{}',
  ativo BOOLEAN NOT NULL DEFAULT true,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- INGREDIENTES DO CARDÁPIO: quais ingredientes tem cada lanche
CREATE TABLE IF NOT EXISTS hamburguer_cardapio_ings (
  id SERIAL PRIMARY KEY,
  cardapio_id INTEGER NOT NULL REFERENCES hamburguer_cardapio(id) ON DELETE CASCADE,
  estoque_id INTEGER REFERENCES hamburguer_estoque(id) ON DELETE SET NULL,
  nome TEXT NOT NULL,
  icone TEXT DEFAULT '🍔',
  removivel BOOLEAN NOT NULL DEFAULT false,
  ordem INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_hcardapio_ings_cardapio ON hamburguer_cardapio_ings (cardapio_id);

-- EXTRAS DO CARDÁPIO: complementos disponíveis para cada lanche
CREATE TABLE IF NOT EXISTS hamburguer_cardapio_extras (
  id SERIAL PRIMARY KEY,
  cardapio_id INTEGER NOT NULL REFERENCES hamburguer_cardapio(id) ON DELETE CASCADE,
  estoque_id INTEGER REFERENCES hamburguer_estoque(id) ON DELETE SET NULL,
  nome TEXT NOT NULL,
  icone TEXT DEFAULT '🍔',
  preco NUMERIC(10,2) NOT NULL DEFAULT 0,
  ordem INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_hcardapio_extras_cardapio ON hamburguer_cardapio_extras (cardapio_id);

-- VENDAS: registro de vendas de hambúrgueres
CREATE TABLE IF NOT EXISTS hamburguer_vendas (
  id SERIAL PRIMARY KEY,
  comanda_num INTEGER,
  cliente TEXT,
  total NUMERIC(10,2) NOT NULL DEFAULT 0,
  pagamento TEXT DEFAULT 'dinheiro',
  obs TEXT DEFAULT '',
  usuario_id INTEGER REFERENCES usuarios(id),
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hvendas_data ON hamburguer_vendas (data DESC);
CREATE INDEX IF NOT EXISTS idx_hvendas_comanda ON hamburguer_vendas (comanda_num);

-- ITENS DA VENDA: cada item dentro de uma venda
CREATE TABLE IF NOT EXISTS hamburguer_venda_itens (
  id SERIAL PRIMARY KEY,
  venda_id INTEGER NOT NULL REFERENCES hamburguer_vendas(id) ON DELETE CASCADE,
  cardapio_id INTEGER REFERENCES hamburguer_cardapio(id) ON DELETE SET NULL,
  nome TEXT NOT NULL,
  emoji TEXT DEFAULT '🍔',
  qtd INTEGER NOT NULL DEFAULT 1,
  preco_unitario NUMERIC(10,2) NOT NULL DEFAULT 0,
  ingredientes_removidos TEXT[] DEFAULT '{}',
  extras_adicionados JSONB DEFAULT '[]',
  observacao TEXT DEFAULT ''
);

CREATE INDEX IF NOT EXISTS idx_hvenda_itens_venda ON hamburguer_venda_itens (venda_id);

-- MOVIMENTAÇÕES: entradas e saídas de estoque de ingredientes
CREATE TABLE IF NOT EXISTS hamburguer_movimentacoes (
  id SERIAL PRIMARY KEY,
  tipo TEXT NOT NULL CHECK (tipo IN ('entrada', 'saida', 'ajuste')),
  estoque_id INTEGER NOT NULL REFERENCES hamburguer_estoque(id) ON DELETE CASCADE,
  produto_nome TEXT NOT NULL,
  qtd NUMERIC(10,2) NOT NULL,
  obs TEXT DEFAULT '',
  usuario_id INTEGER REFERENCES usuarios(id),
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hmov_estoque ON hamburguer_movimentacoes (estoque_id);
CREATE INDEX IF NOT EXISTS idx_hmov_data ON hamburguer_movimentacoes (data DESC);
