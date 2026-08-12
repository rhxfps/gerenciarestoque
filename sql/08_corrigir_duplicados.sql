-- ============================================================
-- Corrigir duplicados no estoque — Agosto 2026
-- Execute no SQL Editor do Supabase
-- Cada bloco: 1) soma qtd no produto que fica, 2) deleta o redundante
-- ============================================================

-- ─── ÁGUA SEM GÁS / ÁGUA NORMAL ──────────────────────────────
-- Manter: "Água sem gás" (tem preço R$4,00)
-- Remover: "Água Normal" (19 un — somar)
UPDATE produtos
SET qtd = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Água Normal'), 0)
WHERE nome = 'Água sem gás';
DELETE FROM produtos WHERE nome = 'Água Normal';

-- ─── ÁGUA COM GÁS (capitalização dupla) ──────────────────────
-- Manter: "Água com gás" (tem preço R$4,50)
-- Remover: "Água com Gás" (sem preço, qtd 0)
UPDATE produtos
SET qtd = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Água com Gás'), 0)
WHERE nome = 'Água com gás';
DELETE FROM produtos WHERE nome = 'Água com Gás';

-- ─── BOLETE BALA ─────────────────────────────────────────────
-- Manter: "Bala Bolete" (79 un — novo cadastro)
-- Remover: "Bolete (Bala)" (antigo, qtd somada já)
UPDATE produtos
SET qtd = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Bolete (Bala)'), 0)
WHERE nome = 'Bala Bolete';
DELETE FROM produtos WHERE nome = 'Bolete (Bala)';

-- ─── BOLETE PIRULITO ─────────────────────────────────────────
-- Manter: "Pirulito Bolete" (6 un — novo cadastro)
-- Remover: "Bolete (Pirulito)" (antigo)
UPDATE produtos
SET qtd = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Bolete (Pirulito)'), 0)
WHERE nome = 'Pirulito Bolete';
DELETE FROM produtos WHERE nome = 'Bolete (Pirulito)';

-- ─── AZEDINHA / BALA AZEDINHA ────────────────────────────────
-- Manter: "Bala Azedinha" (44 un — novo)
-- Remover: "Azedinha (uva)" (antigo, R$0,30 — transferir preço)
UPDATE produtos
SET qtd   = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Azedinha (uva)'), 0),
    preco = CASE WHEN preco = 0 THEN COALESCE((SELECT preco FROM produtos WHERE nome = 'Azedinha (uva)'), 0) ELSE preco END
WHERE nome = 'Bala Azedinha';
DELETE FROM produtos WHERE nome = 'Azedinha (uva)';

-- ─── PIRULITO CORAÇÃO / FLOPITO ──────────────────────────────
-- Manter: "Pirulito Coração" (24 un — novo)
-- Remover: "Flopito (coração)" (antigo)
UPDATE produtos
SET qtd = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Flopito (coração)'), 0)
WHERE nome = 'Pirulito Coração';
DELETE FROM produtos WHERE nome = 'Flopito (coração)';

-- ─── BOLA 7 / BOLA 7 (MAÇÃ VERDE) ───────────────────────────
-- São sabores diferentes? Se sim, deixe comentado.
-- Se for o mesmo produto, descomente:
-- UPDATE produtos SET qtd = qtd + COALESCE((SELECT qtd FROM produtos WHERE nome = 'Bola 7 (maçã verde)'), 0)
-- WHERE nome = 'Bola 7';
-- DELETE FROM produtos WHERE nome = 'Bola 7 (maçã verde)';
-- Por ora: manter os dois (sabores distintos).

-- ─── BALA DE GOMA (possível duplicado de Gomets/Gluds) ───────
-- "Bala de Goma" parece ser produto único — manter.

-- ─── DOCE DE LEITE (possível duplicado) ──────────────────────
-- Verificar se existe duplicado:
-- SELECT nome, qtd FROM produtos WHERE nome ILIKE '%doce%leite%';
-- Se houver, rodar:
-- UPDATE produtos SET qtd = qtd + X WHERE nome = 'Doce de Leite';
-- DELETE FROM produtos WHERE nome = 'doce de leite antigo';

-- ─── CAPITALIZAÇÃO: padronizar nomes ─────────────────────────
-- "Água de Coco 200 ML" já está correto no novo cadastro
-- Remover possível duplicado com capitalização diferente:
DELETE FROM produtos
WHERE LOWER(TRIM(nome)) = 'água de coco 200 ml'
  AND nome != 'Água de Coco 200 ML';

-- ─── VERIFICAÇÃO FINAL ───────────────────────────────────────
-- Após executar, rode esta query para ver todos os produtos em ordem:
-- SELECT id, nome, categoria, qtd, preco FROM produtos ORDER BY nome;
