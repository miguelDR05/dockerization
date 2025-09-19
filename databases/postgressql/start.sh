#!/bin/bash
# PostgreSQL - Script de inicio con verificaciones
cd "$(dirname "$0")"
SERVICE_NAME="PostgreSQL"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"
CONTAINER_NAME="postgres_container"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando $SERVICE_NAME...${NC}"

# Verificar si existe el archivo .env
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}❌ Archivo $ENV_FILE no encontrado${NC}"
    echo -e "${YELLOW}💡 Crea el archivo .env con POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB${NC}"
    exit 1
fi

# Verificar si Docker está corriendo
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker no está corriendo${NC}"
    exit 1
fi

# Verificar si el contenedor ya existe
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo -e "${YELLOW}⚠️  $CONTAINER_NAME ya está corriendo${NC}"
        exit 0
    else
        echo -e "${YELLOW}🔄 Iniciando contenedor existente...${NC}"
        docker start $CONTAINER_NAME
    fi
else
    echo -e "${GREEN}🐳 Creando e iniciando contenedores...${NC}"
    docker-compose -f $COMPOSE_FILE up -d
fi

# Esperar a que el servicio esté listo
echo -e "${YELLOW}⏳ Esperando a que PostgreSQL esté listo...${NC}"
sleep 5

# Verificar estado
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo -e "${GREEN}✅ $SERVICE_NAME iniciado correctamente${NC}"
    echo ""
    echo -e "${BLUE}📊 Estado del contenedor:${NC}"
    docker ps --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    echo -e "${BLUE}🌐 Información de conexión:${NC}"
    echo "  📍 Servidor: localhost:5432"
    echo "  🗄️  Base de datos: demo_db (configurada en .env)"
    echo "  👤 Usuario: admin (configurado en .env)"
    echo "  🔑 Contraseña: (definida en .env)"
    echo "  🛠️  Cliente recomendado: pgAdmin, DBeaver, psql"
    echo ""
    echo -e "${BLUE}📋 Datos de prueba incluidos:${NC}"
    echo "  👥 Tabla 'empleados' con 3 registros de ejemplo"
else
    echo -e "${RED}❌ Error al iniciar $SERVICE_NAME${NC}"
    echo -e "${YELLOW}💡 Revisa los logs con: docker logs $CONTAINER_NAME${NC}"
    exit 1
fi