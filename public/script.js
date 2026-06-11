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
  
  const navItems = ['dashboard', 'estoque', 'produtos', 'entradas', 'saidas', 'historico', 'relatorio', 'vendas', 'usuarios'];
  
  navItems.forEach(item => {
    const el = document.getElementById(`nav-${item}`);
    if (el) {
      if (item === 'vendas') {
        el.style.display = 'block';
      } else {
        el.style.display = isDono ? 'block' : 'none';
      }
    }
  });
  
  // Atualizar role na sidebar
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
  dashboard: 'Dashboard',
  estoque: 'Estoque',
  produtos: 'Produtos',
  entradas: 'Entradas',
  saidas: 'Saídas',
  historico: 'Histórico',
  relatorio: 'Relatório semanal',
  vendas: 'Comandas/Vendas',
  caixa: 'Caixa',
  usuarios: 'Usuários'
};

function nav(screen) {
  // Verificar permissão
  if (screen !== 'vendas' && screen !== 'caixa' && currentUser.role !== 'dono') {
    toast('Acesso negado!', false);
    nav('vendas');
    return;
  }

  document.querySelectorAll('.nav-item').forEach(n => n.classList.toggle('active', n.dataset.screen === screen));
  document.querySelectorAll('.mobile-nav-item').forEach(n => n.classList.toggle('active', n.dataset.screen === screen)); // Atualiza menu móvel
  document.querySelectorAll('.screen').forEach(s => s.classList.toggle('active', s.id === `screen-${screen}`));
  document.getElementById('topbar-title').textContent = titles[screen];
  
  if (screen === 'dashboard') renderDashboardProfissional();
  if (screen === 'estoque') renderEstoque();
  if (screen === 'produtos') renderProdutos();
  if (screen === 'entradas') { populateSelect('e-produto'); renderEntradas(); }
  if (screen === 'saidas') { populateSelect('s-produto'); renderSaidas(); }
  if (screen === 'historico') { populateHFiltro(); renderHistorico(); }
  if (screen === 'relatorio') renderRelatorio();
  if (screen === 'caixa') renderCaixa();
  if (screen === 'vendas') {
    vendaItens = [];
    vendaProdutoSelecionado = null; // Reset selected product
    renderVendas();
    renderVendaItens();
    atualizaPreview();
    
    if (!vendasListenersAdicionados) {
      const pagamentos = document.querySelectorAll('input[name="v-pagamento"]');
      pagamentos.forEach(input => {
        input.addEventListener('change', atualizaEstiloOpcoes);
      });

      const tiposVenda = document.querySelectorAll('input[name="v-tipo-venda"]');
      tiposVenda.forEach(input => {
        input.addEventListener('change', togglePlataforma);
      });
      vendasListenersAdicionados = true;
    }
    
    atualizaEstiloOpcoes();
  }
  if (screen === 'usuarios') renderUsuarios();
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
      topProdutosEl.innerHTML = topProdutos.map(([nome, qtd]) => `
        <div style="margin-bottom:12px">
          <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px"><span>${nome}</span><strong>${qtd} un.</strong></div>
          <div class="progress-bar"><div class="progress-fill" style="background:var(--blue);width:${Math.round((qtd/maxVendas)*100)}%"></div></div>
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
      pagamentosEl.innerHTML = `
        <div style="margin-bottom:12px">
          <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px">
            <span>Dinheiro</span><strong>${pagamentos.dinheiro} (${totalPag > 0 ? Math.round((pagamentos.dinheiro/totalPag)*100) : 0}%)</strong>
          </div>
          <div class="progress-bar"><div class="progress-fill" style="background:var(--green);width:${totalPag > 0 ? Math.round((pagamentos.dinheiro/totalPag)*100) : 0}%"></div></div>
        </div>
        <div style="margin-bottom:12px">
          <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px">
            <span>Cartão</span><strong>${pagamentos.cartao} (${totalPag > 0 ? Math.round((pagamentos.cartao/totalPag)*100) : 0}%)</strong>
          </div>
          <div class="progress-bar"><div class="progress-fill" style="background:var(--blue);width:${totalPag > 0 ? Math.round((pagamentos.cartao/totalPag)*100) : 0}%"></div></div>
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
function renderRelatorio() {
  const semEnt = movimentacoes.filter(m => m.tipo === 'entrada' && semanaAtual(m.data)).reduce((a, m) => a + m.qtd, 0);
  const semSai = movimentacoes.filter(m => m.tipo === 'saida' && semanaAtual(m.data)).reduce((a, m) => a + m.qtd, 0);
  document.getElementById('r-ent').textContent = `${semEnt} un.`;
  document.getElementById('r-sai').textContent = `${semSai} un.`;
  const totalMov = Math.max(semEnt, semSai, 1);
  document.getElementById('r-bar-ent').style.width = `${Math.round((semEnt/totalMov)*100)}%`;
  document.getElementById('r-bar-sai').style.width = `${Math.round((semSai/totalMov)*100)}%`;
  const saldo = semEnt - semSai;
  const sd = document.getElementById('r-saldo');
  sd.textContent = `${saldo >= 0 ? '+' : ''}${saldo} un.`;
  sd.style.color = saldo >= 0 ? 'var(--green)' : 'var(--red)';

  const vendasSemana = vendas.filter(v => semanaAtual(v.data));
  const totalVendas = vendasSemana.length;
  const totalVendasReais = vendasSemana.reduce((acumulador, venda) => {
    return acumulador + (venda.total || 0);
  }, 0);
  
  const totalDinheiro = vendasSemana.filter(v => v.pagamento === 'dinheiro').reduce((acumulador, venda) => {
    return acumulador + (venda.total || 0);
  }, 0);
  const totalCartao = vendasSemana.filter(v => v.pagamento === 'cartao').reduce((acumulador, venda) => {
    return acumulador + (venda.total || 0);
  }, 0);
  
  document.getElementById('r-vendas-qtd').textContent = totalVendas;
  document.getElementById('r-total-dinheiro').textContent = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(totalDinheiro);
  document.getElementById('r-total-cartao').textContent = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(totalCartao);
  document.getElementById('r-total-geral').textContent = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(totalVendasReais);

  const rankVendas = {};
  vendasSemana.forEach(venda => {
    if (venda.itens && venda.itens.length > 0) {
      venda.itens.forEach(item => {
        rankVendas[item.produto_nome] = (rankVendas[item.produto_nome] || 0) + item.qtd;
      });
    } else if (venda.produto_nome) {
      rankVendas[venda.produto_nome] = (rankVendas[venda.produto_nome] || 0) + venda.qtd;
    }
  });
  
  const sortedVendas = Object.entries(rankVendas).sort((a, b) => b[1] - a[1]).slice(0, 5);
  const rkVendas = document.getElementById('r-ranking-vendas');
  if (!sortedVendas.length) {
    rkVendas.innerHTML = '<div class="empty" style="padding:1rem">Sem vendas esta semana</div>';
  } else {
    const maxVendas = sortedVendas[0][1];
    rkVendas.innerHTML = sortedVendas.map(([nome, qtd]) => `
      <div style="margin-bottom:12px">
        <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px"><span>${nome}</span><strong>${qtd} un.</strong></div>
        <div class="progress-bar"><div class="progress-fill" style="background:var(--blue);width:${Math.round((qtd/maxVendas)*100)}%"></div></div>
      </div>
    `).join('');
  }

  const qtdDelivery = vendasSemana.filter(v => v.delivery).length;
  const qtdBalcao = vendasSemana.filter(v => !v.delivery).length;
  document.getElementById('r-delivery').textContent = qtdDelivery;
  document.getElementById('r-balcao').textContent = qtdBalcao;

  const movSemana = movimentacoes.filter(m => semanaAtual(m.data));
  const rank = {};
  movSemana.forEach(m => {
    rank[m.produto_nome] = (rank[m.produto_nome] || 0) + m.qtd;
  });
  const sorted = Object.entries(rank).sort((a, b) => b[1] - a[1]).slice(0, 5);
  const rk = document.getElementById('r-ranking');
  if (!sorted.length) {
    rk.innerHTML = '<div class="empty" style="padding:1rem">Sem movimentações esta semana</div>';
  } else {
    const max = sorted[0][1];
    rk.innerHTML = sorted.map(([nome, qtd]) => `
      <div style="margin-bottom:12px">
        <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px"><span>${nome}</span><strong>${qtd} un.</strong></div>
        <div class="progress-bar"><div class="progress-fill" style="background:var(--blue);width:${Math.round((qtd/max)*100)}%"></div></div>
      </div>
    `).join('');
  }
  
  const rt = document.getElementById('r-tabela');
  if (!produtos.length) {
    rt.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:20px;color:var(--text-secondary)">Sem produtos cadastrados</td></tr>';
    return;
  }
  rt.innerHTML = produtos.map(p => {
    const low = p.qtd <= p.qtd_minima;
    const badge = low ? '<span class="badge badge-amber">Repor</span>' : '<span class="badge badge-green">Normal</span>';
    const precoFormatado = p.preco ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(p.preco) : '—';
    return `<tr><td><strong>${p.nome}</strong></td><td>${p.categoria || '—'}</td><td>${p.qtd}</td><td>${p.qtd_minima}</td><td>${precoFormatado}</td><td>${badge}</td></tr>`;
  }).join('');

  // Renderizar fechamentos de caixa
  const rCaixas = document.getElementById('r-caixas');
  if (!caixas.length) {
    rCaixas.innerHTML = '<div class="empty">Nenhum fechamento de caixa registrado ainda</div>';
  } else {
    rCaixas.innerHTML = caixas.map(c => {
      const dataAbertura = fmt(c.data_abertura);
      const dataFechamento = c.data_fechamento ? fmt(c.data_fechamento) : '-';
      const trocoInicial = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(c.troco_inicial || 0);
      const totalVendas = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(c.total_vendas_dinheiro || 0);
      const valorFinal = c.valor_final ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(c.valor_final) : '-';
      const diferenca = c.valor_final ? 
        (c.valor_final - (c.troco_inicial + c.total_vendas_dinheiro)) : 0;
      const diferencaColor = diferenca >= 0 ? 'green' : 'red';
      const diferencaFormatada = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(Math.abs(diferenca));
      const usuarioAbertura = c.usuario_abertura?.nome || 'Desconhecido';
      const usuarioFechamento = c.usuario_fechamento?.nome || 'Desconhecido';
      
      return `
        <div class="card" style="margin-bottom:12px;padding:1rem">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
            <strong>Aberto: ${dataAbertura}</strong>
            <strong>Fechado: ${dataFechamento}</strong>
          </div>
          <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:8px">
            <div>Troco Inicial: <strong>${trocoInicial}</strong></div>
            <div>Total Vendas Dinheiro: <strong>${totalVendas}</strong></div>
            <div>Valor Final: <strong>${valorFinal}</strong></div>
            <div>Diferença: <strong style="color:var(--${diferencaColor})">${diferenca >= 0 ? '+' : ''}${diferencaFormatada}</strong></div>
            <div>Aberto por: <strong>${usuarioAbertura}</strong></div>
            <div>Fechado por: <strong>${usuarioFechamento}</strong></div>
          </div>
        </div>
      `;
    }).join('');
  }
}

// ==================== VENDAS ====================
let vendaProdutoSelecionado = null; // Track selected product for venda

function filterProdutos() {
  const searchText = document.getElementById('v-produto-search').value.toLowerCase();
  const dropdown = document.getElementById('v-produto-dropdown');
  const filteredProdutos = produtos.filter(p => 
    p.nome.toLowerCase().includes(searchText) || 
    (p.categoria && p.categoria.toLowerCase().includes(searchText))
  );
  
  if (filteredProdutos.length === 0) {
    dropdown.classList.remove('show');
    return;
  }
  
  dropdown.innerHTML = filteredProdutos.map(p => `
    <div class="autocomplete-item" onclick="selectProdutoVenda(${p.id})">
      <span class="autocomplete-item-name">${p.nome}</span>
      <span class="autocomplete-item-stock">${p.qtd} em estoque</span>
    </div>
  `).join('');
  dropdown.classList.add('show');
}

function selectProdutoVenda(produtoId) {
  const produto = produtos.find(p => p.id === produtoId);
  if (!produto) return;
  
  vendaProdutoSelecionado = produtoId;
  document.getElementById('v-produto-search').value = produto.nome;
  document.getElementById('v-produto-dropdown').classList.remove('show');
}

// Close dropdown when clicking outside
document.addEventListener('click', (e) => {
  const searchWrapper = document.querySelector('.search-wrapper');
  if (searchWrapper && !searchWrapper.contains(e.target)) {
    const dropdown = document.getElementById('v-produto-dropdown');
    if (dropdown) dropdown.classList.remove('show');
  }
});

function addItemToVenda() {
  const produtoId = vendaProdutoSelecionado;
  const qtd = parseInt(document.getElementById('v-qty').value) || 1;
  
  if (!produtoId) {
    toast('Selecione um produto!', false);
    return;
  }
  
  const produto = produtos.find(p => p.id === produtoId);
  if (qtd > produto.qtd) {
    toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
    return;
  }
  
  const existingItem = vendaItens.find(item => item.produtoId === produtoId);
  if (existingItem) {
    const newQty = existingItem.qtd + qtd;
    if (newQty > produto.qtd) {
      toast(`Estoque insuficiente! Disponível: ${produto.qtd}`, false);
      return;
    }
    existingItem.qtd = newQty;
  } else {
    vendaItens.push({
      produtoId: produtoId,
      produtoNome: produto.nome,
      qtd: qtd,
      precoUnitario: produto.preco || 0
    });
  }
  
  // Reset
  vendaProdutoSelecionado = null;
  document.getElementById('v-produto-search').value = '';
  document.getElementById('v-qty').value = '1';
  filterProdutos();
  renderVendaItens();
  atualizaPreview();
  toast('Item adicionado à venda!');
}

function removeItemFromVenda(index) {
  vendaItens.splice(index, 1);
  renderVendaItens();
  atualizaPreview();
}

function renderVendaItens() {
  const container = document.getElementById('v-itens-container');
  const empty = document.getElementById('v-itens-empty');
  
  if (!vendaItens.length) {
    container.innerHTML = '';
    empty.style.display = 'block';
    return;
  }
  
  empty.style.display = 'none';
  
  container.innerHTML = vendaItens.map((item, index) => {
    const totalItem = item.qtd * item.precoUnitario;
    return `
      <div class="venda-item-card">
        <div class="venda-item-info">
          <div class="venda-item-name">${item.produtoNome}</div>
          <div class="venda-item-meta">
            <span><i class="ti ti-packages"></i> ${item.qtd} un</span>
            <span><i class="ti ti-currency-real"></i> ${new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(item.precoUnitario)}/un</span>
          </div>
        </div>
        <div class="venda-item-total">${new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(totalItem)}</div>
        <button class="venda-item-remove" onclick="removeItemFromVenda(${index})">
          <i class="ti ti-trash"></i>
        </button>
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
  vendaProdutoSelecionado = null; // Reset selected product
  document.getElementById('v-produto-search').value = '';
  document.getElementById('v-qty').value = '1';
  document.getElementById('v-plataforma').value = '';
  document.getElementById('v-plataforma-container').style.display = 'none';
  document.getElementById('v-obs').value = '';
  // Reset hidden values and UI classes
  document.getElementById('v-pagamento-hidden').value = 'dinheiro';
  document.getElementById('v-tipo-venda-hidden').value = 'balcao';
  renderVendaItens();
  atualizaPreview();
  atualizaEstiloOpcoes();
  filterProdutos();
  renderDashboardProfissional();
  renderEstoque();
  toast('Venda registrada com sucesso!');
  } catch (error) {
    toast(error.message || 'Erro ao registrar venda!', false);
    console.error(error);
  }
}

function renderVendas() {
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

    if (historico.length) {
      historicoDiv.innerHTML = historico.map(c => {
        const dataAbertura = fmt(c.data_abertura);
        const dataFechamento = c.data_fechamento ? fmt(c.data_fechamento) : '-';
        const trocoInicial = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(c.troco_inicial || 0);
        const totalVendas = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(c.total_vendas_dinheiro || 0);
        const valorFinal = c.valor_final ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(c.valor_final) : '-';
        const diferenca = c.valor_final ? 
          (c.valor_final - (c.troco_inicial + c.total_vendas_dinheiro)) : 0;
        const diferencaColor = diferenca >= 0 ? 'green' : 'red';
        const diferencaFormatada = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(Math.abs(diferenca));
        
        const usuarioAbertura = c.usuario_abertura?.nome || 'Desconhecido';
        const usuarioFechamento = c.usuario_fechamento?.nome || 'Desconhecido';
        
        return `
          <div class="card" style="margin-bottom:12px;padding:1rem">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
              <strong>Aberto: ${dataAbertura}</strong>
              <strong>Fechado: ${dataFechamento}</strong>
            </div>
            <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:8px">
              <div>Troco Inicial: <strong>${trocoInicial}</strong></div>
              <div>Total Vendas Dinheiro: <strong>${totalVendas}</strong></div>
              <div>Valor Final: <strong>${valorFinal}</strong></div>
              <div>Diferença: <strong style="color:var(--${diferencaColor})">${diferenca >= 0 ? '+' : ''}${diferencaFormatada}</strong></div>
              <div>Aberto por: <strong>${usuarioAbertura}</strong></div>
              <div>Fechado por: <strong>${usuarioFechamento}</strong></div>
            </div>
          </div>
        `;
      }).join('');
    } else {
      historicoDiv.innerHTML = '<div class="empty">Nenhum caixa fechado ainda</div>';
    }
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
