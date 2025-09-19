#!/bin/bash
# PostgreSQL - Script de limpieza y mantenimiento
cd "$(dirname "$0")"
CONTAINER_NAME="postgres_container"
SERVICE_NAME="PostgreSQL"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Limpieza de $SERVICE_NAME${NC}"
echo "========================================"

# Función para confirmar acciones peligrosas
confirm() {
    read -p "¿Estás seguro? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

echo -e "${YELLOW}Opciones de limpieza:${NC}"
echo "1. 🗂️  Limpiar logs del contenedor"
echo "2. 🐳 Reiniciar contenedor"
echo "3. 🗄️  Limpiar datos de la base de datos (mantener estructura)"
echo "4. 💿 Eliminar volúmenes (PELIGROSO: elimina datos)"
echo "5. 🗑️  Eliminar todo (contenedores + volúmenes + imágenes)"
echo "6. 📊 Solo mostrar información de uso de espacio"
echo ""

read -p "Selecciona una opción (1-6): " choice

case $choice in
    1)
        echo -e "${BLUE}🗂️  Limpiando logs del contenedor...${NC}"
        if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
            docker logs --details $CONTAINER_NAME 2>/dev/null | wc -l | xargs echo "Líneas de log actuales:"
            sudo truncate -s 0 $(docker inspect --format='{{.LogPath}}' $CONTAINER_NAME 2>/dev/null) 2>/dev/null
            echo -e "${GREEN}✅ Logs limpiados${NC}"
        else
            echo -e "${YELLOW}⚠️  Contenedor no encontrado${NC}"
        fi
        ;;
    2)
        echo -e "${BLUE}🐳 Reiniciando contenedor...${NC}"
        if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
            docker restart $CONTAINER_NAME
            echo -e "${GREEN}✅ Contenedor reiniciado${NC}"
        else
            echo -e "${YELLOW}⚠️  Contenedor no está corriendo${NC}"
        fi
        ;;
    3)
        echo -e "${YELLOW}⚠️  Esto eliminará los datos pero mantendrá la estructura de la BD${NC}"
        if confirm; then
            if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
                echo -e "${BLUE}🗄️  Limpiando datos de la tabla empleados...${NC}"
                docker exec $CONTAINER_NAME psql -U admin -d demo_db -c "TRUNCATE TABLE empleados RESTART IDENTITY;"
                echo -e "${BLUE}🔄 Insertando datos de ejemplo nuevamente...${NC}"
                docker exec $CONTAINER_NAME psql -U admin -d demo_db -c "INSERT INTO empleados (nombre, puesto, salario) VALUES ('Ana Torres', 'Ingeniera', 4500.00), ('Luis Pérez', 'Analista', 3800.00), ('María Gómez', 'Gerente', 6000.00);"
                echo -e "${GREEN}✅ Datos reiniciados a estado inicial${NC}"
            else
                echo -e "${RED}❌ Contenedor no está corriendo${NC}"
            fi
        else
            echo -e "${YELLOW}❌ Operación cancelada${NC}"
        fi
        ;;
    4)
        echo -e "${RED}⚠️  PELIGRO: Esto eliminará todos los datos de la base de datos${NC}"
        if confirm; then
            echo -e "${BLUE}🛑 Deteniendo servicios...${NC}"
            docker-compose down
            echo -e "${BLUE}💿 Eliminando volúmenes...${NC}"
            docker volume ls | grep postgres | awk '{print $2}' | xargs -r docker volume rm
            echo -e "${GREEN}✅ Volúmenes eliminados${NC}"
        else
            echo -e "${YELLOW}❌ Operación cancelada${NC}"
        fi
        ;;
    5)
        echo -e "${RED}⚠️  PELIGRO: Esto eliminará TODO (contenedores, volúmenes, imágenes)${NC}"
        if confirm; then
            echo -e "${BLUE}🛑 Deteniendo y eliminando contenedores...${NC}"
            docker-compose down --rmi all --volumes --remove-orphans
            echo -e "${BLUE}🗑️  Limpiando imágenes no utilizadas...${NC}"
            docker image prune -f
            echo -e "${GREEN}✅ Limpieza completa realizada${NC}"
        else
            echo -e "${YELLOW}❌ Operación cancelada${NC}"
        fi
        ;;
    6)
        echo -e "${BLUE}📊 Información de uso de espacio:${NC}"
        echo ""
        echo -e "${BLUE}Contenedores:${NC}"
        docker ps -a --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Size}}"
        echo ""
        echo -e "${BLUE}Volúmenes:${NC}"
        docker volume ls | grep postgres
        echo ""
        echo -e "${BLUE}Imágenes:${NC}"
        docker images | grep postgres
        echo ""
        if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
            echo -e "${BLUE}Tamaño de la base de datos:${NC}"
            docker exec $CONTAINER_NAME psql -U admin -d demo_db -c "SELECT pg_size_pretty(pg_database_size('demo_db')) as database_size;"
        fi
        echo ""
        echo -e "${BLUE}Uso total de Docker:${NC}"
        docker system df
        ;;
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac