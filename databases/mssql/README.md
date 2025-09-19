# 🐳 SQL Server - Configuración Básica

> **Nivel: Básico** - Introducción a Docker con SQL Server 2022 Developer

## 📁 Archivos de Configuración

### `docker-compose.yml`
**Propósito**: Configuración minimalista de SQL Server para aprendizaje

```yaml
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sqlserver_container
    env_file: .env
    environment:
      - ACCEPT_EULA=Y          # Acepta los términos de licencia
      - MSSQL_PID=Developer    # Edición Developer (gratuita)
      - SA_PASSWORD=${SA_PASSWORD}
    ports:
      - "1433:1433"           # Puerto estándar de SQL Server
    volumes:
      - mssql_data:/var/opt/mssql  # Volumen nombrado para persistencia
    restart: "no"             # No reiniciar automáticamente
```

**Características básicas configuradas:**
- ✅ **Imagen oficial**: `mcr.microsoft.com/mssql/server:2022-latest`
- ✅ **Persistencia**: Volumen nombrado `mssql_data`
- ✅ **Puerto estándar**: 1433 mapeado directamente
- ✅ **Edición Developer**: Gratuita para desarrollo
- ✅ **Variables de entorno**: Configuradas desde archivo `.env`

### `.env`
**Propósito**: Variables de entorno sensibles y configuración

```bash
# Contraseña del usuario administrador 'sa'
SA_PASSWORD=md@71436151
```

**Variables explicadas:**
- `SA_PASSWORD`: Contraseña del usuario administrador (sa = System Administrator)
  - Debe cumplir políticas de seguridad de SQL Server
  - Mínimo 8 caracteres, mayúsculas, minúsculas, números y símbolos

### `data/` (Directorio)
**Propósito**: Este directorio NO existe en esta configuración básica

📝 **Nota importante**: En esta configuración básica usamos volúmenes nombrados de Docker en lugar de bind mounts físicos. Los datos se almacenan en `/var/lib/docker/volumes/` administrado por Docker.

## 🛠️ Scripts de Utilidad

### `start-mssql.sh` / `start.sh`
**Propósito**: Iniciar SQL Server con verificaciones inteligentes

**Funcionalidades:**
- ✅ Verifica que Docker esté corriendo
- ✅ Valida que existe el archivo `.env`
- ✅ Detecta si el contenedor ya existe
- ✅ Espera a que SQL Server esté completamente listo
- ✅ Muestra información de conexión
- ✅ Código de colores para mejor experiencia

**Uso:**
```bash
./start.sh
# o
./start-mssql.sh
```

### `stop.mssql.sh` / `stop.sh`  
**Propósito**: Detener SQL Server de forma segura

**Funcionalidades:**
- ✅ Detección inteligente del estado del contenedor
- ✅ Detención graceful con `docker-compose down`
- ✅ Verificación post-detención
- ✅ Información clara del estado final

### `logs.sh`
**Propósito**: Monitorear logs en tiempo real

**Funcionalidades:**
- ✅ Logs en tiempo real con `docker logs -f`
- ✅ Verificación de existencia del contenedor
- ✅ Instrucciones claras para salir (Ctrl+C)

### `monitor.sh`
**Propósito**: Panel completo de monitoreo y diagnóstico

**Información mostrada:**
- 📊 Estado del contenedor (corriendo/detenido/uptime)
- 💾 Uso de recursos (CPU, RAM, Red, Disco)
- 🌐 Información de red y puertos
- 💿 Configuración de volúmenes
- 📋 Logs recientes (últimas 10 líneas)

### `backup.sh`
**Propósito**: Backup del volumen de datos completo

**Funcionalidades:**
- ✅ Backup automático del volumen `mssql_data`
- ✅ Compresión con tar.gz
- ✅ Nombres con timestamp
- ✅ Verificación de integridad
- ✅ Instrucciones de restauración

**Archivos generados:**
```
backups/
└── mssql_volume_backup_YYYYMMDD_HHMMSS.tar.gz
```

### `cleanup.sh`
**Propósito**: Mantenimiento y limpieza del sistema

**Opciones disponibles:**
1. 🗂️ Limpiar logs del contenedor
2. 🐳 Reiniciar contenedor
3. 💿 Eliminar volúmenes (PELIGROSO)
4. 🗑️ Eliminar todo (completo)
5. 📊 Mostrar uso de espacio

### `connect.sh`
**Propósito**: Conectar directamente al CLI de SQL Server

**Funcionalidades:**
- ✅ Conexión automática usando credenciales de `.env`
- ✅ Acceso directo a `sqlcmd` dentro del contenedor
- ✅ Usuario `sa` con contraseña desde variables de entorno

**Comandos útiles dentro de sqlcmd:**
```sql
-- Ver bases de datos
SELECT name FROM sys.databases;
GO

-- Crear base de datos de prueba
CREATE DATABASE TestDB;
GO

-- Usar base de datos
USE TestDB;
GO

-- Salir
exit
```

## 🚀 Uso Básico

### 1. Configuración inicial
```bash
# Asegurar que el archivo .env existe con SA_PASSWORD
cat .env

# Iniciar SQL Server
./start.sh
```

### 2. Conexión
```bash
# Desde CLI
./connect.sh

# Desde cliente externo
# Servidor: localhost,1433
# Usuario: sa
# Contraseña: (la definida en .env)
```

### 3. Monitoreo
```bash
# Ver estado general
./monitor.sh

# Ver logs en tiempo real
./logs.sh
```

### 4. Mantenimiento
```bash
# Backup
./backup.sh

# Limpieza
./cleanup.sh
```

## 🎯 Conceptos Docker Aprendidos

Esta configuración básica enseña:

1. **Imágenes oficiales**: Uso de `mcr.microsoft.com/mssql/server`
2. **Variables de entorno**: Configuración con archivos `.env`
3. **Volúmenes nombrados**: Persistencia de datos con Docker
4. **Mapeo de puertos**: Exposición de servicios al host
5. **Docker Compose básico**: Orquestación simple
6. **Gestión de contenedores**: Start, stop, logs, monitoring

## 🔧 Solución de Problemas

### Error: "Password validation failed"
- La contraseña debe cumplir políticas de SQL Server
- Mínimo 8 caracteres con mayúsculas, minúsculas, números y símbolos

### Error: "Cannot connect to server"
- Verificar que el contenedor esté corriendo: `./monitor.sh`
- Esperar a que SQL Server termine de inicializar (puede tomar 30-60 segundos)
- Verificar logs: `./logs.sh`

### Error: "Port 1433 already in use"
- Cambiar puerto en `docker-compose.yml`: `"1434:1433"`
- O detener otros servicios SQL Server locales

### Contenedor se reinicia constantemente
- Revisar logs para ver errores de configuración
- Verificar que la contraseña cumple requisitos
- Verificar recursos disponibles (RAM mínima: 2GB)

## 📚 Próximos Pasos

Después de dominar esta configuración básica:
1. 🔄 Continuar con **PostgreSQL** (intermedio)
2. 🚀 Avanzar a **MySQL** (avanzado)
3. 🌟 Explorar la rama `pro` para configuraciones production-ready