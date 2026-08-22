-- Migration: Vincular cardápio hamburguer ao estoque (produtos)
-- Rodar APÓS o schema hamburguer e o add_cardapio_to_produtos.sql

-- 1. Adicionar coluna produto_id pra vincular ao estoque pastel
ALTER TABLE hamburguer_cardapio ADD COLUMN IF NOT EXISTS produto_id INTEGER REFERENCES produtos(id) ON DELETE SET NULL;

-- 2. Constraint unique: cada produto só pode ter 1 entrada no cardápio
CREATE UNIQUE INDEX IF NOT EXISTS idx_hamburguer_cardapio_produto ON hamburguer_cardapio(produto_id) WHERE produto_id IS NOT NULL AND ativo = true;

-- 3. Migrar itens hardcoded que têm correspondente no produtos
-- Smash Burger
UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'Smash Burger' LIMIT 1)
WHERE nome = 'Smash Burger' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'Classic Burger' LIMIT 1)
WHERE nome = 'Classic Burger' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'X-Bacon' LIMIT 1)
WHERE nome = 'X-Bacon' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'X-Egg' LIMIT 1)
WHERE nome = 'X-Egg' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'X-Tudo' LIMIT 1)
WHERE nome = 'X-Tudo' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'Mini Burger' LIMIT 1)
WHERE nome = 'Mini Burger' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'Batata Frita' LIMIT 1)
WHERE nome = 'Batata Frita' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'Batata c/ Cheddar' LIMIT 1)
WHERE nome = 'Batata c/ Cheddar' AND produto_id IS NULL;

UPDATE hamburguer_cardapio SET produto_id = (SELECT id FROM produtos WHERE nome = 'Batata c/ Bacon' LIMIT 1)
WHERE nome = 'Batata c/ Bacon' AND produto_id IS NULL;
