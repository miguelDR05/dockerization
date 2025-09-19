#!/bin/bash
# MySQL - Monitor de logs (ambos servicios)
cd "$(dirname "$0")"
MYSQL_CONTAINER="mysql_container"
PHPMYADMIN_CONTAINER="phpmyadmin_container"
SERVICE_NAME="MySQL"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Logs de $SERVICE_NAME${NC}"
echo -e "${YELLOW}💡 Presiona Ctrl+C para salir${NC}"

# Verificar qué contenedores existen
MYSQL_EXISTS=$(docker ps -aq -f name=$MYSQL_CONTAINER)
PHPMYADMIN_EXISTS=$(docker ps -aq -f name=$PHPMYADMIN_CONTAINER)

if [ -z "$MYSQL_EXISTS" ] && [ -z "$PHPMYADMIN_EXISTS" ]; then
    echo -e "${RED}❌ No se encontraron contenedores de MySQL${NC}"
    echo -e "${YELLOW}💡 Ejecuta ./start.sh primero${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Selecciona los logs a mostrar:${NC}"
echo "1. 🗄️  Solo MySQL"
echo "2. 🌐 Solo phpMyAdmin"
echo "3. 📊 Ambos servicios (docker-compose logs)"
echo ""

read -p "Selecciona una opción (1-3): " choice

case $choice in
    1)
        if [ -n "$MYSQL_EXISTS" ]; then
            echo "=========================================="
            echo -e "${BLUE}📋 Logs de MySQL:${NC}"
            echo "=========================================="
            docker logs -f $MYSQL_CONTAINER
        else
            echo -e "${RED}❌ Contenedor MySQL no encontrado${NC}"
        fi
        ;;
    2)
        if [ -n "$PHPMYADMIN_EXISTS" ]; then
            echo "=========================================="
            echo -e "${BLUE}📋 Logs de phpMyAdmin:${NC}"
            echo "=========================================="
            docker logs -f $PHPMYADMIN_CONTAINER
        else
            echo -e "${RED}❌ Contenedor phpMyAdmin no encontrado${NC}"
        fi
        ;;
    3)
        echo "=========================================="
        echo -e "${BLUE}📋 Logs de todos los servicios:${NC}"
        echo "=========================================="
        docker-compose logs -f
        ;;
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac