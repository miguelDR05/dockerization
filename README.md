# 🐳 Dockerization

> **Una colección completa de configuraciones Docker para herramientas de desarrollo**

## 🎯 Objetivo del Proyecto

Este repositorio contiene configuraciones Docker ready-to-use para múltiples herramientas de desarrollo, organizadas de manera educativa y progresiva. Perfecto para aprender Docker o para levantar rápidamente entornos de desarrollo.

## 📁 Estructura del Proyecto

```
📦 dockerization/
├── 🗄️ databases/           # Sistemas de gestión de bases de datos
│   ├── mysql/              # MySQL 8.0 + phpMyAdmin (Avanzado)
│   ├── postgresql/         # PostgreSQL 15 (Intermedio)
│   └── mssql/              # SQL Server 2022 (Básico)
│
├── 🔧 development-tools/    # Herramientas de desarrollo
│   ├── ide/                # IDEs y editores web
│   ├── version-control/    # Git, GitLab, etc.
│   └── database-tools/     # Administradores de BD
│
├── 🚀 runtimes/            # Entornos de ejecución
│   ├── node/               # Node.js + npm/yarn
│   ├── python/             # Python + pip
│   ├── java/               # OpenJDK + Maven
│   └── php/                # PHP + Composer
│
├── 🌐 frameworks/          # Frameworks completos
│   ├── laravel/            # Laravel + MySQL
│   ├── django/             # Django + PostgreSQL
│   └── express/            # Express.js + MongoDB
│
└── 📚 templates/           # Plantillas reutilizables
    ├── scripts/            # Scripts de automatización
    ├── configs/            # Configuraciones base
    └── compose-templates/  # Templates de docker-compose
```

## 🌿 Versiones del Proyecto

### 🎓 **Rama `main` (actual)** - Versión Educativa
- ✅ Configuraciones progresivas (básico → intermedio → avanzado)
- ✅ Perfecta para aprender Docker paso a paso
- ✅ Comentarios explicativos en todos los archivos
- ✅ Ejemplos simples y claros

### 🚀 **Rama [`pro`](../../tree/pro)** - Versión Profesional
- ✅ Configuraciones production-ready
- ✅ Todas las herramientas con administración web
- ✅ Persistencia, backups y monitoring
- ✅ Scripts de automatización completos
- ✅ Templates reutilizables

### 🧪 **Rama [`experimental`](../../tree/experimental)** - Nuevas Herramientas
- ✅ Últimas versiones y tecnologías emergentes
- ✅ Configuraciones en desarrollo
- ✅ Pruebas de concepto

## 🚀 Inicio Rápido

### 1. Clonar el repositorio
```bash
git clone https://github.com/miguelDR05/dockerization.git
cd dockerization
```

### 2. Elegir una herramienta
```bash
# Ejemplo: MySQL con phpMyAdmin
   - Docker Compose básico
   - Variables de entorno
   - Puertos y conexiones

2. **PostgreSQL** (`databases/postgresql/`) - Conceptos intermedios
   - Volúmenes persistentes
   - Scripts de inicialización
   - Gestión de datos

3. **MySQL** (`databases/mysql/`) - Configuración avanzada
   - Múltiples servicios
   - Redes personalizadas
   - Herramientas de administración
   - Configuraciones personalizadas

## 🛠️ Características por Categoría

### 🗄️ **Databases**
- ✅ Sistemas populares: MySQL, PostgreSQL, SQL Server
- ✅ Herramientas de administración incluidas
- ✅ Scripts de inicialización con datos de prueba
- ✅ Configuraciones optimizadas para desarrollo

### 🔧 **Development Tools**
- ✅ IDEs web (VS Code Server, Theia)
- ✅ Control de versiones (GitLab CE, Gitea)
- ✅ Administradores de BD independientes

### 🚀 **Runtimes**
- ✅ Entornos de desarrollo completos
- ✅ Gestores de paquetes incluidos
- ✅ Configuraciones multi-versión

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-herramienta`)
3. Commit tus cambios (`git commit -m 'feat: add nueva-herramienta'`)
4. Push a la rama (`git push origin feature/nueva-herramienta`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 🏷️ Tags

`docker` `docker-compose` `development` `database` `mysql` `postgresql` `sqlserver` `devops` `containers` `learning`

---

**⭐ Si este proyecto te ayuda, no olvides darle una estrella en GitHub**
```

### 3. Levantar los servicios
```bash
docker-compose up -d
```

### 4. Acceder a la herramienta
- **Base de datos**: `localhost:3306`
- **phpMyAdmin**: `http://localhost:8081`

## 📚 Guías de Aprendizaje

### 🎯 **Progresión Recomendada para Principiantes:**

1. **MSSQL** (`databases/mssql/`) - Aprende conceptos básicos
- **MySQL** - Configuración completa con phpMyAdmin y networking
- **PostgreSQL** - Setup intermedio con inicialización automática  
- **SQL Server** - Configuración básica lista para usar

### 🔧 Herramientas de Desarrollo *(Próximamente)*
- **IDEs**: VS Code Server, Theia, Jupyter Lab
- **Control de Versiones**: Gitea, GitLab CE, GitHub Actions
- **Administración**: phpMyAdmin, pgAdmin, MongoDB Compass

### 🚀 Runtimes *(Próximamente)*
- **Node.js** - Diferentes versiones y configuraciones
- **Python** - Con pip, conda y entornos virtuales
- **Java** - OpenJDK y Oracle, diferentes versiones
- **PHP** - Con Apache/Nginx y extensiones

### 🌐 Frameworks *(Próximamente)*
- **Laravel** - PHP framework con todas las dependencias
- **Django** - Python web framework completo
- **Express** - Node.js minimalista y completo
- **Spring Boot** - Java enterprise ready

## 🌿 Ramas del Proyecto

- **`main`** - Versión educativa con progresión gradual
- **`pro`** - Configuraciones production-ready de todas las herramientas
- **`experimental`** - Nuevas herramientas en desarrollo

## 🎯 Filosofía del Proyecto

Cada herramienta se implementa siguiendo una progresión educativa:
1. **Básico** - Configuración mínima funcional
2. **Intermedio** - Agregando persistencia y automatización
3. **Avanzado** - Configuración completa con todas las características

## 🚀 Cómo usar

1. **Para aprender**: Explora la rama `main` y sigue la evolución
2. **Para usar en proyectos**: Ve a la rama `pro` y copia las configuraciones
3. **Para contribuir**: Usa la rama `experimental` para nuevas herramientas

## 📚 Comenzar

```bash
# Clonar el repositorio
git clone https://github.com/miguelDR05/dockerization.git
cd dockerization

# Ver versión educativa (por defecto)
git checkout main

# Ver versión profesional
git checkout pro

# Ejecutar cualquier herramienta
cd databases/mysql
docker-compose up -d
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! 
- Nuevas herramientas van en la rama `experimental`
- Mejoras a configuraciones existentes en `main` o `pro`
- Documentación y tutoriales siempre apreciados

## 📄 Licencia

MIT License - ve [LICENSE](LICENSE) para más detalles.

---

**¿Quieres aprender Docker de forma práctica? ¡Este es tu lugar!** 🐳