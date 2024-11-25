# Flutter CRUD Application

Este projeto é um aplicativo CRUD usando Flutter para a interface do usuário e um servidor Node.js para a API.

## Pré-requisitos

- **Node.js**: Certifique-se de ter o Node.js instalado. Você pode baixá-lo em [nodejs.org](https://nodejs.org/).
- **Flutter**: Certifique-se de ter o Flutter instalado. Siga as instruções em [flutter.dev](https://flutter.dev/docs/get-started/install).

## Configuração do Servidor

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/MarcosPauloA/crud_app
   cd crud_app

2. **Instale as dependências do servidor:**
   ```bash
   cd servidor_crud
   npm install

3. **Inicie o servidor:**
   ```bash
   node server.js
O servidor estará rodando em http://localhost:3000

## Configuração da aplicação Flutter
1. **Navegue até o diretório do app**
   ```bash
   cd ../../crud_app
2. **Instale as dependências do Flutter:**
   ```bash
   flutter pub get
3. **Modifique a variável app com seu IP Local:**
   ```bash
   final String _baseUrl = 'http://[SEU IP LOCAL]:3000/clientes';
Localizado em client_provider e product_provider na pasta lib/providers

4. **Inicie o aplicativo Flutter:**
   ```bash
   flutter run
Certifique-se de ter um emulador rodando ou um dispositivo conectado.

## Estrutura do Projeto
- crud_app: Contém o código da aplicação Flutter e dentro também a pasta servidor_crud.

- servidor_crud: Contém o código do servidor Node.js.

## Endpoints da API
- GET /clientes: Retorna a lista de clientes.

- POST /clientes: Adiciona um novo cliente.

- PUT /clientes/:id: Atualiza um cliente existente.

- DELETE /clientes/:id: Remove um cliente.

- GET /produtos: Retorna a lista de produtos.

- POST /produtos: Adiciona um novo produto.

- PUT /produtos/:id: Atualiza um produto existente.

- DELETE /produtos/:id: Remove um produto.
