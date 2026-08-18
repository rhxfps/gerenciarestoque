-- ============================================================
-- AÇAÍ — script completo (modelo estilo pastel)
-- Tamanhos SEM estoque próprio: o estoque é controlado pelos
-- copos (Copo 300 ML / 500 ML / 700 ML — já criados no 07b).
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

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

-- Tamanhos de açaí — tipo 'acai' = sem estoque (estilo pastel).
-- A baixa de estoque acontece no copo correspondente a cada venda/consumo.
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
SELECT nome, categoria, qtd, qtd_minima, preco, tipo FROM (VALUES
  ('Açaí 300ml', 'Açaí', 0, 0, 10.00, 'acai'),
  ('Açaí 500ml', 'Açaí', 0, 0, 15.00, 'acai')
) AS v(nome, categoria, qtd, qtd_minima, preco, tipo)
WHERE NOT EXISTS (SELECT 1 FROM produtos WHERE produtos.nome = v.nome);
