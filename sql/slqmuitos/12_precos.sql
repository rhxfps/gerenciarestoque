-- ============================================================
-- Ajuste de preços — agosto 2026
-- Execute no SQL Editor do Supabase
-- ============================================================

UPDATE produtos SET preco = 0.30 WHERE nome ILIKE 'bala azedinha rox%';
UPDATE produtos SET preco = 0.30 WHERE nome ILIKE 'bala caramelo%';
UPDATE produtos SET preco = 0.30 WHERE nome ILIKE 'bala iceriss%';
UPDATE produtos SET preco = 5.00 WHERE nome ILIKE 'mini pizza%';

-- Todos os pirulitos
UPDATE produtos SET preco = 0.50 WHERE nome ILIKE 'pirulito%';

-- Guaraviton
UPDATE produtos SET preco = 7.50 WHERE nome ILIKE 'guaraviton%';

-- Del Valle (todos os sabores)
UPDATE produtos SET preco = 7.50 WHERE nome ILIKE 'del valle%';
