-- ============================================================
-- Backup GerenciarStock
-- Data: 18/08/2026, 13:10:33
-- Tabelas: 11
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

INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (55, 'Coxinha com Catupiry', 'Salgados', 15, 5, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (59, 'Bolinho de Carne', 'Salgados', 0, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (200, 'Açaí 300ml', 'Açaí', 0, 0, 10, 'acai');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (66, 'Paçoca', 'Doces e Guloseimas', 111, 5, 1, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (75, 'Poosh Rosa', 'Doces e Guloseimas', 0, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (81, 'Bala Freegells', 'Doces e Guloseimas', 84, 20, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (245, 'Coca Cola lata 350ml', 'Refrigerantes', 17, 1, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (247, 'Chocolate quente', 'Bebidas', 20, 1, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (62, 'Chocolate Ki-Kakau', 'Doces e Guloseimas', 2, 3, 1, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (60, 'Bala Bolete', 'Doces e Guloseimas', 128, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (65, 'Fini Verde Azedo', 'Doces e Guloseimas', 6, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (242, 'BOLO DE POTE CHOCOLATE', 'bolo de pote', 1, 1, 12, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (243, 'BOLO DE POTE NINHO', 'bolo de pote', 3, 1, 12, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (77, 'Poosh Roxo', 'Doces e Guloseimas', 0, 5, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (130, 'Saco G', 'Embalagens', 40, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (101, 'Copo 500 ML', 'Embalagens', 7, 10, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (119, 'Copo 300 ML', 'Embalagens', 9, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (137, 'Guardanapo', 'Descartáveis', 7, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (138, 'Guardanapo 200 un', 'Descartáveis', 7, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (136, 'Papel Toalha G', 'Descartáveis', 4, 3, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (239, 'Colher G', 'Embalagens', 29, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (240, 'Colher P', 'Embalagens', 46, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (58, 'Enroladinho de Salsicha', 'Salgados', 21, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (61, 'Pirulito Bolete', 'Doces e Guloseimas', 7, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (79, 'Pirulito Boca', 'Doces e Guloseimas', 56, 10, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (80, 'Pirulito Coração', 'Doces e Guloseimas', 17, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (241, 'Energetico TNT original', 'Energetico', 6, 1, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (15, 'Plutonita', 'Doces e Guloseimas', 28, 5, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (53, 'Pastel', 'Pastéis', 143, 0, 14, 'pastel');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (71, 'Freegells Gum Morango', 'Doces e Guloseimas', 46, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (70, 'Freegells Gum Tutti Frutti', 'Doces e Guloseimas', 4, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (69, 'Freegells Gum Menta', 'Doces e Guloseimas', 6, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (201, 'Açaí 500ml', 'Açaí', 0, 0, 15, 'acai');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (56, 'Bolinho de Queijo', 'Salgados', 7, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (244, 'Energetico Bally', 'Energetico', 0, 1, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (73, 'Poosh Verde', 'Doces e Guloseimas', 0, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (78, 'Pirulito Coca', 'Doces e Guloseimas', 85, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (74, 'Poosh Vermelho', 'Doces e Guloseimas', 0, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (63, 'Fini Vermelho', 'Doces e Guloseimas', 10, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (64, 'Fini Roxo', 'Doces e Guloseimas', 7, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (54, 'Coxinha de Frango', 'Salgados', 57, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (57, 'Risole de Presunto e Queijo', 'Salgados', 35, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (68, 'Tortuguita', 'Doces e Guloseimas', 1, 3, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (76, 'Poosh 7 Belo', 'Doces e Guloseimas', 0, 5, 0.3, 'estoque');
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
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (29, 'Pé de Moça', 'Doces e Guloseimas', 24, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (222, 'Outro Doce', 'Doces e Guloseimas', 19, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (223, 'Fini Azedinho', 'Doces e Guloseimas', 8, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (175, 'Geladinho Limão', 'Geladinhos', 8, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (220, 'Bala Caramelo', 'Doces e Guloseimas', 174, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (164, 'Polpa Manga', 'Polpas', 10, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (165, 'Polpa Abacaxi', 'Polpas', 8, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (166, 'Polpa Maracujá', 'Polpas', 6, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (167, 'Polpa Goiaba', 'Polpas', 8, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (168, 'Polpa Acerola', 'Polpas', 10, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (169, 'Polpa Caju', 'Polpas', 10, 5, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (170, 'Gelo Saborizado Maçã Verde', 'Gelos Saborizados', 3, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (171, 'Gelo Saborizado Melancia', 'Gelos Saborizados', 2, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (172, 'Gelo Saborizado Coco', 'Gelos Saborizados', 2, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (173, 'Gelo Saborizado Morango', 'Gelos Saborizados', 3, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (176, 'Geladinho Coco', 'Geladinhos', 9, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (177, 'Geladinho Maracujá', 'Geladinhos', 8, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (178, 'Geladinho Morango', 'Geladinhos', 12, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (179, 'Recheio Queijo', 'Recheios Congelados', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (180, 'Recheio Calabresa', 'Recheios Congelados', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (181, 'Recheio Presunto', 'Recheios Congelados', 8, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (182, 'Recheio Frango', 'Recheios Congelados', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (183, 'Recheio Palmito', 'Recheios Congelados', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (185, 'Frango a Passarinho', 'Congelados', 3, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (186, 'Mini Pastel (sacos)', 'Congelados', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (187, 'Gelo (saco)', 'Gelo', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (188, 'Trufa Coco', 'Trufas', 4, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (190, 'Trufa Maracujá', 'Trufas', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (93, 'Doces Tony Kelly', 'Doces e Guloseimas', 3, 3, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (221, 'Bala Iceriss', 'Doces e Guloseimas', 113, 20, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (174, 'Geladinho Açaí', 'Geladinhos', 12, 5, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (225, 'Pirulito Boca Cereja', 'Doces e Guloseimas', 68, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (226, 'Pirulito Coração Morango', 'Doces e Guloseimas', 18, 5, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (215, 'Guaraviton Açaí 500 ML', 'Bebidas', 2, 2, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (211, 'Del Valle Uva 290 ML', 'Bebidas', 4, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (212, 'Del Valle Goiaba 290 ML', 'Bebidas', 5, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (214, 'Del Valle Manga 290 ML', 'Bebidas', 1, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (216, 'TNT Tangerina 500 ML', 'Bebidas', 3, 3, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (217, 'TNT Uva 500 ML', 'Bebidas', 3, 3, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (206, 'Sprite 200 ML', 'Bebidas', 21, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (207, 'Sukita 200 ML', 'Bebidas', 11, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (209, 'Guaraná 1 Litro', 'Bebidas', 10, 5, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (213, 'Del Valle Pêssego 290 ML', 'Bebidas', 4, 3, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (218, 'Bala Azedinha Roxa', 'Doces e Guloseimas', 115, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (227, 'Mini Pizza', 'Salgados', 22, 5, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (208, 'Soda 200 ML', 'Bebidas', 12, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (191, 'Trufa Brigadeiro', 'Trufas', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (192, 'Ketchup (caixa)', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (195, 'Café Solúvel', 'Condimentos', 1, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (31, 'Geleia de Frutas', 'Doces e Guloseimas', 9, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (30, 'Doce de Abóbora', 'Doces e Guloseimas', 3, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (157, 'Soda Limonada', 'Bebidas', 12, 5, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (47, 'Gatorade', 'Bebidas', 4, 5, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (86, 'Bala de Hortelã', 'Doces e Guloseimas', 108, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (51, 'Skol Beats', 'Bebidas Alcoólicas', 5, 5, 10, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (49, 'Original', 'Bebidas Alcoólicas', 29, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (43, 'Água sem gás', 'Bebidas', 50, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (147, 'TNT Sport', 'Bebidas', 3, 5, 8, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (139, 'Coca-Cola 600 ML', 'Bebidas', 1, 5, 9, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (149, 'Suco Del Valle Lata', 'Bebidas', 0, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (145, 'Tônica', 'Bebidas', 2, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (142, 'Energético Furioso 2L', 'Bebidas', 6, 3, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (82, 'Freegells Menta', 'Doces e Guloseimas', 0, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (155, 'Coca-Cola Zero 200 ML', 'Bebidas', 19, 10, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (89, 'Bala Azedinha', 'Doces e Guloseimas', 142, 10, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (156, 'Coca-Cola 200 ML', 'Bebidas', 32, 5, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (154, 'Água de Coco 200 ML', 'Bebidas', 5, 3, 4, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (88, 'Bola 7', 'Doces e Guloseimas', 142, 20, 0.3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (84, 'Freegells Preto', 'Doces e Guloseimas', 18, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (144, 'Guaraná 1,5L', 'Bebidas', 11, 3, 10, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (143, 'Fanta Laranja 1,5L', 'Bebidas', 12, 3, 10, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (87, 'Balinha do Coração', 'Doces e Guloseimas', 60, 10, 0.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (152, 'Guaraná Lata', 'Bebidas', 24, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (96, 'Fount de Leite', 'Doces e Guloseimas', 16, 5, 2, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (199, 'Amstel', 'Bebidas Alcoólicas', 13, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (52, 'Heineken', 'Bebidas Alcoólicas', 35, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (146, 'Guaraviton', 'Bebidas', 7, 5, 7.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (28, 'Molecão', 'Doces e Guloseimas', 24, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (158, 'Sprite', 'Bebidas', 21, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (44, 'Água com gás', 'Bebidas', 12, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (98, 'Doce de Banana', 'Doces e Guloseimas', 17, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (151, 'Guaraná Zero Lata', 'Bebidas', 3, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (153, 'Sukita Lata', 'Bebidas', 4, 3, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (246, 'Chup-chup', 'Doces e Guloseimas', 40, 1, 1, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (189, 'Trufa Morango', 'Trufas', 2, 2, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (228, 'Morango Congelado', 'Congelados', 2, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (229, 'Geladinho Açaí com Nutella', 'Geladinhos', 5, 3, 7, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (230, 'Geladinho Açaí com Leite Condensado', 'Geladinhos', 5, 3, 7, 'estoque');
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
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (91, 'Gomets Tubo', 'Doces e Guloseimas', 19, 5, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (198, 'Massa de Pastel', 'Insumos', 146, 1, 0, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (90, 'Chiclete Ball', 'Doces e Guloseimas', 46, 10, 1.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (83, 'Freegells Choco', 'Doces e Guloseimas', 2, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (150, 'Coca-Cola Zero Lata', 'Bebidas', 2, 5, 6, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (48, 'Skol', 'Bebidas Alcoólicas', 9, 5, 4.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (46, 'Todynho', 'Bebidas', 18, 5, 3, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (248, 'Mini Pastel', 'Pastéis', 7, 5, 5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (249, 'Ouro Branco', 'Doces e Guloseimas', 25, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (250, 'Paçoca de Chocolate', 'Doces e Guloseimas', 2, 5, 2.5, 'estoque');
INSERT INTO produtos (id, nome, categoria, qtd, qtd_minima, preco, tipo) VALUES (251, 'Del Valle Maracujá 290 ML', 'Bebidas', 2, 3, 7.5, 'estoque');

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

INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (59, 7.5, 'cartao', FALSE, NULL, '', '2026-08-18T10:43:22.103829+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (60, 4.5, 'cartao', FALSE, NULL, '', '2026-08-18T10:43:32.743603+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (61, 4, 'dinheiro', FALSE, NULL, '', '2026-08-18T10:43:48.890265+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (62, 8, 'cartao', FALSE, NULL, '', '2026-08-18T10:45:16.933824+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (63, 2, 'dinheiro', FALSE, NULL, '', '2026-08-18T11:22:25.012459+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (64, 5.2, 'dinheiro', FALSE, NULL, '', '2026-08-18T11:24:42.805189+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (65, 4.5, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T11:25:17.15546+00:00');
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data) VALUES (66, 18, 'cartao', FALSE, NULL, 'pix maquinha', '2026-08-18T11:30:00.034744+00:00');

-- Tabela: pastel_recheios
CREATE TABLE IF NOT EXISTS pastel_recheios (
  id SERIAL PRIMARY KEY,
  produto_id INTEGER NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  ordem INTEGER NOT NULL DEFAULT 0,
  UNIQUE(produto_id, nome)
);
CREATE INDEX IF NOT EXISTS idx_pastel_recheios_produto ON pastel_recheios(produto_id);

INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (1, 53, 'Presunto e Queijo', 1);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (2, 53, 'Queijo', 2);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (3, 53, 'Calabresa', 3);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (4, 53, 'Carne', 4);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (5, 53, 'Frango', 5);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (6, 53, 'Palmito', 6);
INSERT INTO pastel_recheios (id, produto_id, nome, ordem) VALUES (7, 53, 'Pizza', 7);

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

INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (101, 59, 82, 'Freegells Menta', 3, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (102, 59, 86, 'Bala de Hortelã', 5, 0.3, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (103, 60, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (104, 61, 43, 'Água sem gás', 1, 4, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (105, 62, 244, 'Energetico Bally', 1, 8, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (106, 63, 82, 'Freegells Menta', 1, 2, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (107, 64, 73, 'Poosh Verde', 3, 0.3, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (108, 64, 74, 'Poosh Vermelho', 4, 0.3, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (109, 64, 88, 'Bola 7', 7, 0.3, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (110, 64, 78, 'Pirulito Coca', 2, 0.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (111, 65, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (112, 66, 54, 'Coxinha de Frango', 3, 4.5, NULL);
INSERT INTO venda_itens (id, venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (113, 66, 57, 'Risole de Presunto e Queijo', 1, 4.5, NULL);

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

INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (54, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Consumo funcionário', '2026-08-17T17:44:20.799242+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (55, 'saida', 54, 'Coxinha de Frango', 1, 'Consumo funcionário', '2026-08-17T17:44:20.799242+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (56, 'saida', 82, 'Freegells Menta', 2, 'Venda balcão - cartao', '2026-08-17T18:19:58.529577+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (57, 'saida', 86, 'Bala de Hortelã', 5, 'Venda balcão - cartao', '2026-08-17T18:19:58.529577+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (58, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T18:34:47.355158+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (59, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - dinheiro', '2026-08-17T18:35:06.27298+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (60, 'saida', 244, 'Energetico Bally', 1, 'Venda balcão - cartao', '2026-08-17T18:38:23.283026+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (61, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - dinheiro', '2026-08-17T18:39:34.53179+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (62, 'saida', 77, 'Poosh Roxo', 3, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (63, 'saida', 73, 'Poosh Verde', 3, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (64, 'saida', 78, 'Pirulito Coca', 2, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (65, 'saida', 88, 'Bola 7', 6, 'Venda balcão - dinheiro', '2026-08-17T18:43:10.662593+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (66, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-17T18:52:03.005879+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (68, 'saida', 198, 'Massa de Pastel', 1, 'Venda (99) - dinheiro', '2026-08-17T18:55:46.601783+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (69, 'saida', 209, 'Guaraná 1 Litro', 1, 'Venda balcão - cartao', '2026-08-17T19:01:38.052087+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (70, 'saida', 198, 'Massa de Pastel', 2, 'Consumo funcionário', '2026-08-17T19:03:13.664254+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (71, 'saida', 227, 'Mini Pizza', 2, 'Consumo funcionário', '2026-08-17T19:03:56.447066+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (72, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-17T19:09:39.406179+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (73, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-17T19:09:39.406179+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (74, 'saida', 208, 'Soda 200 ML', 1, 'Consumo funcionário', '2026-08-17T19:25:43.806024+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (75, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Consumo funcionário', '2026-08-17T20:15:22.906778+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (67, 'saida', NULL, 'Coxinha (pacotes)', 1, 'Venda balcão - cartao', '2026-08-17T18:54:19.343263+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (76, 'saida', 43, 'Água sem gás', 1, 'Consumo funcionário', '2026-08-17T20:38:32.070523+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (77, 'saida', 242, 'BOLO DE POTE CHOCOLATE', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:09.328404+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (78, 'saida', 213, 'Del Valle Pêssego 290 ML', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:09.328404+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (79, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:09.328404+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (80, 'saida', 242, 'BOLO DE POTE CHOCOLATE', 1, 'Venda balcão - cartao', '2026-08-17T21:02:26.010276+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (81, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:59.433273+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (82, 'saida', 243, 'BOLO DE POTE NINHO', 1, 'Venda balcão - dinheiro', '2026-08-17T21:02:59.433273+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (83, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - cartao', '2026-08-17T21:20:42.813977+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (84, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - cartao', '2026-08-17T21:20:42.813977+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (85, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:20:42.813977+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (86, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - cartao', '2026-08-17T21:20:43.675701+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (87, 'saida', 58, 'Enroladinho de Salsicha', 2, 'Venda balcão - cartao', '2026-08-17T21:20:43.675701+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (88, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:20:43.675701+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (89, 'saida', 54, 'Coxinha de Frango', 4, 'Venda balcão - cartao', '2026-08-17T21:21:19.71121+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (90, 'saida', 86, 'Bala de Hortelã', 4, 'Venda balcão - dinheiro', '2026-08-17T21:22:18.87093+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (91, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:27:19.925875+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (92, 'saida', 198, 'Massa de Pastel', 1, 'Venda (ifood) - dinheiro', '2026-08-17T21:48:19.70545+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (93, 'saida', 198, 'Massa de Pastel', 1, 'Venda (ifood) - dinheiro', '2026-08-17T21:48:41.66292+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (94, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-17T21:49:56.624714+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (95, 'saida', 54, 'Coxinha de Frango', 3, 'Venda balcão - cartao', '2026-08-17T21:49:56.624714+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (96, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-17T21:50:49.402858+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (97, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - dinheiro', '2026-08-17T21:52:58.794246+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (98, 'saida', 83, 'Freegells Choco', 1, 'Venda balcão - dinheiro', '2026-08-17T21:52:58.794246+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (99, 'saida', 73, 'Poosh Verde', 4, 'Venda balcão - dinheiro', '2026-08-18T01:16:28.234888+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (100, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-18T01:16:48.407106+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (101, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - dinheiro', '2026-08-18T01:17:19.399153+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (102, 'saida', 77, 'Poosh Roxo', 2, 'Venda balcão - dinheiro', '2026-08-18T01:17:19.399153+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (103, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-18T01:18:15.76837+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (104, 'saida', 58, 'Enroladinho de Salsicha', 1, 'Venda balcão - cartao', '2026-08-18T01:18:30.98106+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (105, 'saida', 54, 'Coxinha de Frango', 4, 'Venda balcão - dinheiro', '2026-08-18T01:19:16.999688+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (106, 'saida', 86, 'Bala de Hortelã', 4, 'Venda balcão - dinheiro', '2026-08-18T01:19:16.999688+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (107, 'saida', 15, 'Plutonita', 4, 'Venda balcão - cartao', '2026-08-18T01:19:54.176818+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (108, 'saida', 198, 'Massa de Pastel', 2, 'Venda balcão - cartao', '2026-08-18T01:20:15.101857+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (109, 'saida', 15, 'Plutonita', 7, 'Venda balcão - dinheiro', '2026-08-18T01:21:21.023246+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (110, 'saida', 150, 'Coca-Cola Zero Lata', 1, 'Venda balcão - dinheiro', '2026-08-18T01:21:45.119207+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (111, 'saida', 15, 'Plutonita', 7, 'Venda balcão - dinheiro', '2026-08-18T01:22:01.712689+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (112, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - dinheiro', '2026-08-18T01:22:22.053897+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (113, 'saida', 218, 'Bala Azedinha Roxa', 2, 'Venda balcão - dinheiro', '2026-08-18T01:22:22.053897+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (114, 'saida', 247, 'Chocolate quente', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (115, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (116, 'saida', 245, 'Coca Cola lata 350ml', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (117, 'saida', 174, 'Geladinho Açaí', 1, 'Venda balcão - cartao', '2026-08-18T01:25:19.341976+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (118, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - dinheiro', '2026-08-18T01:25:24.958401+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (119, 'saida', 48, 'Skol', 2, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (120, 'saida', 198, 'Massa de Pastel', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (121, 'saida', 214, 'Del Valle Manga 290 ML', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (122, 'saida', 247, 'Chocolate quente', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (123, 'saida', 46, 'Todynho', 1, 'Venda balcão - cartao', '2026-08-18T01:26:23.773735+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (124, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - dinheiro', '2026-08-18T01:29:05.115292+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (125, 'saida', 57, 'Risole de Presunto e Queijo', 2, 'Venda balcão - dinheiro', '2026-08-18T01:30:12.202652+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (126, 'entrada', 82, 'Freegells Menta', 4, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (127, 'entrada', 247, 'Chocolate quente', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (128, 'entrada', 83, 'Freegells Choco', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (129, 'entrada', 244, 'Energetico Bally', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (130, 'entrada', 43, 'Água sem gás', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (131, 'entrada', 78, 'Pirulito Coca', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (132, 'entrada', 174, 'Geladinho Açaí', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (133, 'entrada', 58, 'Enroladinho de Salsicha', 7, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (134, 'entrada', 86, 'Bala de Hortelã', 13, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (135, 'entrada', 213, 'Del Valle Pêssego 290 ML', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (136, 'entrada', 73, 'Poosh Verde', 7, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (137, 'entrada', 15, 'Plutonita', 18, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (138, 'entrada', 53, 'Pastel (Carne+Queijo)', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (139, 'entrada', 57, 'Risole de Presunto e Queijo', 9, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (140, 'entrada', 242, 'BOLO DE POTE CHOCOLATE', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (141, 'entrada', 54, 'Coxinha de Frango', 15, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (142, 'entrada', 243, 'BOLO DE POTE NINHO', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (143, 'entrada', 46, 'Todynho', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (144, 'entrada', 245, 'Coca Cola lata 350ml', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (145, 'entrada', 150, 'Coca-Cola Zero Lata', 4, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (146, 'entrada', 48, 'Skol', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (147, 'entrada', 77, 'Poosh Roxo', 5, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (148, 'entrada', 214, 'Del Valle Manga 290 ML', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (149, 'entrada', 218, 'Bala Azedinha Roxa', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (150, 'entrada', 53, 'Pastel (Presunto e Queijo)', 5, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (151, 'entrada', 209, 'Guaraná 1 Litro', 1, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (152, 'entrada', 88, 'Bola 7', 6, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (153, 'entrada', 53, 'Pastel (Frango)', 2, 'ESTORNO — venda anulada em 17/08/26 22:38', '2026-08-18T01:38:20.372876+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (154, 'saida', 82, 'Freegells Menta', 3, 'Venda balcão - cartao', '2026-08-18T10:43:22.453661+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (155, 'saida', 86, 'Bala de Hortelã', 5, 'Venda balcão - cartao', '2026-08-18T10:43:22.453661+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (156, 'saida', 56, 'Bolinho de Queijo', 1, 'Venda balcão - cartao', '2026-08-18T10:43:32.90909+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (157, 'saida', 43, 'Água sem gás', 1, 'Venda balcão - dinheiro', '2026-08-18T10:43:49.024814+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (158, 'saida', 244, 'Energetico Bally', 1, 'Venda balcão - cartao', '2026-08-18T10:45:17.187763+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (159, 'saida', 82, 'Freegells Menta', 1, 'Venda balcão - dinheiro', '2026-08-18T11:22:25.325369+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (160, 'saida', 73, 'Poosh Verde', 3, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (161, 'saida', 74, 'Poosh Vermelho', 4, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (162, 'saida', 88, 'Bola 7', 7, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (163, 'saida', 78, 'Pirulito Coca', 2, 'Venda balcão - dinheiro', '2026-08-18T11:24:43.105656+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (164, 'saida', 54, 'Coxinha de Frango', 1, 'Venda balcão - cartao', '2026-08-18T11:25:17.345726+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (165, 'saida', 54, 'Coxinha de Frango', 3, 'Venda balcão - cartao', '2026-08-18T11:30:00.237025+00:00');
INSERT INTO movimentacoes (id, tipo, produto_id, produto_nome, qtd, obs, data) VALUES (166, 'saida', 57, 'Risole de Presunto e Queijo', 1, 'Venda balcão - cartao', '2026-08-18T11:30:00.237025+00:00');

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

INSERT INTO caixa (id, troco_inicial, data_abertura, data_fechamento, valor_final, total_vendas_dinheiro, usuario_abertura_id, usuario_fechamento_id) VALUES (13, 55, '2026-08-18T10:41:37.276+00:00', NULL, NULL, NULL, 14, NULL);

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

-- (nenhum registro)

-- Tabela: consumos
CREATE TABLE IF NOT EXISTS consumos (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  total NUMERIC(10,2) NOT NULL DEFAULT 0,
  obs TEXT,
  data TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_consumos_usuario_data ON consumos(usuario_id, data);

INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (7, 5, 8, NULL, '2026-08-17T17:44:20.618398+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (8, 11, 28, NULL, '2026-08-17T19:03:13.475699+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (9, 11, 10, NULL, '2026-08-17T19:03:56.314242+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (10, 14, 4, NULL, '2026-08-17T19:25:43.597161+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (11, 8, 4.5, NULL, '2026-08-17T20:15:22.727809+00:00');
INSERT INTO consumos (id, usuario_id, total, obs, data) VALUES (12, 5, 4, NULL, '2026-08-17T20:38:31.878616+00:00');

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

INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (25, 7, 58, 'Enroladinho de Salsicha', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (26, 7, 54, 'Coxinha de Frango', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (27, 8, 53, 'Pastel (Pizza)', 2, 14, 'Pizza');
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (28, 9, 227, 'Mini Pizza', 2, 5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (29, 10, 208, 'Soda 200 ML', 1, 4, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (30, 11, 58, 'Enroladinho de Salsicha', 1, 4.5, NULL);
INSERT INTO consumo_itens (id, consumo_id, produto_id, produto_nome, qtd, preco_unitario, recheio) VALUES (31, 12, 43, 'Água sem gás', 1, 4, NULL);

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

-- ============================================================
-- Fim do backup
-- ============================================================
