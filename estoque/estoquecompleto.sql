-- ============================================================
-- Backup GerenciarStock
-- Data: 20/08/2026, 16:40:44
-- Tabelas: 13
-- ============================================================

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

-- Tabela: usuarios
CREATE TABLE IF NOT EXISTS usuarios (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  usuario TEXT UNIQUE NOT NULL,
  senha TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'funcionario'
);

INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (5, 'ryan', 'ryan', '$2a$10$MXugp5IuebA5bOaA4z.OyOjvFBziDcPj/tbVRQkroY5NCRHsmZI5e', 'dono');
INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (8, 'eliane', 'eliane', '$2a$10$OzCC05ZlzHjtgPXuuAj/rOV7c8W6p9O8yqrkZFv5IPilTrPBhngVG', 'dono');
INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (10, 'rafaela', 'rafaela', '$2a$10$.UqDyn1zcs9o/u2kn7vSle6lId7S6FcP4tpKLE.f3l0wZtehQUd8O', 'funcionario');
INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (11, 'diego', 'diego', '$2a$10$7Id53Nfgg7y74IXhIVndGeKe4ozEepelNEPSQ7ZRrAfZXDJELhqFq', 'funcionario');
INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (12, 'Kaique', 'kaique', '$2a$10$cFScp63jQj5IBnmU3L9DGuyS9uaxlfv2CQGRmNQER9c02pDZ2IRsW', 'funcionario');
INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (13, 'Administrador', 'admin', '$2a$10$dZJLYJvQlV53Lu.GK7TZ3OXExFPcDVbdqcyDQ0kpJSEhvCkLdwWfK', 'dono');
INSERT INTO usuarios (id, nome, usuario, senha, role) VALUES (14, 'thayane', 'thayane', '$2a$10$V94CKxY5K3XTOkX3dHZRGOsOjWGeOAzc8lxPzvG2TadwjOUwHXzYW', 'funcionario');

-- Tabela: produtos
CREATE TABLE IF NOT EXISTS produtos (
  id SERIAL PRIMARY KEY,
  nome TEXT UNIQUE NOT NULL,
  categoria TEXT,
  qtd NUMERIC NOT NULL DEFAULT 0,
  qtd_minima NUMERIC NOT NULL DEFAULT 0,
  preco NUMERIC(10,2) NOT NULL DEFAULT 0,
  tipo VARCHAR(20) NOT NULL DEFAULT 'estoque'
);
CREATE INDEX IF NOT EXISTS idx_produtos_tipo ON produtos(tipo);

INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (119, 'Copo 300 ML', 'Embalagens', 4, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (55, 'Coxinha com Catupiry', 'Salgados', 0, 5, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (68, 'Tortuguita', 'Doces e Guloseimas', 1, 3, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (75, 'Pooshs', 'Doces e Guloseimas', 168, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (63, 'Fini Vermelho', 'Doces e Guloseimas', 10, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (64, 'Fini Roxo', 'Doces e Guloseimas', 7, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (65, 'Fini Verde Azedo', 'Doces e Guloseimas', 6, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (200, 'Açaí 300ml', 'Açaí', 0, 0, 10, 'acai');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (244, 'Energetico Bally', 'Energéticos', 0, 1, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (54, 'Coxinha de Frango', 'Salgados', 3, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (101, 'Copo 500 ML', 'Embalagens', 6, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (255, 'ouro branco', 'Doces e Guloseimas', 22, 1, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (69, 'Freegells Gum Menta', 'Doces e Guloseimas', 3, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (256, 'Freegels cereja', 'Doces é guloseimas', 8, 1, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (53, 'Pastel', 'Pastéis', 143, 0, 14, 'pastel');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (62, 'Chocolate Ki-Kakau', 'Doces e Guloseimas', 2, 3, 1, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (262, 'Fanta Laranja Lata 350ml', 'Bebidas', 12, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (263, 'Energético Furioso Melancia 2L', 'Bebidas', 1, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (264, 'Energético Furioso Tradicional 2L', 'Bebidas', 1, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (253, 'Geladinho coco', 'Geladinhos', 8, 1, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (130, 'Saco G', 'Embalagens', 40, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (137, 'Guardanapo', 'Descartáveis', 7, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (138, 'Guardanapo 200 un', 'Descartáveis', 7, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (136, 'Papel Toalha G', 'Descartáveis', 4, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (239, 'Colher G', 'Embalagens', 29, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (240, 'Colher P', 'Embalagens', 46, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (247, 'Chocolate quente', 'Bebidas', 18, 1, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (79, 'Pirulito Boca', 'Doces e Guloseimas', 56, 10, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (242, 'BOLO DE POTE CHOCOLATE', 'bolo de pote', 0, 1, 12, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (15, 'Plutonita', 'Doces e Guloseimas', 19, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (248, 'Mini Pastel', 'Pastéis', 4, 5, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (265, 'Energético Furioso Tropical 2L', 'Bebidas', 1, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (201, 'Açaí 500ml', 'Açaí', 0, 0, 15, 'acai');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (250, 'Paçoca de Chocolate', 'Doces e Guloseimas', 2, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (249, 'Cafe', 'Bebidas', 95, 1, 3.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (259, 'Guaranazinho 200ml', 'Bebidas', 12, 1, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (245, 'Coca Cola lata 350ml', 'Bebidas', 7, 1, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (251, 'Del Valle Maracujá 290 ML', 'Bebidas', 2, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (252, 'Cafecomleite', 'Bebidas', 100, 1, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (70, 'Freegells Gum Tutti Frutti', 'Doces e Guloseimas', 0, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (241, 'Energetico TNT original', 'Energéticos', 7, 1, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (257, 'ENERG TNT MAÇA VERDE 473ml', 'Energéticos', 1, 1, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (258, 'ENERG TNT MANGO 473ml', 'Energéticos', 2, 1, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (243, 'BOLO DE POTE NINHO', 'bolo de pote', 1, 1, 12, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (267, 'Pé de Moleque', 'Doces e Guloseimas', 17, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (268, 'Doce de batata-doce', 'Doces e Guloseimas', 3, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (57, 'Risole de Presunto e Queijo', 'Salgados', 0, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (56, 'Bolinho de Queijo', 'Salgados', 5, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (254, 'Geladinho morango', 'Geladinhos', 14, 1, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (81, 'Bala Freegells vermelhinha', 'Doces e Guloseimas', 72, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (66, 'Paçoca', 'Doces e Guloseimas', 132, 5, 1, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (71, 'Freegells Gum Morango', 'Doces e Guloseimas', 5, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (78, 'Pirulito Coca', 'Doces e Guloseimas', 84, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (80, 'Pirulito Coração', 'Doces e Guloseimas', 10, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (59, 'Bolinho de Carne', 'Salgados', 1, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (58, 'Enroladinho de Salsicha', 'Salgados', 0, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (60, 'Bala Bolete', 'Doces e Guloseimas', 107, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (61, 'Pirulito Bolete', 'Doces e Guloseimas', 5, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (208, 'Soda 200 ML', 'Bebidas', 46, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (99, 'Pacote Bala Bolete Fechado', 'Doces e Guloseimas', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (100, 'Copo Fechado 180 ML', 'Embalagens', 0, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (102, 'Pote 100 ML', 'Embalagens', 0, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (103, 'Blulister 50 un', 'Embalagens', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (104, 'Garrafa 200 ML', 'Embalagens', 6, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (105, 'Garrafa 300 ML', 'Embalagens', 3, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (106, 'Copo Térmico 300 ML', 'Embalagens', 19, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (107, 'Mini Tampa Descartável', 'Embalagens', 25, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (108, 'Rolo de Papel Alumínio 4M', 'Embalagens', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (109, 'Rolo de Papel Alumínio 7,5M', 'Embalagens', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (110, 'Saquinho Colher Sobremesa 50un', 'Embalagens', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (111, 'Tampa Descartável 300 ML', 'Embalagens', 49, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (112, 'Tampa Descartável 100 ML', 'Embalagens', 136, 20, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (113, 'Copo 180 ML', 'Embalagens', 68, 20, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (114, 'Copo 100 ML', 'Embalagens', 91, 20, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (115, 'Blister', 'Embalagens', 25, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (116, 'Copo 60 ML', 'Embalagens', 27, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (117, 'Mini Pote de Isopor', 'Embalagens', 14, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (118, 'Mini Tampa de Isopor', 'Embalagens', 5, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (120, 'Copo 700 ML', 'Embalagens', 25, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (121, 'Pote 240 ML', 'Embalagens', 24, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (122, 'Tampa 300 ML', 'Embalagens', 45, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (123, 'Tampa 500 ML', 'Embalagens', 40, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (124, 'Tampa 240 ML', 'Embalagens', 25, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (125, 'Embalagem Pastel P', 'Embalagens', 83, 20, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (126, 'Embalagem Pastel G', 'Embalagens', 319, 50, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (127, 'Canudos', 'Embalagens', 313, 50, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (131, 'Suporte de Papel', 'Embalagens', 22, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (132, 'Suporte Batata Viagem P', 'Embalagens', 8, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (133, 'Suporte Batata Viagem M', 'Embalagens', 10, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (134, 'Suporte Batata Viagem G', 'Embalagens', 8, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (135, 'Colher Pacote P 50 un', 'Embalagens', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (220, 'Bala Caramelo', 'Doces e Guloseimas', 166, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (222, 'Outro Doce', 'Doces e Guloseimas', 19, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (223, 'Fini Azedinho', 'Doces e Guloseimas', 8, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (207, 'Sukita 200 ML', 'Bebidas', 22, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (29, 'Pé de Moça', 'Doces e Guloseimas', 21, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (178, 'Geladinho Morango', 'Geladinhos', 9, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (164, 'Polpa Manga', 'Polpas', 10, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (165, 'Polpa Abacaxi', 'Polpas', 8, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (167, 'Polpa Goiaba', 'Polpas', 8, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (168, 'Polpa Acerola', 'Polpas', 10, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (169, 'Polpa Caju', 'Polpas', 10, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (170, 'Gelo Saborizado Maçã Verde', 'Gelos Saborizados', 3, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (171, 'Gelo Saborizado Melancia', 'Gelos Saborizados', 2, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (172, 'Gelo Saborizado Coco', 'Gelos Saborizados', 2, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (173, 'Gelo Saborizado Morango', 'Gelos Saborizados', 3, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (176, 'Geladinho Coco', 'Geladinhos', 9, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (177, 'Geladinho Maracujá', 'Geladinhos', 8, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (179, 'Recheio Queijo', 'Recheios Congelados', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (180, 'Recheio Calabresa', 'Recheios Congelados', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (181, 'Recheio Presunto', 'Recheios Congelados', 8, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (182, 'Recheio Frango', 'Recheios Congelados', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (183, 'Recheio Palmito', 'Recheios Congelados', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (185, 'Frango a Passarinho', 'Congelados', 3, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (186, 'Mini Pastel (sacos)', 'Congelados', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (93, 'Doces Tony Kelly', 'Doces e Guloseimas', 3, 3, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (225, 'Pirulito Boca Cereja', 'Doces e Guloseimas', 46, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (174, 'Geladinho Açaí', 'Geladinhos', 12, 5, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (214, 'Del Valle Manga 290 ML', 'Bebidas', 1, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (188, 'Trufa Coco', 'Trufas', 4, 2, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (190, 'Trufa Maracujá', 'Trufas', 1, 1, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (213, 'Del Valle Pêssego 290 ML', 'Bebidas', 4, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (212, 'Del Valle Goiaba 290 ML', 'Bebidas', 5, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (226, 'Pirulito Coração Morango', 'Doces e Guloseimas', 11, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (211, 'Del Valle Uva 290 ML', 'Bebidas', 3, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (217, 'TNT Uva 500 ML', 'Bebidas', 3, 3, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (216, 'TNT Tangerina 500 ML', 'Bebidas', 2, 3, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (215, 'Guaraviton Açaí 500 ML', 'Bebidas', 1, 2, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (206, 'Sprite 200 ML', 'Bebidas', 19, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (227, 'Mini Pizza', 'Salgados', 9, 5, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (209, 'Guaraná 1 Litro', 'Bebidas', 6, 5, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (175, 'Geladinho Limão', 'Geladinhos', 5, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (166, 'Polpa Maracujá', 'Polpas', 2, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (218, 'Bala Azedinha Roxa', 'Doces e Guloseimas', 110, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (221, 'Bala Iceriss', 'Doces e Guloseimas', 116, 20, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (192, 'Ketchup (caixa)', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (195, 'Café Solúvel', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (157, 'Soda Limonada', 'Bebidas', 12, 5, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (43, 'Água sem gás', 'Bebidas', 44, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (153, 'Sukita Lata', 'Bebidas', 3, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (151, 'Guaraná Zero Lata', 'Bebidas', 3, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (51, 'Skol Beats', 'Bebidas Alcoólicas', 5, 5, 10, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (145, 'Tônica', 'Bebidas', 2, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (146, 'Guaraviton', 'Bebidas', 6, 5, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (149, 'Suco Del Valle Lata', 'Bebidas', 0, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (47, 'Gatorade', 'Bebidas', 4, 5, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (84, 'Freegells Preto', 'Doces e Guloseimas', 16, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (189, 'Trufa Morango', 'Trufas', 0, 2, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (154, 'Água de Coco 200 ML', 'Bebidas', 5, 3, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (191, 'Trufa Brigadeiro', 'Trufas', 1, 1, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (198, 'Massa de Pastel', 'Insumos', 126, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (46, 'Todynho', 'Bebidas', 18, 5, 3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (139, 'Coca-Cola 600 ML', 'Bebidas', 0, 5, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (230, 'Geladinho Açaí com Leite Condensado', 'Geladinhos', 3, 3, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (87, 'Balinha do Coração', 'Doces e Guloseimas', 47, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (144, 'Guaraná 1,5L', 'Bebidas', 11, 3, 10, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (86, 'Bala de Hortelã', 'Doces e Guloseimas', 109, 10, 0.35, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (199, 'Amstel', 'Bebidas Alcoólicas', 13, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (88, 'Bola 7', 'Doces e Guloseimas', 140, 20, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (91, 'Gomets Tubo', 'Doces e Guloseimas', 18, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (83, 'Freegells Choco', 'Doces e Guloseimas', 1, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (142, 'Energético Furioso 2L', 'Bebidas', 6, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (82, 'Freegells Menta', 'Doces e Guloseimas', 12, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (246, 'Chup-chup', 'Doces e Guloseimas', 36, 1, 1, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (228, 'Morango Congelado', 'Congelados', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (229, 'Geladinho Açaí com Nutella', 'Geladinhos', 5, 3, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (193, 'Molho de Tomate', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (194, 'Milho (pacote)', 'Condimentos', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (196, 'Pimenta', 'Condimentos', 6, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (197, 'Molho de Salsa', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (232, 'Azeitona', 'Condimentos', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (233, 'Leite', 'Condimentos', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (234, 'Creme de Leite 200g', 'Condimentos', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (235, 'Creme de Leite 1kg', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (236, 'Maionese', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (237, 'Ketchup', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (238, 'Mostarda', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (128, 'Saco P', 'Embalagens', 46, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (129, 'Saco M', 'Embalagens', 48, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (31, 'Geleia de Frutas', 'Doces e Guloseimas', 8, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (48, 'Skol', 'Bebidas Alcoólicas', 9, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (49, 'Original', 'Bebidas Alcoólicas', 29, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (52, 'Heineken', 'Bebidas Alcoólicas', 35, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (28, 'Molecão', 'Doces e Guloseimas', 24, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (150, 'Coca-Cola Zero Lata', 'Bebidas', 0, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (98, 'Doce de Banana', 'Doces e Guloseimas', 17, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (156, 'Coca-Cola 200 ML', 'Bebidas', 22, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (96, 'Fount de Leite', 'Doces e Guloseimas', 16, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (30, 'Doce de Abóbora', 'Doces e Guloseimas', 3, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (155, 'Coca-Cola Zero 200 ML', 'Bebidas', 12, 10, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (90, 'Chiclete Ball', 'Doces e Guloseimas', 45, 10, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (158, 'Sprite', 'Bebidas', 17, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (152, 'Guaraná Lata', 'Bebidas', 23, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (44, 'Água com gás', 'Bebidas', 10, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (143, 'Fanta Laranja 1,5L', 'Bebidas', 4, 3, 10, 'estoque');

-- Tabela: vendas
CREATE TABLE IF NOT EXISTS vendas (
  id SERIAL PRIMARY KEY,
  total NUMERIC(10,2) NOT NULL,
  pagamento TEXT,
  delivery BOOLEAN,
  plataforma TEXT,
  obs TEXT,
  data TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (67, 5.85, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:42:45.376211+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (68, 8, 'cartao', FALSE, NULL, '', '2026-08-18T17:43:43.519415+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (69, 9.8, 'cartao', FALSE, NULL, '', '2026-08-18T17:44:37.563719+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (70, 8, 'cartao', FALSE, NULL, '', '2026-08-18T17:44:57.864244+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (71, 9, 'cartao', FALSE, NULL, '', '2026-08-18T17:45:18.076972+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (72, 1.05, 'dinheiro', FALSE, NULL, '', '2026-08-18T17:45:55.154602+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (73, 5, 'dinheiro', FALSE, NULL, '', '2026-08-18T17:47:06.809935+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (74, 4.5, 'cartao', FALSE, NULL, '', '2026-08-18T17:47:32.383679+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (75, 8, 'cartao', FALSE, NULL, '', '2026-08-18T17:48:04.184627+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (76, 2.05, 'dinheiro', FALSE, NULL, '', '2026-08-18T17:48:51.791606+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (77, 18, 'cartao', FALSE, NULL, '', '2026-08-18T17:49:56.563303+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (78, 4.5, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:50:52.143934+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (79, 10, 'cartao', FALSE, NULL, '', '2026-08-18T17:51:10.678041+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (80, 6, 'cartao', FALSE, NULL, '', '2026-08-18T17:52:17.37313+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (81, 1.75, 'cartao', FALSE, NULL, '', '2026-08-18T17:53:02.453338+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (82, 9, 'cartao', FALSE, NULL, '', '2026-08-18T17:53:19.430206+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (83, 2, 'dinheiro', FALSE, NULL, '', '2026-08-18T17:53:44.13942+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (84, 18, 'cartao', FALSE, NULL, '', '2026-08-18T17:54:07.809234+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (85, 16.5, 'cartao', FALSE, NULL, '', '2026-08-18T17:54:31.621236+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (86, 35, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:55:54.101354+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (87, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-18T17:56:08.546406+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (88, 6, 'cartao', FALSE, NULL, '', '2026-08-18T17:56:24.914807+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (89, 13, 'cartao', FALSE, NULL, '', '2026-08-18T17:56:58.498552+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (90, 14.55, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:58:08.653369+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (91, 2.45, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:58:46.835827+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (92, 2, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:59:06.872365+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (93, 4, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T17:59:17.836987+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (94, 19, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T18:00:09.241596+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (95, 34, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T18:00:47.057101+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (96, 2, 'dinheiro', FALSE, NULL, '', '2026-08-18T18:01:03.336065+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (97, 2.5, 'dinheiro', FALSE, NULL, '', '2026-08-18T18:03:38.326445+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (98, 8, 'dinheiro', FALSE, NULL, '', '2026-08-18T18:03:49.487707+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (99, 7, 'cartao', FALSE, NULL, '', '2026-08-18T18:04:40.002147+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (100, 15, 'cartao', FALSE, NULL, '', '2026-08-18T18:17:16.472448+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (101, 12, 'cartao', FALSE, NULL, '', '2026-08-18T18:38:14.53773+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (102, 16, 'cartao', FALSE, NULL, '', '2026-08-18T19:01:58.007743+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (103, 6, 'cartao', FALSE, NULL, '', '2026-08-18T19:08:59.926063+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (104, 17.5, 'cartao', FALSE, NULL, 'com catupiry', '2026-08-18T19:32:04.797979+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (105, 4.85, 'dinheiro', FALSE, NULL, '', '2026-08-18T19:39:06.557523+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (106, 18, 'cartao', FALSE, NULL, '', '2026-08-18T20:59:51.758684+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (107, 38.5, 'dinheiro', FALSE, NULL, '', '2026-08-18T21:09:31.403775+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (108, 14, 'cartao', FALSE, NULL, '', '2026-08-18T21:12:01.70984+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (109, 14, 'cartao', FALSE, NULL, 'com cheddar', '2026-08-18T21:14:01.542836+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (110, 4.5, 'cartao', FALSE, NULL, '', '2026-08-18T21:16:40.826098+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (111, 6, 'pix', FALSE, NULL, '', '2026-08-18T21:17:52.874097+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (112, 4.5, 'cartao', FALSE, NULL, '', '2026-08-18T21:19:03.564928+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (113, 4.85, 'dinheiro', FALSE, NULL, '', '2026-08-18T21:20:10.373327+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (114, 3.85, 'cartao', FALSE, NULL, '', '2026-08-18T21:21:31.470806+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (115, 27, 'dinheiro', FALSE, NULL, '', '2026-08-18T21:23:10.526017+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (116, 6, 'dinheiro', FALSE, NULL, '', '2026-08-18T21:25:30.006318+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (117, 2, 'pix', FALSE, NULL, '', '2026-08-18T21:37:52.873489+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (118, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-18T21:49:32.086993+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (119, 7, 'pix', FALSE, NULL, '', '2026-08-18T21:49:53.029669+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (120, 6, 'pix', FALSE, NULL, '', '2026-08-19T09:20:31.458668+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (121, 16, 'pix', FALSE, NULL, '', '2026-08-19T09:54:40.236494+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (122, 3.5, 'pix', FALSE, NULL, '', '2026-08-19T09:55:35.106564+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (123, 16, 'pix', FALSE, NULL, '', '2026-08-19T10:02:12.805068+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (124, 2, 'dinheiro', FALSE, NULL, '', '2026-08-19T10:04:06.636291+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (125, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T10:05:13.853659+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (126, 5, 'cartao', FALSE, NULL, '', '2026-08-19T10:06:07.858324+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (127, 3.5, 'cartao', FALSE, NULL, '', '2026-08-19T10:50:33.558962+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (128, 9.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T12:01:03.283284+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (129, 9, 'dinheiro', FALSE, NULL, '', '2026-08-19T13:33:17.968181+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (130, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T14:09:15.922423+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (131, 6, 'cartao', FALSE, NULL, '', '2026-08-19T14:47:55.428989+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (132, 2.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T14:51:37.213521+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (133, 6, 'dinheiro', FALSE, NULL, '', '2026-08-19T15:16:32.905997+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (134, 4, 'pix', FALSE, NULL, '', '2026-08-19T15:20:37.018452+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (135, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T15:26:18.57441+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (136, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T15:27:08.711453+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (137, 14, 'pix', FALSE, NULL, '', '2026-08-19T15:30:32.519004+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (138, 4, 'dinheiro', FALSE, NULL, '', '2026-08-19T15:45:20.05169+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (139, 4.5, 'cartao', FALSE, NULL, '', '2026-08-19T15:47:11.399205+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (140, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T15:52:27.125722+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (141, 6, 'cartao', FALSE, NULL, '', '2026-08-19T15:53:00.929894+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (142, 2.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T15:54:02.848627+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (143, 8.5, 'pix', FALSE, NULL, '', '2026-08-19T15:59:07.551219+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (144, 2, 'pix', FALSE, NULL, '', '2026-08-19T16:00:15.133415+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (145, 2, 'dinheiro', FALSE, NULL, '', '2026-08-19T16:00:39.936673+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (146, 2, 'dinheiro', FALSE, NULL, '', '2026-08-19T16:00:49.676714+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (147, 4.9, 'cartao', FALSE, NULL, '', '2026-08-19T16:01:47.413668+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (148, 2, 'dinheiro', FALSE, NULL, '', '2026-08-19T16:22:49.599273+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (149, 65.5, 'cartao', FALSE, NULL, '', '2026-08-19T16:37:12.090601+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (150, 22.5, 'pix', FALSE, NULL, '', '2026-08-19T16:44:50.594224+00:00', NULL);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (151, 9, 'cartao', FALSE, NULL, '', '2026-08-19T19:52:03.124077+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (152, 4, 'cartao', FALSE, NULL, '', '2026-08-19T20:09:07.953262+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (153, 3.5, 'cartao', FALSE, NULL, '', '2026-08-19T20:09:18.095495+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (154, 5, 'cartao', FALSE, NULL, '', '2026-08-19T20:13:15.801877+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (155, 5, 'cartao', FALSE, NULL, '', '2026-08-19T20:13:30.623694+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (156, 42, 'cartao', FALSE, NULL, '', '2026-08-19T20:16:10.573817+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (157, 13.5, 'pix', FALSE, NULL, '', '2026-08-19T21:17:50.0569+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (158, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T21:20:53.280187+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (159, 20.5, 'pix', FALSE, NULL, '', '2026-08-19T21:26:02.641615+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (160, 16, 'dinheiro', FALSE, NULL, '15,00 foi em dinheiro e 1,00 foi no pix', '2026-08-19T21:32:03.165779+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (161, 10.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T21:38:57.840018+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (162, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T21:42:48.45184+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (163, 13.5, 'cartao', FALSE, NULL, '', '2026-08-19T21:43:26.239839+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (164, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T21:45:44.692429+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (165, 1.05, 'cartao', FALSE, NULL, '', '2026-08-19T21:46:28.370516+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (166, 15, 'dinheiro', FALSE, NULL, '', '2026-08-19T21:57:12.411271+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (167, 20, 'dinheiro', FALSE, NULL, '', '2026-08-19T21:57:34.590475+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (168, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T22:00:57.117204+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (169, 14, 'cartao', FALSE, NULL, '', '2026-08-19T22:12:03.926859+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (170, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T22:16:14.677476+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (171, 9, 'dinheiro', FALSE, NULL, '', '2026-08-19T22:39:41.17864+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (172, 8.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T22:53:16.338631+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (173, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T23:21:24.229885+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (174, 83, 'dinheiro', FALSE, NULL, '', '2026-08-19T23:29:56.960567+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (175, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T23:30:26.415704+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (176, 72, 'dinheiro', FALSE, NULL, '', '2026-08-19T23:34:08.446364+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (177, 72, 'dinheiro', FALSE, NULL, '', '2026-08-19T23:34:11.515901+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (178, 8.5, 'dinheiro', FALSE, NULL, '', '2026-08-19T23:34:36.01403+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (179, 28, 'cartao', FALSE, NULL, '', '2026-08-19T23:46:18.758977+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (180, 4, 'cartao', FALSE, NULL, '', '2026-08-19T23:54:42.151653+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (181, 6, 'cartao', FALSE, NULL, '', '2026-08-19T23:57:48.779398+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (182, 32.5, 'cartao', FALSE, NULL, 'com catupiry', '2026-08-20T00:17:04.825692+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (183, 2, 'dinheiro', FALSE, NULL, '', '2026-08-20T00:49:10.279076+00:00', 10);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (184, 6, 'cartao', FALSE, NULL, '', '2026-08-20T10:10:24.787961+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (185, 2.5, 'pix', FALSE, NULL, '', '2026-08-20T10:10:43.401805+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (186, 2, 'cartao', FALSE, NULL, '', '2026-08-20T10:11:09.212762+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (187, 6, 'dinheiro', FALSE, NULL, '', '2026-08-20T10:11:22.544655+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (188, 2, 'cartao', FALSE, NULL, '', '2026-08-20T10:11:38.010603+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (189, 5.05, 'cartao', FALSE, NULL, '', '2026-08-20T10:12:32.326078+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (190, 4.9, 'dinheiro', FALSE, NULL, '', '2026-08-20T11:24:35.248497+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (191, 4.5, 'dinheiro', FALSE, NULL, '', '2026-08-20T13:06:40.051291+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (192, 4, 'pix', FALSE, NULL, '', '2026-08-20T13:09:09.648009+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (193, 1.4, 'pix', FALSE, NULL, '', '2026-08-20T14:53:22.132954+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (194, 9, 'cartao', FALSE, NULL, '', '2026-08-20T15:21:26.093814+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (195, 3, 'cartao', FALSE, NULL, '', '2026-08-20T15:22:21.765231+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (196, 0.5, 'pix', FALSE, NULL, '', '2026-08-20T15:27:49.383557+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (197, 9, 'dinheiro', FALSE, NULL, '', '2026-08-20T15:29:25.641714+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (198, 3.85, 'cartao', FALSE, NULL, '', '2026-08-20T15:31:02.05708+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (199, 2, 'dinheiro', FALSE, NULL, '', '2026-08-20T15:34:37.904866+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (200, 18, 'cartao', FALSE, NULL, '', '2026-08-20T15:37:46.272429+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (201, 4.5, 'cartao', FALSE, NULL, '', '2026-08-20T15:38:00.505314+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (202, 0.7, 'pix', FALSE, NULL, 'pix da eliane', '2026-08-20T15:45:48.698974+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (203, 11, 'dinheiro', FALSE, NULL, '', '2026-08-20T15:48:35.530673+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (204, 1.4, 'dinheiro', FALSE, NULL, '', '2026-08-20T15:53:21.140186+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (205, 19, 'dinheiro', FALSE, NULL, '', '2026-08-20T15:57:08.449509+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (206, 4, 'pix', FALSE, NULL, '', '2026-08-20T15:57:58.927642+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (207, 30.5, 'cartao', FALSE, NULL, '', '2026-08-20T16:00:38.92214+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (208, 4, 'cartao', FALSE, NULL, '', '2026-08-20T16:00:56.988209+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (209, 1.05, 'dinheiro', FALSE, NULL, '', '2026-08-20T16:01:26.59431+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (210, 2.1, 'dinheiro', FALSE, NULL, '', '2026-08-20T16:21:43.342168+00:00', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id) VALUES (211, 14.5, 'pix', FALSE, NULL, '', '2026-08-20T19:14:40.959799+00:00', 10);

-- Tabela: pastel_recheios
CREATE TABLE IF NOT EXISTS pastel_recheios (
  id SERIAL PRIMARY KEY,
  produto_id INTEGER NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  ordem INTEGER NOT NULL DEFAULT 0,
  UNIQUE(produto_id, nome)
);
CREATE INDEX IF NOT EXISTS idx_pastel_recheios_produto ON pastel_recheios(produto_id);

INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (1, 53, 'Presunto e Queijo', 1, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (2, 53, 'Queijo', 2, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (3, 53, 'Calabresa', 3, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (4, 53, 'Carne', 4, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (5, 53, 'Frango', 5, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (6, 53, 'Palmito', 6, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (7, 53, 'Pizza', 7, NULL);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (8, 53, 'Nuttella com Morango', 100, 20);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (9, 53, 'Nuttella', 101, 20);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (10, 53, 'Romeu e Julieta', 102, 17);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem, preco) VALUES (11, 53, 'Banana com Canela', 103, 17);

-- Tabela: venda_itens
CREATE TABLE IF NOT EXISTS venda_itens (
  id SERIAL PRIMARY KEY,
  venda_id INTEGER NOT NULL REFERENCES vendas(id) ON DELETE CASCADE,
  produto_id INTEGER REFERENCES produtos(id),
  produto_nome TEXT NOT NULL,
  qtd NUMERIC NOT NULL,
  preco_unitario NUMERIC(10,2) NOT NULL,
  recheio TEXT
);

INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (114, 67, 82, 'Freegells Menta', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (115, 67, 60, 'Bala Bolete', 11, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (116, 68, 241, 'Energetico TNT original', 1, 8, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (117, 69, 75, 'Pooshs', 8, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (118, 69, 78, 'Pirulito Coca', 6, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (119, 69, 246, 'Chup-chup', 4, 1, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (120, 70, 241, 'Energetico TNT original', 1, 8, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (121, 71, 209, 'Guaraná 1 Litro', 1, 9, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (122, 72, 75, 'Pooshs', 3, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (123, 73, 225, 'Pirulito Boca Cereja', 5, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (124, 73, 69, 'Freegells Gum Menta', 1, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (125, 74, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (126, 75, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (127, 75, 249, 'Cafe', 1, 3.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (128, 76, 75, 'Pooshs', 3, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (129, 76, 78, 'Pirulito Coca', 1, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (130, 76, 61, 'Pirulito Bolete', 1, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (131, 77, 57, 'Risole de Presunto e Queijo', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (132, 77, 58, 'Enroladinho de Salsicha', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (133, 78, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (134, 79, 227, 'Mini Pizza', 2, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (135, 80, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (136, 80, 226, 'Pirulito Coração Morango', 3, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (137, 81, 75, 'Pooshs', 5, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (138, 82, 58, 'Enroladinho de Salsicha', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (139, 83, 226, 'Pirulito Coração Morango', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (140, 84, 56, 'Bolinho de Queijo', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (141, 84, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (142, 85, 247, 'Chocolate quente', 1, 7.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (143, 85, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (144, 85, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (145, 86, 54, 'Coxinha de Frango', 5, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (146, 86, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (147, 86, 155, 'Coca-Cola Zero 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (148, 86, 208, 'Soda 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (149, 87, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (150, 88, 150, 'Coca-Cola Zero Lata', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (151, 89, 57, 'Risole de Presunto e Queijo', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (152, 89, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (153, 90, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (154, 90, 75, 'Pooshs', 3, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (155, 90, 139, 'Coca-Cola 600 ML', 1, 9, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (156, 91, 220, 'Bala Caramelo', 7, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (157, 92, 225, 'Pirulito Boca Cereja', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (158, 93, 43, 'Água sem gás', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (159, 94, 227, 'Mini Pizza', 2, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (160, 94, 57, 'Risole de Presunto e Queijo', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (161, 95, 53, 'Pastel (Palmito)', 1, 14, 'Palmito');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (162, 95, 155, 'Coca-Cola Zero 200 ML', 2, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (163, 95, 243, 'BOLO DE POTE NINHO', 1, 12, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (164, 96, 78, 'Pirulito Coca', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (165, 97, 70, 'Freegells Gum Tutti Frutti', 1, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (166, 98, 241, 'Energetico TNT original', 1, 8, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (167, 99, 15, 'Plutonita', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (168, 99, 70, 'Freegells Gum Tutti Frutti', 2, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (169, 100, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (170, 100, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (171, 100, 81, 'Bala Freegells', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (172, 101, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (173, 101, 215, 'Guaraviton Açaí 500 ML', 1, 7.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (174, 102, 200, 'Açaí 300ml (Banana + Leite em pó)', 1, 16, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (175, 103, 152, 'Guaraná Lata', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (176, 104, 53, 'Pastel (Frango)', 1, 14, 'Frango');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (177, 104, 249, 'Cafe', 1, 3.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (178, 105, 44, 'Água com gás', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (179, 105, 220, 'Bala Caramelo', 1, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (180, 106, 54, 'Coxinha de Frango', 4, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (181, 107, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (182, 107, 53, 'Pastel (Queijo)', 1, 14, 'Queijo');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (183, 107, 200, 'Açaí 300ml (Granola + Leite condensado + Morango + Leite em pó)', 1, 20, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (184, 108, 53, 'Pastel (Carne)', 1, 14, 'Carne');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (185, 109, 53, 'Pastel (Calabresa)', 1, 14, 'Calabresa');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (186, 110, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (187, 111, 152, 'Guaraná Lata', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (188, 112, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (189, 113, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (190, 113, 86, 'Bala de Hortelã', 1, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (191, 114, 75, 'Pooshs', 11, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (192, 115, 54, 'Coxinha de Frango', 3, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (193, 115, 58, 'Enroladinho de Salsicha', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (194, 115, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (195, 116, 150, 'Coca-Cola Zero Lata', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (196, 117, 81, 'Bala Freegells', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (197, 118, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (198, 119, 189, 'Trufa Morango', 1, 7, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (199, 120, 81, 'Bala Freegells', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (200, 120, 84, 'Freegells Preto', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (201, 120, 82, 'Freegells Menta', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (202, 121, 242, 'BOLO DE POTE CHOCOLATE', 1, 12, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (203, 121, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (204, 122, 249, 'Cafe', 1, 3.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (205, 123, 216, 'TNT Tangerina 500 ML', 1, 8, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (206, 123, 241, 'Energetico TNT original', 1, 8, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (207, 124, 81, 'Bala Freegells', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (208, 125, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (209, 126, 69, 'Freegells Gum Menta', 1, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (210, 126, 71, 'Freegells Gum Morango', 1, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (211, 127, 249, 'Cafe', 1, 3.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (212, 128, 227, 'Mini Pizza', 1, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (213, 128, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (214, 129, 209, 'Guaraná 1 Litro', 1, 9, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (215, 130, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (216, 131, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (217, 132, 70, 'Freegells Gum Tutti Frutti', 1, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (218, 133, 153, 'Sukita Lata', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (219, 134, 253, 'Geladinho coco', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (220, 134, 178, 'Geladinho Morango', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (221, 135, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (222, 136, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (223, 137, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (224, 137, 227, 'Mini Pizza', 1, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (225, 137, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (226, 138, 43, 'Água sem gás', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (227, 139, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (228, 140, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (229, 141, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (230, 142, 15, 'Plutonita', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (231, 142, 225, 'Pirulito Boca Cereja', 1, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (232, 143, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (233, 143, 155, 'Coca-Cola Zero 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (234, 144, 178, 'Geladinho Morango', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (235, 145, 256, 'Freegels cereja', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (236, 146, 84, 'Freegells Preto', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (237, 147, 218, 'Bala Azedinha Roxa', 7, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (238, 147, 81, 'Bala Freegells vermelhinha', 7, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (239, 148, 253, 'Geladinho coco', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (240, 149, 53, 'Pastel (Pizza)', 1, 14, 'Pizza');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (241, 149, 53, 'Pastel (Carne+Queijo)', 2, 14, 'Carne+Queijo');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (242, 149, 211, 'Del Valle Uva 290 ML', 1, 7.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (243, 149, 209, 'Guaraná 1 Litro', 1, 9, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (244, 149, 189, 'Trufa Morango', 1, 7, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (245, 150, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (246, 150, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (247, 150, 209, 'Guaraná 1 Litro', 1, 9, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (248, 151, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (249, 151, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (250, 152, 43, 'Água sem gás', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (251, 153, 249, 'Cafe', 1, 3.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (252, 154, 227, 'Mini Pizza', 1, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (253, 155, 227, 'Mini Pizza', 1, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (254, 156, 53, 'Pastel (Pizza)', 1, 14, 'Pizza');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (255, 156, 53, 'Pastel (Queijo+Carne)', 2, 14, 'Queijo+Carne');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (256, 157, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (257, 157, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (258, 158, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (259, 159, 200, 'Açaí 300ml (Morango + Nuttella)', 1, 16, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (260, 159, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (261, 160, 200, 'Açaí 300ml (Leite condensado + Leite em pó)', 1, 16, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (262, 161, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (263, 161, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (264, 162, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (265, 163, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (266, 163, 57, 'Risole de Presunto e Queijo', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (267, 164, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (268, 165, 60, 'Bala Bolete', 3, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (269, 166, 248, 'Mini Pastel', 3, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (271, 168, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (272, 169, 53, 'Pastel (Pizza)', 1, 14, 'Pizza');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (273, 170, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (274, 171, 58, 'Enroladinho de Salsicha', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (275, 172, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (276, 172, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (277, 173, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (278, 174, 54, 'Coxinha de Frango', 4, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (279, 174, 55, 'Coxinha com Catupiry', 13, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (280, 175, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (281, 176, 57, 'Risole de Presunto e Queijo', 16, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (282, 177, 57, 'Risole de Presunto e Queijo', 16, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (283, 178, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (284, 178, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (285, 179, 53, 'Pastel (Queijo)', 2, 14, 'Queijo');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (286, 180, 206, 'Sprite 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (287, 181, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (288, 182, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (289, 182, 53, 'Pastel (Queijo+Carne)', 1, 14, 'Queijo+Carne');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (290, 182, 53, 'Pastel (Pizza)', 1, 14, 'Pizza');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (291, 183, 31, 'Geleia de Frutas', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (270, 167, NULL, 'Pastel doce', 1, 20, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (292, 184, 255, 'ouro branco', 3, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (293, 185, 69, 'Freegells Gum Menta', 1, 2.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (294, 186, 225, 'Pirulito Boca Cereja', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (295, 187, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (296, 188, 82, 'Freegells Menta', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (297, 189, 78, 'Pirulito Coca', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (298, 189, 225, 'Pirulito Boca Cereja', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (299, 189, 221, 'Bala Iceriss', 3, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (300, 190, 87, 'Balinha do Coração', 14, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (301, 191, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (302, 192, 206, 'Sprite 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (303, 193, 75, 'Pooshs', 4, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (304, 194, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (305, 195, 88, 'Bola 7', 10, 0.3, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (306, 196, 78, 'Pirulito Coca', 1, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (307, 197, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (308, 197, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (309, 198, 75, 'Pooshs', 11, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (310, 199, 78, 'Pirulito Coca', 4, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (311, 200, 248, 'Mini Pastel (Queijo)', 1, 5, 'Queijo');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (312, 200, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (313, 200, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (314, 200, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (315, 201, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (316, 202, 75, 'Pooshs', 2, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (317, 203, 257, 'ENERG TNT MAÇA VERDE 473ml', 1, 9, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (318, 203, 246, 'Chup-chup', 2, 1, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (319, 204, 75, 'Pooshs', 4, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (320, 205, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (321, 205, 248, 'Mini Pastel (Presunto e Queijo)', 2, 5, 'Presunto e Queijo');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (322, 206, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (323, 207, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (324, 207, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (325, 207, 227, 'Mini Pizza', 4, 5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (326, 208, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (327, 209, 75, 'Pooshs', 3, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (328, 210, 60, 'Bala Bolete', 6, 0.35, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (329, 211, 248, 'Mini Pastel (Carne+Queijo)', 1, 5, 'Carne+Queijo');
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (330, 211, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (331, 211, 225, 'Pirulito Boca Cereja', 2, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (332, 211, 29, 'Pé de Moça', 2, 2, NULL);

-- Tabela: movimentacoes
CREATE TABLE IF NOT EXISTS movimentacoes (
  id SERIAL PRIMARY KEY,
  tipo TEXT NOT NULL,
  produto_id INTEGER REFERENCES produtos(id),
  produto_nome TEXT NOT NULL,
  qtd NUMERIC NOT NULL,
  obs TEXT,
  data TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (54, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Consumo funcionário', '2026-08-17T17:44:20.799242+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (55, 'saida', 54, 'Coxinha de Frango', 1, 'Consumo funcionário', '2026-08-17T17:44:20.799242+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (56, 'saida', 82, 'Freegells Menta', 2, 'Venda balcão - cartao', '2026-08-17T18:19:58.529577+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (57, 'saida', 86, 'Bala de Hortelã', 5, 'Venda balcão - cartao', '2026-08-17T18:19:58.529577+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (58, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T18:34:47.355158+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (59, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - dinheiro', '2026-08-17T18:35:06.27298+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (60, 'saida', 244, 'Energetico Bally', 1, 'Venda balcão - cartao', '2026-08-17T18:38:23.283026+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (61, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - dinheiro', '2026-08-17T18:39:34.53179+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (64, 'saida', 78, 'Pirulito Coca', 2, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (65, 'saida', 88, 'Bola 7', 6, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (66, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-17T18:52:03.005879+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (68, 'saida', 198, 'Massa de Pastel', 1, 'Venda (99) - dinheiro', '2026-08-17T18:55:46.601783+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (69, 'saida', 209, 'Guaraná 1 Litro', 1, 'Venda balcão - cartao', '2026-08-17T19:01:38.052087+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (70, 'saida', 198, 'Massa de Pastel', 2, 'Consumo funcionário', '2026-08-17T19:03:13.664254+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (71, 'saida', 227, 'Mini Pizza', 2, 'Consumo funcionário', '2026-08-17T19:03:56.447066+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (72, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-17T19:09:39.406179+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (73, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-17T19:09:39.406179+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (74, 'saida', 208, 'Soda 200 ML', 1, 'Consumo funcionário', '2026-08-17T19:25:43.806024+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (75, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Consumo funcionário', '2026-08-17T20:15:22.906778+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (67, 'saida', NULL, 'Coxinha (pacotes)', 1, 'Venda balcão - cartao', '2026-08-17T18:54:19.343263+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (76, 'saida', 43, 'Água sem gás', 1, 'Consumo funcionário', '2026-08-17T20:38:32.070523+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (77, 'saida', 242, 'BOLO DE POTE CHOCOLATE', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:09.328404+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (78, 'saida', 213, 'Del Valle Pêssego 290 ML', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:09.328404+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (79, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:09.328404+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (80, 'saida', 242, 'BOLO DE POTE CHOCOLATE', 1, 'Venda balcão - cartao', '2026-08-17T21:02:26.010276+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (81, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:59.433273+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (82, 'saida', 243, 'BOLO DE POTE NINHO', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:59.433273+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (83, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - cartao', '2026-08-17T21:20:42.813977+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (84, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - cartao', '2026-08-17T21:20:42.813977+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (85, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:20:42.813977+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (86, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - cartao', '2026-08-17T21:20:43.675701+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (87, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - cartao', '2026-08-17T21:20:43.675701+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (88, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:20:43.675701+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (89, 'saida', 54, 'Coxinha de Frango', 4, 'Venda balcão - cartao', '2026-08-17T21:21:19.71121+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (90, 'saida', 86, 'Bala de Hortelã', 4, 'Venda balcão - dinheiro', '2026-08-17T21:22:18.87093+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (91, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:27:19.925875+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (92, 'saida', 198, 'Massa de Pastel', 1, 'Venda (ifood) - dinheiro', '2026-08-17T21:48:19.70545+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (93, 'saida', 198, 'Massa de Pastel', 1, 'Venda (ifood) - dinheiro', '2026-08-17T21:48:41.66292+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (94, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:49:56.624714+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (95, 'saida', 54, 'Coxinha de Frango', 3, 'Venda balcão - cartao', '2026-08-17T21:49:56.624714+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (96, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-17T21:50:49.402858+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (97, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - dinheiro', '2026-08-17T21:52:58.794246+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (98, 'saida', 83, 'Freegells Choco', 1, 'Venda balcão - dinheiro', '2026-08-17T21:52:58.794246+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (100, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-18T01:16:48.407106+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (101, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - dinheiro', '2026-08-18T01:17:19.399153+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (103, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-18T01:18:15.76837+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (104, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-18T01:18:30.98106+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (105, 'saida', 54, 'Coxinha de Frango', 4, 'Venda balcão - dinheiro', '2026-08-18T01:19:16.999688+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (106, 'saida', 86, 'Bala de Hortelã', 4, 'Venda balcão - dinheiro', '2026-08-18T01:19:16.999688+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (107, 'saida', 15, 'Plutonita', 4, 'Venda balcão - cartao', '2026-08-18T01:19:54.176818+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (108, 'saida', 198, 'Massa de Pastel', 2, 'Venda balcão - cartao', '2026-08-18T01:20:15.101857+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (109, 'saida', 15, 'Plutonita', 7, 'Venda balcão - dinheiro', '2026-08-18T01:21:21.023246+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (110, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - dinheiro', '2026-08-18T01:21:45.119207+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (111, 'saida', 15, 'Plutonita', 7, 'Venda balcão - dinheiro', '2026-08-18T01:22:01.712689+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (112, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-18T01:22:22.053897+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (113, 'saida', 218, 'Bala Azedinha Roxa', 2, 'Venda balcão - dinheiro', '2026-08-18T01:22:22.053897+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (114, 'saida', 247, 'Chocolate quente', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (115, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (116, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (117, 'saida', 174, 'Geladinho Açaí', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (118, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - dinheiro', '2026-08-18T01:25:24.958401+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (119, 'saida', 48, 'Skol', 2, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (120, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (121, 'saida', 214, 'Del Valle Manga 290 ML', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (122, 'saida', 247, 'Chocolate quente', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (123, 'saida', 46, 'Todynho', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (124, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-18T01:29:05.115292+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (125, 'saida', 57, 'Risole de Presunto e Queijo', 2, 'Venda balcão - dinheiro', '2026-08-18T01:30:12.202652+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (126, 'entrada', 82, 'Freegells Menta', 4, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (127, 'entrada', 247, 'Chocolate quente', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (128, 'entrada', 83, 'Freegells Choco', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (129, 'entrada', 244, 'Energetico Bally', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (130, 'entrada', 43, 'Água sem gás', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (131, 'entrada', 78, 'Pirulito Coca', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (63, 'saida', NULL, 'Poosh Verde', 3, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (99, 'saida', NULL, 'Poosh Verde', 4, 'Venda balcão - dinheiro', '2026-08-18T01:16:28.234888+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (132, 'entrada', 174, 'Geladinho Açaí', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (133, 'entrada', 58, 'Enroladinho de Salsicha', 7, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (134, 'entrada', 86, 'Bala de Hortelã', 13, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (135, 'entrada', 213, 'Del Valle Pêssego 290 ML', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (137, 'entrada', 15, 'Plutonita', 18, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (138, 'entrada', 53, 'Pastel (Carne+Queijo)', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (139, 'entrada', 57, 'Risole de Presunto e Queijo', 9, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (140, 'entrada', 242, 'BOLO DE POTE CHOCOLATE', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (141, 'entrada', 54, 'Coxinha de Frango', 15, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (142, 'entrada', 243, 'BOLO DE POTE NINHO', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (143, 'entrada', 46, 'Todynho', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (144, 'entrada', 245, 'Coca Cola lata 350ml', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (145, 'entrada', 150, 'Coca-Cola Zero Lata', 4, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (146, 'entrada', 48, 'Skol', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (148, 'entrada', 214, 'Del Valle Manga 290 ML', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (149, 'entrada', 218, 'Bala Azedinha Roxa', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (150, 'entrada', 53, 'Pastel (Presunto e Queijo)', 5, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (151, 'entrada', 209, 'Guaraná 1 Litro', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (152, 'entrada', 88, 'Bola 7', 6, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (153, 'entrada', 53, 'Pastel (Frango)', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (154, 'saida', 82, 'Freegells Menta', 3, 'Venda balcão - cartao', '2026-08-18T10:43:22.453661+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (155, 'saida', 86, 'Bala de Hortelã', 5, 'Venda balcão - cartao', '2026-08-18T10:43:22.453661+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (156, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-18T10:43:32.90909+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (157, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - dinheiro', '2026-08-18T10:43:49.024814+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (158, 'saida', 244, 'Energetico Bally', 1, 'Venda balcão - cartao', '2026-08-18T10:45:17.187763+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (159, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - dinheiro', '2026-08-18T11:22:25.325369+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (162, 'saida', 88, 'Bola 7', 7, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (163, 'saida', 78, 'Pirulito Coca', 2, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (164, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-18T11:25:17.345726+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (165, 'saida', 54, 'Coxinha de Frango', 3, 'Venda balcão - cartao', '2026-08-18T11:30:00.237025+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (166, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-18T11:30:00.237025+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (62, 'saida', NULL, 'Poosh Roxo', 3, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (102, 'saida', NULL, 'Poosh Roxo', 2, 'Venda balcão - dinheiro', '2026-08-18T01:17:19.399153+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (147, 'entrada', NULL, 'Poosh Roxo', 5, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (136, 'entrada', NULL, 'Poosh Verde', 7, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (160, 'saida', NULL, 'Poosh Verde', 3, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (161, 'saida', NULL, 'Poosh Vermelho', 4, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (167, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - cartao', '2026-08-18T17:42:45.652286+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (168, 'saida', 60, 'Bala Bolete', 11, 'Venda balcão - cartao', '2026-08-18T17:42:45.652286+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (169, 'saida', 241, 'Energetico TNT original', 1, 'Venda balcão - cartao', '2026-08-18T17:43:43.875764+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (170, 'saida', 75, 'Pooshs', 8, 'Venda balcão - cartao', '2026-08-18T17:44:37.832799+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (171, 'saida', 78, 'Pirulito Coca', 6, 'Venda balcão - cartao', '2026-08-18T17:44:37.832799+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (172, 'saida', 246, 'Chup-chup', 4, 'Venda balcão - cartao', '2026-08-18T17:44:37.832799+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (173, 'saida', 241, 'Energetico TNT original', 1, 'Venda balcão - cartao', '2026-08-18T17:44:58.035126+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (174, 'saida', 209, 'Guaraná 1 Litro', 1, 'Venda balcão - cartao', '2026-08-18T17:45:19.671538+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (175, 'saida', 75, 'Pooshs', 3, 'Venda balcão - dinheiro', '2026-08-18T17:45:55.517961+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (176, 'saida', 225, 'Pirulito Boca Cereja', 5, 'Venda balcão - dinheiro', '2026-08-18T17:47:06.966038+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (177, 'saida', 69, 'Freegells Gum Menta', 1, 'Venda balcão - dinheiro', '2026-08-18T17:47:06.966038+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (178, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-18T17:47:32.627484+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (179, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-18T17:48:04.456358+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (180, 'saida', 249, 'Cafe', 1, 'Venda balcão - cartao', '2026-08-18T17:48:04.456358+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (181, 'saida', 75, 'Pooshs', 3, 'Venda balcão - dinheiro', '2026-08-18T17:48:52.01754+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (182, 'saida', 78, 'Pirulito Coca', 1, 'Venda balcão - dinheiro', '2026-08-18T17:48:52.01754+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (183, 'saida', 61, 'Pirulito Bolete', 1, 'Venda balcão - dinheiro', '2026-08-18T17:48:52.01754+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (184, 'saida', 57, 'Risole de Presunto e Queijo', 2, 'Venda balcão - cartao', '2026-08-18T17:49:56.800582+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (185, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - cartao', '2026-08-18T17:49:56.800582+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (186, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Consumo funcionário', '2026-08-18T17:50:29.235421+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (187, 'saida', 43, 'Água sem gás', 1, 'Consumo funcionário', '2026-08-18T17:50:29.235421+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (188, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-18T17:50:52.2893+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (189, 'saida', 227, 'Mini Pizza', 2, 'Venda balcão - cartao', '2026-08-18T17:51:10.831936+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (190, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-18T17:52:17.595215+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (191, 'saida', 226, 'Pirulito Coração Morango', 3, 'Venda balcão - cartao', '2026-08-18T17:52:17.595215+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (192, 'saida', 75, 'Pooshs', 5, 'Venda balcão - cartao', '2026-08-18T17:53:02.776643+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (193, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - cartao', '2026-08-18T17:53:19.581245+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (194, 'saida', 226, 'Pirulito Coração Morango', 4, 'Venda balcão - dinheiro', '2026-08-18T17:53:44.537078+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (195, 'saida', 56, 'Bolinho de Queijo', 2, 'Venda balcão - cartao', '2026-08-18T17:54:07.952413+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (196, 'saida', 54, 'Coxinha de Frango', 2, 'Venda balcão - cartao', '2026-08-18T17:54:07.952413+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (197, 'saida', 247, 'Chocolate quente', 1, 'Venda balcão - cartao', '2026-08-18T17:54:31.957292+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (198, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-18T17:54:31.957292+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (199, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-18T17:54:31.957292+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (200, 'saida', 54, 'Coxinha de Frango', 5, 'Venda balcão - cartao', '2026-08-18T17:55:54.407112+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (201, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-18T17:55:54.407112+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (202, 'saida', 155, 'Coca-Cola Zero 200 ML', 1, 'Venda balcão - cartao', '2026-08-18T17:55:54.407112+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (203, 'saida', 208, 'Soda 200 ML', 1, 'Venda balcão - cartao', '2026-08-18T17:55:54.407112+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (204, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - dinheiro', '2026-08-18T17:56:08.706085+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (205, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - cartao', '2026-08-18T17:56:25.103824+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (206, 'saida', 57, 'Risole de Presunto e Queijo', 2, 'Venda balcão - cartao', '2026-08-18T17:56:58.745075+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (207, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - cartao', '2026-08-18T17:56:58.745075+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (208, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-18T17:58:08.911069+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (209, 'saida', 75, 'Pooshs', 3, 'Venda balcão - cartao', '2026-08-18T17:58:08.911069+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (210, 'saida', 139, 'Coca-Cola 600 ML', 1, 'Venda balcão - cartao', '2026-08-18T17:58:08.911069+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (211, 'saida', 220, 'Bala Caramelo', 7, 'Venda balcão - cartao', '2026-08-18T17:58:47.057718+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (212, 'saida', 225, 'Pirulito Boca Cereja', 4, 'Venda balcão - cartao', '2026-08-18T17:59:07.004758+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (213, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - cartao', '2026-08-18T17:59:17.974039+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (214, 'saida', 227, 'Mini Pizza', 2, 'Venda balcão - cartao', '2026-08-18T18:00:09.519092+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (215, 'saida', 57, 'Risole de Presunto e Queijo', 2, 'Venda balcão - cartao', '2026-08-18T18:00:09.519092+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (216, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T18:00:47.273181+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (217, 'saida', 155, 'Coca-Cola Zero 200 ML', 2, 'Venda balcão - cartao', '2026-08-18T18:00:47.273181+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (218, 'saida', 243, 'BOLO DE POTE NINHO', 1, 'Venda balcão - cartao', '2026-08-18T18:00:47.273181+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (219, 'saida', 78, 'Pirulito Coca', 4, 'Venda balcão - dinheiro', '2026-08-18T18:01:03.62553+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (220, 'saida', 70, 'Freegells Gum Tutti Frutti', 1, 'Venda balcão - dinheiro', '2026-08-18T18:03:38.617272+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (221, 'saida', 241, 'Energetico TNT original', 1, 'Venda balcão - dinheiro', '2026-08-18T18:03:50.093454+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (222, 'saida', 15, 'Plutonita', 4, 'Venda balcão - cartao', '2026-08-18T18:04:40.365601+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (223, 'saida', 70, 'Freegells Gum Tutti Frutti', 2, 'Venda balcão - cartao', '2026-08-18T18:04:40.365601+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (224, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - cartao', '2026-08-18T18:17:16.786315+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (225, 'saida', 54, 'Coxinha de Frango', 2, 'Venda balcão - cartao', '2026-08-18T18:17:16.786315+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (226, 'saida', 81, 'Bala Freegells', 1, 'Venda balcão - cartao', '2026-08-18T18:17:16.786315+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (227, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-18T18:38:14.878153+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (228, 'saida', 215, 'Guaraviton Açaí 500 ML', 1, 'Venda balcão - cartao', '2026-08-18T18:38:14.878153+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (229, 'saida', 119, 'Açaí 300ml', 1, 'Venda balcão - cartao', '2026-08-18T19:01:58.414804+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (230, 'saida', 152, 'Guaraná Lata', 1, 'Venda balcão - cartao', '2026-08-18T19:09:00.236388+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (231, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T19:32:05.168286+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (232, 'saida', 249, 'Cafe', 1, 'Venda balcão - cartao', '2026-08-18T19:32:05.168286+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (233, 'saida', 44, 'Água com gás', 1, 'Venda balcão - dinheiro', '2026-08-18T19:39:06.843785+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (234, 'saida', 220, 'Bala Caramelo', 1, 'Venda balcão - dinheiro', '2026-08-18T19:39:06.843785+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (235, 'saida', 54, 'Coxinha de Frango', 4, 'Venda balcão - cartao', '2026-08-18T20:59:52.115192+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (236, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-18T21:09:31.841341+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (237, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - dinheiro', '2026-08-18T21:09:31.841341+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (238, 'saida', 119, 'Açaí 300ml', 1, 'Venda balcão - dinheiro', '2026-08-18T21:09:31.841341+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (239, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T21:12:02.396551+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (240, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T21:14:01.838582+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (241, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-18T21:16:41.130762+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (242, 'saida', 152, 'Guaraná Lata', 1, 'Venda balcão - pix', '2026-08-18T21:17:53.19836+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (243, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-18T21:19:03.822663+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (244, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-18T21:20:10.772749+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (245, 'saida', 86, 'Bala de Hortelã', 1, 'Venda balcão - dinheiro', '2026-08-18T21:20:10.772749+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (246, 'saida', 75, 'Pooshs', 11, 'Venda balcão - cartao', '2026-08-18T21:21:31.810051+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (247, 'saida', 54, 'Coxinha de Frango', 3, 'Venda balcão - dinheiro', '2026-08-18T21:23:10.816095+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (248, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - dinheiro', '2026-08-18T21:23:10.816095+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (249, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-18T21:23:10.816095+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (250, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - dinheiro', '2026-08-18T21:25:30.305397+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (251, 'saida', 81, 'Bala Freegells', 1, 'Venda balcão - pix', '2026-08-18T21:37:53.176994+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (252, 'saida', 208, 'Soda 200 ML', 1, 'Consumo funcionário', '2026-08-18T21:43:15.577222+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (253, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-18T21:49:32.436429+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (254, 'saida', 189, 'Trufa Morango', 1, 'Venda balcão - pix', '2026-08-18T21:49:53.195245+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (255, 'saida', 243, 'BOLO DE POTE NINHO', 1, 'Consumo funcionário', '2026-08-18T21:57:17.911916+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (256, 'saida', 119, 'Açaí 300ml', 1, 'Consumo funcionário', '2026-08-18T22:17:24.701292+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (257, 'saida', 247, 'Chocolate quente', 1, 'Consumo funcionário', '2026-08-18T22:17:48.590577+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (258, 'saida', 81, 'Bala Freegells', 1, 'Venda balcão - pix', '2026-08-19T09:20:31.724057+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (259, 'saida', 84, 'Freegells Preto', 1, 'Venda balcão - pix', '2026-08-19T09:20:31.724057+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (260, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - pix', '2026-08-19T09:20:31.724057+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (261, 'saida', 242, 'BOLO DE POTE CHOCOLATE', 1, 'Venda balcão - pix', '2026-08-19T09:54:40.460591+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (262, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - pix', '2026-08-19T09:54:40.460591+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (263, 'saida', 249, 'Cafe', 1, 'Venda balcão - pix', '2026-08-19T09:55:35.305603+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (264, 'saida', 216, 'TNT Tangerina 500 ML', 1, 'Venda balcão - pix', '2026-08-19T10:02:13.057582+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (265, 'saida', 241, 'Energetico TNT original', 1, 'Venda balcão - pix', '2026-08-19T10:02:13.057582+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (266, 'saida', 81, 'Bala Freegells', 1, 'Venda balcão - dinheiro', '2026-08-19T10:04:06.881396+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (267, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T10:05:14.030419+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (268, 'saida', 69, 'Freegells Gum Menta', 1, 'Venda balcão - cartao', '2026-08-19T10:06:08.057946+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (269, 'saida', 71, 'Freegells Gum Morango', 1, 'Venda balcão - cartao', '2026-08-19T10:06:08.057946+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (270, 'saida', 249, 'Cafe', 1, 'Venda balcão - cartao', '2026-08-19T10:50:33.816076+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (271, 'saida', 75, 'Pooshs', 1, 'Consumo funcionário', '2026-08-19T10:55:30.997023+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (272, 'saida', 227, 'Mini Pizza', 1, 'Venda balcão - dinheiro', '2026-08-19T12:01:03.626413+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (273, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T12:01:03.626413+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (274, 'saida', 209, 'Guaraná 1 Litro', 1, 'Venda balcão - dinheiro', '2026-08-19T13:33:18.257528+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (275, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - dinheiro', '2026-08-19T14:09:16.216638+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (276, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-19T14:47:55.681869+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (277, 'saida', 70, 'Freegells Gum Tutti Frutti', 1, 'Venda balcão - dinheiro', '2026-08-19T14:51:37.461784+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (278, 'saida', 60, 'Bala Bolete', 1, 'Consumo funcionário', '2026-08-19T15:01:31.586348+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (279, 'saida', 153, 'Sukita Lata', 1, 'Venda balcão - dinheiro', '2026-08-19T15:16:34.169852+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (280, 'saida', 253, 'Geladinho coco', 1, 'Venda balcão - pix', '2026-08-19T15:20:37.374843+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (281, 'saida', 178, 'Geladinho Morango', 1, 'Venda balcão - pix', '2026-08-19T15:20:37.374843+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (282, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - dinheiro', '2026-08-19T15:26:18.846877+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (283, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-19T15:27:08.8948+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (284, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - pix', '2026-08-19T15:30:33.551614+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (285, 'saida', 227, 'Mini Pizza', 1, 'Venda balcão - pix', '2026-08-19T15:30:33.551614+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (286, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - pix', '2026-08-19T15:30:33.551614+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (287, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - dinheiro', '2026-08-19T15:45:20.308333+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (288, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-19T15:47:11.746147+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (289, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T15:52:27.315995+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (290, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-19T15:53:01.093278+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (291, 'saida', 15, 'Plutonita', 4, 'Venda balcão - dinheiro', '2026-08-19T15:54:03.158411+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (292, 'saida', 225, 'Pirulito Boca Cereja', 1, 'Venda balcão - dinheiro', '2026-08-19T15:54:03.158411+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (293, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - pix', '2026-08-19T15:59:07.709189+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (294, 'saida', 155, 'Coca-Cola Zero 200 ML', 1, 'Venda balcão - pix', '2026-08-19T15:59:07.709189+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (295, 'saida', 178, 'Geladinho Morango', 1, 'Venda balcão - pix', '2026-08-19T16:00:15.623572+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (296, 'saida', 256, 'Freegels cereja', 1, 'Venda balcão - dinheiro', '2026-08-19T16:00:40.837784+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (297, 'saida', 84, 'Freegells Preto', 1, 'Venda balcão - dinheiro', '2026-08-19T16:00:49.872416+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (298, 'saida', 218, 'Bala Azedinha Roxa', 7, 'Venda balcão - cartao', '2026-08-19T16:01:48.706868+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (299, 'saida', 81, 'Bala Freegells vermelhinha', 7, 'Venda balcão - cartao', '2026-08-19T16:01:48.706868+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (300, 'saida', 227, 'Mini Pizza', 1, 'Consumo funcionário', '2026-08-19T16:10:37.016391+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (301, 'saida', 253, 'Geladinho coco', 1, 'Venda balcão - dinheiro', '2026-08-19T16:22:49.82669+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (302, 'saida', 198, 'Massa de Pastel', 3, 'Venda balcão - cartao', '2026-08-19T16:37:12.308962+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (303, 'saida', 211, 'Del Valle Uva 290 ML', 1, 'Venda balcão - cartao', '2026-08-19T16:37:12.308962+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (304, 'saida', 209, 'Guaraná 1 Litro', 1, 'Venda balcão - cartao', '2026-08-19T16:37:12.308962+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (305, 'saida', 189, 'Trufa Morango', 1, 'Venda balcão - cartao', '2026-08-19T16:37:12.308962+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (306, 'saida', 54, 'Coxinha de Frango', 2, 'Venda balcão - pix', '2026-08-19T16:44:50.819943+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (307, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - pix', '2026-08-19T16:44:50.819943+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (308, 'saida', 209, 'Guaraná 1 Litro', 1, 'Venda balcão - pix', '2026-08-19T16:44:50.819943+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (309, 'saida', 253, 'Geladinho coco', 1, 'Consumo funcionário', '2026-08-19T17:24:41.105951+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (310, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Consumo funcionário', '2026-08-19T18:33:25.499339+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (311, 'saida', 209, 'Guaraná 1 Litro', 1, 'Consumo funcionário', '2026-08-19T19:01:35.398113+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (312, 'saida', 15, 'Plutonita', 1, 'Consumo funcionário', '2026-08-19T19:01:35.398113+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (313, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-19T19:52:03.305834+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (314, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-19T19:52:03.305834+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (315, 'saida', 54, 'Coxinha de Frango', 1, 'Consumo funcionário', '2026-08-19T19:56:57.299111+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (316, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - cartao', '2026-08-19T20:09:08.122232+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (317, 'saida', 249, 'Cafe', 1, 'Venda balcão - cartao', '2026-08-19T20:09:18.283189+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (318, 'saida', 227, 'Mini Pizza', 1, 'Venda balcão - cartao', '2026-08-19T20:13:16.057894+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (319, 'saida', 227, 'Mini Pizza', 1, 'Venda balcão - cartao', '2026-08-19T20:13:30.794792+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (320, 'saida', 198, 'Massa de Pastel', 3, 'Venda balcão - cartao', '2026-08-19T20:16:10.827546+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (321, 'entrada', 143, 'Fanta Laranja 1,5L', 4, '[4 un]', '2026-08-19T20:20:25.517263+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (322, 'entrada', 208, 'Soda 200 ML', 36, '[36 un]', '2026-08-19T20:22:51.378191+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (323, 'entrada', 207, 'Sukita 200 ML', 12, '[12 un]', '2026-08-19T20:26:47.68403+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (324, 'entrada', 258, 'ENERG TNT MANGO 473ml', 2, '[2 un]', '2026-08-19T20:27:25.929637+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (325, 'entrada', 259, 'Guaranazinho 200ml', 12, '[12 un]', '2026-08-19T20:28:05.293668+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (326, 'entrada', 257, 'ENERG TNT MAÇA VERDE 473ml', 2, '[2 un]', '2026-08-19T20:28:26.920828+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (327, 'entrada', 241, 'Energetico TNT original', 6, '[6 un]', '2026-08-19T20:38:10.239263+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (328, 'saida', 198, 'Massa de Pastel', 1, 'Consumo funcionário', '2026-08-19T20:47:07.973182+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (329, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Consumo funcionário', '2026-08-19T20:47:07.973182+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (330, 'saida', 254, 'Geladinho morango', 1, 'Consumo funcionário', '2026-08-19T20:48:34.639626+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (331, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - pix', '2026-08-19T21:17:50.339882+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (332, 'saida', 54, 'Coxinha de Frango', 2, 'Venda balcão - pix', '2026-08-19T21:17:50.339882+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (333, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T21:20:53.536344+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (334, 'saida', 119, 'Açaí 300ml', 1, 'Venda balcão - pix', '2026-08-19T21:26:02.992662+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (335, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - pix', '2026-08-19T21:26:02.992662+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (336, 'saida', 119, 'Açaí 300ml', 1, 'Venda balcão - dinheiro', '2026-08-19T21:32:03.470693+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (337, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - dinheiro', '2026-08-19T21:38:58.042797+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (338, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T21:38:58.042797+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (339, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T21:42:48.751839+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (340, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-19T21:43:26.437559+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (341, 'saida', 57, 'Risole de Presunto e Queijo', 2, 'Venda balcão - cartao', '2026-08-19T21:43:26.437559+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (342, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - dinheiro', '2026-08-19T21:45:44.981908+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (343, 'saida', 60, 'Bala Bolete', 3, 'Venda balcão - cartao', '2026-08-19T21:46:28.577143+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (344, 'saida', 248, 'Mini Pastel', 3, 'Venda balcão - dinheiro', '2026-08-19T21:57:12.61312+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (346, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T22:00:57.296976+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (347, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-19T22:12:04.092359+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (348, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T22:16:14.867596+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (349, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - dinheiro', '2026-08-19T22:39:41.369181+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (350, 'saida', 43, 'Água sem gás', 1, 'Consumo funcionário', '2026-08-19T22:52:56.039456+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (351, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T22:53:16.509523+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (352, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - dinheiro', '2026-08-19T22:53:16.509523+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (353, 'saida', 178, 'Geladinho Morango', 1, 'Consumo funcionário', '2026-08-19T23:15:22.461765+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (354, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - dinheiro', '2026-08-19T23:21:24.482257+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (355, 'saida', 54, 'Coxinha de Frango', 4, 'Venda balcão - dinheiro', '2026-08-19T23:29:57.22599+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (356, 'saida', 55, 'Coxinha com Catupiry', 13, 'Venda balcão - dinheiro', '2026-08-19T23:29:57.22599+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (357, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-19T23:30:26.62311+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (358, 'saida', 57, 'Risole de Presunto e Queijo', 16, 'Venda balcão - dinheiro', '2026-08-19T23:34:08.673298+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (359, 'saida', 57, 'Risole de Presunto e Queijo', 16, 'Venda balcão - dinheiro', '2026-08-19T23:34:11.618628+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (360, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - dinheiro', '2026-08-19T23:34:36.154895+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (361, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - dinheiro', '2026-08-19T23:34:36.154895+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (362, 'entrada', 245, 'Coca Cola lata 350ml', 2, '[2 un]', '2026-08-19T23:45:50.77997+00:00', 10);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (363, 'saida', 198, 'Massa de Pastel', 2, 'Venda balcão - cartao', '2026-08-19T23:46:18.946641+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (364, 'saida', 206, 'Sprite 200 ML', 1, 'Venda balcão - cartao', '2026-08-19T23:54:42.43775+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (365, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-19T23:57:49.040988+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (366, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-20T00:17:04.974641+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (367, 'saida', 198, 'Massa de Pastel', 2, 'Venda balcão - cartao', '2026-08-20T00:17:04.974641+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (368, 'saida', 31, 'Geleia de Frutas', 1, 'Venda balcão - dinheiro', '2026-08-20T00:49:10.557888+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (369, 'saida', 54, 'Coxinha de Frango', 1, 'Consumo funcionário', '2026-08-20T01:02:23.864729+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (370, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Consumo funcionário', '2026-08-20T01:02:23.864729+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (371, 'saida', 198, 'Massa de Pastel', 2, 'Consumo funcionário', '2026-08-20T01:55:40.153812+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (345, 'saida', NULL, 'Pastel doce', 1, 'Venda balcão - dinheiro', '2026-08-19T21:57:34.740122+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (372, 'saida', 255, 'ouro branco', 3, 'Venda balcão - cartao', '2026-08-20T10:10:25.035531+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (373, 'saida', 69, 'Freegells Gum Menta', 1, 'Venda balcão - pix', '2026-08-20T10:10:43.55428+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (374, 'saida', 225, 'Pirulito Boca Cereja', 4, 'Venda balcão - cartao', '2026-08-20T10:11:09.363315+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (375, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - dinheiro', '2026-08-20T10:11:22.683511+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (376, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - cartao', '2026-08-20T10:11:38.190008+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (377, 'saida', 78, 'Pirulito Coca', 4, 'Venda balcão - cartao', '2026-08-20T10:12:32.529885+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (378, 'saida', 225, 'Pirulito Boca Cereja', 4, 'Venda balcão - cartao', '2026-08-20T10:12:32.529885+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (379, 'saida', 221, 'Bala Iceriss', 3, 'Venda balcão - cartao', '2026-08-20T10:12:32.529885+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (380, 'saida', 87, 'Balinha do Coração', 14, 'Venda balcão - dinheiro', '2026-08-20T11:24:35.606334+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (381, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-20T13:06:40.245025+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (382, 'saida', 206, 'Sprite 200 ML', 1, 'Venda balcão - pix', '2026-08-20T13:09:09.82216+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (383, 'saida', 90, 'Chiclete Ball', 1, 'Consumo funcionário', '2026-08-20T14:02:44.631151+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (384, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Consumo funcionário', '2026-08-20T14:47:14.574493+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (385, 'saida', 75, 'Pooshs', 4, 'Venda balcão - pix', '2026-08-20T14:53:22.353553+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (386, 'saida', 54, 'Coxinha de Frango', 2, 'Venda balcão - cartao', '2026-08-20T15:21:26.370864+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (387, 'saida', 88, 'Bola 7', 10, 'Venda balcão - cartao', '2026-08-20T15:22:22.185723+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (388, 'saida', 78, 'Pirulito Coca', 1, 'Venda balcão - pix', '2026-08-20T15:27:49.716054+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (389, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-20T15:29:25.863542+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (390, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - dinheiro', '2026-08-20T15:29:25.863542+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (391, 'saida', 75, 'Pooshs', 11, 'Venda balcão - cartao', '2026-08-20T15:31:02.509427+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (392, 'saida', 78, 'Pirulito Coca', 4, 'Venda balcão - dinheiro', '2026-08-20T15:34:38.170689+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (393, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-20T15:38:00.749844+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (394, 'saida', 75, 'Pooshs', 2, 'Venda balcão - pix', '2026-08-20T15:45:48.963733+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (395, 'saida', 257, 'ENERG TNT MAÇA VERDE 473ml', 1, 'Venda balcão - dinheiro', '2026-08-20T15:48:35.738095+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (396, 'saida', 246, 'Chup-chup', 2, 'Venda balcão - dinheiro', '2026-08-20T15:48:35.738095+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (397, 'saida', 75, 'Pooshs', 4, 'Venda balcão - dinheiro', '2026-08-20T15:53:21.444827+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (398, 'saida', 54, 'Coxinha de Frango', 2, 'Venda balcão - dinheiro', '2026-08-20T15:57:08.659589+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (399, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - dinheiro', '2026-08-20T15:57:08.659589+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (400, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - pix', '2026-08-20T15:57:59.211781+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (401, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-20T16:00:39.255723+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (402, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-20T16:00:39.255723+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (403, 'saida', 227, 'Mini Pizza', 4, 'Venda balcão - cartao', '2026-08-20T16:00:39.255723+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (404, 'saida', 156, 'Coca-Cola 200 ML', 1, 'Venda balcão - cartao', '2026-08-20T16:00:57.776666+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (405, 'saida', 75, 'Pooshs', 3, 'Venda balcão - dinheiro', '2026-08-20T16:01:26.791533+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (406, 'saida', 60, 'Bala Bolete', 6, 'Venda balcão - dinheiro', '2026-08-20T16:21:43.607495+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (407, 'saida', 254, 'Geladinho morango', 1, 'Consumo funcionário', '2026-08-20T17:02:02.192027+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (408, 'saida', 175, 'Geladinho Limão', 1, 'Consumo funcionário', '2026-08-20T17:02:16.639553+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (409, 'saida', 241, 'Energetico TNT original', 1, 'Consumo funcionário', '2026-08-20T17:19:55.124338+00:00', NULL);
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data, usuario_id) VALUES (410, 'saida', 101, 'Açaí 500ml', 1, 'Consumo funcionário', '2026-08-20T17:34:16.527031+00:00', NULL);

-- Tabela: caixa
CREATE TABLE IF NOT EXISTS caixa (
  id SERIAL PRIMARY KEY,
  troco_inicial NUMERIC(10,2),
  data_abertura TIMESTAMPTZ NOT NULL,
  data_fechamento TIMESTAMPTZ,
  valor_final NUMERIC(10,2),
  total_vendas_dinheiro NUMERIC(10,2),
  usuario_abertura_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
  usuario_fechamento_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL
);

INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (13, 55, '2026-08-18T10:41:37.276+00:00', '2026-08-18T16:49:00.936+00:00', 55, 0, 14, 5);
INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (14, 58, '2026-08-18T18:06:45.24+00:00', '2026-08-18T20:29:26.634+00:00', 434.85, 4.85, 14, 14);
INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (15, 85, '2026-08-18T20:44:15.108+00:00', '2026-08-18T22:35:38.436+00:00', 251.1, 80.85, 10, 10);
INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (16, 30, '2026-08-19T09:18:36.942+00:00', '2026-08-19T17:23:04.611+00:00', 261.5, 64, 14, 14);
INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (17, 86.5, '2026-08-19T17:25:42.961+00:00', '2026-08-20T01:07:53.445+00:00', 185, 348, 10, 10);
INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (18, 47.5, '2026-08-20T10:16:29.786+00:00', '2026-08-20T17:14:48.75+00:00', 161.95, 54.949999999999996, 14, 14);
INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (19, 101.4, '2026-08-20T17:22:24.588+00:00', NULL, NULL, NULL, 10, NULL);

-- Tabela: caixa_retiradas
CREATE TABLE IF NOT EXISTS caixa_retiradas (
  id SERIAL PRIMARY KEY,
  caixa_id INTEGER NOT NULL REFERENCES caixa(id) ON DELETE CASCADE,
  valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),
  motivo TEXT NOT NULL,
  usuario_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_caixa_retiradas_caixa ON caixa_retiradas(caixa_id);

INSERT INTO caixa_retiradas (id, caixa_id, valor, motivo, usuario_id, data) VALUES (5, 18, 6.1, 'retirada 99 motoboy coca', 14, '2026-08-20T16:53:57.306+00:00');

-- Tabela: consumos
CREATE TABLE IF NOT EXISTS consumos (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  total NUMERIC(10,2) NOT NULL DEFAULT 0,
  obs TEXT,
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_consumos_usuario_data ON consumos(usuario_id, data);

INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (10, 14, 4, NULL, '2026-08-17T19:25:43.597161+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (12, 5, 4, NULL, '2026-08-17T20:38:31.878616+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (9, 11, 4, NULL, '2026-08-17T19:03:56.314242+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (8, 11, 4, NULL, '2026-08-17T19:03:13.475699+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (7, 5, 4, NULL, '2026-08-17T17:44:20.618398+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (11, 8, 4, NULL, '2026-08-17T20:15:22.727809+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (13, 5, 8.5, NULL, '2026-08-18T17:50:28.995509+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (14, 8, 4, NULL, '2026-08-18T21:43:15.398033+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (15, 8, 12, NULL, '2026-08-18T21:57:17.713635+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (16, 14, 16, NULL, '2026-08-18T22:17:24.394748+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (17, 8, 7.5, NULL, '2026-08-18T22:17:48.402556+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (18, 14, 0.35, NULL, '2026-08-19T10:55:30.833204+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (19, 14, 0.35, NULL, '2026-08-19T15:01:31.345905+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (20, 14, 5, NULL, '2026-08-19T16:10:36.82902+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (21, 14, 2, NULL, '2026-08-19T17:24:40.879299+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (22, 10, 9, NULL, '2026-08-19T18:33:25.276193+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (23, 10, 9.5, NULL, '2026-08-19T19:01:34.963162+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (24, 8, 4.5, NULL, '2026-08-19T19:56:56.945452+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (25, 5, 18, NULL, '2026-08-19T20:47:07.778675+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (26, 5, 2, NULL, '2026-08-19T20:48:34.494158+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (27, 5, 4, NULL, '2026-08-19T22:52:55.891009+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (28, 8, 2, NULL, '2026-08-19T23:15:22.299517+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (29, 10, 9, NULL, '2026-08-20T01:02:23.678134+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (31, 14, 1.5, NULL, '2026-08-20T14:02:44.416921+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (32, 14, 4, NULL, '2026-08-20T14:47:14.411224+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (33, 8, 2, NULL, '2026-08-20T17:02:01.912257+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (34, 5, 4.5, NULL, '2026-08-20T17:02:16.480938+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (35, 5, 9, NULL, '2026-08-20T17:19:54.950663+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (36, 14, 25, NULL, '2026-08-20T17:34:16.311237+00:00');

-- Tabela: consumo_itens
CREATE TABLE IF NOT EXISTS consumo_itens (
  id SERIAL PRIMARY KEY,
  consumo_id INTEGER NOT NULL REFERENCES consumos(id) ON DELETE CASCADE,
  produto_id INTEGER REFERENCES produtos(id) ON DELETE SET NULL,
  produto_nome TEXT NOT NULL,
  qtd NUMERIC(10,2) NOT NULL DEFAULT 1,
  preco_unitario NUMERIC(10,2) NOT NULL DEFAULT 0,
  recheio TEXT
);
CREATE INDEX IF NOT EXISTS idx_consumo_itens_consumo ON consumo_itens(consumo_id);

INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (32, 13, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (33, 13, 43, 'Água sem gás', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (34, 14, 208, 'Soda 200 ML', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (35, 15, 243, 'BOLO DE POTE NINHO', 1, 12, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (36, 16, 200, 'Açaí 300ml (Granola + Morango + Abacaxi )', 1, 16, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (37, 17, 247, 'Chocolate quente', 1, 7.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (38, 18, 75, 'Pooshs', 1, 0.35, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (39, 19, 60, 'Bala Bolete', 1, 0.35, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (40, 20, 227, 'Mini Pizza', 1, 5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (41, 21, 253, 'Geladinho coco', 1, 2, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (42, 22, 58, 'Enroladinho de Salsicha', 2, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (43, 23, 209, 'Guaraná 1 Litro', 1, 9, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (44, 23, 15, 'Plutonita', 1, 0.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (45, 24, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (46, 25, 53, 'Pastel (Presunto e Queijo)', 1, 14, 'Presunto e Queijo');
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (47, 25, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (48, 26, 254, 'Geladinho morango', 1, 2, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (49, 27, 43, 'Água sem gás', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (50, 28, 178, 'Geladinho Morango', 1, 2, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (51, 29, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (52, 29, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (54, 31, 90, 'Chiclete Ball', 1, 1.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (55, 32, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (56, 33, 254, 'Geladinho morango', 1, 2, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (57, 34, 175, 'Geladinho Limão', 1, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (58, 35, 241, 'Energetico TNT original', 1, 9, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (59, 36, 201, 'Açaí 500ml (Granola + Morango + Nuttella + Abacaxi )', 1, 25, NULL);

-- Tabela: acai_complementos
CREATE TABLE IF NOT EXISTS acai_complementos (
  id BIGSERIAL PRIMARY KEY,
  nome TEXT UNIQUE NOT NULL,
  preco NUMERIC(10,2) NOT NULL DEFAULT 0,
  ordem INT NOT NULL DEFAULT 0
);

INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (3, 'Banana', 2, 3);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (4, 'Morango', 2, 4);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (6, 'Paçoca', 3, 6);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (5, 'Leite em pó', 4, 5);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (7, 'Nuttella', 4, 7);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (2, 'Leite condensado', 2, 2);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (1, 'Granola', 2, 1);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (8, 'Abacaxi ', 2, 8);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (9, 'Manga ', 2, 9);
INSERT INTO acai_complementos (id, nome, preco, ordem) VALUES (10, 'Farinha láctea ', 3, 10);

-- Tabela: contagem
CREATE TABLE IF NOT EXISTS contagem (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  produto_id INTEGER NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  qtd NUMERIC NOT NULL DEFAULT 0,
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_contagem_usuario_data ON contagem(usuario_id, data);
CREATE INDEX IF NOT EXISTS idx_contagem_produto ON contagem(produto_id);

INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (2, 5, 44, 0, '2026-08-20T04:48:14.518+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (242, 14, 52, 15, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (243, 14, 49, 29, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (244, 14, 48, 9, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (245, 14, 51, 5, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (246, 14, 185, 3, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (247, 14, 186, 2, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (248, 14, 218, 110, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (249, 14, 60, 107, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (250, 14, 220, 166, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (251, 14, 86, 109, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (252, 14, 81, 72, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (253, 14, 221, 116, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (254, 14, 87, 47, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (255, 14, 88, 140, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (256, 14, 90, 45, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (257, 14, 62, 2, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (258, 14, 246, 36, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (259, 14, 30, 3, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (260, 14, 98, 16, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (261, 14, 64, 7, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (262, 14, 65, 6, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (263, 14, 63, 10, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (264, 14, 96, 16, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (265, 14, 83, 1, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (266, 14, 69, 3, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (267, 14, 71, 5, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (268, 14, 82, 12, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (269, 14, 84, 16, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (270, 14, 31, 8, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (271, 14, 91, 18, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (272, 14, 28, 24, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (273, 14, 255, 19, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (274, 14, 66, 132, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (275, 14, 250, 2, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (276, 14, 29, 23, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (277, 14, 225, 48, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (278, 14, 61, 5, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (279, 14, 78, 84, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (280, 14, 80, 10, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (281, 14, 15, 19, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (282, 14, 75, 168, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (283, 14, 68, 1, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (284, 14, 256, 8, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (285, 14, 230, 3, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (286, 14, 229, 5, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (287, 14, 253, 8, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (288, 14, 175, 5, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (289, 14, 254, 14, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (290, 14, 172, 2, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (291, 14, 170, 3, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (292, 14, 171, 2, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (293, 14, 173, 3, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (294, 14, 165, 8, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (295, 14, 168, 10, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (296, 14, 169, 10, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (297, 14, 167, 8, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (298, 14, 164, 10, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (299, 14, 166, 2, '2026-08-20T13:41:50.038+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (454, 10, 44, 10, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (455, 10, 154, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (456, 10, 43, 11, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (457, 10, 245, 7, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (458, 10, 156, 21, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (459, 10, 155, 12, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (460, 10, 212, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (461, 10, 214, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (462, 10, 251, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (463, 10, 213, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (464, 10, 211, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (465, 10, 263, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (466, 10, 265, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (467, 10, 143, 4, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (468, 10, 262, 12, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (469, 10, 209, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (470, 10, 152, 23, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (471, 10, 151, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (472, 10, 259, 12, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (473, 10, 215, 6, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (474, 10, 208, 45, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (475, 10, 206, 18, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (476, 10, 207, 23, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (477, 10, 153, 15, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (478, 10, 216, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (479, 10, 217, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (480, 10, 145, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (481, 10, 52, 15, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (482, 10, 49, 29, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (483, 10, 48, 9, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (484, 10, 51, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (485, 10, 243, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (486, 10, 232, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (487, 10, 195, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (488, 10, 235, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (489, 10, 192, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (490, 10, 233, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (491, 10, 236, 0, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (492, 10, 194, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (493, 10, 185, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (494, 10, 186, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (495, 10, 136, 8, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (496, 10, 218, 110, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (497, 10, 60, 107, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (498, 10, 220, 166, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (499, 10, 86, 109, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (500, 10, 81, 72, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (501, 10, 221, 116, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (502, 10, 87, 47, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (503, 10, 88, 140, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (504, 10, 90, 45, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (505, 10, 62, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (506, 10, 246, 36, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (507, 10, 30, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (508, 10, 98, 16, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (509, 10, 64, 7, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (510, 10, 65, 6, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (511, 10, 63, 10, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (512, 10, 96, 16, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (513, 10, 83, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (514, 10, 69, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (515, 10, 71, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (516, 10, 82, 12, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (517, 10, 84, 16, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (518, 10, 31, 8, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (519, 10, 91, 18, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (520, 10, 28, 24, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (521, 10, 255, 19, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (522, 10, 66, 132, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (523, 10, 250, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (524, 10, 29, 23, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (525, 10, 225, 48, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (526, 10, 61, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (527, 10, 78, 84, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (528, 10, 80, 10, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (529, 10, 15, 19, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (530, 10, 75, 168, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (531, 10, 68, 1, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (532, 10, 256, 8, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (533, 10, 230, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (534, 10, 229, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (535, 10, 253, 8, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (536, 10, 175, 5, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (537, 10, 254, 14, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (538, 10, 172, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (539, 10, 170, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (540, 10, 171, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (541, 10, 173, 3, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (542, 10, 165, 8, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (543, 10, 168, 10, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (544, 10, 169, 10, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (545, 10, 167, 8, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (546, 10, 164, 10, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (547, 10, 166, 2, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (548, 10, 59, 20, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (549, 10, 58, 15, '2026-08-20T19:37:25.715+00:00');
INSERT INTO contagem (id, usuario_id, produto_id, qtd, data) VALUES (550, 10, 188, 3, '2026-08-20T19:37:25.715+00:00');

-- Tabela: gastos
CREATE TABLE IF NOT EXISTS gastos (
  id SERIAL PRIMARY KEY,
  descricao TEXT NOT NULL,
  categoria TEXT NOT NULL DEFAULT 'Outros',
  valor NUMERIC(10,2) NOT NULL DEFAULT 0,
  pagamento TEXT NOT NULL DEFAULT 'dinheiro',
  data TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fixo BOOLEAN NOT NULL DEFAULT FALSE,
  tipo TEXT NOT NULL DEFAULT 'outros',
  itens JSONB,
  usuario_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_gastos_data ON gastos(data);
CREATE INDEX IF NOT EXISTS idx_gastos_categoria ON gastos(categoria);

INSERT INTO gastos (id, descricao, categoria, valor, pagamento, data, fixo, usuario_id, created_at, tipo, itens) VALUES (3, 'Aluguel', 'Aluguel', 1500, 'pix', '2026-08-25T00:00:00+00:00', TRUE, 5, '2026-08-20T04:52:19.246965+00:00', 'outros', NULL);
INSERT INTO gastos (id, descricao, categoria, valor, pagamento, data, fixo, usuario_id, created_at, tipo, itens) VALUES (4, 'Internet', 'Internet', 75, 'pix', '2026-08-20T05:04:37.754+00:00', TRUE, 5, '2026-08-20T05:03:18.613472+00:00', 'outros', NULL);
INSERT INTO gastos (id, descricao, categoria, valor, pagamento, data, fixo, usuario_id, created_at, tipo, itens) VALUES (5, 'Pagamento funcionarios', 'Funcionários', 1600, 'pix', '2026-08-20T05:05:07.882+00:00', TRUE, 5, '2026-08-20T05:03:48.790893+00:00', 'outros', NULL);
INSERT INTO gastos (id, descricao, categoria, valor, pagamento, data, fixo, usuario_id, created_at, tipo, itens) VALUES (6, 'Agua', 'Água', 100, 'pix', '2026-08-20T05:05:40.016+00:00', TRUE, 5, '2026-08-20T05:04:20.925969+00:00', 'outros', NULL);
INSERT INTO gastos (id, descricao, categoria, valor, pagamento, data, fixo, usuario_id, created_at, tipo, itens) VALUES (7, 'Energia', 'Energia', 350, 'pix', '2026-08-20T05:06:11.26+00:00', TRUE, 5, '2026-08-20T05:04:52.058042+00:00', 'outros', NULL);

-- ============================================================
-- Fim do backup
-- ============================================================
