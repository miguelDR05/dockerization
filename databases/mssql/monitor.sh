#!/bin/bash
# SQL Server - Monitor de recursos y estado
cd "$(dirname "$0")"
CONTAINER_NAME="sqlserver_container"
SERVICE_NAME="SQL Server"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 Monitor de $SERVICE_NAME${NC}"
echo "========================================"

# Verificar si el contenedor existe
if [ ! "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo -e "${RED}❌ Contenedor $CONTAINER_NAME no encontrado${NC}"
    exit 1
fi

# Estado del contenedor
echo -e "${BLUE}📦 Estado del Contenedor:${NC}"
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo -e "  ${GREEN}✅ Corriendo${NC}"
    UPTIME=$(docker inspect --format='{{.State.StartedAt}}' $CONTAINER_NAME)
    echo "  ⏰ Iniciado: $UPTIME"
else
    echo -e "  ${RED}❌ Detenido${NC}"
    exit 1
fi

echo ""

# Uso de recursos
echo -e "${BLUE}💾 Uso de Recursos:${NC}"
docker stats $CONTAINER_NAME --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"

echo ""

# Información de red
echo -e "${BLUE}🌐 Información de Red:${NC}"
PORT_INFO=$(docker port $CONTAINER_NAME 2>/dev/null)
if [ -n "$PORT_INFO" ]; then
    echo "  $PORT_INFO"
else
    echo "  Sin puertos expuestos"
fi

echo ""

# Volúmenes
echo -e "${BLUE}💿 Volúmenes:${NC}"
docker inspect $CONTAINER_NAME --format='{{range .Mounts}}  {{.Type}}: {{.Source}} -> {{.Destination}}{{printf "\n"}}{{end}}'

echo ""

# Logs recientes (últimas 10 líneas)
echo -e "${BLUE}📋 Logs Recientes (últimas 10 líneas):${NC}"
echo "----------------------------------------"
docker logs --tail 10 $CONTAINER_NAME

echo ""
echo -e "${YELLOW}💡 Para logs en tiempo real: ./logs.sh${NC}"
echo -e "${YELLOW}💡 Para estadísticas en tiempo real: docker stats $CONTAINER_NAME${NC}"