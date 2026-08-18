-- ============================================================
-- Atualização de estoque — 18/08/2026
-- Apenas UPDATEs para produtos existentes + INSERTs para novos
-- Rode no SQL Editor do Supabase (é seguro, não duplica nada)
-- ============================================================

-- ==================== BEBIDAS ====================
UPDATE produtos SET qtd = 11 WHERE id = 207;  -- Sukita 200 ML
UPDATE produtos SET qtd = 10 WHERE id = 209;  -- Guaraná 1 Litro
UPDATE produtos SET qtd = 19 WHERE id = 155;  -- Coca-Cola Zero 200 ML
UPDATE produtos SET qtd = 32 WHERE id = 156;  -- Coca-Cola 200 ML
UPDATE produtos SET qtd = 17 WHERE id = 245;  -- Coca Cola lata 350ml
UPDATE produtos SET qtd = 24 WHERE id = 152;  -- Guaraná Lata
UPDATE produtos SET qtd = 12 WHERE id = 143;  -- Fanta Laranja (lata)
UPDATE produtos SET qtd = 6  WHERE id = 142;  -- Energético Furioso 2L
UPDATE produtos SET qtd = 7  WHERE id = 146;  -- Guaraviton
UPDATE produtos SET qtd = 1  WHERE id = 242;  -- BOLO DE POTE CHOCOLATE
UPDATE produtos SET qtd = 3  WHERE id = 243;  -- BOLO DE POTE NINHO
UPDATE produtos SET qtd = 1  WHERE id = 214;  -- Del Valle Manga 290 ML
UPDATE produtos SET qtd = 5  WHERE id = 212;  -- Del Valle Goiaba 290 ML
UPDATE produtos SET qtd = 2  WHERE id = 150;  -- Coca-Cola Zero Lata
UPDATE produtos SET qtd = 5  WHERE id = 154;  -- Água de Coco 200 ML
UPDATE produtos SET qtd = 18 WHERE id = 46;   -- Todynho

-- ==================== CERVEJAS ====================
UPDATE produtos SET qtd = 9  WHERE id = 48;   -- Skol
UPDATE produtos SET qtd = 29 WHERE id = 49;   -- Original
UPDATE produtos SET qtd = 35 WHERE id = 52;   -- Heineken

-- ==================== DOCES E GULOSEIMAS ====================
UPDATE produtos SET qtd = 14 WHERE id = 82;   -- Freegells Menta
UPDATE produtos SET qtd = 12 WHERE id = 71;   -- Freegells Gum Morango (Chiclete Bola)
UPDATE produtos SET qtd = 18 WHERE id = 84;   -- Freegells Preto
UPDATE produtos SET qtd = 28 WHERE id = 15;   -- Plutonita
UPDATE produtos SET qtd = 132 WHERE id = 75;  -- Poosh Rosa  (total Poosh = 132)
UPDATE produtos SET qtd = 0  WHERE id = 77;   -- Poosh Roxo
UPDATE produtos SET qtd = 0  WHERE id = 73;   -- Poosh Verde
UPDATE produtos SET qtd = 0  WHERE id = 74;   -- Poosh Vermelho
UPDATE produtos SET qtd = 0  WHERE id = 76;   -- Poosh 7 Belo
UPDATE produtos SET qtd = 4  WHERE id = 70;   -- Freegells Gum Tutti Frutti
UPDATE produtos SET qtd = 46 WHERE id = 90;   -- Chiclete Ball (Morango/Chiclete Bola)
UPDATE produtos SET qtd = 142 WHERE id = 88;  -- Bola 7
UPDATE produtos SET qtd = 115 WHERE id = 89;  -- Bala Azedinha (Azedinha)
UPDATE produtos SET qtd = 108 WHERE id = 86;  -- Bala de Hortelã
UPDATE produtos SET qtd = 60 WHERE id = 87;   -- Balinha do Coração
UPDATE produtos SET qtd = 19 WHERE id = 91;   -- Gomets Tubo (Bala Goma)
UPDATE produtos SET qtd = 40 WHERE id = 246;  -- Chup-chup
UPDATE produtos SET qtd = 25 WHERE id = 249;  -- Ouro Branco (novo)
UPDATE produtos SET qtd = 1  WHERE id = 68;   -- Tortuguita
UPDATE produtos SET qtd = 128 WHERE id = 60;  -- Bala Bolete
UPDATE produtos SET qtd = 7  WHERE id = 61;   -- Pirulito Bolete
UPDATE produtos SET qtd = 10 WHERE id = 63;   -- Fini Vermelho (Fini morango)
UPDATE produtos SET qtd = 7  WHERE id = 64;   -- Fini Roxo (Fini uva)
UPDATE produtos SET qtd = 6  WHERE id = 65;   -- Fini Verde Azedo (Fini verde)
UPDATE produtos SET qtd = 174 WHERE id = 220; -- Bala Caramelo
UPDATE produtos SET qtd = 68 WHERE id = 225;  -- Pirulito Boca Cereja
UPDATE produtos SET qtd = 85 WHERE id = 78;   -- Pirulito Coca
UPDATE produtos SET qtd = 111 WHERE id = 66;  -- Paçoca
UPDATE produtos SET qtd = 17 WHERE id = 80;   -- Pirulito Coração
UPDATE produtos SET qtd = 84 WHERE id = 81;   -- Bala Freegells
UPDATE produtos SET qtd = 113 WHERE id = 221; -- Bala Iceriss
UPDATE produtos SET qtd = 2  WHERE id = 83;   -- Freegells Choco (Chocolate)
-- (id 89 já atualizado acima para 115)

-- ==================== DOCES R$ 2,50 ====================
UPDATE produtos SET qtd = 24 WHERE id = 28;   -- Molecão
UPDATE produtos SET qtd = 17 WHERE id = 98;   -- Doce de Banana
UPDATE produtos SET qtd = 24 WHERE id = 29;   -- Pé de Moça
UPDATE produtos SET qtd = 16 WHERE id = 96;   -- Fount de Leite (Doce de leite)
UPDATE produtos SET qtd = 3  WHERE id = 30;   -- Doce de Abóbora
UPDATE produtos SET qtd = 9  WHERE id = 31;   -- Geleia de Frutas

-- ==================== PASTÉIS / SALGADOS ====================
UPDATE produtos SET qtd = 143 WHERE id = 53;  -- Pastel (massas)
UPDATE produtos SET qtd = 146 WHERE id = 198; -- Massa de Pastel
UPDATE produtos SET qtd = 57 WHERE id = 54;   -- Coxinha de Frango
UPDATE produtos SET qtd = 21 WHERE id = 58;   -- Enroladinho de Salsicha
UPDATE produtos SET qtd = 35 WHERE id = 57;   -- Risole de Presunto e Queijo

-- ==================== TRUFAS ====================
UPDATE produtos SET qtd = 4 WHERE id = 188;   -- Trufa Coco
UPDATE produtos SET qtd = 2 WHERE id = 189;   -- Trufa Morango

-- ==================== NOVOS PRODUTOS ====================
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES (248, 'Mini Pastel', 'Pastéis', 7, 5, 5, 'estoque')
ON CONFLICT (id) DO UPDATE SET qtd = EXCLUDED.qtd, preco = EXCLUDED.preco;

INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES (250, 'Paçoca de Chocolate', 'Doces e Guloseimas', 2, 5, 2.5, 'estoque')
ON CONFLICT (id) DO UPDATE SET qtd = EXCLUDED.qtd;

INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES (251, 'Del Valle Maracujá 290 ML', 'Bebidas', 2, 3, 7.5, 'estoque')
ON CONFLICT (id) DO UPDATE SET qtd = EXCLUDED.qtd;
