-- ============================================================
-- Atualização de Estoque - Inventário 26/08/2026
-- Define a quantidade de cada item conforme contagem informada
-- ============================================================

-- ------------------------------------------------------------
-- SALGADINHOS / CONFEITARIAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 4 WHERE id = 57;  -- Risole de Presunto e Queijo (Risole presunto)
UPDATE produtos SET qtd = 4 WHERE id = 56;  -- Bolinho de Queijo (Risole queijo)
UPDATE produtos SET qtd = 3 WHERE id = 59;  -- Bolinho de Carne (Carne com ovo)
UPDATE produtos SET qtd = 15 WHERE id = 55; -- Coxinha com Catupiry
UPDATE produtos SET qtd = 6 WHERE id = 54;  -- Coxinha de Frango (Frango)
UPDATE produtos SET qtd = 4 WHERE id = 58;  -- Enroladinho de Salsicha

-- ------------------------------------------------------------
-- BEBIDAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 43 WHERE id = 208; -- Soda 200 ml
UPDATE produtos SET qtd = 8 WHERE id = 155;  -- Coca-Cola Zero 200 ml
UPDATE produtos SET qtd = 9 WHERE id = 156;  -- Coca-Cola 200 ml
UPDATE produtos SET qtd = 13 WHERE id = 206; -- Sprite 200 ml
UPDATE produtos SET qtd = 22 WHERE id = 207; -- Sukita 200 ml
UPDATE produtos SET qtd = 10 WHERE id = 259; -- Guaraná 200 ml
UPDATE produtos SET qtd = 10 WHERE id = 139; -- Coca-Cola 600 ml
UPDATE produtos SET qtd = 14 WHERE id = 245; -- Coca-Cola lata 350 ml
UPDATE produtos SET qtd = 36 WHERE id = 43;  -- Água sem gás
UPDATE produtos SET qtd = 7 WHERE id = 44;   -- Água com gás
UPDATE produtos SET qtd = 10 WHERE id = 262; -- Fanta Laranja lata 350 ml
UPDATE produtos SET qtd = 19 WHERE id = 152; -- Guaraná lata 350 ml
UPDATE produtos SET qtd = 2 WHERE id = 153;  -- Sukita lata 350 ml
UPDATE produtos SET qtd = 2 WHERE id = 145;  -- Tônica
UPDATE produtos SET qtd = 6 WHERE id = 154;  -- Água de Coco 200 ml
UPDATE produtos SET qtd = 10 WHERE id = 46;  -- Todynho
UPDATE produtos SET qtd = 1 WHERE id = 214;  -- Del Valle Manga
UPDATE produtos SET qtd = 1 WHERE id = 211;  -- Del Valle Uva
UPDATE produtos SET qtd = 5 WHERE id = 213;  -- Del Valle Pêssego
UPDATE produtos SET qtd = 5 WHERE id = 212;  -- Del Valle Goiaba
UPDATE produtos SET qtd = 3 WHERE id = 47;   -- Gatorade
UPDATE produtos SET qtd = 2 WHERE id = 216;  -- TNT Tangerina
UPDATE produtos SET qtd = 2 WHERE id = 217;  -- TNT Uva
UPDATE produtos SET qtd = 6 WHERE id = 215;  -- Guaraviton Açaí 500 ML
UPDATE produtos SET qtd = 3 WHERE id = 243;  -- BOLO DE POTE NINHO (Bolo Prestígio)
UPDATE produtos SET qtd = 10 WHERE id = 146; -- Guaraviton (base)
-- TNT lata 473ml: NÃO MEXER (manter como está)

-- ------------------------------------------------------------
-- CERVEJAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 5 WHERE id = 51;   -- Skol Beats
UPDATE produtos SET qtd = 14 WHERE id = 52;  -- Heineken
UPDATE produtos SET qtd = 25 WHERE id = 49;  -- Original
UPDATE produtos SET qtd = 8 WHERE id = 48;   -- Skol

-- ------------------------------------------------------------
-- OUTRAS BEBIDAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 2 WHERE id = 143;  -- Fanta Laranja 1,5L (lista "Fanta 2L")
UPDATE produtos SET qtd = 3 WHERE id = 209;  -- Guaraná 1 Litro (lista "Guaraná 600ml")
UPDATE produtos SET qtd = 2 WHERE id = 142;  -- Energético Furioso 2L

-- ------------------------------------------------------------
-- MATERIAL / UTENSÍLIOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 6 WHERE id = 136;  -- Papel Toalha G (6 rolos; obs. mensagem posterior "Papel toalha 7")
UPDATE produtos SET qtd = 7 WHERE id = 137;  -- Guardanapo (7 pacotes; obs. mensagem posterior "Guardanapo 950")
UPDATE produtos SET qtd = 100 WHERE id = 127; -- Canudos 25cm

-- ------------------------------------------------------------
-- RECHEIOS (saquinhos de recheio)
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 12 WHERE id = 179; -- Recheio Queijo
UPDATE produtos SET qtd = 4 WHERE id = 181;  -- Recheio Presunto
UPDATE produtos SET qtd = 3 WHERE id = 180;  -- Recheio Calabresa
UPDATE produtos SET qtd = 1 WHERE id = 182;  -- Recheio Frango
-- Recheio Carne (3) e Recheio Bacon (1): sem produto correspondente

-- ------------------------------------------------------------
-- GELOS SABORIZADOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 2 WHERE id = 172;  -- Gelo Saborizado Coco
UPDATE produtos SET qtd = 3 WHERE id = 170;  -- Gelo Saborizado Maçã Verde
UPDATE produtos SET qtd = 2 WHERE id = 171;  -- Gelo Saborizado Melancia
UPDATE produtos SET qtd = 3 WHERE id = 173;  -- Gelo Saborizado Morango

-- ------------------------------------------------------------
-- POLPAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 10 WHERE id = 169; -- Polpa Caju
UPDATE produtos SET qtd = 10 WHERE id = 168; -- Polpa Acerola
UPDATE produtos SET qtd = 8 WHERE id = 167;  -- Polpa Goiaba
UPDATE produtos SET qtd = 8 WHERE id = 165;  -- Polpa Abacaxi
UPDATE produtos SET qtd = 10 WHERE id = 164; -- Polpa Manga

-- ------------------------------------------------------------
-- GELADINHOS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 14 WHERE id = 176; -- Geladinho Coco
UPDATE produtos SET qtd = 0 WHERE id = 253;  -- Geladinho coco [duplicado zerado]
UPDATE produtos SET qtd = 21 WHERE id = 175; -- Geladinho Limão (4 + 17)
UPDATE produtos SET qtd = 15 WHERE id = 177; -- Geladinho Maracujá
UPDATE produtos SET qtd = 5 WHERE id = 229;  -- Geladinho Açaí com Nutella
UPDATE produtos SET qtd = 3 WHERE id = 230;  -- Geladinho Açaí c/ Leite Condensado

-- ------------------------------------------------------------
-- DOCES / GULOSEIMAS
-- ------------------------------------------------------------

UPDATE produtos SET qtd = 23 WHERE id = 29;   -- Pé de Moça
UPDATE produtos SET qtd = 16 WHERE id = 96;   -- Fount de Leite (Doce de leite)
UPDATE produtos SET qtd = 24 WHERE id = 28;   -- Molecão (obs. "Amendoim" também aponta para Molecão)
UPDATE produtos SET qtd = 18 WHERE id = 267;  -- Pé de Moleque
UPDATE produtos SET qtd = 8 WHERE id = 31;    -- Geleia de Frutas
UPDATE produtos SET qtd = 3 WHERE id = 30;    -- Doce de Abóbora
UPDATE produtos SET qtd = 2 WHERE id = 268;   -- Doce de batata-doce
UPDATE produtos SET qtd = 17 WHERE id = 98;   -- Doce de Banana
UPDATE produtos SET qtd = 100 WHERE id = 60;  -- Bala Bolete
UPDATE produtos SET qtd = 5 WHERE id = 61;    -- Pirulito Bolete
UPDATE produtos SET qtd = 128 WHERE id = 66;  -- Paçoca
UPDATE produtos SET qtd = 164 WHERE id = 220; -- Bala Caramelo (Dadinho)
UPDATE produtos SET qtd = 48 WHERE id = 15;   -- Plutonita
UPDATE produtos SET qtd = 217 WHERE id = 75;  -- Pooshs (roxo 9 + vermelho 83 + verde 105 + rosa 20)
UPDATE produtos SET qtd = 67 WHERE id = 78;   -- Pirulito Coca
UPDATE produtos SET qtd = 53 WHERE id = 79;   -- Pirulito Boca (Boca Cereja)
UPDATE produtos SET qtd = 51 WHERE id = 226;  -- Pirulito Coração Morango
UPDATE produtos SET qtd = 169 WHERE id = 81;  -- Bala Freegells
UPDATE produtos SET qtd = 17 WHERE id = 255;  -- Ouro Branco
UPDATE produtos SET qtd = 32 WHERE id = 246;  -- Chup-chup
UPDATE produtos SET qtd = 202 WHERE id = 86;  -- Bala de Hortelã
UPDATE produtos SET qtd = 47 WHERE id = 87;   -- Balinha do Coração
UPDATE produtos SET qtd = 93 WHERE id = 88;   -- Bola 7
UPDATE produtos SET qtd = 73 WHERE id = 218;  -- Bala Azedinha Roxa
UPDATE produtos SET qtd = 38 WHERE id = 90;   -- Chiclete Ball (Guds Ball)
UPDATE produtos SET qtd = 15 WHERE id = 91;   -- Gomets Tubo

-- Fini
UPDATE produtos SET qtd = 5 WHERE id = 65;    -- Fini Verde Azedo
UPDATE produtos SET qtd = 6 WHERE id = 64;    -- Fini Roxo
UPDATE produtos SET qtd = 10 WHERE id = 63;   -- Fini Vermelho

-- Freegells Gum
UPDATE produtos SET qtd = 18 WHERE id = 271;  -- Chiclete freegels melancia (gum 6 + barra 12)
UPDATE produtos SET qtd = 15 WHERE id = 69;   -- Freegells Gum Menta
UPDATE produtos SET qtd = 15 WHERE id = 70;   -- Freegells Gum Tutti Frutti

-- Freegells (barra)
UPDATE produtos SET qtd = 10 WHERE id = 82;   -- Freegells Menta
UPDATE produtos SET qtd = 1 WHERE id = 256;   -- Freegels cereja
UPDATE produtos SET qtd = 13 WHERE id = 84;   -- Freegells Preto

-- ------------------------------------------------------------
-- NOVOS PRODUTOS
-- ------------------------------------------------------------

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES ('Sacola', 'Embalagens', 64, 0, 0, 'estoque');

-- ============================================================
-- Fim - inventário 26/08/2026
-- ============================================================
