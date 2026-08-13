-- ============================================================
-- Salgados — inserir produtos com estoque inicial 10
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo) VALUES
  ('Coxinha de Frango',            'Salgados', 10, 5, 4.00, 'estoque'),
  ('Coxinha com Catupiry',         'Salgados', 10, 5, 4.50, 'estoque'),
  ('Bolinho de Queijo',            'Salgados', 10, 5, 4.00, 'estoque'),
  ('Risole de Presunto e Queijo',  'Salgados', 10, 5, 4.00, 'estoque'),
  ('Enroladinho de Salsicha',      'Salgados', 10, 5, 4.00, 'estoque'),
  ('Bolinho de Carne',             'Salgados', 10, 5, 4.00, 'estoque');
