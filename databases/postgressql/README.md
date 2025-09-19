# 🐳 PostgreSQL - Configuración Intermedia

> **Nivel: Intermedio** - Persistencia de datos y scripts de inicialización

## 📁 Archivos de Configuración

### `docker-compose.yml`
**Propósito**: Configuración intermedia que introduce conceptos de persistencia y automatización

```yaml
services:
  postgres:
    image: postgres:15
    container_name: postgres_container
    env_file: .env
    ports:
      - "5432:5432"           # Puerto estándar de PostgreSQL
    volumes:
      - postgres_data:/var/lib/postgresql/data     # Volumen nombrado para datos
      - ./init:/docker-entrypoint-initdb.d:ro     # Scripts de inicialización
    restart: "no"             # Cambiar a unless-stopped para autoarranque
```

**Características intermedias configuradas:**
- ✅ **Imagen oficial**: `postgres:15` (versión LTS estable)
- ✅ **Persistencia avanzada**: Volumen nombrado gestionado por Docker
- ✅ **Inicialización automática**: Scripts SQL ejecutados en primer arranque
- ✅ **Solo lectura**: Scripts de init en modo `:ro` (read-only)
- ✅ **Variables de entorno**: Configuración completa desde `.env`

### `.env`
**Propósito**: Variables de entorno para usuario, contraseña y base de datos

```bash
POSTGRES_USER=admin
POSTGRES_PASSWORD=md@71436151
POSTGRES_DB=demo_db
```

**Variables explicadas:**
- `POSTGRES_USER`: Usuario administrador personalizado (recomendado vs default 'postgres')
- `POSTGRES_PASSWORD`: Contraseña del usuario administrador
- `POSTGRES_DB`: Base de datos que se creará automáticamente al inicializar

### `init/init.sql`
**Propósito**: Script de inicialización automática con datos de prueba

```sql
-- Crear tabla de prueba
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    puesto VARCHAR(50),
    salario DECIMAL(10,2)
);

-- Insertar registros de prueba
INSERT INTO empleados (nombre, puesto, salario) VALUES
('Ana Torres', 'Ingeniera', 4500.00),
('Luis Pérez', 'Analista', 3800.00),
('María Gómez', 'Gerente', 6000.00);
```

**Características del script:**
- ✅ **Ejecución automática**: Se ejecuta solo en el primer arranque
- ✅ **Datos de prueba**: 3 empleados con diferentes roles y salarios
- ✅ **Tipos de datos**: VARCHAR, DECIMAL, SERIAL (auto-increment)
- ✅ **Constrains**: Primary key, NOT NULL

## 🛠️ Scripts de Utilidad

### `start.sh`
**Propósito**: Iniciar PostgreSQL con verificaciones avanzadas

**Funcionalidades específicas:**
- ✅ Validación de archivo `.env` con todas las variables necesarias
- ✅ Verificación de contenedor existente vs nuevo
- ✅ Tiempo de espera optimizado para PostgreSQL (5 segundos)
- ✅ Información detallada de conexión y datos incluidos
- ✅ Recomendaciones de clientes (pgAdmin, DBeaver, psql)

**Información mostrada:**
```
🌐 Información de conexión:
  📍 Servidor: localhost:5432
  🗄️  Base de datos: demo_db
  👤 Usuario: admin
  🔑 Contraseña: (definida en .env)
  
📋 Datos de prueba incluidos:
  👥 Tabla 'empleados' con 3 registros de ejemplo
```

### `stop.sh`
**Propósito**: Detener PostgreSQL con verificación de estado

**Funcionalidades:**
- ✅ Detección de contenedor corriendo vs detenido
- ✅ Uso de `docker-compose down` para detención limpia
- ✅ Verificación post-detención
- ✅ Mensaje de estado final claro

### `logs.sh`
**Propósito**: Monitoreo de logs específico para PostgreSQL

**Funcionalidades:**
- ✅ Logs en tiempo real con `docker logs -f`
- ✅ Verificación de existencia del contenedor
- ✅ Instrucciones claras de salida

### `monitor.sh`
**Propósito**: Panel avanzado de monitoreo con información específica de PostgreSQL

**Información específica de PostgreSQL:**
- 📊 **Estado del contenedor**: Uptime y estado de ejecución
- 💾 **Recursos**: CPU, RAM, Red, Disco en tiempo real
- 🗄️ **Base de datos**: Tamaño de la BD con `pg_database_size()`
- 🔗 **Conexiones**: Conexiones activas con `pg_stat_activity`
- 💿 **Volúmenes**: Configuración de montajes y persistencia

**Comandos específicos ejecutados:**
```sql
-- Tamaño de la base de datos
SELECT pg_size_pretty(pg_database_size('demo_db'));

-- Conexiones activas
SELECT count(*) FROM pg_stat_activity WHERE state='active';
```

### `backup.sh`
**Propósito**: Backup dual (lógico + físico) para PostgreSQL

**Tipos de backup implementados:**

#### 1. **Backup Lógico (pg_dump)**
```bash
docker exec $CONTAINER_NAME pg_dump -U admin -d demo_db > $BACKUP_FILE
```
- ✅ Backup específico de la base de datos `demo_db`
- ✅ Formato SQL estándar
- ✅ Fácil de restaurar en cualquier PostgreSQL

#### 2. **Backup Físico (Volumen completo)**
```bash
docker run --rm -v $VOLUME_NAME:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/postgres_volume_backup_$DATE.tar.gz -C /data .
```
- ✅ Backup completo del volumen de datos
- ✅ Incluye todas las bases de datos, configuraciones y logs
- ✅ Backup bit-a-bit del directorio de datos

**Archivos generados:**
```
backups/
├── postgres_demo_db_YYYYMMDD_HHMMSS.sql        # Backup lógico
└── postgres_volume_backup_YYYYMMDD_HHMMSS.tar.gz  # Backup físico
```

**Instrucciones de restauración incluidas:**
- Backup SQL: `docker exec -i postgres_container psql -U admin -d demo_db < backups/archivo.sql`
- Backup volumen: Instrucciones paso a paso para recrear volumen

### `cleanup.sh`
**Propósito**: Limpieza avanzada con opción específica para PostgreSQL

**Opciones específicas de PostgreSQL:**
1. 🗂️ Limpiar logs del contenedor
2. 🐳 Reiniciar contenedor
3. 🗄️ **Limpiar datos de la BD (mantener estructura)** - ESPECÍFICO POSTGRES
4. 💿 Eliminar volúmenes (PELIGROSO)
5. 🗑️ Eliminar todo (completo)
6. 📊 Mostrar información de uso

**Opción 3 - Característica única:**
```sql
-- Limpia datos pero mantiene estructura
TRUNCATE TABLE empleados RESTART IDENTITY;

-- Reinserta datos de ejemplo
INSERT INTO empleados (nombre, puesto, salario) VALUES 
('Ana Torres', 'Ingeniera', 4500.00), ...
```

### `connect.sh`
**Propósito**: Conexión directa al CLI de PostgreSQL (psql)

**Funcionalidades específicas:**
- ✅ Conexión automática a base de datos `demo_db`
- ✅ Usuario `admin` desde variables de entorno
- ✅ Tips específicos de psql incluidos

**Comandos útiles mostrados:**
```
💡 Para salir escribe: \q
💡 Para ver tablas: \dt
💡 Para describir tabla: \d nombre_tabla
```

**Comandos útiles dentro de psql:**
```sql
-- Ver todas las tablas
\dt

-- Describir tabla empleados
\d empleados

-- Ver datos
SELECT * FROM empleados;

-- Información de la base de datos
\l

-- Salir
\q
```

## 🚀 Uso Intermedio

### 1. Configuración inicial
```bash
# Verificar configuración
cat .env

# Verificar script de inicialización
cat init/init.sql

# Iniciar PostgreSQL
./start.sh
```

### 2. Conexión y pruebas
```bash
# Conectar vía CLI
./connect.sh

# Verificar datos de prueba
SELECT * FROM empleados;

# Verificar estructura
\d empleados
```

### 3. Monitoreo avanzado
```bash
# Panel completo con info de BD
./monitor.sh

# Logs específicos
./logs.sh
```

### 4. Gestión de datos
```bash
# Backup dual (SQL + volumen)
./backup.sh

# Reiniciar datos a estado inicial
./cleanup.sh  # Opción 3
```

## 🎯 Conceptos Docker Aprendidos

Esta configuración intermedia enseña:

1. **Volúmenes nombrados**: Persistencia gestionada por Docker
2. **Inicialización automática**: Scripts SQL ejecutados en primer arranque
3. **Variables de entorno múltiples**: Usuario, contraseña y base de datos
4. **Montajes de solo lectura**: `:ro` para scripts de inicialización
5. **Gestión de datos**: Backup lógico vs físico
6. **Monitoreo específico**: Comandos SQL para información del sistema

## 🔄 Diferencias vs Configuración Básica (MSSQL)

| Aspecto | MSSQL (Básico) | PostgreSQL (Intermedio) |
|---------|----------------|-------------------------|
| **Persistencia** | Volumen nombrado simple | Volumen nombrado + inicialización |
| **Datos iniciales** | ❌ Ninguno | ✅ Tabla con 3 registros |
| **Backup** | Solo volumen físico | Dual: lógico (pg_dump) + físico |
| **Monitoreo** | Información básica | Info específica: tamaño BD, conexiones |
| **Cleanup** | Opciones estándar | + Opción de reinicio de datos |
| **Inicialización** | Manual después del arranque | Automática con scripts |

## 🔧 Solución de Problemas

### Error: "Database demo_db does not exist"
- Verificar que las variables en `.env` estén correctas
- El contenedor debe arrancar por primera vez para crear la BD
- Si existe, revisar logs: `./logs.sh`

### Error: "Init scripts not executing"
- Verificar que `./init/init.sql` tenga permisos de lectura
- Scripts solo se ejecutan en primer arranque (volumen vacío)
- Para re-ejecutar: `./cleanup.sh` → opción 4 → `./start.sh`

### Error: "Connection refused"
- PostgreSQL tarda menos en arrancar que SQL Server (≈5 segundos)
- Verificar puerto disponible: `netstat -tlpn | grep 5432`
- Revisar logs para errores de configuración: `./logs.sh`

### Tabla empleados no existe
- Script de inicialización falló
- Verificar sintaxis SQL en `init/init.sql`
- Recrear desde cero: `./cleanup.sh` → eliminar volúmenes → `./start.sh`

## 📚 Próximos Pasos

Después de dominar esta configuración intermedia:
1. 🚀 Continuar con **MySQL** (avanzado) - Multi-servicio y redes
2. 🌟 Explorar la rama `pro` para configuraciones production-ready
3. 🔙 Comparar con **MSSQL** básico para entender la progresión
4. 📊 Experimentar con consultas SQL más complejas en los datos de ejemplo