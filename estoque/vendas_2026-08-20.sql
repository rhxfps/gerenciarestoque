-- ============================================================
-- Vendas Exportadas - GerenciarStock
-- Data: 20/08/2026, 14:49:15
-- Filtros: hoje
-- Vendas: 27
-- ============================================================

-- Inserir vendas
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (210, 2.1, 'dinheiro', false, NULL, '', '2026-08-20T16:21:43.342Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (209, 1.05, 'dinheiro', false, NULL, '', '2026-08-20T16:01:26.594Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (208, 4, 'cartao', false, NULL, '', '2026-08-20T16:00:56.988Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (207, 30.5, 'cartao', false, NULL, '', '2026-08-20T16:00:38.922Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (206, 4, 'pix', false, NULL, '', '2026-08-20T15:57:58.927Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (205, 19, 'dinheiro', false, NULL, '', '2026-08-20T15:57:08.449Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (204, 1.4, 'dinheiro', false, NULL, '', '2026-08-20T15:53:21.140Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (203, 11, 'dinheiro', false, NULL, '', '2026-08-20T15:48:35.530Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (202, 0.7, 'pix', false, NULL, 'pix da eliane', '2026-08-20T15:45:48.698Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (201, 4.5, 'cartao', false, NULL, '', '2026-08-20T15:38:00.505Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (200, 18, 'cartao', false, NULL, '', '2026-08-20T15:37:46.272Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (199, 2, 'dinheiro', false, NULL, '', '2026-08-20T15:34:37.904Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (198, 3.85, 'cartao', false, NULL, '', '2026-08-20T15:31:02.057Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (197, 9, 'dinheiro', false, NULL, '', '2026-08-20T15:29:25.641Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (196, 0.5, 'pix', false, NULL, '', '2026-08-20T15:27:49.383Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (195, 3, 'cartao', false, NULL, '', '2026-08-20T15:22:21.765Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (194, 9, 'cartao', false, NULL, '', '2026-08-20T15:21:26.093Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (193, 1.4, 'pix', false, NULL, '', '2026-08-20T14:53:22.132Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (192, 4, 'pix', false, NULL, '', '2026-08-20T13:09:09.648Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (191, 4.5, 'dinheiro', false, NULL, '', '2026-08-20T13:06:40.051Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (190, 4.9, 'dinheiro', false, NULL, '', '2026-08-20T11:24:35.248Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (189, 5.05, 'cartao', false, NULL, '', '2026-08-20T10:12:32.326Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (188, 2, 'cartao', false, NULL, '', '2026-08-20T10:11:38.010Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (187, 6, 'dinheiro', false, NULL, '', '2026-08-20T10:11:22.544Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (186, 2, 'cartao', false, NULL, '', '2026-08-20T10:11:09.212Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (185, 2.5, 'pix', false, NULL, '', '2026-08-20T10:10:43.401Z', 14);
INSERT INTO vendas (id, total, pagamento, delivery, plataforma, obs, data, usuario_id)
VALUES (184, 6, 'cartao', false, NULL, '', '2026-08-20T10:10:24.787Z', 14);

-- Inserir itens das vendas
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (210, 60, 'Bala Bolete', 6, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (209, 75, 'Pooshs', 3, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (208, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (207, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (207, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (207, 227, 'Mini Pizza', 4, 5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (206, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (205, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (205, 248, 'Mini Pastel (Presunto e Queijo)', 2, 5, 'Presunto e Queijo');
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (204, 75, 'Pooshs', 4, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (203, 257, 'ENERG TNT MAÇA VERDE 473ml', 1, 9, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (203, 246, 'Chup-chup', 2, 1, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (202, 75, 'Pooshs', 2, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (201, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (200, 248, 'Mini Pastel (Queijo)', 1, 5, 'Queijo');
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (200, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (200, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (200, 156, 'Coca-Cola 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (199, 78, 'Pirulito Coca', 4, 0.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (198, 75, 'Pooshs', 11, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (197, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (197, 56, 'Bolinho de Queijo', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (196, 78, 'Pirulito Coca', 1, 0.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (195, 88, 'Bola 7', 10, 0.3, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (194, 54, 'Coxinha de Frango', 2, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (193, 75, 'Pooshs', 4, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (192, 206, 'Sprite 200 ML', 1, 4, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (191, 54, 'Coxinha de Frango', 1, 4.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (190, 87, 'Balinha do Coração', 14, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (189, 78, 'Pirulito Coca', 4, 0.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (189, 225, 'Pirulito Boca Cereja', 4, 0.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (189, 221, 'Bala Iceriss', 3, 0.35, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (188, 82, 'Freegells Menta', 1, 2, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (187, 245, 'Coca Cola lata 350ml', 1, 6, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (186, 225, 'Pirulito Boca Cereja', 4, 0.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (185, 69, 'Freegells Gum Menta', 1, 2.5, NULL);
INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario, recheio)
VALUES (184, 255, 'ouro branco', 3, 2, NULL);

-- ============================================================
-- Fim da exportação
-- ============================================================
