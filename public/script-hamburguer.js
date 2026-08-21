// ==================== HAMBURGUER MODE ====================
var appMode = localStorage.getItem('appMode') || 'pastel';

function applyAppMode() {
  document.body.setAttribute('data-app', appMode);
  var isH = appMode === 'hamburguer';
  var label = document.getElementById('mode-toggle-label');
  var icon = document.getElementById('mode-toggle-icon');
  var logoTitle = document.getElementById('sidebar-logo-title');
  var logoSub = document.getElementById('sidebar-logo-sub');
  if (label) label.textContent = isH ? 'Pastel de Rei' : 'Hamburguer';
  if (icon) icon.className = isH ? 'ti ti-cake' : 'ti ti-burger';
  if (logoTitle) logoTitle.innerHTML = isH ? '<i class="ti ti-burger"></i> Hamburguer' : '<i class="ti ti-box"></i> Pastel de Rei';
  if (logoSub) logoSub.textContent = isH ? 'PDV Hamburguer' : 'Sistema de estoque';
  document.querySelectorAll('.hamburguer-only').forEach(function(el) { el.style.display = isH ? '' : 'none'; });
  document.querySelectorAll('#nav .nav-item').forEach(function(el) {
    if (!el.classList.contains('hamburguer-only')) el.style.display = isH ? 'none' : '';
  });
  document.querySelectorAll('#mobileNav .mobile-nav-item').forEach(function(el) {
    if (!el.classList.contains('hamburguer-only')) el.style.display = isH ? 'none' : '';
  });
  var adminSec = document.getElementById('nav-admin-section');
  var funcSec = document.getElementById('nav-func-section');
  var mobileAdmin = document.getElementById('mobile-admin-section');
  var mobileFunc = document.getElementById('mobile-func-section');
  if (adminSec) adminSec.style.display = isH ? 'none' : '';
  if (funcSec) funcSec.style.display = isH ? 'none' : '';
  if (mobileAdmin) mobileAdmin.style.display = isH ? 'none' : '';
  if (mobileFunc) mobileFunc.style.display = isH ? 'none' : '';
}

function toggleAppMode() {
  appMode = appMode === 'pastel' ? 'hamburguer' : 'pastel';
  localStorage.setItem('appMode', appMode);
  applyAppMode();
  if (appMode === 'hamburguer') nav('h-dashboard');
  else nav('dashboard');
}

var hTitles = {
  'h-dashboard': 'Dashboard',
  'h-estoque': 'Estoque',
  'h-vendas': 'Vendas',
  'h-pdv': 'PDV',
  'h-produtos': 'Produtos',
  'h-caixa': 'Caixa'
};

// ==================== HAMBURGUER PDV ====================
var hpdvCardapio = [
  { id: 1, nome: "Smash Burger", desc: "2 smash 80g, queijo duplo, cebola caramelizada e molho especial", preco: 29.90, emoji: "\uD83D\uDCA5", categoria: "Especiais", tags: ["popular"],
    ingredientes: [
      { id: "pao", nome: "Pao smash", icone: "\uD83C\uDF5E", removivel: false },
      { id: "smash", nome: "2x Smash 80g", icone: "\uD83E\uDD69", removivel: false },
      { id: "queijo", nome: "Queijo duplo", icone: "\uD83E\uDDC0", removivel: true },
      { id: "cebola", nome: "Cebola caramelizada", icone: "\uD83E\uDDC5", removivel: true },
      { id: "molho", nome: "Molho especial", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "bacon", nome: "Bacon", icone: "\uD83E\uDD53", preco: 4.00 },
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "cheddar", nome: "Cheddar extra", icone: "\uD83E\uDDC0", preco: 3.00 },
      { id: "jalapeno", nome: "Jalapeno", icone: "\uD83C\uDF36\uFE0F", preco: 2.50 }
    ]
  },
  { id: 2, nome: "Classic Burger", desc: "Pao brioche, hamburguer 150g, cheddar, alface, tomate e molho especial", preco: 22.90, emoji: "\uD83C\uDF54", categoria: "Classicos", tags: [],
    ingredientes: [
      { id: "pao", nome: "Pao brioche", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "Hamburguer 150g", icone: "\uD83E\uDD69", removivel: false },
      { id: "cheddar", nome: "Queijo cheddar", icone: "\uD83E\uDDC0", removivel: true },
      { id: "alface", nome: "Alface", icone: "\uD83E\uDD6C", removivel: true },
      { id: "tomate", nome: "Tomate", icone: "\uD83C\uDF45", removivel: true },
      { id: "molho", nome: "Molho especial", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "bacon", nome: "Bacon", icone: "\uD83E\uDD53", preco: 4.00 },
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "onion_rings", nome: "Onion rings", icone: "\uD83E\uDDC5", preco: 5.00 }
    ]
  },
  { id: 3, nome: "Cheese Burger", desc: "Pao brioche, hamburguer 150g, 2x cheddar e molho da casa", preco: 24.90, emoji: "\uD83E\uDDC0", categoria: "Classicos", tags: [],
    ingredientes: [
      { id: "pao", nome: "Pao brioche", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "Hamburguer 150g", icone: "\uD83E\uDD69", removivel: false },
      { id: "cheddar", nome: "Cheddar duplo", icone: "\uD83E\uDDC0", removivel: true },
      { id: "molho", nome: "Molho da casa", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "bacon", nome: "Bacon", icone: "\uD83E\uDD53", preco: 4.00 },
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "presunto", nome: "Presunto", icone: "\uD83C\uDF56", preco: 3.00 }
    ]
  },
  { id: 4, nome: "Bacon Burger", desc: "Pao brioche, hamburguer 150g, queijo, bacon crocante e molho BBQ", preco: 27.90, emoji: "\uD83E\uDD53", categoria: "Classicos", tags: ["popular"],
    ingredientes: [
      { id: "pao", nome: "Pao brioche", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "Hamburguer 150g", icone: "\uD83E\uDD69", removivel: false },
      { id: "cheddar", nome: "Queijo cheddar", icone: "\uD83E\uDDC0", removivel: true },
      { id: "bacon", nome: "Bacon crocante", icone: "\uD83E\uDD53", removivel: true },
      { id: "alface", nome: "Alface", icone: "\uD83E\uDD6C", removivel: true },
      { id: "molho_bbq", nome: "Molho BBQ", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "onion_rings", nome: "Onion rings", icone: "\uD83E\uDDC5", preco: 5.00 },
      { id: "cheddar", nome: "Cheddar extra", icone: "\uD83E\uDDC0", preco: 3.00 }
    ]
  },
  { id: 5, nome: "Mushroom Burger", desc: "Pao brioche, hamburguer 150g, queijo suico, cogumelos e molho trufado", preco: 32.90, emoji: "\uD83C\uDF44", categoria: "Especiais", tags: ["novo"],
    ingredientes: [
      { id: "pao", nome: "Pao brioche", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "Hamburguer 150g", icone: "\uD83E\uDD69", removivel: false },
      { id: "queijo_sui", nome: "Queijo suico", icone: "\uD83E\uDDC0", removivel: true },
      { id: "cogumelos", nome: "Cogumelos grelhados", icone: "\uD83C\uDF44", removivel: true },
      { id: "molho_truf", nome: "Molho trufado", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "bacon", nome: "Bacon", icone: "\uD83E\uDD53", preco: 4.00 },
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "rucula", nome: "Rucula", icone: "\uD83C\uDF3F", preco: 2.00 }
    ]
  },
  { id: 6, nome: "BBQ Bacon", desc: "Pao australiano, hamburguer 180g, queijo, bacon, onion rings e BBQ defumado", preco: 34.90, emoji: "\uD83D\uDD25", categoria: "Especiais", tags: ["popular"],
    ingredientes: [
      { id: "pao", nome: "Pao australiano", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "Hamburguer 180g", icone: "\uD83E\uDD69", removivel: false },
      { id: "cheddar", nome: "Queijo cheddar", icone: "\uD83E\uDDC0", removivel: true },
      { id: "bacon", nome: "Bacon defumado", icone: "\uD83E\uDD53", removivel: true },
      { id: "onion_rings", nome: "Onion rings", icone: "\uD83E\uDDC5", removivel: true },
      { id: "molho_bbq", nome: "Molho BBQ defumado", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "cheddar", nome: "Cheddar extra", icone: "\uD83E\uDDC0", preco: 3.00 },
      { id: "jalapeno", nome: "Jalapeno", icone: "\uD83C\uDF36\uFE0F", preco: 2.50 }
    ]
  },
  { id: 7, nome: "Double Cheddar", desc: "Pao brioche, 2x hamburguer 150g, 3x cheddar, alface e molho especial", preco: 36.90, emoji: "\uD83C\uDF54", categoria: "Duplos", tags: [],
    ingredientes: [
      { id: "pao", nome: "Pao brioche", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "2x Hamburguer 150g", icone: "\uD83E\uDD69", removivel: false },
      { id: "cheddar", nome: "3x Queijo cheddar", icone: "\uD83E\uDDC0", removivel: true },
      { id: "alface", nome: "Alface", icone: "\uD83E\uDD6C", removivel: true },
      { id: "molho", nome: "Molho especial", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "bacon", nome: "Bacon", icone: "\uD83E\uDD53", preco: 4.00 },
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", preco: 2.50 },
      { id: "onion_rings", nome: "Onion rings", icone: "\uD83E\uDDC5", preco: 5.00 }
    ]
  },
  { id: 8, nome: "Monster Burger", desc: "Pao australiano, 3x hamburguer 150g, queijo, bacon, ovo, alface, tomate", preco: 45.90, emoji: "\uD83D\uDC51", categoria: "Duplos", tags: [],
    ingredientes: [
      { id: "pao", nome: "Pao australiano", icone: "\uD83C\uDF5E", removivel: false },
      { id: "hamburg", nome: "3x Hamburguer 150g", icone: "\uD83E\uDD69", removivel: false },
      { id: "cheddar", nome: "Queijo cheddar", icone: "\uD83E\uDDC0", removivel: true },
      { id: "bacon", nome: "Bacon", icone: "\uD83E\uDD53", removivel: true },
      { id: "ovo", nome: "Ovo frito", icone: "\uD83C\uDF73", removivel: true },
      { id: "alface", nome: "Alface", icone: "\uD83E\uDD6C", removivel: true },
      { id: "tomate", nome: "Tomate", icone: "\uD83C\uDF45", removivel: true },
      { id: "molho", nome: "Molho especial", icone: "\uD83E\uDED9", removivel: true }
    ],
    extras: [
      { id: "cheddar", nome: "Cheddar extra", icone: "\uD83E\uDDC0", preco: 3.00 },
      { id: "onion_rings", nome: "Onion rings", icone: "\uD83E\uDDC5", preco: 5.00 },
      { id: "jalapeno", nome: "Jalapeno", icone: "\uD83C\uDF36\uFE0F", preco: 2.50 }
    ]
  }
];

var hpdvComandaItens = [];
var hpdvCatAtiva = "Todos";
var hpdvModalLanche = null;
var hpdvModalQtd = 1;
var hpdvModalIngs = [];
var hpdvModalExtras = [];

function hpdvFmt(v) { return "R$ " + v.toFixed(2).replace(".", ","); }

function hpdvGetCategorias() {
  var cats = [];
  hpdvCardapio.forEach(function(l) { if (cats.indexOf(l.categoria) === -1) cats.push(l.categoria); });
  return ["Todos"].concat(cats);
}

function hpdvRenderCategorias() {
  var el = document.getElementById("hpdv-categorias");
  if (!el) return;
  el.innerHTML = hpdvGetCategorias().map(function(c) {
    return '<button class="hpdv-cat-btn' + (c === hpdvCatAtiva ? ' active' : '') + '" onclick="hpdvSelectCat(\'' + c + '\')">' + c + '</button>';
  }).join("");
}

function hpdvSelectCat(c) { hpdvCatAtiva = c; hpdvRenderCategorias(); hpdvRenderCardapio(); }

function hpdvRenderCardapio() {
  var grid = document.getElementById("hpdv-cardapio-grid");
  if (!grid) return;
  var busca = (document.getElementById("hpdv-busca") ? document.getElementById("hpdv-busca").value : "").toLowerCase().trim();
  var lista = hpdvCardapio;
  if (hpdvCatAtiva !== "Todos") lista = lista.filter(function(l) { return l.categoria === hpdvCatAtiva; });
  if (busca) lista = lista.filter(function(l) { return l.nome.toLowerCase().indexOf(busca) !== -1 || l.desc.toLowerCase().indexOf(busca) !== -1; });
  grid.innerHTML = lista.map(function(l) {
    var tags = l.tags.map(function(t) {
      if (t === "popular") return '<span class="hpdv-lanche-tag hpdv-tag-popular">Popular</span>';
      if (t === "novo") return '<span class="hpdv-lanche-tag hpdv-tag-novo">Novo</span>';
      return '';
    }).join("");
    return '<div class="hpdv-lanche-card" onclick="hpdvAbrirModal(' + l.id + ')">' +
      '<span class="hpdv-lanche-emoji">' + l.emoji + '</span>' +
      '<div class="hpdv-lanche-info"><div class="hpdv-lanche-nome">' + l.nome + '</div>' +
      '<div class="hpdv-lanche-desc">' + l.desc + '</div></div>' +
      '<div class="hpdv-lanche-rodape"><span class="hpdv-lanche-preco">' + hpdvFmt(l.preco) + '</span>' + tags + '</div></div>';
  }).join("");
}

function hpdvAbrirModal(id) {
  hpdvModalLanche = hpdvCardapio.find(function(l) { return l.id === id; });
  if (!hpdvModalLanche) return;
  hpdvModalQtd = 1;
  hpdvModalIngs = hpdvModalLanche.ingredientes.map(function(i) { return Object.assign({}, i, { ativo: true }); });
  hpdvModalExtras = hpdvModalLanche.extras.map(function(e) { return Object.assign({}, e, { qtd: 0 }); });
  document.getElementById("hpdv-modal-emoji").textContent = hpdvModalLanche.emoji;
  document.getElementById("hpdv-modal-nome").textContent = hpdvModalLanche.nome;
  document.getElementById("hpdv-modal-desc").textContent = hpdvModalLanche.desc;
  document.getElementById("hpdv-modal-obs").value = "";
  document.getElementById("hpdv-modal-qtd").textContent = "1";
  hpdvRenderModalIngs();
  hpdvRenderModalExtras();
  hpdvAtualizarModalTotal();
  document.getElementById("hpdv-modal-overlay").classList.add("show");
}

function hpdvFecharModal(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById("hpdv-modal-overlay").classList.remove("show");
}

function hpdvRenderModalIngs() {
  var el = document.getElementById("hpdv-modal-ingredientes");
  el.innerHTML = hpdvModalIngs.map(function(ing, i) {
    return '<div class="hpdv-ingrediente-item' + (ing.removivel && !ing.ativo ? ' removido' : '') + '">' +
      '<div class="hpdv-ingrediente-esq"><span class="hpdv-ingrediente-ic">' + ing.icone + '</span>' +
      '<span class="hpdv-ingrediente-nome">' + ing.nome + '</span></div>' +
      (ing.removivel
        ? '<button class="hpdv-ing-toggle' + (ing.ativo ? '' : ' off') + '" onclick="hpdvToggleIng(' + i + ')"></button>'
        : '<span style="font-size:11px;color:var(--text-muted)">base</span>') +
      '</div>';
  }).join("");
}

function hpdvToggleIng(i) {
  hpdvModalIngs[i].ativo = !hpdvModalIngs[i].ativo;
  hpdvRenderModalIngs();
  hpdvAtualizarModalTotal();
}

function hpdvRenderModalExtras() {
  var el = document.getElementById("hpdv-modal-extras");
  el.innerHTML = hpdvModalExtras.map(function(ext, i) {
    return '<div class="hpdv-extra-item"><div class="hpdv-extra-esq"><span class="hpdv-extra-ic">' + ext.icone + '</span>' +
      '<div class="hpdv-extra-info"><span class="hpdv-extra-nome">' + ext.nome + '</span>' +
      '<span class="hpdv-extra-preco">+' + hpdvFmt(ext.preco) + '</span></div></div>' +
      '<div class="hpdv-extra-controle"><button onclick="hpdvMudarExtra(' + i + ',-1)"><i class="ti ti-minus"></i></button>' +
      '<span class="hpdv-extra-qtd">' + ext.qtd + '</span>' +
      '<button onclick="hpdvMudarExtra(' + i + ',1)"><i class="ti ti-plus"></i></button></div></div>';
  }).join("");
}

function hpdvMudarExtra(i, delta) {
  hpdvModalExtras[i].qtd = Math.max(0, hpdvModalExtras[i].qtd + delta);
  hpdvRenderModalExtras();
  hpdvAtualizarModalTotal();
}

function hpdvMudarQtd(delta) {
  hpdvModalQtd = Math.max(1, Math.min(20, hpdvModalQtd + delta));
  document.getElementById("hpdv-modal-qtd").textContent = hpdvModalQtd;
  hpdvAtualizarModalTotal();
}

function hpdvAtualizarModalTotal() {
  var precoBase = hpdvModalLanche.preco;
  var totalExtras = hpdvModalExtras.reduce(function(s, e) { return s + (e.preco * e.qtd); }, 0);
  var total = (precoBase + totalExtras) * hpdvModalQtd;
  document.getElementById("hpdv-modal-total").textContent = hpdvFmt(total);
}

function hpdvAdicionarAoPedido() {
  if (!hpdvModalLanche) return;
  if (typeof acquire === 'function' && !acquire('hpdvAdd')) return;
  try {
    var ingsMarcados = hpdvModalIngs.filter(function(i) { return i.removivel && !i.ativo; });
    var extrasSel = hpdvModalExtras.filter(function(e) { return e.qtd > 0; });
    var totalExtras = extrasSel.reduce(function(s, e) { return s + (e.preco * e.qtd); }, 0);
    var precoUnit = hpdvModalLanche.preco + totalExtras;
    var obs = document.getElementById("hpdv-modal-obs").value.trim();
    hpdvComandaItens.push({
      id: Date.now(), lancheId: hpdvModalLanche.id, nome: hpdvModalLanche.nome,
      emoji: hpdvModalLanche.emoji, qtd: hpdvModalQtd, precoUnit: precoUnit,
      total: precoUnit * hpdvModalQtd, removidos: ingsMarcados.map(function(i) { return i.nome; }),
      adicionados: extrasSel.map(function(e) { return e.nome + ' x' + e.qtd; }), obs: obs
    });
    hpdvFecharModal();
    hpdvRenderComanda();
  } finally {
    if (typeof release === 'function') release('hpdvAdd');
  }
}

function hpdvRenderComanda() {
  var container = document.getElementById("hpdv-comanda-itens");
  var vazio = document.getElementById("hpdv-comanda-vazio");
  if (!container) return;
  if (!hpdvComandaItens.length) {
    container.innerHTML = "";
    if (vazio) { container.appendChild(vazio); vazio.style.display = "block"; }
    hpdvAtualizarTotal();
    return;
  }
  if (vazio) vazio.style.display = "none";
  container.innerHTML = hpdvComandaItens.map(function(item, idx) {
    var custom = [];
    if (item.removidos.length) custom.push('<span class="removido">Sem ' + item.removidos.join(", ") + '</span>');
    if (item.adicionados.length) custom.push('<span class="adicionado">+ ' + item.adicionados.join(", ") + '</span>');
    var customHtml = custom.length ? '<div class="hpdv-comanda-item-custom">' + custom.join(" . ") + '</div>' : "";
    var obsHtml = item.obs ? '<div class="hpdv-comanda-item-obs"><i class="ti ti-note"></i> ' + item.obs + '</div>' : "";
    return '<div class="hpdv-comanda-item">' +
      '<div class="hpdv-comanda-item-topo"><span class="hpdv-comanda-item-nome">' + item.emoji + ' ' + item.nome + '</span>' +
      '<span class="hpdv-comanda-item-qtd">x' + item.qtd + '</span></div>' +
      customHtml + obsHtml +
      '<div class="hpdv-comanda-item-bottom"><div class="hpdv-comanda-item-acoes">' +
      '<button onclick="hpdvMudarItemQtd(' + idx + ',-1)"><i class="ti ti-minus"></i></button>' +
      '<button onclick="hpdvMudarItemQtd(' + idx + ',1)"><i class="ti ti-plus"></i></button>' +
      '<button class="hpdv-btn-remover" onclick="hpdvRemoverItem(' + idx + ')"><i class="ti ti-trash"></i></button>' +
      '</div><span class="hpdv-comanda-item-valor">' + hpdvFmt(item.total) + '</span></div></div>';
  }).join("");
  hpdvAtualizarTotal();
}

function hpdvMudarItemQtd(idx, delta) {
  var item = hpdvComandaItens[idx];
  if (!item) return;
  item.qtd += delta;
  if (item.qtd <= 0) { hpdvComandaItens.splice(idx, 1); }
  else { item.total = item.precoUnit * item.qtd; }
  hpdvRenderComanda();
}

function hpdvRemoverItem(idx) {
  hpdvComandaItens.splice(idx, 1);
  hpdvRenderComanda();
}

function hpdvAtualizarTotal() {
  var total = hpdvComandaItens.reduce(function(s, i) { return s + i.total; }, 0);
  var el = document.getElementById("hpdv-comanda-total");
  if (el) el.textContent = hpdvFmt(total);
}

function hpdvLimparComanda() {
  if (!hpdvComandaItens.length) return;
  hpdvComandaItens = [];
  hpdvRenderComanda();
}

function hpdvFinalizarComanda() {
  if (!hpdvComandaItens.length) return;
  var num = document.getElementById("hpdv-comanda-num") ? document.getElementById("hpdv-comanda-num").value : "";
  var clienteEl = document.getElementById("hpdv-cliente-nome");
  var cliente = clienteEl && clienteEl.value.trim() ? clienteEl.value.trim() : "Sem nome";
  var total = hpdvComandaItens.reduce(function(s, i) { return s + i.total; }, 0);
  var agora = new Date();
  var hora = agora.toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" });
  var html = '<div class="hpdv-resumo-info"><span>Comanda No</span><strong>' + (num || "\u2014") + '</strong></div>' +
    '<div class="hpdv-resumo-info"><span>Cliente</span><strong>' + cliente + '</strong></div>' +
    '<div class="hpdv-resumo-info"><span>Hora</span><strong>' + hora + '</strong></div>' +
    '<div style="margin-top:.75rem">';
  hpdvComandaItens.forEach(function(item) {
    var custom = [];
    if (item.removidos.length) custom.push("Sem " + item.removidos.join(", "));
    if (item.adicionados.length) custom.push("+ " + item.adicionados.join(", "));
    html += '<div class="hpdv-resumo-item">' +
      '<div class="hpdv-resumo-item-top"><span class="hpdv-resumo-item-nome">' + item.emoji + ' ' + item.nome + '</span>' +
      '<span class="hpdv-resumo-item-qtd">x' + item.qtd + '</span></div>';
    if (custom.length) html += '<div class="hpdv-resumo-item-custom">' + custom.join(" . ") + '</div>';
    if (item.obs) html += '<div class="hpdv-resumo-item-custom" style="color:var(--yellow)">' + item.obs + '</div>';
    html += '<div class="hpdv-resumo-item-valor">' + hpdvFmt(item.total) + '</div></div>';
  });
  html += '</div><div class="hpdv-resumo-total"><span>Total</span><strong>' + hpdvFmt(total) + '</strong></div>';
  document.getElementById("hpdv-resumo-body").innerHTML = html;
  document.getElementById("hpdv-resumo-overlay").classList.add("show");
}

function hpdvFecharResumo(e) {
  if (e && e.target !== e.currentTarget) return;
  document.getElementById("hpdv-resumo-overlay").classList.remove("show");
  hpdvComandaItens = [];
  hpdvRenderComanda();
  var numEl = document.getElementById("hpdv-comanda-num");
  var clienteEl = document.getElementById("hpdv-cliente-nome");
  var obsEl = document.getElementById("hpdv-comanda-obs");
  if (numEl) numEl.value = "";
  if (clienteEl) clienteEl.value = "";
  if (obsEl) obsEl.value = "";
}

// ==================== HAMBURGUER ESTOQUE (placeholder) ====================
function hRenderEstoque() {
  var tbody = document.getElementById("h-estoque-tbody");
  if (tbody) tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;color:var(--text-muted);padding:2rem">Estoque em construcao...</td></tr>';
}

function hRenderProdutos() {
  var tbody = document.getElementById("h-prod-tbody");
  if (tbody) tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--text-muted);padding:2rem">Produtos em construcao...</td></tr>';
}

function hAbrirModalProduto() {
  toast('Funcionalidade em breve!');
}

function renderHDashboard() {
  var el = document.getElementById("screen-h-dashboard");
  if (!el) return;
  var kpiVendas = document.getElementById("h-kpi-vendas-hoje");
  var kpiLanches = document.getElementById("h-kpi-lanches");
  var kpiEstoque = document.getElementById("h-kpi-estoque-baixo");
  var kpiTicket = document.getElementById("h-kpi-ticket");
  if (kpiVendas) kpiVendas.textContent = "R$ 0,00";
  if (kpiLanches) kpiLanches.textContent = "0";
  if (kpiEstoque) kpiEstoque.textContent = "0";
  if (kpiTicket) kpiTicket.textContent = "R$ 0,00";
}

function hRenderVendas() {
  var el = document.getElementById("h-vendas-lista");
  if (el) el.innerHTML = '<p>Nenhuma venda registrada ainda.</p>';
}

function hRenderCaixa() {
  // placeholder - caixa screen already has static content
}
