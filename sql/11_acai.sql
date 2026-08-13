-- ============================================================
-- Açaí — tamanhos (produtos com estoque) + complementos (adicionais)
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

-- Tamanhos de açaí como produtos (controlam estoque na venda)
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
SELECT nome, categoria, qtd, qtd_minima, preco, tipo FROM (VALUES
  ('Açaí 300ml', 'Açaí', 30, 10, 10.00, 'estoque'),
  ('Açaí 500ml', 'Açaí', 30, 10, 14.00, 'estoque'),
  ('Açaí 700ml', 'Açaí', 30, 10, 18.00, 'estoque')
) AS v(nome, categoria, qtd, qtd_minima, preco, tipo)
WHERE NOT EXISTS (SELECT 1 FROM produtos WHERE produtos.nome = v.nome);

-- Complementos (adicionais com preço extra)
CREATE TABLE IF NOT EXISTS acai_complementos (
  id BIGSERIAL PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE,
  preco NUMERIC(10,2) NOT NULL DEFAULT 0,
  ordem INT NOT NULL DEFAULT 0
);

INSERT INTO acai_complementos (nome, preco, ordem)
SELECT nome, preco, ordem FROM (VALUES
  ('Granola',           1.50, 1),
  ('Leite condensado',  1.50, 2),
  ('Banana',            1.00, 3),
  ('Morango',           1.50, 4),
  ('Leite em pó',       1.00, 5),
  ('Paçoca',            1.50, 6)
) AS v(nome, preco, ordem)
WHERE NOT EXISTS (SELECT 1 FROM acai_complementos WHERE acai_complementos.nome = v.nome);
