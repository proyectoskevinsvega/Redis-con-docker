# Redis Docker Makefile
# Comandos para gestionar Redis + RedisInsight + Monitoreo

# Variables por defecto
COMPOSE_CMD := $(shell command -v docker-compose >/dev/null 2>&1 && echo "docker-compose" || echo "docker compose")
ENVIRONMENT := development

help:
	@echo "🐳 Redis Docker - Comandos Disponibles"
	@echo "====================================="
	@echo "make install        - Instalar Docker automáticamente"
	@echo "make start          - Iniciar Redis + RedisInsight"
	@echo "make start-monitoring - Iniciar con Prometheus + Grafana"
	@echo "make start-clustering - Iniciar con clustering"
	@echo "make start-full     - Iniciar todo (Redis + Cluster + Monitoreo)"
	@echo "make stop           - Parar servicios"
	@echo "make restart        - Reiniciar servicios"
	@echo "make status         - Ver estado de servicios"
	@echo "make logs           - Ver logs de servicios"
	@echo "make build          - Construir imágenes"
	@echo "make verify         - Verificar funcionamiento"
	@echo "make clean          - Limpiar recursos"
	@echo "make clean-all      - Limpiar todo (volúmenes + imágenes)"
	@echo ""
	@echo "Variables:"
	@echo "  ENVIRONMENT=development|staging|production"
	@echo "  COMPOSE_CMD=docker-compose|docker compose"
	@echo "  PROMETHEUS_ENABLED=true|false"
	@echo "  GRAFANA_ENABLED=true|false"
	@echo "  CLUSTERING_ENABLED=true|false"

# Instalar Docker
install:
	@echo "🔧 Instalando Docker..."
	@./pipeline/install-docker.sh

# Iniciar servicios básicos
start:
	@echo "🚀 Iniciando Redis + RedisInsight..."
	@./scripts/start.sh

# Iniciar con monitoreo
start-monitoring:
	@echo "📊 Iniciando Redis + RedisInsight + Prometheus + Grafana..."
	@./scripts/start-with-monitoring.sh

# Iniciar con clustering
start-clustering:
	@echo "🔄 Iniciando Redis con clustering..."
	@./scripts/start-with-clustering.sh

# Iniciar todo (básico + clustering + monitoreo)
start-full:
	@echo "🚀 Iniciando todo (Redis + Cluster + Monitoreo)..."
	@./scripts/start-with-clustering.sh

# Parar servicios
stop:
	@echo "🛑 Parando servicios..."
	@$(COMPOSE_CMD) down

# Reiniciar servicios
restart:
	@echo "🔄 Reiniciando servicios..."
	@$(COMPOSE_CMD) restart

# Ver estado de servicios
status:
	@echo "📊 Estado de servicios:"
	@$(COMPOSE_CMD) ps

# Ver logs de servicios
logs:
	@echo "📋 Logs de servicios:"
	@$(COMPOSE_CMD) logs -f

# Construir imágenes
build:
	@echo "🔨 Construyendo imágenes..."
	@$(COMPOSE_CMD) build

# Verificar funcionamiento
verify:
	@echo "✅ Verificando funcionamiento..."
	@./scripts/verify.sh

# Limpiar recursos
clean:
	@echo "🧹 Limpiando recursos..."
	@$(COMPOSE_CMD) down -v
	@docker system prune -f

# Limpiar todo
clean-all:
	@echo "🧹 Limpiando todo..."
	@$(COMPOSE_CMD) down -v --rmi all
	@docker system prune -af

# Comandos de Redis
redis-connect:
	@echo "🔌 Conectando a Redis..."
	@docker exec -it redis-db redis-cli -a redis123

redis-shell:
	@echo "🐚 Abriendo shell de Redis..."
	@docker exec -it redis-db bash

# Comandos de RedisInsight
redisinsight-open:
	@echo "🌐 Abriendo RedisInsight..."
	@echo "URL: http://localhost:8001"
	@echo "Usuario: default"
	@echo "Contraseña: redis123"

# Comandos de monitoreo
monitoring-start:
	@echo "📊 Iniciando servicios de monitoreo..."
	@$(COMPOSE_CMD) --profile monitoring up -d

monitoring-stop:
	@echo "📊 Parando servicios de monitoreo..."
	@$(COMPOSE_CMD) --profile monitoring down

monitoring-status:
	@echo "📊 Estado de servicios de monitoreo:"
	@$(COMPOSE_CMD) --profile monitoring ps

monitoring-logs:
	@echo "📊 Logs de servicios de monitoreo:"
	@$(COMPOSE_CMD) --profile monitoring logs -f

# Comandos de Prometheus
prometheus-open:
	@echo "📈 Abriendo Prometheus..."
	@echo "URL: http://localhost:9090"
	@echo "Métricas: http://localhost:9090/metrics"

# Comandos de Grafana
grafana-open:
	@echo "📊 Abriendo Grafana..."
	@echo "URL: http://localhost:3000"
	@echo "Usuario: admin"
	@echo "Contraseña: admin123"

# Comandos de clustering
clustering-start:
	@echo "🔄 Iniciando servicios de clustering..."
	@$(COMPOSE_CMD) --profile clustering up -d

clustering-stop:
	@echo "🔄 Parando servicios de clustering..."
	@$(COMPOSE_CMD) --profile clustering down

clustering-status:
	@echo "🔄 Estado de servicios de clustering:"
	@$(COMPOSE_CMD) --profile clustering ps

# Comandos de Redis Cluster
redis-cluster-info:
	@echo "🔄 Información del cluster:"
	@docker exec redis-db redis-cli -a redis123 cluster info

redis-cluster-nodes:
	@echo "🔄 Nodos del cluster:"
	@docker exec redis-db redis-cli -a redis123 cluster nodes

# Comandos de desarrollo
dev-start:
	@echo "🚀 Iniciando en modo desarrollo..."
	@ENVIRONMENT=development $(COMPOSE_CMD) up -d

dev-stop:
	@echo "🛑 Parando modo desarrollo..."
	@$(COMPOSE_CMD) down

# Comandos de Redis
redis-info:
	@echo "ℹ️ Información de Redis:"
	@docker exec redis-db redis-cli -a redis123 info

redis-memory:
	@echo "💾 Uso de memoria:"
	@docker exec redis-db redis-cli -a redis123 info memory

redis-clients:
	@echo "👥 Clientes conectados:"
	@docker exec redis-db redis-cli -a redis123 info clients

redis-keys:
	@echo "🔑 Claves en Redis:"
	@docker exec redis-db redis-cli -a redis123 keys "*"

redis-dbsize:
	@echo "📊 Tamaño de base de datos:"
	@docker exec redis-db redis-cli -a redis123 dbsize

redis-ping:
	@echo "🏥 Ping a Redis:"
	@docker exec redis-db redis-cli -a redis123 ping

redis-flushall:
	@echo "🧹 Limpiando todas las claves:"
	@docker exec redis-db redis-cli -a redis123 flushall

redis-flushdb:
	@echo "🧹 Limpiando base de datos actual:"
	@docker exec redis-db redis-cli -a redis123 flushdb

# Comandos de backup
backup:
	@echo "💾 Creando backup de Redis..."
	@docker exec redis-db redis-cli -a redis123 --rdb /data/backup.rdb

restore:
	@echo "🔄 Restaurando backup de Redis..."
	@docker exec redis-db redis-cli -a redis123 --rdb /data/backup.rdb

# Comandos de estadísticas
stats:
	@echo "📊 Estadísticas de Redis:"
	@docker exec redis-db redis-cli -a redis123 info stats

# Comandos de red
network-ls:
	@echo "🌐 Listando redes Docker..."
	@docker network ls

network-inspect:
	@echo "🔍 Inspeccionando red redis_network..."
	@docker network inspect redis_network

# Comandos de volúmenes
volume-ls:
	@echo "💾 Listando volúmenes Docker..."
	@docker volume ls

volume-inspect:
	@echo "🔍 Inspeccionando volúmenes Redis..."
	@docker volume inspect redis-docker_redis_data

# Comandos de imágenes
image-ls:
	@echo "🖼️ Listando imágenes Docker..."
	@docker images | grep redis

# Comandos de contenedores
container-ls:
	@echo "📦 Listando contenedores Docker..."
	@docker ps -a | grep redis

# Comandos de salud
health:
	@echo "🏥 Salud de Redis..."
	@docker exec redis-db redis-cli -a redis123 ping

# Comandos de versión
version:
	@echo "📋 Versión de Redis..."
	@docker exec redis-db redis-cli -a redis123 --version

# Comandos de ayuda
help-redis:
	@echo "📋 Ayuda de Redis..."
	@docker exec redis-db redis-cli -a redis123 --help

# Comandos de información
info:
	@echo "ℹ️ Información del sistema..."
	@echo "Docker Compose: $(COMPOSE_CMD)"
	@echo "Entorno: $(ENVIRONMENT)"
	@echo "Servicios:"
	@$(COMPOSE_CMD) ps
