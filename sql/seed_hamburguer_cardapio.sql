-- Seed: Inserir itens do cardápio hamburguer no banco
-- Rodar APÓS o schema hamburguer + add_cardapio_to_produtos.sql + add_produto_id_to_cardapio.sql
-- Os itens são vinculados aos produtos pelo nome

-- Smash Burger
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'Smash Burger', '2 smash 80g, queijo duplo, cebola caramelizada e molho especial', '💥', 29.90, 'Especiais', '["popular"]', true
FROM produtos p WHERE p.nome = 'Smash Burger'
ON CONFLICT DO NOTHING;

-- Classic Burger
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'Classic Burger', 'Pao brioche, hamburguer 150g, cheddar, alface, tomate e molho especial', '🍔', 22.90, 'Classicos', '[]', true
FROM produtos p WHERE p.nome = 'Classic Burger'
ON CONFLICT DO NOTHING;

-- X-Bacon
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'X-Bacon', 'Pao brioche, hamburguer 150g, queijo, bacon crocante e molho', '🥓', 25.90, 'Classicos', '[]', true
FROM produtos p WHERE p.nome = 'X-Bacon'
ON CONFLICT DO NOTHING;

-- X-Egg
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'X-Egg', 'Pao brioche, hamburguer 150g, queijo, ovo frito e molho especial', '🍳', 24.90, 'Classicos', '[]', true
FROM produtos p WHERE p.nome = 'X-Egg'
ON CONFLICT DO NOTHING;

-- X-Tudo
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'X-Tudo', 'Pao brioche, hamburguer, queijo, bacon, ovo, presunto, alface e tomate', '🌮', 29.90, 'Especiais', '["popular"]', true
FROM produtos p WHERE p.nome = 'X-Tudo'
ON CONFLICT DO NOTHING;

-- Mini Burger
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'Mini Burger', 'Pao mini, hamburguer 100g e queijo cheddar', '🍔', 15.90, 'Classicos', '["novo"]', true
FROM produtos p WHERE p.nome = 'Mini Burger'
ON CONFLICT DO NOTHING;

-- Batata Frita
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'Batata Frita', 'Porcao generosa de batata frita crocante', '🍟', 14.00, 'Batatas', '[]', true
FROM produtos p WHERE p.nome = 'Batata Frita'
ON CONFLICT DO NOTHING;

-- Batata c/ Cheddar
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'Batata c/ Cheddar', 'Batata frita com cheddar cremoso', '🍟', 18.00, 'Batatas', '["popular"]', true
FROM produtos p WHERE p.nome = 'Batata c/ Cheddar'
ON CONFLICT DO NOTHING;

-- Batata c/ Bacon
INSERT INTO hamburguer_cardapio (produto_id, nome, descricao, emoji, preco, categoria, tags, ativo)
SELECT p.id, 'Batata c/ Bacon', 'Batata frita com cheddar e bacon crocante', '🍟', 20.00, 'Batatas', '[]', true
FROM produtos p WHERE p.nome = 'Batata c/ Bacon'
ON CONFLICT DO NOTHING;

-- Inserir ingredientes para cada item do cardápio
DO $$
DECLARE
  card_id INTEGER;
BEGIN
  -- Smash Burger
  SELECT id INTO card_id FROM hamburguer_cardapio WHERE nome = 'Smash Burger' AND ativo = true LIMIT 1;
  IF card_id IS NOT NULL THEN
    INSERT INTO hamburguer_cardapio_ings (cardapio_id, nome, icone, removivel, ordem) VALUES
      (card_id, 'Pao smash', '🍞', false, 0),
      (card_id, '2x Smash 80g', '🥩', false, 1),
      (card_id, 'Queijo duplo', '🧀', true, 2),
      (card_id, 'Cebola caramelizada', '🧅', true, 3),
      (card_id, 'Molho especial', '🥄', true, 4);
    INSERT INTO hamburguer_cardapio_extras (cardapio_id, nome, icone, preco, ordem) VALUES
      (card_id, 'Bacon', '🥓', 4.00, 0),
      (card_id, 'Ovo frito', '🍳', 2.50, 1),
      (card_id, 'Cheddar extra', '🧀', 3.00, 2),
      (card_id, 'Jalapeno', '🌶️', 2.50, 3);
  END IF;

  -- Classic Burger
  SELECT id INTO card_id FROM hamburguer_cardapio WHERE nome = 'Classic Burger' AND ativo = true LIMIT 1;
  IF card_id IS NOT NULL THEN
    INSERT INTO hamburguer_cardapio_ings (cardapio_id, nome, icone, removivel, ordem) VALUES
      (card_id, 'Pao brioche', '🍞', false, 0),
      (card_id, 'Hamburguer 150g', '🥩', false, 1),
      (card_id, 'Queijo cheddar', '🧀', true, 2),
      (card_id, 'Alface', '🥬', true, 3),
      (card_id, 'Tomate', '🍅', true, 4),
      (card_id, 'Molho especial', '🥄', true, 5);
    INSERT INTO hamburguer_cardapio_extras (cardapio_id, nome, icone, preco, ordem) VALUES
      (card_id, 'Bacon', '🥓', 4.00, 0),
      (card_id, 'Ovo frito', '🍳', 2.50, 1),
      (card_id, 'Onion rings', '🧅', 5.00, 2);
  END IF;

  -- X-Bacon
  SELECT id INTO card_id FROM hamburguer_cardapio WHERE nome = 'X-Bacon' AND ativo = true LIMIT 1;
  IF card_id IS NOT NULL THEN
    INSERT INTO hamburguer_cardapio_ings (cardapio_id, nome, icone, removivel, ordem) VALUES
      (card_id, 'Pao brioche', '🍞', false, 0),
      (card_id, 'Hamburguer 150g', '🥩', false, 1),
      (card_id, 'Queijo cheddar', '🧀', true, 2),
      (card_id, 'Bacon crocante', '🥓', true, 3),
      (card_id, 'Molho especial', '🥄', true, 4);
    INSERT INTO hamburguer_cardapio_extras (cardapio_id, nome, icone, preco, ordem) VALUES
      (card_id, 'Ovo frito', '🍳', 2.50, 0),
      (card_id, 'Cheddar extra', '🧀', 3.00, 1),
      (card_id, 'Cebola caramelizada', '🧅', 3.00, 2);
  END IF;

  -- X-Egg
  SELECT id INTO card_id FROM hamburguer_cardapio WHERE nome = 'X-Egg' AND ativo = true LIMIT 1;
  IF card_id IS NOT NULL THEN
    INSERT INTO hamburguer_cardapio_ings (cardapio_id, nome, icone, removivel, ordem) VALUES
      (card_id, 'Pao brioche', '🍞', false, 0),
      (card_id, 'Hamburguer 150g', '🥩', false, 1),
      (card_id, 'Queijo cheddar', '🧀', true, 2),
      (card_id, 'Ovo frito', '🍳', true, 3),
      (card_id, 'Molho especial', '🥄', true, 4);
    INSERT INTO hamburguer_cardapio_extras (cardapio_id, nome, icone, preco, ordem) VALUES
      (card_id, 'Bacon', '🥓', 4.00, 0),
      (card_id, 'Cheddar extra', '🧀', 3.00, 1);
  END IF;

  -- X-Tudo
  SELECT id INTO card_id FROM hamburguer_cardapio WHERE nome = 'X-Tudo' AND ativo = true LIMIT 1;
  IF card_id IS NOT NULL THEN
    INSERT INTO hamburguer_cardapio_ings (cardapio_id, nome, icone, removivel, ordem) VALUES
      (card_id, 'Pao brioche', '🍞', false, 0),
      (card_id, 'Hamburguer 150g', '🥩', false, 1),
      (card_id, 'Queijo cheddar', '🧀', true, 2),
      (card_id, 'Bacon', '🥓', true, 3),
      (card_id, 'Ovo frito', '🍳', true, 4),
      (card_id, 'Presunto', '🍔', true, 5),
      (card_id, 'Alface', '🥬', true, 6),
      (card_id, 'Tomate', '🍅', true, 7);
    INSERT INTO hamburguer_cardapio_extras (cardapio_id, nome, icone, preco, ordem) VALUES
      (card_id, 'Cebola caramelizada', '🧅', 3.00, 0),
      (card_id, 'Cheddar extra', '🧀', 3.00, 1);
  END IF;

  -- Mini Burger
  SELECT id INTO card_id FROM hamburguer_cardapio WHERE nome = 'Mini Burger' AND ativo = true LIMIT 1;
  IF card_id IS NOT NULL THEN
    INSERT INTO hamburguer_cardapio_ings (cardapio_id, nome, icone, removivel, ordem) VALUES
      (card_id, 'Pao mini', '🍞', false, 0),
      (card_id, 'Hamburguer 100g', '🥩', false, 1),
      (card_id, 'Queijo cheddar', '🧀', true, 2);
    INSERT INTO hamburguer_cardapio_extras (cardapio_id, nome, icone, preco, ordem) VALUES
      (card_id, 'Bacon', '🥓', 4.00, 0),
      (card_id, 'Ovo frito', '🍳', 2.50, 1);
  END IF;
END $$;
