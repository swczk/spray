#!/bin/bash

# Script de início rápido para desenvolvimento
# Combina build local e start em um comando
# Uso: ./scripts/quick-start.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "🚀 Spray Management System - Início Rápido"
echo "=========================================="
echo ""

# Verificar se Docker está rodando
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker não está rodando. Iniciando Docker..."
    echo "Por favor, inicie o Docker e execute novamente."
    exit 1
fi

echo "📦 Preparando ambiente..."

# Build local do message-consumer (necessário para o primeiro run)
if [ -d "./message-consumer" ] && [ -f "./message-consumer/pom.xml" ]; then
    echo "🔨 Fazendo build local do message-consumer..."
    cd "./message-consumer"
    if command -v mvn >/dev/null 2>&1; then
        mvn clean package -DskipTests -q
        echo "   ✅ Maven build concluído"
    else
        echo "   ⚠️  Maven não encontrado - usando build no Docker"
    fi
    cd ".."
fi

# Verificar qual compose file usar
if [ -f "compose.dev.yaml" ]; then
    COMPOSE_FILE="compose.dev.yaml"
elif [ -f "compose.yaml" ]; then
    COMPOSE_FILE="compose.yaml"
else
    echo "❌ Nenhum arquivo compose encontrado!"
    exit 1
fi

echo "📋 Usando arquivo: $COMPOSE_FILE"

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker compose -f "$COMPOSE_FILE" down --remove-orphans >/dev/null 2>&1 || true

# Iniciar serviços
echo "🚀 Iniciando serviços..."
docker compose -f "$COMPOSE_FILE" up --build -d

# Aguardar serviços ficarem prontos
echo "⏳ Aguardando serviços ficarem prontos..."
echo "   (Isso pode levar alguns minutos na primeira execução)"

# Aguardar RabbitMQ ficar pronto (fundamental para o consumer)
echo "🐰 Verificando RabbitMQ..."
for i in {1..30}; do
    if docker compose -f "$COMPOSE_FILE" exec rabbitmq rabbitmqctl status >/dev/null 2>&1; then
        echo "   ✅ RabbitMQ está pronto"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "   ⚠️  RabbitMQ demorou para ficar pronto, mas continuando..."
    fi
    sleep 2
done

# Verificar status final
echo ""
echo "📊 Status dos serviços:"
docker compose -f "$COMPOSE_FILE" ps

echo ""
echo "🎉 Sistema iniciado com sucesso!"
echo ""
echo "📱 Acesse os serviços:"
echo "   Frontend:                http://localhost:80"
echo "   Spring API:              http://localhost:8080"
echo "   Spring API Swagger:      http://localhost:8080/swagger-ui"
echo "   GraphQL API:             http://localhost:8081"
echo "   Message Consumer:        http://localhost:8082"
echo "   Consumer Swagger:        http://localhost:8082/swagger-ui"
echo "   Consumer H2 Console:     http://localhost:8082/h2-console"
echo "   RabbitMQ Management:     http://localhost:15672 (admin/admin123)"
echo ""
echo "🔧 Comandos úteis:"
echo "   Ver logs:                docker compose -f $COMPOSE_FILE logs -f"
echo "   Parar:                   docker compose -f $COMPOSE_FILE down"
echo "   Reiniciar um serviço:    docker compose -f $COMPOSE_FILE restart [service]"
echo ""
echo "💡 Para testar mensageria:"
echo "   1. Crie uma aplicação via Spring API"
echo "   2. Verifique os logs do consumer: docker compose -f $COMPOSE_FILE logs -f message-consumer"
echo "   3. Acesse o H2 Console para ver dados processados"