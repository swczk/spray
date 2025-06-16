# Docker Commands para Build e Deploy

## Script Automatizado

```bash
# Build e deploy de todos os serviços
./scripts/docker-build.sh

# Build e deploy com tag específica
./scripts/docker-build.sh v1.0.0
```

## Comandos Individuais

### Spring Boot API
```bash
# Build
docker build -t swczk/pulveriza-nenem-spring-api:latest ./backend-spring

# Push
docker push swczk/pulveriza-nenem-spring-api:latest
```

### GraphQL API  
```bash
# Build
docker build -t swczk/pulveriza-nenem-graphql-api:latest ./backend-graphql

# Push
docker push swczk/pulveriza-nenem-graphql-api:latest
```

### Frontend
```bash
# Build
docker build -t swczk/pulveriza-nenem-frontend:latest -f ./frontend/Dockerfile.prod ./frontend

# Push
docker push swczk/pulveriza-nenem-frontend:latest
```

## Comandos com Tags Versionadas

### Build com versão específica
```bash
# Spring Boot
docker build -t swczk/pulveriza-nenem-spring-api:v1.0.0 ./backend-spring
docker tag swczk/pulveriza-nenem-spring-api:v1.0.0 swczk/pulveriza-nenem-spring-api:latest

# GraphQL
docker build -t swczk/pulveriza-nenem-graphql-api:v1.0.0 ./backend-graphql
docker tag swczk/pulveriza-nenem-graphql-api:v1.0.0 swczk/pulveriza-nenem-graphql-api:latest

# Frontend
docker build -t swczk/pulveriza-nenem-frontend:v1.0.0 -f ./frontend/Dockerfile.prod ./frontend
docker tag swczk/pulveriza-nenem-frontend:v1.0.0 swczk/pulveriza-nenem-frontend:latest
```

### Push com versão específica
```bash
# Spring Boot
docker push swczk/pulveriza-nenem-spring-api:v1.0.0
docker push swczk/pulveriza-nenem-spring-api:latest

# GraphQL
docker push swczk/pulveriza-nenem-graphql-api:v1.0.0
docker push swczk/pulveriza-nenem-graphql-api:latest

# Frontend
docker push swczk/pulveriza-nenem-frontend:v1.0.0
docker push swczk/pulveriza-nenem-frontend:latest
```

## Deploy em Produção

```bash
# Usar as imagens do Docker Hub
docker-compose -f compose.prod.yaml up -d

# Verificar status
docker-compose -f compose.prod.yaml ps

# Ver logs
docker-compose -f compose.prod.yaml logs -f

# Parar serviços
docker-compose -f compose.prod.yaml down
```

## Comandos Úteis

```bash
# Login no Docker Hub
docker login

# Listar imagens locais
docker images | grep swczk/pulveriza-nenem

# Remover imagens locais
docker rmi swczk/pulveriza-nenem-spring-api:latest
docker rmi swczk/pulveriza-nenem-graphql-api:latest
docker rmi swczk/pulveriza-nenem-frontend:latest

# Limpeza geral
docker system prune -a

# Build multi-arquitetura (para ARM64/AMD64)
docker buildx build --platform linux/amd64,linux/arm64 -t swczk/pulveriza-nenem-spring-api:latest ./backend-spring --push
docker buildx build --platform linux/amd64,linux/arm64 -t swczk/pulveriza-nenem-graphql-api:latest ./backend-graphql --push
docker buildx build --platform linux/amd64,linux/arm64 -t swczk/pulveriza-nenem-frontend:latest -f ./frontend/Dockerfile.prod ./frontend --push
```

## Pré-requisitos

1. Docker instalado e rodando
2. Login no Docker Hub: `docker login`
3. Permissão de escrita no repositório swczk no Docker Hub