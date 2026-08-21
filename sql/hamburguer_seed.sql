-- ============================================================
-- HAMBURGUER — Seed de estoque de ingredientes
-- Execute APÓS o schema (hamburguer_schema.sql)
-- ============================================================

INSERT INTO hamburguer_estoque (nome, icone, categoria, qtd, qtd_minima, unidade, preco_unitario) VALUES
  -- Pães
  ('Pão Brioche',        '🍞', 'Pães',      50, 20, 'un',  0.80),
  ('Pão Smash',          '🍞', 'Pães',      40, 15, 'un',  1.00),
  ('Pão Integral',       '🍞', 'Pães',      20, 10, 'un',  1.20),
  ('Pão Sedan',          '🍞', 'Pães',      30, 10, 'un',  0.90),

  -- Carnes
  ('Hambúrguer 150g',    '🥩', 'Carnes',     30, 15, 'un',  5.50),
  ('Smash 80g',          '🥩', 'Carnes',     40, 20, 'un',  3.50),
  ('Hambúrguer 200g',    '🥩', 'Carnes',     20, 10, 'un',  7.00),
  ('Frango Grelhado',    '🍗', 'Carnes',     15, 8,  'un',  4.50),
  ('Presunto',           '🥓', 'Carnes',     20, 10, 'un',  3.00),

  -- Queijos
  ('Queijo Cheddar',     '🧀', 'Queijos',    25, 10, 'un',  2.00),
  ('Queijo Mussarela',   '🧀', 'Queijos',    25, 10, 'un',  1.80),
  ('Cream Cheese',       '🧀', 'Queijos',    15, 5,  'un',  2.50),
  ('Queijo Suíço',       '🧀', 'Queijos',    10, 5,  'un',  3.00),

  -- Legumes / Verduras
  ('Alface',             '🥬', 'Legumes',    20, 10, 'un',  0.30),
  ('Tomate',             '🍅', 'Legumes',    20, 10, 'un',  0.50),
  ('Cebola',             '🧅', 'Legumes',    15, 8,  'un',  0.40),
  ('Cebola Caramelizada','🧅', 'Legumes',    10, 5,  'un',  1.50),
  ('Picles',             '🥒', 'Legumes',    10, 5,  'un',  1.00),
  (' Jalapeño',          '🌶️', 'Legumes',    8,  3,  'un',  1.50),

  -- Bacon / Ovos
  ('Bacon',              '🥓', 'Acompanhamentos', 20, 10, 'un', 2.50),
  ('Ovo Frito',          '🍳', 'Acompanhamentos', 30, 15, 'un', 0.80),

  -- Molhos
  ('Molho Especial',     '🫗', 'Molhos',     15, 8,  'ml',  0.10),
  ('Ketchup',            '🫗', 'Molhos',     20, 10, 'ml',  0.03),
  ('Mostarda',           '🫗', 'Molhos',     20, 10, 'ml',  0.03),
  ('Maionese',           '🫗', 'Molhos',     20, 10, 'ml',  0.04),
  ('BBQ',                '🫗', 'Molhos',     10, 5,  'ml',  0.08),
  ('Molho Ranch',        '🫗', 'Molhos',     10, 5,  'ml',  0.10),

  -- Batatas e Acompanhamentos
  ('Batata Palha',       '🍟', 'Acompanhamentos', 15, 8, 'kg', 8.00),
  ('Onion Rings',        '🧅', 'Acompanhamentos', 10, 5, 'un', 2.00),

  -- Bebidas
  ('Coca-Cola Lata',     '🥤', 'Bebidas',    24, 12, 'un', 3.50),
  ('Guaraná Lata',       '🥤', 'Bebidas',    24, 12, 'un', 3.00),
  ('Água Mineral',       '💧', 'Bebidas',    20, 10, 'un', 2.00),
  ('Suco Natural',       '🧃', 'Bebidas',    10, 5,  'un', 5.00),
  ('Heineken Lata',      '🍺', 'Bebidas',    12, 6,  'un', 7.00)

ON CONFLICT (nome) DO NOTHING;
