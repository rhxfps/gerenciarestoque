-- ============================================================
-- PASSO 1 — Adicionar constraint UNIQUE em nome (rode uma vez)
-- Se já existir a constraint, este comando vai retornar erro — ignore.
-- ============================================================
ALTER TABLE produtos ADD CONSTRAINT produtos_nome_unique UNIQUE (nome);

-- ============================================================
-- PASSO 2 — Upsert completo (rode logo após o PASSO 1)
-- Se o produto já existe pelo nome: atualiza qtd e categoria
-- Se não existe: insere novo
-- ============================================================

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo) VALUES

-- DOCES E BALAS
('Bala Bolete',               'Doces e Guloseimas', 79,  10, 0,    'estoque'),
('Pirulito Bolete',           'Doces e Guloseimas', 6,   5,  0,    'estoque'),
('Chocolate Ki-Kakau',        'Doces e Guloseimas', 2,   3,  0,    'estoque'),
('Fini Vermelho',             'Doces e Guloseimas', 14,  5,  0,    'estoque'),
('Fini Roxo',                 'Doces e Guloseimas', 10,  5,  0,    'estoque'),
('Fini Verde Azedo',          'Doces e Guloseimas', 8,   5,  0,    'estoque'),
('Paçoca',                    'Doces e Guloseimas', 37,  5,  0,    'estoque'),
('Ouro Branco',               'Doces e Guloseimas', 4,   5,  0,    'estoque'),
('Tortuguita',                'Doces e Guloseimas', 1,   3,  0,    'estoque'),
('Freegells Gum Menta',       'Doces e Guloseimas', 10,  5,  0,    'estoque'),
('Freegells Gum Tutti Frutti','Doces e Guloseimas', 7,   5,  0,    'estoque'),
('Freegells Gum Morango',     'Doces e Guloseimas', 8,   5,  0,    'estoque'),
('Plutonita',                 'Doces e Guloseimas', 59,  10, 0,    'estoque'),
('Poosh Verde',               'Doces e Guloseimas', 62,  10, 0,    'estoque'),
('Poosh Vermelho',            'Doces e Guloseimas', 69,  10, 0,    'estoque'),
('Poosh Rosa',                'Doces e Guloseimas', 32,  10, 0,    'estoque'),
('Poosh 7 Belo',              'Doces e Guloseimas', 8,   5,  0,    'estoque'),
('Poosh Roxo',                'Doces e Guloseimas', 9,   5,  0,    'estoque'),
('Pirulito Coca',             'Doces e Guloseimas', 21,  5,  0,    'estoque'),
('Pirulito Boca',             'Doces e Guloseimas', 56,  10, 0,    'estoque'),
('Pirulito Coração',          'Doces e Guloseimas', 24,  5,  0,    'estoque'),
('Bala Freegells',            'Doces e Guloseimas', 109, 20, 0,    'estoque'),
('Freegells Menta',           'Doces e Guloseimas', 13,  5,  0,    'estoque'),
('Freegells Choco',           'Doces e Guloseimas', 7,   5,  0,    'estoque'),
('Freegells Preto',           'Doces e Guloseimas', 8,   5,  0,    'estoque'),
('Dadinho',                   'Doces e Guloseimas', 122, 20, 0,    'estoque'),
('Bala de Hortelã',           'Doces e Guloseimas', 46,  10, 0,    'estoque'),
('Balinha do Coração',        'Doces e Guloseimas', 66,  10, 0,    'estoque'),
('Bola 7',                    'Doces e Guloseimas', 97,  20, 0,    'estoque'),
('Bala Azedinha',             'Doces e Guloseimas', 44,  10, 0,    'estoque'),
('Gluds Ball',                'Doces e Guloseimas', 53,  10, 0,    'estoque'),
('Gomets Tubo',               'Doces e Guloseimas', 22,  5,  0,    'estoque'),
('Geleia de Frutas',          'Doces e Guloseimas', 9,   3,  0,    'estoque'),
('Doces Tony Kelly',          'Doces e Guloseimas', 3,   3,  0,    'estoque'),
('Doce de Abóbora',           'Doces e Guloseimas', 3,   3,  0,    'estoque'),
('Pé de Moça',                'Doces e Guloseimas', 11,  5,  0,    'estoque'),
('Fount de Leite',            'Doces e Guloseimas', 17,  5,  0,    'estoque'),
('Molecão',                   'Doces e Guloseimas', 4,   3,  0,    'estoque'),
('Doce de Banana',            'Doces e Guloseimas', 17,  5,  0,    'estoque'),
('Pacote Bala Bolete Fechado','Doces e Guloseimas', 1,   1,  0,    'estoque'),

-- EMBALAGENS
('Copo Fechado 180 ML',       'Embalagens', 0,   5,  0, 'estoque'),
('Copo 500 ML',               'Embalagens', 49,  10, 0, 'estoque'),
('Pote 100 ML',               'Embalagens', 0,   5,  0, 'estoque'),
('Blulister 50 un',           'Embalagens', 1,   1,  0, 'estoque'),
('Garrafa 200 ML',            'Embalagens', 6,   3,  0, 'estoque'),
('Garrafa 300 ML',            'Embalagens', 3,   3,  0, 'estoque'),
('Copo Térmico 300 ML',       'Embalagens', 19,  5,  0, 'estoque'),
('Mini Tampa Descartável',    'Embalagens', 25,  5,  0, 'estoque'),
('Rolo de Papel Alumínio 4M', 'Embalagens', 2,   1,  0, 'estoque'),
('Rolo de Papel Alumínio 7,5M','Embalagens',1,   1,  0, 'estoque'),
('Saquinho Colher Sobremesa 50un','Embalagens',1, 1,  0, 'estoque'),
('Tampa Descartável 300 ML',  'Embalagens', 49,  10, 0, 'estoque'),
('Tampa Descartável 100 ML',  'Embalagens', 136, 20, 0, 'estoque'),
('Copo 180 ML',               'Embalagens', 68,  20, 0, 'estoque'),
('Copo 100 ML',               'Embalagens', 91,  20, 0, 'estoque'),
('Blister',                   'Embalagens', 25,  5,  0, 'estoque'),
('Copo 60 ML',                'Embalagens', 27,  10, 0, 'estoque'),
('Mini Pote de Isopor',       'Embalagens', 14,  5,  0, 'estoque'),
('Mini Tampa de Isopor',      'Embalagens', 5,   5,  0, 'estoque'),
('Copo 300 ML',               'Embalagens', 13,  5,  0, 'estoque'),
('Copo 700 ML',               'Embalagens', 25,  5,  0, 'estoque'),
('Pote 240 ML',               'Embalagens', 24,  5,  0, 'estoque'),
('Tampa 300 ML',              'Embalagens', 45,  10, 0, 'estoque'),
('Tampa 500 ML',              'Embalagens', 40,  10, 0, 'estoque'),
('Tampa 240 ML',              'Embalagens', 25,  5,  0, 'estoque'),
('Embalagem Pastel P',        'Embalagens', 83,  20, 0, 'estoque'),
('Embalagem Pastel G',        'Embalagens', 319, 50, 0, 'estoque'),
('Canudos',                   'Embalagens', 313, 50, 0, 'estoque'),
('Saco P',                    'Embalagens', 10,  5,  0, 'estoque'),
('Saco M',                    'Embalagens', 4,   3,  0, 'estoque'),
('Saco G',                    'Embalagens', 41,  10, 0, 'estoque'),
('Suporte de Papel',          'Embalagens', 22,  5,  0, 'estoque'),
('Suporte Batata Viagem P',   'Embalagens', 8,   3,  0, 'estoque'),
('Suporte Batata Viagem M',   'Embalagens', 10,  3,  0, 'estoque'),
('Suporte Batata Viagem G',   'Embalagens', 8,   3,  0, 'estoque'),
('Colher Pacote P 50 un',     'Embalagens', 1,   1,  0, 'estoque'),

-- DESCARTÁVEIS
('Papel Toalha G',            'Descartáveis', 9, 3, 0, 'estoque'),
('Guardanapo',                'Descartáveis', 7, 2, 0, 'estoque'),
('Guardanapo 200 un',         'Descartáveis', 1, 1, 0, 'estoque'),

-- BEBIDAS
('Coca-Cola 600 ML',          'Bebidas', 3,  5,  0, 'estoque'),
('Água com Gás',              'Bebidas', 3,  5,  0, 'estoque'),
('Água Normal',               'Bebidas', 19, 10, 0, 'estoque'),
('Energético Furioso 2L',     'Bebidas', 3,  3,  0, 'estoque'),
('Fanta Laranja 1,5L',        'Bebidas', 1,  3,  0, 'estoque'),
('Guaraná 1,5L',              'Bebidas', 2,  3,  0, 'estoque'),
('Tônica',                    'Bebidas', 2,  3,  0, 'estoque'),
('Guaravita',                 'Bebidas', 4,  5,  0, 'estoque'),
('TNT Sport',                 'Bebidas', 6,  5,  0, 'estoque'),
('Gatorade',                  'Bebidas', 4,  5,  0, 'estoque'),
('Suco Del Valle Lata',       'Bebidas', 5,  5,  0, 'estoque'),
('Coca-Cola Zero Lata',       'Bebidas', 5,  5,  0, 'estoque'),
('Guaraná Zero Lata',         'Bebidas', 4,  5,  0, 'estoque'),
('Guaraná Lata',              'Bebidas', 2,  3,  0, 'estoque'),
('Sukita Lata',               'Bebidas', 1,  3,  0, 'estoque'),
('Água de Coco 200 ML',       'Bebidas', 2,  3,  0, 'estoque'),
('Coca-Cola Zero 200 ML',     'Bebidas', 15, 10, 0, 'estoque'),
('Coca-Cola 200 ML',          'Bebidas', 8,  5,  0, 'estoque'),
('Soda Limonada',             'Bebidas', 12, 5,  0, 'estoque'),
('Sprite',                    'Bebidas', 2,  3,  0, 'estoque'),
('Todynho',                   'Bebidas', 19, 10, 0, 'estoque'),

-- BEBIDAS ALCOÓLICAS
('Heineken',                  'Bebidas Alcoólicas', 19, 10, 0, 'estoque'),
('Skol Beats',                'Bebidas Alcoólicas', 5,  5,  0, 'estoque'),
('Original',                  'Bebidas Alcoólicas', 32, 10, 0, 'estoque'),
('Skol',                      'Bebidas Alcoólicas', 11, 5,  0, 'estoque'),

-- POLPAS
('Polpa Manga',               'Polpas', 10, 5, 0, 'estoque'),
('Polpa Abacaxi',             'Polpas', 8,  5, 0, 'estoque'),
('Polpa Maracujá',            'Polpas', 6,  5, 0, 'estoque'),
('Polpa Goiaba',              'Polpas', 8,  5, 0, 'estoque'),
('Polpa Acerola',             'Polpas', 10, 5, 0, 'estoque'),
('Polpa Caju',                'Polpas', 10, 5, 0, 'estoque'),

-- GELOS SABORIZADOS
('Gelo Saborizado Maçã Verde','Gelos Saborizados', 3, 2, 0, 'estoque'),
('Gelo Saborizado Melancia',  'Gelos Saborizados', 2, 2, 0, 'estoque'),
('Gelo Saborizado Coco',      'Gelos Saborizados', 2, 2, 0, 'estoque'),
('Gelo Saborizado Morango',   'Gelos Saborizados', 3, 2, 0, 'estoque'),

-- GELADINHOS
('Geladinho Açaí',            'Geladinhos', 12, 5, 7.00, 'estoque'),
('Geladinho Limão',           'Geladinhos', 10, 5, 4.50, 'estoque'),
('Geladinho Coco',            'Geladinhos', 9,  5, 4.50, 'estoque'),
('Geladinho Maracujá',        'Geladinhos', 8,  5, 2.00, 'estoque'),
('Geladinho Morango',         'Geladinhos', 12, 5, 2.00, 'estoque'),

-- RECHEIOS CONGELADOS
('Recheio Queijo',            'Recheios Congelados', 2, 1, 0, 'estoque'),
('Recheio Calabresa',         'Recheios Congelados', 1, 1, 0, 'estoque'),
('Recheio Presunto',          'Recheios Congelados', 8, 2, 0, 'estoque'),
('Recheio Frango',            'Recheios Congelados', 1, 1, 0, 'estoque'),
('Recheio Palmito',           'Recheios Congelados', 1, 1, 0, 'estoque'),

-- SALGADOS / CONGELADOS
('Coxinha (pacotes)',          'Salgados',   3, 2, 0, 'estoque'),
('Frango a Passarinho',       'Congelados',  3, 2, 0, 'estoque'),
('Mini Pastel (sacos)',        'Congelados',  2, 1, 0, 'estoque'),
('Gelo (saco)',                'Gelo',        1, 1, 0, 'estoque'),

-- TRUFAS
('Trufa Coco',                'Trufas', 4, 2, 0, 'estoque'),
('Trufa Morango',             'Trufas', 2, 2, 0, 'estoque'),
('Trufa Maracujá',            'Trufas', 1, 1, 0, 'estoque'),
('Trufa Brigadeiro',          'Trufas', 1, 1, 0, 'estoque'),

-- CONDIMENTOS
('Ketchup (caixa)',            'Condimentos', 1, 1, 0, 'estoque'),
('Molho de Tomate',            'Condimentos', 1, 1, 0, 'estoque'),
('Milho (pacote)',              'Condimentos', 2, 1, 0, 'estoque'),
('Café Solúvel',               'Condimentos', 1, 1, 0, 'estoque'),
('Pimenta',                    'Condimentos', 6, 2, 0, 'estoque'),
('Molho de Salsa',             'Condimentos', 2, 1, 0, 'estoque'),

-- INSUMOS
('Massa de Pastel',            'Insumos', 2, 1, 0, 'estoque')

ON CONFLICT (nome) DO UPDATE
  SET qtd       = EXCLUDED.qtd,
      categoria = EXCLUDED.categoria;
