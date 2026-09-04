-- ============================================================
-- Atualização de Estoque - Inventário (04/09/2026)
-- Define a quantidade de cada item conforme contagem informada
-- ============================================================

-- ------------------------------------------------------------
-- BEBIDAS / MATERIAIS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 10 WHERE id = 136; -- Papel Toalha G (10 rolos)
UPDATE produtos SET qtd = 7  WHERE id = 137; -- Guardanapo (7 pacotes)
UPDATE produtos SET qtd = 2  WHERE id = 192; -- Ketchup (caixa)
UPDATE produtos SET qtd = 37 WHERE id = 208; -- Soda 200 ml
UPDATE produtos SET qtd = 16 WHERE id = 207; -- Sukita 200 ml
UPDATE produtos SET qtd = 5  WHERE id = 209; -- Guaraná 1 Litro
UPDATE produtos SET qtd = 28 WHERE id = 43;  -- Água sem gás
UPDATE produtos SET qtd = 8  WHERE id = 152; -- Guaraná 350 ml (Guaraná Lata)
UPDATE produtos SET qtd = 5  WHERE id = 258; -- ENERG TNT MANGO 473ml
UPDATE produtos SET qtd = 6  WHERE id = 241; -- Energetico TNT original
UPDATE produtos SET qtd = 8  WHERE id = 257; -- ENERG TNT MAÇA VERDE 473ml
UPDATE produtos SET qtd = 6  WHERE id = 206; -- Sprite 200 ml
UPDATE produtos SET qtd = 3  WHERE id = 259; -- Guaranazinho 200 ml
UPDATE produtos SET qtd = 2  WHERE id = 145; -- Tônica
UPDATE produtos SET qtd = 4  WHERE id = 154; -- Água de Coco 200 ml
UPDATE produtos SET qtd = 15 WHERE id = 46;  -- Todynho
UPDATE produtos SET qtd = 5  WHERE id = 262; -- Fanta Laranja lata 350 ml
UPDATE produtos SET qtd = 1  WHERE id = 153; -- Sukita Lata 350 ml
UPDATE produtos SET qtd = 1  WHERE id = 150; -- Coca-Cola Zero Lata 350 ml
UPDATE produtos SET qtd = 3  WHERE id = 211; -- Del Valle Uva
UPDATE produtos SET qtd = 5  WHERE id = 212; -- Del Valle Goiaba
UPDATE produtos SET qtd = 2  WHERE id = 214; -- Del Valle Manga
UPDATE produtos SET qtd = 4  WHERE id = 215; -- Guaraviton (Açaí 500 ML)
UPDATE produtos SET qtd = 2  WHERE id = 217; -- TNT Uva
UPDATE produtos SET qtd = 2  WHERE id = 216; -- TNT Tangerina
UPDATE produtos SET qtd = 2  WHERE id = 47;  -- Gatorade
UPDATE produtos SET qtd = 1  WHERE id = 139; -- Coca-Cola 600 ml
UPDATE produtos SET qtd = 2  WHERE id = 142; -- Energético Furioso 2L
UPDATE produtos SET qtd = 2  WHERE id = 242; -- BOLO DE POTE CHOCOLATE
UPDATE produtos SET qtd = 6  WHERE id = 44;  -- Água com gás

-- ------------------------------------------------------------
-- CERVEJAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 5  WHERE id = 51;  -- Skol Beats (269ml)
UPDATE produtos SET qtd = 6  WHERE id = 48;  -- Skol (269ml)
UPDATE produtos SET qtd = 14 WHERE id = 52;  -- Heineken (269ml)
UPDATE produtos SET qtd = 25 WHERE id = 49;  -- Original (269ml)

-- ------------------------------------------------------------
-- GELADINHOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 16 WHERE id = 176; -- Geladinho Coco
UPDATE produtos SET qtd = 0  WHERE id = 253; -- Geladinho coco [duplicado zerado]
UPDATE produtos SET qtd = 8  WHERE id = 177; -- Geladinho Maracujá
UPDATE produtos SET qtd = 1  WHERE id = 178; -- Geladinho Morango
UPDATE produtos SET qtd = 0  WHERE id = 254; -- Geladinho morango [duplicado zerado]
UPDATE produtos SET qtd = 13 WHERE id = 175; -- Geladinho Limão (12 + 1)
UPDATE produtos SET qtd = 3  WHERE id = 230; -- Geladinho Açaí c/ Leite Condensado
UPDATE produtos SET qtd = 4  WHERE id = 229; -- Geladinho Açaí com Nutella

-- ------------------------------------------------------------
-- POLPAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 7  WHERE id = 167; -- Polpa Goiaba
UPDATE produtos SET qtd = 8  WHERE id = 165; -- Polpa Abacaxi
UPDATE produtos SET qtd = 10 WHERE id = 164; -- Polpa Manga

-- ------------------------------------------------------------
-- RECHEIOS (para fazer pastel)
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 10 WHERE id = 181; -- Recheio Presunto
UPDATE produtos SET qtd = 4  WHERE id = 179; -- Recheio Queijo
UPDATE produtos SET qtd = 1  WHERE id = 180; -- Recheio Calabresa

-- ------------------------------------------------------------
-- SALGADOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 9  WHERE id = 58;  -- Enroladinho de Salsicha
UPDATE produtos SET qtd = 13 WHERE id = 59;  -- Bolinho de Carne
UPDATE produtos SET qtd = 6  WHERE id = 57;  -- Risole de Presunto e Queijo
UPDATE produtos SET qtd = 13 WHERE id = 56;  -- Bolinho de Queijo

-- ------------------------------------------------------------
-- DOCES / GULOSEIMAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 72  WHERE id = 60;  -- Bala Bolete
UPDATE produtos SET qtd = 6   WHERE id = 64;  -- Fini Roxo
UPDATE produtos SET qtd = 5   WHERE id = 65;  -- Fini Verde Azedo
UPDATE produtos SET qtd = 10  WHERE id = 63;  -- Fini Vermelho
UPDATE produtos SET qtd = 105 WHERE id = 66;  -- Paçoca (85 + 20)
UPDATE produtos SET qtd = 26  WHERE id = 70;  -- Freegells Gum Tutti Frutti
UPDATE produtos SET qtd = 2   WHERE id = 69;  -- Freegells Gum Menta
UPDATE produtos SET qtd = 100 WHERE id = 15;  -- Plutonita
UPDATE produtos SET qtd = 152 WHERE id = 220; -- Bala Caramelo
UPDATE produtos SET qtd = 246 WHERE id = 75;  -- Pooshs (verde 111 + vermelho 54 + roxo 79 + rosa 2)
UPDATE produtos SET qtd = 35  WHERE id = 78;  -- Pirulito Coca
UPDATE produtos SET qtd = 49  WHERE id = 226; -- Pirulito Coração Morango
UPDATE produtos SET qtd = 9   WHERE id = 79;  -- Pirulito Boca (Boca Cereja)
UPDATE produtos SET qtd = 163 WHERE id = 81;  -- Bala Freegells
UPDATE produtos SET qtd = 3   WHERE id = 82;  -- Freegells Menta
UPDATE produtos SET qtd = 1   WHERE id = 256; -- Freegels cereja
UPDATE produtos SET qtd = 1   WHERE id = 271; -- Chiclete freegels melancia
UPDATE produtos SET qtd = 8   WHERE id = 84;  -- Freegells Preto
UPDATE produtos SET qtd = 57  WHERE id = 246; -- Chup-chup
UPDATE produtos SET qtd = 193 WHERE id = 86;  -- Bala de Hortelã
UPDATE produtos SET qtd = 44  WHERE id = 87;  -- Balinha do Coração
UPDATE produtos SET qtd = 22  WHERE id = 218; -- Bala Azedinha Roxa
UPDATE produtos SET qtd = 52  WHERE id = 88;  -- Bola 7
UPDATE produtos SET qtd = 32  WHERE id = 90;  -- Chiclete Ball (Guds Ball)
UPDATE produtos SET qtd = 44  WHERE id = 91;  -- Gomets Tubo
UPDATE produtos SET qtd = 5   WHERE id = 61;  -- Pirulito Bolete
UPDATE produtos SET qtd = 31  WHERE id = 96;  -- Fount de Leite (Doce de leite, 18 + 13)
UPDATE produtos SET qtd = 19  WHERE id = 29;  -- Pé de Moça
UPDATE produtos SET qtd = 15  WHERE id = 267; -- Pé de Moleque
UPDATE produtos SET qtd = 8   WHERE id = 31;  -- Geleia de Frutas
UPDATE produtos SET qtd = 3   WHERE id = 30;  -- Doce de Abóbora
UPDATE produtos SET qtd = 2   WHERE id = 268; -- Doce de batata-doce
UPDATE produtos SET qtd = 17  WHERE id = 98;  -- Doce de Banana
UPDATE produtos SET qtd = 22  WHERE id = 28;  -- Molecão

-- ------------------------------------------------------------
-- NOVOS PRODUTOS
-- ------------------------------------------------------------

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo) VALUES
('Óleo',          'Insumos',              2,  0, 0, 'estoque'),
('Pepsi 1L',      'Bebidas',              3,  0, 0, 'estoque'),
('Mentos Mint',   'Doces e Guloseimas',   12, 0, 0, 'estoque'),
('Mentos Fruit Mix', 'Doces e Guloseimas',10, 0, 0, 'estoque'),
('Mentos Tutti Frutti', 'Doces e Guloseimas', 12, 0, 0, 'estoque'),
('Carne com Ovo', 'Confeitarias',         20, 0, 0, 'estoque');

-- ============================================================
-- FIM - inventário 04/09/2026
-- ============================================================
