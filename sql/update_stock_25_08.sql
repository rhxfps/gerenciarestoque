-- ============================================================
-- Baixa de Estoque - Vendas antes das 12:00 - 25/08/2026
-- Script gerado automaticamente
-- ============================================================

-- ------------------------------------------------------------
-- BEBIDAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 241;  -- Energetico TNT original (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 10, 0) WHERE id = 139; -- Coca-Cola 600 ML (est: 10)
UPDATE produtos SET qtd = GREATEST(qtd - 6, 0) WHERE id = 215;  -- Guaraviton Açaí 500 ML (est: 6)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 217;  -- TNT Uva 500 ML (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 216;  -- TNT Tangerina 500 ML (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 4, 0) WHERE id = 47;   -- Gatorade (est: 4)
UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 209;  -- Guaraná 1 Litro (est: 3)
UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 143;  -- Fanta Laranja 1,5L (est: 3)
UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 263;  -- Energético Furioso Melancia 2L (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 265;  -- Energético Furioso Tropical 2L (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 153;  -- Sukita Lata (est: 15)
UPDATE produtos SET qtd = GREATEST(qtd - 10, 0) WHERE id = 262; -- Fanta Laranja Lata 350ml (est: 4)
UPDATE produtos SET qtd = GREATEST(qtd - 16, 0) WHERE id = 245; -- Coca Cola lata 350ml (est: 29)
UPDATE produtos SET qtd = GREATEST(qtd - 19, 0) WHERE id = 152; -- Guaraná Lata (est: 20)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 251;  -- Del Valle Maracujá 290 ML (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 214;  -- Del Valle Manga 290 ML (est: 1)
UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 211;  -- Del Valle Uva 290 ML (est: 1)
UPDATE produtos SET qtd = GREATEST(qtd - 6, 0) WHERE id = 213;  -- Del Valle Pêssego 290 ML (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 5, 0) WHERE id = 212;  -- Del Valle Goiaba 290 ML (est: 5)
UPDATE produtos SET qtd = GREATEST(qtd - 16, 0) WHERE id = 156; -- Coca-Cola 200 ML (est: 11)
UPDATE produtos SET qtd = GREATEST(qtd - 9, 0) WHERE id = 155;  -- Coca-Cola Zero 200 ML (est: 10)
UPDATE produtos SET qtd = GREATEST(qtd - 14, 0) WHERE id = 206; -- Sprite 200 ML (est: 17)
UPDATE produtos SET qtd = GREATEST(qtd - 43, 0) WHERE id = 208; -- Soda 200 ML (est: 41)
UPDATE produtos SET qtd = GREATEST(qtd - 23, 0) WHERE id = 207; -- Sukita 200 ML (est: 23)
UPDATE produtos SET qtd = GREATEST(qtd - 12, 0) WHERE id = 259; -- Guaranazinho 200ml (est: 11)
UPDATE produtos SET qtd = GREATEST(qtd - 7, 0) WHERE id = 44;   -- Água com gás (est: 7)
UPDATE produtos SET qtd = GREATEST(qtd - 40, 0) WHERE id = 43;  -- Água sem gás (est: 9)
UPDATE produtos SET qtd = GREATEST(qtd - 5, 0) WHERE id = 154;  -- Água de Coco 200 ML (est: 5)
UPDATE produtos SET qtd = GREATEST(qtd - 17, 0) WHERE id = 46;  -- Todynho (est: 17)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 145;  -- Tônica (est: 2)

-- ------------------------------------------------------------
-- BOLOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 242;  -- BOLO DE POTE CHOCOLATE (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 243;  -- BOLO DE POTE NINHO / Prestígio (est: 0)

-- ------------------------------------------------------------
-- CERVEJAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = GREATEST(qtd - 14, 0) WHERE id = 52;  -- Heineken (est: 14)
UPDATE produtos SET qtd = GREATEST(qtd - 5, 0) WHERE id = 51;   -- Skol Beats (est: 5)
UPDATE produtos SET qtd = GREATEST(qtd - 24, 0) WHERE id = 49;  -- Original (est: 25)
UPDATE produtos SET qtd = GREATEST(qtd - 8, 0) WHERE id = 48;   -- Skol (est: 8)

-- ------------------------------------------------------------
-- GELADINHOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = GREATEST(qtd - 16, 0) WHERE id = 177; -- Geladinho Maracujá (est: 8)
-- Geladinho Coco: duas entradas no banco (id 176 + id 253, total estoque: 10, venda: 14)
UPDATE produtos SET qtd = GREATEST(qtd - 14, 0) WHERE id = 176; -- Geladinho Coco (est: 9)
UPDATE produtos SET qtd = GREATEST(qtd - 14, 0) WHERE id = 253; -- Geladinho coco [duplicado] (est: 1)
-- Geladinho Morango: duas entradas no banco (id 254 + id 178, total estoque: 6, venda: 17)
UPDATE produtos SET qtd = GREATEST(qtd - 17, 0) WHERE id = 254; -- Geladinho morango (est: 4)
UPDATE produtos SET qtd = GREATEST(qtd - 17, 0) WHERE id = 178; -- Geladinho Morango [duplicado] (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 21, 0) WHERE id = 175; -- Geladinho Limão (est: 5)
UPDATE produtos SET qtd = GREATEST(qtd - 5, 0) WHERE id = 229;  -- Geladinho Açaí com Nutella (est: 5)
UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 230;  -- Geladinho Açaí c/ Leite Condensado (est: 3)

-- ------------------------------------------------------------
-- RECHEIOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = GREATEST(qtd - 6, 0) WHERE id = 181;  -- Recheio Presunto (est: 8)
UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 180;  -- Recheio Calabresa (est: 1)
UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 182;  -- Recheio Frango (est: 1)
UPDATE produtos SET qtd = GREATEST(qtd - 15, 0) WHERE id = 179; -- Recheio Queijo (est: 2)
-- SEM CORRESPONDÊNCIA: Recheio Carne (5) - produto não encontrado no banco
-- SEM CORRESPONDÊNCIA: Recheio Bacon (1) - produto não encontrado no banco

-- ------------------------------------------------------------
-- CONGELADOS / POLPAS / GELOS SABORIZADOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 228;  -- Morango Congelado (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 4, 0) WHERE id = 170;  -- Gelo Saborizado Maçã Verde (est: 3)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 172;  -- Gelo Saborizado Coco (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 171;  -- Gelo Saborizado Melancia (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 173;  -- Gelo Saborizado Morango (est: 3)
UPDATE produtos SET qtd = GREATEST(qtd - 10, 0) WHERE id = 164; -- Polpa Manga (est: 10)
UPDATE produtos SET qtd = GREATEST(qtd - 8, 0) WHERE id = 165;  -- Polpa Abacaxi (est: 8)
UPDATE produtos SET qtd = GREATEST(qtd - 8, 0) WHERE id = 167;  -- Polpa Goiaba (est: 8)
UPDATE produtos SET qtd = GREATEST(qtd - 12, 0) WHERE id = 169; -- Polpa Caju (est: 10)
UPDATE produtos SET qtd = GREATEST(qtd - 12, 0) WHERE id = 168; -- Polpa Acerola (est: 10)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 186;  -- Mini Pastel (sacos) (est: 2)
UPDATE produtos SET qtd = GREATEST(qtd - 3, 0) WHERE id = 185;  -- Frango a Passarinho (est: 3)
-- SEM CORRESPONDÊNCIA: Abacaxi congelado pequeno (2) - produto não encontrado no banco

-- ------------------------------------------------------------
-- DOCES E GULOSEIMAS
-- ------------------------------------------------------------

-- Bombons
UPDATE produtos SET qtd = GREATEST(qtd - 19, 0) WHERE id = 255; -- Ouro Branco (est: 15)
UPDATE produtos SET qtd = GREATEST(qtd - 34, 0) WHERE id = 246; -- Chup-chup (est: 36)

-- Balas
UPDATE produtos SET qtd = GREATEST(qtd - 66, 0) WHERE id = 81;  -- Bala Freegells vermelhinha (est: 61)
UPDATE produtos SET qtd = GREATEST(qtd - 108, 0) WHERE id = 221; -- Bala Iceriss (est: 116)
UPDATE produtos SET qtd = GREATEST(qtd - 46, 0) WHERE id = 15;  -- Plutonita (est: 45)
UPDATE produtos SET qtd = GREATEST(qtd - 213, 0) WHERE id = 220; -- Bala Caramelo (est: 166)
UPDATE produtos SET qtd = GREATEST(qtd - 83, 0) WHERE id = 218; -- Bala Azedinha Roxa (est: 86)
UPDATE produtos SET qtd = GREATEST(qtd - 47, 0) WHERE id = 87;  -- Balinha do Coração (est: 47)
UPDATE produtos SET qtd = GREATEST(qtd - 109, 0) WHERE id = 86; -- Bala de Hortelã (est: 109)
UPDATE produtos SET qtd = GREATEST(qtd - 101, 0) WHERE id = 88; -- Bola 7 (est: 105)

-- Freegells / Chicletes
UPDATE produtos SET qtd = GREATEST(qtd - 1, 0) WHERE id = 71;   -- Freegells Gum Morango (est: 1)
UPDATE produtos SET qtd = GREATEST(qtd - 11, 0) WHERE id = 271; -- Chiclete freegels melancia (est: 10)
UPDATE produtos SET qtd = GREATEST(qtd - 40, 0) WHERE id = 90;  -- Chiclete Ball (est: 40)

-- Pirulitos e Bala Bolete
UPDATE produtos SET qtd = GREATEST(qtd - 5, 0) WHERE id = 61;   -- Pirulito Bolete (est: 5)
UPDATE produtos SET qtd = GREATEST(qtd - 101, 0) WHERE id = 60; -- Bala Bolete (est: 105)

-- Fini
UPDATE produtos SET qtd = GREATEST(qtd - 10, 0) WHERE id = 63;  -- Fini Vermelho (est: 10)

-- Poosh e Gomets
UPDATE produtos SET qtd = GREATEST(qtd - 114, 0) WHERE id = 75; -- Pooshs (est: 93)
UPDATE produtos SET qtd = GREATEST(qtd - 16, 0) WHERE id = 91;  -- Gomets Tubo (est: 16)

-- Paçoca
UPDATE produtos SET qtd = GREATEST(qtd - 128, 0) WHERE id = 66; -- Paçoca (est: 131)

-- Doces tradicionais
UPDATE produtos SET qtd = GREATEST(qtd - 19, 0) WHERE id = 29;  -- Pé de Moça (est: 21)
UPDATE produtos SET qtd = GREATEST(qtd - 16, 0) WHERE id = 96;  -- Fount de Leite (est: 16)
UPDATE produtos SET qtd = GREATEST(qtd - 24, 0) WHERE id = 28;  -- Molecão (est: 24)
UPDATE produtos SET qtd = GREATEST(qtd - 17, 0) WHERE id = 98;  -- Doce de Banana (est: 16)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 268;  -- Doce de batata-doce (est: 3)
UPDATE produtos SET qtd = GREATEST(qtd - 2, 0) WHERE id = 30;   -- Doce de Abóbora (est: 3)
UPDATE produtos SET qtd = GREATEST(qtd - 8, 0) WHERE id = 31;   -- Geleia de Frutas (est: 8)
UPDATE produtos SET qtd = GREATEST(qtd - 17, 0) WHERE id = 267; -- Pé de Moleque (est: 17)

-- SEM CORRESPONDÊNCIA: Bala goma (15) - possivelmente Gomets Tubo (id 91), ignorado
-- SEM CORRESPONDÊNCIA: Fini uva (6) - possivelmente Fini Roxo, ignorado
-- SEM CORRESPONDÊNCIA: Visibilidade verde/azedinha (5) - produto não encontrado no banco
-- SEM CORRESPONDÊNCIA: Poosh verde caixa fechada (2) - ignorado
-- SEM CORRESPONDÊNCIA: Poosh vermelho caixa fechada (2) - ignorado

-- ============================================================
-- Fim da baixa de estoque - 25/08/2026
-- ============================================================
