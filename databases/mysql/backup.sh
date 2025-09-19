#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}💾 Sistema de Backup para MySQL...${NC}"

# Verificar si MySQL está corriendo
MYSQL_STATUS=$(docker ps -q -f name=mysql_container 2>/dev/null)
if [ -z "$MYSQL_STATUS" ]; then
    echo -e "${RED}❌ MySQL no está corriendo${NC}"
    echo -e "${YELLOW}💡 Ejecuta ./start.sh primero${NC}"
    exit 1
fi

# Crear directorio de backups si no existe
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

# Timestamp para el backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo -e "\n${GREEN}🎯 Opciones de backup disponibles:${NC}"
echo -e "1. 📄 Backup lógico (mysqldump) - Solo datos y estructura"
echo -e "2. 💿 Backup físico (directorio data) - Archivos completos"
echo -e "3. ⚙️ Backup configuraciones - Archivos conf.d e initdb"
echo -e "4. 🎯 Backup completo - Todo lo anterior"
echo -e "5. ❌ Cancelar"

read -p "Selecciona una opción (1-5): " choice

case $choice in
    1)
        echo -e "\n${BLUE}📄 Realizando backup lógico con mysqldump...${NC}"
        BACKUP_FILE="$BACKUP_DIR/mysql_logical_backup_$TIMESTAMP.sql"
        
        # Backup lógico usando mysqldump
        docker exec mysql_container mysqldump -u admin -padmin --all-databases --routines --triggers > "$BACKUP_FILE"
        
        if [ $? -eq 0 ]; then
            # Comprimir el backup
            gzip "$BACKUP_FILE"
            BACKUP_SIZE=$(du -sh "$BACKUP_FILE.gz" | cut -f1)
            echo -e "${GREEN}✅ Backup lógico completado${NC}"
            echo -e "   📁 Archivo: $BACKUP_FILE.gz"
            echo -e "   📊 Tamaño: $BACKUP_SIZE"
        else
            echo -e "${RED}❌ Error en backup lógico${NC}"
        fi
        ;;
        
    2)
        echo -e "\n${BLUE}💿 Realizando backup físico del directorio data...${NC}"
        if [ -d "./data" ]; then
            BACKUP_FILE="$BACKUP_DIR/mysql_physical_backup_$TIMESTAMP.tar.gz"
            
            # Backup físico del directorio data
            tar -czf "$BACKUP_FILE" -C . data/
            
            if [ $? -eq 0 ]; then
                BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
                echo -e "${GREEN}✅ Backup físico completado${NC}"
                echo -e "   📁 Archivo: $BACKUP_FILE"
                echo -e "   📊 Tamaño: $BACKUP_SIZE"
                echo -e "   ⚠️  Para restaurar, detén MySQL primero"
            else
                echo -e "${RED}❌ Error en backup físico${NC}"
            fi
        else
            echo -e "${RED}❌ Directorio ./data/ no encontrado${NC}"
        fi
        ;;
        
    3)
        echo -e "\n${BLUE}⚙️ Realizando backup de configuraciones...${NC}"
        BACKUP_FILE="$BACKUP_DIR/mysql_config_backup_$TIMESTAMP.tar.gz"
        
        # Backup de configuraciones
        tar -czf "$BACKUP_FILE" conf.d/ initdb/ docker-compose.yml .env 2>/dev/null
        
        if [ $? -eq 0 ]; then
            BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
            echo -e "${GREEN}✅ Backup de configuraciones completado${NC}"
            echo -e "   📁 Archivo: $BACKUP_FILE"
            echo -e "   📊 Tamaño: $BACKUP_SIZE"
            echo -e "   📋 Incluye: conf.d/, initdb/, docker-compose.yml, .env"
        else
            echo -e "${RED}❌ Error en backup de configuraciones${NC}"
        fi
        ;;
        
    4)
        echo -e "\n${BLUE}🎯 Realizando backup completo...${NC}"
        BACKUP_FILE="$BACKUP_DIR/mysql_complete_backup_$TIMESTAMP.tar.gz"
        
        # Primero el backup lógico
        LOGICAL_FILE="$BACKUP_DIR/temp_logical_$TIMESTAMP.sql"
        docker exec mysql_container mysqldump -u admin -padmin --all-databases --routines --triggers > "$LOGICAL_FILE"
        
        # Luego backup completo incluyendo todo
        tar -czf "$BACKUP_FILE" -C . data/ conf.d/ initdb/ docker-compose.yml .env "$LOGICAL_FILE" 2>/dev/null
        
        # Limpiar archivo temporal
        rm -f "$LOGICAL_FILE"
        
        if [ $? -eq 0 ]; then
            BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
            echo -e "${GREEN}✅ Backup completo realizado${NC}"
            echo -e "   📁 Archivo: $BACKUP_FILE"
            echo -e "   📊 Tamaño: $BACKUP_SIZE"
            echo -e "   📋 Incluye: Datos, configuraciones y estructura"
        else
            echo -e "${RED}❌ Error en backup completo${NC}"
        fi
        ;;
        
    5)
        echo -e "${YELLOW}❌ Backup cancelado${NC}"
        exit 0
        ;;
        
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}📁 Backups disponibles:${NC}"
if [ -d "$BACKUP_DIR" ]; then
    ls -lah "$BACKUP_DIR"/mysql_*backup* 2>/dev/null | tail -5
    
    TOTAL_BACKUPS=$(ls "$BACKUP_DIR"/mysql_*backup* 2>/dev/null | wc -l)
    TOTAL_SIZE=$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)
    echo -e "\n📊 Total: $TOTAL_BACKUPS backups ($TOTAL_SIZE)"
else
    echo -e "   No hay backups previos"
fi

echo -e "\n${YELLOW}💡 Tips para restauración:${NC}"
echo -e "   • Backup lógico: mysql < archivo.sql"
echo -e "   • Backup físico: detener MySQL, extraer tar.gz en ./"
echo -e "   • Backup configuraciones: extraer y reiniciar stack"