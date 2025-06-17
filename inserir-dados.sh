#!/bin/bash

# Script para inserir dados fictícios na aplicação Pulveriza Neném
# Execute este script com a aplicação rodando

set -e

echo "==========================================="
echo "   INSERÇÃO DE DADOS FICTÍCIOS"
echo "   Sistema de Pulverização Agrícola"
echo "==========================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para verificar se um serviço está rodando
check_service() {
    local service_name=$1
    local port=$2
    local host=${3:-localhost}
    
    echo -e "${BLUE}Verificando ${service_name}...${NC}"
    
    if nc -z $host $port 2>/dev/null; then
        echo -e "${GREEN}✓ ${service_name} está rodando na porta ${port}${NC}"
        return 0
    else
        echo -e "${RED}✗ ${service_name} não está respondendo na porta ${port}${NC}"
        return 1
    fi
}

# Verificar dependências
echo "Verificando dependências..."

# Verificar se psql está disponível
if ! command -v psql &> /dev/null; then
    echo -e "${RED}✗ psql não encontrado. Instale o PostgreSQL client.${NC}"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "  CentOS/RHEL: sudo yum install postgresql"
    exit 1
fi

# Verificar se mongosh está disponível
if ! command -v mongosh &> /dev/null; then
    echo -e "${YELLOW}⚠ mongosh não encontrado. Tentando usar mongo...${NC}"
    if ! command -v mongo &> /dev/null; then
        echo -e "${RED}✗ Cliente MongoDB não encontrado. Instale mongosh ou mongo.${NC}"
        echo "  Instalar mongosh: https://www.mongodb.com/docs/mongodb-shell/install/"
        exit 1
    else
        MONGO_CMD="mongo"
    fi
else
    MONGO_CMD="mongosh"
fi

echo -e "${GREEN}✓ Dependências verificadas${NC}"
echo ""

# Verificar serviços
echo "Verificando serviços..."

services_ok=true

if ! check_service "PostgreSQL" 5432; then
    services_ok=false
fi

if ! check_service "Spring Boot API" 8080; then
    services_ok=false
fi

if ! check_service "GraphQL API" 8081; then
    services_ok=false
fi

if ! check_service "MongoDB" 27017; then
    services_ok=false
fi

if [ "$services_ok" = false ]; then
    echo ""
    echo -e "${RED}❌ Alguns serviços não estão rodando!${NC}"
    echo -e "${YELLOW}Execute primeiro:${NC}"
    echo "  docker compose --env-file .env.dev -f compose.dev.yaml up -d"
    echo "  ou"
    echo "  docker compose --env-file .env.prod -f compose.prod.yaml up -d"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Todos os serviços estão rodando${NC}"
echo ""

# Configuração do banco de dados
echo "Configurando conexões com bancos de dados..."

# Verificar se é ambiente de desenvolvimento ou produção
if [ -f ".env.dev" ] && docker ps | grep -q "spray-postgres"; then
    echo -e "${BLUE}Detectado ambiente de DESENVOLVIMENTO${NC}"
    DB_HOST="localhost"
    DB_PORT="5432"
    DB_NAME="tacdb"
    DB_USER="tacdb_owner"
    DB_PASS="npg_lUXQNZzx2J1d"
    MONGO_URI="mongodb://admin:password@localhost:27017"
    MONGO_DB="pulverizacao"
    ENV_TYPE="dev"
elif [ -f ".env.prod" ]; then
    echo -e "${BLUE}Detectado ambiente de PRODUÇÃO${NC}"
    # Ler configurações do .env.prod
    source .env.prod
    if [[ $DATABASE_URL == jdbc:postgresql://* ]]; then
        # Extrair informações da URL JDBC
        DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*\/\/\([^:]*\):.*/\1/p')
        DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
        DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
    fi
    DB_USER=$POSTGRES_USER
    DB_PASS=$POSTGRES_PASSWORD
    MONGO_URI=$MONGO_URI
    MONGO_DB=$MONGO_DATABASE
    ENV_TYPE="prod"
else
    echo -e "${RED}❌ Não foi possível detectar o ambiente. Certifique-se de ter .env.dev ou .env.prod${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Ambiente ${ENV_TYPE} configurado${NC}"
echo ""

# Inserir dados no PostgreSQL
echo "==========================================="
echo -e "${BLUE}INSERINDO DADOS NO POSTGRESQL${NC}"
echo "==========================================="

echo "Conectando ao PostgreSQL..."
echo "Host: $DB_HOST"
echo "Porta: $DB_PORT"
echo "Banco: $DB_NAME"
echo "Usuário: $DB_USER"
echo ""

# Definir PGPASSWORD para evitar prompt de senha
export PGPASSWORD="$DB_PASS"

# Verificar conexão com PostgreSQL
if psql -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -U "$DB_USER" -c "SELECT 1;" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Conexão com PostgreSQL estabelecida${NC}"
else
    echo -e "${RED}✗ Falha na conexão com PostgreSQL${NC}"
    echo "Verifique as credenciais e se o banco está acessível."
    exit 1
fi

# Executar script SQL
echo "Executando script de dados fictícios..."
if psql -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -U "$DB_USER" -f "dados-ficticios.sql" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Dados fictícios inseridos no PostgreSQL com sucesso!${NC}"
    
    # Mostrar estatísticas
    echo ""
    echo "Estatísticas dos dados inseridos:"
    psql -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -U "$DB_USER" -c "
        SELECT 'Usuários' as tabela, COUNT(*) as registros FROM usuarios
        UNION ALL
        SELECT 'Equipamentos', COUNT(*) FROM equipamentos
        UNION ALL
        SELECT 'Talhões', COUNT(*) FROM talhoes
        UNION ALL
        SELECT 'Tipos de Aplicação', COUNT(*) FROM tipos_aplicacao
        UNION ALL
        SELECT 'Aplicações', COUNT(*) FROM aplicacoes;
    "
else
    echo -e "${RED}✗ Erro ao inserir dados no PostgreSQL${NC}"
    echo "Verifique o arquivo dados-ficticios.sql"
    exit 1
fi

echo ""

# Inserir dados no MongoDB
echo "==========================================="
echo -e "${BLUE}INSERINDO DADOS NO MONGODB${NC}"
echo "==========================================="

echo "Conectando ao MongoDB..."
echo "URI: $MONGO_URI"
echo "Database: $MONGO_DB"
echo ""

# Verificar conexão com MongoDB
if [ "$ENV_TYPE" = "dev" ]; then
    # Ambiente local
    if $MONGO_CMD --eval "db.adminCommand('ping')" "mongodb://admin:password@localhost:27017/admin" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Conexão com MongoDB estabelecida${NC}"
    else
        echo -e "${RED}✗ Falha na conexão com MongoDB${NC}"
        exit 1
    fi
    
    # Executar script no MongoDB local
    echo "Executando script de dados geográficos..."
    $MONGO_CMD "mongodb://admin:password@localhost:27017/$MONGO_DB" "dados-geograficos.js"
else
    # Ambiente de produção com MongoDB Atlas
    if $MONGO_CMD "$MONGO_URI/$MONGO_DB" --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Conexão com MongoDB Atlas estabelecida${NC}"
    else
        echo -e "${RED}✗ Falha na conexão com MongoDB Atlas${NC}"
        echo "Verifique as credenciais do MongoDB Atlas no .env.prod"
        exit 1
    fi
    
    # Executar script no MongoDB Atlas
    echo "Executando script de dados geográficos..."
    $MONGO_CMD "$MONGO_URI/$MONGO_DB" "dados-geograficos.js"
fi

echo -e "${GREEN}✓ Dados geográficos inseridos no MongoDB com sucesso!${NC}"

# Mostrar estatísticas do MongoDB
echo ""
echo "Estatísticas do MongoDB:"
if [ "$ENV_TYPE" = "dev" ]; then
    $MONGO_CMD "mongodb://admin:password@localhost:27017/$MONGO_DB" --eval "
        print('Trajetórias inseridas: ' + db.geo_trajetorias.countDocuments());
        print('Exemplo de trajetória:');
        printjson(db.geo_trajetorias.findOne({}, {aplicacaoId: 1, areaCobertura: 1, distanciaPercorrida: 1}));
    " --quiet
else
    $MONGO_CMD "$MONGO_URI/$MONGO_DB" --eval "
        print('Trajetórias inseridas: ' + db.geo_trajetorias.countDocuments());
        print('Exemplo de trajetória:');
        printjson(db.geo_trajetorias.findOne({}, {aplicacaoId: 1, areaCobertura: 1, distanciaPercorrida: 1}));
    " --quiet
fi

echo ""
echo "==========================================="
echo -e "${GREEN}✅ INSERÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo "==========================================="
echo ""
echo "Dados inseridos:"
echo "• 5 usuários (admin, técnicos, operadores)"
echo "• 5 equipamentos de diferentes fabricantes"
echo "• 7 talhões com culturas variadas"
echo "• 8 tipos de aplicação"
echo "• 13 aplicações (10 finalizadas, 3 em andamento)"
echo "• 10 trajetórias geográficas detalhadas"
echo ""
echo "Acesse a aplicação em:"
echo "• Frontend: http://localhost:3000 (dev) ou http://localhost (prod)"
echo "• API REST: http://localhost:8080"
echo "• GraphQL: http://localhost:8081/graphql"
echo ""
echo "Credenciais de teste:"
echo "• Email: joao.silva@fazenda.com"
echo "• Senha: 123456"
echo ""
echo -e "${YELLOW}Nota: Todos os usuários têm a mesma senha: 123456${NC}"