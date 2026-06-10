const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'seu-segredo-jwt-muito-seguro-123';

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '.')));

// Serve the HTML file as the default route
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Conectar ao banco de dados SQLite
const db = new sqlite3.Database('./estoque_new.db', (err) => {
  if (err) {
    console.error(err.message);
  } else {
    console.log('Conectado ao banco de dados SQLite!');
    initializeDatabase();
  }
});

// Rota para redefinir senha do admin (apenas para desenvolvimento!)
app.post('/api/reset-admin-password', async (req, res) => {
  const { novaSenha } = req.body;
  if (!novaSenha) {
    return res.status(400).json({ error: 'Informe a nova senha' });
  }
  const senhaHash = await bcrypt.hash(novaSenha, 10);
  db.run('UPDATE usuarios SET senha = ? WHERE usuario = ?', [senhaHash, 'admin'], function(err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Senha do admin redefinida com sucesso!', novaSenha });
  });
});

// Inicializar tabelas do banco de dados
function initializeDatabase() {
  db.serialize(() => {
    // Tabela de Usuários
    db.run(`CREATE TABLE IF NOT EXISTS usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      usuario TEXT NOT NULL UNIQUE,
      senha TEXT NOT NULL,
      role TEXT NOT NULL CHECK(role IN ('dono', 'funcionario')) DEFAULT 'funcionario'
    )`, async (err) => {
      if (err) {
        console.error('Erro ao criar tabela de usuários:', err);
      } else {
        // Verificar se já existe um usuário admin, se não, criar um padrão
        db.get('SELECT id FROM usuarios WHERE usuario = ?', ['admin'], async (err, row) => {
          if (!row) {
            const senhaHash = await bcrypt.hash('admin123', 10);
            db.run('INSERT INTO usuarios (nome, usuario, senha, role) VALUES (?, ?, ?, ?)', 
              ['Administrador', 'admin', senhaHash, 'dono']);
            console.log('Usuário padrão criado: admin / admin123');
          }
        });
      }
    });

    // Tabela de Produtos
    db.run(`CREATE TABLE IF NOT EXISTS produtos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      categoria TEXT,
      qtd INTEGER DEFAULT 0,
      qtd_minima INTEGER DEFAULT 0,
      preco REAL DEFAULT 0
    )`);

    // Tabela de Movimentações
    db.run(`CREATE TABLE IF NOT EXISTS movimentacoes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tipo TEXT NOT NULL,
      produto_id INTEGER,
      produto_nome TEXT,
      qtd INTEGER,
      obs TEXT,
      data DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (produto_id) REFERENCES produtos (id)
    )`);

    // Tabela de Vendas
    db.run(`CREATE TABLE IF NOT EXISTS vendas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      total REAL DEFAULT 0,
      pagamento TEXT,
      delivery INTEGER DEFAULT 0,
      plataforma TEXT,
      obs TEXT,
      data DATETIME DEFAULT CURRENT_TIMESTAMP
    )`);

    // Tabela de Itens de Venda
    db.run(`CREATE TABLE IF NOT EXISTS venda_itens (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      venda_id INTEGER,
      produto_id INTEGER,
      produto_nome TEXT,
      qtd INTEGER,
      preco_unitario REAL,
      FOREIGN KEY (venda_id) REFERENCES vendas (id),
      FOREIGN KEY (produto_id) REFERENCES produtos (id)
    )`);
  });
}

// Middleware de autenticação
const autenticar = (req, res, next) => {
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
};

// ==================== USUARIOS / AUTH ====================
app.post('/api/auth/login', async (req, res) => {
  const { usuario, senha } = req.body;
  if (!usuario || !senha) {
    return res.status(400).json({ error: 'Informe usuário e senha' });
  }

  db.get('SELECT * FROM usuarios WHERE usuario = ?', [usuario], async (err, user) => {
    if (err) {
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
    if (!user) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const senhaValida = await bcrypt.compare(senha, user.senha);
    if (!senhaValida) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const token = jwt.sign({ id: user.id, usuario: user.usuario, role: user.role }, JWT_SECRET, { expiresIn: '24h' });
    res.json({ 
      token, 
      usuario: { id: user.id, nome: user.nome, usuario: user.usuario, role: user.role } 
    });
  });
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
  db.run('INSERT INTO usuarios (nome, usuario, senha, role) VALUES (?, ?, ?, ?)', 
    [nome, usuario, senhaHash, role || 'funcionario'], function(err) {
    if (err) {
      if (err.message.includes('UNIQUE constraint failed')) {
        return res.status(400).json({ error: 'Usuário já cadastrado' });
      }
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
    res.json({ id: this.lastID, nome, usuario, role: role || 'funcionario' });
  });
});

app.get('/api/usuarios', autenticar, (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  db.all('SELECT id, nome, usuario, role FROM usuarios', [], (err, usuarios) => {
    if (err) {
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
    res.json(usuarios);
  });
});

app.delete('/api/usuarios/:id', autenticar, (req, res) => {
  // Apenas donos podem deletar usuários
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { id } = req.params;
  if (parseInt(id) === req.usuario.id) {
    return res.status(400).json({ error: 'Você não pode deletar seu próprio usuário' });
  }

  db.run('DELETE FROM usuarios WHERE id = ?', [id], function(err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ deleted: this.changes });
  });
});

// Atualizar usuário
app.put('/api/usuarios/:id', autenticar, async (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }

  const { id } = req.params;
  const { nome, usuario, senha, role } = req.body;

  // Validação básica
  if (!nome || !usuario) {
    return res.status(400).json({ error: 'Nome e usuário são obrigatórios' });
  }

  // Verificar se o usuário já existe para outro ID
  db.get('SELECT id FROM usuarios WHERE usuario = ? AND id != ?', [usuario, id], async (err, row) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (row) {
      return res.status(400).json({ error: 'Usuário já está em uso' });
    }

    // Se senha for fornecida, hasheá-la, senão manter a mesma
    if (senha) {
      const senhaHash = await bcrypt.hash(senha, 10);
      db.run(
        'UPDATE usuarios SET nome = ?, usuario = ?, senha = ?, role = ? WHERE id = ?',
        [nome, usuario, senhaHash, role, id],
        function(err) {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.json({ id, nome, usuario, role });
        }
      );
    } else {
      db.run(
        'UPDATE usuarios SET nome = ?, usuario = ?, role = ? WHERE id = ?',
        [nome, usuario, role, id],
        function(err) {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.json({ id, nome, usuario, role });
        }
      );
    }
  });
});

// ==================== API ENDPOINTS (PROTEGIDOS) ====================
// PRODUTOS
app.get('/api/produtos', autenticar, (req, res) => {
  db.all('SELECT * FROM produtos', [], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

app.post('/api/produtos', autenticar, (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  const { nome, categoria, qtd, qtd_minima, preco } = req.body;
  const sql = 'INSERT INTO produtos (nome, categoria, qtd, qtd_minima, preco) VALUES (?, ?, ?, ?, ?)';
  db.run(sql, [nome, categoria, qtd || 0, qtd_minima || 0, preco || 0], function(err) {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ id: this.lastID, nome, categoria, qtd: qtd || 0, qtd_minima: qtd_minima || 0, preco: preco || 0 });
  });
});

app.delete('/api/produtos/:id', autenticar, (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  const { id } = req.params;
  db.run('DELETE FROM produtos WHERE id = ?', [id], function(err) {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ deleted: this.changes });
  });
});

// MOVIMENTAÇÕES
app.get('/api/movimentacoes', autenticar, (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  db.all('SELECT * FROM movimentacoes ORDER BY data DESC', [], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

app.post('/api/movimentacoes', autenticar, (req, res) => {
  if (req.usuario.role !== 'dono') {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  const { tipo, produto_id, produto_nome, qtd, obs } = req.body;
  const sql = 'INSERT INTO movimentacoes (tipo, produto_id, produto_nome, qtd, obs) VALUES (?, ?, ?, ?, ?)';
  db.run(sql, [tipo, produto_id, produto_nome, qtd, obs], function(err) {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }

    const updateSql = tipo === 'entrada' 
      ? 'UPDATE produtos SET qtd = qtd + ? WHERE id = ?'
      : 'UPDATE produtos SET qtd = qtd - ? WHERE id = ?';
    
    db.run(updateSql, [qtd, produto_id], (updateErr) => {
      if (updateErr) {
        res.status(500).json({ error: updateErr.message });
        return;
      }
      res.json({ id: this.lastID, tipo, produto_id, produto_nome, qtd, obs });
    });
  });
});

// VENDAS
app.get('/api/vendas', autenticar, (req, res) => {
  db.all('SELECT * FROM vendas ORDER BY data DESC', [], (err, vendas) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }

    if (vendas.length === 0) {
      res.json([]);
      return;
    }

    const vendasComItens = [];
    let completedCount = 0;

    vendas.forEach(venda => {
      db.all('SELECT * FROM venda_itens WHERE venda_id = ?', [venda.id], (errItens, itens) => {
        if (errItens) {
          console.error('Erro ao buscar itens da venda:', errItens.message);
        }
        vendasComItens.push({ ...venda, itens: itens || [] });
        completedCount++;

        if (completedCount === vendas.length) {
          res.json(vendasComItens);
        }
      });
    });
  });
});

app.post('/api/vendas', autenticar, (req, res) => {
  const { itens, total, pagamento, delivery, plataforma, obs } = req.body;
  const vendaSql = 'INSERT INTO vendas (total, pagamento, delivery, plataforma, obs) VALUES (?, ?, ?, ?, ?)';
  
  db.run(vendaSql, [total || 0, pagamento, delivery ? 1 : 0, plataforma, obs], function(vendaErr) {
    if (vendaErr) {
      res.status(500).json({ error: vendaErr.message });
      return;
    }

    const vendaId = this.lastID;
    
    if (!itens || itens.length === 0) {
      res.json({ id: vendaId, total: total || 0, pagamento, delivery, plataforma, obs, itens: [] });
      return;
    }

    let processedItems = 0;
    const totalItems = itens.length;

    itens.forEach(item => {
      const itemSql = 'INSERT INTO venda_itens (venda_id, produto_id, produto_nome, qtd, preco_unitario) VALUES (?, ?, ?, ?, ?)';
      db.run(itemSql, [vendaId, item.produtoId, item.produtoNome, item.qtd, item.precoUnitario || 0], (itemErr) => {
        if (itemErr) console.error('Erro ao inserir item:', itemErr);

        const estoqueSql = 'UPDATE produtos SET qtd = qtd - ? WHERE id = ?';
        db.run(estoqueSql, [item.qtd, item.produtoId], (estoqueErr) => {
          if (estoqueErr) console.error('Erro ao atualizar estoque:', estoqueErr);

          const movSql = 'INSERT INTO movimentacoes (tipo, produto_id, produto_nome, qtd, obs) VALUES (?, ?, ?, ?, ?)';
          db.run(movSql, ['saida', item.produtoId, item.produtoNome, item.qtd, `Venda ${delivery ? `(${plataforma || ''})` : 'balcão'} - ${pagamento}`], (movErr) => {
            if (movErr) console.error('Erro ao adicionar movimentação:', movErr);

            processedItems++;
            if (processedItems === totalItems) {
              res.json({ id: vendaId, total: total || 0, pagamento, delivery, plataforma, obs, itens });
            }
          });
        });
      });
    });
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse o site em http://localhost:${PORT}`);
  console.log('\nUsuário padrão:');
  console.log('Usuário: admin');
  console.log('Senha: admin123');
  console.log('Role: Dono');
});
