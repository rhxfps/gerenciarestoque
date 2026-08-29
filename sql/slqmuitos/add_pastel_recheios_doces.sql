-- Adicionar coluna preco na tabela pastel_recheios
ALTER TABLE pastel_recheios ADD COLUMN IF NOT EXISTS preco NUMERIC(10,2);

-- Inserir recheios doces (precisa do id do pastel)
DO $$
DECLARE
  pastel_id INTEGER;
BEGIN
  SELECT id INTO pastel_id FROM produtos WHERE nome ILIKE 'pastel' LIMIT 1;
  IF pastel_id IS NULL THEN RETURN; END IF;

  INSERT INTO pastel_recheios (produto_id, nome, ordem, preco) VALUES
    (pastel_id, 'Nuttella com Morango', 100, 20.00),
    (pastel_id, 'Nuttella',             101, 20.00),
    (pastel_id, 'Romeu e Julieta',      102, 17.00),
    (pastel_id, 'Banana com Canela',    103, 17.00)
  ON CONFLICT (produto_id, nome) DO NOTHING;
END $$;
