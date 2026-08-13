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

// Consumo de funcionários
let consumoItens = [];
let consumoCategoriaAtiva = 'Todos';
let consumos = [];
let consumoTotalMes = 0;
let consumoFuncionarios = [];
let consumoUsuarios = [];
let consumoUsuarioId = null;
const LIMITE_CONSUMO = 100;

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
let toastTimer = null;

function toast(msg, ok = true) {
  const tipo = ok === true ? 'success' : ok === false ? 'error' : ok;
  showToast(msg, tipo);
}

function toastWarn(msg) {
  showToast(msg, 'warning');
}

function showToast(msg, tipo = 'success') {
  const t = document.getElementById('toast');
  if (!t) return;
  const ic = t.querySelector('.toast-ic i');
  const text = t.querySelector('.toast-msg');
  const cfg = {
    success: { cls: 'toast-success', icon: 'ti ti-check' },
    error:   { cls: 'toast-error',   icon: 'ti ti-alert-circle' },
    warning: { cls: 'toast-warning', icon: 'ti ti-alert-triangle' },
  };
  const c = cfg[tipo] || cfg.success;
  t.className = `toast ${c.cls}`;
  ic.className = c.icon;
  text.textContent = msg;
  // Reinicia a animação sem "fantasma" do toast anterior
  t.style.transition = 'none';
  t.classList.remove('show');
  void t.offsetWidth;
  t.style.transition = '';
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.classList.remove('show'), 3200);
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
  renderConsumoBars();
  nav('dashboard');
}

// Atualizar menu por role
function updateMenuByRole() {
  const isDono = currentUser.role === 'dono';
  
  const navItems = ['dashboard', 'estoque', 'registrar', 'lista-vendas', 'relatorio', 'vendas', 'caixa', 'consumo', 'usuarios'];
  
  navItems.forEach(item => {
    const el = document.getElementById(`nav-${item}`);
    if (el) {
      if (item === 'consumo' || item === 'vendas' || item === 'caixa') {
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
      try {
        consumoFuncionarios = await apiRequest('/consumo/funcionarios');
      } catch (e) {
        console.error('Erro ao carregar consumo dos funcionários:', e);
        consumoFuncionarios = [];
      }
    } else {
      try {
        const consumoResponse = await apiRequest('/consumo');
        consumos = consumoResponse.consumos || [];
        consumoTotalMes = consumoResponse.totalMes || 0;
      } catch (e) {
        console.error('Erro ao carregar consumo:', e);
        consumos = [];
        consumoTotalMes = 0;
      }
      try {
        consumoUsuarios = await apiRequest('/consumo/usuarios');
      } catch (e) {
        console.error('Erro ao carregar usuários do consumo:', e);
        consumoUsuarios = [];
      }
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
  'lista-vendas': 'Vendas',
  relatorio:    'Relatório semanal',
  vendas:       'Comandas/Vendas',
  caixa:        'Caixa',
  consumo:      'Consumo',
  usuarios:     'Usuários'
};

function nav(screen) {
  if (screen === 'consumo') {
    if (currentUser.role !== 'dono' && currentUser.role !== 'funcionario') {
      toast('Acesso negado!', false);
      nav('vendas');
      return;
    }
  } else if (screen !== 'vendas' && screen !== 'caixa' && screen !== 'lista-vendas' && currentUser.role !== 'dono') {
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
  if (screen === 'registrar')    { populateSelect('e-produto'); populateSelect('s-produto'); populateHFiltro(); selectRegTipo(regTipoAtivo); renderHistorico(); }
  if (screen === 'lista-vendas') renderListaVendas();
  if (screen === 'relatorio')    renderRelatorio();
  if (screen === 'caixa')        renderCaixa();
  if (screen === 'usuarios')     renderUsuarios();
  if (screen === 'consumo') {
    consumoItens = [];
    consumoCategoriaAtiva = 'Todos';
    if (currentUser.role === 'dono') {
      renderConsumoDono();
    } else {
      consumoUsuarioId = currentUser.id;
      const label = document.getElementById('c-quem-label');
      if (label) label.textContent = currentUser.nome || 'Quem consumiu';
      Promise.all([loadPastelData(), loadAcaiData()]).then(() => {
        renderConsumo();
        renderConsumoItens();
        atualizaConsumoPreview();
        renderConsumoBars();
      });
    }
  }
  if (screen === 'vendas') {
    vendaItens = [];
    vendaCategoriaAtiva = 'Todos';
    Promise.all([loadPastelData(), loadAcaiData()]).then(() => {
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
  document.getElementById('reg-btn-historico').classList.toggle('active', tipo === 'historico');
  document.getElementById('reg-form-entrada').style.display = tipo === 'entrada' ? 'block' : 'none';
  document.getElementById('reg-form-saida').style.display   = tipo === 'saida'   ? 'block' : 'none';
  document.getElementById('reg-form-historico').style.display = tipo === 'historico' ? 'block' : 'none';
  if (tipo === 'historico') renderHistorico();
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

    const numVenda = v.id ? `#${String(v.id).padStart(4,'0')}` : '';
    const pagClass = v.pagamento === 'dinheiro' ? 'pag-dinheiro' : 'pag-cartao';

    return `
      <div class="vl-card ${pagClass}" onclick="openVendaDetalhe(${v.id})">
        <div class="vl-card-inner">
          <div class="vl-card-left">
            <div class="vl-card-top">
              <span class="vl-card-valor">${total}</span>
              ${numVenda ? `<span class="vl-card-num">${numVenda}</span>` : ''}
            </div>
            <div class="vl-card-prod">${prodResumo}</div>
            <div class="vl-card-data"><i class="ti ti-clock"></i>${fmt(v.data)}</div>
          </div>
          <div class="vl-card-right">
            <div class="vl-card-badges">
              ${pagBadge}
              ${tipoBadge}
            </div>
            <i class="ti ti-chevron-right vl-card-arrow"></i>
          </div>
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
function toggleFormProduto(e) {
  if (e && e.target !== e.currentTarget) return;
  const modal = document.getElementById('novo-produto-modal');
  if (!modal) return;
  const aberto = modal.classList.contains('show');
  if (aberto) {
    modal.classList.remove('show');
  } else {
    document.getElementById('p-nome').value = '';
    document.getElementById('p-cat').value = '';
    document.getElementById('p-qty').value = '';
    document.getElementById('p-min').value = '';
    document.getElementById('p-preco').value = '';
    modal.classList.add('show');
    setTimeout(() => document.getElementById('p-nome').focus(), 120);
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

function openEditarProduto(id) {
  const p = produtos.find(x => x.id === id);
  if (!p) return;
  document.getElementById('edit-id').value    = p.id;
  document.getElementById('edit-nome').value  = p.nome;
  document.getElementById('edit-cat').value   = p.categoria || '';
  document.getElementById('edit-qty').value   = p.qtd;
  document.getElementById('edit-min').value   = p.qtd_minima;
  document.getElementById('edit-preco').value = p.preco || '';
  document.getElementById('editar-produto-modal').classList.add('show');
}

function closeEditarProduto(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('editar-produto-modal').classList.remove('show');
}

async function salvarEdicaoProduto() {
  const id        = parseInt(document.getElementById('edit-id').value);
  const nome      = document.getElementById('edit-nome').value.trim();
  const categoria = document.getElementById('edit-cat').value.trim();
  const qtd       = parseFloat(document.getElementById('edit-qty').value) || 0;
  const qtd_minima= parseInt(document.getElementById('edit-min').value) || 0;
  const preco     = parseFloat(document.getElementById('edit-preco').value) || 0;

  if (!nome) { toast('Informe o nome do produto!', false); return; }

  try {
    await apiRequest(`/produtos/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ nome, categoria, qtd, qtd_minima, preco })
    });
    await loadAllData();
    renderProdutos();
    // atualiza estoque se estiver visível
    if (document.getElementById('screen-estoque').classList.contains('active')) {
      renderEstoqueCats();
      filtrarEstoque();
    }
    closeEditarProduto();
    toast('Produto atualizado com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao atualizar produto!', false);
  }
}

function renderProdutos() {
  const tb = document.getElementById('tabela-produtos');
  const em = document.getElementById('produtos-empty');
  const ct = document.getElementById('p-count');
  const lista = produtos.filter(p => !isProdutoAcai(p));
  ct.textContent = `${lista.length} produto(s)`;
  
  if (!lista.length) {
    tb.innerHTML = '';
    em.style.display = 'block';
    return;
  }
  em.style.display = 'none';
  
  tb.innerHTML = lista.map(p => {
    const low = p.qtd <= p.qtd_minima;
    const badge = low ? '<span class="badge badge-red">Baixo</span>' : '<span class="badge badge-green">OK</span>';
    const precoFormatado = p.preco ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(p.preco) : '—';
    return `<tr>
      <td><strong>${p.nome}</strong></td>
      <td>${p.categoria || '—'}</td>
      <td>${p.qtd}</td>
      <td>${p.qtd_minima}</td>
      <td>${precoFormatado}</td>
      <td>${badge}</td>
      <td style="white-space:nowrap">
        <button class="btn btn-sm" style="margin-right:4px" onclick="openEditarProduto(${p.id})" title="Editar">
          <i class="ti ti-edit"></i>
        </button>
        <button class="btn btn-danger btn-sm" onclick="deleteProduto(${p.id})" title="Remover">
          <i class="ti ti-trash"></i>
        </button>
      </td>
    </tr>`;
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
  const produtoId = parseInt(document.getElementById('e-produto').value);
  const qtdRaw    = parseFloat(document.getElementById('e-qty').value);
  const unidade   = document.getElementById('e-unidade')?.value || 'un';
  const obsInput  = document.getElementById('e-obs').value.trim();

  if (!produtoId) { toast('Selecione um produto!', false); return; }
  if (!qtdRaw || qtdRaw <= 0) { toast('Quantidade deve ser maior que zero!', false); return; }

  // Para "un" arredonda para inteiro; para demais unidades mantém decimal
  const qtd = unidade === 'un' ? Math.round(qtdRaw) : qtdRaw;

  // Monta observação incluindo a unidade
  const obs = obsInput
    ? `[${qtd} ${unidade}] ${obsInput}`
    : `[${qtd} ${unidade}]`;

  const produto = produtos.find(p => p.id === produtoId);

  try {
    await apiRequest('/movimentacoes', {
      method: 'POST',
      body: JSON.stringify({ tipo: 'entrada', produto_id: produtoId, produto_nome: produto.nome, qtd, obs })
    });

    await loadAllData();
    renderHistorico();
    populateSelect('e-produto');
    document.getElementById('e-qty').value = '';
    document.getElementById('e-obs').value = '';
    toast('Entrada registrada com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao registrar entrada!', false);
    console.error('Error in addEntrada:', error);
  }
}

async function addSaida() {
  const produtoId = parseInt(document.getElementById('s-produto').value);
  const qtdRaw    = parseFloat(document.getElementById('s-qty').value);
  const unidade   = document.getElementById('s-unidade')?.value || 'un';
  const obsInput  = document.getElementById('s-obs').value.trim();

  if (!produtoId) { toast('Selecione um produto!', false); return; }
  if (!qtdRaw || qtdRaw <= 0) { toast('Quantidade deve ser maior que zero!', false); return; }

  const qtd = unidade === 'un' ? Math.round(qtdRaw) : qtdRaw;

  const produto = produtos.find(p => p.id === produtoId);
  if (unidade === 'un' && qtd > produto.qtd) {
    toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
    return;
  }

  const obs = obsInput
    ? `[${qtd} ${unidade}] ${obsInput}`
    : `[${qtd} ${unidade}]`;

  try {
    await apiRequest('/movimentacoes', {
      method: 'POST',
      body: JSON.stringify({ tipo: 'saida', produto_id: produtoId, produto_nome: produto.nome, qtd, obs })
    });

    await loadAllData();
    renderHistorico();
    populateSelect('s-produto');
    document.getElementById('s-qty').value = '';
    document.getElementById('s-obs').value = '';
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
let estoqueViewAtiva = localStorage.getItem('estoqueView') || 'dashboard';
let estoqueCatAtiva  = 'Todas';

function setEstoqueView(view) {
  estoqueViewAtiva = view;
  localStorage.setItem('estoqueView', view);
  document.getElementById('estoque-btn-dashboard').classList.toggle('active', view === 'dashboard');
  document.getElementById('estoque-btn-estoque').classList.toggle('active', view === 'estoque');
  document.getElementById('estoque-btn-produtos').classList.toggle('active', view === 'produtos');
  document.getElementById('estoque-view-dashboard').style.display = view === 'dashboard' ? 'block' : 'none';
  document.getElementById('estoque-view-estoque').style.display = view === 'estoque' ? 'block' : 'none';
  document.getElementById('estoque-view-produtos').style.display = view === 'produtos' ? 'block' : 'none';
  if (view === 'produtos') renderProdutos();
}

function renderEstoqueCats() {
  const el = document.getElementById('estoque-cats');
  if (!el) return;
  const cats = ['Todas', ...new Set(produtos.filter(p => !isProdutoAcai(p)).map(p => p.categoria).filter(Boolean))].sort((a, b) => {
    if (a === 'Todas') return -1;
    if (b === 'Todas') return 1;
    return a.localeCompare(b, 'pt-BR');
  });
  el.innerHTML = cats.map(c => `
    <button class="estoque-cat-pill${c === estoqueCatAtiva ? ' active' : ''}"
      onclick="selectEstoqueCat('${c.replace(/'/g, "\\'")}')">
      ${c}
    </button>`).join('');
}

function selectEstoqueCat(cat) {
  estoqueCatAtiva = cat;
  renderEstoqueCats();
  filtrarEstoque();
}

function renderEstoque() {
  setEstoqueView(estoqueViewAtiva);
  renderEstoqueCats();
  const low = produtos.filter(p => !isProdutoAcai(p) && p.qtd <= p.qtd_minima);
  
  document.getElementById('estoque-total-produtos').textContent = produtos.filter(p => !isProdutoAcai(p)).length;
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
    // limpa busca e renderiza via filtrarEstoque
    const buscaEl = document.getElementById('estoque-busca');
    if (buscaEl) buscaEl.value = '';
    filtrarEstoque();
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

function filtrarEstoque() {
  const busca = (document.getElementById('estoque-busca')?.value || '').toLowerCase().trim();
  const dpq   = document.getElementById('estoque-produtos-quantidades');
  const count = document.getElementById('estoque-busca-count');
  if (!dpq) return;

  let lista = produtos.filter(p => !isProdutoAcai(p));

  // filtro categoria
  if (estoqueCatAtiva && estoqueCatAtiva !== 'Todas') {
    lista = lista.filter(p => p.categoria === estoqueCatAtiva);
  }

  // filtro busca
  if (busca) {
    lista = lista.filter(p =>
      p.nome.toLowerCase().includes(busca) ||
      (p.categoria && p.categoria.toLowerCase().includes(busca))
    );
  }

  if (count) count.textContent = (busca || estoqueCatAtiva !== 'Todas') ? `${lista.length} produto(s)` : '';

  if (!lista.length) {
    dpq.innerHTML = `<tr><td colspan="4" style="text-align:center;padding:24px;color:var(--text-muted)">
      Nenhum produto encontrado
    </td></tr>`;
    return;
  }

  const escapedBusca = busca.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  dpq.innerHTML = lista.map(p => {
    const low = p.qtd <= p.qtd_minima;
    const badge = low
      ? '<span class="badge badge-red"><i class="ti ti-alert-triangle"></i> Baixo</span>'
      : '<span class="badge badge-green"><i class="ti ti-check"></i> OK</span>';
    const qtdColor = low ? 'text-red' : 'text-green';
    const nomeDisplay = busca
      ? p.nome.replace(new RegExp(`(${escapedBusca})`, 'gi'), '<mark class="estoque-highlight">$1</mark>')
      : `<strong>${p.nome}</strong>`;

    // Barra de progresso: qtd em relação ao mínimo (verde = folga, âmbar = perto, vermelho = baixo)
    const pct = p.qtd_minima > 0 ? Math.min(Math.round((p.qtd / p.qtd_minima) * 100), 100) : 100;
    const barColor = low ? 'var(--red)' : (p.qtd >= p.qtd_minima * 2 ? 'var(--green)' : 'var(--amber)');

    return `<tr>
      <td>${nomeDisplay}</td>
      <td><span class="est-cat-pill">${p.categoria || '—'}</span></td>
      <td>
        <div class="est-qtd-head">
          <span class="est-qtd-val ${qtdColor}"><strong>${p.qtd}</strong></span>
          <span class="est-qtd-min">mín ${p.qtd_minima}</span>
        </div>
        <div class="est-bar"><div class="est-bar-fill" style="width:${pct}%;background:${barColor}"></div></div>
      </td>
      <td>${badge}</td>
    </tr>`;
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

  // ── Gráficos sparkline ─────────────────────────────────────
  renderDashSparkSemana();
  renderDashSparkMes();
}

function _buildSparkline(containerId, pontos, labels, totalEl, qtdEl, pctEl) {
  const el = document.getElementById(containerId);
  if (!el) return;

  const total = pontos.reduce((s, v) => s + v, 0);
  const qtd   = pontos.filter(v => v > 0).length;
  const fmtM  = v => new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(v);

  if (totalEl) document.getElementById(totalEl).textContent = fmtM(total);
  if (qtdEl)   document.getElementById(qtdEl).textContent   = qtd;
  if (pctEl) {
    const el2 = document.getElementById(pctEl);
    if (el2) {
      // compara primeira metade com segunda metade
      const mid   = Math.floor(pontos.length / 2);
      const prima = pontos.slice(0, mid).reduce((s, v) => s + v, 0);
      const segun = pontos.slice(mid).reduce((s, v) => s + v, 0);
      const diff  = prima > 0 ? Math.round(((segun - prima) / prima) * 100) : null;
      if (diff === null) {
        el2.textContent = '';
      } else {
        el2.textContent = (diff >= 0 ? '↗ ' : '↘ ') + Math.abs(diff) + '%';
        el2.style.color = diff >= 0 ? 'var(--green)' : 'var(--red)';
      }
    }
  }

  const max    = Math.max(...pontos, 0.01);
  const width  = el.clientWidth  || 400;
  const height = 80;
  const pad    = 16;
  const n      = pontos.length;
  const stepX  = (width - pad * 2) / Math.max(n - 1, 1);

  // calcula pontos SVG
  const pts = pontos.map((v, i) => {
    const x = pad + i * stepX;
    const y = pad + (1 - v / max) * (height - pad * 2);
    return { x, y, v, label: labels[i] };
  });

  const pathD = pts.map((p, i) => `${i === 0 ? 'M' : 'L'}${p.x.toFixed(1)},${p.y.toFixed(1)}`).join(' ');

  // área preenchida abaixo
  const areaD = `${pathD} L${pts[pts.length-1].x.toFixed(1)},${height} L${pts[0].x.toFixed(1)},${height} Z`;

  // círculos interativos
  const circles = pts.map((p, i) => `
    <g class="spark-point" data-label="${p.label}" data-val="${fmtM(p.v)}">
      <circle cx="${p.x.toFixed(1)}" cy="${p.y.toFixed(1)}" r="14" fill="transparent" class="spark-hit"/>
      <circle cx="${p.x.toFixed(1)}" cy="${p.y.toFixed(1)}" r="4" fill="var(--blue)" stroke="var(--bg-primary)" stroke-width="2" class="spark-dot"/>
    </g>`).join('');

  el.innerHTML = `
    <div class="spark-tooltip" id="${containerId}-tip"></div>
    <svg width="100%" height="${height}" viewBox="0 0 ${width} ${height}" preserveAspectRatio="none"
         class="spark-svg" onmouseleave="hideSpark('${containerId}')">
      <defs>
        <linearGradient id="sg-${containerId}" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="var(--blue)" stop-opacity="0.25"/>
          <stop offset="100%" stop-color="var(--blue)" stop-opacity="0"/>
        </linearGradient>
      </defs>
      <!-- área -->
      <path d="${areaD}" fill="url(#sg-${containerId})"/>
      <!-- linha -->
      <path d="${pathD}" fill="none" stroke="var(--blue)" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round"/>
      <!-- pontos -->
      ${circles}
    </svg>`;

  // eventos
  el.querySelectorAll('.spark-point').forEach(g => {
    g.addEventListener('mouseenter', (e) => {
      const tip   = document.getElementById(`${containerId}-tip`);
      const label = g.dataset.label;
      const val   = g.dataset.val;
      tip.innerHTML = `<strong>${label}</strong><span>Receita &nbsp;<b>${val}</b></span>`;
      tip.classList.add('show');
      // posição relativa ao wrapper
      const rect = el.getBoundingClientRect();
      const cx   = parseFloat(g.querySelector('circle').getAttribute('cx'));
      const frac = cx / width;
      tip.style.left = Math.min(Math.max(frac * 100, 5), 85) + '%';
    });
    g.addEventListener('mouseleave', () => {});
  });
}

function hideSpark(id) {
  const tip = document.getElementById(`${id}-tip`);
  if (tip) tip.classList.remove('show');
}

function renderDashSparkSemana() {
  const hoje      = new Date();
  const diaSemana = hoje.getDay();
  const segunda   = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);

  const labels = ['Seg','Ter','Qua','Qui','Sex','Sáb','Dom'];
  const valores = [0,0,0,0,0,0,0];

  vendas.forEach(v => {
    const d    = new Date(v.data);
    const diff = Math.floor((d - segunda) / 86400000);
    if (diff >= 0 && diff <= 6) valores[diff] += v.total || 0;
  });

  // só dias até hoje
  const diaAtual = (diaSemana + 6) % 7;
  _buildSparkline(
    'dash-spark-semana',
    valores.slice(0, diaAtual + 1),
    labels.slice(0, diaAtual + 1),
    'dash-spark-semana-total',
    'dash-spark-semana-qtd',
    'dash-spark-semana-pct'
  );
}

function renderDashSparkMes() {
  const hoje  = new Date();
  const mes   = hoje.getMonth();
  const ano   = hoje.getFullYear();
  const meses = ['janeiro','fevereiro','março','abril','maio','junho','julho','agosto','setembro','outubro','novembro','dezembro'];
  const nomeEl = document.getElementById('dash-chart-mes-nome');
  if (nomeEl) nomeEl.textContent = meses[mes];

  const diaAtual  = hoje.getDate();
  const valores   = Array(diaAtual).fill(0);
  const labels    = Array.from({length: diaAtual}, (_, i) => `Dia ${String(i+1).padStart(2,'0')}`);

  vendas.forEach(v => {
    const d = new Date(v.data);
    if (d.getMonth() === mes && d.getFullYear() === ano) {
      const dia = d.getDate() - 1;
      if (dia < diaAtual) valores[dia] += v.total || 0;
    }
  });

  _buildSparkline(
    'dash-spark-mes',
    valores,
    labels,
    'dash-spark-mes-total',
    'dash-spark-mes-qtd',
    'dash-spark-mes-pct'
  );
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
  const lista = produtos.filter(p => !isProdutoAcai(p));
  if (!lista.length) {
    rt.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:20px;color:var(--text-secondary)">Sem produtos cadastrados</td></tr>';
    return;
  }
  rt.innerHTML = lista.map(p => {
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
  const fmt$ = v => new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(v||0);

  rCaixas.innerHTML = caixas.map(c => {
    const diferenca  = c.valor_final ? c.valor_final-(c.troco_inicial+c.total_vendas_dinheiro) : 0;
    const difColor   = diferenca >= 0 ? 'var(--green)' : 'var(--red)';
    const difFmt     = (diferenca>=0?'+':'')+fmt$(diferenca);
    const usuAbr     = c.usuario_abertura?.nome   || 'Desconhecido';
    const usuFec     = c.usuario_fechamento?.nome || 'Desconhecido';
    const retiradas  = c.caixa_retiradas || [];
    const totalRet   = retiradas.reduce((s,r)=>s+parseFloat(r.valor||0),0);

    const retiradasHTML = retiradas.length
      ? `<div class="caixa-ret-section">
          <div class="caixa-ret-title"><i class="ti ti-arrow-bar-up"></i> Retiradas (${retiradas.length})</div>
          ${retiradas.map(r=>`
            <div class="caixa-ret-item">
              <span class="caixa-ret-motivo">${r.motivo}</span>
              <span class="caixa-ret-user">${r.usuario?.nome||'—'}</span>
              <span class="caixa-ret-hora">${fmt(r.data)}</span>
              <span class="caixa-ret-valor">${fmt$(r.valor)}</span>
            </div>`).join('')}
          <div class="caixa-ret-total">Total retirado: <strong>${fmt$(totalRet)}</strong></div>
        </div>`
      : '';

    return `
      <div class="caixa-card">
        <div class="caixa-card-header">
          <span><i class="ti ti-lock-open"></i> Aberto: <strong>${fmt(c.data_abertura)}</strong></span>
          <span><i class="ti ti-lock"></i> Fechado: <strong>${c.data_fechamento ? fmt(c.data_fechamento) : '—'}</strong></span>
        </div>
        <div class="caixa-card-grid">
          <div class="caixa-stat"><span>Troco inicial</span><strong>${fmt$(c.troco_inicial)}</strong></div>
          <div class="caixa-stat"><span>Vendas (dinheiro)</span><strong>${fmt$(c.total_vendas_dinheiro)}</strong></div>
          <div class="caixa-stat"><span>Total retirado</span><strong style="color:var(--red)">${fmt$(totalRet)}</strong></div>
          <div class="caixa-stat"><span>Valor final</span><strong>${c.valor_final ? fmt$(c.valor_final) : '—'}</strong></div>
          <div class="caixa-stat"><span>Diferença</span><strong style="color:${difColor}">${difFmt}</strong></div>
          <div class="caixa-stat"><span>Aberto por</span><strong>${usuAbr}</strong></div>
          <div class="caixa-stat"><span>Fechado por</span><strong>${usuFec}</strong></div>
        </div>
        ${retiradasHTML}
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

// Categorias que só aparecem no estoque — nunca no PDV de vendas
const CATEGORIAS_SO_ESTOQUE = new Set([
  'recheios congelados',
  'embalagens',
  'polpas',
  'descartáveis',
  'descartaveis',
  'insumos',
  'congelados',
  'gelo',
  'condimentos',
]);

function isProdutoPastel(p) {
  return p.tipo === 'pastel' || (p.nome && p.nome.toLowerCase() === 'pastel');
}

function isProdutoAcai(p) {
  return p.tipo === 'acai' || (p.categoria && p.categoria.toLowerCase() === 'açaí');
}

function isSoEstoque(p) {
  if (isProdutoPastel(p)) return true;
  if (isProdutoAcai(p)) return true;
  if (!p.categoria) return false;
  return CATEGORIAS_SO_ESTOQUE.has(p.categoria.toLowerCase());
}

function produtosVenda() {
  return produtos.filter(p => !isSoEstoque(p));
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

let pastelSelecionados = [];
let pastelModo = 'vendas';

function openPastelModal(modo = 'vendas') {
  const modal = document.getElementById('pastel-modal');
  if (!modal) return;

  pastelModo = modo;
  pastelSelecionados = [];
  renderPastelModal();

  modal.classList.add('show');
}

function renderPastelModal() {
  const grid = document.getElementById('pastel-recheios-grid');
  if (!grid) return;

  const recheios = pastelData.recheios?.length
    ? pastelData.recheios
    : PASTEL_RECHEIOS_PADRAO.map((nome, i) => ({ id: i, nome }));

  grid.innerHTML = recheios.map(r => `
    <button type="button" class="pastel-recheio-btn${pastelSelecionados.includes(r.nome) ? ' selected' : ''}"
      onclick="togglePastelRecheio('${r.nome.replace(/'/g, "\\'")}')">
      ${r.nome}
    </button>
  `).join('');

  const texto = document.getElementById('pastel-selecao-texto');
  if (texto) texto.textContent = pastelSelecionados.length ? pastelSelecionados.join(' + ') : 'Nenhum sabor';

  const btn = document.getElementById('pastel-add-btn');
  if (btn) btn.disabled = pastelSelecionados.length === 0;
}

function togglePastelRecheio(nome) {
  const idx = pastelSelecionados.indexOf(nome);
  if (idx >= 0) {
    pastelSelecionados.splice(idx, 1);
  } else if (pastelSelecionados.length >= 3) {
    toast('Máximo de 3 sabores por pastel!', false);
    return;
  } else {
    pastelSelecionados.push(nome);
  }
  renderPastelModal();
}

function confirmPastelAdd() {
  if (!pastelSelecionados.length) return;
  addPastelToVenda(pastelSelecionados.join('+'), pastelModo);
}

function closePastelModal(e) {
  if (e && e.target !== e.currentTarget) return;
  const modal = document.getElementById('pastel-modal');
  if (modal) modal.classList.remove('show');
}

function addPastelToVenda(recheio, modo = 'vendas') {
  const itens = modo === 'consumo' ? consumoItens : vendaItens;
  const pastel = produtos.find(isProdutoPastel);
  const produtoId = pastelData.produtoId || pastel?.id;
  const preco = pastelData.preco || pastel?.preco || 14;

  if (!produtoId) {
    toast('Produto Pastel não cadastrado. Execute o SQL do pastel no Supabase.', false);
    return;
  }

  const existing = itens.find(i => i.produtoId === produtoId && i.recheio === recheio);
  if (existing) {
    existing.qtd += 1;
  } else {
    itens.push({
      produtoId,
      produtoNome: `Pastel (${recheio})`,
      qtd: 1,
      precoUnitario: preco,
      recheio
    });
  }

  closePastelModal();
  if (modo === 'consumo') {
    renderConsumoItens();
    atualizaConsumoPreview();
  } else {
    renderVendaItens();
    atualizaPreview();
  }
  toast(`Pastel ${recheio} adicionado!`);
}

// ==================== SALGADOS MODAL ====================
function isSalgado(p) {
  return p.categoria && p.categoria.toLowerCase() === 'salgados';
}

function openSalgadosModal(modo = 'vendas') {
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
          onclick="addSalgadoToVenda(${p.id}, '${modo}')" ${semEstoque ? 'disabled' : ''}>
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

function addSalgadoToVenda(produtoId, modo = 'vendas') {
  const itens = modo === 'consumo' ? consumoItens : vendaItens;
  const produto = produtos.find(p => p.id === produtoId);
  if (!produto) return;

  if (produto.qtd <= 0) {
    toast('Salgado sem estoque!', false);
    return;
  }

  const existing = itens.find(i => i.produtoId === produtoId && !i.recheio);
  if (existing) {
    if (existing.qtd + 1 > produto.qtd) {
      toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
      return;
    }
    existing.qtd += 1;
  } else {
    itens.push({
      produtoId: produto.id,
      produtoNome: produto.nome,
      qtd: 1,
      precoUnitario: produto.preco || 0
    });
  }

  closeSalgadosModal();
  if (modo === 'consumo') {
    renderConsumoItens();
    atualizaConsumoPreview();
  } else {
    renderVendaItens();
    atualizaPreview();
  }
  toast(`${produto.nome} adicionado!`);
}

// ==================== AÇAÍ MODAL ====================
let acaiData = { tamanhos: [], complementos: [] };
let acaiModo = 'vendas';
let acaiTamanhoId = null;
let acaiComplementosSel = [];

async function loadAcaiData() {
  try {
    const data = await apiRequest('/acai');
    acaiData = { tamanhos: data.tamanhos || [], complementos: data.complementos || [] };
  } catch (e) {
    console.error('Erro ao carregar açaí:', e);
  }
}

function openAcaiModal(modo = 'vendas') {
  acaiModo = modo;
  acaiTamanhoId = null;
  acaiComplementosSel = [];

  const modal = document.getElementById('acai-modal');
  const tEl = document.getElementById('acai-tamanhos');
  const cEl = document.getElementById('acai-complementos');
  if (!modal || !tEl || !cEl) return;

  if (!acaiData.tamanhos.length) {
    toast('Açaí não cadastrado. Execute o SQL de açaí no Supabase.', false);
    return;
  }

  tEl.innerHTML = acaiData.tamanhos.map(t => `
    <button type="button" class="acai-tam-btn"
      onclick="selectAcaiTamanho(${t.id})" data-id="${t.id}">
      <span class="acai-tam-nome">${t.nome}</span>
      <span class="acai-tam-preco">${fmtMoeda(t.preco || 0)}</span>
    </button>`).join('');

  cEl.innerHTML = acaiData.complementos.map(c => `
    <button type="button" class="acai-comp-btn" onclick="toggleAcaiComplemento(${c.id})" data-id="${c.id}">
      <span class="acai-comp-nome">${c.nome}</span>
      <span class="acai-comp-preco">${c.preco > 0 ? `+${fmtMoeda(c.preco)}` : 'Grátis'}</span>
    </button>
  `).join('');

  atualizaAcaiPreview();
  modal.classList.add('show');
}

function closeAcaiModal(e) {
  if (e && e.target !== e.currentTarget) return;
  const modal = document.getElementById('acai-modal');
  if (modal) modal.classList.remove('show');
}

function selectAcaiTamanho(id) {
  acaiTamanhoId = id;
  document.querySelectorAll('#acai-tamanhos .acai-tam-btn').forEach(b => {
    b.classList.toggle('active', parseInt(b.dataset.id) === id);
  });
  atualizaAcaiPreview();
}

function toggleAcaiComplemento(id) {
  const idx = acaiComplementosSel.indexOf(id);
  if (idx >= 0) {
    acaiComplementosSel.splice(idx, 1);
  } else {
    acaiComplementosSel.push(id);
  }
  const btn = document.querySelector(`#acai-complementos .acai-comp-btn[data-id="${id}"]`);
  if (btn) btn.classList.toggle('active');
  atualizaAcaiPreview();
}

function atualizaAcaiPreview() {
  const t = acaiData.tamanhos.find(x => x.id === acaiTamanhoId);
  let total = t ? (t.preco || 0) : 0;
  acaiComplementosSel.forEach(id => {
    const c = acaiData.complementos.find(x => x.id === id);
    if (c) total += (c.preco || 0);
  });
  const el = document.getElementById('acai-total-preview');
  if (el) el.textContent = fmtMoeda(total);
  const btn = document.getElementById('acai-add-btn');
  if (btn) btn.disabled = !t;
}

function addAcaiToVenda() {
  const t = acaiData.tamanhos.find(x => x.id === acaiTamanhoId);
  if (!t) {
    toast('Selecione o tamanho!', false);
    return;
  }

  const itens = acaiModo === 'consumo' ? consumoItens : vendaItens;
  const comps = acaiData.complementos.filter(c => acaiComplementosSel.includes(c.id));
  const compsNome = comps.map(c => c.nome).join(' + ');
  const precoUnit = (t.preco || 0) + comps.reduce((s, c) => s + (c.preco || 0), 0);
  const nome = comps.length
    ? `${t.nome} (${compsNome})`
    : t.nome;

  const existing = itens.find(i => i.produtoId === t.id && (i.complementos || '') === compsNome);
  if (existing) {
    existing.qtd += 1;
  } else {
    itens.push({
      produtoId: t.id,
      produtoNome: nome,
      qtd: 1,
      precoUnitario: precoUnit,
      complementos: compsNome
    });
  }

  closeAcaiModal();
  if (acaiModo === 'consumo') {
    renderConsumoItens();
    atualizaConsumoPreview();
  } else {
    renderVendaItens();
    atualizaPreview();
  }
  toast('Açaí adicionado!');
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

// ==================== CONSUMO (funcionários) ====================
function renderConsumo() {
  const sc = document.getElementById('screen-consumo');
  if (sc) sc.classList.add('pdv-mode');
  const funcView = document.getElementById('consumo-funcionario-view');
  const donoView = document.getElementById('consumo-dono-view');
  if (funcView) funcView.style.display = 'flex';
  if (donoView) donoView.style.display = 'none';
  renderConsumoCategorias();
  renderConsumoGrid();
  renderConsumoBars();
}

async function renderConsumoDono() {
  const sc = document.getElementById('screen-consumo');
  if (sc) sc.classList.remove('pdv-mode');
  const funcView = document.getElementById('consumo-funcionario-view');
  const donoView = document.getElementById('consumo-dono-view');
  if (funcView) funcView.style.display = 'none';
  if (donoView) donoView.style.display = 'block';

  try {
    consumoFuncionarios = await apiRequest('/consumo/funcionarios');
  } catch (e) {
    console.error('Erro ao carregar consumo dos funcionários:', e);
    consumoFuncionarios = [];
  }

  const totalGeral = consumoFuncionarios.reduce((s, f) => s + (f.totalMes || 0), 0);
  const media = consumoFuncionarios.length ? totalGeral / consumoFuncionarios.length : 0;

  document.getElementById('cd-count').textContent = consumoFuncionarios.length;
  document.getElementById('cd-total').textContent = fmtMoeda(totalGeral);
  document.getElementById('cd-media').textContent = fmtMoeda(media);

  const grid = document.getElementById('cd-grid');
  if (!consumoFuncionarios.length) {
    grid.innerHTML = '<div class="empty"><i class="ti ti-users"></i>Nenhum funcionário cadastrado ainda.</div>';
    return;
  }

  grid.innerHTML = consumoFuncionarios.map(f => {
    const pct = Math.min(((f.totalMes || 0) / LIMITE_CONSUMO) * 100, 100);
    const restante = Math.max(LIMITE_CONSUMO - (f.totalMes || 0), 0);
    const nConsumos = f.consumos?.length || 0;
    const limite = (f.totalMes || 0) >= LIMITE_CONSUMO
      ? '<span class="badge badge-red">Limite atingido</span>'
      : (nConsumos ? `<span class="badge badge-blue">${nConsumos} consumo${nConsumos === 1 ? '' : 's'}</span>` : '');
    return `
      <div class="cd-card" onclick="openConsumoDonoDetalhe(${f.id})">
        <div class="cd-card-top">
          <div class="cd-avatar"><i class="ti ti-user-circle"></i></div>
          <div class="cd-info">
            <div class="cd-nome">${f.nome}</div>
            <div class="cd-user">@${f.usuario}</div>
          </div>
          <div class="cd-valor">${fmtMoeda(f.totalMes || 0)}</div>
        </div>
        <div class="progress-bar cd-progress">
          <div class="progress-fill" style="width:${pct}%;background:var(--blue)"></div>
        </div>
        <div class="cd-card-foot">
          <span>${fmtMoeda(restante)} restantes</span>
          <span>${limite}</span>
        </div>
      </div>`;
  }).join('');
}

function openConsumoDonoDetalhe(usuarioId) {
  const f = consumoFuncionarios.find(x => x.id === usuarioId);
  if (!f) return;

  document.getElementById('cd-detalhe-nome').textContent = f.nome;
  document.getElementById('cd-detalhe-total').textContent = fmtMoeda(f.totalMes || 0);

  const body = document.getElementById('consumo-detalhe-body');
  if (!f.consumos?.length) {
    body.innerHTML = '<div class="empty"><i class="ti ti-wallet"></i>Nenhum consumo registrado neste mês.</div>';
  } else {
    body.innerHTML = f.consumos.map(c => {
      const itensHTML = (c.itens || []).map(i => {
        const sub = fmtMoeda((i.preco_unitario || 0) * i.qtd);
        return `<div class="vd-item">
          <span class="vd-item-nome">${i.produto_nome}${i.recheio ? ` <small>(${i.recheio})</small>` : ''}</span>
          <span class="vd-item-qty">× ${i.qtd}</span>
          <span class="vd-item-sub">${sub}</span>
        </div>`;
      }).join('') || '<div class="empty" style="padding:.5rem">Sem itens</div>';

      return `
        <div class="cd-consumo">
          <div class="cd-consumo-header">
            <span><i class="ti ti-clock"></i> ${fmt(c.data)}</span>
            <strong>${fmtMoeda(c.total || 0)}</strong>
          </div>
          ${c.obs ? `<div class="cd-consumo-obs"><i class="ti ti-note"></i> ${c.obs}</div>` : ''}
          <div class="vd-itens">${itensHTML}</div>
        </div>`;
    }).join('');
  }

  document.getElementById('consumo-detalhe-modal').classList.add('show');
}

function closeConsumoDonoDetalhe(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('consumo-detalhe-modal').classList.remove('show');
}

// ==================== QUEM CONSUMIU (funcionário) ====================
async function openConsumoQuem() {
  try {
    consumoUsuarios = await apiRequest('/consumo/usuarios');
  } catch (e) {
    toast('Erro ao carregar usuários!', false);
    return;
  }

  const body = document.getElementById('consumo-quem-body');
  if (!consumoUsuarios.length) {
    body.innerHTML = '<div class="empty"><i class="ti ti-users"></i>Nenhum funcionário cadastrado.</div>';
  } else {
    body.innerHTML = consumoUsuarios.map(u => `
      <div class="consumo-quem-row${u.id === consumoUsuarioId ? ' active' : ''}" onclick="selectConsumoQuem(${u.id})">
        <div class="consumo-quem-avatar"><i class="ti ti-user-circle"></i></div>
        <div class="consumo-quem-info">
          <div class="consumo-quem-nome">${u.nome}</div>
          <div class="consumo-quem-user">@${u.usuario}</div>
        </div>
        ${u.id === consumoUsuarioId ? '<i class="ti ti-check consumo-quem-check"></i>' : ''}
      </div>
    `).join('');
  }

  document.getElementById('consumo-quem-modal').classList.add('show');
}

function selectConsumoQuem(id) {
  consumoUsuarioId = id;
  const u = consumoUsuarios.find(x => x.id === id);
  const label = document.getElementById('c-quem-label');
  if (label) label.textContent = u ? u.nome : 'Selecionar quem consumiu';
  closeConsumoQuem();
}

function closeConsumoQuem(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('consumo-quem-modal').classList.remove('show');
}

function renderConsumoCategorias() {
  const el = document.getElementById('c-categorias');
  if (!el) return;
  el.innerHTML = getCategoriasVenda().map(cat => `
    <button type="button" class="vendas-cat-btn${cat === consumoCategoriaAtiva ? ' active' : ''}"
      onclick="selectConsumoCategoria('${cat.replace(/'/g, "\\'")}')">${cat}</button>
  `).join('');
}

function selectConsumoCategoria(cat) {
  consumoCategoriaAtiva = cat;
  renderConsumoCategorias();
  renderConsumoGrid();
}

function renderConsumoGrid() {
  const grid = document.getElementById('c-produtos-grid');
  if (!grid) return;

  const busca = (document.getElementById('c-busca')?.value || '').toLowerCase().trim();
  let lista = produtosVenda();

  if (consumoCategoriaAtiva !== 'Todos') {
    lista = lista.filter(p => p.categoria === consumoCategoriaAtiva);
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
        onclick="consumoQuickAdd(${p.id})" ${semEstoque ? 'disabled' : ''}>
        <span class="vendas-prod-nome">${p.nome}</span>
        <span class="vendas-prod-preco">${preco}</span>
        ${semEstoque ? '<span class="vendas-prod-badge">Sem estoque</span>' : ''}
      </button>
    `;
  }).join('');
}

function consumoQuickAdd(produtoId) {
  const produto = produtos.find(p => p.id === produtoId);
  if (!produto || isProdutoPastel(produto)) return;

  if (produto.qtd <= 0) {
    toast('Produto sem estoque!', false);
    return;
  }

  const existing = consumoItens.find(i => i.produtoId === produtoId && !i.recheio);
  if (existing) {
    if (existing.qtd + 1 > produto.qtd) {
      toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
      return;
    }
    existing.qtd += 1;
  } else {
    consumoItens.push({
      produtoId: produto.id,
      produtoNome: produto.nome,
      qtd: 1,
      precoUnitario: produto.preco || 0
    });
  }

  renderConsumoItens();
  atualizaConsumoPreview();
}

function consumoChangeQty(index, delta) {
  const item = consumoItens[index];
  if (!item) return;

  const novo = item.qtd + delta;
  if (novo <= 0) {
    consumoItens.splice(index, 1);
    renderConsumoItens();
    atualizaConsumoPreview();
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
  renderConsumoItens();
  atualizaConsumoPreview();
}

function consumoRemoveItem(index) {
  consumoItens.splice(index, 1);
  renderConsumoItens();
  atualizaConsumoPreview();
}

function renderConsumoItens() {
  const container = document.getElementById('c-itens-container');
  const empty = document.getElementById('c-itens-empty');
  const countEl = document.getElementById('c-carrinho-count');
  const totalItens = consumoItens.reduce((s, i) => s + i.qtd, 0);

  if (countEl) countEl.textContent = `${totalItens} ${totalItens === 1 ? 'item' : 'itens'}`;

  if (!consumoItens.length) {
    if (container) container.innerHTML = '';
    if (empty) empty.style.display = 'block';
    return;
  }

  if (empty) empty.style.display = 'none';

  container.innerHTML = consumoItens.map((item, index) => {
    const totalItem = item.qtd * item.precoUnitario;
    return `
      <div class="venda-item-card">
        <div class="venda-item-top">
          <div class="venda-item-info">
            <div class="venda-item-name">${item.produtoNome}</div>
            <div class="venda-item-meta">${fmtMoeda(item.precoUnitario)} / un</div>
          </div>
          <button type="button" class="venda-item-remove" onclick="consumoRemoveItem(${index})">
            <i class="ti ti-trash"></i>
          </button>
        </div>
        <div class="venda-item-bottom">
          <div class="venda-item-qty">
            <button type="button" onclick="consumoChangeQty(${index}, -1)"><i class="ti ti-minus"></i></button>
            <span>${item.qtd}</span>
            <button type="button" onclick="consumoChangeQty(${index}, 1)"><i class="ti ti-plus"></i></button>
          </div>
          <div class="venda-item-total">${fmtMoeda(totalItem)}</div>
        </div>
      </div>
    `;
  }).join('');
}

function atualizaConsumoPreview() {
  const preview = document.getElementById('c-total-preview');
  const warnEl = document.getElementById('c-limite-warn');
  const total = consumoItens.reduce((acumulador, item) => {
    return acumulador + (item.qtd * item.precoUnitario);
  }, 0);
  if (preview) preview.textContent = fmtMoeda(total);

  // Aviso quando o carrinho passa do limite do mês (somente para o próprio usuário)
  if (!consumoUsuarioId || consumoUsuarioId === currentUser.id) {
    const disponivel = Math.max(LIMITE_CONSUMO - consumoTotalMes, 0);
    const acima = total > disponivel;
    if (preview) preview.classList.toggle('over-limit', acima);
    if (warnEl) warnEl.style.display = acima ? 'flex' : 'none';
  } else {
    if (preview) preview.classList.remove('over-limit');
    if (warnEl) warnEl.style.display = 'none';
  }
}

async function addConsumo() {
  if (!consumoItens.length) {
    toast('Adicione pelo menos um item!', false);
    return;
  }

  const obs = document.getElementById('c-obs').value.trim();
  const totalConsumo = consumoItens.reduce((acumulador, item) => {
    return acumulador + (item.qtd * item.precoUnitario);
  }, 0);

  // Não bloqueia: apenas notifica quando estiver passando do limite
  let acimaLimite = false;
  if (!consumoUsuarioId || consumoUsuarioId === currentUser.id) {
    const disponivel = Math.max(LIMITE_CONSUMO - consumoTotalMes, 0);
    acimaLimite = totalConsumo > disponivel;
    if (acimaLimite) {
      toastWarn(`Atenção! Você está passando do seu limite de ${fmtMoeda(LIMITE_CONSUMO)} do mês.`);
    }
  }

  try {
    const resp = await apiRequest('/consumo', {
      method: 'POST',
      body: JSON.stringify({
        itens: consumoItens,
        obs,
        usuario_id: consumoUsuarioId || currentUser.id
      })
    });

    await loadAllData();
    consumoItens = [];
    consumoCategoriaAtiva = 'Todos';
    const busca = document.getElementById('c-busca');
    if (busca) busca.value = '';
    document.getElementById('c-obs').value = '';
    renderConsumo();
    renderConsumoItens();
    atualizaConsumoPreview();
    renderConsumoBars();
    if (resp?.acimaLimite || acimaLimite) {
      toastWarn('Consumo registrado acima do limite mensal!');
    } else {
      toast('Consumo registrado com sucesso!');
    }
  } catch (error) {
    toast(error.message || 'Erro ao registrar consumo!', false);
    console.error(error);
  }
}

function renderConsumoBars() {
  const usado = consumoTotalMes || 0;
  const pct = Math.min((usado / LIMITE_CONSUMO) * 100, 100);
  const restante = Math.max(LIMITE_CONSUMO - usado, 0);
  const restText = restante > 0 ? `${fmtMoeda(restante)} restantes` : 'Limite atingido';

  // Barra na sidebar (parte da account)
  const wrapper = document.getElementById('consumo-bar-wrapper');
  if (wrapper) {
    wrapper.style.display = currentUser.role === 'funcionario' ? 'block' : 'none';
  }
  const fillSide = document.getElementById('consumo-bar-fill');
  if (fillSide) fillSide.style.width = pct + '%';
  const valSide = document.getElementById('consumo-bar-valor');
  if (valSide) valSide.textContent = fmtMoeda(usado);
  const restSide = document.getElementById('consumo-bar-restante');
  if (restSide) restSide.textContent = restText;
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
    const { caixaAtual, totalVendasDinheiro, totalRetiradas, retiradas, historico } = response;

    const caixaAbertoDiv  = document.getElementById('caixa-aberto');
    const caixaFechadoDiv = document.getElementById('caixa-fechado');

    const fmt$ = v => new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(v||0);

    if (caixaAtual && !caixaAtual.data_fechamento) {
      caixaAbertoDiv.style.display  = 'block';
      caixaFechadoDiv.style.display = 'none';

      const troco   = caixaAtual.troco_inicial || 0;
      const vendas  = totalVendasDinheiro || 0;
      const ret     = totalRetiradas || 0;
      const saldo   = troco + vendas - ret;

      document.getElementById('caixa-troco-inicial').textContent    = fmt$(troco);
      document.getElementById('caixa-total-vendas').textContent     = fmt$(vendas);
      document.getElementById('caixa-total-retiradas').textContent  = fmt$(ret);
      document.getElementById('caixa-saldo-esperado').textContent   = fmt$(saldo);

      // Lista de retiradas
      const listaEl = document.getElementById('caixa-retiradas-lista');
      if (!retiradas || !retiradas.length) {
        listaEl.innerHTML = '<div class="empty"><i class="ti ti-receipt-off"></i>Nenhuma retirada registrada.</div>';
      } else {
        listaEl.innerHTML = `
          <table>
            <thead><tr><th>Horário</th><th>Motivo</th><th>Usuário</th><th style="text-align:right">Valor</th></tr></thead>
            <tbody>
              ${retiradas.map(r => `
                <tr>
                  <td style="white-space:nowrap">${fmt(r.data)}</td>
                  <td>${r.motivo}</td>
                  <td>${r.usuario?.nome || '—'}</td>
                  <td style="text-align:right;font-weight:700;color:var(--red)">${fmt$(r.valor)}</td>
                </tr>`).join('')}
            </tbody>
            <tfoot>
              <tr>
                <td colspan="3" style="text-align:right;font-weight:700;padding-top:10px">Total retirado:</td>
                <td style="text-align:right;font-weight:800;color:var(--red);padding-top:10px">${fmt$(ret)}</td>
              </tr>
            </tfoot>
          </table>`;
      }
    } else {
      caixaAbertoDiv.style.display  = 'none';
      caixaFechadoDiv.style.display = 'block';
    }

    // Atualiza caixas no histórico do relatório
    if (historico) {
      caixas = historico;
    }
  } catch (error) {
    toast(error.message || 'Erro ao carregar caixa!', false);
    console.error(error);
  }
}

async function registrarRetirada() {
  const valor  = parseFloat(document.getElementById('retirada-valor')?.value);
  const motivo = document.getElementById('retirada-motivo')?.value?.trim();

  if (!valor || valor <= 0) { toast('Informe um valor válido!', false); return; }
  if (!motivo)              { toast('Informe o motivo da retirada!', false); return; }

  try {
    await apiRequest('/caixa/retirada', {
      method: 'POST',
      body: JSON.stringify({ valor, motivo })
    });

    document.getElementById('retirada-valor').value  = '';
    document.getElementById('retirada-motivo').value = '';
    toast(`Retirada de ${new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(valor)} registrada!`);
    renderCaixa();
  } catch (error) {
    toast(error.message || 'Erro ao registrar retirada!', false);
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
