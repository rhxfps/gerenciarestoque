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
      .select('id, usuario, senha, nome, role')
      .eq('usuario', usuario)
      .maybeSingle();

    if (error) {
      console.error('Erro no login (consulta):', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }

    if (!data) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    let senhaValida = false;
    try {
      senhaValida = await bcrypt.compare(senha, data.senha);
    } catch (e) {
      console.error('Erro ao comparar senha:', e.message);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }

    if (!senhaValida) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const token = jwt.sign({ id: data.id, usuario: data.usuario, role: data.role }, JWT_SECRET, { expiresIn: '24h' });
    res.json({ token, usuario: { id: data.id, nome: data.nome, usuario: data.usuario, role: data.role } });
  } catch (err) {
    console.error('Login error:', err);
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
    // Limpa referências do usuário para a exclusão não quebrar por chave estrangeira
    const limpeza = [
      supabase.from('consumo').delete().eq('usuario_id', id),
      supabase.from('caixa').update({ usuario_abertura_id: null }).eq('usuario_abertura_id', id),
      supabase.from('caixa').update({ usuario_fechamento_id: null }).eq('usuario_fechamento_id', id),
      supabase.from('caixa_retiradas').update({ usuario_id: null }).eq('usuario_id', id),
    ];
    await Promise.all(limpeza.map(p => Promise.resolve(p).catch(() => null)));

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

app.put('/api/produtos/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  const { id } = req.params;
  const { nome, categoria, qtd, qtd_minima, preco } = req.body;

  try {
    const { data, error } = await supabase
      .from('produtos')
      .update({ nome, categoria, qtd, qtd_minima, preco })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
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

// ==================== PASTEL ====================
app.get('/api/pastel/recheios', autenticar, async (req, res) => {
  try {
    const { data: pastel, error: pastelError } = await supabase
      .from('produtos')
      .select('id, preco, nome, tipo')
      .eq('nome', 'Pastel')
      .maybeSingle();

    if (pastelError) throw pastelError;

    if (!pastel) {
      return res.json({ produtoId: null, preco: 14, recheios: [] });
    }

    const { data: recheios, error: recheiosError } = await supabase
      .from('pastel_recheios')
      .select('id, nome, ordem')
      .eq('produto_id', pastel.id)
      .order('ordem');

    if (recheiosError) {
      return res.json({ produtoId: pastel.id, preco: pastel.preco || 14, recheios: [] });
    }

    res.json({
      produtoId: pastel.id,
      preco: pastel.preco || 14,
      recheios: recheios || []
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== AÇAÍ ====================
app.get('/api/acai', autenticar, async (req, res) => {
  try {
    const { data: tamanhos, error: tError } = await supabase
      .from('produtos')
      .select('id, nome, preco, qtd, tipo')
      .eq('categoria', 'Açaí')
      .order('preco');

    if (tError) throw tError;

    const { data: complementos, error: cError } = await supabase
      .from('acai_complementos')
      .select('id, nome, preco, ordem')
      .order('ordem');

    if (cError) throw cError;

    res.json({ tamanhos: tamanhos || [], complementos: complementos || [] });
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
// Baixa de estoque otimizada: busca produtos e copos de açaí em poucas
// consultas e executa atualizações + movimentações em paralelo/lote.
async function baixarEstoqueItens(itens, obs) {
  // Produtos dos itens em UMA consulta
  const ids = [...new Set(itens.map(i => i.produtoId))];
  const estoqueMap = new Map();
  if (ids.length) {
    const { data: prods } = await supabase
      .from('produtos')
      .select('id, qtd, tipo, nome, categoria')
      .in('id', ids);
    for (const p of prods || []) estoqueMap.set(p.id, p);
  }

  // Itens de açaí → copos (embalagens) correspondentes
  const acaiPorProduto = new Map(); // produtoId -> ml
  for (const item of itens) {
    const nome = String(item.produtoNome || '').toLowerCase();
    if (!nome.startsWith('açaí') && !nome.startsWith('acai')) continue;
    const m = nome.match(/(\d+)\s*ml/);
    if (m) acaiPorProduto.set(item.produtoId, m[1]);
  }

  const copoPorMl = new Map(); // ml -> produto copo
  if (acaiPorProduto.size) {
    const { data: copos } = await supabase
      .from('produtos')
      .select('id, qtd, nome, tipo, categoria')
      .ilike('nome', 'copo %ml');
    for (const c of copos || []) {
      const m = c.nome.toLowerCase().match(/^copo\s+(\d+)/);
      if (m && !copoPorMl.has(m[1])) {
        copoPorMl.set(m[1], c);
        estoqueMap.set(c.id, c);
      }
    }
  }

  // Agregar deduções por produto (evita corrida e consultas repetidas)
  const deducoes = new Map(); // id -> { qtd, nome }

  // Buscar "Massa de Pastel" para baixar estoque a cada pastel vendido
  const { data: massaProd } = await supabase
    .from('produtos')
    .select('id, qtd')
    .ilike('nome', 'massa de pastel')
    .limit(1)
    .maybeSingle();
  if (massaProd) estoqueMap.set(massaProd.id, { ...massaProd, nome: 'Massa de Pastel' });

  for (const item of itens) {
    const p = estoqueMap.get(item.produtoId);
    const isPastel = item.recheio || p?.tipo === 'pastel' ||
      (p?.nome && p.nome.toLowerCase() === 'pastel');
    const isAcai = p?.categoria === 'Açaí' || p?.tipo === 'acai';

    let idAlvo = null;
    if (p && !isPastel && !isAcai) {
      idAlvo = item.produtoId;
    } else {
      const ml = acaiPorProduto.get(item.produtoId);
      const copo = ml ? copoPorMl.get(ml) : null;
      if (copo) idAlvo = copo.id;
    }

    if (idAlvo != null) {
      const d = deducoes.get(idAlvo) || { qtd: 0, nome: p ? p.nome : item.produtoNome };
      d.qtd += item.qtd;
      deducoes.set(idAlvo, d);
    }

    // Cada pastel desconta 1 unidade de Massa de Pastel
    if (isPastel && massaProd) {
      const dm = deducoes.get(massaProd.id) || { qtd: 0, nome: 'Massa de Pastel' };
      dm.qtd += item.qtd;
      deducoes.set(massaProd.id, dm);
    }
  }

  // Atualizar estoques e registrar movimentações em paralelo (lote)
  const ops = [];
  const movimentacoes = [];
  for (const [id, d] of deducoes) {
    const base = estoqueMap.get(id);
    ops.push(supabase
      .from('produtos')
      .update({ qtd: Math.max(parseFloat(base?.qtd || 0) - d.qtd, 0) })
      .eq('id', id));
    movimentacoes.push({ tipo: 'saida', produto_id: id, produto_nome: d.nome, qtd: d.qtd, obs });
  }
  if (movimentacoes.length) {
    ops.push(supabase.from('movimentacoes').insert(movimentacoes));
  }
  await Promise.all(ops);
}

app.get('/api/vendas', autenticar, async (req, res) => {
  try {
    const { data: vendas, error: vendasError } = await supabase
      .from('vendas')
      .select('*')
      .order('data', { ascending: false });
    if (vendasError) throw vendasError;

    // Itens de todas as vendas em UMA consulta (evita N+1)
    const ids = (vendas || []).map(v => v.id);
    const itensPorVenda = new Map();
    if (ids.length) {
      const { data: itens, error: itensError } = await supabase
        .from('venda_itens')
        .select('*')
        .in('venda_id', ids);
      if (itensError) throw itensError;
      for (const it of itens || []) {
        const arr = itensPorVenda.get(it.venda_id) || [];
        arr.push(it);
        itensPorVenda.set(it.venda_id, arr);
      }
    }

    res.json((vendas || []).map(v => ({ ...v, itens: itensPorVenda.get(v.id) || [] })));
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
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

    // Inserir todos os itens de venda em lote
    const itensData = itens.map(item => ({
      venda_id: venda.id,
      produto_id: item.produtoId,
      produto_nome: item.produtoNome,
      qtd: item.qtd,
      preco_unitario: item.precoUnitario,
      ...(item.recheio ? { recheio: item.recheio } : {})
    }));
    const { error: itensError } = await supabase.from('venda_itens').insert(itensData);
    if (itensError) throw itensError;

    // Baixar estoque + copos de açaí + movimentações de forma otimizada
    const obsVenda = `Venda ${delivery ? `(${plataforma || ''})` : 'balcão'} - ${pagamento}`;
    await baixarEstoqueItens(itens, obsVenda);

    res.json({ ...venda, itens });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== CONSUMO (funcionários) ====================
const LIMITE_CONSUMO_MENSAL = 50;

function inicioDoMesLocal(agora = new Date()) {
  return new Date(agora.getFullYear(), agora.getMonth(), 1);
}

app.get('/api/consumo', autenticar, async (req, res) => {
  try {
    const agora = new Date();
    const inicio = inicioDoMesLocal(agora);

    const { data: consumos, error } = await supabase
      .from('consumos')
      .select('*, consumo_itens(*)')
      .eq('usuario_id', req.usuario.id)
      .gte('data', inicio.toISOString())
      .lte('data', agora.toISOString())
      .order('data', { ascending: false });

    if (error) throw error;

    const consumosComItens = (consumos || []).map(c => ({ ...c, itens: c.consumo_itens || [] }));

    const totalMes = (consumos || []).reduce((s, c) => s + parseFloat(c.total || 0), 0);

    res.json({ consumos: consumosComItens, totalMes });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/consumo', autenticar, async (req, res) => {
  if (req.usuario.role !== 'funcionario' && req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { itens, obs, usuario_id } = req.body;

  if (!itens || !Array.isArray(itens) || !itens.length) {
    return res.status(400).json({ error: 'Adicione pelo menos um item' });
  }

  // Quem consumiu (padrão: o próprio usuário logado)
  let consumidorId = req.usuario.id;
  let consumidorRole = req.usuario.role;
  if (usuario_id) {
    const { data: alvo, error: alvoError } = await supabase
      .from('usuarios')
      .select('id, role')
      .eq('id', usuario_id)
      .single();

    if (alvoError || !alvo || !['funcionario', 'dono'].includes(alvo.role)) {
      return res.status(400).json({ error: 'Usuário inválido para consumo' });
    }
    consumidorId = alvo.id;
    consumidorRole = alvo.role;
  }

  const total = itens.reduce((s, i) => s + (parseFloat(i.qtd || 0) * parseFloat(i.precoUnitario || 0)), 0);

  try {
    // Verificar limite mensal do usuário que consumiu (donos não têm limite)
    const inicio = inicioDoMesLocal();
    const { data: consumosMes } = await supabase
      .from('consumos')
      .select('total')
      .eq('usuario_id', consumidorId)
      .gte('data', inicio.toISOString());

    const jaUsado = (consumosMes || []).reduce((s, c) => s + parseFloat(c.total || 0), 0);
    const acimaLimite = consumidorRole === 'funcionario' && (jaUsado + total > LIMITE_CONSUMO_MENSAL);

    // Inserir consumo
    const { data: consumo, error: consumoError } = await supabase
      .from('consumos')
      .insert([{ usuario_id: consumidorId, total, obs: obs || null }])
      .select()
      .single();
    if (consumoError) throw consumoError;

    // Inserir todos os itens de consumo em lote
    const itensData = itens.map(item => ({
      consumo_id: consumo.id,
      produto_id: item.produtoId,
      produto_nome: item.produtoNome,
      qtd: item.qtd,
      preco_unitario: item.precoUnitario,
      ...(item.recheio ? { recheio: item.recheio } : {})
    }));
    const { error: itensError } = await supabase.from('consumo_itens').insert(itensData);
    if (itensError) throw itensError;

    // Baixar estoque + copos de açaí + movimentações de forma otimizada
    await baixarEstoqueItens(itens, 'Consumo funcionário');

    res.json({ ...consumo, itens, acimaLimite });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/consumo/usuarios', autenticar, async (req, res) => {
  if (req.usuario.role !== 'funcionario' && req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    const { data: funcionarios, error } = await supabase
      .from('usuarios')
      .select('id, nome, usuario')
      .in('role', ['funcionario', 'dono'])
      .order('nome');

    if (error) throw error;

    res.json(funcionarios || []);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/consumo/funcionarios', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    const agora = new Date();
    const inicio = inicioDoMesLocal(agora);

    const { data: funcionarios, error: funcError } = await supabase
      .from('usuarios')
      .select('id, nome, usuario, role')
      .in('role', ['funcionario', 'dono'])
      .order('nome');

    if (funcError) throw funcError;

    if (!funcionarios?.length) return res.json([]);

    const funcIds = funcionarios.map(f => f.id);

    // Consumos de todos os funcionários em UMA consulta
    const { data: consumos, error: consError } = await supabase
      .from('consumos')
      .select('*')
      .in('usuario_id', funcIds)
      .gte('data', inicio.toISOString())
      .lte('data', agora.toISOString())
      .order('data', { ascending: false });

    if (consError) throw consError;

    // Itens de todos os consumos em UMA consulta
    const consumoIds = [...new Set((consumos || []).map(c => c.id))];
    const itensPorConsumo = new Map();
    if (consumoIds.length) {
      const { data: itens, error: itensError } = await supabase
        .from('consumo_itens')
        .select('*')
        .in('consumo_id', consumoIds);
      if (itensError) throw itensError;
      for (const it of itens || []) {
        const arr = itensPorConsumo.get(it.consumo_id) || [];
        arr.push(it);
        itensPorConsumo.set(it.consumo_id, arr);
      }
    }

    const consumosPorFunc = new Map();
    for (const c of consumos || []) {
      const arr = consumosPorFunc.get(c.usuario_id) || [];
      arr.push({ ...c, itens: itensPorConsumo.get(c.id) || [] });
      consumosPorFunc.set(c.usuario_id, arr);
    }

    const resultado = [];
    for (const f of funcionarios || []) {
      const cs = consumosPorFunc.get(f.id) || [];
      const totalMes = cs.reduce((s, c) => s + parseFloat(c.total || 0), 0);
      resultado.push({ ...f, totalMes, consumos: cs });
    }

    res.json(resultado);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== CONSUMO ADMIN (ajustes do dono) ====================
// Adicionar itens ao consumo de um usuário (sem baixar estoque)
app.post('/api/consumo/admin', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { itens, obs, usuario_id } = req.body;

  if (!usuario_id) return res.status(400).json({ error: 'Informe o usuário' });
  if (!itens || !Array.isArray(itens) || !itens.length) {
    return res.status(400).json({ error: 'Adicione pelo menos um item' });
  }

  try {
    const { data: alvo, error: alvoError } = await supabase
      .from('usuarios')
      .select('id, role')
      .eq('id', usuario_id)
      .single();

    if (alvoError || !alvo || !['funcionario', 'dono'].includes(alvo.role)) {
      return res.status(400).json({ error: 'Usuário inválido para consumo' });
    }

    const total = itens.reduce((s, i) => s + (parseFloat(i.qtd || 0) * parseFloat(i.precoUnitario || 0)), 0);

    const { data: consumo, error: consumoError } = await supabase
      .from('consumos')
      .insert([{ usuario_id, total, obs: obs || null }])
      .select()
      .single();
    if (consumoError) throw consumoError;

    const itensData = itens.map(item => ({
      consumo_id: consumo.id,
      produto_id: item.produtoId,
      produto_nome: item.produtoNome,
      qtd: item.qtd,
      preco_unitario: item.precoUnitario,
      ...(item.recheio ? { recheio: item.recheio } : {})
    }));
    const { error: itensError } = await supabase.from('consumo_itens').insert(itensData);
    if (itensError) throw itensError;

    res.json({ ...consumo, itens });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Remover um item específico do consumo (recalcula o total; apaga o consumo se não restarem itens)
app.delete('/api/consumo/admin/item/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    const { data: item, error: itemError } = await supabase
      .from('consumo_itens')
      .select('*')
      .eq('id', req.params.id)
      .single();
    if (itemError) return res.status(404).json({ error: 'Item não encontrado' });

    const { error: delError } = await supabase.from('consumo_itens').delete().eq('id', req.params.id);
    if (delError) throw delError;

    // Verificar se ainda restam itens
    const { data: restantes } = await supabase
      .from('consumo_itens')
      .select('id')
      .eq('consumo_id', item.consumo_id);

    if (!restantes || !restantes.length) {
      await supabase.from('consumos').delete().eq('id', item.consumo_id);
    } else {
      const { data: itensRestantes } = await supabase
        .from('consumo_itens')
        .select('qtd, preco_unitario')
        .eq('consumo_id', item.consumo_id);
      const novoTotal = (itensRestantes || []).reduce((s, i) => s + parseFloat(i.qtd) * parseFloat(i.preco_unitario), 0);
      await supabase.from('consumos').update({ total: novoTotal }).eq('id', item.consumo_id);
    }

    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Remover um consumo inteiro (com todos os itens)
app.delete('/api/consumo/admin/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    await supabase.from('consumo_itens').delete().eq('consumo_id', req.params.id);
    await supabase.from('consumos').delete().eq('id', req.params.id);
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Zerar todo o consumo do usuário no mês atual
app.delete('/api/consumo/admin/zerar/:usuarioId', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  try {
    const inicio = inicioDoMesLocal();
    const { data: consumos } = await supabase
      .from('consumos')
      .select('id')
      .eq('usuario_id', req.params.usuarioId)
      .gte('data', inicio.toISOString());

    const ids = (consumos || []).map(c => c.id);
    if (ids.length) {
      await supabase.from('consumo_itens').delete().in('consumo_id', ids);
      await supabase.from('consumos').delete().in('id', ids);
    }

    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== CAIXA ====================
app.get('/api/caixa', autenticar, async (req, res) => {
  try {
    // Buscar último caixa aberto/fechado com dados de usuário
    const { data: ultimoCaixa, error: errorCaixa } = await supabase
      .from('caixa')
      .select(`
        *,
        usuario_abertura:usuario_abertura_id (nome),
        usuario_fechamento:usuario_fechamento_id (nome)
      `)
      .order('data_abertura', { ascending: false })
      .limit(1)
      .single();
    
    // Buscar histórico de caixas fechados com dados de usuário
    const { data: historicoCaixa, error: errorHistorico } = await supabase
      .from('caixa')
      .select(`
        *,
        usuario_abertura:usuario_abertura_id (nome),
        usuario_fechamento:usuario_fechamento_id (nome),
        caixa_retiradas (id, valor, motivo, data, usuario:usuario_id(nome))
      `)
      .not('data_fechamento', 'is', null)
      .order('data_fechamento', { ascending: false })
      .limit(10);
    
    if (errorCaixa && errorCaixa.code !== 'PGRST116') throw errorCaixa;
    if (errorHistorico) throw errorHistorico;

    // Calcular total de vendas em dinheiro do caixa aberto (se houver)
    let totalVendasDinheiro = 0;
    let totalRetiradas = 0;
    let retiradas = [];
    if (ultimoCaixa && !ultimoCaixa.data_fechamento) {
      const [vendasRes, retiradasRes] = await Promise.all([
        supabase
          .from('vendas')
          .select('total')
          .eq('pagamento', 'dinheiro')
          .gte('data', ultimoCaixa.data_abertura),
        supabase
          .from('caixa_retiradas')
          .select('*, usuario:usuario_id(nome)')
          .eq('caixa_id', ultimoCaixa.id)
          .order('data', { ascending: false })
      ]);

      if (!vendasRes.error && vendasRes.data) {
        totalVendasDinheiro = vendasRes.data.reduce((sum, v) => sum + v.total, 0);
      }

      retiradas = retiradasRes.data || [];
      totalRetiradas = retiradas.reduce((s, r) => s + parseFloat(r.valor), 0);
    }

    res.json({
      caixaAtual: ultimoCaixa || null,
      totalVendasDinheiro,
      totalRetiradas,
      retiradas,
      historico: historicoCaixa || []
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/caixa/abrir', autenticar, async (req, res) => {
  const { troco_inicial } = req.body;

  try {
    // Verificar se já tem caixa aberto
    const { data: caixaAberto, error: errorCaixaAberto } = await supabase
      .from('caixa')
      .select('*')
      .is('data_fechamento', null)
      .limit(1)
      .single();
    
    if (caixaAberto && !errorCaixaAberto) {
      return res.status(400).json({ error: 'Já há um caixa aberto' });
    }

    const { data: novoCaixa, error: errorNovoCaixa } = await supabase
      .from('caixa')
      .insert([{
        troco_inicial,
        data_abertura: new Date().toISOString(),
        usuario_abertura_id: req.usuario.id
      }])
      .select()
      .single();
    
    if (errorNovoCaixa) throw errorNovoCaixa;

    res.json(novoCaixa);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/caixa/fechar', autenticar, async (req, res) => {
  const { valor_final } = req.body;

  try {
    // Buscar caixa aberto
    const { data: caixaAberto, error: errorCaixaAberto } = await supabase
      .from('caixa')
      .select('*')
      .is('data_fechamento', null)
      .limit(1)
      .single();
    
    if (errorCaixaAberto || !caixaAberto) {
      return res.status(400).json({ error: 'Nenhum caixa aberto' });
    }

    // Calcular total de vendas em dinheiro
    const { data: vendas, error: errorVendas } = await supabase
      .from('vendas')
      .select('total')
      .eq('pagamento', 'dinheiro')
      .gte('data', caixaAberto.data_abertura);
    
    let totalVendasDinheiro = 0;
    if (!errorVendas && vendas) {
      totalVendasDinheiro = vendas.reduce((sum, v) => sum + v.total, 0);
    }

    // Fechar caixa
    const { data: caixaFechado, error: errorFechar } = await supabase
      .from('caixa')
      .update({
        valor_final,
        total_vendas_dinheiro: totalVendasDinheiro,
        data_fechamento: new Date().toISOString(),
        usuario_fechamento_id: req.usuario.id
      })
      .eq('id', caixaAberto.id)
      .select()
      .single();
    
    if (errorFechar) throw errorFechar;

    res.json(caixaFechado);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== CAIXA — RETIRADAS ====================
app.post('/api/caixa/retirada', autenticar, async (req, res) => {
  const { valor, motivo } = req.body;

  if (!valor || valor <= 0) return res.status(400).json({ error: 'Valor inválido' });
  if (!motivo || !motivo.trim()) return res.status(400).json({ error: 'Informe o motivo' });

  try {
    // Buscar caixa aberto
    const { data: caixaAberto, error: errCaixa } = await supabase
      .from('caixa')
      .select('id')
      .is('data_fechamento', null)
      .limit(1)
      .single();

    if (errCaixa || !caixaAberto) {
      return res.status(400).json({ error: 'Nenhum caixa aberto' });
    }

    const { data, error } = await supabase
      .from('caixa_retiradas')
      .insert([{
        caixa_id:   caixaAberto.id,
        valor:      parseFloat(valor),
        motivo:     motivo.trim(),
        usuario_id: req.usuario.id,
        data:       new Date().toISOString()
      }])
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/caixa/retiradas', autenticar, async (req, res) => {
  try {
    // Buscar caixa aberto
    const { data: caixaAberto } = await supabase
      .from('caixa')
      .select('id')
      .is('data_fechamento', null)
      .limit(1)
      .single();

    if (!caixaAberto) return res.json([]);

    const { data, error } = await supabase
      .from('caixa_retiradas')
      .select('*, usuario:usuario_id(nome)')
      .eq('caixa_id', caixaAberto.id)
      .order('data', { ascending: false });

    if (error) throw error;
    res.json(data || []);
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
