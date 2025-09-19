# 🗄️ Databases - Centro de Aprendizaje Docker

> **Configuraciones progresivas de bases de datos con Docker para dominar conceptos desde básico hasta avanzado**

## 📊 Visión General del Proyecto

Este directorio contiene **3 configuraciones de bases de datos** diseñadas para enseñar conceptos Docker de forma progresiva:

| Base de Datos | Nivel | Enfoque de Aprendizaje | Conceptos Clave |
|---------------|-------|------------------------|-----------------|
| **MSSQL** | 🟢 **Básico** | Fundamentos Docker | Contenedores, volúmenes, variables env |
| **PostgreSQL** | 🟡 **Intermedio** | Inicialización automática | Init scripts, backup, persistencia |
| **MySQL** | 🔴 **Avanzado** | Multi-servicio y redes | Networking, multi-container, web admin |

## 🎯 Filosofía de Aprendizaje

### **Progresión Educativa**
1. **Comenzar simple** → MSSQL para entender Docker básico
2. **Agregar complejidad** → PostgreSQL para scripts de inicialización  
3. **Dominar orquestación** → MySQL para múltiples servicios

### **Principios de Diseño**
- ✅ **Configuraciones reales**: Listas para desarrollo
- ✅ **Scripts uniformes**: Misma interfaz, diferentes implementaciones
- ✅ **Documentación completa**: Cada concepto explicado
- ✅ **Troubleshooting**: Problemas comunes y soluciones
- ✅ **Evolución clara**: Complejidad incremental visible

## 🛠️ Scripts de Utilidad Universales

Cada base de datos incluye **7 scripts estándar** con funcionalidades adaptadas a su nivel de complejidad:

### 1. `start.sh` - 🚀 **Iniciar servicios**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ Crear directorio data | ✅ Crear directorio data | ✅ Crear directorio data |
| ✅ Iniciar contenedor único | ✅ Iniciar con init scripts | ✅ Iniciar stack multi-servicio |
| ✅ Verificación básica | ✅ Verificación + logs init | ✅ Verificación MySQL + phpMyAdmin |
| ✅ Info de conexión | ✅ Info de conexión + datos | ✅ Info CLI + URL web |

**Comando:**
```bash
./start.sh
```

### 2. `stop.sh` - 🛑 **Detener servicios**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ Detener contenedor | ✅ Detener con docker-compose | ✅ Detener stack completo |
| ✅ Verificación post-stop | ✅ Verificación post-stop | ✅ Verificación multi-servicio |

**Comando:**
```bash
./stop.sh
```

### 3. `logs.sh` - 📋 **Ver registros**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ Logs simples | ✅ Logs con timestamps | ✅ Menú interactivo |
| ✅ Follow mode (-f) | ✅ Follow mode (-f) | ✅ MySQL, phpMyAdmin o ambos |
| - | ✅ Filtros de init | ✅ Logs en tiempo real |

**Comando:**
```bash
./logs.sh
```

### 4. `monitor.sh` - 📊 **Monitorear estado**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ Estado básico del contenedor | ✅ Estado + recursos | ✅ Estado multi-servicio |
| ✅ Información de puerto | ✅ Puerto + volúmenes | ✅ Puertos + red personalizada |
| ✅ Logs recientes | ✅ Logs + procesos | ✅ Logs de ambos servicios |

**Comando:**
```bash
./monitor.sh
```

### 5. `backup.sh` - 💾 **Realizar respaldos**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ Backup básico SQLCMD | ✅ Backup lógico (pg_dump) | ✅ Backup lógico (mysqldump) |
| ✅ Timestamp automático | ✅ Backup físico (directorio) | ✅ Backup físico (bind mount) |
| ✅ Compresión | ✅ Compresión avanzada | ✅ Backup configuraciones |

**Comando:**
```bash
./backup.sh
```

### 6. `cleanup.sh` - 🧹 **Limpiar recursos**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ Limpiar logs | ✅ Menú de opciones | ✅ Menú avanzado |
| ✅ Reiniciar contenedor | ✅ Reiniciar con datos/sin datos | ✅ Limpiar por servicio |
| ✅ Eliminar todo | ✅ Eliminación selectiva | ✅ Eliminar red personalizada |

**Comando:**
```bash
./cleanup.sh
```

### 7. `connect.sh` - 🔌 **Conectar al CLI**

| MSSQL (Básico) | PostgreSQL (Intermedio) | MySQL (Avanzado) |
|----------------|-------------------------|------------------|
| ✅ SQLCMD directo | ✅ psql con base específica | ✅ mysql con base específica |
| ✅ Tips básicos SQL Server | ✅ Tips PostgreSQL | ✅ Tips MySQL |
| ✅ Comandos de ayuda | ✅ Comandos de ayuda | ✅ Comandos de ayuda |

**Comando:**
```bash
./connect.sh
```

## 🎨 Características de los Scripts

### **Interfaz Visual Consistente**
Todos los scripts comparten:
- 🎨 **Colores uniformes**: Verde para éxito, rojo para error, azul para info
- 📝 **Mensajes claros**: Estados explicados en español
- ⚡ **Verificaciones inteligentes**: Estado antes de actuar
- 💡 **Tips útiles**: Comandos específicos de cada BD
- 🚨 **Manejo de errores**: Validaciones y fallbacks

### **Código de Ejemplo (Patrón start.sh)**
```bash
#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificación inteligente
if [ -f "docker-compose.yml" ]; then
    echo -e "${BLUE}🚀 Iniciando [Base de Datos]...${NC}"
    # Lógica específica por BD
else
    echo -e "${RED}❌ Error: docker-compose.yml no encontrado${NC}"
    exit 1
fi
```

## 📁 Estructura de Archivos por Base de Datos

### **Patrón Común**
```
[database]/
├── docker-compose.yml      # Configuración principal
├── .env                    # Variables de entorno
├── [config-dir]/          # Configuraciones específicas
├── [init-dir]/            # Scripts de inicialización
├── [data-dir]/            # Persistencia (generado)
└── scripts/               # 7 scripts de utilidad
    ├── start.sh
    ├── stop.sh
    ├── logs.sh
    ├── monitor.sh
    ├── backup.sh
    ├── cleanup.sh
    └── connect.sh
```

### **MSSQL - Configuración Básica**
```
mssql/
├── docker-compose.yml      # SQL Server 2022 básico
├── .env                    # Variables esenciales
├── data/                   # Volumen nombrado → directorio
├── start-mssql.sh         # Script simple start
├── stop-mssql.sh          # Script simple stop
└── README.md              # Documentación básica
```

### **PostgreSQL - Configuración Intermedia**
```
postgresql/
├── docker-compose.yml      # PostgreSQL 15 con init
├── .env                    # Variables completas
├── init/
│   └── init.sql           # Script de inicialización
├── data/                   # Volumen nombrado → directorio
└── README.md              # Documentación intermedia
```

### **MySQL - Configuración Avanzada**
```
mysql/
├── docker-compose.yml      # MySQL 8.0 + phpMyAdmin
├── .env                    # Variables compartidas
├── conf.d/
│   └── my.cnf             # Configuración personalizada
├── initdb/
│   └── init.sql           # Script de inicialización
├── data/                   # Bind mount físico
└── README.md              # Documentación avanzada
```

## 🚀 Guía de Uso Rápido

### **1. Elegir tu Nivel**
```bash
cd databases/

# Principiante en Docker
cd mssql/

# Tienes experiencia básica
cd postgresql/

# Quieres configuraciones avanzadas
cd mysql/
```

### **2. Iniciar Cualquier Base de Datos**
```bash
# Hacer scripts ejecutables (primera vez)
chmod +x *.sh

# Iniciar
./start.sh
```

### **3. Explorar Funcionalidades**
```bash
# Ver estado
./monitor.sh

# Ver logs
./logs.sh

# Conectar por CLI
./connect.sh

# Hacer backup
./backup.sh

# Limpiar cuando termines
./cleanup.sh

# Detener
./stop.sh
```

## 🎓 Ruta de Aprendizaje Recomendada

### **Fase 1: Fundamentos (MSSQL)**
**Objetivos:**
- [ ] Entender qué es un contenedor Docker
- [ ] Aprender docker-compose básico
- [ ] Familiarizarse con volúmenes
- [ ] Practicar comandos básicos

**Actividades:**
1. Analizar `docker-compose.yml` línea por línea
2. Ejecutar todos los scripts y ver qué hacen
3. Conectar con SQL Server Management Studio externo
4. Hacer backup y restore básico

### **Fase 2: Conceptos Intermedios (PostgreSQL)**
**Objetivos:**
- [ ] Entender scripts de inicialización
- [ ] Aprender estrategias de backup
- [ ] Familiarizarse con logs y debugging
- [ ] Configurar conexiones externas

**Actividades:**
1. Modificar `init.sql` con tus propias tablas
2. Comparar backup lógico vs físico
3. Configurar pgAdmin externo
4. Experimentar con diferentes versiones de PostgreSQL

### **Fase 3: Configuraciones Avanzadas (MySQL)**
**Objetivos:**
- [ ] Dominar multi-servicio con docker-compose
- [ ] Entender redes Docker personalizadas
- [ ] Configurar bind mounts vs volúmenes
- [ ] Integrar interfaces web

**Actividades:**
1. Analizar comunicación entre MySQL y phpMyAdmin
2. Experimentar con configuraciones de `my.cnf`
3. Configurar SSL/TLS (rama experimental)
4. Agregar servicios adicionales (Redis, etc.)

## 🌟 Conceptos Docker Enseñados

### **Por Configuración**

| Concepto | MSSQL | PostgreSQL | MySQL |
|----------|-------|------------|-------|
| **Contenedores básicos** | ✅ | ✅ | ✅ |
| **docker-compose** | ✅ | ✅ | ✅ |
| **Variables de entorno** | ✅ | ✅ | ✅ |
| **Volúmenes nombrados** | ✅ | ✅ | - |
| **Bind mounts** | - | - | ✅ |
| **Scripts de init** | - | ✅ | ✅ |
| **Multi-servicio** | - | - | ✅ |
| **Redes personalizadas** | - | - | ✅ |
| **Dependencias** | - | - | ✅ |
| **Restart policies** | - | - | ✅ |
| **Configuración externa** | - | - | ✅ |
| **Interfaces web** | - | - | ✅ |

### **Progresión de Complejidad**

```
BÁSICO (MSSQL)
├── Un contenedor
├── Variables simples
├── Volumen básico
└── Puerto único

INTERMEDIO (PostgreSQL)  
├── Un contenedor
├── Variables + inicialización
├── Volumen + scripts
└── Puerto + datos automáticos

AVANZADO (MySQL)
├── Múltiples contenedores
├── Variables compartidas
├── Bind mounts + configuración
├── Múltiples puertos
├── Red personalizada
└── Dependencias entre servicios
```

## 🔧 Herramientas de Desarrollo

### **Línea de Comandos**
Cada configuración te enseña comandos específicos:

```bash
# MSSQL
sqlcmd -S localhost -U sa -P 'YourPassword'

# PostgreSQL  
psql -h localhost -U admin -d mydb

# MySQL
mysql -h localhost -u admin -p mydb
```

### **Interfaces Gráficas**
- **MSSQL**: SQL Server Management Studio, Azure Data Studio
- **PostgreSQL**: pgAdmin, DBeaver
- **MySQL**: phpMyAdmin (incluido), MySQL Workbench

### **Docker Commands Útiles**
```bash
# Ver todos los contenedores
docker ps -a

# Ver logs de un contenedor específico
docker logs [container_name]

# Ejecutar comandos dentro del contenedor
docker exec -it [container_name] bash

# Ver uso de recursos
docker stats

# Ver redes
docker network ls

# Ver volúmenes
docker volume ls
```

## 🚀 Estrategias Git para Experimentación

### **Rama `main`** - Configuraciones estables
- ✅ Configuraciones probadas y documentadas
- ✅ Scripts funcionales para desarrollo
- ✅ Documentación completa

### **Rama `pro`** - Configuraciones de producción
- 🔒 SSL/TLS configurado
- 📊 Monitoring con Prometheus/Grafana
- 🛡️ Seguridad hardening
- 🔄 Replicación y alta disponibilidad

### **Rama `experimental`** - Nuevas tecnologías
- 🧪 Nuevas bases de datos (MongoDB, Redis, Cassandra)
- 🌐 Configuraciones de microservicios
- ☁️ Integraciones cloud
- 🤖 Automatización con CI/CD

### **Flujo de Trabajo Recomendado**
```bash
# Empezar en main
git checkout main

# Experimentar con nuevas features
git checkout -b feature/nueva-bd

# Cambios estables van a main
git checkout main
git merge feature/nueva-bd

# Configuraciones production-ready van a pro
git checkout pro
git merge main
```

## 📊 Métricas de Aprendizaje

### **Checkpoints de Progreso**

**Nivel Básico Completado** ✅
- [ ] Puedes iniciar/detener contenedores
- [ ] Entiendes variables de entorno
- [ ] Sabes conectar desde aplicaciones externas
- [ ] Puedes hacer backup básico

**Nivel Intermedio Completado** ✅
- [ ] Configuras scripts de inicialización
- [ ] Entiendes diferencias entre tipos de backup
- [ ] Puedes debuggear problemas con logs
- [ ] Configuras persistencia correctamente

**Nivel Avanzado Completado** ✅
- [ ] Orquestas múltiples servicios
- [ ] Configuras redes personalizadas
- [ ] Integras interfaces web
- [ ] Optimizas configuraciones para producción

## 🏆 Objetivos de Aprendizaje Final

Al completar todas las configuraciones habrás aprendido:

### **Conceptos Docker Fundamentales**
- ✅ **Contenedores**: Aislamiento y portabilidad
- ✅ **Imágenes**: Capas y optimización
- ✅ **Volúmenes**: Persistencia de datos
- ✅ **Redes**: Comunicación entre servicios
- ✅ **docker-compose**: Orquestación de servicios

### **Habilidades de Administración**
- ✅ **Backup/Restore**: Estrategias para diferentes tipos de datos
- ✅ **Monitoring**: Observabilidad y troubleshooting
- ✅ **Configuración**: Personalización de servicios
- ✅ **Seguridad**: Buenas prácticas básicas
- ✅ **Automatización**: Scripts para operaciones repetitivas

### **Preparación para Producción**
- ✅ **Escalabilidad**: Múltiples instancias y load balancing
- ✅ **Alta Disponibilidad**: Replicación y failover
- ✅ **Monitoring Avanzado**: Métricas y alertas
- ✅ **CI/CD**: Integración con pipelines de deployment
- ✅ **Cloud**: Migración a AWS/Azure/GCP

## 🚀 Próximos Pasos

### **Después de completar las 3 configuraciones:**

1. **🌟 Migrar a rama `pro`**: Configuraciones production-ready
2. **📊 Implementar monitoring**: Prometheus + Grafana stack
3. **🔒 Configurar seguridad**: SSL, usuarios granulares, network policies
4. **☁️ Experimentar con cloud**: RDS, CloudSQL, Azure Database
5. **🤖 Automatizar deployment**: GitHub Actions, Docker Hub
6. **🧪 Explorar nuevas BDs**: MongoDB, Redis, Elasticsearch

### **Recursos Adicionales**
- 📚 **Documentación Docker**: docker.com/docs
- 🎓 **Docker Courses**: docker.com/courses  
- 🌐 **Best Practices**: docs.docker.com/best-practices
- 👥 **Community**: docker.com/community

---

## 🎯 **¡Felicidades!**

Has completado un centro de aprendizaje completo para bases de datos con Docker. Estas configuraciones te han dado:

- ✅ **Base sólida** en Docker y docker-compose
- ✅ **Experiencia práctica** con 3 bases de datos diferentes  
- ✅ **Scripts reusables** para proyectos futuros
- ✅ **Comprensión progresiva** de conceptos avanzados
- ✅ **Preparación** para configuraciones de producción

**¡Estás listo para llevar tus aplicaciones al siguiente nivel con Docker!** 🚀

---

*Última actualización: Configuraciones completadas - MSSQL ✅ PostgreSQL ✅ MySQL ✅*