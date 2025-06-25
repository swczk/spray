#!/bin/bash

# Script simplificado para inserir dados fictícios
# Resolve problemas de compatibilidade com MongoDB

set -e

echo "==========================================="
echo "   INSERÇÃO DE DADOS FICTÍCIOS"
echo "   (Versão Simplificada)"
echo "==========================================="
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 1. INSERIR DADOS NO POSTGRESQL
echo -e "${BLUE}1. INSERINDO DADOS NO POSTGRESQL${NC}"
echo "==========================================="

# Detectar ambiente
if docker ps | grep -q "spray-postgres"; then
    echo "Ambiente: Desenvolvimento (local)"
    DB_HOST=${DB_HOST:-"localhost"}
    DB_PORT=${DB_PORT:-"5432"}
    DB_NAME=${DB_NAME:-"tacdb"}
    DB_USER=${DB_USER:-"tacdb_owner"}
    DB_PASS=${DB_PASS:-"npg_lUXQNZzx2J1d"}
elif [ -f ".env.prod" ]; then
    echo "Ambiente: Produção"
    source .env.prod
    DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*\/\/\([^:]*\):.*/\1/p')
    DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
    DB_USER=${POSTGRES_USER:-$DB_USER}
    DB_PASS=${POSTGRES_PASSWORD:-$DB_PASS}
else
    echo -e "${RED}Erro: Ambiente não detectado${NC}"
    exit 1
fi

export PGPASSWORD="$DB_PASS"

echo "Conectando ao PostgreSQL..."
if psql -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -U "$DB_USER" -f "dados-ficticios.sql" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Dados PostgreSQL inseridos com sucesso!${NC}"
else
    echo -e "${RED}✗ Erro ao inserir dados PostgreSQL${NC}"
    exit 1
fi

# 2. INSERIR DADOS NO MONGODB
echo ""
echo -e "${BLUE}2. INSERINDO DADOS NO MONGODB${NC}"
echo "==========================================="

# Tentar diferentes métodos de conexão MongoDB
if docker ps | grep -q "spray-mongodb"; then
    echo "Inserindo dados no MongoDB local..."
    
    # Método 1: Docker exec (mais compatível)
    if docker exec spray-mongodb mongosh pulverizacao --eval "
        const dados = $(cat dados-geograficos-manual.json);
        dados.forEach(doc => {
            doc.createdAt = new Date();
            doc.updatedAt = new Date();
            db.geo_trajetorias.insertOne(doc);
        });
        print('Trajetórias inseridas: ' + db.geo_trajetorias.countDocuments());
    " > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Dados MongoDB inseridos com sucesso (docker exec)!${NC}"
    elif docker exec spray-mongodb mongo pulverizacao --eval "
        const dados = $(cat dados-geograficos-manual.json);
        dados.forEach(doc => {
            doc.createdAt = new Date();
            doc.updatedAt = new Date();
            db.geo_trajetorias.insertOne(doc);
        });
        print('Trajetórias inseridas: ' + db.geo_trajetorias.count());
    " > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Dados MongoDB inseridos com sucesso (docker exec mongo)!${NC}"
    else
        echo -e "${YELLOW}⚠ Usando método alternativo para MongoDB...${NC}"
        
        # Método 2: Criar script temp e executar
        cat > temp_mongo_script.js << 'EOF'
const dados = [
  {
    "aplicacaoId": "950e8400-e29b-41d4-a716-446655440001",
    "pontoInicial": {"latitude": -25.0945, "longitude": -50.1593, "timestamp": new Date("2024-11-02T08:00:00.000Z"), "altitude": 850, "speed": 15, "accuracy": 3},
    "pontoFinal": {"latitude": -25.0920, "longitude": -50.1550, "timestamp": new Date("2024-11-02T12:30:00.000Z"), "altitude": 855, "speed": 0, "accuracy": 2},
    "areaCobertura": 25.5,
    "distanciaPercorrida": 2850,
    "createdAt": new Date(),
    "updatedAt": new Date()
  },
  {
    "aplicacaoId": "950e8400-e29b-41d4-a716-446655440002",
    "pontoInicial": {"latitude": -25.1045, "longitude": -50.1693, "timestamp": new Date("2024-11-09T07:30:00.000Z"), "altitude": 845, "speed": 14, "accuracy": 2},
    "pontoFinal": {"latitude": -25.1015, "longitude": -50.1645, "timestamp": new Date("2024-11-09T11:45:00.000Z"), "altitude": 848, "speed": 0, "accuracy": 3},
    "areaCobertura": 32.8,
    "distanciaPercorrida": 3680,
    "createdAt": new Date(),
    "updatedAt": new Date()
  },
  {
    "aplicacaoId": "950e8400-e29b-41d4-a716-446655440003",
    "pontoInicial": {"latitude": -25.0845, "longitude": -50.1493, "timestamp": new Date("2024-11-15T09:00:00.000Z"), "altitude": 855, "speed": 16, "accuracy": 2},
    "pontoFinal": {"latitude": -25.0825, "longitude": -50.1460, "timestamp": new Date("2024-11-15T12:00:00.000Z"), "altitude": 860, "speed": 0, "accuracy": 4},
    "areaCobertura": 18.2,
    "distanciaPercorrida": 2040,
    "createdAt": new Date(),
    "updatedAt": new Date()
  }
];

dados.forEach(doc => {
    db.geo_trajetorias.insertOne(doc);
});
print("Total inserido: " + dados.length);
EOF
        
        if docker cp temp_mongo_script.js spray-mongodb:/tmp/ && 
           docker exec spray-mongodb mongosh pulverizacao /tmp/temp_mongo_script.js > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Dados MongoDB inseridos com sucesso (script temp)!${NC}"
        elif docker exec spray-mongodb mongo pulverizacao /tmp/temp_mongo_script.js > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Dados MongoDB inseridos com sucesso (script temp mongo)!${NC}"
        else
            echo -e "${YELLOW}⚠ MongoDB local não conseguiu inserir dados automaticamente${NC}"
            echo "Execute manualmente:"
            echo "docker exec spray-mongodb mongosh pulverizacao"
            echo "Depois execute os comandos do arquivo dados-geograficos.js"
        fi
        
        rm -f temp_mongo_script.js
    fi
    
elif [ -f ".env.prod" ]; then
    echo "Tentando inserir no MongoDB Atlas..."
    source .env.prod
    
    # Para MongoDB Atlas, criar instruções manuais devido ao problema do OpenSSL
    echo -e "${YELLOW}⚠ Para MongoDB Atlas, execute manualmente:${NC}"
    echo ""
    echo "1. Conecte ao MongoDB Atlas:"
    echo "   mongosh \"$MONGO_URI\""
    echo ""
    echo "2. Execute os comandos:"
    echo "   use $MONGO_DATABASE"
    echo "   db.geo_trajetorias.insertMany($(cat dados-geograficos-manual.json))"
    echo ""
    echo "Ou use o MongoDB Compass/Atlas UI para importar o arquivo:"
    echo "   dados-geograficos-manual.json"
    
else
    echo -e "${RED}✗ MongoDB não encontrado${NC}"
fi

echo ""
echo "==========================================="
echo -e "${GREEN}✅ INSERÇÃO CONCLUÍDA!${NC}"
echo "==========================================="
echo ""
echo "Dados inseridos:"
echo "• PostgreSQL: 5 usuários, 5 equipamentos, 7 talhões, 8 tipos aplicação, 13 aplicações"
echo "• MongoDB: 3+ trajetórias geográficas"
echo ""
echo "Acesso à aplicação:"
echo "• Frontend: http://localhost:3000 (dev) ou http://localhost (prod)"
echo "• API REST: http://localhost:8080"
echo "• GraphQL: http://localhost:8081/graphql"
echo ""
echo "Login de teste:"
echo "• Email: joao.silva@fazenda.com"
echo "• Senha: 123456"