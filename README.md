# 🐳 Redis Docker - Redis + RedisInsight con Docker

Este proyecto proporciona una **solución completa de Redis con Docker** que incluye Redis y RedisInsight, con **pipeline automático de instalación de Docker** y **scripts de automatización**.

## 🎯 Características Principales

- **Redis 7.0**: Base de datos en memoria de última generación
- **RedisInsight**: Panel de gestión web en http://localhost:8001
- **Prometheus**: Monitoreo y métricas en http://localhost:9090
- **Grafana**: Dashboards y visualización en http://localhost:3000
- **Clustering Opcional**: Redis Cluster configurable
- **Docker Compose**: Orquestación de contenedores
- **Pipeline Automático**: Instalación automática de Docker
- **Scripts de Automatización**: Start, stop, verify, backup
- **Configuración Optimizada**: Para desarrollo y producción
- **Datos de Ejemplo**: Incluye datos de prueba

## 🏗️ Arquitectura del Proyecto

```
┌─────────────────────────────────────────────────────────────┐
│                    Redis Docker                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │     Redis       │  │  RedisInsight   │  │   Redis     │ │
│  │    Master       │  │   Web Panel     │  │   Cluster   │ │
│  │  Port: 6379     │  │   Port: 8001    │  │Port: 6380   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
│           │                     │                   │       │
│  ┌────────▼─────────┐  ┌────────▼─────────┐  ┌────▼─────┐ │
│  │   Prometheus     │  │   Grafana        │  │ Docker   │ │
│  │   Monitoring     │  │   Dashboards     │  │ Compose  │ │
│  │   Port: 9090     │  │   Port: 3000     │  │          │ │
│  └──────────────────┘  └──────────────────┘  └──────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Estructura del Proyecto

```
redis-docker/
├── docker/                          # Configuraciones Docker
│   ├── Dockerfile.redis            # Imagen Redis personalizada
│   ├── Dockerfile.redisinsight      # Imagen RedisInsight personalizada
│   ├── redis.conf                   # Configuración Redis
│   └── init-scripts/               # Scripts de inicialización
│       └── 01-create-sample-data.sh # Crear datos de ejemplo
├── monitoring/                     # Configuración de monitoreo
│   ├── prometheus/                 # Configuración Prometheus
│   │   ├── prometheus.yml          # Configuración principal
│   │   └── rules/                  # Reglas de alertas
│   └── grafana/                    # Configuración Grafana
│       ├── datasources.yml         # Fuentes de datos
│       └── dashboards/             # Dashboards predefinidos
├── scripts/                        # Scripts de automatización
│   ├── start.sh                    # Iniciar servicios básicos
│   ├── start-with-monitoring.sh    # Iniciar con monitoreo
│   ├── start-with-clustering.sh    # Iniciar con clustering
│   ├── stop.sh                     # Parar servicios
│   └── verify.sh                   # Verificar funcionamiento
├── pipeline/                       # Pipeline de instalación
│   └── install-docker.sh           # Instalar Docker automáticamente
├── examples/                       # Ejemplos de aplicaciones
│   └── python-flask/               # Ejemplo Flask con Redis
├── docs/                           # Documentación
├── docker-compose.yml              # Orquestación de servicios
├── config.yml                      # Configuración del proyecto
├── env.example                     # Variables de entorno
├── Makefile                        # Comandos de automatización
└── README.md                       # Este archivo
```

## 🚀 Inicio Rápido

### **1. Instalar Docker (Automático)**
```bash
make install
```

### **2. Iniciar Servicios Básicos**
```bash
make start
```

### **3. Verificar Funcionamiento**
```bash
make verify
```

### **4. Acceder a RedisInsight**
- **URL**: http://localhost:8001
- **Usuario**: default
- **Contraseña**: redis123

## 🛠️ Comandos Disponibles

### **Comandos Principales**
```bash
make install        # Instalar Docker automáticamente
make start          # Iniciar servicios básicos (Redis + RedisInsight)
make start-monitoring # Iniciar con monitoreo (Prometheus + Grafana)
make start-clustering # Iniciar con clustering
make start-full     # Iniciar todo (Redis + Cluster + Monitoreo)
make stop           # Parar servicios
make restart        # Reiniciar servicios
make status         # Ver estado
make logs           # Ver logs
make verify         # Verificar funcionamiento
make clean          # Limpiar recursos
```

### **Comandos de Monitoreo**
```bash
make monitoring-start    # Iniciar servicios de monitoreo
make monitoring-stop     # Parar servicios de monitoreo
make monitoring-status   # Estado de servicios de monitoreo
make monitoring-logs     # Logs de servicios de monitoreo
make prometheus-open     # Abrir Prometheus
make grafana-open       # Abrir Grafana
```

### **Comandos de Clustering**
```bash
make clustering-start      # Iniciar servicios de clustering
make clustering-stop        # Parar servicios de clustering
make clustering-status     # Estado de servicios de clustering
make redis-cluster-info    # Información del cluster
make redis-cluster-nodes  # Nodos del cluster
```

### **Comandos de Desarrollo**
```bash
make dev-start      # Modo desarrollo
make dev-stop       # Parar desarrollo
make redis-connect  # Conectar a Redis
make redisinsight-open # Abrir RedisInsight
```

### **Comandos de Redis**
```bash
make redis-info     # Información de Redis
make redis-memory   # Uso de memoria
make redis-clients  # Clientes conectados
make redis-keys     # Listar claves
make redis-dbsize   # Tamaño de base de datos
make redis-ping     # Ping a Redis
make redis-flushall # Limpiar todas las claves
make redis-flushdb  # Limpiar base de datos actual
```

## 🔧 Configuración

### **Variables de Entorno**
```bash
# Copiar archivo de ejemplo
cp env.example .env

# Editar configuración
nano .env
```

### **Configuración Avanzada**
```bash
# Editar configuración YAML
nano config.yml

# Configurar monitoreo
PROMETHEUS_ENABLED=true
GRAFANA_ENABLED=true

# Configurar clustering
CLUSTERING_ENABLED=true
```

## 📊 Monitoreo

### **Prometheus**
- **URL**: http://localhost:9090
- **Métricas**: Redis, sistema, contenedores
- **Alertas**: Configuradas automáticamente

### **Grafana**
- **URL**: http://localhost:3000
- **Usuario**: admin
- **Contraseña**: admin123
- **Dashboards**: Redis predefinidos

## 🔄 Clustering

### **Configuración**
- **Master**: localhost:6379
- **Cluster**: localhost:6380
- **Modo**: Cluster o Sentinel
- **Nodos**: Configurables

### **Verificación**
```bash
# Información del cluster
make redis-cluster-info

# Nodos del cluster
make redis-cluster-nodes
```

## 🗄️ Datos de Ejemplo Incluidos

- **Usuarios**: 3 usuarios de ejemplo
- **Productos**: 3 productos de ejemplo
- **Sesiones**: Sesiones activas
- **Contadores**: Contadores de visitas
- **Listas**: Listas de usuarios y productos
- **Sets**: Tags y categorías
- **Sorted Sets**: Leaderboards

## 👥 Tipos de Datos Redis

- **Strings**: Valores simples
- **Hashes**: Objetos estructurados
- **Lists**: Listas ordenadas
- **Sets**: Conjuntos únicos
- **Sorted Sets**: Conjuntos ordenados
- **Streams**: Flujos de datos

## 🔒 Seguridad

- **Contraseñas**: Configurables por variables
- **Red**: Red Docker aislada
- **Comandos**: Comandos peligrosos deshabilitados
- **Autenticación**: Por contraseña

## 🚀 Despliegue en Producción

### **Variables de Producción**
```bash
# Configurar para producción
ENVIRONMENT=production
REDIS_PASSWORD=your-secure-password
```

### **Monitoreo en Producción**
```bash
# Habilitar monitoreo completo
PROMETHEUS_ENABLED=true
GRAFANA_ENABLED=true
```

## 🐛 Solución de Problemas

### **Verificar Servicios**
```bash
make status
make logs
make health
```

### **Reiniciar Servicios**
```bash
make restart
make stop
make start
```

### **Limpiar Recursos**
```bash
make clean
make clean-all
```

## 📚 Documentación Adicional

- [Configuración Redis](docs/redis-config.md)
- [Monitoreo con Prometheus](docs/monitoring.md)
- [Clustering Redis](docs/clustering.md)
- [Despliegue en Producción](docs/production.md)

## 🤝 Contribuir

1. Fork el proyecto
2. Crear rama para feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 🆘 Soporte

Si tienes problemas o preguntas:

1. Revisar la documentación
2. Verificar logs: `make logs`
3. Verificar estado: `make status`
4. Crear issue en GitHub

---

**¡Disfruta usando Redis con Docker!** 🐳🔴
