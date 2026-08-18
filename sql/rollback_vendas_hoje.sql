-- ============================================================
-- ROLLBACK: Anular todas as vendas de hoje e devolver estoque
-- Data alvo: hoje (baseado no fuso do banco)
-- 
-- ⚠️  LEIA ANTES DE EXECUTAR:
--   1. Isso deleta permanentemente as vendas de hoje
--   2. Devolve o estoque de todos os itens vendidos hoje
--   3. Não afeta vendas de outros dias
--   4. Recomenda-se fazer um backup antes
--
-- Execute no SQL Editor do Supabase
-- ============================================================

-- Define o início e fim de hoje (UTC-3 Brasil)
-- Ajuste o offset se necessário
DO $$
DECLARE
  inicio_hoje TIMESTAMPTZ := date_trunc('day', NOW() AT TIME ZONE 'America/Sao_Paulo') AT TIME ZONE 'America/Sao_Paulo';
  fim_hoje    TIMESTAMPTZ := inicio_hoje + INTERVAL '1 day';
BEGIN

  RAISE NOTICE 'Rollback de vendas de % até %', inicio_hoje, fim_hoje;
  RAISE NOTICE 'Total de vendas a anular: %', (
    SELECT COUNT(*) FROM vendas WHERE data >= inicio_hoje AND data < fim_hoje
  );

  -- ── PASSO 1: Devolver estoque dos itens de venda ──────────────
  -- Para cada item vendido hoje, soma a qtd de volta no produto
  UPDATE produtos p
  SET qtd = p.qtd + sub.total_vendido
  FROM (
    SELECT vi.produto_id, SUM(vi.qtd) AS total_vendido
    FROM venda_itens vi
    INNER JOIN vendas v ON v.id = vi.venda_id
    WHERE v.data >= inicio_hoje AND v.data < fim_hoje
      AND vi.produto_id IS NOT NULL
    GROUP BY vi.produto_id
  ) sub
  WHERE p.id = sub.produto_id;

  RAISE NOTICE 'Estoque devolvido para % produto(s)', FOUND::int;

  -- ── PASSO 2: Registrar movimentações de estorno ───────────────
  INSERT INTO movimentacoes (tipo, produto_id, produto_nome, qtd, obs, data)
  SELECT 
    'entrada',
    vi.produto_id,
    vi.produto_nome,
    SUM(vi.qtd),
    'ESTORNO — venda anulada em ' || to_char(NOW() AT TIME ZONE 'America/Sao_Paulo', 'DD/MM/YY HH24:MI'),
    NOW()
  FROM venda_itens vi
  INNER JOIN vendas v ON v.id = vi.venda_id
  WHERE v.data >= inicio_hoje AND v.data < fim_hoje
    AND vi.produto_id IS NOT NULL
  GROUP BY vi.produto_id, vi.produto_nome;

  -- ── PASSO 3: Deletar itens das vendas de hoje ─────────────────
  DELETE FROM venda_itens
  WHERE venda_id IN (
    SELECT id FROM vendas
    WHERE data >= inicio_hoje AND data < fim_hoje
  );

  -- ── PASSO 4: Deletar as vendas de hoje ───────────────────────
  DELETE FROM vendas
  WHERE data >= inicio_hoje AND data < fim_hoje;

  RAISE NOTICE 'Concluído. Todas as vendas de hoje foram anuladas e o estoque foi restaurado.';

END $$;
