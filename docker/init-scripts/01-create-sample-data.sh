#!/bin/bash
# Script para crear datos de ejemplo en Redis

set -e

echo "Creating sample data in Redis..."

# Esperar a que Redis esté listo
sleep 10

# Crear datos de ejemplo usando redis-cli
redis-cli -a redis123 <<-EOF
# Configurar base de datos 0
SELECT 0

# Crear usuarios
HSET user:1 name "John Doe" email "john@example.com" age 30
HSET user:2 name "Jane Smith" email "jane@example.com" age 25
HSET user:3 name "Bob Wilson" email "bob@example.com" age 35

# Crear productos
HSET product:1 name "Laptop" price 999.99 category "Electronics"
HSET product:2 name "Phone" price 599.99 category "Electronics"
HSET product:3 name "Book" price 19.99 category "Books"

# Crear sesiones
SET session:user:1 "active" EX 3600
SET session:user:2 "active" EX 3600

# Crear contadores
SET counter:visits 0
SET counter:users 3

# Crear listas
LPUSH recent:users user:1 user:2 user:3
LPUSH recent:products product:1 product:2 product:3

# Crear sets
SADD tags:electronics product:1 product:2
SADD tags:books product:3

# Crear sorted sets
ZADD leaderboard 100 user:1
ZADD leaderboard 95 user:2
ZADD leaderboard 90 user:3

# Configurar TTL para algunos datos
EXPIRE session:user:1 3600
EXPIRE session:user:2 3600

# Crear índices
SADD index:users:active user:1 user:2 user:3
SADD index:products:electronics product:1 product:2

EOF

echo "Sample data created successfully!"
