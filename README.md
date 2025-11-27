# Magento 2 Docker Compose

Este proyecto proporciona una configuración completa de Docker Compose para ejecutar Magento 2 con todos sus servicios dependientes.

## Requisitos Previos

- Docker Desktop (Windows/Mac) o Docker Engine + Docker Compose (Linux)
- Git
- Al menos 4GB de RAM disponible
- 10GB de espacio en disco libre

## Configuración Inicial

### 1. Clonar o descargar el proyecto

Si aún no lo has hecho, asegúrate de estar en el directorio del proyecto.

### 2. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables (o usa los valores por defecto):

```env
# Configuración de MySQL
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=magento
MYSQL_USER=magento
MYSQL_PASSWORD=magento
MYSQL_PORT=3306

# Configuración de Redis
REDIS_PORT=6379

# Configuración de Elasticsearch
ELASTICSEARCH_PORT=9200
ELASTICSEARCH_PORT_2=9300

# Configuración de Nginx
NGINX_PORT=80
NGINX_PORT_SSL=443
NGINX_HOST=localhost

# Configuración de PHP
PHP_MEMORY_LIMIT=2G
PHP_UPLOAD_MAX_FILESIZE=64M
PHP_POST_MAX_SIZE=64M

# Autenticación de Composer para Magento Marketplace (opcional)
# Formato: {"http-basic":{"repo.magento.com":{"username":"TU_PUBLIC_KEY","password":"TU_PRIVATE_KEY"}}}
# Obtén tus claves en: https://marketplace.magento.com/customer/accessKeys/
COMPOSER_AUTH=
```

**Importante**: Si deseas descargar la versión completa de Magento (no solo Open Source), necesitarás configurar `COMPOSER_AUTH` con tus credenciales de Magento Marketplace:

1. Obtén tus claves de acceso en: https://marketplace.magento.com/customer/accessKeys/
2. Edita el archivo `.env` y agrega:

```env
COMPOSER_AUTH={"http-basic":{"repo.magento.com":{"username":"TU_PUBLIC_KEY","password":"TU_PRIVATE_KEY"}}}
```

### 3. Iniciar los servicios

```bash
docker-compose up -d
```

Este comando:
- Descargará todas las imágenes necesarias
- Creará los contenedores (PHP, Nginx, MySQL, Redis, Elasticsearch)

### 4. Descargar Magento 2

Una vez que los servicios estén corriendo, descarga Magento usando uno de estos métodos:

**Opción A: Usando el script de inicialización (recomendado)**

```bash
# En Windows (PowerShell)
bash init-magento.sh

# En Linux/Mac
chmod +x init-magento.sh
./init-magento.sh
```

**Opción B: Usando Docker Compose directamente**

```bash
docker-compose run --rm composer sh -c "
  composer create-project \
    --repository-url=https://repo.magento.com/ \
    magento/project-community-edition \
    . \
    --no-interaction \
    --prefer-dist
"
```

Esto descargará la última versión de Magento 2 en el directorio `src/`.

### 5. Instalar Magento

Una vez que Magento esté descargado, ejecuta la instalación:

```bash
docker-compose exec php bin/magento setup:install \
  --base-url=http://localhost \
  --db-host=db \
  --db-name=magento \
  --db-user=magento \
  --db-password=magento \
  --admin-firstname=Admin \
  --admin-lastname=User \
  --admin-email=admin@example.com \
  --admin-user=admin \
  --admin-password=Admin123 \
  --language=en_US \
  --currency=USD \
  --timezone=America/New_York \
  --use-rewrites=1 \
  --backend-frontname=admin \
  --elasticsearch-host=elasticsearch \
  --elasticsearch-port=9200
```

### 6. Configurar permisos

```bash
docker-compose exec php chmod -R 777 var pub/static pub/media app/etc
```

### 7. Acceder a Magento

- Frontend: http://localhost
- Backend: http://localhost/admin
  - Usuario: admin
  - Contraseña: Admin123 (o la que hayas configurado)

## Servicios Incluidos

- **PHP 8.2-FPM**: Servidor PHP con todas las extensiones necesarias para Magento
- **Nginx**: Servidor web
- **MySQL 8.0**: Base de datos
- **Redis**: Caché y sesiones
- **Elasticsearch 8.11**: Motor de búsqueda
- **Composer**: Para descargar e instalar Magento

## Comandos Útiles

### Ver logs
```bash
docker-compose logs -f [nombre_servicio]
```

### Ejecutar comandos de Magento
```bash
docker-compose exec php bin/magento [comando]
```

### Acceder al contenedor PHP
```bash
docker-compose exec php bash
```

### Reiniciar servicios
```bash
docker-compose restart
```

### Detener servicios
```bash
docker-compose down
```

### Detener y eliminar volúmenes (¡CUIDADO! Esto elimina la base de datos)
```bash
docker-compose down -v
```

## Estructura de Directorios

```
magento2-test/
├── docker-compose.yml
├── .env
├── .env.example
├── README.md
├── docker/
│   ├── nginx/
│   │   └── default.conf
│   └── php/
│       ├── Dockerfile
│       ├── php.ini
│       └── xdebug.ini
└── src/          # Aquí se descargará Magento
```

## Solución de Problemas

### Error de permisos
Si encuentras errores de permisos, ejecuta:
```bash
docker-compose exec php chmod -R 777 var pub/static pub/media app/etc
```

### Elasticsearch no inicia
Si Elasticsearch no inicia, verifica que tengas suficiente memoria disponible. Puedes reducir el uso de memoria editando `ES_JAVA_OPTS` en `docker-compose.yml`.

### Composer no puede descargar Magento
- Verifica que `COMPOSER_AUTH` esté correctamente configurado en `.env`
- Para la versión Open Source, no necesitas credenciales
- Verifica los logs: `docker-compose logs composer`

### Puerto ya en uso
Si algún puerto está en uso, modifica los valores en el archivo `.env`:
- `NGINX_PORT`: Puerto para HTTP (por defecto 80)
- `MYSQL_PORT`: Puerto para MySQL (por defecto 3306)
- `REDIS_PORT`: Puerto para Redis (por defecto 6379)
- `ELASTICSEARCH_PORT`: Puerto para Elasticsearch (por defecto 9200)

## Actualizar Magento

Para actualizar Magento a la última versión:

```bash
docker-compose exec php composer update
docker-compose exec php bin/magento setup:upgrade
docker-compose exec php bin/magento setup:di:compile
docker-compose exec php bin/magento setup:static-content:deploy -f
docker-compose exec php bin/magento cache:flush
```

## Notas

- Los datos de la base de datos se almacenan en un volumen persistente
- Los archivos de Magento se almacenan en el directorio `src/`
- Para desarrollo, se recomienda usar el modo developer: `bin/magento deploy:mode:set developer`

## Licencia

Este proyecto está bajo la Licencia Apache 2.0.

