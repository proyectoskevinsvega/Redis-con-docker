#!/bin/bash

# 🚀 Redis Docker - Start Script
# Script para iniciar Redis + RedisInsight

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] ✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] ⚠️  $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ❌ $1${NC}"
}

info() {
    echo -e "${CYAN}[$(date +'%Y-%m-%d %H:%M:%S')] ℹ️  $1${NC}"
}

# Función para verificar si Docker Compose está disponible
check_docker_compose() {
    if ! command -v docker-compose >/dev/null 2>&1; then
        if ! docker compose version >/dev/null 2>&1; then
            error "Docker Compose no está disponible"
            exit 1
        fi
        COMPOSE_CMD="docker compose"
    else
        COMPOSE_CMD="docker-compose"
    fi
}

# Función para crear archivo .env si no existe
create_env_file() {
    if [ ! -f .env ]; then
        log "Creando archivo .env desde env.example..."
        cp env.example .env
        success "Archivo .env creado"
    else
        info "Archivo .env ya existe"
    fi
}

# Función para iniciar servicios
start_services() {
    log "Iniciando Redis + RedisInsight..."
    
    $COMPOSE_CMD up -d redis redisinsight
    
    success "Servicios iniciados"
}

# Función para verificar servicios
check_services() {
    log "Verificando servicios..."
    
    # Esperar a que Redis esté listo
    log "Esperando a que Redis esté listo..."
    timeout 60 bash -c 'until docker exec redis-db redis-cli -a redis123 ping >/dev/null 2>&1; do sleep 2; done'
    
    # Esperar a que RedisInsight esté listo
    log "Esperando a que RedisInsight esté listo..."
    timeout 60 bash -c 'until curl -f http://localhost:8001/health >/dev/null 2>&1; do sleep 2; done'
    
    success "Todos los servicios están funcionando"
}

# Función para mostrar información de conexión
show_connection_info() {
    echo ""
    success "🎉 Redis + RedisInsight están funcionando!"
    echo ""
    info "📋 Información de conexión:"
    echo "  Redis:"
    echo "    Host: localhost"
    echo "    Puerto: 6379"
    echo "    Contraseña: redis123"
    echo "    Base de datos: 0"
    echo ""
    echo "  RedisInsight:"
    echo "    URL: http://localhost:8001"
    echo "    Usuario: default"
    echo "    Contraseña: redis123"
    echo ""
    info "🔧 Comandos útiles:"
    echo "  Ver logs: $COMPOSE_CMD logs -f"
    echo "  Parar servicios: $COMPOSE_CMD down"
    echo "  Reiniciar: $COMPOSE_CMD restart"
    echo "  Estado: $COMPOSE_CMD ps"
}

# Función principal
main() {
    log "🚀 Iniciando Redis + RedisInsight con Docker..."
    
    # Verificar Docker Compose
    check_docker_compose
    
    # Crear archivo .env
    create_env_file
    
    # Iniciar servicios
    start_services
    
    # Verificar servicios
    check_services
    
    # Mostrar información
    show_connection_info
}

# Ejecutar función principal
main "$@"
