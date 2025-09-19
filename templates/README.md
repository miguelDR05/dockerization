# Templates y Scripts Reutilizables

Esta carpeta contiene plantillas y scripts que se pueden reutilizar across diferentes herramientas del proyecto.

## 📁 Estructura

```
templates/
├── scripts/           # Scripts bash reutilizables
│   ├── start.sh      # Template para iniciar servicios
│   ├── stop.sh       # Template para detener servicios
│   ├── backup.sh     # Template para backups
│   └── health.sh     # Template para health checks
├── configs/          # Configuraciones base
│   ├── .env.template # Variables de entorno comunes
│   └── logging.conf  # Configuración de logs
└── compose-templates/ # Plantillas de docker-compose
    ├── basic.yml     # Configuración básica
    ├── with-admin.yml # Con herramienta de administración
    └── production.yml # Para producción
```

## 🎯 Cómo usar

1. Copia el template que necesites
2. Personaliza las variables específicas de tu herramienta
3. Adapta los paths y nombres según corresponda

## 📝 Convenciones

- Variables en MAYÚSCULAS: `${SERVICE_NAME}`
- Nombres descriptivos: `mysql_container` no `container1`
- Comentarios explicativos en archivos complejos
- Separación clara entre configuración y datos