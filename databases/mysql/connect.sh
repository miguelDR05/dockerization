#!/bin/bash
# MySQL - Conectar directamente al CLI de MySQL
cd "$(dirname "$0")"
MYSQL_CONTAINER="mysql_container"
SERVICE_NAME="MySQL"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔌 Conectando a $SERVICE_NAME CLI${NC}"

# Verificar si el contenedor está corriendo
if [ ! "$(docker ps -q -f name=$MYSQL_CONTAINER)" ]; then
    echo -e "${RED}❌ Contenedor $MYSQL_CONTAINER no está corriendo${NC}"
    echo -e "${YELLOW}💡 Inicia el servicio con ./start.sh${NC}"
    exit 1
fi

# Obtener credenciales del archivo .env
if [ -f ".env" ]; then
    MYSQL_USER=$(grep "MYSQL_USER" .env | cut -d '=' -f2)
    MYSQL_PASSWORD=$(grep "MYSQL_PASSWORD" .env | cut -d '=' -f2)
    MYSQL_DATABASE=$(grep "MYSQL_DATABASE" .env | cut -d '=' -f2)
    
    if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ]; then
        echo -e "${RED}❌ No se pudieron encontrar las credenciales en .env${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Archivo .env no encontrado${NC}"
    exit 1
fi

echo -e "${YELLOW}💡 Conectando como '$MYSQL_USER' a la base de datos '$MYSQL_DATABASE'...${NC}"
echo -e "${YELLOW}💡 Para salir escribe: exit${NC}"
echo -e "${YELLOW}💡 Para ver tablas: SHOW TABLES;${NC}"
echo -e "${YELLOW}💡 Para describir tabla: DESCRIBE nombre_tabla;${NC}"
echo "----------------------------------------"

# Conectar usando mysql dentro del contenedor
docker exec -it $MYSQL_CONTAINER mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"