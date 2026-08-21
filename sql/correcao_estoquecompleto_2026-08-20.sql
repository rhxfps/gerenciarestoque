-- ============================================================
-- Correção do EstoquesCompleto conforme contagem física
-- Data: 20/08/2026
-- Diferenças encontradas: 23 produtos
-- ============================================================

-- Ajustes (estoquecompleto → contagem correta)
UPDATE produtos SET qtd = 23 WHERE id = 29;   -- Pé de Moça (era 21)
UPDATE produtos SET qtd = 11 WHERE id = 43;   -- Água sem gás (era 44)
UPDATE produtos SET qtd = 15 WHERE id = 52;   -- Heineken (era 35)
UPDATE produtos SET qtd = 15 WHERE id = 58;   -- Enroladinho de Salsicha (era 0)
UPDATE produtos SET qtd = 20 WHERE id = 59;   -- Bolinho de Carne (era 1)
UPDATE produtos SET qtd = 16 WHERE id = 98;   -- Doce de Banana (era 17)
UPDATE produtos SET qtd = 8 WHERE id = 136;   -- Papel Toalha G (era 4)
UPDATE produtos SET qtd = 1 WHERE id = 151;   -- Guaraná Zero Lata (era 3)
UPDATE produtos SET qtd = 15 WHERE id = 153;  -- Sukita Lata (era 3)
UPDATE produtos SET qtd = 21 WHERE id = 156;  -- Coca-Cola 200 ML (era 22)
UPDATE produtos SET qtd = 3 WHERE id = 188;   -- Trufa Coco (era 4)
UPDATE produtos SET qtd = 18 WHERE id = 206;  -- Sprite 200 ML (era 19)
UPDATE produtos SET qtd = 23 WHERE id = 207;  -- Sukita 200 ML (era 22)
UPDATE produtos SET qtd = 45 WHERE id = 208;  -- Soda 200 ML (era 46)
UPDATE produtos SET qtd = 5 WHERE id = 209;   -- Guaraná 1 Litro (era 6)
UPDATE produtos SET qtd = 3 WHERE id = 213;   -- Del Valle Pêssego (era 4)
UPDATE produtos SET qtd = 6 WHERE id = 215;   -- Guaraviton Açaí 500 ML (era 1)
UPDATE produtos SET qtd = 48 WHERE id = 225;  -- Pirulito Boca Cereja (era 46)
UPDATE produtos SET qtd = 5 WHERE id = 233;   -- Leite (era 2)
UPDATE produtos SET qtd = 0 WHERE id = 236;   -- Maionese (era 1)
UPDATE produtos SET qtd = 19 WHERE id = 255;  -- ouro branco (era 22)
UPDATE produtos SET qtd = 2 WHERE id = 263;   -- Energético Furioso Melancia 2L (era 1)
UPDATE produtos SET qtd = 2 WHERE id = 265;   -- Energético Furioso Tropical 2L (era 1)

-- ============================================================
-- Fim da correção
-- ============================================================
