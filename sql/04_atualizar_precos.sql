-- ============================================================
-- Atualizar preços (valores da sua lista)
-- Preços entre parênteses na lista original foram usados
-- quando havia divergência (ex: Chiclete Bola 1,50 em vez de 2,00)
-- ============================================================

-- Doces e Guloseimas
UPDATE produtos SET preco = 1.50 WHERE nome = 'Fini Uva';
UPDATE produtos SET preco = 1.50 WHERE nome = 'Fini Misto';
UPDATE produtos SET preco = 1.50 WHERE nome = 'Fini Morango';
UPDATE produtos SET preco = 1.50 WHERE nome = 'Fini Laranja';
UPDATE produtos SET preco = 1.00 WHERE nome = 'Chup-Chup';
UPDATE produtos SET preco = 1.00 WHERE nome = 'Doce de Leite';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Trento Caramelo';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Trento Chocolate';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Ouro Branco';
UPDATE produtos SET preco = 0.50 WHERE nome = 'Flopito (coração)';
UPDATE produtos SET preco = 0.50 WHERE nome = 'Pop Kiss';
UPDATE produtos SET preco = 0.50 WHERE nome = 'Bolete (Pirulito)';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Poosh';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Plutonita';
UPDATE produtos SET preco = 1.50 WHERE nome = 'Chiclete Bola';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Colação';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Bola 7 (maçã verde)';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Azedinha (uva)';
UPDATE produtos SET preco = 1.50 WHERE nome = 'Bala de Goma';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Bolete (Bala)';
UPDATE produtos SET preco = 0.30 WHERE nome = 'Hortelã';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Freegells';
UPDATE produtos SET preco = 0.50 WHERE nome = 'Caramelo (Bala)';
UPDATE produtos SET preco = 1.00 WHERE nome = 'Paçoca Tradicional';
UPDATE produtos SET preco = 1.50 WHERE nome = 'Paçoca Chocolate';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Pé de Moleque Crocante';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Molecão';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Pé de Moça';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Doce de Abóbora';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Geleia de Frutas';
UPDATE produtos SET preco = 12.00 WHERE nome = 'Bolo Chocolate';
UPDATE produtos SET preco = 12.00 WHERE nome = 'Bolo Ninho';

-- Bebidas
UPDATE produtos SET preco = 8.00 WHERE nome = 'TNT';
UPDATE produtos SET preco = 7.50 WHERE nome = 'Suco (lata)';
UPDATE produtos SET preco = 9.00 WHERE nome = 'Coca-Cola 600ml';
UPDATE produtos SET preco = 6.00 WHERE nome = 'Coca-Cola lata';
UPDATE produtos SET preco = 4.00 WHERE nome = 'Coca-Cola 200ml';
UPDATE produtos SET preco = 6.00 WHERE nome = 'Sukita lata';
UPDATE produtos SET preco = 6.00 WHERE nome = 'Tônica lata';
UPDATE produtos SET preco = 6.00 WHERE nome = 'Guaraná Zero lata';
UPDATE produtos SET preco = 4.00 WHERE nome = 'Fanta Laranja 200ml';
UPDATE produtos SET preco = 4.00 WHERE nome = 'Água sem gás';
UPDATE produtos SET preco = 4.50 WHERE nome = 'Água com gás';
UPDATE produtos SET preco = 7.50 WHERE nome = 'H2OH!';
UPDATE produtos SET preco = 2.00 WHERE nome = 'Todynho';
UPDATE produtos SET preco = 7.50 WHERE nome = 'Gatorade';

-- Cervejas
UPDATE produtos SET preco = 4.50 WHERE nome = 'Skol';
UPDATE produtos SET preco = 4.50 WHERE nome = 'Original';
UPDATE produtos SET preco = 4.50 WHERE nome = 'Amstel';
UPDATE produtos SET preco = 10.00 WHERE nome = 'Skol Beats';
UPDATE produtos SET preco = 5.50 WHERE nome = 'Heineken';

-- Pastel (preço fixo — recheio não altera o valor)
UPDATE produtos SET preco = 14.00 WHERE nome = 'Pastel' AND tipo = 'pastel';
