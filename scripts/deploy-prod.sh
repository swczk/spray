#!/bin/bash

# Exit on any error
set -e

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    echo "Deployment failed! Cleaning up..." >&2
    docker compose -f compose.yaml down --remove-orphans 2>/dev/null || true
    exit 1
}

# Trap errors
trap 'error_exit "Script failed at line $LINENO"' ERR

echo "Deploying spray management system to production..."

# Check if compose.prod.yaml exists
COMPOSE_FILE=${COMPOSE_FILE:-"compose.yaml"}
if [ ! -f "$COMPOSE_FILE" ]; then
    error_exit "$COMPOSE_FILE not found"
fi

# Build production images with error checking
echo "Building Spring Boot API image..."
docker build -t ${SPRING_API_IMAGE:-spray-spring-api}:${IMAGE_TAG:-latest} ${SPRING_API_PATH:-./spring-api} || error_exit "Failed to build Spring Boot API image"

echo "Building GraphQL API image..."
docker build -t ${GRAPHQL_API_IMAGE:-spray-graphql-api}:${IMAGE_TAG:-latest} ${GRAPHQL_API_PATH:-./graphql-api} || error_exit "Failed to build GraphQL API image"

echo "Building Frontend image..."
docker build -f ${FRONTEND_PATH:-./frontend}/Dockerfile -t ${FRONTEND_IMAGE:-spray-frontend}:${IMAGE_TAG:-latest} ${FRONTEND_PATH:-./frontend} || error_exit "Failed to build Frontend image"

# Stop existing containers
echo "Stopping existing containers..."
docker compose -f "$COMPOSE_FILE" down --remove-orphans || error_exit "Failed to stop existing containers"

# Start production environment
echo "Starting production environment..."
docker compose -f "$COMPOSE_FILE" up -d || error_exit "Failed to start production environment"

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

# Check if services are running
if ! docker compose -f "$COMPOSE_FILE" ps | grep -q "Up"; then
    error_exit "Some services failed to start properly"
fi

echo "Production deployment complete!"
echo "Application available at: ${APPLICATION_URL:-https://your-domain.com}"
echo "Run 'docker compose -f $COMPOSE_FILE logs' to view logs"
