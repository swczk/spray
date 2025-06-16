#!/bin/bash

# Script para configurar o ambiente de produção
# Uso: ./scripts/setup-prod.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "🚀 Configurando ambiente de produção..."
echo ""

# Verificar se .env.prod já existe
if [ -f ".env.prod" ]; then
    echo "⚠️  Arquivo .env.prod já existe!"
    read -p "Deseja sobrescrever? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operação cancelada."
        exit 1
    fi
fi

# Copiar arquivo de exemplo
echo "📋 Copiando .env.prod.example para .env.prod..."
cp .env.prod.example .env.prod

echo "✅ Arquivo .env.prod criado!"
echo ""
echo "🔧 Próximos passos:"
echo "1. Edite o arquivo .env.prod com suas configurações:"
echo "   nano .env.prod"
echo ""
echo "2. Configure as seguintes variáveis obrigatórias:"
echo "   - DATABASE_URL (PostgreSQL para Spring Boot)"
echo "   - MONGO_PASSWORD (Senha do MongoDB container)"
echo "   - DATABASE_NAME (Nome do banco MongoDB)"
echo "   - Configurações AWS Cognito (se usando)"
echo ""
echo "3. Execute o deploy:"
echo "   docker compose -f compose.prod.yaml --env-file .env.prod up -d"
echo ""
echo "📖 Veja docker-commands.md para mais detalhes."