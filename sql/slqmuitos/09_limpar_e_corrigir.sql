-- ============================================================
-- LIMPEZA DEFINITIVA — Remove os produtos antigos/duplicados
-- e aplica preços corretos nos produtos atuais
-- Execute no SQL Editor do Supabase
-- ============================================================

-- ─── PASSO 1: Remover produtos antigos (IDs do seed original) ─
-- Estes foram substituídos pelos novos cadastros do 07_atualizar_estoque
-- (qtd zerada ou incorreta, nomes antigos)

DELETE FROM produtos WHERE id IN (
  2,   -- Fini Uva (substituído por Fini Vermelho/Roxo/Verde Azedo)
  3,   -- Fini Misto
  4,   -- Fini Morango
  5,   -- Fini Laranja
  6,   -- Chup-Chup (manter se ainda vende, mas qtd era 30 fake)
  7,   -- Doce de Leite (qtd fake 30)
  10,  -- Ouro Branco (mantido no 07, mas id 10 tem qtd 4 — OK, checar abaixo)
  12,  -- Pop Kiss (qtd fake 30)
  14,  -- Poosh (genérico — substituído por Poosh Verde/Vermelho/Rosa etc)
  16,  -- Chiclete Bola (qtd fake 30)
  17,  -- Colação (qtd fake 30)
  18,  -- Bola 7 (maçã verde) (qtd fake 30 — novo id 88 tem qtd real 97)
  20,  -- Bala de Goma (qtd fake 30)
  22,  -- Hortelã (substituído por Bala de Hortelã id 86)
  23,  -- Freegells (genérico — substituído por Freegells Menta/Choco/Preto)
  24,  -- Caramelo (Bala) (qtd fake 30)
  25,  -- Paçoca Tradicional (substituído por Paçoca id 66)
  26,  -- Paçoca Chocolate (qtd fake 30)
  27,  -- Pé de Moleque Crocante (qtd fake 30)
  32,  -- Bolo Chocolate (qtd fake 30)
  33,  -- Bolo Ninho (qtd fake 30)
  34,  -- TNT (genérico — substituído por TNT Sport id novo)
  35,  -- Suco (lata) (genérico — substituído por Suco Del Valle Lata)
  36,  -- Coca-Cola 600ml (substituído por Coca-Cola 600 ML)
  37,  -- Coca-Cola lata (qtd fake 30 — substituído por Coca-Cola Zero Lata etc)
  38,  -- Coca-Cola 200ml (substituído por Coca-Cola 200 ML)
  39,  -- Sukita lata (substituído por Sukita Lata)
  40,  -- Tônica lata (substituído por Tônica)
  41,  -- Guaraná Zero lata (substituído por Guaraná Zero Lata)
  42,  -- Fanta Laranja 200ml (substituído por Fanta Laranja 1,5L)
  45,  -- H2OH! (não está na lista nova)
  50   -- Amstel (Cervejas — mover para Bebidas Alcoólicas abaixo)
);

-- ─── PASSO 2: Corrigir Ouro Branco (id 10 já foi deletado, o 07 inseriu novo)
-- Verificar: SELECT id, nome, qtd FROM produtos WHERE nome = 'Ouro Branco';
-- Se aparecer dois, deletar o que tem qtd errada.

-- ─── PASSO 3: Mover Amstel para categoria correta ─────────────
-- Amstel foi deletado acima (era id 50, categoria 'Cervejas')
-- Inserir com categoria certa e preço:
INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco, tipo)
VALUES ('Amstel', 'Bebidas Alcoólicas', 30, 5, 4.50, 'estoque')
ON CONFLICT (nome) DO UPDATE SET categoria = 'Bebidas Alcoólicas', preco = 4.50;

-- ─── PASSO 4: Preços nos produtos novos (IDs 60+) ────────────

-- Doces
UPDATE produtos SET preco = 0.30  WHERE nome = 'Bala Bolete';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Pirulito Bolete';
UPDATE produtos SET preco = 1.00  WHERE nome = 'Chocolate Ki-Kakau';
UPDATE produtos SET preco = 1.50  WHERE nome = 'Fini Vermelho';
UPDATE produtos SET preco = 1.50  WHERE nome = 'Fini Roxo';
UPDATE produtos SET preco = 1.50  WHERE nome = 'Fini Verde Azedo';
UPDATE produtos SET preco = 1.00  WHERE nome = 'Paçoca';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Ouro Branco';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Tortuguita';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Freegells Gum Menta';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Freegells Gum Tutti Frutti';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Freegells Gum Morango';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Plutonita';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Poosh Verde';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Poosh Vermelho';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Poosh Rosa';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Poosh 7 Belo';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Poosh Roxo';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Pirulito Coca';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Pirulito Boca';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Pirulito Coração';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Bala Freegells';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Freegells Menta';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Freegells Choco';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Freegells Preto';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Dadinho';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Bala de Hortelã';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Balinha do Coração';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Bola 7';
UPDATE produtos SET preco = 0.30  WHERE nome = 'Bala Azedinha';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Gluds Ball';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Gomets Tubo';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Geleia de Frutas';
UPDATE produtos SET preco = 0.50  WHERE nome = 'Doces Tony Kelly';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Doce de Abóbora';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Pé de Moça';
UPDATE produtos SET preco = 1.00  WHERE nome = 'Fount de Leite';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Molecão';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Doce de Banana';
-- Mantidos com preço já correto:
-- Ouro Branco = 2.00 ✓ (id 10 deletado, novo inserido via ON CONFLICT acima)
-- Pé de Moça = 2.00 ✓
-- Molecão = 2.00 ✓

-- Bebidas
UPDATE produtos SET preco = 4.50  WHERE nome = 'Água com gás';
UPDATE produtos SET preco = 4.00  WHERE nome = 'Água sem gás';
UPDATE produtos SET preco = 9.00  WHERE nome = 'Coca-Cola 600 ML';
UPDATE produtos SET preco = 2.00  WHERE nome = 'Todynho';
UPDATE produtos SET preco = 7.50  WHERE nome = 'Gatorade';
UPDATE produtos SET preco = 5.00  WHERE nome = 'Energético Furioso 2L';
UPDATE produtos SET preco = 7.00  WHERE nome = 'Fanta Laranja 1,5L';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Guaraná 1,5L';
UPDATE produtos SET preco = 5.00  WHERE nome = 'Tônica';
UPDATE produtos SET preco = 8.00  WHERE nome = 'Guaravita';
UPDATE produtos SET preco = 8.00  WHERE nome = 'TNT Sport';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Suco Del Valle Lata';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Coca-Cola Zero Lata';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Guaraná Zero Lata';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Guaraná Lata';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Sukita Lata';
UPDATE produtos SET preco = 5.00  WHERE nome = 'Água de Coco 200 ML';
UPDATE produtos SET preco = 4.00  WHERE nome = 'Coca-Cola Zero 200 ML';
UPDATE produtos SET preco = 4.00  WHERE nome = 'Coca-Cola 200 ML';
UPDATE produtos SET preco = 8.00  WHERE nome = 'Soda Limonada';
UPDATE produtos SET preco = 6.00  WHERE nome = 'Sprite';

-- Bebidas Alcoólicas
UPDATE produtos SET preco = 5.50  WHERE nome = 'Heineken';
UPDATE produtos SET preco = 10.00 WHERE nome = 'Skol Beats';
UPDATE produtos SET preco = 4.50  WHERE nome = 'Original';
UPDATE produtos SET preco = 4.50  WHERE nome = 'Skol';

-- Geladinhos (preços já definidos no 07)
-- Geladinho Açaí = 7.00 ✓
-- Geladinho Limão = 4.50 ✓
-- Geladinho Coco = 4.50 ✓
-- Geladinho Maracujá = 2.00 ✓
-- Geladinho Morango = 2.00 ✓

-- ─── PASSO 5: Verificação final ──────────────────────────────
-- Rode após executar:
-- SELECT nome, categoria, qtd, preco FROM produtos ORDER BY categoria, nome;
