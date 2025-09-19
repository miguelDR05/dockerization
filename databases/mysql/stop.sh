#!/bin/bash
# MySQL - Script de parada
cd "$(dirname "$0")"
MYSQL_CONTAINER="mysql_container"
PHPMYADMIN_CONTAINER="phpmyadmin_container"
SERVICE_NAME="MySQL + phpMyAdmin"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛑 Deteniendo $SERVICE_NAME...${NC}"

# Verificar si los contenedores existen y están corriendo
MYSQL_RUNNING=$(docker ps -q -f name=$MYSQL_CONTAINER)
PHPMYADMIN_RUNNING=$(docker ps -q -f name=$PHPMYADMIN_CONTAINER)

if [ -n "$MYSQL_RUNNING" ] || [ -n "$PHPMYADMIN_RUNNING" ]; then
    echo -e "${YELLOW}📦 Deteniendo contenedores...${NC}"
    docker-compose down
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $SERVICE_NAME detenido correctamente${NC}"
    else
        echo -e "${RED}❌ Error al detener $SERVICE_NAME${NC}"
        exit 1
    fi
elif [ "$(docker ps -aq -f name=$MYSQL_CONTAINER)" ] || [ "$(docker ps -aq -f name=$PHPMYADMIN_CONTAINER)" ]; then
    echo -e "${YELLOW}⚠️  Los contenedores ya estaban detenidos${NC}"
else
    echo -e "${YELLOW}⚠️  No se encontraron contenedores de MySQL${NC}"
fi

echo -e "${BLUE}📊 Estado actual:${NC}"
docker ps --filter name=mysql --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || echo "  No hay contenedores de MySQL corriendo"