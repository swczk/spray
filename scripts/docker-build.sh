#!/bin/bash

# Script para build e deploy das imagens para Docker Hub
# Uso: ./docker-build.sh [tag]
# Se não especificar tag, usa 'latest'

set -e

# Mudar para o diretório raiz do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

TAG=${1:-latest}
DOCKER_USERNAME="swczk"
PROJECT_NAME="pulveriza-nenem"

echo "🚀 Iniciando build e deploy para Docker Hub..."
echo "Diretório do projeto: $PROJECT_ROOT"
echo "Tag: $TAG"
echo "Username: $DOCKER_USERNAME"
echo ""

# Função para fazer login no Docker Hub
docker_login() {
    echo "🔐 Fazendo login no Docker Hub..."
    if ! docker info | grep -q "Username: $DOCKER_USERNAME"; then
        echo "Por favor, faça login no Docker Hub:"
        docker login
    else
        echo "✅ Já logado no Docker Hub"
    fi
    echo ""
}

# Função para build e push de uma imagem
build_and_push() {
    local service=$1
    local context=$2
    local dockerfile=${3:-Dockerfile}
    local image_name="$DOCKER_USERNAME/$PROJECT_NAME-$service:$TAG"
    
    echo "🔨 Building $service..."
    echo "Context: $context"
    echo "Dockerfile: $dockerfile"
    echo "Image: $image_name"
    
    # Build da imagem
    docker build -t "$image_name" -f "$context/$dockerfile" "$context"
    
    # Tag como latest se não for latest
    if [ "$TAG" != "latest" ]; then
        docker tag "$image_name" "$DOCKER_USERNAME/$PROJECT_NAME-$service:latest"
    fi
    
    # Push para Docker Hub
    echo "📤 Pushing $image_name..."
    docker push "$image_name"
    
    if [ "$TAG" != "latest" ]; then
        echo "📤 Pushing $DOCKER_USERNAME/$PROJECT_NAME-$service:latest..."
        docker push "$DOCKER_USERNAME/$PROJECT_NAME-$service:latest"
    fi
    
    echo "✅ $service concluído!"
    echo ""
}

# Verificar se Docker está rodando
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker."
    exit 1
fi

# Login no Docker Hub
docker_login

# Build e push do Spring Boot API
echo "🏗️  SPRING BOOT API"
echo "================================"
build_and_push "spring-api" "./backend-spring" "Dockerfile"

# Build e push do GraphQL API
echo "🏗️  GRAPHQL API"
echo "================================"
build_and_push "graphql-api" "./backend-graphql" "Dockerfile"

# Build e push do Frontend
echo "🏗️  FRONTEND"
echo "================================"
build_and_push "frontend" "./frontend" "Dockerfile.prod"

echo "🎉 Build e deploy concluídos com sucesso!"
echo ""
echo "📋 Imagens criadas:"
echo "  - $DOCKER_USERNAME/$PROJECT_NAME-spring-api:$TAG"
echo "  - $DOCKER_USERNAME/$PROJECT_NAME-graphql-api:$TAG"
echo "  - $DOCKER_USERNAME/$PROJECT_NAME-frontend:$TAG"
echo ""
echo "🚀 Para usar em produção:"
echo "  docker compose -f compose.prod.yaml up -d"
echo ""
echo "🔍 Para verificar as imagens:"
echo "  docker images | grep $DOCKER_USERNAME/$PROJECT_NAME"