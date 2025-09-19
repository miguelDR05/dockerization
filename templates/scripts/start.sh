#!/bin/bash
# Template para script de inicio de servicios Docker
# Personaliza las variables según tu herramienta

# Configuración
SERVICE_NAME="tu-servicio"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Iniciando $SERVICE_NAME...${NC}"

# Verificar si existe el archivo .env
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${YELLOW}⚠️  Archivo $ENV_FILE no encontrado. Creando desde template...${NC}"
    if [ -f ".env.template" ]; then
        cp .env.template $ENV_FILE
        echo -e "${YELLOW}📝 Por favor, edita $ENV_FILE con tus configuraciones${NC}"
        exit 1
    else
        echo -e "${RED}❌ No se encontró .env.template${NC}"
        exit 1
    fi
fi

# Verificar si Docker está corriendo
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker no está corriendo${NC}"
    exit 1
fi

# Crear directorios necesarios si no existen
echo "📁 Verificando directorios..."
# mkdir -p data logs config

# Iniciar servicios
echo "🐳 Iniciando contenedores..."
docker-compose -f $COMPOSE_FILE up -d

# Verificar estado
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ $SERVICE_NAME iniciado correctamente${NC}"
    echo ""
    echo "📊 Estado de los contenedores:"
    docker-compose -f $COMPOSE_FILE ps
    echo ""
    echo "🌐 URLs disponibles:"
    echo "  - Servicio principal: http://localhost:[PUERTO]"
    echo "  - Administración: http://localhost:[PUERTO_ADMIN]"
else
    echo -e "${RED}❌ Error al iniciar $SERVICE_NAME${NC}"
    exit 1
fi