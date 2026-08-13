-- ============================================================
-- Copos de açaí — produtos de embalagem descontados a cada açaí
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
SELECT nome, categoria, qtd, qtd_minima, preco, tipo FROM (VALUES
  ('Copo 300ml', 'Embalagens', 50, 20, 0.00, 'estoque'),
  ('Copo 500ml', 'Embalagens', 50, 20, 0.00, 'estoque'),
  ('Copo 700ml', 'Embalagens', 50, 20, 0.00, 'estoque')
) AS v(nome, categoria, qtd, qtd_minima, preco, tipo)
WHERE NOT EXISTS (SELECT 1 FROM produtos WHERE produtos.nome = v.nome);
