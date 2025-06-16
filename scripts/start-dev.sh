#!/bin/bash

# Exit on any error
set -e

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    echo "Development startup failed! Cleaning up..." >&2
    docker compose -f compose.dev.yaml down --remove-orphans 2>/dev/null || true
    exit 1
}

# Trap errors
trap 'error_exit "Script failed at line $LINENO"' ERR

echo "Starting spray management system in development mode..."

# Check if compose.dev.yaml exists
if [ ! -f "compose.dev.yaml" ]; then
    error_exit "compose.dev.yaml not found"
fi

COMPOSE_FILE="compose.dev.yaml"

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
echo "Frontend: http://localhost:3000"
echo "Spring API: http://localhost:8080"
echo "GraphQL API: http://localhost:8081"
echo "Adminer (PostgreSQL): http://localhost:8082"
echo "Mongo Express: http://localhost:8083"

# Wait for services to be healthy
echo "Waiting for services to be ready..."
for i in {1..12}; do
    sleep 5
    echo "Checking services... ($i/12)"
    if docker-compose -f "$COMPOSE_FILE" ps | grep -q "Up"; then
        echo "Services are starting up..."
    fi
done

# Check service health
echo "Final service status:"
docker-compose -f "$COMPOSE_FILE" ps

# Verify critical services are running
if ! docker-compose -f "$COMPOSE_FILE" ps | grep -q "spray-spring-api.*Up"; then
    error_exit "Spring API failed to start"
fi

if ! docker-compose -f "$COMPOSE_FILE" ps | grep -q "spray-frontend.*Up"; then
    error_exit "Frontend failed to start"
fi

echo "Development environment is ready!"
echo "If any service is not healthy, check logs with: docker compose -f $COMPOSE_FILE logs [service-name]"
