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
// Descontar 1 copo do estoque por açaí vendido/consumido (tamanho em ml)
async function baixarCopoAcai(item, obs = 'Açaí') {
  const nome = String(item.produtoNome || '').toLowerCase();
  if (!nome.startsWith('açaí') && !nome.startsWith('acai')) return;

  const m = nome.match(/(\d+)\s*ml/);
  if (!m) return;

  const ml = m[1];
  const { data: copo } = await supabase
    .from('produtos')
    .select('id, qtd')
    .eq('nome', `Copo ${ml}ml`)
    .maybeSingle();
  if (!copo) return;

  await supabase
    .from('produtos')
    .update({ qtd: Math.max(parseFloat(copo.qtd || 0) - item.qtd, 0) })
    .eq('id', copo.id);

  await supabase
    .from('movimentacoes')
    .insert([{
      tipo: 'saida',
      produto_id: copo.id,
      produto_nome: `Copo ${ml}ml`,
      qtd: item.qtd,
      obs
    }]);
}

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
      const itemData = {
        venda_id: venda.id,
        produto_id: item.produtoId,
        produto_nome: item.produtoNome,
        qtd: item.qtd,
        preco_unitario: item.precoUnitario
      };
      if (item.recheio) itemData.recheio = item.recheio;

      await supabase.from('venda_itens').insert([itemData]);

      const { data: produtoAtual } = await supabase
        .from('produtos')
        .select('qtd, tipo, nome')
        .eq('id', item.produtoId)
        .single();

      const isPastel = item.recheio || produtoAtual?.tipo === 'pastel' ||
        (produtoAtual?.nome && produtoAtual.nome.toLowerCase() === 'pastel');

      if (!isPastel && produtoAtual) {
        await supabase
          .from('produtos')
          .update({ qtd: produtoAtual.qtd - item.qtd })
          .eq('id', item.produtoId);

        await supabase
          .from('movimentacoes')
          .insert([{
            tipo: 'saida',
            produto_id: item.produtoId,
            produto_nome: item.produtoNome,
            qtd: item.qtd,
            obs: `Venda ${delivery ? `(${plataforma || ''})` : 'balcão'} - ${pagamento}`
          }]);
      }

      await baixarCopoAcai(item, `Venda ${delivery ? `(${plataforma || ''})` : 'balcão'} - ${pagamento}`);
    }

    res.json({ ...venda, itens });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ==================== CONSUMO (funcionários) ====================
const LIMITE_CONSUMO_MENSAL = 100;

function inicioDoMesLocal(agora = new Date()) {
  return new Date(agora.getFullYear(), agora.getMonth(), 1);
}

app.get('/api/consumo', autenticar, async (req, res) => {
  try {
    const agora = new Date();
    const inicio = inicioDoMesLocal(agora);

    const { data: consumos, error } = await supabase
      .from('consumos')
      .select('*')
      .eq('usuario_id', req.usuario.id)
      .gte('data', inicio.toISOString())
      .lte('data', agora.toISOString())
      .order('data', { ascending: false });

    if (error) throw error;

    const consumosComItens = [];
    for (const c of consumos || []) {
      const { data: itens } = await supabase
        .from('consumo_itens')
        .select('*')
        .eq('consumo_id', c.id);
      consumosComItens.push({ ...c, itens: itens || [] });
    }

    const totalMes = (consumos || []).reduce((s, c) => s + parseFloat(c.total || 0), 0);

    res.json({ consumos: consumosComItens, totalMes });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/consumo', autenticar, async (req, res) => {
  if (req.usuario.role !== 'funcionario') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { itens, obs, usuario_id } = req.body;

  if (!itens || !Array.isArray(itens) || !itens.length) {
    return res.status(400).json({ error: 'Adicione pelo menos um item' });
  }

  // Quem consumiu (padrão: o próprio funcionário logado)
  let consumidorId = req.usuario.id;
  if (usuario_id) {
    const { data: alvo, error: alvoError } = await supabase
      .from('usuarios')
      .select('id, role')
      .eq('id', usuario_id)
      .single();

    if (alvoError || !alvo || alvo.role !== 'funcionario') {
      return res.status(400).json({ error: 'Usuário inválido para consumo' });
    }
    consumidorId = alvo.id;
  }

  const total = itens.reduce((s, i) => s + (parseFloat(i.qtd || 0) * parseFloat(i.precoUnitario || 0)), 0);

  try {
    // Verificar limite mensal do usuário que consumiu
    const inicio = inicioDoMesLocal();
    const { data: consumosMes } = await supabase
      .from('consumos')
      .select('total')
      .eq('usuario_id', consumidorId)
      .gte('data', inicio.toISOString());

    const jaUsado = (consumosMes || []).reduce((s, c) => s + parseFloat(c.total || 0), 0);
    const acimaLimite = jaUsado + total > LIMITE_CONSUMO_MENSAL;

    // Inserir consumo
    const { data: consumo, error: consumoError } = await supabase
      .from('consumos')
      .insert([{ usuario_id: consumidorId, total, obs: obs || null }])
      .select()
      .single();
    if (consumoError) throw consumoError;

    // Inserir itens, baixar estoque e registrar movimentação
    for (const item of itens) {
      const itemData = {
        consumo_id: consumo.id,
        produto_id: item.produtoId,
        produto_nome: item.produtoNome,
        qtd: item.qtd,
        preco_unitario: item.precoUnitario
      };
      if (item.recheio) itemData.recheio = item.recheio;

      await supabase.from('consumo_itens').insert([itemData]);

      const { data: produtoAtual } = await supabase
        .from('produtos')
        .select('qtd, tipo, nome')
        .eq('id', item.produtoId)
        .single();

      const isPastel = item.recheio || produtoAtual?.tipo === 'pastel' ||
        (produtoAtual?.nome && produtoAtual.nome.toLowerCase() === 'pastel');

      if (!isPastel && produtoAtual) {
        await supabase
          .from('produtos')
          .update({ qtd: produtoAtual.qtd - item.qtd })
          .eq('id', item.produtoId);

        await supabase
          .from('movimentacoes')
          .insert([{
            tipo: 'saida',
            produto_id: item.produtoId,
            produto_nome: item.produtoNome,
            qtd: item.qtd,
            obs: 'Consumo funcionário'
          }]);
      }

      await baixarCopoAcai(item, 'Consumo funcionário');
    }

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
      .eq('role', 'funcionario')
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
      .select('id, nome, usuario')
      .eq('role', 'funcionario')
      .order('nome');

    if (funcError) throw funcError;

    const resultado = [];
    for (const f of funcionarios || []) {
      const { data: consumos, error: consError } = await supabase
        .from('consumos')
        .select('*')
        .eq('usuario_id', f.id)
        .gte('data', inicio.toISOString())
        .lte('data', agora.toISOString())
        .order('data', { ascending: false });

      if (consError) throw consError;

      const comItens = [];
      for (const c of consumos || []) {
        const { data: itens } = await supabase
          .from('consumo_itens')
          .select('*')
          .eq('consumo_id', c.id);
        comItens.push({ ...c, itens: itens || [] });
      }

      const totalMes = (consumos || []).reduce((s, c) => s + parseFloat(c.total || 0), 0);
      resultado.push({ ...f, totalMes, consumos: comItens });
    }

    res.json(resultado);
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
      const { data: vendasData, error: errorVendas } = await supabase
        .from('vendas')
        .select('total')
        .eq('pagamento', 'dinheiro')
        .gte('data', ultimoCaixa.data_abertura);
      
      if (!errorVendas && vendasData) {
        totalVendasDinheiro = vendasData.reduce((sum, v) => sum + v.total, 0);
      }

      const { data: retiradasData } = await supabase
        .from('caixa_retiradas')
        .select('*, usuario:usuario_id(nome)')
        .eq('caixa_id', ultimoCaixa.id)
        .order('data', { ascending: false });

      retiradas = retiradasData || [];
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
