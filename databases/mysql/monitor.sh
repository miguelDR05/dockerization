#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 Monitoreando MySQL + phpMyAdmin...${NC}"

# Verificar si los contenedores existen y están corriendo
MYSQL_STATUS=$(docker ps -q -f name=mysql_container 2>/dev/null)
PHPMYADMIN_STATUS=$(docker ps -q -f name=phpmyadmin_container 2>/dev/null)

if [ -z "$MYSQL_STATUS" ] && [ -z "$PHPMYADMIN_STATUS" ]; then
    echo -e "${RED}❌ No hay contenedores corriendo${NC}"
    echo -e "${YELLOW}💡 Ejecuta ./start.sh para iniciar los servicios${NC}"
    exit 1
fi

echo -e "\n${GREEN}🟢 Estado de los servicios:${NC}"
if [ ! -z "$MYSQL_STATUS" ]; then
    echo -e "   ✅ MySQL Server - Corriendo"
else
    echo -e "   ❌ MySQL Server - Detenido"
fi

if [ ! -z "$PHPMYADMIN_STATUS" ]; then
    echo -e "   ✅ phpMyAdmin - Corriendo"
else
    echo -e "   ❌ phpMyAdmin - Detenido"
fi

echo -e "\n${GREEN}🌐 Información de conexión:${NC}"
echo -e "   🗄️  MySQL Server: localhost:3306"
echo -e "   🌐 phpMyAdmin Web: http://localhost:8081"

echo -e "\n${GREEN}💾 Uso de recursos:${NC}"
if [ ! -z "$MYSQL_STATUS" ] || [ ! -z "$PHPMYADMIN_STATUS" ]; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" mysql_container phpmyadmin_container 2>/dev/null | head -3
fi

echo -e "\n${GREEN}🌍 Red personalizada:${NC}"
NETWORK_EXISTS=$(docker network ls -q -f name=mysql_network 2>/dev/null)
if [ ! -z "$NETWORK_EXISTS" ]; then
    echo -e "   ✅ Red 'mysql_network' activa"
    docker network inspect mysql_network --format '{{.Name}}: {{.Driver}} ({{len .Containers}} contenedores conectados)' 2>/dev/null
else
    echo -e "   ❌ Red 'mysql_network' no encontrada"
fi

echo -e "\n${GREEN}💿 Persistencia de datos:${NC}"
if [ -d "./data" ]; then
    TOTAL_SIZE=$(du -sh ./data 2>/dev/null | cut -f1)
    echo -e "   ✅ Bind mount: ./data/ (${TOTAL_SIZE:-"calculando..."})"
    echo -e "   📊 Archivos principales:"
    ls -la ./data/ 2>/dev/null | head -5 | tail -4 | while read line; do
        echo -e "      $line"
    done
else
    echo -e "   ❌ Directorio ./data/ no existe"
fi

echo -e "\n${GREEN}📋 Logs recientes:${NC}"
echo -e "${BLUE}--- MySQL últimas 3 líneas ---${NC}"
if [ ! -z "$MYSQL_STATUS" ]; then
    docker logs mysql_container --tail 3 2>/dev/null
else
    echo "MySQL no está corriendo"
fi

echo -e "\n${BLUE}--- phpMyAdmin últimas 3 líneas ---${NC}"
if [ ! -z "$PHPMYADMIN_STATUS" ]; then
    docker logs phpmyadmin_container --tail 3 2>/dev/null
else
    echo "phpMyAdmin no está corriendo"
fi

echo -e "\n${YELLOW}💡 Comandos útiles:${NC}"
echo -e "   ./logs.sh     - Ver logs detallados"
echo -e "   ./connect.sh  - Conectar al CLI de MySQL"
echo -e "   ./stop.sh     - Detener los servicios"