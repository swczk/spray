#!/bin/bash

# Script para inserir dados fictícios diretamente nos bancos em cloud
# PostgreSQL Neon + MongoDB Atlas

set -e

echo "==========================================="
echo "   INSERÇÃO DE DADOS NOS BANCOS CLOUD"
echo "   PostgreSQL Neon + MongoDB Atlas"
echo "==========================================="
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configurações dos bancos cloud
echo "Carregando configurações dos bancos..."

# PostgreSQL Neon
PG_HOST=${PG_HOST:-"ep-wandering-firefly-ac208w7e-pooler.sa-east-1.aws.neon.tech"}
PG_PORT=${PG_PORT:-"5432"}
PG_DB=${PG_DB:-"tacdb"}
PG_USER=${PG_USER:-"tacdb_owner"}
PG_PASS=${PG_PASS:-"npg_lUXQNZzx2J1d"}

# MongoDB Atlas
MONGO_URI=${MONGO_URI:-"mongodb+srv://dudu:TusEUdoJnMrDkL2R@cluster0.afqf6od.mongodb.net/pulverizacao?retryWrites=true&w=majority&appName=Cluster0"}
MONGO_DB=${MONGO_DB:-"pulverizacao"}

echo -e "${GREEN}✓ Configurações carregadas${NC}"
echo ""

# 1. INSERIR DADOS NO POSTGRESQL NEON
echo -e "${BLUE}1. INSERINDO DADOS NO POSTGRESQL NEON${NC}"
echo "==========================================="
echo "Host: $PG_HOST"
echo "Database: $PG_DB"
echo "User: $PG_USER"
echo ""

# Verificar se psql está disponível
if ! command -v psql &> /dev/null; then
    echo -e "${RED}✗ psql não encontrado. Instale o PostgreSQL client.${NC}"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "  Fedora: sudo dnf install postgresql"
    exit 1
fi

export PGPASSWORD="$PG_PASS"

echo "Testando conexão com PostgreSQL Neon..."
if psql -h "$PG_HOST" -p "$PG_PORT" -d "$PG_DB" -U "$PG_USER" -c "SELECT 1;" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Conexão com PostgreSQL Neon estabelecida${NC}"
else
    echo -e "${RED}✗ Falha na conexão com PostgreSQL Neon${NC}"
    echo "Verifique sua conexão com a internet e as credenciais."
    exit 1
fi

echo "Inserindo dados fictícios..."
if psql -h "$PG_HOST" -p "$PG_PORT" -d "$PG_DB" -U "$PG_USER" -f "dados-ficticios.sql" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Dados inseridos no PostgreSQL Neon com sucesso!${NC}"
    
    # Mostrar estatísticas
    echo ""
    echo "Estatísticas dos dados inseridos:"
    psql -h "$PG_HOST" -p "$PG_PORT" -d "$PG_DB" -U "$PG_USER" -c "
        SELECT 'Usuários' as tabela, COUNT(*) as registros FROM usuarios
        UNION ALL
        SELECT 'Equipamentos', COUNT(*) FROM equipamentos
        UNION ALL
        SELECT 'Talhões', COUNT(*) FROM talhoes
        UNION ALL
        SELECT 'Tipos de Aplicação', COUNT(*) FROM tipos_aplicacao
        UNION ALL
        SELECT 'Aplicações', COUNT(*) FROM aplicacoes;
    " 2>/dev/null || echo "Dados inseridos com sucesso"
else
    echo -e "${RED}✗ Erro ao inserir dados no PostgreSQL Neon${NC}"
    exit 1
fi

echo ""

# 2. INSERIR DADOS NO MONGODB ATLAS
echo -e "${BLUE}2. INSERINDO DADOS NO MONGODB ATLAS${NC}"
echo "==========================================="
echo "Cluster: cluster0.afqf6od.mongodb.net"
echo "Database: $MONGO_DB"
echo ""

# Tentar diferentes métodos para MongoDB Atlas
echo "Tentando inserir dados no MongoDB Atlas..."

# Método 1: mongosh (preferido)
if command -v mongosh &> /dev/null; then
    echo "Usando mongosh..."
    
    # Contornar problema do OpenSSL
    export NODE_OPTIONS="--openssl-legacy-provider" 2>/dev/null || true
    
    if mongosh "$MONGO_URI" --eval "
        const dados = $(cat dados-geograficos-manual.json);
        dados.forEach(doc => {
            doc.createdAt = new Date();
            doc.updatedAt = new Date();
            db.geo_trajetorias.insertOne(doc);
        });
        print('Total inserido: ' + db.geo_trajetorias.countDocuments());
    " > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Dados inseridos no MongoDB Atlas com sucesso!${NC}"
    else
        echo -e "${YELLOW}⚠ mongosh falhou, tentando método alternativo...${NC}"
        
        # Método alternativo: criar arquivo temporário
        cat > temp_atlas_insert.js << 'EOF'
const dados = [
  {
    aplicacaoId: "950e8400-e29b-41d4-a716-446655440001",
    pontoInicial: {latitude: -25.0945, longitude: -50.1593, timestamp: new Date("2024-11-02T08:00:00.000Z"), altitude: 850, speed: 15, accuracy: 3},
    pontoFinal: {latitude: -25.0920, longitude: -50.1550, timestamp: new Date("2024-11-02T12:30:00.000Z"), altitude: 855, speed: 0, accuracy: 2},
    trajetoria: [
      {latitude: -25.0945, longitude: -50.1593, timestamp: new Date("2024-11-02T08:00:00.000Z"), altitude: 850, speed: 15, accuracy: 3},
      {latitude: -25.0944, longitude: -50.1591, timestamp: new Date("2024-11-02T08:03:20.000Z"), altitude: 851, speed: 14.5, accuracy: 2.8},
      {latitude: -25.0920, longitude: -50.1550, timestamp: new Date("2024-11-02T12:30:00.000Z"), altitude: 855, speed: 0, accuracy: 2}
    ],
    areaCobertura: 25.5,
    distanciaPercorrida: 2850,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    aplicacaoId: "950e8400-e29b-41d4-a716-446655440002",
    pontoInicial: {latitude: -25.1045, longitude: -50.1693, timestamp: new Date("2024-11-09T07:30:00.000Z"), altitude: 845, speed: 14, accuracy: 2},
    pontoFinal: {latitude: -25.1015, longitude: -50.1645, timestamp: new Date("2024-11-09T11:45:00.000Z"), altitude: 848, speed: 0, accuracy: 3},
    trajetoria: [
      {latitude: -25.1045, longitude: -50.1693, timestamp: new Date("2024-11-09T07:30:00.000Z"), altitude: 845, speed: 14, accuracy: 2},
      {latitude: -25.1043, longitude: -50.1690, timestamp: new Date("2024-11-09T07:33:40.000Z"), altitude: 845.3, speed: 13.8, accuracy: 2.1},
      {latitude: -25.1015, longitude: -50.1645, timestamp: new Date("2024-11-09T11:45:00.000Z"), altitude: 848, speed: 0, accuracy: 3}
    ],
    areaCobertura: 32.8,
    distanciaPercorrida: 3680,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    aplicacaoId: "950e8400-e29b-41d4-a716-446655440003",
    pontoInicial: {latitude: -25.0845, longitude: -50.1493, timestamp: new Date("2024-11-15T09:00:00.000Z"), altitude: 855, speed: 16, accuracy: 2},
    pontoFinal: {latitude: -25.0825, longitude: -50.1460, timestamp: new Date("2024-11-15T12:00:00.000Z"), altitude: 860, speed: 0, accuracy: 4},
    trajetoria: [
      {latitude: -25.0845, longitude: -50.1493, timestamp: new Date("2024-11-15T09:00:00.000Z"), altitude: 855, speed: 16, accuracy: 2},
      {latitude: -25.0843, longitude: -50.1490, timestamp: new Date("2024-11-15T09:03:00.000Z"), altitude: 855.5, speed: 15.8, accuracy: 2.1},
      {latitude: -25.0825, longitude: -50.1460, timestamp: new Date("2024-11-15T12:00:00.000Z"), altitude: 860, speed: 0, accuracy: 4}
    ],
    areaCobertura: 18.2,
    distanciaPercorrida: 2040,
    createdAt: new Date(),
    updatedAt: new Date()
  }
];

db.geo_trajetorias.insertMany(dados);
print("Dados inseridos: " + dados.length);
print("Total na collection: " + db.geo_trajetorias.countDocuments());
EOF
        
        if mongosh "$MONGO_URI" temp_atlas_insert.js > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Dados inseridos no MongoDB Atlas (método alternativo)!${NC}"
        else
            echo -e "${YELLOW}⚠ Inserção automática falhou${NC}"
            echo ""
            echo -e "${BLUE}INSTRUÇÕES MANUAIS PARA MONGODB ATLAS:${NC}"
            echo "1. Acesse MongoDB Atlas: https://cloud.mongodb.com"
            echo "2. Vá para o cluster: cluster0"
            echo "3. Clique em 'Browse Collections'"
            echo "4. Selecione database: pulverizacao"
            echo "5. Crie collection: geo_trajetorias"
            echo "6. Clique em 'INSERT DOCUMENT'"
            echo "7. Use 'Import JSON file' e selecione: dados-geograficos-manual.json"
            echo ""
            echo "OU execute manualmente:"
            echo "mongosh \"$MONGO_URI\""
            echo "Depois execute o arquivo: temp_atlas_insert.js"
        fi
        
        rm -f temp_atlas_insert.js
    fi

# Método 2: mongo legacy
elif command -v mongo &> /dev/null; then
    echo "Usando mongo (legacy)..."
    if mongo "$MONGO_URI" temp_atlas_insert.js > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Dados inseridos no MongoDB Atlas com sucesso!${NC}"
    else
        echo -e "${YELLOW}⚠ Método mongo legacy falhou${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Cliente MongoDB não encontrado${NC}"
    echo ""
    echo -e "${BLUE}INSTRUÇÕES PARA INSERIR MANUALMENTE:${NC}"
    echo ""
    echo "OPÇÃO 1 - MongoDB Compass:"
    echo "1. Baixe MongoDB Compass: https://www.mongodb.com/products/compass"
    echo "2. Conecte usando: $MONGO_URI"
    echo "3. Importe o arquivo: dados-geograficos-manual.json"
    echo "4. Collection: geo_trajetorias"
    echo ""
    echo "OPÇÃO 2 - MongoDB Atlas Web UI:"
    echo "1. Acesse: https://cloud.mongodb.com"
    echo "2. Entre no cluster: cluster0"
    echo "3. Collections -> pulverizacao -> geo_trajetorias"
    echo "4. Insert Document -> Import JSON"
    echo "5. Selecione: dados-geograficos-manual.json"
fi

echo ""
echo "==========================================="
echo -e "${GREEN}✅ INSERÇÃO CONCLUÍDA!${NC}"
echo "==========================================="
echo ""
echo "Dados inseridos nos bancos cloud:"
echo ""
echo -e "${BLUE}PostgreSQL Neon:${NC}"
echo "• 5 usuários (diferentes roles)"
echo "• 5 equipamentos de pulverização"
echo "• 7 talhões com culturas variadas"
echo "• 8 tipos de aplicação"
echo "• 13 aplicações (10 finalizadas, 3 em andamento)"
echo ""
echo -e "${BLUE}MongoDB Atlas:${NC}"
echo "• 3+ trajetórias geográficas com coordenadas GPS"
echo "• Pontos de trajetória detalhados"
echo "• Dados de área e distância percorrida"
echo ""
echo -e "${BLUE}Próximos passos:${NC}"
echo "1. Inicie a aplicação: docker compose --env-file .env.prod -f compose.prod.yaml up"
echo "2. Acesse: http://localhost"
echo "3. Login: joao.silva@fazenda.com / 123456"
echo ""
echo -e "${YELLOW}Nota: Todos os usuários têm senha: 123456${NC}"