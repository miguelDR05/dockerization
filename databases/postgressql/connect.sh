#!/bin/bash
# PostgreSQL - Conectar directamente al CLI de PostgreSQL
cd "$(dirname "$0")"
CONTAINER_NAME="postgres_container"
SERVICE_NAME="PostgreSQL"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔌 Conectando a $SERVICE_NAME CLI${NC}"

# Verificar si el contenedor está corriendo
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo -e "${RED}❌ Contenedor $CONTAINER_NAME no está corriendo${NC}"
    echo -e "${YELLOW}💡 Inicia el servicio con ./start.sh${NC}"
    exit 1
fi

echo -e "${YELLOW}💡 Conectando a la base de datos 'demo_db' como usuario 'admin'...${NC}"
echo -e "${YELLOW}💡 Para salir escribe: \\q${NC}"
echo -e "${YELLOW}💡 Para ver tablas: \\dt${NC}"
echo -e "${YELLOW}💡 Para describir tabla: \\d nombre_tabla${NC}"
echo "----------------------------------------"

# Conectar usando psql dentro del contenedor
docker exec -it $CONTAINER_NAME psql -U admin -d demo_db