-- ============================================================
-- EXPORTAÇÃO DE FICHAS TÉCNICAS — RECEITAS — 2026-09-23
-- Rode no Supabase (SQL Editor) para restaurar em outra base.
-- ============================================================

-- INGREDIENTES
insert into public.ingredientes (id, nome, categoria, preco_compra, quanto_vem, unid_qvem, medida) values
  (74, 'CALABRESA', 'Carnes', 16, 1000, 'g', 'g'),
  (78, 'CATUPIRY', 'Laticinios', 46, 1000, 'g', 'g'),
  (80, 'BACON', 'Carnes', 20, 1000, 'g', 'g'),
  (90, 'MASSA PASTEL', 'Laticinios', 31.5, 50, 'un', 'un'),
  (95, 'MOLHO DE BACON', 'Laticinios', 19.99, 1000, 'g', 'g'),
  (14, 'CARNE MOÍDA', 'Carnes', 20, 1000, 'g', 'g'),
  (28, 'FRANGO', 'Carnes', 80, 5000, 'g', 'g'),
  (62, 'PRESUNTO', 'Carnes', 20, 1000, 'g', 'g'),
  (63, 'QUEIJO', 'Laticinios', 38, 1000, 'g', 'g'),
  (73, 'TOMATE', 'Hortifruti', 6.9, 1000, 'g', 'g'),
  (75, 'OREGANO', 'Hortifruti', 3, 100, 'g', 'g'),
  (81, 'CREME DE AVELA', 'Laticinios', 37, 1000, 'g', 'g'),
  (91, 'COXINHA', 'Salgados', 2.4, 1, 'un', 'un'),
  (55, 'ÓLEO SOJA', 'Oleos', 6.99, 900, 'g', 'g')
on conflict (id) do nothing;

-- FICHAS TÉCNICAS
insert into public.fichas (id, nome, categoria) values
  (1, 'PASTEL CARNE', 'Pastel'),
  (2, 'PASTEL DE FRANGO', 'Pastel'),
  (3, 'COXINHA', 'Salgado'),
  (4, 'PASTEL AVELA', 'Pastel'),
  (5, 'PASTEL PIZZA', 'Pastel'),
  (6, 'PASTEL CARNE COM QUEIJO', 'Pastel'),
  (7, 'PASTEL DE QUEIJO', 'Pastel'),
  (8, 'PASTEL DE CALABRESA', 'Pastel'),
  (9, 'PASTEL CALABRESA COM BACON', 'Pastel'),
  (10, 'PASTEL DE FRANGO COM CATUPIRY', 'Pastel'),
  (11, 'PASTEL CALABRESA COM BACON E QUEIJO', 'Pastel'),
  (12, 'PASTEL QUEIJO COM BACON', 'Pastel'),
  (13, 'PASTEL DE CALABRESA COM QUEIJO', 'Pastel'),
  (14, 'MOLHO DE BACON DA CASA', 'Pastel'),
  (15, 'PASTEL CARNE COM BACON', 'Pastel')
on conflict (id) do nothing;

-- RECEITAS — INGREDIENTES DE CADA FICHA
insert into public.ficha_ingredientes (ficha_id, ing_id, qtde) values
  (1, 14, 120),
  (1, 55, 0.01),
  (1, 90, 1),
  (6, 14, 60),
  (6, 55, 0.01),
  (6, 90, 1),
  (6, 63, 60),
  (5, 62, 60),
  (5, 63, 60),
  (5, 75, 0.1),
  (5, 73, 0.1),
  (5, 90, 1),
  (8, 74, 120),
  (8, 90, 1),
  (8, 55, 0.1),
  (7, 63, 120),
  (7, 90, 1),
  (7, 55, 0.1),
  (9, 90, 1),
  (9, 74, 60),
  (9, 80, 60),
  (9, 55, 1),
  (4, 90, 1),
  (4, 81, 120),
  (4, 55, 1),
  (2, 90, 1),
  (2, 28, 120),
  (2, 55, 1),
  (10, 90, 1),
  (10, 28, 60),
  (10, 55, 1),
  (10, 78, 60),
  (11, 90, 1),
  (11, 74, 60),
  (11, 80, 60),
  (11, 55, 1),
  (11, 63, 30),
  (12, 90, 1),
  (12, 80, 60),
  (12, 55, 1),
  (12, 63, 60),
  (3, 91, 1),
  (13, 74, 60),
  (13, 90, 1),
  (13, 55, 0.1),
  (13, 63, 60),
  (14, 95, 30),
  (15, 14, 60),
  (15, 80, 60)
on conflict (ficha_id, ing_id) do nothing;
