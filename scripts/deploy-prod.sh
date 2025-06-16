#!/bin/bash

# Exit on any error
set -e

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    echo "Deployment failed! Cleaning up..." >&2
    docker compose -f compose.prod.yaml down --remove-orphans 2>/dev/null || true
    exit 1
}

# Trap errors
trap 'error_exit "Script failed at line $LINENO"' ERR

echo "Deploying spray management system to production..."

# Check if compose.prod.yaml exists
if [ ! -f "compose.prod.yaml" ]; then
    error_exit "compose.prod.yaml not found"
fi

# Build production images with error checking
echo "Building Spring Boot API image..."
docker build -t spray-spring-api:latest ./backend-spring || error_exit "Failed to build Spring Boot API image"

echo "Building GraphQL API image..."
docker build -t spray-graphql-api:latest ./backend-graphql || error_exit "Failed to build GraphQL API image"

echo "Building Frontend image..."
docker build -f ./frontend/Dockerfile.prod -t spray-frontend:latest ./frontend || error_exit "Failed to build Frontend image"

# Stop existing containers
echo "Stopping existing containers..."
docker compose -f compose.prod.yaml down --remove-orphans || error_exit "Failed to stop existing containers"

# Start production environment
echo "Starting production environment..."
docker compose -f compose.prod.yaml up -d || error_exit "Failed to start production environment"

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

# Check if services are running
if ! docker compose -f compose.prod.yaml ps | grep -q "Up"; then
    error_exit "Some services failed to start properly"
fi

echo "Production deployment complete!"
echo "Application available at: https://your-domain.com"
echo "Run 'docker compose -f compose.prod.yaml logs' to view logs"
