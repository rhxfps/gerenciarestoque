-- ============================================================
-- Cadastro de produtos — estoque inicial 30, preço 0
-- (ajuste os preços depois com os UPDATEs no final do arquivo)
-- Execute no SQL Editor do Supabase
-- ============================================================

-- Limpar produtos existentes (opcional — descomente se quiser recomeçar)
-- TRUNCATE produtos RESTART IDENTITY CASCADE;

INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco) VALUES

-- 🍬 DOCES E GULOSEIMAS — Fini
('Fini Uva', 'Doces e Guloseimas', 30, 5, 0),
('Fini Misto', 'Doces e Guloseimas', 30, 5, 0),
('Fini Morango', 'Doces e Guloseimas', 30, 5, 0),
('Fini Laranja', 'Doces e Guloseimas', 30, 5, 0),

-- Chup-Chup / Doce de Leite
('Chup-Chup', 'Doces e Guloseimas', 30, 5, 0),
('Doce de Leite', 'Doces e Guloseimas', 30, 5, 0),

-- Trento
('Trento Caramelo', 'Doces e Guloseimas', 30, 5, 0),
('Trento Chocolate', 'Doces e Guloseimas', 30, 5, 0),

-- Bombons
('Ouro Branco', 'Doces e Guloseimas', 30, 5, 0),

-- Pirulitos
('Flopito (coração)', 'Doces e Guloseimas', 30, 5, 0),
('Pop Kiss', 'Doces e Guloseimas', 30, 5, 0),
('Bolete (Pirulito)', 'Doces e Guloseimas', 30, 5, 0),

-- Chicletes
('Poosh', 'Doces e Guloseimas', 30, 5, 0),
('Plutonita', 'Doces e Guloseimas', 30, 5, 0),
('Chiclete Bola', 'Doces e Guloseimas', 30, 5, 0),

-- Balas
('Colação', 'Doces e Guloseimas', 30, 5, 0),
('Bola 7 (maçã verde)', 'Doces e Guloseimas', 30, 5, 0),
('Azedinha (uva)', 'Doces e Guloseimas', 30, 5, 0),
('Bala de Goma', 'Doces e Guloseimas', 30, 5, 0),
('Bolete (Bala)', 'Doces e Guloseimas', 30, 5, 0),
('Hortelã', 'Doces e Guloseimas', 30, 5, 0),
('Freegells', 'Doces e Guloseimas', 30, 5, 0),
('Caramelo (Bala)', 'Doces e Guloseimas', 30, 5, 0),

-- Paçocas
('Paçoca Tradicional', 'Doces e Guloseimas', 30, 5, 0),
('Paçoca Chocolate', 'Doces e Guloseimas', 30, 5, 0),

-- Doces
('Pé de Moleque Crocante', 'Doces e Guloseimas', 30, 5, 0),
('Molecão', 'Doces e Guloseimas', 30, 5, 0),
('Pé de Moça', 'Doces e Guloseimas', 30, 5, 0),
('Doce de Abóbora', 'Doces e Guloseimas', 30, 5, 0),
('Geleia de Frutas', 'Doces e Guloseimas', 30, 5, 0),

-- Bolos
('Bolo Chocolate', 'Doces e Guloseimas', 30, 5, 0),
('Bolo Ninho', 'Doces e Guloseimas', 30, 5, 0),

-- 🥤 BEBIDAS — Energético
('TNT', 'Bebidas', 30, 5, 0),

-- Refrigerantes
('Suco (lata)', 'Bebidas', 30, 5, 0),
('Coca-Cola 600ml', 'Bebidas', 30, 5, 0),
('Coca-Cola lata', 'Bebidas', 30, 5, 0),
('Coca-Cola 200ml', 'Bebidas', 30, 5, 0),
('Sukita lata', 'Bebidas', 30, 5, 0),
('Tônica lata', 'Bebidas', 30, 5, 0),
('Guaraná Zero lata', 'Bebidas', 30, 5, 0),
('Fanta Laranja 200ml', 'Bebidas', 30, 5, 0),

-- Águas
('Água sem gás', 'Bebidas', 30, 5, 0),
('Água com gás', 'Bebidas', 30, 5, 0),
('H2OH!', 'Bebidas', 30, 5, 0),

-- Lácteos
('Todynho', 'Bebidas', 30, 5, 0),

-- Isotônicos
('Gatorade', 'Bebidas', 30, 5, 0),

-- 🍺 CERVEJAS
('Skol', 'Cervejas', 30, 5, 0),
('Original', 'Cervejas', 30, 5, 0),
('Amstel', 'Cervejas', 30, 5, 0),
('Skol Beats', 'Cervejas', 30, 5, 0),
('Heineken', 'Cervejas', 30, 5, 0);
