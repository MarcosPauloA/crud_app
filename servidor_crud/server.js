const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// Conectar ao banco de dados SQLite
const db = new sqlite3.Database(':memory:');

// Criar tabelas de exemplo e inserir dados
db.serialize(() => {
  db.run("CREATE TABLE clientes (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, sobrenome TEXT, email TEXT, idade INTEGER, foto TEXT)");
  db.run("CREATE TABLE produtos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, descricao TEXT, preco REAL, dataAtualizado TEXT)");

  // Inserir dados na tabela clientes
  db.run("INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES ('João', 'Silva', 'joao.silva@example.com', 30, 'https://i.pravatar.cc/300?img=1')");
  db.run("INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES ('Maria', 'Oliveira', 'maria.oliveira@example.com', 25, 'https://i.pravatar.cc/300?img=2')");
  db.run("INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES ('Pedro', 'Santos', 'pedro.santos@example.com', 28, 'https://i.pravatar.cc/300?img=3')");
  db.run("INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES ('Ana', 'Costa', 'ana.costa@example.com', 35, 'https://i.pravatar.cc/300?img=4')");
  db.run("INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES ('Lucas', 'Souza', 'lucas.souza@example.com', 22, 'https://i.pravatar.cc/300?img=5')");

  // Inserir dados na tabela produtos
  db.run("INSERT INTO produtos (nome, descricao, preco, dataAtualizado) VALUES ('Notebook', 'Notebook ultrafino com 16GB RAM', 4500.50, '2023-11-01T10:00:00Z')");
  db.run("INSERT INTO produtos (nome, descricao, preco, dataAtualizado) VALUES ('Smartphone', 'Smartphone com tela de 6.5 polegadas', 2999.99, '2023-10-15T15:30:00Z')");
  db.run("INSERT INTO produtos (nome, descricao, preco, dataAtualizado) VALUES ('Fone de Ouvido', 'Fone de ouvido com cancelamento de ruído', 799.99, '2023-09-20T12:45:00Z')");
  db.run("INSERT INTO produtos (nome, descricao, preco, dataAtualizado) VALUES ('Monitor', 'Monitor 27 polegadas 4K', 2000.00, '2023-11-10T09:00:00Z')");
  db.run("INSERT INTO produtos (nome, descricao, preco, dataAtualizado) VALUES ('Teclado Mecânico', 'Teclado mecânico RGB', 350.75, '2023-11-18T18:30:00Z')");
});

// Rotas para Clientes
app.get('/clientes', (req, res) => {
  db.all("SELECT * FROM clientes", [], (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send(rows);
  });
});

app.post('/clientes', (req, res) => {
  const { nome, sobrenome, email, idade, foto } = req.body;
  db.run("INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES (?, ?, ?, ?, ?)", [nome, sobrenome, email, idade, foto], function(err) {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send({ id: this.lastID, ...req.body });
  });
});

app.put('/clientes/:id', (req, res) => {
  const { nome, sobrenome, email, idade, foto } = req.body;
  db.run("UPDATE clientes SET nome = ?, sobrenome = ?, email = ?, idade = ?, foto = ? WHERE id = ?", [nome, sobrenome, email, idade, foto, req.params.id], function(err) {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send({ id: req.params.id, ...req.body });
  });
});

app.delete('/clientes/:id', (req, res) => {
  db.run("DELETE FROM clientes WHERE id = ?", req.params.id, function(err) {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send({ message: 'Cliente removido' });
  });
});

// Rotas para Produtos
app.get('/produtos', (req, res) => {
  db.all("SELECT * FROM produtos", [], (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send(rows);
  });
});

app.post('/produtos', (req, res) => {
  const { nome, descricao, preco, dataAtualizado } = req.body;
  db.run("INSERT INTO produtos (nome, descricao, preco, dataAtualizado) VALUES (?, ?, ?, ?)", [nome, descricao, preco, dataAtualizado], function(err) {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send({ id: this.lastID, ...req.body });
  });
});

app.put('/produtos/:id', (req, res) => {
  const { nome, descricao, preco, dataAtualizado } = req.body;
  db.run("UPDATE produtos SET nome = ?, descricao = ?, preco = ?, dataAtualizado = ? WHERE id = ?", [nome, descricao, preco, dataAtualizado, req.params.id], function(err) {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send({ id: req.params.id, ...req.body });
  });
});

app.delete('/produtos/:id', (req, res) => {
  db.run("DELETE FROM produtos WHERE id = ?", req.params.id, function(err) {
    if (err) {
      res.status(500).send(err.message);
      return;
    }
    res.send({ message: 'Produto removido' });
  });
});

app.listen(3000, () => {
  console.log('Servidor rodando na porta 3000');
});
