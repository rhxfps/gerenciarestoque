-- ============================================================
-- Estoque Restante - Vendas antes das 12:00 - 25/08/2026
-- Calculo: estoque_do_backup - vendas = restante
-- ============================================================

-- ------------------------------------------------------------
-- BEBIDAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 0 WHERE id = 241;  -- Energetico TNT original (2 - 3 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 139;  -- Coca-Cola 600 ML (10 - 10 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 215;  -- Guaraviton Açaí 500 ML (6 - 6 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 217;  -- TNT Uva 500 ML (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 216;  -- TNT Tangerina 500 ML (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 47;   -- Gatorade (4 - 4 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 209;  -- Guaraná 1 Litro (3 - 3 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 143;  -- Fanta Laranja 1,5L (3 - 3 = 0)
UPDATE produtos SET qtd = 1 WHERE id = 263;  -- Energético Furioso Melancia 2L (2 - 1 = 1)
UPDATE produtos SET qtd = 1 WHERE id = 265;  -- Energético Furioso Tropical 2L (2 - 1 = 1)
UPDATE produtos SET qtd = 13 WHERE id = 153; -- Sukita Lata (15 - 2 = 13)
UPDATE produtos SET qtd = 0 WHERE id = 262;  -- Fanta Laranja Lata 350ml (4 - 10 = 0)
UPDATE produtos SET qtd = 13 WHERE id = 245; -- Coca Cola lata 350ml (29 - 16 = 13)
UPDATE produtos SET qtd = 1 WHERE id = 152;  -- Guaraná Lata (20 - 19 = 1)
UPDATE produtos SET qtd = 0 WHERE id = 251;  -- Del Valle Maracujá 290 ML (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 214;  -- Del Valle Manga 290 ML (1 - 1 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 211;  -- Del Valle Uva 290 ML (1 - 1 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 213;  -- Del Valle Pêssego 290 ML (2 - 6 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 212;  -- Del Valle Goiaba 290 ML (5 - 5 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 156;  -- Coca-Cola 200 ML (11 - 16 = 0)
UPDATE produtos SET qtd = 1 WHERE id = 155;  -- Coca-Cola Zero 200 ML (10 - 9 = 1)
UPDATE produtos SET qtd = 3 WHERE id = 206;  -- Sprite 200 ML (17 - 14 = 3)
UPDATE produtos SET qtd = 0 WHERE id = 208;  -- Soda 200 ML (41 - 43 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 207;  -- Sukita 200 ML (23 - 23 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 259;  -- Guaranazinho 200ml (11 - 12 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 44;   -- Água com gás (7 - 7 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 43;   -- Água sem gás (9 - 40 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 154;  -- Água de Coco 200 ML (5 - 5 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 46;   -- Todynho (17 - 17 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 145;  -- Tônica (2 - 2 = 0)

-- ------------------------------------------------------------
-- BOLOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 0 WHERE id = 242;  -- BOLO DE POTE CHOCOLATE (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 243;  -- BOLO DE POTE NINHO (0 - 2 = 0)

-- ------------------------------------------------------------
-- CERVEJAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 0 WHERE id = 52;   -- Heineken (14 - 14 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 51;   -- Skol Beats (5 - 5 = 0)
UPDATE produtos SET qtd = 1 WHERE id = 49;   -- Original (25 - 24 = 1)
UPDATE produtos SET qtd = 0 WHERE id = 48;   -- Skol (8 - 8 = 0)

-- ------------------------------------------------------------
-- GELADINHOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 0 WHERE id = 177;  -- Geladinho Maracujá (8 - 16 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 176;  -- Geladinho Coco (9 - 14 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 253;  -- Geladinho coco [dup] (1 - 14 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 254;  -- Geladinho morango (4 - 17 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 178;  -- Geladinho Morango [dup] (2 - 17 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 175;  -- Geladinho Limão (5 - 21 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 229;  -- Geladinho Açaí com Nutella (5 - 5 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 230;  -- Geladinho Açaí c/ Leite Condensado (3 - 3 = 0)

-- ------------------------------------------------------------
-- RECHEIOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 2 WHERE id = 181;  -- Recheio Presunto (8 - 6 = 2)
UPDATE produtos SET qtd = 0 WHERE id = 180;  -- Recheio Calabresa (1 - 3 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 182;  -- Recheio Frango (1 - 1 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 179;  -- Recheio Queijo (2 - 15 = 0)
-- SEM CORRESPONDÊNCIA: Recheio Carne (5)
-- SEM CORRESPONDÊNCIA: Recheio Bacon (1)

-- ------------------------------------------------------------
-- CONGELADOS / POLPAS / GELOS SABORIZADOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 1 WHERE id = 228;  -- Morango Congelado (2 - 1 = 1)
UPDATE produtos SET qtd = 0 WHERE id = 170;  -- Gelo Saborizado Maçã Verde (3 - 4 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 172;  -- Gelo Saborizado Coco (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 171;  -- Gelo Saborizado Melancia (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 173;  -- Gelo Saborizado Morango (3 - 3 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 164;  -- Polpa Manga (10 - 10 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 165;  -- Polpa Abacaxi (8 - 8 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 167;  -- Polpa Goiaba (8 - 8 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 169;  -- Polpa Caju (10 - 12 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 168;  -- Polpa Acerola (10 - 12 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 186;  -- Mini Pastel (sacos) (2 - 2 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 185;  -- Frango a Passarinho (3 - 3 = 0)
-- SEM CORRESPONDÊNCIA: Abacaxi congelado pequeno (2)

-- ------------------------------------------------------------
-- DOCES E GULOSEIMAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 0 WHERE id = 255;  -- Ouro Branco (15 - 19 = 0)
UPDATE produtos SET qtd = 2 WHERE id = 246;  -- Chup-chup (36 - 34 = 2)
UPDATE produtos SET qtd = 0 WHERE id = 81;   -- Bala Freegells vermelhinha (61 - 66 = 0)
UPDATE produtos SET qtd = 8 WHERE id = 221;  -- Bala Iceriss (116 - 108 = 8)
UPDATE produtos SET qtd = 0 WHERE id = 15;   -- Plutonita (45 - 46 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 220;  -- Bala Caramelo (166 - 213 = 0)
UPDATE produtos SET qtd = 3 WHERE id = 218;  -- Bala Azedinha Roxa (86 - 83 = 3)
UPDATE produtos SET qtd = 0 WHERE id = 87;   -- Balinha do Coração (47 - 47 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 86;   -- Bala de Hortelã (109 - 109 = 0)
UPDATE produtos SET qtd = 4 WHERE id = 88;   -- Bola 7 (105 - 101 = 4)
UPDATE produtos SET qtd = 0 WHERE id = 71;   -- Freegells Gum Morango (1 - 1 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 271;  -- Chiclete freegels melancia (10 - 11 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 90;   -- Chiclete Ball (40 - 40 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 61;   -- Pirulito Bolete (5 - 5 = 0)
UPDATE produtos SET qtd = 4 WHERE id = 60;   -- Bala Bolete (105 - 101 = 4)
UPDATE produtos SET qtd = 0 WHERE id = 63;   -- Fini Vermelho (10 - 10 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 75;   -- Pooshs (93 - 114 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 91;   -- Gomets Tubo (16 - 16 = 0)
UPDATE produtos SET qtd = 3 WHERE id = 66;   -- Paçoca (131 - 128 = 3)
UPDATE produtos SET qtd = 2 WHERE id = 29;   -- Pé de Moça (21 - 19 = 2)
UPDATE produtos SET qtd = 0 WHERE id = 96;   -- Fount de Leite (16 - 16 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 28;   -- Molecão (24 - 24 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 98;   -- Doce de Banana (16 - 17 = 0)
UPDATE produtos SET qtd = 1 WHERE id = 268;  -- Doce de batata-doce (3 - 2 = 1)
UPDATE produtos SET qtd = 1 WHERE id = 30;   -- Doce de Abóbora (3 - 2 = 1)
UPDATE produtos SET qtd = 0 WHERE id = 31;   -- Geleia de Frutas (8 - 8 = 0)
UPDATE produtos SET qtd = 0 WHERE id = 267;  -- Pé de Moleque (17 - 17 = 0)
-- SEM CORRESPONDÊNCIA: Bala goma (15)
-- SEM CORRESPONDÊNCIA: Fini uva (6)
-- SEM CORRESPONDÊNCIA: Visibilidade verde/azedinha (5)
-- SEM CORRESPONDÊNCIA: Poosh verde caixa fechada (2)
-- SEM CORRESPONDÊNCIA: Poosh vermelho caixa fechada (2)

-- ============================================================
-- Fim - estoque restante apos vendas 25/08/2026
-- ============================================================
