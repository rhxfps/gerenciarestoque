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
let adminTipoAtivo = 'usuarios';
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

// ==================== CONFIRMAÇÃO NO SITE (aceitar/recusar) ====================
let confirmCallback = null;

function showConfirm({ title = 'Tem certeza?', message = '', confirmText = 'Confirmar', cancelText = 'Cancelar', danger = true, icon = 'ti ti-alert-triangle', onConfirm = null } = {}) {
  document.getElementById('confirm-title').textContent = title;
  document.getElementById('confirm-message').textContent = message;
  document.getElementById('confirm-icon').innerHTML = `<i class="${icon}"></i>`;
  document.getElementById('confirm-ok-btn').innerHTML = `<i class="ti ti-check"></i> ${confirmText}`;
  document.getElementById('confirm-cancel-btn').innerHTML = `<i class="ti ti-x"></i> ${cancelText}`;
  const ok = document.getElementById('confirm-ok-btn');
  ok.classList.toggle('btn-danger', danger);
  ok.classList.toggle('btn-primary', !danger);
  document.getElementById('confirm-modal').classList.toggle('danger', danger);
  confirmCallback = onConfirm;
  document.getElementById('confirm-modal').classList.add('show');
}

function closeConfirmModal(e) {
  if (e && e.target !== e.currentTarget) return;
  confirmCallback = null;
  document.getElementById('confirm-modal').classList.remove('show');
}

function confirmOk() {
  const cb = confirmCallback;
  confirmCallback = null;
  document.getElementById('confirm-modal').classList.remove('show');
  if (cb) cb();
}

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

  // Itens do dono: dashboard, estoque, lista-vendas, relatorio
  const donoItems = ['dashboard', 'estoque', 'lista-vendas', 'relatorio', 'gastos'];
  donoItems.forEach(item => {
    const el = document.getElementById(`nav-${item}`);
    if (el) el.style.display = isDono ? 'block' : 'none';
  });

  // Registrar: visível para ambos
  const regEl = document.getElementById('nav-registrar');
  if (regEl) regEl.style.display = 'block';

  // Contagem: visível para ambos
  const contEl = document.getElementById('nav-contagem');
  if (contEl) contEl.style.display = 'block';

  // Seção Admin: só dono
  const adminSection = document.getElementById('nav-admin-section');
  if (adminSection) adminSection.style.display = isDono ? 'flex' : 'none';
  const mobileAdmin = document.getElementById('mobile-admin-section');
  if (mobileAdmin) mobileAdmin.style.display = isDono ? 'flex' : 'none';

  // Separador "Funcionários": só dono vê o label
  const funcSection = document.getElementById('nav-func-section');
  if (funcSection) funcSection.style.display = isDono ? 'flex' : 'none';
  const mobileFunc = document.getElementById('mobile-func-section');
  if (mobileFunc) mobileFunc.style.display = isDono ? 'flex' : 'none';

  // Itens da seção funcionários: sempre visíveis
  const funcItems = ['minhas-vendas', 'vendas', 'caixa', 'consumo'];
  funcItems.forEach(item => {
    const el = document.getElementById(`nav-${item}`);
    if (el) el.style.display = 'block';
  });

  const userRoleEl = document.getElementById('user-role');
  if (userRoleEl) {
    userRoleEl.textContent = isDono ? 'Dono' : 'Funcionário';
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
      gastosData = await apiRequest('/gastos').catch(() => []);
    }

    preencherFiltroProduto();

    if (currentUser.role === 'dono') {
      const [usr, caixaRes, consumoFunc, meuConsumo] = await Promise.all([
        apiRequest('/usuarios').catch(() => []),
        apiRequest('/caixa').catch(() => ({ historico: [] })),
        apiRequest('/consumo/funcionarios').catch(() => []),
        apiRequest('/consumo').catch(() => ({ consumos: [], totalMes: 0 }))
      ]);
      usuarios = usr || [];
      caixas = (caixaRes && caixaRes.historico) || [];
      consumoFuncionarios = consumoFunc || [];
      consumos = (meuConsumo && meuConsumo.consumos) || [];
      consumoTotalMes = (meuConsumo && meuConsumo.totalMes) || 0;
    } else {
      const [consumoRes, consumoUsr] = await Promise.all([
        apiRequest('/consumo').catch(() => ({ consumos: [], totalMes: 0 })),
        apiRequest('/consumo/usuarios').catch(() => [])
      ]);
      consumos = (consumoRes && consumoRes.consumos) || [];
      consumoTotalMes = (consumoRes && consumoRes.totalMes) || 0;
      consumoUsuarios = consumoUsr || [];
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
  'minhas-vendas': 'Registrados',
  relatorio:    'Relatório semanal',
  vendas:       'Comandas/Vendas',
  caixa:        'Caixa',
  consumo:      'Consumo',
  contagem:     'Contagem de Estoque',
  gastos:       'Gastos',
  admin:        'Admin',
  usuarios:     'Usuários'
};

function nav(screen) {
  if (screen === 'consumo') {
    if (currentUser.role !== 'dono' && currentUser.role !== 'funcionario') {
      toast('Acesso negado!', false);
      nav('vendas');
      return;
    }
  } else if (screen !== 'vendas' && screen !== 'caixa' && screen !== 'lista-vendas' && screen !== 'minhas-vendas' && screen !== 'registrar' && screen !== 'contagem' && currentUser.role !== 'dono') {
    toast('Acesso negado!', false);
    nav('vendas');
    return;
  }

  // Usuários agora fica dentro do Admin
  if (screen === 'usuarios') {
    adminTipoAtivo = 'usuarios';
    screen = 'admin';
  }

  document.querySelectorAll('.nav-item').forEach(n => n.classList.toggle('active', n.dataset.screen === screen));
  document.querySelectorAll('.mobile-nav-item').forEach(n => n.classList.toggle('active', n.dataset.screen === screen));
  document.querySelectorAll('.screen').forEach(s => s.classList.toggle('active', s.id === `screen-${screen}`));
  const adminSection = document.getElementById('nav-admin-section');
  if (adminSection) adminSection.classList.toggle('active', screen === 'admin');
  const mobileAdmin = document.getElementById('mobile-admin-section');
  if (mobileAdmin) mobileAdmin.classList.toggle('active', screen === 'admin');
  document.getElementById('topbar-title').textContent = titles[screen] || screen;

  if (screen === 'dashboard')    renderDashboardProfissional();
  if (screen === 'estoque')      renderEstoque();
  if (screen === 'registrar') {
    populateSelect('e-produto');
    populateSelect('s-produto');
    const isFunc = currentUser.role !== 'dono';
    const histBtn = document.getElementById('reg-btn-historico');
    if (histBtn) histBtn.style.display = isFunc ? 'none' : '';
    if (isFunc) selectRegTipo('entrada');
    else { selectRegTipo(regTipoAtivo); renderHistorico(); }
  }
  if (screen === 'lista-vendas') renderListaVendas();
  if (screen === 'minhas-vendas') renderMinhasVendas();
  if (screen === 'relatorio')    renderRelatorio();
  if (screen === 'caixa')        renderCaixa();
  if (screen === 'admin')        selectAdminTipo(adminTipoAtivo);
  if (screen === 'contagem')    { loadContagemServidor().then(() => renderContagem()); }
  if (screen === 'gastos')      { if (!document.getElementById('g-data').value) document.getElementById('g-data').value = new Date().toISOString().slice(0, 10); updateGastosKPIs(); if (gastosListaVisivel) renderGastos(); }
  if (screen === 'consumo') {
    consumoItens = [];
    consumoCategoriaAtiva = 'Todos';
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
  if (tipo === 'historico' && currentUser.role !== 'dono') return;
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
// Acesso rápido por período (chips)
function setListaPeriodo(p) {
  const sel = document.getElementById('vl-filtro-periodo');
  if (sel) sel.value = p;
  // Limpa o período personalizado para não conflitar com o preset
  const de = document.getElementById('vl-filtro-de');
  const ate = document.getElementById('vl-filtro-ate');
  if (de) de.value = '';
  if (ate) ate.value = '';
  atualizarChipsPeriodo();
  renderListaVendas();
}

function atualizarChipsPeriodo() {
  const deVal = document.getElementById('vl-filtro-de')?.value;
  const ateVal = document.getElementById('vl-filtro-ate')?.value;
  const periodo = document.getElementById('vl-filtro-periodo')?.value || 'semana';
  const personalizado = deVal || ateVal;
  document.querySelectorAll('.vl-chip').forEach(c => {
    c.classList.toggle('active', !personalizado && c.dataset.periodo === periodo);
  });
}

function renderListaVendas() {
  // Preferência salva do ranking
  const storedRank = localStorage.getItem('vl-mostrar-ranking');
  if (storedRank !== null) {
    const chk = document.getElementById('vl-mostrar-ranking');
    if (chk) chk.checked = storedRank === '1';
  }
  toggleListaRanking();
  atualizarChipsPeriodo();

  const periodo    = document.getElementById('vl-filtro-periodo')?.value || 'semana';
  const pagFiltro  = document.getElementById('vl-filtro-pag')?.value || '';
  const tipoFiltro = document.getElementById('vl-filtro-tipo')?.value || '';
  const prodFiltro = document.getElementById('vl-filtro-produto')?.value || '';
  const deVal      = document.getElementById('vl-filtro-de')?.value || '';
  const ateVal     = document.getElementById('vl-filtro-ate')?.value || '';
  const horaDeVal  = document.getElementById('vl-filtro-hora-de')?.value || '';
  const horaAteVal = document.getElementById('vl-filtro-hora-ate')?.value || '';

  const hoje = new Date();
  hoje.setHours(23, 59, 59, 999);
  const diaSemana = hoje.getDay();
  const segunda = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);
  const primeiroDiaMes = new Date(hoje.getFullYear(), hoje.getMonth(), 1);
  const inicioDia = new Date(); inicioDia.setHours(0, 0, 0, 0);

  // Período personalizado (De/Até) tem prioridade sobre o preset
  const inicioDe = deVal ? new Date(deVal + 'T00:00:00') : null;
  const fimAte   = ateVal ? new Date(ateVal + 'T23:59:59.999') : null;

  const filtroPeriodo = v => {
    const d = new Date(v.data);
    if (inicioDe) {
      if (d < inicioDe) return false;
    } else if (periodo === 'hoje') {
      if (d < inicioDia) return false;
    } else if (periodo === 'semana') {
      if (d < segunda) return false;
    } else if (periodo === 'mes') {
      if (d < primeiroDiaMes) return false;
    }
    if (fimAte && d > fimAte) return false;

    // Filtro por horário
    if (horaDeVal || horaAteVal) {
      const h = d.getHours();
      const m = d.getMinutes();
      const mins = h * 60 + m;
      if (horaDeVal) {
        const [hd, md] = horaDeVal.split(':').map(Number);
        if (mins < hd * 60 + md) return false;
      }
      if (horaAteVal) {
        const [ha, ma] = horaAteVal.split(':').map(Number);
        if (mins > ha * 60 + ma) return false;
      }
    }

    return true;
  };

  const lista = [...vendas].sort((a, b) => new Date(b.data) - new Date(a.data)).filter(filtroPeriodo);

  // Filtros que não dependem do produto (usados no ranking)
  const filtroBasico = v => {
    if (pagFiltro && v.pagamento !== pagFiltro) return false;
    if (tipoFiltro && (tipoFiltro === 'delivery' ? !v.delivery : v.delivery)) return false;
    return true;
  };
  const listaRanking = lista.filter(filtroBasico);

  // Filtro por produto (busca por texto)
  let listaFiltrada = listaRanking;
  if (prodFiltro) {
    const termo = prodFiltro.toLowerCase();
    listaFiltrada = listaRanking.filter(v => {
      if (v.itens?.length) return v.itens.some(i => i.produto_nome.toLowerCase().includes(termo));
      return v.produto_nome?.toLowerCase().includes(termo);
    });
  }

  const fmt$ = v => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);
  const totalFat   = listaFiltrada.reduce((s, v) => s + (v.total || 0), 0);
  const ticketMed  = listaFiltrada.length ? totalFat / listaFiltrada.length : 0;
  const unidades   = listaFiltrada.reduce((s, v) => s + (v.itens?.length
    ? v.itens.reduce((a, i) => a + (i.qtd || 0), 0)
    : (v.qtd || 1)), 0);

  document.getElementById('vl-count').textContent       = `${listaFiltrada.length} venda(s)`;
  document.getElementById('vl-kpi-qtd').textContent     = listaFiltrada.length;
  document.getElementById('vl-kpi-total').textContent   = fmt$(totalFat);
  document.getElementById('vl-kpi-ticket').textContent  = fmt$(ticketMed);
  document.getElementById('vl-kpi-unid').textContent    = unidades;

  renderListaRanking(listaRanking, prodFiltro);

  const container = document.getElementById('vl-lista');
  if (!listaFiltrada.length) {
    container.innerHTML = '<div class="empty"><i class="ti ti-receipt"></i>Nenhuma venda no período selecionado.</div>';
    return;
  }

  // No mês/tudo a lista vai junta (sem separadores de dia); datas continuam em cada venda
  const agruparPorDia = periodo !== 'mes' && periodo !== 'tudo';

  let html = '';
  let ultimoDia = null;
  listaFiltrada.forEach(v => {
    if (agruparPorDia) {
      const dia = new Date(v.data);
      const chaveDia = dia.toDateString();
      if (chaveDia !== ultimoDia) {
        ultimoDia = chaveDia;
        html += `<div class="vl-dia"><i class="ti ti-calendar"></i>${rotuloDia(dia)}</div>`;
      }
    }

    const total = fmt$(v.total);
    let pagCls, pagTxt, pagIco;
    if (v.pagamento === 'dinheiro') { pagCls = 'pag-dinheiro'; pagTxt = 'Dinheiro'; pagIco = 'ti-cash'; }
    else if (v.pagamento === 'pix') { pagCls = 'pag-pix'; pagTxt = 'Pix'; pagIco = 'ti-qrcode'; }
    else { pagCls = 'pag-cartao'; pagTxt = 'Cartão'; pagIco = 'ti-credit-card'; }
    const tipoTxt = v.delivery ? 'Delivery' : 'Balcão';
    const tipoIco = v.delivery ? 'ti-delivery' : 'ti-shopping-bag';

    let prodResumo = '';
    let nUnid = 0;
    if (v.itens?.length) {
      nUnid = v.itens.reduce((a, i) => a + (i.qtd || 0), 0);
      prodResumo = v.itens.length === 1
        ? `${v.itens[0].produto_nome} × ${v.itens[0].qtd}`
        : `${v.itens.length} itens · ${nUnid} un.`;
    } else if (v.produto_nome) {
      nUnid = v.qtd || 1;
      prodResumo = `${v.produto_nome} × ${nUnid}`;
    }

    const numVenda = v.id ? `#${String(v.id).padStart(4,'0')}` : '';

    html += `
      <div class="vl-card ${pagCls}" onclick="openVendaDetalhe(${v.id})">
        <div class="vl-card-icone"><i class="ti ${pagIco}"></i></div>
        <div class="vl-card-info">
          <div class="vl-card-top">
            <span class="vl-card-valor">${total}</span>
            ${numVenda ? `<span class="vl-card-num">${numVenda}</span>` : ''}
            ${nUnid ? `<span class="vl-card-num vl-card-unid"><i class="ti ti-box"></i> ${nUnid} un.</span>` : ''}
          </div>
          <div class="vl-card-prod">${prodResumo}</div>
          <div class="vl-card-data">
            <i class="ti ti-clock"></i>${fmt(v.data)}
            <span class="vl-card-tag ${pagCls}"><i class="ti ${pagIco}"></i>${pagTxt}</span>
            <span class="vl-card-tag"><i class="ti ${tipoIco}"></i>${tipoTxt}</span>
            ${v.plataforma ? `<span class="vl-card-tag vl-card-plataforma"><i class="ti ti-device-mobile"></i>${v.plataforma}</span>` : ''}
          </div>
        </div>
        <div class="vl-card-arrow"><i class="ti ti-chevron-right"></i></div>
      </div>`;
  });

  container.innerHTML = html;
}

function rotuloDia(d) {
  const hoje = new Date(); hoje.setHours(0, 0, 0, 0);
  const ontem = new Date(hoje); ontem.setDate(ontem.getDate() - 1);
  const dia = new Date(d.getFullYear(), d.getMonth(), d.getDate());
  if (dia.getTime() === hoje.getTime()) return 'Hoje';
  if (dia.getTime() === ontem.getTime()) return 'Ontem';
  return d.toLocaleDateString('pt-BR', { weekday: 'long', day: '2-digit', month: '2-digit' });
}

let mvPeriodo = 'hoje';

function setMinhasVendasPeriodo(p) {
  mvPeriodo = p;
  document.querySelectorAll('[data-mv-periodo]').forEach(b => b.classList.toggle('active', b.dataset.mvPeriodo === p));
  renderMinhasVendas();
}

async function renderMinhasVendas() {
  const busca      = (document.getElementById('mv-filtro-busca')?.value || '').toLowerCase();
  const deVal      = document.getElementById('mv-filtro-de')?.value || '';
  const ateVal     = document.getElementById('mv-filtro-ate')?.value || '';
  const horaDeVal  = document.getElementById('mv-filtro-hora-de')?.value || '';
  const horaAteVal = document.getElementById('mv-filtro-hora-ate')?.value || '';

  let lista = [];
  try {
    lista = await apiRequest('/vendas');
  } catch (e) {
    lista = [];
  }

  const hoje = new Date();
  hoje.setHours(23, 59, 59, 999);
  const diaSemana = hoje.getDay();
  const segunda = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);
  const primeiroDiaMes = new Date(hoje.getFullYear(), hoje.getMonth(), 1);
  const inicioDia = new Date(); inicioDia.setHours(0, 0, 0, 0);

  const inicioDe = deVal ? new Date(deVal + 'T00:00:00') : null;
  const fimAte   = ateVal ? new Date(ateVal + 'T23:59:59.999') : null;

  const filtrada = lista.filter(v => {
    const d = new Date(v.data);
    if (inicioDe && d < inicioDe) return false;
    if (!inicioDe) {
      if (mvPeriodo === 'hoje' && d < inicioDia) return false;
      if (mvPeriodo === 'semana' && d < segunda) return false;
      if (mvPeriodo === 'mes' && d < primeiroDiaMes) return false;
    }
    if (fimAte && d > fimAte) return false;

    if (horaDeVal || horaAteVal) {
      const mins = d.getHours() * 60 + d.getMinutes();
      if (horaDeVal) {
        const [hd, md] = horaDeVal.split(':').map(Number);
        if (mins < hd * 60 + md) return false;
      }
      if (horaAteVal) {
        const [ha, ma] = horaAteVal.split(':').map(Number);
        if (mins > ha * 60 + ma) return false;
      }
    }

    if (busca) {
      const temItem = v.itens?.some(i => i.produto_nome.toLowerCase().includes(busca));
      if (!temItem) return false;
    }

    return true;
  }).sort((a, b) => new Date(b.data) - new Date(a.data));

  const fmt$ = v => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);
  document.getElementById('mv-count').textContent = `${filtrada.length} venda(s)`;

  const tbody = document.getElementById('mv-tbody');
  const empty = document.getElementById('mv-empty');
  if (!filtrada.length) {
    tbody.innerHTML = '';
    empty.style.display = 'flex';
    return;
  }
  empty.style.display = 'none';

  tbody.innerHTML = filtrada.map(v => {
    let pagCls, pagTxt, pagIco;
    if (v.pagamento === 'dinheiro') { pagCls = 'pag-dinheiro'; pagTxt = 'Dinheiro'; pagIco = 'ti-cash'; }
    else if (v.pagamento === 'pix') { pagCls = 'pag-pix'; pagTxt = 'Pix'; pagIco = 'ti-qrcode'; }
    else { pagCls = 'pag-cartao'; pagTxt = 'Cartão'; pagIco = 'ti-credit-card'; }

    let itensResumo = '';
    if (v.itens?.length) {
      itensResumo = v.itens.map(i => `${i.produto_nome} ×${i.qtd}`).join(', ');
    }

    const tipoTxt = v.delivery ? `Delivery${v.plataforma ? ' (' + v.plataforma + ')' : ''}` : 'Balcão';

    return `<tr>
      <td><i class="ti ti-clock" style="margin-right:4px;opacity:.5"></i>${fmt(v.data)}</td>
      <td>${itensResumo}</td>
      <td><span class="vl-card-tag ${pagCls}"><i class="ti ${pagIco}"></i>${pagTxt}</span></td>
      <td>${tipoTxt}</td>
      <td style="font-weight:700">${fmt$(v.total)}</td>
    </tr>`;
  }).join('');
}

function toggleListaRanking() {
  const chk = document.getElementById('vl-mostrar-ranking');
  const card = document.getElementById('vl-ranking-card');
  const on = chk ? chk.checked : true;
  localStorage.setItem('vl-mostrar-ranking', on ? '1' : '0');
  if (card) card.style.display = on ? 'block' : 'none';
}

function renderListaRanking(lista, prodFiltro) {
  const el = document.getElementById('vl-ranking');
  const subEl = document.getElementById('vl-ranking-sub');
  if (!el) return;

  const agrup = {};
  lista.forEach(v => {
    if (v.itens?.length) {
      v.itens.forEach(i => {
        const key = i.produto_nome;
        if (!agrup[key]) agrup[key] = { qtd: 0, total: 0 };
        agrup[key].qtd += i.qtd || 0;
        agrup[key].total += (i.preco_unitario || 0) * (i.qtd || 0);
      });
    } else if (v.produto_nome) {
      const key = v.produto_nome;
      if (!agrup[key]) agrup[key] = { qtd: 0, total: 0 };
      agrup[key].qtd += v.qtd || 1;
      agrup[key].total += v.total || 0;
    }
  });

  const ranking = Object.entries(agrup).sort((a, b) => b[1].qtd - a[1].qtd).slice(0, 8);
  const maxQtd = ranking.length ? ranking[0][1].qtd : 0;
  const fmt$ = v => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);

  if (subEl) {
    const totalUnid = ranking.reduce((s, [, d]) => s + d.qtd, 0);
    subEl.textContent = totalUnid ? `· ${totalUnid} unidades` : '';
  }

  if (!ranking.length) {
    el.innerHTML = '<div class="empty"><i class="ti ti-trophy"></i>Sem vendas no período.</div>';
    return;
  }

  el.innerHTML = ranking.map(([nome, d]) => {
    const hl = prodFiltro && nome === prodFiltro;
    return `
      <div class="dash-rank-item${hl ? ' dash-rank-item--hl' : ''}" onclick="selectRankingProduto('${nome.replace(/'/g, "\\'")}')">
        <div class="dash-rank-header">
          <span class="dash-rank-name"><i class="ti ti-cup" style="color:var(--blue)"></i> ${nome}</span>
          <span class="dash-rank-val">×${d.qtd} <small>${fmt$(d.total)}</small></span>
        </div>
        <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--blue);width:${maxQtd ? Math.round((d.qtd / maxQtd) * 100) : 0}%"></div></div>
      </div>`;
  }).join('');
}

function selectRankingProduto(nome) {
  const input = document.getElementById('vl-filtro-produto');
  if (input) {
    input.value = nome;
    renderListaVendas();
  }
}

function preencherFiltroProduto() {
  const dl = document.getElementById('vl-filtro-produto-list');
  if (!dl) return;
  const prods = new Set();
  vendas.forEach(v => {
    if (v.itens?.length) v.itens.forEach(i => prods.add(i.produto_nome));
    else if (v.produto_nome) prods.add(v.produto_nome);
  });
  const input = document.getElementById('vl-filtro-produto');
  const atual = input ? input.value : '';
  dl.innerHTML = [...prods].sort((a, b) => a.localeCompare(b, 'pt-BR')).map(p =>
    `<option value="${p.replace(/"/g, '&quot;')}">`).join('');
  if (input) input.value = atual;
}

function openVendaDetalhe(vendaId) {
  const venda = vendas.find(v => v.id === vendaId);
  if (!venda) return;

  const fmt$ = v => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);
  const total = fmt$(venda.total);

  let itens = [];
  if (venda.itens?.length) {
    itens = venda.itens;
  } else if (venda.produto_nome) {
    itens = [{ produto_nome: venda.produto_nome, qtd: venda.qtd || 1, preco_unitario: venda.total || 0 }];
  }

  const nItens = itens.length;
  const nUnid = itens.reduce((s, i) => s + (i.qtd || 0), 0);

  const itensHTML = itens.length
    ? itens.map(i => {
        const un = i.qtd || 1;
        const preco = i.preco_unitario || 0;
        const sub = fmt$(preco * un);
        return `<div class="vd-item">
          <div class="vd-item-ico"><i class="ti ti-basket"></i></div>
          <div class="vd-item-body">
            <div class="vd-item-nome">${i.produto_nome}${i.recheio ? `<small>${i.recheio}</small>` : ''}</div>
            <div class="vd-item-preco">${fmt$(preco)} × ${un}</div>
          </div>
          <div class="vd-item-sub">${sub}</div>
        </div>`;
      }).join('')
    : '<div class="empty" style="padding:1rem">Sem detalhes de itens</div>';

  const numVenda = venda.id ? `#${String(venda.id).padStart(4,'0')}` : 'Venda';
  const dt = new Date(venda.data);
  const dataHora = `${dt.toLocaleDateString('pt-BR')} às ${dt.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}`;

  let pagIco, pagTxt, pagCls;
  if (venda.pagamento === 'dinheiro') { pagIco = 'ti-cash'; pagTxt = 'Dinheiro'; pagCls = 'pag-dinheiro'; }
  else if (venda.pagamento === 'pix') { pagIco = 'ti-qrcode'; pagTxt = 'Pix'; pagCls = 'pag-pix'; }
  else { pagIco = 'ti-credit-card'; pagTxt = 'Cartão'; pagCls = 'pag-cartao'; }
  const tipoChip = venda.delivery
    ? '<span class="vd-strip-chip"><i class="ti ti-delivery"></i> Delivery</span>'
    : '<span class="vd-strip-chip"><i class="ti ti-shopping-bag"></i> Balcão</span>';

  document.getElementById('venda-detalhe-body').innerHTML = `
    <div class="vd-strip">
      <button type="button" class="vd-close" onclick="closeVendaDetalhe()"><i class="ti ti-x"></i></button>
      <div class="vd-strip-top">
        <span class="vd-strip-num">${numVenda}</span>
        <span class="vd-strip-total">${total}</span>
      </div>
      <div class="vd-strip-meta">
        <span class="vd-strip-chip"><i class="ti ti-clock"></i>${dataHora}</span>
        <span class="vd-strip-chip vd-chip-pag ${pagCls}"><i class="ti ${pagIco}"></i>${pagTxt}</span>
        ${tipoChip}
        ${venda.plataforma ? `<span class="vd-strip-chip"><i class="ti ti-device-mobile"></i>${venda.plataforma}</span>` : ''}
      </div>
    </div>
    ${venda.obs ? `<div class="vd-obs"><i class="ti ti-note"></i> ${venda.obs}</div>` : ''}
    <div class="vd-section-title">Itens <span>${nItens} item(ns) · ${nUnid} un.</span></div>
    <div class="vd-itens">${itensHTML}</div>
    <div class="vd-footer">
      <div class="vd-footer-count"><i class="ti ti-box"></i> ${nItens} itens · ${nUnid} un.</div>
      <div class="vd-footer-total">
        <span>Total da venda</span>
        <strong>${total}</strong>
      </div>
    </div>`;

  document.getElementById('venda-detalhe-modal').classList.add('show');
}

function closeVendaDetalhe(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('venda-detalhe-modal').classList.remove('show');
}

// ==================== PRODUTOS ====================
function populateCategoriaDatalist() {
  const cats = [...new Set(produtos.map(p => p.categoria).filter(Boolean))];
  const list = document.getElementById('p-cat-list');
  if (list) list.innerHTML = cats.map(c => `<option value="${c}">`).join('');
}

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
    populateCategoriaDatalist();
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
  showConfirm({
    title: 'Remover produto',
    message: 'Remover este produto? Esta ação não pode ser desfeita.',
    confirmText: 'Remover',
    onConfirm: async () => {
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
  });
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
  populateCategoriaDatalist();
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

let produtosCatAtiva = 'Todas';

function renderProdutos() {
  const lista = produtos.filter(p => !isProdutoAcai(p));
  const ct = document.getElementById('p-count');
  if (ct) ct.textContent = `${lista.length} produto(s)`;

  // Gera pills de categoria
  const catsEl = document.getElementById('p-cats');
  if (catsEl) {
    const cats = ['Todas', ...new Set(lista.map(p => p.categoria).filter(Boolean))].sort((a,b) => {
      if (a==='Todas') return -1; if (b==='Todas') return 1;
      return a.localeCompare(b,'pt-BR');
    });
    catsEl.innerHTML = cats.map(c => `
      <button class="estoque-cat-pill${c === produtosCatAtiva ? ' active' : ''}"
        onclick="selectProdutosCat('${c.replace(/'/g,"\\'")}')">
        ${c}
      </button>`).join('');
  }

  filtrarProdutos();
}

function selectProdutosCat(cat) {
  produtosCatAtiva = cat;
  renderProdutos();
}

function filtrarProdutos() {
  const busca = (document.getElementById('p-busca')?.value || '').toLowerCase().trim();
  const tb    = document.getElementById('tabela-produtos');
  const em    = document.getElementById('produtos-empty');
  const count = document.getElementById('p-busca-count');

  let lista = produtos.filter(p => !isProdutoAcai(p));

  if (produtosCatAtiva !== 'Todas') {
    lista = lista.filter(p => p.categoria === produtosCatAtiva);
  }
  if (busca) {
    lista = lista.filter(p =>
      p.nome.toLowerCase().includes(busca) ||
      (p.categoria && p.categoria.toLowerCase().includes(busca))
    );
  }

  if (count) count.textContent = (busca || produtosCatAtiva !== 'Todas') ? `${lista.length} produto(s)` : '';

  if (!lista.length) {
    tb.innerHTML = `<tr><td colspan="7" style="text-align:center;padding:24px;color:var(--text-muted)">Nenhum produto encontrado</td></tr>`;
    if (em) em.style.display = 'none';
    return;
  }
  if (em) em.style.display = 'none';

  const esc = busca.replace(/[.*+?^${}()|[\]\\]/g,'\\$&');
  tb.innerHTML = lista.map(p => {
    const low  = p.qtd <= p.qtd_minima;
    const badge = low ? '<span class="badge badge-red">Baixo</span>' : '<span class="badge badge-green">OK</span>';
    const preco = p.preco ? new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(p.preco) : '—';
    const nome  = busca
      ? `<strong>${p.nome.replace(new RegExp(`(${esc})`,'gi'),'<mark class="estoque-highlight">$1</mark>')}</strong>`
      : `<strong>${p.nome}</strong>`;
    return `<tr>
      <td>${nome}</td>
      <td>${p.categoria || '—'}</td>
      <td>${p.qtd}</td>
      <td>${p.qtd_minima}</td>
      <td>${preco}</td>
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
  const list = document.getElementById(id + '-list');
  if (!list) return;
  list.innerHTML = produtos.map(p => `<option value="${p.nome}">${p.nome} (estoque: ${p.qtd})</option>`).join('');
}

function findProdutoByName(name) {
  const lower = name.toLowerCase().trim();
  return produtos.find(p => p.nome.toLowerCase().trim() === lower);
}

function populateHFiltro() {
  const sel = document.getElementById('h-filtro-prod');
  sel.innerHTML = '<option value="">Todos os produtos</option>' + 
    produtos.map(p => `<option value="${p.id}">${p.nome}</option>`).join('');
}

// ==================== MOVIMENTAÇÕES ====================
async function addEntrada() {
  const produto = findProdutoByName(document.getElementById('e-produto').value);
  const produtoId = produto ? produto.id : null;
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
  const produto = findProdutoByName(document.getElementById('s-produto').value);
  const produtoId = produto ? produto.id : null;
  const qtdRaw    = parseFloat(document.getElementById('s-qty').value);
  const unidade   = document.getElementById('s-unidade')?.value || 'un';
  const obsInput  = document.getElementById('s-obs').value.trim();

  if (!produtoId) { toast('Selecione um produto!', false); return; }
  if (!qtdRaw || qtdRaw <= 0) { toast('Quantidade deve ser maior que zero!', false); return; }

  const qtd = unidade === 'un' ? Math.round(qtdRaw) : qtdRaw;

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

  const pagamentos = { dinheiro: 0, cartao: 0, pix: 0 };
  vendasMes.forEach(venda => {
    if (venda.pagamento === 'dinheiro') {
      pagamentos.dinheiro++;
    } else if (venda.pagamento === 'pix') {
      pagamentos.pix++;
    } else if (venda.pagamento === 'cartao') {
      pagamentos.cartao++;
    }
  });
  
  const pagamentosEl = document.getElementById('dash-pagamentos');
  if (pagamentosEl) {
    if (!vendasMes.length) {
      pagamentosEl.innerHTML = '<div class="empty" style="padding:1rem">Sem dados ainda</div>';
    } else {
      const totalPag = pagamentos.dinheiro + pagamentos.cartao + pagamentos.pix;
      const pctDin = totalPag > 0 ? Math.round((pagamentos.dinheiro/totalPag)*100) : 0;
      const pctCart = totalPag > 0 ? Math.round((pagamentos.cartao/totalPag)*100) : 0;
      const pctPix = totalPag > 0 ? Math.round((pagamentos.pix/totalPag)*100) : 0;
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
        <div class="dash-rank-item">
          <div class="dash-rank-header">
            <span class="dash-rank-name"><i class="ti ti-qrcode" style="color:var(--purple)"></i> Pix</span>
            <span class="dash-rank-val">${pagamentos.pix} venda(s) · ${pctPix}%</span>
          </div>
          <div class="dash-rank-bar"><div class="dash-rank-fill" style="background:var(--purple);width:${pctPix}%"></div></div>
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
        let pagamentoBadge;
        if (venda.pagamento === 'dinheiro') pagamentoBadge = '<span class="badge badge-green">Dinheiro</span>';
        else if (venda.pagamento === 'pix') pagamentoBadge = '<span class="badge badge-purple">Pix</span>';
        else pagamentoBadge = '<span class="badge badge-blue">Cartão</span>';
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
  const totalPix         = vendasSemana.filter(v => v.pagamento === 'pix').reduce((a, v) => a + (v.total || 0), 0);
  const qtdDelivery      = vendasSemana.filter(v => v.delivery).length;
  const qtdBalcao        = vendasSemana.filter(v => !v.delivery).length;
  const totalTipo        = Math.max(qtdDelivery + qtdBalcao, 1);

  document.getElementById('r-vendas-qtd').textContent     = vendasSemana.length;
  document.getElementById('r-total-dinheiro').textContent = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalDinheiro);
  document.getElementById('r-total-cartao').textContent   = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalCartao);
  document.getElementById('r-total-pix').textContent      = new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(totalPix);
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

let pastelModoRecheio = 'salgado';

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
let pastelTipo = 'pastel';

function openPastelModal(modo = 'vendas', tipo = 'pastel') {
  const modal = document.getElementById('pastel-modal');
  if (!modal) return;

  pastelModo = modo;
  pastelTipo = tipo;
  pastelSelecionados = [];
  pastelModoRecheio = 'salgado';

  const titulo = modal.querySelector('h3 span');
  if (titulo) titulo.parentElement.innerHTML = tipo === 'mini'
    ? '<span>🥟</span> Mini Pastéis — escolha o recheio'
    : '<span>🥟</span> Escolha o recheio';

  document.getElementById('pastel-btn-salgado').style.display = tipo === 'mini' ? 'none' : '';
  document.getElementById('pastel-btn-doce').style.display = tipo === 'mini' ? 'none' : '';

  renderPastelModal();
  modal.classList.add('show');
}

function setPastelModoRecheio(modo) {
  pastelModoRecheio = modo;
  pastelSelecionados = [];
  document.getElementById('pastel-btn-salgado').classList.toggle('active', modo === 'salgado');
  document.getElementById('pastel-btn-doce').classList.toggle('active', modo === 'doce');
  renderPastelModal();
}

function renderPastelModal() {
  const grid = document.getElementById('pastel-recheios-grid');
  const precoTexto = document.getElementById('pastel-preco-texto');
  if (!grid) return;

  const todos = pastelData.recheios?.length
    ? pastelData.recheios
    : PASTEL_RECHEIOS_PADRAO.map((nome, i) => ({ id: i, nome }));

  const salgados = todos.filter(r => !r.preco);
  const doces = todos.filter(r => r.preco);

  if (pastelModoRecheio === 'doce') {
    grid.innerHTML = doces.length
      ? doces.map(r => `
        <button type="button" class="pastel-recheio-btn pastel-recheio-doce${pastelSelecionados.includes(r.nome) ? ' selected' : ''}"
          onclick="togglePastelRecheio('${r.nome.replace(/'/g, "\\'")}')">
          ${r.nome}
          <span class="pastel-recheio-preco">${fmtMoeda(r.preco)}</span>
        </button>`).join('')
      : '<p style="grid-column:1/-1;text-align:center;color:var(--text-muted);padding:1rem">Nenhum recheio doce cadastrado.</p>';
    if (precoTexto) precoTexto.innerHTML = 'Preço variável por recheio — escolha até <strong>3 sabores</strong>';
  } else if (pastelTipo === 'mini') {
    grid.innerHTML = salgados.map(r => `
      <button type="button" class="pastel-recheio-btn${pastelSelecionados.includes(r.nome) ? ' selected' : ''}"
        onclick="togglePastelRecheio('${r.nome.replace(/'/g, "\\'")}')">
        ${r.nome}
      </button>`).join('');
    if (precoTexto) precoTexto.innerHTML = `Preço fixo: <strong>${fmtMoeda(5)}</strong> — escolha até <strong>3 sabores</strong>`;
  } else {
    grid.innerHTML = salgados.map(r => `
      <button type="button" class="pastel-recheio-btn${pastelSelecionados.includes(r.nome) ? ' selected' : ''}"
        onclick="togglePastelRecheio('${r.nome.replace(/'/g, "\\'")}')">
        ${r.nome}
      </button>`).join('');
    if (precoTexto) precoTexto.innerHTML = `Preço fixo: <strong>${fmtMoeda(pastelData.preco || 14)}</strong> — escolha até <strong>3 sabores</strong>`;
  }

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
  let precoUnitario = null;
  if (pastelTipo === 'mini') {
    precoUnitario = 5;
  } else if (pastelModoRecheio === 'doce') {
    const doce = (pastelData.recheios || []).find(r => r.nome === pastelSelecionados[0]);
    precoUnitario = doce ? doce.preco : null;
  }
  addPastelToVenda(pastelSelecionados.join('+'), pastelModo, precoUnitario, pastelTipo);
}

function closePastelModal(e) {
  if (e && e.target !== e.currentTarget) return;
  const modal = document.getElementById('pastel-modal');
  if (modal) modal.classList.remove('show');
}

function addPastelToVenda(recheio, modo = 'vendas', precoOverride = null, tipo = 'pastel') {
  const itens = modo === 'consumo' ? consumoItens : vendaItens;
  const produto = tipo === 'mini'
    ? produtos.find(p => p.nome && p.nome.toLowerCase().includes('mini pastel'))
    : produtos.find(isProdutoPastel);
  const produtoId = tipo === 'mini' ? (produto?.id || null) : (pastelData.produtoId || produto?.id);
  const preco = precoOverride || (tipo === 'mini' ? 5 : (pastelData.preco || produto?.preco || 14));

  if (!produtoId) {
    toast(`Produto ${tipo === 'mini' ? 'Mini Pastel' : 'Pastel'} não cadastrado.`, false);
    return;
  }

  const nomeProduto = tipo === 'mini' ? `Mini Pastel (${recheio})` : `Pastel (${recheio})`;
  const existing = itens.find(i => i.produtoId === produtoId && i.recheio === recheio && i.mini === (tipo === 'mini'));
  if (existing) {
    existing.qtd += 1;
  } else {
    itens.push({
      produtoId,
      produtoNome: nomeProduto,
      qtd: 1,
      precoUnitario: preco,
      recheio,
      mini: tipo === 'mini'
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

  tEl.innerHTML = acaiData.tamanhos.map(t => {
    const ml = (String(t.nome).match(/(\d+)\s*ml/i) || [])[1];
    return `
      <button type="button" class="acai-tam-btn"
        onclick="selectAcaiTamanho(${t.id})" data-id="${t.id}">
        <span class="acai-tam-check"><i class="ti ti-check"></i></span>
        <span class="acai-tam-ml">${ml ? ml + 'ml' : t.nome}</span>
        <span class="acai-tam-preco">${fmtMoeda(t.preco || 0)}</span>
      </button>`;
  }).join('');

  cEl.innerHTML = acaiData.complementos.map(c => `
    <button type="button" class="acai-comp-btn" onclick="toggleAcaiComplemento(${c.id})" data-id="${c.id}">
      <i class="ti ti-check acai-comp-check"></i>
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
  const compsSel = acaiData.complementos.filter(c => acaiComplementosSel.includes(c.id));
  compsSel.forEach(c => total += (c.preco || 0));
  const el = document.getElementById('acai-total-preview');
  if (el) el.textContent = fmtMoeda(total);
  const btn = document.getElementById('acai-add-btn');
  if (btn) btn.disabled = !t;

  const cnt = document.getElementById('acai-comp-count');
  if (cnt) cnt.textContent = compsSel.length
    ? `(${compsSel.length} selecionado${compsSel.length > 1 ? 's' : ''})`
    : '(opcional)';

  const sel = document.getElementById('acai-selecao-texto');
  if (sel) {
    if (!t) {
      sel.textContent = 'Nenhum tamanho';
    } else {
      const partes = [String(t.nome).replace(/^açaí\s*/i, '')];
      if (compsSel.length) partes.push(`${compsSel.length} complemento${compsSel.length > 1 ? 's' : ''}`);
      sel.textContent = partes.join(' · ');
    }
  }
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
  document.getElementById('v-pagamento-hidden').value = type;

  document.querySelectorAll('.payment-option').forEach(opt => {
    opt.classList.remove('active');
    if (opt.id === 'label-' + type) opt.classList.add('active');
  });

  const trocoRow = document.getElementById('v-troco-row');
  if (trocoRow) {
    trocoRow.style.display = type === 'dinheiro' ? 'flex' : 'none';
    if (type !== 'dinheiro') {
      document.getElementById('v-valor-recebido').value = '';
      document.getElementById('v-troco-valor').textContent = 'R$ 0,00';
    }
  }
}

function calcTroco() {
  const totalText = document.getElementById('v-total-preview')?.textContent || 'R$ 0,00';
  const total = parseFloat(totalText.replace(/[^\d,]/g, '').replace(',', '.')) || 0;
  const recebido = parseFloat(document.getElementById('v-valor-recebido')?.value) || 0;
  const troco = recebido - total;
  const trocoEl = document.getElementById('v-troco-valor');
  if (trocoEl) {
    trocoEl.textContent = fmtMoeda(Math.max(troco, 0));
    trocoEl.style.color = troco < 0 ? 'var(--red)' : 'var(--green)';
  }
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
  if (document.getElementById('v-pagamento-hidden')?.value === 'dinheiro') calcTroco();
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
    document.getElementById('v-valor-recebido').value = '';
    document.getElementById('v-troco-valor').textContent = 'R$ 0,00';
    document.getElementById('v-troco-row').style.display = 'none';
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

// ==================== ADMIN (Usuários + Consumo do dono) ====================
// Alterna a aba do Admin: Usuários ou Consumo (visão geral)
function selectAdminTipo(tipo) {
  adminTipoAtivo = tipo;
  document.getElementById('admin-btn-usuarios').classList.toggle('active', tipo === 'usuarios');
  document.getElementById('admin-btn-consumo').classList.toggle('active', tipo === 'consumo');
  document.getElementById('admin-btn-atividade').classList.toggle('active', tipo === 'atividade');
  document.getElementById('admin-view-usuarios').style.display = tipo === 'usuarios' ? 'block' : 'none';
  document.getElementById('admin-view-consumo').style.display = tipo === 'consumo' ? 'block' : 'none';
  document.getElementById('admin-view-atividade').style.display = tipo === 'atividade' ? 'block' : 'none';
  if (tipo === 'usuarios') renderUsuarios();
  if (tipo === 'consumo') selectAdminConsumo(adminConsumoAtivo);
  if (tipo === 'atividade') renderAtividade();
}

async function renderAtividade() {
  let data = [];
  try {
    data = await apiRequest('/movimentacoes/log');
  } catch (e) { data = []; }

  const tb = document.getElementById('tabela-atividade');
  const em = document.getElementById('atividade-empty');
  document.getElementById('at-count').textContent = `${data.length} registro(s)`;

  if (!data.length) {
    tb.innerHTML = '';
    em.style.display = 'flex';
    return;
  }
  em.style.display = 'none';

  tb.innerHTML = data.map(m => {
    const badge = m.tipo === 'entrada'
      ? '<span class="badge badge-green">Entrada</span>'
      : '<span class="badge badge-red">Saída</span>';
    const qtd = m.tipo === 'entrada'
      ? `<span class="tag-entrada">+${m.qtd}</span>`
      : `<span class="tag-saida">-${m.qtd}</span>`;
    return `<tr>
      <td>${fmt(m.data)}</td>
      <td>${m.usuario_nome || '—'}</td>
      <td>${m.produto_nome}</td>
      <td>${badge}</td>
      <td>${qtd}</td>
      <td>${m.obs || '—'}</td>
    </tr>`;
  }).join('');
}

function renderConsumo() {
  const sc = document.getElementById('screen-consumo');
  if (sc) sc.classList.add('pdv-mode');
  renderConsumoCategorias();
  renderConsumoGrid();
  renderConsumoBars();
}

async function renderConsumoDono() {
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
    grid.innerHTML = '<div class="empty"><i class="ti ti-users"></i>Nenhum usuário cadastrado ainda.</div>';
    return;
  }

  grid.innerHTML = consumoFuncionarios.map(f => {
    const isDono = f.role === 'dono';
    const nConsumos = f.consumos?.length || 0;
    const pct = isDono ? 0 : Math.min(((f.totalMes || 0) / LIMITE_CONSUMO) * 100, 100);
    const restante = isDono ? 0 : Math.max(LIMITE_CONSUMO - (f.totalMes || 0), 0);
    const limite = isDono
      ? '<span class="badge badge-blue">Sem limite</span>'
      : ((f.totalMes || 0) >= LIMITE_CONSUMO
        ? '<span class="badge badge-red">Limite atingido</span>'
        : (nConsumos ? `<span class="badge badge-blue">${nConsumos} consumo${nConsumos === 1 ? '' : 's'}</span>` : ''));
    return `
      <div class="cd-card" onclick="openConsumoDonoDetalhe(${f.id})">
        <div class="cd-card-top">
          <div class="cd-avatar">${isDono ? '<i class="ti ti-crown"></i>' : '<i class="ti ti-user-circle"></i>'}</div>
          <div class="cd-info">
            <div class="cd-nome">${f.nome}${isDono ? ' <span class="cd-role-tag">Dono</span>' : ''}</div>
            <div class="cd-user">@${f.usuario}</div>
          </div>
          <div class="cd-valor">${fmtMoeda(f.totalMes || 0)}</div>
        </div>
        ${isDono ? '' : `
        <div class="progress-bar cd-progress">
          <div class="progress-fill" style="width:${pct}%;background:var(--blue)"></div>
        </div>`}
        <div class="cd-card-foot">
          <span>${isDono
            ? (nConsumos ? `${nConsumos} consumo${nConsumos === 1 ? '' : 's'} no mês` : 'Nenhum consumo no mês')
            : `${fmtMoeda(restante)} restantes`}</span>
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
          <div class="cd-itens-list">${itensHTML}</div>
        </div>`;
    }).join('');
  }

  document.getElementById('consumo-detalhe-modal').classList.add('show');
}

function closeConsumoDonoDetalhe(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('consumo-detalhe-modal').classList.remove('show');
}

// ==================== CONSUMO ADMIN (gerenciar consumo do dono) ====================
let adminConsumoAtivo = 'visao';
let acUserAtivo = null;
let acCart = [];

// Alterna entre Visão geral e Gerenciar consumo (dentro da aba Consumo do Admin)
function selectAdminConsumo(v) {
  adminConsumoAtivo = v;
  document.getElementById('ac-btn-visao').classList.toggle('active', v === 'visao');
  document.getElementById('ac-btn-gerenciar').classList.toggle('active', v === 'gerenciar');
  document.getElementById('ac-visao-view').style.display = v === 'visao' ? 'block' : 'none';
  document.getElementById('ac-gerenciar-view').style.display = v === 'gerenciar' ? 'block' : 'none';
  if (v === 'visao') {
    renderConsumoDono();
  } else {
    renderAcUserPicker();
  }
}

// Lista de usuários para selecionar no gerenciamento
function renderAcUserPicker() {
  const picker = document.getElementById('ac-user-picker');
  if (!consumoFuncionarios.length) {
    picker.innerHTML = '<div class="empty"><i class="ti ti-users"></i>Nenhum usuário cadastrado ainda.</div>';
    return;
  }
  picker.innerHTML = consumoFuncionarios.map(f => {
    const isDono = f.role === 'dono';
    const ativo = acUserAtivo === f.id;
    return `
      <button class="ac-user-chip ${ativo ? 'active' : ''}" onclick="selectAcUser(${f.id})">
        <span class="ac-user-chip-avatar">${isDono ? '<i class="ti ti-crown"></i>' : '<i class="ti ti-user-circle"></i>'}</span>
        <span class="ac-user-chip-info">
          <strong>${f.nome}</strong>
          <small>${fmtMoeda(f.totalMes || 0)} no mês</small>
        </span>
      </button>`;
  }).join('');
}

// Seleciona o usuário e monta o painel de gerenciamento
function selectAcUser(usuarioId) {
  acUserAtivo = usuarioId;
  acCart = [];
  renderAcUserPicker();
  renderAcManage();
}

function renderAcManage() {
  const f = consumoFuncionarios.find(x => x.id === acUserAtivo);
  const panel = document.getElementById('ac-manage-panel');
  if (!f) {
    panel.innerHTML = '<div class="card"><div class="empty"><i class="ti ti-user"></i>Selecione um usuário acima.</div></div>';
    return;
  }

  const isDono = f.role === 'dono';
  const nConsumos = f.consumos?.length || 0;
  const total = f.totalMes || 0;

  const cartHTML = acCart.length ? acCart.map((it, idx) => `
      <div class="vd-item">
        <span class="vd-item-nome">${it.produtoNome}</span>
        <span class="vd-item-qty">× ${it.qtd}</span>
        <span class="vd-item-sub">${fmtMoeda(parseFloat(it.precoUnitario || 0) * it.qtd)}</span>
        <button class="btn btn-danger btn-sm" onclick="acRemoveCartItem(${idx})" title="Remover item"><i class="ti ti-x"></i></button>
      </div>`).join('')
    : '<div class="empty vendas-empty">Nenhum item adicionado</div>';

  const cartTotal = acCart.reduce((s, i) => s + (parseFloat(i.precoUnitario || 0) * i.qtd), 0);

  const consumosHTML = (f.consumos || []).map(c => {
    const itensHTML = (c.itens || []).map(i => `
      <div class="vd-item">
        <span class="vd-item-nome">${i.produto_nome}${i.recheio ? ` <small>(${i.recheio})</small>` : ''}</span>
        <span class="vd-item-qty">× ${i.qtd}</span>
        <span class="vd-item-sub">${fmtMoeda((parseFloat(i.preco_unitario) || 0) * i.qtd)}</span>
        <button class="btn btn-danger btn-sm" onclick="acRemoverItem(${i.id})" title="Remover este item"><i class="ti ti-x"></i></button>
      </div>`).join('') || '<div class="empty" style="padding:.5rem">Sem itens</div>';

    return `
      <div class="cd-consumo">
        <div class="cd-consumo-header">
          <span><i class="ti ti-clock"></i> ${fmt(c.data)}</span>
          <div style="display:flex;align-items:center;gap:8px">
            <strong>${fmtMoeda(c.total || 0)}</strong>
            <button class="btn btn-danger btn-sm" onclick="acRemoverConsumo(${c.id})" title="Remover consumo inteiro"><i class="ti ti-trash"></i></button>
          </div>
        </div>
        ${c.obs ? `<div class="cd-consumo-obs"><i class="ti ti-note"></i> ${c.obs}</div>` : ''}
        <div class="vd-itens">${itensHTML}</div>
      </div>`;
  }).join('') || '<div class="empty"><i class="ti ti-wallet"></i>Nenhum consumo registrado neste mês.</div>';

  panel.innerHTML = `
    <div class="card ac-manage-user-card">
      <div class="ac-manage-user">
        <div class="cd-avatar">${isDono ? '<i class="ti ti-crown"></i>' : '<i class="ti ti-user-circle"></i>'}</div>
        <div class="cd-info">
          <div class="cd-nome">${f.nome}${isDono ? ' <span class="cd-role-tag">Dono</span>' : ''}</div>
          <div class="cd-user">@${f.usuario} · ${nConsumos} consumo${nConsumos === 1 ? '' : 's'} no mês</div>
        </div>
        <div class="ac-manage-total">
          <span>Total no mês</span>
          <strong>${fmtMoeda(total)}</strong>
        </div>
        <button class="cd-btn cd-btn-zero" onclick="zerarConsumo(${f.id})"><i class="ti ti-eraser"></i> Zerar mês</button>
      </div>
    </div>

    <div class="ac-manage-grid">
      <div class="card">
        <div class="card-title"><i class="ti ti-plus" style="color:var(--green)"></i> Adicionar consumo</div>
        <div class="ac-add-form">
          <div class="form-group"><label>Produto</label><select id="ac-produto"></select></div>
          <div class="form-group ac-qtd"><label>Qtd</label><input type="number" id="ac-qtd" value="1" min="0.001" step="0.001"></div>
          <div class="ac-add-btn-wrap">
            <button class="btn btn-primary" onclick="acAddItem()"><i class="ti ti-plus"></i> Adicionar</button>
          </div>
        </div>
        <div class="vendas-carrinho-body ac-cart">
          <div class="ac-section-title"><i class="ti ti-shopping-cart"></i> Itens para registrar</div>
          <div class="vendas-itens-list">${cartHTML}</div>
        </div>
        <div class="total-section vendas-total">
          <div class="total-label">Total</div>
          <div class="total-value" id="ac-cart-total">${fmtMoeda(cartTotal)}</div>
        </div>
        <div class="form-group" style="margin-top:10px">
          <label>Observação (opcional)</label>
          <input type="text" id="ac-obs" placeholder="Ex: Ajuste manual...">
        </div>
        <button class="btn btn-primary" style="width:100%;justify-content:center;margin-top:12px" onclick="acRegistrar()">
          <i class="ti ti-check"></i> Registrar consumo
        </button>
      </div>

      <div class="card">
        <div class="card-title"><i class="ti ti-list"></i> Consumos do mês</div>
        <div class="ac-consom-list">${consumosHTML}</div>
      </div>
    </div>`;

  populateAcProdutos();
}

function populateAcProdutos() {
  const sel = document.getElementById('ac-produto');
  if (!sel) return;
  sel.innerHTML = produtos.map(p => {
    const preco = parseFloat(p.preco) || 0;
    return `<option value="${p.id}">${p.nome} — R$ ${preco.toFixed(2).replace('.', ',')}</option>`;
  }).join('');
}

function acAddItem() {
  const sel = document.getElementById('ac-produto');
  const produto = produtos.find(p => p.id === parseInt(sel.value));
  if (!produto) { toast('Selecione um produto!', false); return; }
  const qtd = parseFloat(document.getElementById('ac-qtd').value);
  if (!qtd || qtd <= 0) { toast('Informe uma quantidade válida!', false); return; }
  acCart.push({
    produtoId: produto.id,
    produtoNome: produto.nome,
    qtd,
    precoUnitario: parseFloat(produto.preco) || 0
  });
  document.getElementById('ac-qtd').value = 1;
  renderAcManage();
}

function acRemoveCartItem(idx) {
  acCart.splice(idx, 1);
  renderAcManage();
}

async function acRegistrar() {
  if (!acCart.length) { toast('Adicione pelo menos um item!', false); return; }
  const obs = document.getElementById('ac-obs').value;
  try {
    await apiRequest('/consumo/admin', {
      method: 'POST',
      body: JSON.stringify({ usuario_id: acUserAtivo, itens: acCart, obs })
    });
    toast('Consumo adicionado!');
    acCart = [];
    await refreshConsumoFuncionarios();
    renderConsumoDono();
    renderAcUserPicker();
    renderAcManage();
  } catch (e) {
    toast(e.message || 'Erro ao adicionar consumo', false);
  }
}

async function acRemoverItem(itemId) {
  try {
    await apiRequest(`/consumo/admin/item/${itemId}`, { method: 'DELETE' });
    toast('Item removido!');
    await refreshConsumoFuncionarios();
    renderConsumoDono();
    renderAcUserPicker();
    renderAcManage();
  } catch (e) {
    toast(e.message || 'Erro ao remover item', false);
  }
}

async function acRemoverConsumo(consumoId) {
  try {
    await apiRequest(`/consumo/admin/${consumoId}`, { method: 'DELETE' });
    toast('Consumo removido!');
    await refreshConsumoFuncionarios();
    renderConsumoDono();
    renderAcUserPicker();
    renderAcManage();
  } catch (e) {
    toast(e.message || 'Erro ao remover consumo', false);
  }
}

async function refreshConsumoFuncionarios() {
  try {
    consumoFuncionarios = await apiRequest('/consumo/funcionarios');
  } catch (e) {
    consumoFuncionarios = [];
  }
}

async function zerarConsumo(usuarioId) {
  const f = consumoFuncionarios.find(x => x.id === usuarioId);
  if (!f) return;
  showConfirm({
    title: 'Zerar consumo',
    message: `Zerar todo o consumo do mês de ${f.nome}? Essa ação não pode ser desfeita.`,
    confirmText: 'Zerar',
    icon: 'ti ti-eraser',
    onConfirm: async () => {
      try {
        await apiRequest(`/consumo/admin/zerar/${usuarioId}`, { method: 'DELETE' });
        toast('Consumo zerado!');
        await refreshConsumoFuncionarios();
        renderConsumoDono();
        renderAcUserPicker();
        renderAcManage();
      } catch (e) {
        toast(e.message || 'Erro ao zerar consumo', false);
      }
    }
  });
}

async function baixarBackup() {
  const btn = document.getElementById('btn-backup');
  const original = btn.innerHTML;
  btn.disabled = true;
  btn.innerHTML = '<i class="ti ti-loader"></i> Gerando...';

  try {
    const resp = await fetch('/api/admin/backup', {
      headers: { 'Authorization': `Bearer ${authToken}` }
    });

    if (!resp.ok) {
      const err = await resp.json().catch(() => ({}));
      throw new Error(err.error || 'Erro ao gerar backup');
    }

    const blob = await resp.blob();
    const disposition = resp.headers.get('Content-Disposition') || '';
    const match = disposition.match(/filename="?(.+?)"?$/);
    const filename = match ? match[1] : 'backup_gerenciarstock.sql';

    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    toast('Backup baixado com sucesso!');
  } catch (e) {
    toast(e.message || 'Erro ao baixar backup', false);
  } finally {
    btn.disabled = false;
    btn.innerHTML = original;
  }
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
    body.innerHTML = '<div class="empty"><i class="ti ti-users"></i>Nenhum usuário cadastrado.</div>';
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

  // Aviso quando o carrinho passa do limite do mês (somente funcionários, para o próprio usuário)
  if (currentUser.role === 'funcionario' && (!consumoUsuarioId || consumoUsuarioId === currentUser.id)) {
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

  // Não bloqueia: apenas notifica quando estiver passando do limite (só funcionários têm limite)
  let acimaLimite = false;
  if (currentUser.role === 'funcionario' && (!consumoUsuarioId || consumoUsuarioId === currentUser.id)) {
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
  const temLimite = currentUser.role === 'funcionario';
  const pct = temLimite ? Math.min((usado / LIMITE_CONSUMO) * 100, 100) : (usado > 0 ? 100 : 0);
  const restante = temLimite ? Math.max(LIMITE_CONSUMO - usado, 0) : 0;
  const restText = temLimite
    ? (restante > 0 ? `${fmtMoeda(restante)} restantes` : 'Limite atingido')
    : 'Sem limite mensal';

  // Barra na sidebar (parte da account)
  const wrapper = document.getElementById('consumo-bar-wrapper');
  if (wrapper) {
    wrapper.style.display = (currentUser.role === 'funcionario' || currentUser.role === 'dono') ? 'block' : 'none';
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
  showConfirm({
    title: 'Remover usuário',
    message: 'Remover este usuário? Esta ação não pode ser desfeita.',
    confirmText: 'Remover',
    onConfirm: async () => {
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
  });
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

      document.getElementById('caixa-troco-inicial').textContent   = fmt$(troco);
      document.getElementById('caixa-total-retiradas').textContent = fmt$(ret);

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

// ==================== CONTAGEM DE ESTOQUE ====================
let contagemServerData = null;

function renderContagem() {
  const container = document.getElementById('contagem-lista');
  if (!container) return;

  const busca = (document.getElementById('contagem-busca')?.value || '').toLowerCase().trim();
  let lista = produtos.filter(p => !isProdutoAcai(p));

  if (busca) {
    lista = lista.filter(p =>
      p.nome.toLowerCase().includes(busca) ||
      (p.categoria && p.categoria.toLowerCase().includes(busca))
    );
  }

  lista.sort((a, b) => {
    const catA = (a.categoria || '').localeCompare(b.categoria || '', 'pt-BR');
    if (catA !== 0) return catA;
    return a.nome.localeCompare(b.nome, 'pt-BR');
  });

  const count = document.getElementById('contagem-count');
  if (count) count.textContent = `${lista.length} produto(s)`;

  const saved = JSON.parse(localStorage.getItem('contagem') || '{}');
  const lastTs = contagemServerData?.data || saved._timestamp;
  const lastUser = contagemServerData?.usuario || saved._user;
  const lastEl = document.getElementById('contagem-last');
  if (lastEl) {
    if (lastTs) {
      lastEl.textContent = `Última contagem: ${fmt(lastTs)}${lastUser ? ' por ' + lastUser : ''}`;
    } else {
      lastEl.textContent = '';
    }
  }

  if (currentUser.role === 'dono') {
    const sqlBtn = document.getElementById('contagem-sql-btn');
    if (sqlBtn) sqlBtn.style.display = lastTs ? 'inline-flex' : 'none';
  }

  if (!lista.length) {
    container.innerHTML = '<div class="empty"><i class="ti ti-clipboard-check"></i>Nenhum produto encontrado.</div>';
    return;
  }

  let html = '';
  let lastCat = '';
  lista.forEach(p => {
    const cat = p.categoria || 'Sem categoria';
    if (cat !== lastCat) {
      if (lastCat) html += '</div>';
      lastCat = cat;
      html += `<div class="contagem-cat">
        <div class="contagem-cat-title"><i class="ti ti-tag"></i> ${cat}</div>
        <div class="contagem-items">`;
    }
    const val = saved[p.id] !== undefined ? saved[p.id] : '';
    html += `<div class="contagem-row">
      <span class="contagem-name">${p.nome}</span>
      <input type="number" class="contagem-input" data-id="${p.id}" value="${val}" min="0" step="0.001" placeholder="0"
        onchange="saveContagemField(${p.id}, this.value)" oninput="saveContagemField(${p.id}, this.value)">
    </div>`;
  });
  if (lastCat) html += '</div></div>';

  container.innerHTML = html;
}

function saveContagemField(id, val) {
  const saved = JSON.parse(localStorage.getItem('contagem') || '{}');
  if (val === '' || val === undefined) {
    delete saved[id];
  } else {
    saved[id] = parseFloat(val);
  }
  localStorage.setItem('contagem', JSON.stringify(saved));
}

async function confirmarContagem() {
  const inputs = document.querySelectorAll('.contagem-input');
  const items = [];
  inputs.forEach(inp => {
    if (inp.value !== '' && inp.value !== undefined && parseFloat(inp.value) >= 0) {
      items.push({ produto_id: parseInt(inp.dataset.id), qtd: parseFloat(inp.value) });
    }
  });

  if (!items.length) {
    toast('Preencha pelo menos uma quantidade antes de confirmar!', false);
    return;
  }

  try {
    const resp = await apiRequest('/contagem', {
      method: 'POST',
      body: JSON.stringify({ items })
    });

    contagemServerData = { data: resp.data, usuario: currentUser.nome };

    const saved = JSON.parse(localStorage.getItem('contagem') || '{}');
    saved._timestamp = resp.data;
    saved._user = currentUser.nome;
    localStorage.setItem('contagem', JSON.stringify(saved));

    const lastEl = document.getElementById('contagem-last');
    if (lastEl) lastEl.textContent = `Última contagem: ${fmt(resp.data)} por ${currentUser.nome}`;

    if (currentUser.role === 'dono') {
      const sqlBtn = document.getElementById('contagem-sql-btn');
      if (sqlBtn) sqlBtn.style.display = 'inline-flex';
    }

    toast(`${items.length} produto(s) confirmado(s) e salvo(s) no servidor!`);
  } catch (e) {
    toast(e.message || 'Erro ao salvar contagem!', false);
  }
}

function limparContagem() {
  showConfirm({
    title: 'Limpar contagem',
    message: 'Apagar todos os valores da contagem atual?',
    confirmText: 'Limpar',
    icon: 'ti ti-trash',
    onConfirm: () => {
      localStorage.removeItem('contagem');
      contagemServerData = null;
      renderContagem();
      toast('Contagem limpa!');
    }
  });
}

async function loadContagemServidor() {
  try {
    const data = await apiRequest('/contagem');
    if (data && data.data) {
      contagemServerData = data;
      const saved = {};
      data.items.forEach(item => {
        saved[item.produto_id] = item.qtd;
      });
      saved._timestamp = data.data;
      saved._user = data.usuario;
      localStorage.setItem('contagem', JSON.stringify(saved));
    }
  } catch (e) {
    console.error('Erro ao carregar contagem do servidor:', e);
  }
}

function salvarContagemSQL() {
  const saved = JSON.parse(localStorage.getItem('contagem') || '{}');
  const ids = Object.keys(saved).filter(k => !k.startsWith('_'));

  if (!ids.length) {
    toast('Nenhuma contagem para exportar!', false);
    return;
  }

  let sql = `-- ============================================================\n`;
  sql += `-- Contagem de Estoque - GerenciarStock\n`;
  sql += `-- Data: ${new Date().toLocaleString('pt-BR', { timeZone: 'America/Sao_Paulo' })}\n`;
  sql += `-- Produtos: ${ids.length}\n`;
  sql += `-- ============================================================\n\n`;

  ids.forEach(id => {
    const produto = produtos.find(p => p.id === parseInt(id));
    const nome = produto ? produto.nome : `Produto #${id}`;
    const qtd = saved[id];
    sql += `-- ${nome}\n`;
    sql += `UPDATE produtos SET qtd = ${qtd} WHERE id = ${id};\n`;
  });

  sql += `\n-- ============================================================\n`;
  sql += `-- Fim da contagem\n`;
  sql += `-- ============================================================\n`;

  const blob = new Blob([sql], { type: 'application/sql;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  const dateStr = new Date().toISOString().slice(0, 10);
  a.download = `contagem_estoque_${dateStr}.sql`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);

  toast('Arquivo SQL baixado com sucesso!');
}

// ==================== GASTOS ====================
let gastosData = [];
let gastosListaVisivel = false;

function toggleGastosLista() {
  gastosListaVisivel = !gastosListaVisivel;
  const section = document.getElementById('gastos-lista-section');
  const icon = document.getElementById('gastos-toggle-icon');
  const btn = document.getElementById('gastos-toggle-btn');

  if (gastosListaVisivel) {
    section.style.display = 'block';
    icon.classList.replace('ti-chevron-down', 'ti-chevron-up');
    btn.classList.add('active');
    renderGastos();
  } else {
    section.style.display = 'none';
    icon.classList.replace('ti-chevron-up', 'ti-chevron-down');
    btn.classList.remove('active');
  }
}

function updateGastosToggleCount() {
  const count = document.getElementById('gastos-toggle-count');
  if (count) count.textContent = `(${gastosData.length})`;
}

async function loadGastos() {
  try {
    gastosData = await apiRequest('/gastos');
    updateGastosToggleCount();
  } catch (e) {
    console.error('Erro ao carregar gastos:', e);
    gastosData = [];
  }
}

function updateGastosKPIs() {
  const fmt$ = v => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);
  const hoje = new Date();
  const mesAtual = gastosData.filter(g => {
    const d = new Date(g.data);
    return d.getMonth() === hoje.getMonth() && d.getFullYear() === hoje.getFullYear();
  });
  const fixosMes = mesAtual.filter(g => g.fixo).reduce((s, g) => s + (g.valor || 0), 0);
  const variaveisMes = mesAtual.filter(g => !g.fixo).reduce((s, g) => s + (g.valor || 0), 0);

  document.getElementById('gastos-fixos-total').textContent = fmt$(fixosMes);
  document.getElementById('gastos-variaveis-total').textContent = fmt$(variaveisMes);
  document.getElementById('gastos-total-mes').textContent = fmt$(fixosMes + variaveisMes);
}

function renderGastos() {
  if (!gastosListaVisivel) return;

  const fmt$ = v => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0);
  const periodo = document.getElementById('g-filtro-periodo')?.value || 'mes';

  const hoje = new Date();
  const inicioDia = new Date(); inicioDia.setHours(0, 0, 0, 0);
  const diaSemana = hoje.getDay();
  const segunda = new Date(hoje);
  segunda.setDate(hoje.getDate() - ((diaSemana + 6) % 7));
  segunda.setHours(0, 0, 0, 0);

  const filtrados = gastosData.filter(g => {
    const d = new Date(g.data);
    if (periodo === 'semana') return d >= segunda;
    if (periodo === 'hoje') return d >= inicioDia;
    return true;
  }).sort((a, b) => new Date(b.data) - new Date(a.data));

  const count = document.getElementById('g-count');
  if (count) count.textContent = `${filtrados.length} gasto(s)`;

  const tbody = document.getElementById('gastos-tbody');
  const empty = document.getElementById('gastos-empty');

  if (!filtrados.length) {
    tbody.innerHTML = '';
    empty.style.display = 'flex';
    return;
  }
  empty.style.display = 'none';

  const pagMap = {
    dinheiro: { txt: 'Dinheiro', cls: 'pag-dinheiro', ico: 'ti-cash' },
    cartao:   { txt: 'Cartão',   cls: 'pag-cartao',   ico: 'ti-credit-card' },
    pix:      { txt: 'Pix',      cls: 'pag-pix',      ico: 'ti-qrcode' },
    transferencia: { txt: 'Transferência', cls: 'pag-cartao', ico: 'ti-arrows-left-right' },
    boleto:   { txt: 'Boleto',   cls: 'pag-cartao',   ico: 'ti-file-text' }
  };

  tbody.innerHTML = filtrados.map(g => {
    const d = new Date(g.data);
    const dataFmt = d.toLocaleDateString('pt-BR');
    const pag = pagMap[g.pagamento] || pagMap.dinheiro;
    const tipoBadge = g.fixo
      ? '<span class="badge badge-amber"><i class="ti ti-repeat"></i> Fixo</span>'
      : '<span class="badge badge-blue"><i class="ti ti-random"></i> Variável</span>';
    return `<tr>
      <td style="white-space:nowrap"><i class="ti ti-clock" style="margin-right:4px;opacity:.5"></i>${dataFmt}</td>
      <td><strong>${g.descricao}</strong></td>
      <td>${g.categoria || '—'}</td>
      <td style="font-weight:700">${fmt$(g.valor)}</td>
      <td><span class="vl-card-tag ${pag.cls}"><i class="ti ${pag.ico}"></i>${pag.txt}</span></td>
      <td>${tipoBadge}</td>
      <td style="white-space:nowrap">
        <button class="btn btn-sm" style="color:var(--primary);padding:4px 6px" title="Editar" onclick="openEditarGastoById(${g.id})"><i class="ti ti-pencil"></i></button>
        <button class="btn btn-danger btn-sm" onclick="deleteGasto(${g.id})"><i class="ti ti-trash"></i></button>
      </td>
    </tr>`;
  }).join('');
}

async function addGastoFixo() {
  const descricao = document.getElementById('gf-descricao').value.trim();
  const categoria = document.getElementById('gf-categoria').value.trim() || 'Outros';
  const valor = parseFloat(document.getElementById('gf-valor').value) || 0;
  const pagamento = document.getElementById('gf-pagamento').value;

  if (!descricao) { toast('Informe a descrição do gasto fixo!', false); return; }
  if (valor <= 0) { toast('Informe um valor válido!', false); return; }

  try {
    await apiRequest('/gastos', {
      method: 'POST',
      body: JSON.stringify({ descricao, categoria, valor, pagamento, data: new Date().toISOString(), fixo: true })
    });

    await loadGastos();
    renderGastos();
    updateGastosKPIs();

    document.getElementById('gf-descricao').value = '';
    document.getElementById('gf-categoria').value = '';
    document.getElementById('gf-valor').value = '';
    toast('Gasto fixo adicionado com sucesso!');
  } catch (e) {
    toast(e.message || 'Erro ao adicionar gasto fixo!', false);
  }
}

async function addGasto() {
  const descricao = document.getElementById('g-descricao').value.trim();
  const categoria = document.getElementById('g-categoria').value.trim() || 'Outros';
  const valor = parseFloat(document.getElementById('g-valor').value) || 0;
  const pagamento = document.getElementById('g-pagamento').value;
  const data = document.getElementById('g-data').value;

  if (!descricao) { toast('Informe a descrição do gasto!', false); return; }
  if (valor <= 0) { toast('Informe um valor válido!', false); return; }

  try {
    await apiRequest('/gastos', {
      method: 'POST',
      body: JSON.stringify({ descricao, categoria, valor, pagamento, data: data || undefined, fixo: false })
    });

    await loadGastos();
    renderGastos();
    updateGastosKPIs();

    document.getElementById('g-descricao').value = '';
    document.getElementById('g-categoria').value = '';
    document.getElementById('g-valor').value = '';
    toast('Gasto adicionado com sucesso!');
  } catch (e) {
    toast(e.message || 'Erro ao adicionar gasto!', false);
  }
}

function openEditarGastoById(id) {
  const g = gastosData.find(x => x.id === id);
  if (!g) return;
  openEditarGasto(g);
}

function openEditarGasto(g) {
  document.getElementById('eg-id').value = g.id;
  document.getElementById('eg-descricao').value = g.descricao || '';
  document.getElementById('eg-categoria').value = g.categoria || '';
  document.getElementById('eg-valor').value = g.valor || '';
  document.getElementById('eg-pagamento').value = g.pagamento || 'dinheiro';
  document.getElementById('eg-data').value = g.data ? new Date(g.data).toISOString().slice(0, 10) : '';
  document.getElementById('eg-fixo').checked = !!g.fixo;
  document.getElementById('editar-gasto-modal').classList.add('show');
}

function closeEditarGasto(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById('editar-gasto-modal').classList.remove('show');
}

async function salvarEdicaoGasto() {
  const id = document.getElementById('eg-id').value;
  const descricao = document.getElementById('eg-descricao').value.trim();
  const categoria = document.getElementById('eg-categoria').value.trim() || 'Outros';
  const valor = parseFloat(document.getElementById('eg-valor').value) || 0;
  const pagamento = document.getElementById('eg-pagamento').value;
  const data = document.getElementById('eg-data').value;
  const fixo = document.getElementById('eg-fixo').checked;

  if (!descricao) { toast('Informe a descrição!', false); return; }
  if (valor <= 0) { toast('Informe um valor válido!', false); return; }

  try {
    await apiRequest(`/gastos/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ descricao, categoria, valor, pagamento, data, fixo })
    });
    closeEditarGasto();
    await loadGastos();
    renderGastos();
    updateGastosKPIs();
    toast('Gasto atualizado com sucesso!');
  } catch (e) {
    toast(e.message || 'Erro ao atualizar gasto!', false);
  }
}

async function deleteGasto(id) {
  showConfirm({
    title: 'Remover gasto',
    message: 'Deseja remover este gasto?',
    confirmText: 'Remover',
    onConfirm: async () => {
      try {
        await apiRequest(`/gastos/${id}`, { method: 'DELETE' });
        await loadGastos();
        renderGastos();
        updateGastosKPIs();
        toast('Gasto removido!');
      } catch (e) {
        toast(e.message || 'Erro ao remover gasto!', false);
      }
    }
  });
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
