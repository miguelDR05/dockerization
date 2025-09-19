#!/bin/bash
# PostgreSQL - Monitor de logs en tiempo real
cd "$(dirname "$0")"
CONTAINER_NAME="postgres_container"
SERVICE_NAME="PostgreSQL"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Logs de $SERVICE_NAME${NC}"
echo -e "${YELLOW}💡 Presiona Ctrl+C para salir${NC}"
echo "----------------------------------------"

# Verificar si el contenedor existe
if [ ! "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo -e "${RED}❌ Contenedor $CONTAINER_NAME no encontrado${NC}"
    echo -e "${YELLOW}💡 Ejecuta ./start.sh primero${NC}"
    exit 1
fi

# Mostrar logs en tiempo real
docker logs -f $CONTAINER_NAME