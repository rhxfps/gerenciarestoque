// ==================== TEMA ====================
function initTheme() {
  const saved = localStorage.getItem('theme') || 'dark';
  applyTheme(saved);
}

function applyTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  const icon = document.getElementById('theme-icon');
  if (icon) icon.className = theme === 'dark' ? 'ti ti-sun' : 'ti ti-moon';
  localStorage.setItem('theme', theme);
}

function toggleTheme() {
  const current = document.documentElement.getAttribute('data-theme') || 'light';
  applyTheme(current === 'dark' ? 'light' : 'dark');
}

// Aplicar tema antes do DOM carregar para evitar flash
initTheme();

// Variáveis globais
let produtos = [];
let movimentacoes = [];
let vendas = [];
let usuarios = [];
let vendaItens = [];
let caixas = [];
let vendasListenersAdicionados = false;
let currentUser = null;
let authToken = null;

const API_URL = '/api';

// Carregar token do localStorage
function loadAuth() {
  const savedToken = localStorage.getItem('authToken');
  const savedUser = localStorage.getItem('currentUser');
  if (savedToken && savedUser) {
    authToken = savedToken;
    currentUser = JSON.parse(savedUser);
    return true;
  }
  return false;
}

// Salvar autenticação no localStorage
function saveAuth(token, user) {
  authToken = token;
  currentUser = user;
  localStorage.setItem('authToken', token);
  localStorage.setItem('currentUser', JSON.stringify(user));
}

// Limpar autenticação
function clearAuth() {
  authToken = null;
  currentUser = null;
  localStorage.removeItem('authToken');
  localStorage.removeItem('currentUser');
}

// Helper para fazer requisições autenticadas
async function apiRequest(endpoint, options = {}) {
  const headers = {
    'Content-Type': 'application/json',
    ...options.headers
  };
  
  if (authToken) {
    headers['Authorization'] = `Bearer ${authToken}`;
  }

  const response = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.error || `Erro na requisição: ${response.status}`);
  }

  return response.json();
}

// Toast notification
function toast(msg, ok = true) {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.style.background = ok ? '#1D9E75' : '#A32D2D';
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 2400);
}

// Format date
function fmt(d) {
  const date = new Date(d);
  return date.toLocaleDateString('pt-BR', {day:'2-digit',month:'2-digit',year:'2-digit'}) + ' ' + 
         date.toLocaleTimeString('pt-BR', {hour:'2-digit',minute:'2-digit'});
}

// Check if date is in current week
function semanaAtual(d) {
  const hoje = new Date();
  const date = new Date(d);
  const diaSemana = hoje.getDay();
  const segunda = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);
  const domingo = new Date(segunda);
  domingo.setDate(segunda.getDate() + 7);
  
  return date >= segunda && date < domingo;
}

// Função para mostrar/ocultar senha
function toggleSenha() {
  const inputSenha = document.getElementById('login-senha');
  const icone = document.getElementById('icone-senha');
  
  if (inputSenha.type === 'password') {
    inputSenha.type = 'text';
    icone.className = 'ti ti-eye-off';
  } else {
    inputSenha.type = 'password';
    icone.className = 'ti ti-eye';
  }
}

// Função de login
async function login() {
  const usuario = document.getElementById('login-email').value.trim();
  const senha = document.getElementById('login-senha').value.trim();
  
  if (!usuario || !senha) {
    toast('Informe usuário e senha!', false);
    return;
  }

  console.log('Tentando login com:', { usuario, senha });

  try {
    const data = await apiRequest('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ usuario, senha })
    });

    console.log('Resposta do login:', data);
    saveAuth(data.token, data.usuario);
    await loadAllData();
    showApp();
    toast('Login realizado com sucesso!');
  } catch (error) {
    console.error('Erro no login:', error);
    toast(error.message || 'Erro ao fazer login!', false);
  }
}

// Função de logout
function logout() {
  clearAuth();
  document.getElementById('login-container').style.display = 'flex';
  document.getElementById('app-container').style.display = 'none';
  document.getElementById('login-email').value = '';
  document.getElementById('login-senha').value = '';
}

// Mostrar app principal
function showApp() {
  document.getElementById('login-container').style.display = 'none';
  document.getElementById('app-container').style.display = 'flex';
  document.getElementById('user-name').textContent = currentUser.nome;
  updateMenuByRole();
  nav('dashboard');
}

// Atualizar menu por role
function updateMenuByRole() {
  const isDono = currentUser.role === 'dono';
  
  const navItems = ['dashboard', 'estoque', 'produtos', 'registrar', 'historico', 'lista-vendas', 'relatorio', 'vendas', 'caixa', 'usuarios'];
  
  navItems.forEach(item => {
    const el = document.getElementById(`nav-${item}`);
    if (el) {
      if (item === 'vendas' || item === 'caixa') {
        el.style.display = 'block';
      } else {
        el.style.display = isDono ? 'block' : 'none';
      }
    }
  });
  
  const userRoleEl = document.getElementById('user-role');
  if (userRoleEl) {
    userRoleEl.textContent = currentUser.role === 'dono' ? 'Dono' : 'Funcionário';
  }
}

// Carregar todos os dados
async function loadAllData() {
  try {
    [produtos, movimentacoes, vendas] = await Promise.all([
      apiRequest('/produtos'),
      currentUser.role === 'dono' ? apiRequest('/movimentacoes') : [],
      apiRequest('/vendas')
    ]);

    if (currentUser.role === 'dono') {
      usuarios = await apiRequest('/usuarios');
      const caixaResponse = await apiRequest('/caixa');
      caixas = caixaResponse.historico || [];
    }
  } catch (error) {
    console.error('Erro ao carregar dados:', error);
    toast('Erro ao carregar dados do servidor!', false);
  }
}

// ==================== NAVEGAÇÃO ====================
const titles = {
  dashboard:    'Dashboard',
  estoque:      'Estoque',
  produtos:     'Produtos',
  registrar:    'Registrar Movimentação',
  historico:    'Histórico',
  'lista-vendas': 'Vendas',
  relatorio:    'Relatório semanal',
  vendas:       'Comandas/Vendas',
  caixa:        'Caixa',
  usuarios:     'Usuários'
};

function nav(screen) {
  if (screen !== 'vendas' && screen !== 'caixa' && screen !== 'lista-vendas' && currentUser.role !== 'dono') {
    toast('Acesso negado!', false);
    nav('vendas');
    return;
  }

  document.querySelectorAll('.nav-item').forEach(n => n.classList.toggle('active', n.dataset.screen === screen));
  document.querySelectorAll('.mobile-nav-item').forEach(n => n.classList.toggle('active', n.dataset.screen === screen));
  document.querySelectorAll('.screen').forEach(s => s.classList.toggle('active', s.id === `screen-${screen}`));
  document.getElementById('topbar-title').textContent = titles[screen] || screen;

  if (screen === 'dashboard')    renderDashboardProfissional();
  if (screen === 'estoque')      renderEstoque();
  if (screen === 'produtos')     renderProdutos();
  if (screen === 'registrar')    { populateSelect('e-produto'); populateSelect('s-produto'); renderRegistros(); }
  if (screen === 'historico')    { populateHFiltro(); renderHistorico(); }
  if (screen === 'lista-vendas') renderListaVendas();
  if (screen === 'relatorio')    renderRelatorio();
  if (screen === 'caixa')        renderCaixa();
  if (screen === 'usuarios')     renderUsuarios();
  if (screen === 'vendas') {
    vendaItens = [];
    vendaCategoriaAtiva = 'Todos';
    loadPastelData().then(() => {
      renderVendas();
      renderVendaItens();
      atualizaPreview();
    });

    if (!vendasListenersAdicionados) {
      const pagamentos = document.querySelectorAll('input[name="v-pagamento"]');
      pagamentos.forEach(input => input.addEventListener('change', atualizaEstiloOpcoes));
      const tiposVenda = document.querySelectorAll('input[name="v-tipo-venda"]');
      tiposVenda.forEach(input => input.addEventListener('change', togglePlataforma));
      vendasListenersAdicionados = true;
    }
    atualizaEstiloOpcoes();
  }
}

      const tiposVenda = document.querySelectorAll('input[name="v-tipo-venda"]');
      tiposVenda.forEach(input => {
        input.addEventListener('change', togglePlataforma);
      });
      vendasListenersAdicionados = true;
    }
    
    atualizaEstiloOpcoes();
  }
}

document.getElementById('nav').addEventListener('click', e => {
  const item = e.target.closest('.nav-item');
  if (item) nav(item.dataset.screen);
});

// Função para abrir/fechar menu móvel
function toggleMobileMenu() {
  const menu = document.getElementById('mobileMenu');
  const overlay = document.getElementById('menuOverlay');
  
  if (menu.style.display === 'block') {
    menu.style.display = 'none';
    overlay.style.display = 'none';
  } else {
    menu.style.display = 'block';
    overlay.style.display = 'block';
  }
}

// Event listener para os itens do menu móvel
document.getElementById('mobileNav').addEventListener('click', e => {
  const item = e.target.closest('.mobile-nav-item');
  if (item) {
    toggleMobileMenu(); // Fecha o menu ao selecionar
    nav(item.dataset.screen);
  }
});

// ==================== REGISTRAR (Entrada + Saída unificado) ====================
let regTipoAtivo = 'entrada';

function selectRegTipo(tipo) {
  regTipoAtivo = tipo;
  document.getElementById('reg-btn-entrada').classList.toggle('active', tipo === 'entrada');
  document.getElementById('reg-btn-saida').classList.toggle('active', tipo === 'saida');
  document.getElementById('reg-form-entrada').style.display = tipo === 'entrada' ? 'block' : 'none';
  document.getElementById('reg-form-saida').style.display   = tipo === 'saida'   ? 'block' : 'none';
}

function renderRegistros() {
  selectRegTipo(regTipoAtivo);
  const tb = document.getElementById('tabela-registros');
  const em = document.getElementById('registros-empty');
  const recentes = [...movimentacoes].slice(0, 30);
  if (!recentes.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  tb.innerHTML = recentes.map(m => {
    const badge = m.tipo === 'entrada'
      ? '<span class="badge badge-green">Entrada</span>'
      : '<span class="badge badge-red">Saída</span>';
    const qtd = m.tipo === 'entrada'
      ? `<span class="tag-entrada">+${m.qtd}</span>`
      : `<span class="tag-saida">-${m.qtd}</span>`;
    return `<tr>
      <td><strong>${m.produto_nome}</strong></td>
      <td>${badge}</td>
      <td>${qtd}</td>
      <td>${m.obs || '—'}</td>
      <td>${fmt(m.data)}</td>
    </tr>`;
  }).join('');
}

// ==================== LISTA DE VENDAS ====================
function renderListaVendas() {
  const periodo  = document.getElementById('vl-filtro-periodo')?.value || 'semana';
  const pagFiltro = document.getElementById('vl-filtro-pag')?.value || '';
  const tipoFiltro = document.getElementById('vl-filtro-tipo')?.value || '';

  const hoje = new Date();
  hoje.setHours(23, 59, 59, 999);
  const diaSemana = hoje.getDay();
  const segunda = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);
  const primeiroDiaMes = new Date(hoje.getFullYear(), hoje.getMonth(), 1);
  const inicioDia = new Date(); inicioDia.setHours(0, 0, 0, 0);

  let lista = [...vendas].sort((a, b) => new Date(b.data) - new Date(a.data));

  if (periodo === 'hoje')   lista = lista.filter(v => new Date(v.data) >= inicioDia);
  if (periodo === 'semana') lista = lista.filter(v => new Date(v.data) >= segunda);
  if (periodo === 'mes')    lista = lista.filter(v => new Date(v.data) >= primeiroDiaMes);
  if (pagFiltro)  lista = lista.filter(v => v.pagamento === pagFiltro);
  if (tipoFiltro) lista = lista.filter(v => tipoFiltro === 'delivery' ? v.delivery : !v.delivery);

  const totalFat   = lista.reduce((s, v) => s + (v.total || 0), 0);
  const ticketMed  = lista.length ? totalFat / lista.length : 0;

  document.getElementById('vl-count').textContent  = `${lista.length} venda(s)`;
  document.getElementById('vl-kpi-qtd').textContent  = lista.length;
  document.getElementById('vl-kpi-total').textContent = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalFat);
  document.getElementById('vl-kpi-ticket').textContent = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(ticketMed);

  const container = document.getElementById('vl-lista');
  if (!lista.length) {
    container.innerHTML = '<div class="empty"><i class="ti ti-receipt"></i>Nenhuma venda no período selecionado.</div>';
    return;
  }

  container.innerHTML = lista.map(v => {
    const total = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(v.total || 0);
    const pagBadge = v.pagamento === 'dinheiro'
      ? '<span class="badge badge-green"><i class="ti ti-cash"></i> Dinheiro</span>'
      : '<span class="badge badge-blue"><i class="ti ti-credit-card"></i> Cartão</span>';
    const tipoBadge = v.delivery
      ? '<span class="badge badge-amber"><i class="ti ti-delivery"></i> Delivery</span>'
      : '<span class="badge badge-gray"><i class="ti ti-shopping-bag"></i> Balcão</span>';

    let prodResumo = '';
    if (v.itens?.length) {
      prodResumo = v.itens.length === 1
        ? `${v.itens[0].produto_nome} × ${v.itens[0].qtd}`
        : `${v.itens.length} itens`;
    } else if (v.produto_nome) {
      prodResumo = `${v.produto_nome} × ${v.qtd || 1}`;
    }

    return `
      <div class="vl-card" onclick="openVendaDetalhe(${v.id})">
        <div class="vl-card-left">
          <div class="vl-card-valor">${total}</div>
          <div class="vl-card-prod">${prodResumo}</div>
          <div class="vl-card-data">${fmt(v.data)}</div>
        </div>
        <div class="vl-card-right">
          ${pagBadge}
          ${tipoBadge}
          <i class="ti ti-chevron-right vl-card-arrow"></i>
        </div>
      </div>`;
  }).join('');
}

function openVendaDetalhe(vendaId) {
  const venda = vendas.find(v => v.id === vendaId);
  if (!venda) return;

  const total = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(venda.total || 0);
  const pagBadge = venda.pagamento === 'dinheiro'
    ? '<span class="badge badge-green">Dinheiro</span>'
    : '<span class="badge badge-blue">Cartão</span>';
  const tipoBadge = venda.delivery
    ? '<span class="badge badge-amber">Delivery</span>'
    : '<span class="badge badge-gray">Balcão</span>';

  let itensHTML = '';
  if (venda.itens?.length) {
    itensHTML = venda.itens.map(i => {
      const sub = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format((i.preco_unitario || 0) * i.qtd);
      return `<div class="vd-item">
        <span class="vd-item-nome">${i.produto_nome}${i.recheio ? ` <small>(${i.recheio})</small>` : ''}</span>
        <span class="vd-item-qty">× ${i.qtd}</span>
        <span class="vd-item-sub">${sub}</span>
      </div>`;
    }).join('');
  } else if (venda.produto_nome) {
    const sub = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(venda.total || 0);
    itensHTML = `<div class="vd-item">
      <span class="vd-item-nome">${venda.produto_nome}</span>
      <span class="vd-item-qty">× ${venda.qtd || 1}</span>
      <span class="vd-item-sub">${sub}</span>
    </div>`;
  }

  document.getElementById('venda-detalhe-body').innerHTML = `
    <div class="vd-meta">
      <div class="vd-meta-row"><i class="ti ti-clock"></i> ${fmt(venda.data)}</div>
      <div class="vd-meta-row">${pagBadge} ${tipoBadge}</div>
      ${venda.plataforma ? `<div class="vd-meta-row"><i class="ti ti-device-mobile"></i> ${venda.plataforma}</div>` : ''}
      ${venda.obs ? `<div class="vd-meta-row"><i class="ti ti-note"></i> ${venda.obs}</div>` : ''}
    </div>
    <div class="vd-itens-title">Itens</div>
    <div class="vd-itens">${itensHTML || '<div class="empty" style="padding:1rem">Sem detalhes de itens</div>'}</div>
    <div class="vd-total">
      <span>Total</span>
      <strong>${total}</strong>
    </div>`;

  document.getElementById('venda-detalhe-modal').classList.add('show');
}

function closeVendaDetalhe(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('venda-detalhe-modal').classList.remove('show');
}

// ==================== PRODUTOS ====================
function toggleFormProduto() {
  const formCard = document.getElementById('card-form-produto');
  formCard.style.display = formCard.style.display === 'none' ? 'block' : 'none';
  if (formCard.style.display === 'block') {
    document.getElementById('p-nome').value = '';
    document.getElementById('p-cat').value = '';
    document.getElementById('p-qty').value = '';
    document.getElementById('p-min').value = '';
    document.getElementById('p-preco').value = '';
  }
}

async function addProduto() {
  const nome = document.getElementById('p-nome').value.trim();
  const categoria = document.getElementById('p-cat').value.trim();
  const qtd = parseInt(document.getElementById('p-qty').value) || 0;
  const qtd_minima = parseInt(document.getElementById('p-min').value) || 0;
  const preco = parseFloat(document.getElementById('p-preco').value) || 0;
  
  if (!nome) {
    toast('Informe o nome do produto!', false);
    return;
  }
  
  try {
    await apiRequest('/produtos', {
      method: 'POST',
      body: JSON.stringify({ nome, categoria, qtd, qtd_minima, preco })
    });

    await loadAllData();
    renderProdutos();
    toggleFormProduto();
    toast('Produto cadastrado com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao cadastrar produto!', false);
    console.error(error);
  }
}

async function deleteProduto(id) {
  if (!confirm('Remover este produto? Esta ação não pode ser desfeita.')) return;
  
  try {
    await apiRequest(`/produtos/${id}`, { method: 'DELETE' });
    await loadAllData();
    renderProdutos();
    toast('Produto removido com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao remover produto!', false);
    console.error(error);
  }
}

function renderProdutos() {
  const tb = document.getElementById('tabela-produtos');
  const em = document.getElementById('produtos-empty');
  const ct = document.getElementById('p-count');
  ct.textContent = `${produtos.length} produto(s)`;
  
  if (!produtos.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  
  tb.innerHTML = produtos.map(p => {
    const low = p.qtd <= p.qtd_minima;
    const badge = low ? '<span class="badge badge-red">Baixo</span>' : '<span class="badge badge-green">OK</span>';
    const precoFormatado = p.preco ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(p.preco) : '—';
    return `<tr><td><strong>${p.nome}</strong></td><td>${p.categoria || '—'}</td><td>${p.qtd}</td><td>${p.qtd_minima}</td><td>${precoFormatado}</td><td>${badge}</td><td><button class="btn btn-danger btn-sm" onclick="deleteProduto(${p.id})"><i class="ti ti-trash"></i></button></td></tr>`;
  }).join('');
}

function populateSelect(id) {
  const sel = document.getElementById(id);
  const cur = sel.value;
  sel.innerHTML = '<option value="">Selecione um produto</option>' + 
    produtos.map(p => `<option value="${p.id}">${p.nome} (estoque: ${p.qtd})</option>`).join('');
  if (cur) sel.value = cur;
}

function populateHFiltro() {
  const sel = document.getElementById('h-filtro-prod');
  sel.innerHTML = '<option value="">Todos os produtos</option>' + 
    produtos.map(p => `<option value="${p.id}">${p.nome}</option>`).join('');
}

// ==================== MOVIMENTAÇÕES ====================
async function addEntrada() {
  console.log('addEntrada function called!');
  const produtoId = parseInt(document.getElementById('e-produto').value);
  const qtd = parseInt(document.getElementById('e-qty').value) || 0;
  const obs = document.getElementById('e-obs').value.trim();
  
  console.log('Values:', { produtoId, qtd, obs });
  
  if (!produtoId) { toast('Selecione um produto!', false); return; }
  if (qtd < 1) { toast('Quantidade deve ser maior que zero!', false); return; }

  const produto = produtos.find(p => p.id === produtoId);
  console.log('Found product:', produto);
  
  try {
    const result = await apiRequest('/movimentacoes', {
      method: 'POST',
      body: JSON.stringify({ tipo: 'entrada', produto_id: produtoId, produto_nome: produto.nome, qtd, obs })
    });
    console.log('API request result:', result);
    
    await loadAllData();
    renderEntradas();
    populateSelect('e-produto');
    toast('Entrada registrada com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao registrar entrada!', false);
    console.error('Error in addEntrada:', error);
  }
}

async function addSaida() {
  console.log('addSaida function called!');
  const produtoId = parseInt(document.getElementById('s-produto').value);
  const qtd = parseInt(document.getElementById('s-qty').value) || 0;
  const obs = document.getElementById('s-obs').value.trim();
  
  console.log('Values:', { produtoId, qtd, obs });
  
  if (!produtoId) { toast('Selecione um produto!', false); return; }
  if (qtd < 1) { toast('Quantidade deve ser maior que zero!', false); return; }
  
  const produto = produtos.find(p => p.id === produtoId);
  console.log('Found product:', produto);
  if (qtd > produto.qtd) {
    toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
    return;
  }

  try {
    const result = await apiRequest('/movimentacoes', {
      method: 'POST',
      body: JSON.stringify({ tipo: 'saida', produto_id: produtoId, produto_nome: produto.nome, qtd, obs })
    });
    console.log('API request result:', result);
    
    await loadAllData();
    renderSaidas();
    populateSelect('s-produto');
    toast('Saída registrada com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao registrar saída!', false);
    console.error('Error in addSaida:', error);
  }
}

function renderEntradas() {
  const tb = document.getElementById('tabela-entradas');
  const em = document.getElementById('entradas-empty');
  const mv = movimentacoes.filter(m => m.tipo === 'entrada');
  
  if (!mv.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  
  tb.innerHTML = mv.slice(0, 50).map(m => `<tr><td>${m.produto_nome}</td><td class="text-green"><strong>+${m.qtd}</strong></td><td>${m.obs || '—'}</td><td>${fmt(m.data)}</td></tr>`).join('');
}

function renderSaidas() {
  const tb = document.getElementById('tabela-saidas');
  const em = document.getElementById('saidas-empty');
  const mv = movimentacoes.filter(m => m.tipo === 'saida');
  
  if (!mv.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  
  tb.innerHTML = mv.slice(0, 50).map(m => `<tr><td>${m.produto_nome}</td><td class="text-red"><strong>-${m.qtd}</strong></td><td>${m.obs || '—'}</td><td>${fmt(m.data)}</td></tr>`).join('');
}

function renderHistorico() {
  const tipo = document.getElementById('h-filtro-tipo').value;
  const pid = document.getElementById('h-filtro-prod').value;
  let mv = [...movimentacoes];
  
  if (tipo) mv = mv.filter(m => m.tipo === tipo);
  if (pid) mv = mv.filter(m => m.produto_id === parseInt(pid));
  
  const tb = document.getElementById('tabela-historico');
  const em = document.getElementById('historico-empty');
  document.getElementById('h-count').textContent = `${mv.length} registro(s)`;
  
  if (!mv.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  
  tb.innerHTML = mv.map(m => {
    const badge = m.tipo === 'entrada' ? '<span class="badge badge-green">Entrada</span>' : '<span class="badge badge-red">Saída</span>';
    const qtd = m.tipo === 'entrada' ? `<span class="tag-entrada">+${m.qtd}</span>` : `<span class="tag-saida">-${m.qtd}</span>`;
    return `<tr><td>${fmt(m.data)}</td><td>${m.produto_nome}</td><td>${badge}</td><td>${qtd}</td><td>${m.obs || '—'}</td></tr>`;
  }).join('');
}

// ==================== ESTOQUE ====================
function renderEstoque() {
  const low = produtos.filter(p => p.qtd <= p.qtd_minima);
  
  document.getElementById('estoque-total-produtos').textContent = produtos.length;
  const semEnt = movimentacoes.filter(m => m.tipo === 'entrada' && semanaAtual(m.data)).reduce((a, m) => a + m.qtd, 0);
  const semSai = movimentacoes.filter(m => m.tipo === 'saida' && semanaAtual(m.data)).reduce((a, m) => a + m.qtd, 0);
  document.getElementById('estoque-entradas').textContent = semEnt;
  document.getElementById('estoque-saidas').textContent = semSai;
  document.getElementById('estoque-baixo').textContent = low.length;
  
  const al = document.getElementById('estoque-alertas');
  if (!low.length) {
    al.innerHTML = '<div class="empty" style="padding:1rem"><i class="ti ti-circle-check" style="color:#3B6D11;font-size:28px;display:block;margin-bottom:6px"></i>Nenhum produto com estoque baixo!</div>';
  } else {
    al.innerHTML = low.map(p => `<div class="alert-row"><i class="ti ti-alert-triangle"></i><span class="alert-name">${p.nome}</span><span class="alert-qty">${p.qtd} / mín. ${p.qtd_minima}</span></div>`).join('');
  }

  const dpq = document.getElementById('estoque-produtos-quantidades');
  if (!produtos.length) {
    dpq.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:var(--text-secondary)">Nenhum produto cadastrado</td></tr>';
  } else {
    dpq.innerHTML = produtos.map(p => {
      const lowItem = p.qtd <= p.qtd_minima;
      const badge = lowItem ? '<span class="badge badge-red">Baixo</span>' : '<span class="badge badge-green">OK</span>';
      const qtdColor = lowItem ? 'text-red' : 'text-green';
      return `<tr><td><strong>${p.nome}</strong></td><td>${p.categoria || '—'}</td><td class="${qtdColor}"><strong>${p.qtd}</strong></td><td>${badge}</td></tr>`;
    }).join('');
  }

  const dm = document.getElementById('estoque-movimentos');
  if (!movimentacoes.length) {
    dm.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:var(--text-secondary)">Sem movimentações ainda</td></tr>';
    return;
  }
  dm.innerHTML = movimentacoes.slice(0, 5).map(m => {
    const badge = m.tipo === 'entrada' ? '<span class="badge badge-green">Entrada</span>' : '<span class="badge badge-red">Saída</span>';
    const qtd = m.tipo === 'entrada' ? `<span class="text-green">+${m.qtd}</span>` : `<span class="text-red">-${m.qtd}</span>`;
    return `<tr><td>${m.produto_nome}</td><td>${badge}</td><td>${qtd}</td><td>${fmt(m.data)}</td></tr>`;
  }).join('');
}

// ==================== DASHBOARD ====================
function renderDashboardProfissional() {
  const hoje = new Date();
  const mesAtual = hoje.getMonth();
  const anoAtual = hoje.getFullYear();

  const meses = ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
                 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'];
  const nomeMesAtual = meses[mesAtual];
  
  const elMesAtual = document.getElementById('dash-mes-atual');
  if (elMesAtual) elMesAtual.textContent = nomeMesAtual;

  const vendasHoje = vendas.filter(v => {
    const dataVenda = new Date(v.data);
    return dataVenda.getDate() === hoje.getDate() && 
           dataVenda.getMonth() === mesAtual && 
           dataVenda.getFullYear() === anoAtual;
  });
  
  const elVendasHoje = document.getElementById('dash-vendas-hoje');
  if (elVendasHoje) elVendasHoje.textContent = vendasHoje.length;
  
  const valorHoje = vendasHoje.reduce((acumulador, venda) => {
    return acumulador + (venda.total || 0);
  }, 0);
  const elValorHoje = document.getElementById('dash-valor-hoje');
  if (elValorHoje) elValorHoje.textContent = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(valorHoje);

  const vendasMes = vendas.filter(v => {
    const dataVenda = new Date(v.data);
    return dataVenda.getMonth() === mesAtual && dataVenda.getFullYear() === anoAtual;
  });
  
  const elVendasMes = document.getElementById('dash-vendas-mes');
  if (elVendasMes) elVendasMes.textContent = vendasMes.length;
  
  const valorMes = vendasMes.reduce((acumulador, venda) => {
    return acumulador + (venda.total || 0);
  }, 0);
  const elValorMes = document.getElementById('dash-valor-mes');
  if (elValorMes) elValorMes.textContent = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(valorMes);

  const produtosVendidos = {};
  vendasMes.forEach(venda => {
    if (venda.itens && venda.itens.length > 0) {
      venda.itens.forEach(item => {
        produtosVendidos[item.produto_nome] = (produtosVendidos[item.produto_nome] || 0) + item.qtd;
      });
    } else if (venda.produto_nome) {
      produtosVendidos[venda.produto_nome] = (produtosVendidos[venda.produto_nome] || 0) + venda.qtd;
    }
  });
  
  const topProdutos = Object.entries(produtosVendidos).sort((a, b) => b[1] - a[1]).slice(0, 5);
  const topProdutosEl = document.getElementById('dash-top-produtos');
  if (topProdutosEl) {
    if (!topProdutos.length) {
      topProdutosEl.innerHTML = '<div class="empty" style="padding:1rem">Sem vendas ainda</div>';
    } else {
      const maxVendas = topProdutos[0][1];
      const medals = ['🥇','🥈','🥉','',''];
      topProdutosEl.innerHTML = topProdutos.map(([nome, qtd], i) => `
        <div class="dash-rank-item">
          <div class="dash-rank-header">
            <span class="dash-rank-name"><span class="dash-rank-medal">${medals[i]||''}</span>${nome}</span>
            <span class="dash-rank-val">${qtd} un.</span>
          </div>
          <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--blue);width:${Math.round((qtd/maxVendas)*100)}%"></div></div>
        </div>
      `).join('');
    }
  }

  const pagamentos = { dinheiro: 0, cartao: 0 };
  vendasMes.forEach(venda => {
    if (venda.pagamento === 'dinheiro') {
      pagamentos.dinheiro++;
    } else if (venda.pagamento === 'cartao') {
      pagamentos.cartao++;
    }
  });
  
  const pagamentosEl = document.getElementById('dash-pagamentos');
  if (pagamentosEl) {
    if (!vendasMes.length) {
      pagamentosEl.innerHTML = '<div class="empty" style="padding:1rem">Sem dados ainda</div>';
    } else {
      const totalPag = pagamentos.dinheiro + pagamentos.cartao;
      const pctDin = totalPag > 0 ? Math.round((pagamentos.dinheiro/totalPag)*100) : 0;
      const pctCart = totalPag > 0 ? Math.round((pagamentos.cartao/totalPag)*100) : 0;
      pagamentosEl.innerHTML = `
        <div class="dash-rank-item">
          <div class="dash-rank-header">
            <span class="dash-rank-name"><i class="ti ti-cash" style="color:var(--green)"></i> Dinheiro</span>
            <span class="dash-rank-val">${pagamentos.dinheiro} venda(s) · ${pctDin}%</span>
          </div>
          <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--green);width:${pctDin}%"></div></div>
        </div>
        <div class="dash-rank-item">
          <div class="dash-rank-header">
            <span class="dash-rank-name"><i class="ti ti-credit-card" style="color:var(--blue)"></i> Cartão</span>
            <span class="dash-rank-val">${pagamentos.cartao} venda(s) · ${pctCart}%</span>
          </div>
          <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--blue);width:${pctCart}%"></div></div>
        </div>
      `;
    }
  }

  const ultimasVendasEl = document.getElementById('dash-ultimas-vendas');
  if (ultimasVendasEl) {
    if (!vendas.length) {
      ultimasVendasEl.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:20px;color:var(--text-secondary)">Sem vendas ainda</td></tr>';
    } else {
      ultimasVendasEl.innerHTML = vendas.slice(0, 8).map(venda => {
        const pagamentoBadge = venda.pagamento === 'dinheiro' 
          ? '<span class="badge badge-green">Dinheiro</span>' 
          : '<span class="badge badge-blue">Cartão</span>';
        const deliveryBadge = venda.delivery 
          ? '<span class="badge badge-amber">Sim</span>' 
          : '<span class="badge badge-green">Não</span>';
        const totalFormatado = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(venda.total || 0);
        
        let produtoNome = '';
        let qtd = 0;
        if (venda.itens && venda.itens.length) {
          if (venda.itens.length === 1) {
            produtoNome = venda.itens[0].produto_nome;
            qtd = venda.itens[0].qtd;
          } else {
            produtoNome = `${venda.itens.length} itens`;
            qtd = venda.itens.reduce((sum, item) => sum + item.qtd, 0);
          }
        } else if (venda.produto_nome) {
          produtoNome = venda.produto_nome;
          qtd = venda.qtd;
        }
        
        return `<tr><td>${fmt(venda.data)}</td><td><strong>${produtoNome}</strong></td><td>${qtd}</td><td><strong>${totalFormatado}</strong></td><td>${pagamentoBadge}</td><td>${deliveryBadge}</td></tr>`;
      }).join('');
    }
  }
}

// ==================== RELATÓRIO ====================
let relTabAtiva = 'vendas';

function selectRelTab(tab) {
  relTabAtiva = tab;
  document.querySelectorAll('.rel-tab').forEach(b => b.classList.toggle('active', b.dataset.tab === tab));
  document.querySelectorAll('.rel-panel').forEach(p => p.classList.toggle('active', p.id === `rel-${tab}`));
  renderRelatorioTab(tab);
}

function renderRelatorio() {
  relTabAtiva = 'vendas';
  document.querySelectorAll('.rel-tab').forEach(b => b.classList.toggle('active', b.dataset.tab === 'vendas'));
  document.querySelectorAll('.rel-panel').forEach(p => p.classList.toggle('active', p.id === 'rel-vendas'));
  renderRelatorioTab('vendas');
}

function renderRelatorioTab(tab) {
  if (tab === 'vendas')        renderRelVendas();
  if (tab === 'estoque')       renderRelEstoque();
  if (tab === 'movimentacoes') renderRelMovimentacoes();
  if (tab === 'caixa')         renderRelCaixa();
}

function renderRelVendas() {
  const vendasSemana = vendas.filter(v => semanaAtual(v.data));
  const totalVendasReais = vendasSemana.reduce((a, v) => a + (v.total || 0), 0);
  const totalDinheiro    = vendasSemana.filter(v => v.pagamento === 'dinheiro').reduce((a, v) => a + (v.total || 0), 0);
  const totalCartao      = vendasSemana.filter(v => v.pagamento === 'cartao').reduce((a, v) => a + (v.total || 0), 0);
  const qtdDelivery      = vendasSemana.filter(v => v.delivery).length;
  const qtdBalcao        = vendasSemana.filter(v => !v.delivery).length;
  const totalTipo        = Math.max(qtdDelivery + qtdBalcao, 1);

  document.getElementById('r-vendas-qtd').textContent     = vendasSemana.length;
  document.getElementById('r-total-dinheiro').textContent = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalDinheiro);
  document.getElementById('r-total-cartao').textContent   = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalCartao);
  document.getElementById('r-total-geral').textContent    = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalVendasReais);
  document.getElementById('r-delivery').textContent = qtdDelivery;
  document.getElementById('r-balcao').textContent   = qtdBalcao;
  document.getElementById('r-bar-delivery').style.width = `${Math.round((qtdDelivery/totalTipo)*100)}%`;
  document.getElementById('r-bar-balcao').style.width   = `${Math.round((qtdBalcao/totalTipo)*100)}%`;

  // ---- Gráfico de barras por dia da semana ----
  const hoje = new Date();
  const diaSemana = hoje.getDay(); // 0=dom
  const segunda = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);

  const diasLabel  = ['Seg','Ter','Qua','Qui','Sex','Sáb','Dom'];
  const diasValor  = [0, 0, 0, 0, 0, 0, 0]; // índice 0=Seg
  const diasQtd    = [0, 0, 0, 0, 0, 0, 0];

  vendasSemana.forEach(v => {
    const d = new Date(v.data);
    const diff = Math.floor((d - segunda) / 86400000);
    if (diff >= 0 && diff <= 6) {
      diasValor[diff] += v.total || 0;
      diasQtd[diff]   += 1;
    }
  });

  // só mostra até o dia de hoje
  const diaAtual = ((diaSemana + 6) % 7); // 0=Seg
  const maxValor = Math.max(...diasValor, 1);
  const fmtM = v => new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(v);

  const chartEl = document.getElementById('r-chart-dias');
  if (!chartEl) return;

  chartEl.innerHTML = diasLabel.map((label, i) => {
    const isFuture  = i > diaAtual;
    const isHoje    = i === diaAtual;
    const pct       = isFuture ? 0 : Math.round((diasValor[i] / maxValor) * 100);
    const hasVenda  = diasValor[i] > 0;
    return `
      <div class="bar-day ${isFuture ? 'bar-day--future' : ''} ${isHoje ? 'bar-day--today' : ''}">
        <div class="bar-day-tooltip">
          <span class="bar-day-tooltip-val">${fmtM(diasValor[i])}</span>
          <span class="bar-day-tooltip-qty">${diasQtd[i]} venda(s)</span>
        </div>
        <div class="bar-day-bar-wrap">
          <div class="bar-day-bar" style="height:${pct}%"></div>
        </div>
        <span class="bar-day-label">${label}</span>
        ${isHoje ? '<span class="bar-day-today-dot"></span>' : ''}
      </div>`;
  }).join('');

  // ---- Ranking produtos mais vendidos ----
  const rankVendas = {};
  vendasSemana.forEach(v => {
    if (v.itens?.length) v.itens.forEach(i => { rankVendas[i.produto_nome] = (rankVendas[i.produto_nome]||0)+i.qtd; });
    else if (v.produto_nome) rankVendas[v.produto_nome] = (rankVendas[v.produto_nome]||0)+v.qtd;
  });
  const sortedV = Object.entries(rankVendas).sort((a,b)=>b[1]-a[1]).slice(0,5);
  const rkVendas = document.getElementById('r-ranking-vendas');
  if (!sortedV.length) {
    rkVendas.innerHTML = '<div class="empty" style="padding:1rem">Sem vendas esta semana</div>';
  } else {
    const maxV = sortedV[0][1];
    const medals = ['🥇','🥈','🥉','',''];
    rkVendas.innerHTML = sortedV.map(([nome, qtd], i) => `
      <div class="dash-rank-item">
        <div class="dash-rank-header">
          <span class="dash-rank-name"><span class="dash-rank-medal">${medals[i]||''}</span>${nome}</span>
          <span class="dash-rank-val">${qtd} un.</span>
        </div>
        <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--blue);width:${Math.round((qtd/maxV)*100)}%"></div></div>
      </div>`).join('');
  }
}

function renderRelEstoque() {
  const rt = document.getElementById('r-tabela');
  if (!produtos.length) {
    rt.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:20px;color:var(--text-secondary)">Sem produtos cadastrados</td></tr>';
    return;
  }
  rt.innerHTML = produtos.map(p => {
    const low = p.qtd <= p.qtd_minima;
    const badge = low ? '<span class="badge badge-red">Repor</span>' : '<span class="badge badge-green">Normal</span>';
    const preco = p.preco ? new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(p.preco) : '—';
    return `<tr><td><strong>${p.nome}</strong></td><td>${p.categoria||'—'}</td><td>${p.qtd}</td><td>${p.qtd_minima}</td><td>${preco}</td><td>${badge}</td></tr>`;
  }).join('');
}

function renderRelMovimentacoes() {
  const semEnt = movimentacoes.filter(m => m.tipo==='entrada' && semanaAtual(m.data)).reduce((a,m)=>a+m.qtd,0);
  const semSai = movimentacoes.filter(m => m.tipo==='saida'  && semanaAtual(m.data)).reduce((a,m)=>a+m.qtd,0);
  const totalMov = Math.max(semEnt, semSai, 1);

  document.getElementById('r-ent').textContent = `${semEnt} un.`;
  document.getElementById('r-sai').textContent = `${semSai} un.`;

  const pctEnt = Math.round((semEnt/totalMov)*100);
  const pctSai = Math.round((semSai/totalMov)*100);
  document.getElementById('r-bar-ent').style.width = `${pctEnt}%`;
  document.getElementById('r-bar-sai').style.width = `${pctSai}%`;
  document.getElementById('r-ent-pct').textContent = `${pctEnt}%`;
  document.getElementById('r-sai-pct').textContent = `${pctSai}%`;

  const saldo = semEnt - semSai;
  const sd = document.getElementById('r-saldo');
  sd.textContent = `${saldo>=0?'+':''}${saldo} un.`;

  // Balanço KPI: verde se positivo, vermelho se negativo, azul se zero
  const kpiBalanco = document.getElementById('r-kpi-balanco');
  kpiBalanco.classList.remove('dash-kpi--green','dash-kpi--red','dash-kpi--blue');
  kpiBalanco.classList.add(saldo > 0 ? 'dash-kpi--green' : saldo < 0 ? 'dash-kpi--red' : 'dash-kpi--blue');

  const movSemana = movimentacoes.filter(m => semanaAtual(m.data));
  const rank = {};
  movSemana.forEach(m => { rank[m.produto_nome] = (rank[m.produto_nome]||0)+m.qtd; });
  const sorted = Object.entries(rank).sort((a,b)=>b[1]-a[1]).slice(0,5);
  const rk = document.getElementById('r-ranking');
  if (!sorted.length) {
    rk.innerHTML = '<div class="empty" style="padding:1rem">Sem movimentações esta semana</div>';
  } else {
    const max = sorted[0][1];
    rk.innerHTML = sorted.map(([nome, qtd]) => `
      <div class="dash-rank-item">
        <div class="dash-rank-header">
          <span class="dash-rank-name">${nome}</span>
          <span class="dash-rank-val">${qtd} un.</span>
        </div>
        <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--blue);width:${Math.round((qtd/max)*100)}%"></div></div>
      </div>`).join('');
  }
}

function renderRelCaixa() {
  const rCaixas = document.getElementById('r-caixas');
  if (!caixas.length) {
    rCaixas.innerHTML = '<div class="empty" style="padding:2rem"><i class="ti ti-cash"></i>Nenhum fechamento de caixa registrado ainda</div>';
    return;
  }
  rCaixas.innerHTML = caixas.map(c => {
    const dataAbertura    = fmt(c.data_abertura);
    const dataFechamento  = c.data_fechamento ? fmt(c.data_fechamento) : '—';
    const trocoInicial    = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(c.troco_inicial||0);
    const totalVendasFmt  = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(c.total_vendas_dinheiro||0);
    const valorFinal      = c.valor_final ? new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(c.valor_final) : '—';
    const diferenca       = c.valor_final ? c.valor_final-(c.troco_inicial+c.total_vendas_dinheiro) : 0;
    const difColor        = diferenca>=0 ? 'var(--green)' : 'var(--red)';
    const difFmt          = (diferenca>=0?'+':'')+new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(diferenca);
    const usuAbr          = c.usuario_abertura?.nome  || 'Desconhecido';
    const usufec          = c.usuario_fechamento?.nome|| 'Desconhecido';
    return `
      <div class="caixa-card">
        <div class="caixa-card-header">
          <span><i class="ti ti-lock-open"></i> Aberto: <strong>${dataAbertura}</strong></span>
          <span><i class="ti ti-lock"></i> Fechado: <strong>${dataFechamento}</strong></span>
        </div>
        <div class="caixa-card-grid">
          <div class="caixa-stat"><span>Troco inicial</span><strong>${trocoInicial}</strong></div>
          <div class="caixa-stat"><span>Vendas (dinheiro)</span><strong>${totalVendasFmt}</strong></div>
          <div class="caixa-stat"><span>Valor final</span><strong>${valorFinal}</strong></div>
          <div class="caixa-stat"><span>Diferença</span><strong style="color:${difColor}">${difFmt}</strong></div>
          <div class="caixa-stat"><span>Aberto por</span><strong>${usuAbr}</strong></div>
          <div class="caixa-stat"><span>Fechado por</span><strong>${usufec}</strong></div>
        </div>
      </div>`;
  }).join('');
}

// ==================== VENDAS ====================
let vendaCategoriaAtiva = 'Todos';
let pastelData = { produtoId: null, preco: 14, recheios: [] };

const PASTEL_RECHEIOS_PADRAO = [
  'Presunto e Queijo', 'Queijo', 'Calabresa', 'Carne', 'Frango', 'Palmito', 'Pizza'
];

const fmtMoeda = (v) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v);

function isProdutoPastel(p) {
  return p.tipo === 'pastel' || (p.nome && p.nome.toLowerCase() === 'pastel');
}

function produtosVenda() {
  return produtos.filter(p => !isProdutoPastel(p));
}

function getCategoriasVenda() {
  const cats = [...new Set(produtosVenda().map(p => p.categoria).filter(Boolean))];
  return ['Todos', ...cats.sort()];
}

async function loadPastelData() {
  try {
    pastelData = await apiRequest('/pastel/recheios');
    if (!pastelData.recheios?.length) {
      pastelData.recheios = PASTEL_RECHEIOS_PADRAO.map((nome, i) => ({ id: i, nome, ordem: i + 1 }));
    }
  } catch {
    const pastel = produtos.find(isProdutoPastel);
    pastelData = {
      produtoId: pastel?.id || null,
      preco: pastel?.preco || 14,
      recheios: PASTEL_RECHEIOS_PADRAO.map((nome, i) => ({ id: i, nome, ordem: i + 1 }))
    };
  }
}

function renderVendas() {
  renderVendasCategorias();
  renderVendasGrid();
  // atualiza subtítulo do botão de salgados
  const sub = document.getElementById('v-salgados-sub');
  if (sub) {
    const disponiveis = produtos.filter(p => isSalgado(p) && p.qtd > 0).length;
    const total = produtos.filter(p => isSalgado(p)).length;
    sub.textContent = total ? `${disponiveis} de ${total} disponíveis` : 'Ver opções';
  }
}

function renderVendasCategorias() {
  const el = document.getElementById('v-categorias');
  if (!el) return;
  el.innerHTML = getCategoriasVenda().map(cat => `
    <button type="button" class="vendas-cat-btn${cat === vendaCategoriaAtiva ? ' active' : ''}"
      onclick="selectVendaCategoria('${cat.replace(/'/g, "\\'")}')">${cat}</button>
  `).join('');
}

function selectVendaCategoria(cat) {
  vendaCategoriaAtiva = cat;
  renderVendasCategorias();
  renderVendasGrid();
}

function renderVendasGrid() {
  const grid = document.getElementById('v-produtos-grid');
  if (!grid) return;

  const busca = (document.getElementById('v-busca')?.value || '').toLowerCase().trim();
  let lista = produtosVenda();

  if (vendaCategoriaAtiva !== 'Todos') {
    lista = lista.filter(p => p.categoria === vendaCategoriaAtiva);
  }
  if (busca) {
    lista = lista.filter(p =>
      p.nome.toLowerCase().includes(busca) ||
      (p.categoria && p.categoria.toLowerCase().includes(busca))
    );
  }

  lista.sort((a, b) => a.nome.localeCompare(b.nome, 'pt-BR'));

  if (!lista.length) {
    grid.innerHTML = '<div class="vendas-grid-empty">Nenhum produto encontrado</div>';
    return;
  }

  grid.innerHTML = lista.map(p => {
    const semEstoque = p.qtd <= 0;
    const preco = p.preco ? fmtMoeda(p.preco) : '—';
    return `
      <button type="button" class="vendas-prod-btn${semEstoque ? ' sem-estoque' : ''}"
        onclick="quickAddProduto(${p.id})" ${semEstoque ? 'disabled' : ''}>
        <span class="vendas-prod-nome">${p.nome}</span>
        <span class="vendas-prod-preco">${preco}</span>
        ${semEstoque ? '<span class="vendas-prod-badge">Sem estoque</span>' : ''}
      </button>
    `;
  }).join('');
}

function quickAddProduto(produtoId) {
  const produto = produtos.find(p => p.id === produtoId);
  if (!produto || isProdutoPastel(produto)) return;

  if (produto.qtd <= 0) {
    toast('Produto sem estoque!', false);
    return;
  }

  const existing = vendaItens.find(i => i.produtoId === produtoId && !i.recheio);
  if (existing) {
    if (existing.qtd + 1 > produto.qtd) {
      toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
      return;
    }
    existing.qtd += 1;
  } else {
    vendaItens.push({
      produtoId: produto.id,
      produtoNome: produto.nome,
      qtd: 1,
      precoUnitario: produto.preco || 0
    });
  }

  renderVendaItens();
  atualizaPreview();
}

function openPastelModal() {
  const modal = document.getElementById('pastel-modal');
  const grid = document.getElementById('pastel-recheios-grid');
  if (!modal || !grid) return;

  const recheios = pastelData.recheios?.length
    ? pastelData.recheios
    : PASTEL_RECHEIOS_PADRAO.map((nome, i) => ({ id: i, nome }));

  grid.innerHTML = recheios.map(r => `
    <button type="button" class="pastel-recheio-btn" onclick="addPastelToVenda('${r.nome.replace(/'/g, "\\'")}')">
      ${r.nome}
    </button>
  `).join('');

  modal.classList.add('show');
}

function closePastelModal(e) {
  if (e && e.target !== e.currentTarget) return;
  const modal = document.getElementById('pastel-modal');
  if (modal) modal.classList.remove('show');
}

function addPastelToVenda(recheio) {
  const pastel = produtos.find(isProdutoPastel);
  const produtoId = pastelData.produtoId || pastel?.id;
  const preco = pastelData.preco || pastel?.preco || 14;

  if (!produtoId) {
    toast('Produto Pastel não cadastrado. Execute o SQL do pastel no Supabase.', false);
    return;
  }

  const existing = vendaItens.find(i => i.produtoId === produtoId && i.recheio === recheio);
  if (existing) {
    existing.qtd += 1;
  } else {
    vendaItens.push({
      produtoId,
      produtoNome: `Pastel (${recheio})`,
      qtd: 1,
      precoUnitario: preco,
      recheio
    });
  }

  closePastelModal();
  renderVendaItens();
  atualizaPreview();
  toast(`Pastel ${recheio} adicionado!`);
}

// ==================== SALGADOS MODAL ====================
function isSalgado(p) {
  return p.categoria && p.categoria.toLowerCase() === 'salgados';
}

function openSalgadosModal() {
  const modal = document.getElementById('salgados-modal');
  const grid  = document.getElementById('salgados-grid');
  if (!modal || !grid) return;

  const lista = produtos.filter(p => isSalgado(p));

  if (!lista.length) {
    grid.innerHTML = '<p style="padding:1rem;color:var(--text-secondary);text-align:center">Nenhum salgado cadastrado.<br>Execute o SQL de salgados no Supabase.</p>';
  } else {
    grid.innerHTML = lista.map(p => {
      const semEstoque = p.qtd <= 0;
      return `
        <button type="button" class="pastel-recheio-btn salgado-btn${semEstoque ? ' salgado-sem-estoque' : ''}"
          onclick="addSalgadoToVenda(${p.id})" ${semEstoque ? 'disabled' : ''}>
          <span class="salgado-nome">${p.nome}</span>
          <span class="salgado-preco">${fmtMoeda(p.preco || 0)}</span>
          ${semEstoque ? '<span class="salgado-badge">Sem estoque</span>' : `<span class="salgado-estoque">${p.qtd} un.</span>`}
        </button>`;
    }).join('');
  }

  modal.classList.add('show');
}

function closeSalgadosModal(e) {
  if (e && e.target !== e.currentTarget) return;
  const modal = document.getElementById('salgados-modal');
  if (modal) modal.classList.remove('show');
}

function addSalgadoToVenda(produtoId) {
  const produto = produtos.find(p => p.id === produtoId);
  if (!produto) return;

  if (produto.qtd <= 0) {
    toast('Salgado sem estoque!', false);
    return;
  }

  const existing = vendaItens.find(i => i.produtoId === produtoId && !i.recheio);
  if (existing) {
    if (existing.qtd + 1 > produto.qtd) {
      toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
      return;
    }
    existing.qtd += 1;
  } else {
    vendaItens.push({
      produtoId: produto.id,
      produtoNome: produto.nome,
      qtd: 1,
      precoUnitario: produto.preco || 0
    });
  }

  closeSalgadosModal();
  renderVendaItens();
  atualizaPreview();
  toast(`${produto.nome} adicionado!`);
}

function changeItemQty(index, delta) {
  const item = vendaItens[index];
  if (!item) return;

  const novo = item.qtd + delta;
  if (novo <= 0) {
    removeItemFromVenda(index);
    return;
  }

  if (!item.recheio) {
    const produto = produtos.find(p => p.id === item.produtoId);
    if (produto && novo > produto.qtd) {
      toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
      return;
    }
  }

  item.qtd = novo;
  renderVendaItens();
  atualizaPreview();
}

function removeItemFromVenda(index) {
  vendaItens.splice(index, 1);
  renderVendaItens();
  atualizaPreview();
}

function renderVendaItens() {
  const container = document.getElementById('v-itens-container');
  const empty = document.getElementById('v-itens-empty');
  const countEl = document.getElementById('v-carrinho-count');
  const totalItens = vendaItens.reduce((s, i) => s + i.qtd, 0);

  if (countEl) countEl.textContent = `${totalItens} ${totalItens === 1 ? 'item' : 'itens'}`;

  if (!vendaItens.length) {
    if (container) container.innerHTML = '';
    if (empty) empty.style.display = 'block';
    return;
  }

  if (empty) empty.style.display = 'none';

  container.innerHTML = vendaItens.map((item, index) => {
    const totalItem = item.qtd * item.precoUnitario;
    return `
      <div class="venda-item-card">
        <div class="venda-item-top">
          <div class="venda-item-info">
            <div class="venda-item-name">${item.produtoNome}</div>
            <div class="venda-item-meta">${fmtMoeda(item.precoUnitario)} / un</div>
          </div>
          <button type="button" class="venda-item-remove" onclick="removeItemFromVenda(${index})">
            <i class="ti ti-trash"></i>
          </button>
        </div>
        <div class="venda-item-bottom">
          <div class="venda-item-qty">
            <button type="button" onclick="changeItemQty(${index}, -1)"><i class="ti ti-minus"></i></button>
            <span>${item.qtd}</span>
            <button type="button" onclick="changeItemQty(${index}, 1)"><i class="ti ti-plus"></i></button>
          </div>
          <div class="venda-item-total">${fmtMoeda(totalItem)}</div>
        </div>
      </div>
    `;
  }).join('');
}

function selectPayment(type) {
  // Update hidden input
  document.getElementById('v-pagamento-hidden').value = type;
  
  // Update UI
  document.querySelectorAll('.payment-option').forEach(opt => {
    opt.classList.remove('active');
    if (opt.id === 'label-' + type) opt.classList.add('active');
  });
}

function selectSaleType(type) {
  // Update hidden input
  document.getElementById('v-tipo-venda-hidden').value = type;
  
  // Update UI
  document.querySelectorAll('.sale-type-option').forEach(opt => {
    opt.classList.remove('active');
    if (opt.id === 'label-' + type) opt.classList.add('active');
  });
  
  // Toggle platform
  const plataformaContainer = document.getElementById('v-plataforma-container');
  plataformaContainer.style.display = type === 'delivery' ? 'block' : 'none';
  if (type !== 'delivery') {
    document.getElementById('v-plataforma').value = '';
  }
}

function atualizaEstiloOpcoes() {
  // This function is replaced by selectPayment and selectSaleType, but keeping for compatibility
  const pagamentoSelecionado = document.getElementById('v-pagamento-hidden').value;
  const tipoVendaSelecionado = document.getElementById('v-tipo-venda-hidden').value;
  
  document.querySelectorAll('.payment-option').forEach(opt => {
    opt.classList.remove('active');
    if (opt.id === 'label-' + pagamentoSelecionado) opt.classList.add('active');
  });
  
  document.querySelectorAll('.sale-type-option').forEach(opt => {
    opt.classList.remove('active');
    if (opt.id === 'label-' + tipoVendaSelecionado) opt.classList.add('active');
  });
}

function togglePlataforma() {
  // This is replaced by selectSaleType
  const tipoVenda = document.getElementById('v-tipo-venda-hidden').value;
  const plataformaContainer = document.getElementById('v-plataforma-container');
  plataformaContainer.style.display = tipoVenda === 'delivery' ? 'block' : 'none';
  if (tipoVenda !== 'delivery') {
    document.getElementById('v-plataforma').value = '';
  }
}

function atualizaPreview() {
  const preview = document.getElementById('v-total-preview');
  const total = vendaItens.reduce((acumulador, item) => {
    return acumulador + (item.qtd * item.precoUnitario);
  }, 0);
  preview.textContent = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(total);
}

async function addVenda() {
  const tipoVenda = document.getElementById('v-tipo-venda-hidden').value;
  const isDelivery = tipoVenda === 'delivery';
  const plataforma = document.getElementById('v-plataforma').value;
  const obs = document.getElementById('v-obs').value.trim();
  const pagamento = document.getElementById('v-pagamento-hidden').value;

  if (!vendaItens.length) {
    toast('Adicione pelo menos um item à venda!', false);
    return;
  }
  if (isDelivery && !plataforma) {
    toast('Selecione uma plataforma para delivery!', false);
    return;
  }

  const totalVenda = vendaItens.reduce((acumulador, item) => {
    return acumulador + (item.qtd * item.precoUnitario);
  }, 0);
  
  try {
    await apiRequest('/vendas', {
      method: 'POST',
      body: JSON.stringify({
        itens: vendaItens,
        total: totalVenda,
        pagamento,
        delivery: isDelivery,
        plataforma: isDelivery ? plataforma : null,
        obs
      })
    });
    
    await loadAllData();
    vendaItens = [];
    vendaCategoriaAtiva = 'Todos';
    document.getElementById('v-busca').value = '';
    document.getElementById('v-plataforma').value = '';
    document.getElementById('v-plataforma-container').style.display = 'none';
    document.getElementById('v-obs').value = '';
    document.getElementById('v-pagamento-hidden').value = 'dinheiro';
    document.getElementById('v-tipo-venda-hidden').value = 'balcao';
    renderVendas();
    renderVendaItens();
    atualizaPreview();
    atualizaEstiloOpcoes();
  renderDashboardProfissional();
  renderEstoque();
  toast('Venda registrada com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao registrar venda!', false);
    console.error(error);
  }
}

// ==================== USUÁRIOS ====================
// Função para mostrar/ocultar senha no login
function toggleLoginSenha() {
  const inputSenha = document.getElementById('login-senha');
  const icone = document.getElementById('login-icone-senha');
  
  if (inputSenha.type === 'password') {
    inputSenha.type = 'text';
    icone.className = 'ti ti-eye-off';
  } else {
    inputSenha.type = 'password';
    icone.className = 'ti ti-eye';
  }
}

// Função para mostrar/ocultar senha no formulário de usuário
function toggleUsuarioSenha(inputId, iconId) {
  const input = document.getElementById(inputId);
  const icon = document.getElementById(iconId);
  
  if (input.type === 'password') {
    input.type = 'text';
    icon.className = 'ti ti-eye-off';
  } else {
    input.type = 'password';
    icon.className = 'ti ti-eye';
  }
}

function toggleFormUsuario() {
  const formCard = document.getElementById('card-form-usuario');
  const editFormCard = document.getElementById('card-form-editar-usuario');
  
  // Fechar formulário de edição se estiver aberto
  if (editFormCard.style.display !== 'none') {
    editFormCard.style.display = 'none';
  }
  
  formCard.style.display = formCard.style.display === 'none' ? 'block' : 'none';
  if (formCard.style.display === 'block') {
    document.getElementById('u-nome').value = '';
    document.getElementById('u-email').value = '';
    document.getElementById('u-senha').value = '';
    document.getElementById('u-role').value = 'funcionario';
  }
}

async function addUsuario() {
  const nome = document.getElementById('u-nome').value.trim();
  const usuario = document.getElementById('u-email').value.trim();
  const senha = document.getElementById('u-senha').value;
  const role = document.getElementById('u-role').value;
  
  if (!nome || !usuario || !senha) {
    toast('Preencha todos os campos!', false);
    return;
  }
  
  try {
    await apiRequest('/usuarios', {
      method: 'POST',
      body: JSON.stringify({ nome, usuario, senha, role })
    });

    await loadAllData();
    renderUsuarios();
    toggleFormUsuario();
    toast('Usuário cadastrado com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao cadastrar usuário!', false);
    console.error(error);
  }
}

async function deleteUsuario(id) {
  if (!confirm('Remover este usuário? Esta ação não pode ser desfeita.')) return;
  
  try {
    await apiRequest(`/usuarios/${id}`, { method: 'DELETE' });
    await loadAllData();
    renderUsuarios();
    toast('Usuário removido com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao remover usuário!', false);
    console.error(error);
  }
}

function editarUsuarioForm(u) {
  // Fechar formulário de novo usuário se estiver aberto
  const addFormCard = document.getElementById('card-form-usuario');
  if (addFormCard.style.display !== 'none') {
    addFormCard.style.display = 'none';
  }
  
  // Abrir formulário de edição
  const editFormCard = document.getElementById('card-form-editar-usuario');
  editFormCard.style.display = 'block';
  
  // Preencher dados
  document.getElementById('editar-u-id').value = u.id;
  document.getElementById('editar-u-nome').value = u.nome;
  document.getElementById('editar-u-usuario').value = u.usuario;
  document.getElementById('editar-u-senha').value = '';
  document.getElementById('editar-u-role').value = u.role;
}

function cancelarEdicaoUsuario() {
  const editFormCard = document.getElementById('card-form-editar-usuario');
  editFormCard.style.display = 'none';
  document.getElementById('editar-u-id').value = '';
  document.getElementById('editar-u-nome').value = '';
  document.getElementById('editar-u-usuario').value = '';
  document.getElementById('editar-u-senha').value = '';
  document.getElementById('editar-u-role').value = 'funcionario';
}

async function editarUsuario() {
  const id = document.getElementById('editar-u-id').value;
  const nome = document.getElementById('editar-u-nome').value.trim();
  const usuario = document.getElementById('editar-u-usuario').value.trim();
  const senha = document.getElementById('editar-u-senha').value;
  const role = document.getElementById('editar-u-role').value;
  
  if (!id || !nome || !usuario) {
    toast('Preencha os campos obrigatórios!', false);
    return;
  }
  
  try {
    const payload = { nome, usuario, role };
    if (senha) payload.senha = senha;
    
    await apiRequest(`/usuarios/${id}`, {
      method: 'PUT',
      body: JSON.stringify(payload)
    });

    await loadAllData();
    renderUsuarios();
    cancelarEdicaoUsuario();
    toast('Usuário atualizado com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao atualizar usuário!', false);
    console.error(error);
  }
}

function renderUsuarios() {
  const tb = document.getElementById('tabela-usuarios');
  const em = document.getElementById('usuarios-empty');
  const ct = document.getElementById('u-count');
  ct.textContent = `${usuarios.length} usuário(s)`;
  
  if (!usuarios.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  
  tb.innerHTML = usuarios.map(u => {
    const roleLabel = u.role === 'dono' ? '<span class="badge badge-amber">Dono</span>' : '<span class="badge badge-blue">Funcionário</span>';
    const editBtn = `<button class="btn btn-sm" onclick='editarUsuarioForm(${JSON.stringify(u).replace(/'/g, "\\'")})'><i class="ti ti-edit"></i></button>`;
    const deleteBtn = u.id === currentUser.id ? '' : `<button class="btn btn-danger btn-sm" onclick="deleteUsuario(${u.id})"><i class="ti ti-trash"></i></button>`;
    return `<tr><td><strong>${u.nome}</strong></td><td>${u.usuario}</td><td>${roleLabel}</td><td style="display:flex;gap:4px">${editBtn} ${deleteBtn}</td></tr>`;
  }).join('');
}

// ==================== CAIXA ====================
async function renderCaixa() {
  try {
    const response = await apiRequest('/caixa');
    const { caixaAtual, totalVendasDinheiro, historico } = response;

    const caixaAbertoDiv = document.getElementById('caixa-aberto');
    const caixaFechadoDiv = document.getElementById('caixa-fechado');
    const historicoDiv = document.getElementById('historico-caixa');

    if (caixaAtual && !caixaAtual.data_fechamento) {
      caixaAbertoDiv.style.display = 'block';
      caixaFechadoDiv.style.display = 'none';

      document.getElementById('caixa-troco-inicial').textContent = 
        new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(caixaAtual.troco_inicial || 0);
      document.getElementById('caixa-total-vendas').textContent = 
        new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(totalVendasDinheiro || 0);
    } else {
      caixaAbertoDiv.style.display = 'none';
      caixaFechadoDiv.style.display = 'block';
    }

    // O histórico dos caixas é exibido apenas na tela de Relatórios
  } catch (error) {
    toast(error.message || 'Erro ao carregar caixa!', false);
    console.error(error);
  }
}

async function abrirCaixa() {
  const trocoInput = document.getElementById('caixa-troco');
  const trocoInicial = parseFloat(trocoInput.value);

  if (isNaN(trocoInicial) || trocoInicial < 0) {
    toast('Informe um valor de troco inicial válido!', false);
    return;
  }

  try {
    await apiRequest('/caixa/abrir', {
      method: 'POST',
      body: JSON.stringify({ troco_inicial: trocoInicial })
    });

    trocoInput.value = '';
    toast('Caixa aberto com sucesso!');
    renderCaixa();
  } catch (error) {
    toast(error.message || 'Erro ao abrir caixa!', false);
    console.error(error);
  }
}

async function fecharCaixa() {
  const valorFinalInput = document.getElementById('caixa-valor-final');
  const valorFinal = parseFloat(valorFinalInput.value);

  if (isNaN(valorFinal) || valorFinal < 0) {
    toast('Informe um valor final válido!', false);
    return;
  }

  try {
    await apiRequest('/caixa/fechar', {
      method: 'POST',
      body: JSON.stringify({ valor_final: valorFinal })
    });

    valorFinalInput.value = '';
    toast('Caixa fechado com sucesso!');
    renderCaixa();
  } catch (error) {
    toast(error.message || 'Erro ao fechar caixa!', false);
    console.error(error);
  }
}

// ==================== INICIALIZAÇÃO ====================
window.addEventListener('DOMContentLoaded', () => {
  if (loadAuth()) {
    loadAllData().then(() => {
      showApp();
    }).catch(error => {
      console.error(error);
      document.getElementById('login-container').style.display = 'flex';
    });
  } else {
    document.getElementById('login-container').style.display = 'flex';
  }
});
