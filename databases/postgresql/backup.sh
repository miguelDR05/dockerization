#!/bin/bash
# PostgreSQL - Script de backup
cd "$(dirname "$0")"
CONTAINER_NAME="postgres_container"
SERVICE_NAME="PostgreSQL"
BACKUP_DIR="./backups"
DATE=$(date +"%Y%m%d_%H%M%S")

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}💾 Backup de $SERVICE_NAME${NC}"
echo "========================================"

# Verificar si el contenedor está corriendo
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo -e "${RED}❌ Contenedor $CONTAINER_NAME no está corriendo${NC}"
    echo -e "${YELLOW}💡 Inicia el servicio con ./start.sh${NC}"
    exit 1
fi

# Crear directorio de backup si no existe
mkdir -p $BACKUP_DIR

echo -e "${YELLOW}📁 Creando backup en: $BACKUP_DIR${NC}"

# Backup de la base de datos usando pg_dump
echo -e "${BLUE}🗄️  Haciendo backup de la base de datos 'demo_db'...${NC}"
BACKUP_FILE="$BACKUP_DIR/postgres_demo_db_$DATE.sql"

docker exec $CONTAINER_NAME pg_dump -U admin -d demo_db > $BACKUP_FILE

if [ $? -eq 0 ] && [ -s $BACKUP_FILE ]; then
    echo -e "${GREEN}✅ Backup de la base de datos completado: $BACKUP_FILE${NC}"
    SIZE=$(ls -lh $BACKUP_FILE | awk '{print $5}')
    echo "   📏 Tamaño: $SIZE"
else
    echo -e "${RED}❌ Error en el backup de la base de datos${NC}"
    rm -f $BACKUP_FILE
    exit 1
fi

# Backup del volumen completo
echo -e "${BLUE}💿 Haciendo backup del volumen de datos...${NC}"
VOLUME_NAME=$(docker inspect $CONTAINER_NAME --format='{{range .Mounts}}{{if eq .Destination "/var/lib/postgresql/data"}}{{.Name}}{{end}}{{end}}')

if [ -n "$VOLUME_NAME" ]; then
    VOLUME_BACKUP_FILE="$BACKUP_DIR/postgres_volume_backup_$DATE.tar.gz"
    docker run --rm -v $VOLUME_NAME:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/postgres_volume_backup_$DATE.tar.gz -C /data .
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Backup del volumen completado: $VOLUME_BACKUP_FILE${NC}"
        SIZE=$(ls -lh $VOLUME_BACKUP_FILE | awk '{print $5}')
        echo "   📏 Tamaño: $SIZE"
    else
        echo -e "${RED}❌ Error en el backup del volumen${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No se encontró volumen de datos configurado${NC}"
fi

# Información del backup
echo ""
echo -e "${BLUE}📊 Información del Backup:${NC}"
echo "  📅 Fecha: $(date)"
echo "  📁 Directorio: $BACKUP_DIR"
echo "  📦 Archivos disponibles:"
ls -la $BACKUP_DIR/ | grep -E "\.(sql|tar\.gz)$" | awk '{print "    " $9 " (" $5 ")"}'

echo ""
echo -e "${YELLOW}💡 Para restaurar desde un backup SQL:${NC}"
echo "   docker exec -i $CONTAINER_NAME psql -U admin -d demo_db < backups/ARCHIVO_BACKUP.sql"
echo ""
echo -e "${YELLOW}💡 Para restaurar el volumen completo:${NC}"
echo "   1. Detén el servicio: ./stop.sh"
echo "   2. Elimina el volumen: docker volume rm postgres_data"
echo "   3. Inicia el servicio: ./start.sh"
echo "   4. Restaura: docker run --rm -v postgres_data:/data -v $(pwd)/backups:/backup alpine tar xzf /backup/ARCHIVO_BACKUP.tar.gz -C /data"