#!/bin/bash
# SQL Server - Script de backup
cd "$(dirname "$0")"
CONTAINER_NAME="sqlserver_container"
SERVICE_NAME="SQL Server"
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
    echo -e "${YELLOW}💡 Inicia el servicio con ./start-mssql.sh${NC}"
    exit 1
fi

# Crear directorio de backup si no existe
mkdir -p $BACKUP_DIR

echo -e "${YELLOW}📁 Creando backup en: $BACKUP_DIR${NC}"

# Backup del volumen de datos completo
echo -e "${BLUE}🗄️  Haciendo backup del volumen de datos...${NC}"
VOLUME_NAME=$(docker inspect $CONTAINER_NAME --format='{{range .Mounts}}{{if eq .Destination "/var/opt/mssql"}}{{.Name}}{{end}}{{end}}')

if [ -n "$VOLUME_NAME" ]; then
    BACKUP_FILE="$BACKUP_DIR/mssql_volume_backup_$DATE.tar.gz"
    docker run --rm -v $VOLUME_NAME:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/mssql_volume_backup_$DATE.tar.gz -C /data .
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Backup del volumen completado: $BACKUP_FILE${NC}"
        SIZE=$(ls -lh $BACKUP_FILE | awk '{print $5}')
        echo "   📏 Tamaño: $SIZE"
    else
        echo -e "${RED}❌ Error en el backup del volumen${NC}"
        exit 1
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
ls -la $BACKUP_DIR/ | grep -E "\.(tar\.gz|sql)$" | awk '{print "    " $9 " (" $5 ")"}'

echo ""
echo -e "${YELLOW}💡 Para restaurar un backup:${NC}"
echo "   1. Detén el servicio: ./stop.sh"
echo "   2. Elimina el volumen: docker volume rm mssql_data"
echo "   3. Inicia el servicio: ./start-mssql.sh"
echo "   4. Restaura: docker run --rm -v mssql_data:/data -v $(pwd)/backups:/backup alpine tar xzf /backup/ARCHIVO_BACKUP.tar.gz -C /data"