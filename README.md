# Sistema de Pulverização - Spray Management System

Sistema completo para gerenciamento de aplicações de pulverização agrícola, desenvolvido com arquitetura de microserviços.

## 🏗️ Arquitetura

O projeto é composto por três principais componentes:

- **Frontend**: Vue.js 3 + Vite + Tailwind CSS
- **Backend Spring**: API REST com Spring Boot + PostgreSQL
- **Backend GraphQL**: API GraphQL com Go + MongoDB

### Tecnologias Utilizadas

#### Frontend
- Vue.js 3 com Composition API
- Vite para build e desenvolvimento
- Tailwind CSS para estilização
- Pinia para gerenciamento de estado
- Axios para requisições HTTP
- Vue Router para roteamento

#### Backend Spring Boot
- Java 17 + Spring Boot 3
- Spring Security com JWT
- Spring Data JPA
- PostgreSQL como banco de dados
- AWS Cognito para autenticação
- Swagger/OpenAPI para documentação

#### Backend GraphQL
- Go 1.21+
- GraphQL com gqlgen
- MongoDB para persistência
- Docker para containerização

## 📁 Estrutura do Projeto

```
pulveriza-nenem/
├── frontend/                 # Aplicação Vue.js
│   ├── src/
│   │   ├── components/      # Componentes reutilizáveis
│   │   ├── views/          # Páginas da aplicação
│   │   ├── services/       # Serviços para API
│   │   ├── stores/         # Gerenciamento de estado (Pinia)
│   │   └── router/         # Configuração de rotas
│   ├── Dockerfile.dev      # Docker para desenvolvimento
│   ├── Dockerfile.prod     # Docker para produção
│   └── package.json
├── backend-spring/          # API REST Spring Boot
│   ├── src/main/java/br/edu/utfpr/api1/
│   │   ├── controller/     # Controllers REST
│   │   ├── model/          # Entidades JPA
│   │   ├── repository/     # Repositórios Spring Data
│   │   ├── service/        # Lógica de negócio
│   │   ├── dto/            # Data Transfer Objects
│   │   └── security/       # Configuração de segurança
│   └── Dockerfile
├── backend-graphql/         # API GraphQL em Go
│   ├── graphql/            # Schema e resolvers
│   ├── models/             # Modelos de dados
│   ├── database/           # Conexão com MongoDB
│   └── Dockerfile
├── scripts/                 # Scripts de deployment
│   ├── start-dev.sh        # Iniciar desenvolvimento
│   └── deploy-prod.sh      # Deploy produção
├── compose.dev.yaml        # Docker Compose desenvolvimento
└── compose.prod.yaml       # Docker Compose produção
```

## 🚀 Como Executar

### Pré-requisitos

- Docker e Docker Compose
- Git
- Bash (para execução dos scripts)

### 🛠️ Desenvolvimento

1. **Clone o repositório**
```bash
git clone <repository-url>
cd pulveriza-nenem
```

2. **Configure as variáveis de ambiente**
```bash
# Copie o arquivo de exemplo (se existir)
cp .env.example .env

# Ou crie o arquivo .env com suas configurações
cat > .env << EOF
# Database
POSTGRES_DB=tacdb
POSTGRES_USER=tacdb_owner
POSTGRES_PASSWORD=npg_lUXQNZzx2J1d

# MongoDB
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=password
MONGO_DATABASE=pulverizacao

# AWS Cognito
AWS_COGNITO_REGION=sa-east-1
AWS_COGNITO_URL=https://cognito-idp.sa-east-1.amazonaws.com
AWS_COGNITO_USER_POOL_ID=your_pool_id
AWS_COGNITO_CLIENT_ID=your_client_id
AWS_COGNITO_CLIENT_SECRET=your_client_secret
EOF
```

3. **Execute o ambiente de desenvolvimento**
```bash
# Usar script automatizado (recomendado)
./scripts/start-dev.sh

# Ou manualmente
docker compose -f compose.dev.yaml up --build
```

4. **Acesse as aplicações**
- Frontend: http://localhost:3000
- Spring API: http://localhost:8080
- GraphQL API: http://localhost:8081
- Swagger UI: http://localhost:8080/swagger-ui
- Adminer (PostgreSQL): http://localhost:8082
- Mongo Express: http://localhost:8083

### 🌐 Produção

1. **Configure as variáveis de produção**
```bash
# Edite o arquivo .env.production com suas configurações seguras
nano .env.production
```

2. **Execute o deploy**
```bash
./scripts/deploy-prod.sh
```

## 📋 Funcionalidades

### Módulos Principais

1. **Autenticação e Autorização**
   - Login/logout com AWS Cognito
   - Refresh token automático
   - Controle de acesso baseado em roles

2. **Gestão de Usuários**
   - CRUD de usuários
   - Controle de status (ativo/inativo)
   - Perfis de acesso

3. **Gestão de Equipamentos**
   - Cadastro de equipamentos de pulverização
   - Controle de manutenção
   - Histórico de uso

4. **Gestão de Talhões**
   - Cadastro de áreas de cultivo
   - Coordenadas geográficas
   - Informações de cultura

5. **Tipos de Aplicação**
   - Definição de produtos e dosagens
   - Categorização por tipo de tratamento

6. **Aplicações de Pulverização**
   - Registro de aplicações
   - Controle de status (em andamento/finalizada)
   - Histórico completo
   - Relatórios por período

## 🔧 Desenvolvimento

### Comandos Úteis

```bash
# Verificar logs de um serviço específico
docker compose -f compose.dev.yaml logs -f [service-name]

# Reiniciar um serviço
docker compose -f compose.dev.yaml restart [service-name]

# Parar todos os serviços
docker compose -f compose.dev.yaml down

# Rebuild de um serviço específico
docker compose -f compose.dev.yaml build [service-name]

# Entrar no container de um serviço
docker compose -f compose.dev.yaml exec [service-name] bash

# Ver status dos serviços
docker compose -f compose.dev.yaml ps

# Ver logs em tempo real
docker compose -f compose.dev.yaml logs -f
```

### Endpoints Principais

#### API Spring Boot (REST)
- `POST /auth/login` - Autenticação
- `POST /auth/refresh` - Renovar token
- `GET /api/aplicacoes` - Listar aplicações
- `POST /api/aplicacoes` - Criar aplicação
- `GET /api/usuarios` - Listar usuários
- `GET /api/equipamentos` - Listar equipamentos
- `GET /api/talhoes` - Listar talhões

#### API GraphQL
- `POST /graphql` - Endpoint GraphQL único

### Estrutura de Dados

#### Aplicação
```json
{
  "id": "uuid",
  "talhao": { "id": "uuid", "nome": "string" },
  "equipamento": { "id": "uuid", "nome": "string" },
  "tipoAplicacao": { "id": "uuid", "nome": "string" },
  "dataInicio": "datetime",
  "dataFim": "datetime",
  "finalizada": "boolean",
  "observacoes": "string"
}
```

## 🐛 Troubleshooting

### Problemas Comuns

1. **Erro de conexão entre containers**
   - Verifique se os serviços estão na mesma rede Docker
   - Confirme se os nomes dos serviços no compose estão corretos

2. **Frontend não consegue acessar APIs**
   - Verifique as variáveis de ambiente VITE_API_URL
   - Confirme se os arquivos .env estão corretos

3. **Erro de autenticação**
   - Verifique as configurações do AWS Cognito
   - Confirme se as credenciais estão corretas

4. **Banco de dados não conecta**
   - Verifique se as credenciais do banco estão corretas
   - Aguarde o healthcheck dos containers de banco

### Logs Úteis

```bash
# Ver logs de todos os serviços
docker compose -f compose.dev.yaml logs

# Ver logs específicos
docker compose -f compose.dev.yaml logs spring-api
docker compose -f compose.dev.yaml logs frontend
docker compose -f compose.dev.yaml logs postgres
docker compose -f compose.dev.yaml logs mongodb

# Ver logs em tempo real
docker compose -f compose.dev.yaml logs -f spring-api

# Verificar health check dos serviços
docker compose -f compose.dev.yaml ps --format table
```

## 🔒 Segurança

- Autenticação via AWS Cognito
- JWT tokens com refresh automático
- CORS configurado adequadamente
- Validação de entrada em todos os endpoints
- Senhas e chaves em variáveis de ambiente

## 📝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Equipe

Projeto desenvolvido como parte da disciplina de Tópicos Avançados em Computação - UTFPR.

## 📞 Suporte

Para suporte e dúvidas:
- Abra uma issue no GitHub
- Contate a equipe de desenvolvimento

---

**Nota**: Este sistema foi desenvolvido para fins acadêmicos e pode necessitar de ajustes para uso em produção.