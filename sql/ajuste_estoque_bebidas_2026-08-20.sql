-- ============================================================
-- Ajuste de Estoque - Bebidas
-- Data: 20/08/2026
-- Total de itens: 60
-- ============================================================

-- Novos produtos
-- Novos produtos (Fanta Laranja Lata já existe no banco)

-- Ajustes de estoque existente
UPDATE produtos SET qtd = 46 WHERE id = 208; -- Soda 200 ML
UPDATE produtos SET qtd = 22 WHERE id = 156; -- Coca-Cola 200 ML
UPDATE produtos SET qtd = 12 WHERE id = 155; -- Coca-Cola Zero 200 ML
UPDATE produtos SET qtd = 22 WHERE id = 207; -- Sukita 200 ML
UPDATE produtos SET qtd = 12 WHERE id = 259; -- Guaranazinho 200ml
UPDATE produtos SET qtd = 17 WHERE id = 158; -- Sprite
UPDATE produtos SET qtd = 7 WHERE id = 245; -- Coca Cola lata 350ml
UPDATE produtos SET qtd = 23 WHERE id = 152; -- Guaraná Lata
UPDATE produtos SET qtd = 10 WHERE id = 44; -- Água com gás
UPDATE produtos SET qtd = 4 WHERE id = 143; -- Fanta Laranja 1,5L
UPDATE produtos SET qtd = 44 WHERE id = 43; -- Água sem gás
UPDATE produtos SET qtd = 3 WHERE id = 153; -- Sukita Lata
UPDATE produtos SET qtd = 3 WHERE id = 151; -- Guaraná Zero Lata
UPDATE produtos SET qtd = 2 WHERE id = 251; -- Del Valle Maracujá 290 ML
UPDATE produtos SET qtd = 1 WHERE id = 214; -- Del Valle Manga 290 ML
UPDATE produtos SET qtd = 4 WHERE id = 213; -- Del Valle Pêssego 290 ML
UPDATE produtos SET qtd = 5 WHERE id = 212; -- Del Valle Goiaba 290 ML
UPDATE produtos SET qtd = 3 WHERE id = 211; -- Del Valle Uva 290 ML
UPDATE produtos SET qtd = 2 WHERE id = 145; -- Tônica
UPDATE produtos SET qtd = 7 WHERE id = 241; -- Energetico TNT original
UPDATE produtos SET qtd = 1 WHERE id = 257; -- ENERG TNT MAÇA VERDE 473ml
UPDATE produtos SET qtd = 2 WHERE id = 258; -- ENERG TNT MANGO 473ml
UPDATE produtos SET qtd = 6 WHERE id = 146; -- Guaraviton
UPDATE produtos SET qtd = 3 WHERE id = 217; -- TNT Uva 500 ML
UPDATE produtos SET qtd = 2 WHERE id = 216; -- TNT Tangerina 500 ML
UPDATE produtos SET qtd = 4 WHERE id = 47; -- Gatorade
UPDATE produtos SET qtd = 1 WHERE id = 243; -- BOLO DE POTE NINHO
UPDATE produtos SET qtd = 6 WHERE id = 209; -- Guaraná 1 Litro
UPDATE produtos SET qtd = 5 WHERE id = 154; -- Água de Coco 200 ML
UPDATE produtos SET qtd = 18 WHERE id = 46; -- Todynho

-- ============================================================
-- Ajuste de Estoque - Doces, Geladinhos, Polpas e Bombons
-- Data: 20/08/2026
-- ============================================================

-- Novos produtos
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo) VALUES ('Pé de Moleque', 'Doces e Guloseimas', 17, 5, 2, 'estoque');
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo) VALUES ('Doce de batata-doce', 'Doces e Guloseimas', 3, 5, 2, 'estoque');

-- Geladinhos
UPDATE produtos SET qtd = 3 WHERE id = 230; -- Geladinho Açaí com Leite Condensado
UPDATE produtos SET qtd = 5 WHERE id = 175; -- Geladinho Limão
UPDATE produtos SET qtd = 14 WHERE id = 254; -- Geladinho morango

-- Polpas
UPDATE produtos SET qtd = 2 WHERE id = 166; -- Polpa Maracujá

-- Bombons e Balas
UPDATE produtos SET qtd = 47 WHERE id = 87; -- Balinha do Coração
UPDATE produtos SET qtd = 109 WHERE id = 86; -- Bala de Hortelã
UPDATE produtos SET qtd = 110 WHERE id = 218; -- Bala Azedinha Roxa
UPDATE produtos SET qtd = 140 WHERE id = 88; -- Bola 7
UPDATE produtos SET qtd = 18 WHERE id = 91; -- Gomets Tubo
UPDATE produtos SET qtd = 116 WHERE id = 221; -- Bala Iceriss
UPDATE produtos SET qtd = 72 WHERE id = 81; -- Bala Freegells vermelhinha

-- Paçocas
UPDATE produtos SET qtd = 132 WHERE id = 66; -- Paçoca

-- Freegells
UPDATE produtos SET qtd = 1 WHERE id = 83; -- Freegells Choco
UPDATE produtos SET qtd = 12 WHERE id = 82; -- Freegells Menta
UPDATE produtos SET qtd = 5 WHERE id = 71; -- Freegells Gum Morango

-- Pirulitos
UPDATE produtos SET qtd = 84 WHERE id = 78; -- Pirulito Coca
UPDATE produtos SET qtd = 48 WHERE id = 225; -- Pirulito Boca Cereja
UPDATE produtos SET qtd = 10 WHERE id = 80; -- Pirulito Coração
UPDATE produtos SET qtd = 5 WHERE id = 61; -- Pirulito Bolete

-- Outros doces
UPDATE produtos SET qtd = 168 WHERE id = 75; -- Pooshs
UPDATE produtos SET qtd = 36 WHERE id = 246; -- Chup-chup
UPDATE produtos SET qtd = 23 WHERE id = 29; -- Pé de Moça

-- ============================================================
-- Fim do ajuste
-- ============================================================
