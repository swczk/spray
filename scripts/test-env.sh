#!/bin/bash

# Script para testar se as variáveis de ambiente estão configuradas corretamente
# Uso: ./scripts/test-env.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "🔍 Testando configuração das variáveis de ambiente..."
echo ""

# Verificar se .env.prod existe
if [ ! -f ".env.prod" ]; then
    echo "❌ Arquivo .env.prod não encontrado!"
    echo "Execute: ./scripts/setup-prod.sh"
    exit 1
fi

# Função para ler valor do .env
get_env_value() {
    grep "^$1=" .env.prod | cut -d'=' -f2- | head -n1
}

echo "📋 Verificando variáveis no .env.prod:"
echo ""

# Verificar Spring Boot Database
echo "🗄️  Spring Boot Database:"
DATABASE_URL=$(get_env_value "DATABASE_URL")
if [ -n "$DATABASE_URL" ]; then
    echo "   ✅ DATABASE_URL: ${DATABASE_URL:0:50}..."
else
    echo "   ❌ DATABASE_URL não definida"
fi

# Verificar MongoDB
echo ""
echo "🍃 MongoDB (GraphQL - Container Local):"
MONGO_PASSWORD=$(get_env_value "MONGO_PASSWORD")
if [ -n "$MONGO_PASSWORD" ]; then
    echo "   ✅ MONGO_PASSWORD: ${MONGO_PASSWORD:0:10}..."
    echo "   ✅ MONGO_URI: mongodb://admin:***@mongodb:27017 (auto-configurado)"
else
    echo "   ❌ MONGO_PASSWORD não definida"
fi

DATABASE_NAME=$(get_env_value "DATABASE_NAME")
if [ -n "$DATABASE_NAME" ]; then
    echo "   ✅ DATABASE_NAME: $DATABASE_NAME"
else
    echo "   ❌ DATABASE_NAME não definida"
fi

# Verificar AWS Cognito
echo ""
echo "🔐 AWS Cognito:"
AWS_COGNITO_REGION=$(get_env_value "AWS_COGNITO_REGION")
if [ -n "$AWS_COGNITO_REGION" ]; then
    echo "   ✅ AWS_COGNITO_REGION: $AWS_COGNITO_REGION"
else
    echo "   ❌ AWS_COGNITO_REGION não definida"
fi

AWS_COGNITO_USER_POOL_ID=$(get_env_value "AWS_COGNITO_USER_POOL_ID")
if [ -n "$AWS_COGNITO_USER_POOL_ID" ]; then
    echo "   ✅ AWS_COGNITO_USER_POOL_ID: $AWS_COGNITO_USER_POOL_ID"
else
    echo "   ❌ AWS_COGNITO_USER_POOL_ID não definida"
fi

AWS_COGNITO_CLIENT_ID=$(get_env_value "AWS_COGNITO_CLIENT_ID")
if [ -n "$AWS_COGNITO_CLIENT_ID" ]; then
    echo "   ✅ AWS_COGNITO_CLIENT_ID: $AWS_COGNITO_CLIENT_ID"
else
    echo "   ❌ AWS_COGNITO_CLIENT_ID não definida"
fi

AWS_COGNITO_CLIENT_SECRET=$(get_env_value "AWS_COGNITO_CLIENT_SECRET")
if [ -n "$AWS_COGNITO_CLIENT_SECRET" ]; then
    echo "   ✅ AWS_COGNITO_CLIENT_SECRET: ${AWS_COGNITO_CLIENT_SECRET:0:20}..."
else
    echo "   ❌ AWS_COGNITO_CLIENT_SECRET não definida"
fi

echo ""
echo "🚀 Para deploy em produção:"
echo "docker compose -f compose.prod.yaml --env-file .env.prod up -d"
