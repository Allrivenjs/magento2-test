#!/bin/bash

# Script de inicialización para descargar e instalar Magento 2

set -e

echo "=========================================="
echo "Inicializando Magento 2"
echo "=========================================="

# Verificar si Magento ya está descargado
if [ -f "src/composer.json" ]; then
    echo "Magento ya está descargado. Ejecutando composer install..."
    docker-compose exec -T composer composer install --no-interaction --prefer-dist
else
    echo "Descargando la última versión de Magento 2..."
    
    # Verificar si COMPOSER_AUTH está configurado
    if [ -z "$COMPOSER_AUTH" ]; then
        echo "ADVERTENCIA: COMPOSER_AUTH no está configurado."
        echo "Se descargará la versión Open Source de Magento."
        echo "Para la versión completa, configura COMPOSER_AUTH en el archivo .env"
        echo ""
    fi
    
    # Descargar Magento usando Composer
    docker-compose run --rm composer sh -c "
        composer create-project \
            --repository-url=https://repo.magento.com/ \
            magento/project-community-edition \
            . \
            --no-interaction \
            --prefer-dist \
            --no-install
    "
    
    echo "Magento descargado exitosamente!"
fi

echo ""
echo "=========================================="
echo "Próximos pasos:"
echo "=========================================="
echo "1. Instala Magento ejecutando:"
echo "   docker-compose exec php bin/magento setup:install \\"
echo "     --base-url=http://localhost \\"
echo "     --db-host=db \\"
echo "     --db-name=magento \\"
echo "     --db-user=magento \\"
echo "     --db-password=magento \\"
echo "     --admin-firstname=Admin \\"
echo "     --admin-lastname=User \\"
echo "     --admin-email=admin@example.com \\"
echo "     --admin-user=admin \\"
echo "     --admin-password=Admin123 \\"
echo "     --language=en_US \\"
echo "     --currency=USD \\"
echo "     --timezone=America/New_York \\"
echo "     --use-rewrites=1 \\"
echo "     --backend-frontname=admin \\"
echo "     --elasticsearch-host=elasticsearch \\"
echo "     --elasticsearch-port=9200"
echo ""
echo "2. Configura permisos:"
echo "   docker-compose exec php chmod -R 777 var pub/static pub/media app/etc"
echo ""
echo "3. Accede a Magento en: http://localhost"
echo "=========================================="

