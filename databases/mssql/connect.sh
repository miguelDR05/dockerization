#!/bin/bash
# SQL Server - Conectar directamente al CLI de SQL Server
cd "$(dirname "$0")"
CONTAINER_NAME="sqlserver_container"
SERVICE_NAME="SQL Server"

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
    echo -e "${YELLOW}💡 Inicia el servicio con ./start-mssql.sh${NC}"
    exit 1
fi

# Obtener contraseña del archivo .env
if [ -f ".env" ]; then
    SA_PASSWORD=$(grep "SA_PASSWORD" .env | cut -d '=' -f2)
    if [ -z "$SA_PASSWORD" ]; then
        echo -e "${RED}❌ No se pudo encontrar SA_PASSWORD en .env${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Archivo .env no encontrado${NC}"
    exit 1
fi

echo -e "${YELLOW}💡 Conectando como 'sa' usuario...${NC}"
echo -e "${YELLOW}💡 Para salir escribe: exit${NC}"
echo "----------------------------------------"

# Conectar usando sqlcmd dentro del contenedor
docker exec -it $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD"