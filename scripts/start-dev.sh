#!/bin/bash

# Exit on any error
set -e

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    echo "Development startup failed! Cleaning up..." >&2
    docker compose -f "${COMPOSE_FILE:-compose.yaml}" down --remove-orphans 2>/dev/null || true
    exit 1
}

# Trap errors
trap 'error_exit "Script failed at line $LINENO"' ERR

echo "Starting spray management system in development mode..."

# Check for development compose file
if [ -f "compose.dev.yaml" ]; then
    COMPOSE_FILE="compose.dev.yaml"
elif [ -f "compose.yaml" ]; then
    COMPOSE_FILE="compose.yaml"
    echo "Using compose.yaml for development (compose.dev.yaml not found)"
else
    error_exit "No compose file found (compose.dev.yaml or compose.yaml)"
fi

# Check if .env template exists if .env doesn't exist
if [ ! -f .env ]; then
    if [ -f .env.template ]; then
        echo "Creating .env file from template..."
        cp .env.template .env || error_exit "Failed to create .env file from template"
    else
        echo "Warning: No .env file found and no .env.template available"
        echo "Using default environment variables..."
    fi
fi

# Stop any existing containers
echo "Stopping existing containers..."
docker compose -f "$COMPOSE_FILE" down --remove-orphans 2>/dev/null || true

# Start development environment
echo "Building and starting development environment with $COMPOSE_FILE..."
docker compose -f "$COMPOSE_FILE" up --build -d || error_exit "Failed to start development environment"

echo "Services starting..."
echo "Frontend: http://localhost:80"
echo "Spring API: http://localhost:8080"
echo "GraphQL API: http://localhost:8081"
echo "Message Consumer: http://localhost:8082"
echo "Message Consumer H2 Console: http://localhost:8082/h2-console"
echo "Message Consumer Swagger: http://localhost:8082/swagger-ui"
echo "RabbitMQ Management: http://localhost:15672 (admin/admin123)"

# Wait for services to be healthy
echo "Waiting for services to be ready..."
for i in {1..12}; do
    sleep 5
    echo "Checking services... ($i/12)"
    if docker compose -f "$COMPOSE_FILE" ps | grep -q "Up"; then
        echo "Services are starting up..."
    fi
done

# Check service health
echo "Final service status:"
docker compose -f "$COMPOSE_FILE" ps

# Verify critical services are running
echo "🔍 Verificando serviços críticos..."

services_to_check=("spray-spring-api" "spray-frontend" "spray-rabbitmq" "spray-message-consumer")
failed_services=()

for service in "${services_to_check[@]}"; do
    if ! docker compose -f "$COMPOSE_FILE" ps | grep -q "$service.*Up"; then
        failed_services+=("$service")
    else
        echo "   ✅ $service está rodando"
    fi
done

if [ ${#failed_services[@]} -gt 0 ]; then
    echo "   ❌ Serviços que falharam: ${failed_services[*]}"
    echo "   💡 Execute 'docker compose -f $COMPOSE_FILE logs [service-name]' para verificar os logs"
    error_exit "Alguns serviços críticos falharam ao iniciar"
fi

echo "Development environment is ready!"
echo "If any service is not healthy, check logs with: docker compose -f $COMPOSE_FILE logs [service-name]"
