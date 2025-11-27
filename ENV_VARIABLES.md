# Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

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

## Notas Importantes

- **COMPOSER_AUTH**: Solo es necesario si deseas descargar la versión Enterprise de Magento o módulos del Marketplace. Para la versión Community Edition (Open Source) no es necesario.
- **Puertos**: Si algún puerto está en uso, modifica los valores correspondientes.
- **Memoria PHP**: Ajusta `PHP_MEMORY_LIMIT` según los recursos de tu sistema. El mínimo recomendado es 2GB.

