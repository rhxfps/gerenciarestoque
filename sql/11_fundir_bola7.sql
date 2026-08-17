-- ============================================================
-- Fundir "Bola 7 Verde" em "Bola 7"
-- (são o mesmo produto com nomes diferentes)
-- Execute no SQL Editor do Supabase
-- ============================================================

-- 1. Soma a qtd de "Bola 7 Verde" em "Bola 7"
UPDATE produtos
SET qtd = qtd + COALESCE(
  (SELECT qtd FROM produtos WHERE nome = 'Bola 7 Verde'), 0
)
WHERE nome = 'Bola 7';

-- 2. Se "Bola 7" não tem preço mas "Bola 7 Verde" tem, herda o preço
UPDATE produtos
SET preco = COALESCE(
  (SELECT preco FROM produtos WHERE nome = 'Bola 7 Verde'), preco
)
WHERE nome = 'Bola 7' AND (preco IS NULL OR preco = 0);

-- 3. Remove o duplicado
DELETE FROM produtos WHERE nome = 'Bola 7 Verde';

-- Verificar resultado:
-- SELECT id, nome, qtd, preco FROM produtos WHERE nome ILIKE 'bola 7%';
