-- ============================================================
-- PASTEL — 1 produto, preço fixo R$ 14,00, sem estoque
-- Recheios são só escolha na venda (não mudam o preço)
-- Ajuste a lista de recheios conforme seu cardápio
-- ============================================================

-- Produto único (qtd 0 — não controla estoque na venda)
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES ('Pastel', 'Pastéis', 0, 0, 14.00, 'pastel');

-- Recheios que aparecem ao clicar em Pastel
INSERT INTO pastel_recheios (produto_id, nome, ordem)
SELECT p.id, r.nome, r.ordem
FROM produtos p
CROSS JOIN (VALUES
  ('Presunto e Queijo', 1),
  ('Queijo',            2),
  ('Calabresa',         3),
  ('Carne',             4),
  ('Frango',            5),
  ('Palmito',           6),
  ('Pizza',             7)
) AS r(nome, ordem)
WHERE p.nome = 'Pastel' AND p.tipo = 'pastel';
