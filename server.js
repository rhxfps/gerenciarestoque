require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { createClient } = require('@supabase/supabase-js');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'seu-segredo-jwt-muito-seguro-123';

// Configurar Supabase (você precisa colocar suas credenciais aqui!
const SUPABASE_URL = process.env.SUPABASE_URL || 'SEU_SUPABASE_URL';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY || 'SEU_SUPABASE_SERVICE_KEY';
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// Serve the HTML file as the default route
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ==================== USUÁRIOS / AUTENTICAÇÃO ====================
app.post('/api/auth/login', async (req, res) => {
  const { usuario, senha } = req.body;
  if (!usuario || !senha) {
    return res.status(400).json({ error: 'Informe usuário e senha' });
  }

  try {
    const { data, error } = await supabase
      .from('usuarios')
      .select('*')
      .eq('usuario', usuario)
      .single();

    if (error || !data) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const senhaValida = await bcrypt.compare(senha, data.senha);
    if (!senhaValida) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const token = jwt.sign({ id: data.id, usuario: data.usuario, role: data.role }, JWT_SECRET, { expiresIn: '24h' });
    res.json({ token, usuario: { id: data.id, nome: data.nome, usuario: data.usuario, role: data.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.post('/api/usuarios', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { nome, usuario, senha, role } = req.body;
  if (!nome || !usuario || !senha) {
    return res.status(400).json({ error: 'Informe nome, usuário e senha' });
  }

  const senhaHash = await bcrypt.hash(senha, 10);

  try {
    const { data, error } = await supabase
      .from('usuarios')
      .insert([{ nome, usuario, senha: senhaHash, role }])
      .select()
      .single();

    if (error) {
      if (error.code === '23505') {
        return res.status(400).json({ error: 'Usuário já cadastrado' });
      }
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/usuarios', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    const { data, error } = await supabase
      .from('usuarios')
      .select('id, nome, usuario, role');
    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.delete('/api/usuarios/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { id } = req.params;
  if (parseInt(id) === req.usuario.id) {
    return res.status(400).json({ error: 'Você não pode deletar seu próprio usuário' });
  }

  try {
    const { error } = await supabase
      .from('usuarios')
      .delete()
      .eq('id', id);

    if (error) throw error;
    res.json({ deleted: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/api/usuarios/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { id } = req.params;
  const { nome, usuario, senha, role } = req.body;
  if (!nome || !usuario) {
    return res.status(400).json({ error: 'Nome e usuário são obrigatórios' });
  }

  try {
    let updateData = { nome, usuario, role };

    if (senha) {
      const senhaHash = await bcrypt.hash(senha, 10);
      updateData.senha = senhaHash;
    }

    const { data, error } = await supabase
      .from('usuarios')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==================== PRODUTOS ====================
app.get('/api/produtos', autenticar, async (req, res) => {
  try {
    const { data, error } = await supabase.from('produtos').select('*');
    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.post('/api/produtos', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { nome, categoria, qtd, qtd_minima, preco } = req.body;
  try {
    const { data, error } = await supabase
      .from('produtos')
      .insert([{ nome, categoria, qtd: qtd || 0, qtd_minima: qtd_minima || 0, preco: preco || 0 }])
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.delete('/api/produtos/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { id } = req.params;
  try {
    const { error } = await supabase
      .from('produtos')
      .delete()
      .eq('id', id);
    if (error) throw error;
    res.json({ deleted: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== MOVIMENTAÇÕES ====================
app.get('/api/movimentacoes', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    const { data, error } = await supabase
      .from('movimentacoes')
      .select('*')
      .order('data', { ascending: false });
    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.post('/api/movimentacoes', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { tipo, produto_id, produto_nome, qtd, obs } = req.body;

  try {
    // Inserir movimentação
    const { data: movimentacao, error: movError } = await supabase
      .from('movimentacoes')
      .insert([{ tipo, produto_id, produto_nome, qtd, obs }])
      .select()
      .single();
    if (movError) throw movError;

    // Atualizar estoque
    const { data: produtoAtual } = await supabase
      .from('produtos')
      .select('qtd')
      .eq('id', produto_id)
      .single();

    let novaQtd;
    if (tipo === 'entrada') {
      novaQtd = produtoAtual.qtd + qtd;
    } else {
      novaQtd = produtoAtual.qtd - qtd;
    }

    await supabase
      .from('produtos')
      .update({ qtd: novaQtd })
      .eq('id', produto_id);

    res.json(movimentacao);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== VENDAS ====================
app.get('/api/vendas', autenticar, async (req, res) => {
  try {
    const { data: vendas, error: vendasError } = await supabase
      .from('vendas')
      .select('*')
      .order('data', { ascending: false });
    if (vendasError) throw vendasError;

    const vendasComItens = [];
    for (const venda of vendas) {
      const { data: itens, error: itensError } = await supabase
        .from('venda_itens')
        .select('*')
        .eq('venda_id', venda.id);
      if (itensError) console.error(itensError);
      vendasComItens.push({ ...venda, itens: itens || [] });
    }

    res.json(vendasComItens);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/vendas', autenticar, async (req, res) => {
  const { itens, total, pagamento, delivery, plataforma, obs } = req.body;

  try {
    // Inserir venda
    const { data: venda, error: vendaError } = await supabase
      .from('vendas')
      .insert([{ total, pagamento, delivery, plataforma, obs }])
      .select()
      .single();
    if (vendaError) throw vendaError;

    // Inserir itens de venda, atualizar estoque e adicionar movimentações
    for (const item of itens) {
      // Inserir item
      await supabase
        .from('venda_itens')
        .insert([{ venda_id: venda.id, produto_id: item.produtoId, produto_nome: item.produtoNome, qtd: item.qtd, preco_unitario: item.precoUnitario }]);

      // Atualizar estoque
      const { data: produtoAtual } = await supabase
        .from('produtos')
        .select('qtd')
        .eq('id', item.produtoId)
        .single();
      await supabase
        .from('produtos')
        .update({ qtd: produtoAtual.qtd - item.qtd })
        .eq('id', item.produtoId);

      // Inserir movimentação de saída
      await supabase
        .from('movimentacoes')
        .insert([{ tipo: 'saida', produto_id: item.produtoId, produto_nome: item.produtoNome, qtd: item.qtd, obs: `Venda ${delivery ? `(${plataforma || ''})` : 'balcão'} - ${pagamento}` }]);
    }

    res.json({ ...venda, itens });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== MIDDLEWARE DE AUTENTICAÇÃO ====================
function autenticar(req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token não fornecido' });
  }

  jwt.verify(token, JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(403).json({ error: 'Token inválido' });
    }
    req.usuario = decoded;
    next();
  });
}

const criarUsuarioPadrao = async () => {
  try {
    // Verificar se o usuário admin já existe
    const { data: usuarioExistente, error } = await supabase
      .from('usuarios')
      .select('id')
      .eq('usuario', 'admin')
      .single();

    if (!usuarioExistente) {
      const senhaHash = await bcrypt.hash('admin123', 10);
      await supabase.from('usuarios').insert([{
        nome: 'Administrador',
        usuario: 'admin',
        senha: senhaHash,
        role: 'dono'
      }]);
      console.log('Usuário admin criado com sucesso!');
    }
  } catch (err) {
    console.error('Erro ao criar usuário padrão:', err);
  }
};

criarUsuarioPadrao();

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse o site em http://localhost:${PORT}`);
  console.log('\nUsuário padrão:');
  console.log('Usuário: admin');
  console.log('Senha: admin123');
  console.log('Role: Dono');
});
