#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Sistema de Limpieza para MySQL + phpMyAdmin...${NC}"

echo -e "\n${GREEN}🎯 Opciones de limpieza disponibles:${NC}"
echo -e "1. 📋 Limpiar logs de ambos contenedores"
echo -e "2. 🔄 Reiniciar stack (mantener datos)"
echo -e "3. 🗑️ Limpiar datos MySQL (mantener estructura)"
echo -e "4. ⚠️ Eliminar directorio data completo (PELIGROSO)"
echo -e "5. 🔥 Eliminar todo (contenedores + red + volúmenes)"
echo -e "6. 🧹 Limpiar backups antiguos"
echo -e "7. ❌ Cancelar"

read -p "Selecciona una opción (1-7): " choice

case $choice in
    1)
        echo -e "\n${BLUE}📋 Limpiando logs de contenedores...${NC}"
        
        # Verificar si los contenedores existen
        MYSQL_STATUS=$(docker ps -aq -f name=mysql_container 2>/dev/null)
        PHPMYADMIN_STATUS=$(docker ps -aq -f name=phpmyadmin_container 2>/dev/null)
        
        if [ ! -z "$MYSQL_STATUS" ]; then
            echo -e "   🗄️ Limpiando logs de MySQL..."
            docker logs mysql_container > /dev/null 2>&1
            echo -e "   ✅ Logs de MySQL limpiados"
        fi
        
        if [ ! -z "$PHPMYADMIN_STATUS" ]; then
            echo -e "   🌐 Limpiando logs de phpMyAdmin..."
            docker logs phpmyadmin_container > /dev/null 2>&1
            echo -e "   ✅ Logs de phpMyAdmin limpiados"
        fi
        
        echo -e "${GREEN}✅ Limpieza de logs completada${NC}"
        ;;
        
    2)
        echo -e "\n${BLUE}🔄 Reiniciando stack MySQL + phpMyAdmin...${NC}"
        
        echo -e "   🛑 Deteniendo servicios..."
        docker-compose down
        
        echo -e "   🚀 Iniciando servicios..."
        docker-compose up -d
        
        echo -e "   ⏳ Esperando que MySQL esté listo..."
        sleep 10
        
        # Verificar que estén corriendo
        MYSQL_STATUS=$(docker ps -q -f name=mysql_container 2>/dev/null)
        PHPMYADMIN_STATUS=$(docker ps -q -f name=phpmyadmin_container 2>/dev/null)
        
        if [ ! -z "$MYSQL_STATUS" ] && [ ! -z "$PHPMYADMIN_STATUS" ]; then
            echo -e "${GREEN}✅ Stack reiniciado exitosamente${NC}"
            echo -e "   🗄️ MySQL: Corriendo"
            echo -e "   🌐 phpMyAdmin: http://localhost:8081"
        else
            echo -e "${RED}❌ Error al reiniciar el stack${NC}"
        fi
        ;;
        
    3)
        echo -e "\n${YELLOW}⚠️ Esta acción eliminará TODOS los datos de MySQL${NC}"
        echo -e "Se mantendrá la estructura pero se perderán los datos"
        read -p "¿Estás seguro? (escribe 'SI' para confirmar): " confirm
        
        if [ "$confirm" = "SI" ]; then
            echo -e "\n${BLUE}🗑️ Limpiando datos MySQL...${NC}"
            
            # Detener MySQL
            docker-compose stop mysql
            
            # Eliminar archivos de datos pero mantener estructura
            if [ -d "./data" ]; then
                echo -e "   🗄️ Eliminando archivos de bases de datos..."
                rm -rf ./data/mydb/* 2>/dev/null
                find ./data -name "*.ibd" -delete 2>/dev/null
                find ./data -name "binlog.*" -delete 2>/dev/null
                echo -e "   ✅ Datos eliminados"
            fi
            
            # Reiniciar MySQL para recrear datos
            echo -e "   🚀 Reiniciando MySQL..."
            docker-compose up -d mysql
            
            echo -e "${GREEN}✅ Datos MySQL limpiados y recreados${NC}"
        else
            echo -e "${YELLOW}❌ Operación cancelada${NC}"
        fi
        ;;
        
    4)
        echo -e "\n${RED}⚠️ PELIGRO: Esta acción eliminará TODO el directorio data${NC}"
        echo -e "Se perderán TODOS los datos y configuraciones de MySQL"
        read -p "¿Estás COMPLETAMENTE seguro? (escribe 'ELIMINAR' para confirmar): " confirm
        
        if [ "$confirm" = "ELIMINAR" ]; then
            echo -e "\n${BLUE}💥 Eliminando directorio data completo...${NC}"
            
            # Detener servicios
            docker-compose down
            
            # Eliminar directorio data
            if [ -d "./data" ]; then
                echo -e "   🗂️ Eliminando ./data/..."
                rm -rf ./data/
                echo -e "   ✅ Directorio data eliminado"
            fi
            
            echo -e "${GREEN}✅ Directorio data eliminado completamente${NC}"
            echo -e "${YELLOW}💡 La próxima vez que inicies se creará un MySQL limpio${NC}"
        else
            echo -e "${YELLOW}❌ Operación cancelada${NC}"
        fi
        ;;
        
    5)
        echo -e "\n${RED}⚠️ PELIGRO: Esta acción eliminará TODO${NC}"
        echo -e "Se eliminarán: contenedores, red, volúmenes y datos"
        read -p "¿Estás COMPLETAMENTE seguro? (escribe 'ELIMINAR_TODO' para confirmar): " confirm
        
        if [ "$confirm" = "ELIMINAR_TODO" ]; then
            echo -e "\n${BLUE}🔥 Eliminando todo...${NC}"
            
            # Detener y eliminar todo
            docker-compose down -v --remove-orphans
            
            # Eliminar red personalizada si existe
            docker network rm mysql_network 2>/dev/null
            
            # Eliminar directorio data
            if [ -d "./data" ]; then
                rm -rf ./data/
            fi
            
            # Eliminar contenedores huérfanos si existen
            docker container prune -f --filter label=com.docker.compose.project=mysql
            
            echo -e "${GREEN}✅ TODO eliminado completamente${NC}"
            echo -e "${YELLOW}💡 Puedes iniciar desde cero con ./start.sh${NC}"
        else
            echo -e "${YELLOW}❌ Operación cancelada${NC}"
        fi
        ;;
        
    6)
        echo -e "\n${BLUE}🧹 Limpiando backups antiguos...${NC}"
        
        if [ -d "./backups" ]; then
            echo -e "   📊 Backups actuales:"
            ls -la ./backups/ | wc -l | xargs echo "   Total de archivos:"
            
            # Eliminar backups más antiguos de 7 días
            find ./backups -name "mysql_*backup*" -mtime +7 -delete 2>/dev/null
            
            echo -e "   🗑️ Backups antiguos (>7 días) eliminados"
            
            REMAINING=$(ls ./backups/mysql_*backup* 2>/dev/null | wc -l)
            echo -e "${GREEN}✅ Limpieza completada. Backups restantes: $REMAINING${NC}"
        else
            echo -e "${YELLOW}📂 No hay directorio de backups${NC}"
        fi
        ;;
        
    7)
        echo -e "${YELLOW}❌ Limpieza cancelada${NC}"
        exit 0
        ;;
        
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac

echo -e "\n${YELLOW}💡 Estado actual:${NC}"
MYSQL_STATUS=$(docker ps -q -f name=mysql_container 2>/dev/null)
PHPMYADMIN_STATUS=$(docker ps -q -f name=phpmyadmin_container 2>/dev/null)

if [ ! -z "$MYSQL_STATUS" ]; then
    echo -e "   ✅ MySQL: Corriendo"
else
    echo -e "   ❌ MySQL: Detenido"
fi

if [ ! -z "$PHPMYADMIN_STATUS" ]; then
    echo -e "   ✅ phpMyAdmin: Corriendo"
else
    echo -e "   ❌ phpMyAdmin: Detenido"
fi