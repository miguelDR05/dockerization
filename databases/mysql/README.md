# 🐳 MySQL - Configuración Avanzada

> **Nivel: Avanzado** - Multi-servicio, redes personalizadas y administración web

## 📁 Archivos de Configuración

### `docker-compose.yml`
**Propósito**: Configuración avanzada con múltiples servicios y networking personalizado

```yaml
services:
  mysql:
    image: mysql:8.0
    container_name: mysql_container
    restart: always
    env_file: .env
    ports:
      - "${MYSQL_PORT}:3306"
    volumes:
      - ./data:/var/lib/mysql                    # Bind mount físico
      - ./conf.d:/etc/mysql/conf.d               # Configuraciones personalizadas
      - ./initdb:/docker-entrypoint-initdb.d    # Scripts de inicialización
    command: --default-authentication-plugin=mysql_native_password
    networks:
      - mysql_network

  phpmyadmin:
    image: phpmyadmin:latest
    container_name: phpmyadmin_container
    restart: always
    ports:
      - "8081:80"
    environment:
      PMA_HOST: mysql                            # Comunicación por nombre de servicio
      PMA_PORT: 3306
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    depends_on:
      - mysql                                    # Dependencia de arranque
    networks:
      - mysql_network

networks:
  mysql_network:
    driver: bridge                               # Red personalizada
```

**Características avanzadas configuradas:**
- ✅ **Multi-servicio**: MySQL + phpMyAdmin en un solo stack
- ✅ **Red personalizada**: `mysql_network` para comunicación interna
- ✅ **Bind mounts**: Persistencia física en `./data/`
- ✅ **Configuración personalizada**: Archivos `.cnf` en `./conf.d/`
- ✅ **Dependencias**: phpMyAdmin espera a MySQL
- ✅ **Restart policy**: `always` para alta disponibilidad
- ✅ **Plugin de autenticación**: Compatible con clientes legacy

### `.env`
**Propósito**: Variables de entorno completas para ambos servicios

```bash
MYSQL_ROOT_PASSWORD=admin
MYSQL_DATABASE=mydb
MYSQL_USER=admin
MYSQL_PASSWORD=admin
MYSQL_PORT=3306
MYSQL_HOST=localhost
```

**Variables explicadas:**
- `MYSQL_ROOT_PASSWORD`: Contraseña del usuario root (también usada por phpMyAdmin)
- `MYSQL_DATABASE`: Base de datos creada automáticamente
- `MYSQL_USER`: Usuario adicional (no root) para aplicaciones
- `MYSQL_PASSWORD`: Contraseña del usuario adicional
- `MYSQL_PORT`: Puerto configurable (por defecto 3306)
- `MYSQL_HOST`: Host para conexiones externas

### `conf.d/my.cnf`
**Propósito**: Configuración personalizada del servidor MySQL

```ini
[mysqld]
sql_mode=STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
```

**Configuraciones explicadas:**
- `sql_mode`: Modo estricto para mejor integridad de datos
- `character-set-server`: UTF8MB4 para soporte completo de Unicode
- `collation-server`: Collation general para comparaciones

### `initdb/init.sql`
**Propósito**: Script de inicialización con datos de prueba

```sql
-- Script de ejemplo, se ejecuta al iniciar por primera vez
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES
('Admin', 'admin@example.com'),
('Test User', 'test@example.com');
```

**Características del script:**
- ✅ **Tabla de usuarios**: Estructura típica de aplicación web
- ✅ **Auto-increment**: ID automático
- ✅ **Constraints**: UNIQUE email, NOT NULL
- ✅ **Timestamp**: Fecha de creación automática
- ✅ **Datos de prueba**: 2 usuarios de ejemplo

### `data/` (Directorio)
**Propósito**: Persistencia física de datos en el host

**Contenido típico:**
```
data/
├── auto.cnf                    # Configuración automática
├── binlog.*                    # Logs binarios para replicación
├── ca*.pem, server*.pem        # Certificados SSL automáticos
├── ib*                         # Archivos InnoDB
├── mysql.ibd                   # Tablas del sistema
├── mydb/                       # Nuestra base de datos
│   └── users.ibd              # Tabla de usuarios
├── mysql/                      # Base de datos del sistema
├── performance_schema/         # Esquema de performance
└── sys/                        # Vistas del sistema
```

**Ventajas del bind mount:**
- ✅ **Acceso directo**: Archivos visibles desde el host
- ✅ **Backup fácil**: Copiar directorio completo
- ✅ **Debugging**: Inspección directa de archivos
- ✅ **Migración**: Mover datos entre entornos

## 🛠️ Scripts de Utilidad

### `start.sh`
**Propósito**: Iniciar stack completo con verificaciones multi-servicio

**Funcionalidades avanzadas:**
- ✅ Verificación de ambos servicios (MySQL + phpMyAdmin)
- ✅ Creación automática del directorio `./data/`
- ✅ Tiempo de espera extendido (15 segundos) para MySQL
- ✅ Información completa de ambos servicios
- ✅ URLs de acceso tanto CLI como web

**Información mostrada:**
```
🌐 MySQL Server: localhost:3306
  🗄️  Base de datos: mydb
  👤 Usuario: admin
  
🌐 phpMyAdmin (Interfaz Web):
  🔗 URL: http://localhost:8081
  👤 Usuario: admin
  🔑 Contraseña: admin
```

### `stop.sh`
**Propósito**: Detener stack completo con verificación multi-servicio

**Funcionalidades:**
- ✅ Verificación de estado de ambos contenedores
- ✅ Detención coordinada con `docker-compose down`
- ✅ Verificación post-detención de ambos servicios

### `logs.sh`
**Propósito**: Sistema avanzado de logs con múltiples opciones

**Opciones disponibles:**
1. 🗄️ **Solo MySQL** - Logs del servidor de base de datos
2. 🌐 **Solo phpMyAdmin** - Logs de la interfaz web
3. 📊 **Ambos servicios** - Logs combinados con `docker-compose logs`

**Funcionalidades:**
- ✅ Menú interactivo para selección
- ✅ Logs en tiempo real para cada opción
- ✅ Verificación de existencia de cada contenedor

### `monitor.sh`
**Propósito**: Monitoreo avanzado para ambos servicios

**Información específica de MySQL:**
- 📊 **Estado de ambos contenedores**
- 💾 **Recursos de ambos servicios**
- 🌐 **Puertos de MySQL (3306) y phpMyAdmin (8081)**
- 💿 **Bind mounts y configuraciones**
- 📋 **Logs recientes de ambos servicios**

### `backup.sh` *(Pendiente de completar)*
**Propósito**: Backup avanzado para MySQL

**Características planificadas:**
- ✅ Backup lógico con `mysqldump`
- ✅ Backup físico del directorio `./data/`
- ✅ Backup de configuraciones personalizadas
- ✅ Compresión automática con timestamps

### `cleanup.sh` *(Pendiente de completar)*
**Propósito**: Limpieza avanzada para multi-servicio

**Opciones planificadas:**
- ✅ Limpiar logs de ambos contenedores
- ✅ Reiniciar stack completo
- ✅ Limpiar datos MySQL (mantener estructura)
- ✅ Eliminar directorio `./data/` (PELIGROSO)
- ✅ Eliminar todo (contenedores + redes + volúmenes)

### `connect.sh`
**Propósito**: Conexión directa al CLI de MySQL

**Funcionalidades específicas:**
- ✅ Conexión a base de datos `mydb` con usuario `admin`
- ✅ Credenciales automáticas desde `.env`
- ✅ Tips específicos de MySQL incluidos

**Comandos útiles mostrados:**
```
💡 Para salir escribe: exit
💡 Para ver tablas: SHOW TABLES;
💡 Para describir tabla: DESCRIBE nombre_tabla;
```

## 🌐 phpMyAdmin - Administración Web

### Acceso y Configuración
- **URL**: http://localhost:8081
- **Usuario**: admin (desde `.env`)
- **Contraseña**: admin (desde `.env`)

### Funcionalidades Disponibles
- ✅ **Gestión de bases de datos**: Crear, modificar, eliminar
- ✅ **Editor SQL**: Ejecutar consultas directamente
- ✅ **Gestión de usuarios**: Crear usuarios y permisos
- ✅ **Import/Export**: Backup y restauración vía web
- ✅ **Visualización de datos**: Navegación tabular
- ✅ **Monitoreo**: Estado del servidor y procesos

### Ventajas de la Interfaz Web
- 🎯 **Accesibilidad**: No requiere cliente específico
- 🔍 **Visual**: Navegación intuitiva de estructuras
- 📊 **Reportes**: Estadísticas y gráficos
- 🔧 **Administración**: Configuración sin comandos
- 📤 **Backup/Restore**: Interfaz gráfica para gestión de datos

## 🚀 Uso Avanzado

### 1. Configuración inicial
```bash
# Verificar todas las configuraciones
cat .env
cat conf.d/my.cnf
cat initdb/init.sql

# Iniciar stack completo
./start.sh
```

### 2. Acceso múltiple
```bash
# CLI directo
./connect.sh

# Interfaz web
# Navegar a: http://localhost:8081
```

### 3. Verificar funcionamiento
```bash
# Monitoreo completo
./monitor.sh

# Logs específicos
./logs.sh  # Seleccionar opción
```

### 4. Operaciones avanzadas
```bash
# Verificar red personalizada
docker network ls | grep mysql

# Ver comunicación interna
docker exec mysql_container ping phpmyadmin_container

# Backup (cuando esté implementado)
./backup.sh
```

## 🎯 Conceptos Docker Avanzados Aprendidos

Esta configuración avanzada enseña:

1. **Multi-servicio**: Orquestación de servicios relacionados
2. **Redes personalizadas**: Comunicación interna por nombre
3. **Bind mounts vs volúmenes**: Persistencia física vs lógica
4. **Dependencias**: `depends_on` para orden de arranque
5. **Variables de entorno compartidas**: Uso entre servicios
6. **Configuración personalizada**: Montaje de archivos de configuración
7. **Políticas de reinicio**: `always` para producción
8. **Gestión de puertos**: Múltiples servicios, múltiples puertos

## 🔄 Evolución de Complejidad

| Aspecto | MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|---------|----------------|-------------------------|------------------|
| **Servicios** | 1 (Solo BD) | 1 (Solo BD) | 2 (BD + Admin Web) |
| **Persistencia** | Volumen nombrado | Volumen nombrado | Bind mount físico |
| **Redes** | Default | Default | Personalizada |
| **Configuración** | Variables env | Variables env + init | Variables + config files + init |
| **Administración** | CLI externo | CLI externo | CLI + Web interface |
| **Dependencias** | Ninguna | Ninguna | phpMyAdmin → MySQL |
| **Restart Policy** | `no` | `no` | `always` |
| **Inicialización** | Manual | Automática | Automática + config |

## 🔧 Solución de Problemas

### Error: "phpMyAdmin cannot connect to MySQL"
- Verificar que ambos servicios estén en la misma red: `mysql_network`
- Verificar variable `PMA_HOST=mysql` (nombre del servicio)
- Revisar logs de phpMyAdmin: `./logs.sh` → opción 2

### Error: "Port 8081 already in use"
- Cambiar puerto de phpMyAdmin en `docker-compose.yml`: `"8082:80"`
- O detener otros servicios web locales

### Error: "Access denied for user"
- Verificar variables en `.env` (MYSQL_USER, MYSQL_PASSWORD)
- Verificar que `MYSQL_ROOT_PASSWORD` sea la misma para ambos servicios
- Usar modo debug: `./logs.sh` → opción 1

### Directorio data con permisos incorrectos
- El contenedor de MySQL crea archivos como usuario mysql (uid 999)
- Esto es normal, no cambiar permisos manualmente
- Para backup, usar `sudo` o scripts automáticos

### Error: "Authentication plugin 'caching_sha2_password'"
- Solucionado con: `--default-authentication-plugin=mysql_native_password`
- Para clientes que no soportan el nuevo plugin de MySQL 8.0

## 📚 Próximos Pasos

Después de dominar esta configuración avanzada:
1. 🌟 **Rama `pro`**: Configuraciones production-ready con monitoring
2. 🔄 **Replicación**: Master-slave setup
3. 🚀 **Load Balancing**: MySQL Router
4. 🔐 **Seguridad**: SSL/TLS y usuarios granulares
5. 📊 **Monitoring**: Prometheus + Grafana
6. 🧪 **Rama `experimental`**: Nuevas bases de datos (MongoDB, Redis)

## 🏆 Logros Desbloqueados

Al completar MySQL avanzado has aprendido:
- ✅ Orquestación de múltiples servicios
- ✅ Redes Docker personalizadas
- ✅ Persistencia con bind mounts
- ✅ Administración web integrada
- ✅ Configuración avanzada de servicios
- ✅ Gestión de dependencias entre contenedores

**¡Estás listo para configuraciones de producción!** 🚀