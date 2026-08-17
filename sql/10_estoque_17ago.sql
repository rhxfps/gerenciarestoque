-- ============================================================
-- Atualização de estoque — 17/08
-- Apenas atualiza qtd. Preços NÃO são alterados.
-- Produtos novos são inseridos com preco = 0 para você ajustar.
-- Execute no SQL Editor do Supabase.
-- ============================================================

-- ─── BEBIDAS ─────────────────────────────────────────────────
UPDATE produtos SET qtd = 19  WHERE nome ILIKE 'guaraná lata%'           AND categoria ILIKE 'bebidas%';
UPDATE produtos SET qtd = 14  WHERE nome ILIKE 'coca-cola lata%'          AND categoria ILIKE 'bebidas%';
UPDATE produtos SET qtd = 12  WHERE nome ILIKE 'fanta lata%'              AND categoria ILIKE 'bebidas%';
UPDATE produtos SET qtd = 16  WHERE nome ILIKE 'coca-cola zero 200%';
UPDATE produtos SET qtd = 33  WHERE nome ILIKE 'coca-cola 200%'           AND nome NOT ILIKE '%zero%';
UPDATE produtos SET qtd = 21  WHERE nome ILIKE 'sprite%';
UPDATE produtos SET qtd = 52  WHERE nome ILIKE 'água sem gás';
UPDATE produtos SET qtd = 12  WHERE nome ILIKE 'água com gás';
UPDATE produtos SET qtd = 6   WHERE nome ILIKE 'água de coco 200%';
UPDATE produtos SET qtd = 9   WHERE nome ILIKE 'todynho%' OR nome ILIKE 'todinho%';
UPDATE produtos SET qtd = 4   WHERE nome ILIKE 'coca-cola zero lata%';
UPDATE produtos SET qtd = 3   WHERE nome ILIKE 'guaraná zero lata%';
UPDATE produtos SET qtd = 4   WHERE nome ILIKE 'sukita%lata%';
UPDATE produtos SET qtd = 4   WHERE nome ILIKE 'gatorade%';
UPDATE produtos SET qtd = 15  WHERE nome ILIKE 'heineken%';
UPDATE produtos SET qtd = 5   WHERE nome ILIKE 'skol beats%' OR nome ILIKE 'beats%';
UPDATE produtos SET qtd = 31  WHERE nome ILIKE 'original%'               AND categoria ILIKE 'bebidas%';
UPDATE produtos SET qtd = 11  WHERE nome ILIKE 'skol%'                   AND nome NOT ILIKE '%beats%';
UPDATE produtos SET qtd = 1   WHERE nome ILIKE 'coca-cola 600%';
UPDATE produtos SET qtd = 2   WHERE nome ILIKE 'tônica%' OR nome ILIKE 'tonica%';
UPDATE produtos SET qtd = 3   WHERE nome ILIKE 'furioso%' OR nome ILIKE 'energético furioso%';

-- Guaraná 1 litro — pode ter nome diferente, tenta por padrão
UPDATE produtos SET qtd = 11  WHERE nome ILIKE 'guaraná 1%';

-- Novos itens de bebida (inserir se não existir)
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES
  ('Fanta Lata 350 ML',             'Bebidas', 12, 5,  0, 'estoque'),
  ('Guaraná Lata 350 ML',           'Bebidas', 19, 5,  0, 'estoque'),
  ('Coca-Cola Lata 350 ML',         'Bebidas', 14, 5,  0, 'estoque'),
  ('Sprite 200 ML',                 'Bebidas', 21, 5,  0, 'estoque'),
  ('Sukita 200 ML',                 'Bebidas', 12, 5,  0, 'estoque'),
  ('Soda 200 ML',                   'Bebidas', 13, 5,  0, 'estoque'),
  ('Guaraná 1 Litro',               'Bebidas', 11, 5,  0, 'estoque'),
  ('Energético Lata',               'Bebidas',  1, 2,  0, 'estoque'),
  ('Del Valle Uva 290 ML',          'Bebidas',  4, 3,  0, 'estoque'),
  ('Del Valle Goiaba 290 ML',       'Bebidas',  4, 3,  0, 'estoque'),
  ('Del Valle Pêssego 290 ML',      'Bebidas',  4, 3,  0, 'estoque'),
  ('Del Valle Manga 290 ML',        'Bebidas',  5, 3,  0, 'estoque'),
  ('Guaraviton Açaí 500 ML',        'Bebidas',  2, 2,  0, 'estoque'),
  ('TNT Tangerina 500 ML',          'Bebidas',  3, 3,  0, 'estoque'),
  ('TNT Uva 500 ML',                'Bebidas',  3, 3,  0, 'estoque')
ON CONFLICT (nome) DO UPDATE SET qtd = EXCLUDED.qtd;

-- TNT Sport já existia, só atualiza
UPDATE produtos SET qtd = 3 WHERE nome ILIKE 'tnt sport%';

-- ─── DOCES ───────────────────────────────────────────────────
UPDATE produtos SET qtd = 132 WHERE nome ILIKE 'paçoca%';
UPDATE produtos SET qtd = 65  WHERE nome ILIKE 'poosh vermelho%';
UPDATE produtos SET qtd = 73  WHERE nome ILIKE 'poosh rox%' OR nome ILIKE 'poosh rosa%';
UPDATE produtos SET qtd = 80  WHERE nome ILIKE 'poosh verde%';
UPDATE produtos SET qtd = 23  WHERE nome ILIKE 'bala azedinha%' AND nome NOT ILIKE '%rox%';
UPDATE produtos SET qtd = 84  WHERE nome ILIKE 'bala freegells%';
UPDATE produtos SET qtd = 4   WHERE nome ILIKE 'freegells gum tutti%';
UPDATE produtos SET qtd = 6   WHERE nome ILIKE 'freegells gum menta%';
UPDATE produtos SET qtd = 6   WHERE nome ILIKE 'freegells gum morango%';
UPDATE produtos SET qtd = 4   WHERE nome ILIKE 'freegells menta%';
UPDATE produtos SET qtd = 3   WHERE nome ILIKE 'freegells choco%';
UPDATE produtos SET qtd = 6   WHERE nome ILIKE 'freegells preto%';
UPDATE produtos SET qtd = 26  WHERE nome ILIKE 'ouro branco%';
UPDATE produtos SET qtd = 103 WHERE nome ILIKE 'dadinho%';
UPDATE produtos SET qtd = 113 WHERE nome ILIKE 'bala de hortelã%' OR nome ILIKE 'bala hortelã%';
UPDATE produtos SET qtd = 66  WHERE nome ILIKE 'balinha do coração%' OR nome ILIKE 'balinha coração%';
UPDATE produtos SET qtd = 46  WHERE nome ILIKE 'gluds%' OR nome ILIKE 'guds%';
UPDATE produtos SET qtd = 19  WHERE nome ILIKE 'gomets%' OR nome ILIKE 'gomes%';
UPDATE produtos SET qtd = 19  WHERE nome ILIKE 'pé de moça%';
UPDATE produtos SET qtd = 53  WHERE nome ILIKE 'pirulito coca%' OR nome ILIKE 'pirulito pop kiss%';
UPDATE produtos SET qtd = 2   WHERE nome ILIKE 'chocolate ki-kakau%';
UPDATE produtos SET qtd = 6   WHERE nome ILIKE 'pirulito bolete%';
UPDATE produtos SET qtd = 52  WHERE nome ILIKE 'bala bolete%';
UPDATE produtos SET qtd = 38  WHERE nome ILIKE 'plutonita%' OR nome ILIKE 'blutonita%';

-- Novos doces (inserir se não existir)
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES
  ('Bala Azedinha Roxa',       'Doces e Guloseimas',  96, 10, 0, 'estoque'),
  ('Bola 7 Verde',             'Doces e Guloseimas', 145, 20, 0, 'estoque'),
  ('Bala Caramelo',            'Doces e Guloseimas',  79, 10, 0, 'estoque'),
  ('Bala Iceriss',             'Doces e Guloseimas', 113, 20, 0, 'estoque'),
  ('Outro Doce',               'Doces e Guloseimas',  19,  5, 0, 'estoque'),
  ('Fini Azedinho',            'Doces e Guloseimas',   8,  5, 0, 'estoque'),
  ('Fini Verde Azedo',         'Doces e Guloseimas',   5,  5, 0, 'estoque'),
  ('Pirulito Boca Cereja',     'Doces e Guloseimas',  18,  5, 0, 'estoque'),
  ('Pirulito Coração Morango', 'Doces e Guloseimas',  18,  5, 0, 'estoque')
ON CONFLICT (nome) DO UPDATE SET qtd = EXCLUDED.qtd;

-- Fini Uva já existe
UPDATE produtos SET qtd = 7 WHERE nome ILIKE 'fini uva%';

-- ─── SALGADOS E MASSAS ────────────────────────────────────────
UPDATE produtos SET qtd = 56 WHERE nome ILIKE 'coxinha de frango%' OR nome ILIKE 'coxinha%' AND nome NOT ILIKE '%catupiry%' AND categoria ILIKE 'salgados%';
UPDATE produtos SET qtd = 46 WHERE nome ILIKE 'risole%presunto%' OR nome ILIKE 'presunto%queijo%';
UPDATE produtos SET qtd = 31 WHERE nome ILIKE 'enroladinho%';
UPDATE produtos SET qtd = 15 WHERE nome ILIKE 'coxinha%catupiry%';
UPDATE produtos SET qtd = 25 WHERE nome ILIKE 'massa de pastel%';

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES
  ('Mini Pizza', 'Salgados', 24, 5, 0, 'estoque')
ON CONFLICT (nome) DO UPDATE SET qtd = EXCLUDED.qtd;

-- ─── CONGELADOS E GELADINHOS ─────────────────────────────────
UPDATE produtos SET qtd = 8  WHERE nome ILIKE 'geladinho%limão%' OR nome ILIKE 'geladinho limao%';
UPDATE produtos SET qtd = 2  WHERE nome ILIKE 'trufa de coco%';
UPDATE produtos SET qtd = 2  WHERE nome ILIKE 'trufa de morango%' OR nome ILIKE 'trufa morango%';

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES
  ('Morango Congelado',                     'Congelados',  2, 1, 0.00, 'estoque'),
  ('Geladinho Açaí com Nutella',            'Geladinhos',  5, 3, 7.00, 'estoque'),
  ('Geladinho Açaí com Leite Condensado',   'Geladinhos',  5, 3, 7.00, 'estoque')
ON CONFLICT (nome) DO UPDATE SET qtd = EXCLUDED.qtd;

-- ─── INGREDIENTES E MOLHOS ────────────────────────────────────
UPDATE produtos SET qtd = 1  WHERE nome ILIKE 'molho de tomate%';
UPDATE produtos SET qtd = 2  WHERE nome ILIKE 'milho%';
UPDATE produtos SET qtd = 6  WHERE nome ILIKE 'pimenta%' OR nome ILIKE 'molho de pimenta%';
UPDATE produtos SET qtd = 1  WHERE nome ILIKE 'molho de salsa%';

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES
  ('Mel',              'Condimentos', 1, 1, 0, 'estoque'),
  ('Azeitona',         'Condimentos', 2, 1, 0, 'estoque'),
  ('Leite',            'Condimentos', 2, 1, 0, 'estoque'),
  ('Creme de Leite 200g', 'Condimentos', 2, 1, 0, 'estoque'),
  ('Creme de Leite 1kg',  'Condimentos', 1, 1, 0, 'estoque'),
  ('Maionese',         'Condimentos', 1, 1, 0, 'estoque'),
  ('Ketchup',          'Condimentos', 1, 1, 0, 'estoque'),
  ('Mostarda',         'Condimentos', 1, 1, 0, 'estoque')
ON CONFLICT (nome) DO UPDATE SET qtd = EXCLUDED.qtd;

-- ─── EMBALAGENS E SACOS ───────────────────────────────────────
UPDATE produtos SET qtd = 46 WHERE nome ILIKE 'saco p%' OR nome ILIKE 'sacos p%';
UPDATE produtos SET qtd = 48 WHERE nome ILIKE 'saco m%' OR nome ILIKE 'sacos m%';
UPDATE produtos SET qtd = 40 WHERE nome ILIKE 'saco g%' OR nome ILIKE 'sacos g%';
UPDATE produtos SET qtd = 7  WHERE nome ILIKE 'copo 500%';
UPDATE produtos SET qtd = 9  WHERE nome ILIKE 'copo 300%';
UPDATE produtos SET qtd = 7  WHERE nome ILIKE 'guardanapo%' AND categoria ILIKE 'descartáveis%';
UPDATE produtos SET qtd = 4  WHERE nome ILIKE 'papel toalha%';

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES
  ('Colher G',  'Embalagens', 29, 5, 0, 'estoque'),
  ('Colher P',  'Embalagens', 46, 5, 0, 'estoque')
ON CONFLICT (nome) DO UPDATE SET qtd = EXCLUDED.qtd;
