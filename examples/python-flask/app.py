#!/usr/bin/env python3
"""
Redis Docker Example - Flask Application
Aplicación Flask de ejemplo con Redis
"""

from flask import Flask, jsonify, request
import redis
import os
from dotenv import load_dotenv
import json
import time

# Cargar variables de entorno
load_dotenv()

# Configuración de la aplicación
app = Flask(__name__)

# Configuración de Redis
REDIS_HOST = os.getenv('REDIS_HOST', 'redis-db')
REDIS_PORT = int(os.getenv('REDIS_PORT', 6379))
REDIS_PASSWORD = os.getenv('REDIS_PASSWORD', 'redis123')
REDIS_DB = int(os.getenv('REDIS_DB', 0))

# Conectar a Redis
try:
    redis_client = redis.Redis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        password=REDIS_PASSWORD,
        db=REDIS_DB,
        decode_responses=True
    )
    # Verificar conexión
    redis_client.ping()
    print("✅ Conectado a Redis exitosamente")
except Exception as e:
    print(f"❌ Error conectando a Redis: {e}")
    redis_client = None

@app.route('/')
def index():
    """Página principal"""
    return jsonify({
        'message': 'Redis Docker Example - Flask Application',
        'status': 'running',
        'redis_connected': redis_client is not None
    })

@app.route('/health')
def health():
    """Endpoint de salud"""
    try:
        if redis_client:
            redis_client.ping()
            return jsonify({'status': 'healthy', 'redis': 'connected'})
        else:
            return jsonify({'status': 'unhealthy', 'redis': 'disconnected'}), 500
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'error': str(e)}), 500

@app.route('/redis/info')
def redis_info():
    """Información de Redis"""
    try:
        if redis_client:
            info = redis_client.info()
            return jsonify({
                'redis_version': info.get('redis_version'),
                'connected_clients': info.get('connected_clients'),
                'used_memory_human': info.get('used_memory_human'),
                'keyspace': info.get('keyspace', {}),
                'uptime_in_seconds': info.get('uptime_in_seconds')
            })
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/redis/keys')
def redis_keys():
    """Listar claves de Redis"""
    try:
        if redis_client:
            keys = redis_client.keys('*')
            return jsonify({'keys': keys, 'count': len(keys)})
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/redis/set', methods=['POST'])
def redis_set():
    """Establecer clave-valor en Redis"""
    try:
        if redis_client:
            data = request.get_json()
            key = data.get('key')
            value = data.get('value')
            ttl = data.get('ttl', None)
            
            if not key or not value:
                return jsonify({'error': 'Key and value are required'}), 400
            
            if ttl:
                redis_client.setex(key, ttl, value)
            else:
                redis_client.set(key, value)
            
            return jsonify({'message': 'Key set successfully', 'key': key})
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/redis/get/<key>')
def redis_get(key):
    """Obtener valor de Redis"""
    try:
        if redis_client:
            value = redis_client.get(key)
            if value is not None:
                return jsonify({'key': key, 'value': value})
            else:
                return jsonify({'error': 'Key not found'}), 404
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/redis/delete/<key>', methods=['DELETE'])
def redis_delete(key):
    """Eliminar clave de Redis"""
    try:
        if redis_client:
            deleted = redis_client.delete(key)
            if deleted:
                return jsonify({'message': 'Key deleted successfully', 'key': key})
            else:
                return jsonify({'error': 'Key not found'}), 404
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/redis/flush', methods=['POST'])
def redis_flush():
    """Limpiar todas las claves de Redis"""
    try:
        if redis_client:
            redis_client.flushdb()
            return jsonify({'message': 'Database flushed successfully'})
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users', methods=['GET'])
def get_users():
    """Obtener usuarios de Redis"""
    try:
        if redis_client:
            users = []
            for key in redis_client.keys('user:*'):
                user_data = redis_client.hgetall(key)
                user_data['id'] = key.split(':')[1]
                users.append(user_data)
            return jsonify({'users': users, 'count': len(users)})
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users', methods=['POST'])
def create_user():
    """Crear usuario en Redis"""
    try:
        if redis_client:
            data = request.get_json()
            user_id = str(int(time.time()))
            user_key = f'user:{user_id}'
            
            redis_client.hset(user_key, mapping=data)
            return jsonify({'message': 'User created successfully', 'user_id': user_id})
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/products', methods=['GET'])
def get_products():
    """Obtener productos de Redis"""
    try:
        if redis_client:
            products = []
            for key in redis_client.keys('product:*'):
                product_data = redis_client.hgetall(key)
                product_data['id'] = key.split(':')[1]
                products.append(product_data)
            return jsonify({'products': products, 'count': len(products)})
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/stats')
def get_stats():
    """Estadísticas de la aplicación"""
    try:
        if redis_client:
            stats = {
                'total_keys': len(redis_client.keys('*')),
                'users': len(redis_client.keys('user:*')),
                'products': len(redis_client.keys('product:*')),
                'sessions': len(redis_client.keys('session:*')),
                'redis_info': {
                    'connected_clients': redis_client.info().get('connected_clients'),
                    'used_memory_human': redis_client.info().get('used_memory_human'),
                    'uptime_in_seconds': redis_client.info().get('uptime_in_seconds')
                }
            }
            return jsonify(stats)
        else:
            return jsonify({'error': 'Redis not connected'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
