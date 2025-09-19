#!/bin/bash
# PostgreSQL - Script de parada
cd "$(dirname "$0")"
CONTAINER_NAME="postgres_container"
SERVICE_NAME="PostgreSQL"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🛑 Deteniendo $SERVICE_NAME...${NC}"

# Verificar si el contenedor existe y está corriendo
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo -e "${YELLOW}📦 Deteniendo contenedor...${NC}"
    
    # Intentar detener con docker compose primero
    if command -v docker-compose &> /dev/null; then
        docker-compose down
    elif docker compose version &> /dev/null; then
        docker compose down
    else
        # Fallback: detener directamente el contenedor
        docker stop $CONTAINER_NAME
    fi
    
    # Esperar un momento para que se detenga
    sleep 2
    
    # Verificar si realmente se detuvo
    if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo -e "${GREEN}✅ $SERVICE_NAME detenido correctamente${NC}"
    else
        echo -e "${RED}❌ $SERVICE_NAME aún está corriendo. Forzando detención...${NC}"
        docker stop $CONTAINER_NAME
        sleep 1
        if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
            echo -e "${GREEN}✅ $SERVICE_NAME detenido forzadamente${NC}"
        else
            echo -e "${RED}❌ Error: No se pudo detener $SERVICE_NAME${NC}"
            exit 1
        fi
    fi
elif [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo -e "${YELLOW}⚠️  El contenedor ya estaba detenido${NC}"
else
    echo -e "${YELLOW}⚠️  No se encontró el contenedor $CONTAINER_NAME${NC}"
fi

echo -e "${BLUE}📊 Estado actual:${NC}"
docker ps --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || echo "  No hay contenedores de $SERVICE_NAME corriendo"