-- ============================================================
-- Permitir excluir usuários que tenham histórico (caixa/vendas/retiradas)
-- Execute no SQL Editor do Supabase:
-- https://supabase.com/dashboard → seu projeto → SQL Editor
-- ============================================================

-- Remove as FKs de usuario_id (de caixa/vendas/caixa_retiradas) que apontam para usuarios
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT c.conrelid::regclass AS tabela, c.conname
    FROM pg_constraint c
    JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
    WHERE c.contype = 'f'
      AND c.confrelid = 'usuarios'::regclass
      AND a.attname = 'usuario_id'
      AND c.conrelid IN ('caixa'::regclass, 'vendas'::regclass, 'caixa_retiradas'::regclass)
  LOOP
    EXECUTE format('ALTER TABLE %s DROP CONSTRAINT %I', r.tabela, r.conname);
  END LOOP;
END $$;

-- Garante que a coluna pode ficar nula (histórico fica, mas sem o usuário excluído)
ALTER TABLE caixa           ALTER COLUMN usuario_id DROP NOT NULL;
ALTER TABLE vendas          ALTER COLUMN usuario_id DROP NOT NULL;
ALTER TABLE caixa_retiradas ALTER COLUMN usuario_id DROP NOT NULL;

-- Recria as FKs como ON DELETE SET NULL (excluir usuário mantém o histórico sem ele)
ALTER TABLE caixa ADD CONSTRAINT caixa_usuario_id_fkey
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL;

ALTER TABLE vendas ADD CONSTRAINT vendas_usuario_id_fkey
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL;

ALTER TABLE caixa_retiradas ADD CONSTRAINT caixa_retiradas_usuario_id_fkey
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL;
