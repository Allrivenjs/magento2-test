# Magento 2 Docker Setup

Configuración de Docker para Magento 2 basada en [markshust/docker-magento](https://github.com/markshust/docker-magento).

## Requisitos Previos

- **Docker Desktop** (Windows/Mac) o **Docker Engine + Docker Compose** (Linux)
- **Git Bash** (para Windows) - [Descargar Git for Windows](https://git-scm.com/download/win)
- **Al menos 6GB de RAM** asignada a Docker
- **10GB de espacio en disco** libre

## Configuración Inicial

### 1. Verificar Docker

Asegúrate de que Docker esté corriendo:

```bash
docker --version
docker compose version
```

### 2. Configurar Memoria de Docker

En Docker Desktop:
- Ve a Settings → Resources → Advanced
- Asigna al menos **6GB de RAM**
- Aplica los cambios

### 3. Iniciar los Servicios

**En Windows (PowerShell o Git Bash):**

```bash
bash bin/start
```

O usa el script de Windows:

```bash
start-docker.bat
```

**En Linux/Mac:**

```bash
./bin/start
```

Esto iniciará todos los servicios necesarios:
- PHP 8.3-FPM
- Nginx
- MariaDB 11.4
- Redis (Valkey)
- OpenSearch 2.12
- RabbitMQ 4.1
- MailCatcher

### 4. Descargar Magento 2

**Opción A: Descargar solo Magento (recomendado para empezar)**

```bash
bash bin/download
```

Esto descargará la última versión de Magento 2 Community Edition (2.4.7-p3) en el directorio `src/`.

**Opción B: Configuración completa automática**

```bash
bash bin/setup magento.test
```

Este comando:
- Descarga Magento
- Instala Magento
- Configura SSL
- Configura el dominio
- Genera contenido estático

**Nota:** En Windows, necesitarás agregar manualmente `magento.test` a tu archivo `C:\Windows\System32\drivers\etc\hosts`:

```
127.0.0.1 magento.test
```

### 5. Configurar Autenticación de Composer

Si necesitas descargar módulos del Marketplace de Magento, configura tus credenciales:

```bash
bash bin/setup-composer-auth
```

Obtén tus claves en: https://marketplace.magento.com/customer/accessKeys/

## Comandos Útiles

### Gestión de Contenedores

```bash
# Iniciar servicios
bash bin/start

# Detener servicios
bash bin/stop

# Reiniciar servicios
bash bin/restart

# Ver estado de contenedores
bash bin/status
```

### Comandos de Magento

```bash
# Ejecutar comandos de Magento
bash bin/magento cache:flush
bash bin/magento setup:upgrade
bash bin/magento indexer:reindex

# Ver versión de Magento
bash bin/magento --version
```

### Comandos de Composer

```bash
# Instalar dependencias
bash bin/composer install

# Actualizar dependencias
bash bin/composer update

# Requerir un módulo
bash bin/composer require vendor/module-name
```

### Acceso a Contenedores

```bash
# Acceder al contenedor PHP
bash bin/bash

# Ejecutar un comando en el contenedor
bash bin/cli ls -la
```

### Permisos

```bash
# Arreglar permisos de archivos
bash bin/fixperms

# Arreglar propietarios de archivos
bash bin/fixowns
```

## Acceso a Servicios

Una vez configurado, puedes acceder a:

- **Magento Frontend:** https://magento.test/ (o http://localhost)
- **Magento Admin:** https://magento.test/admin/
  - Usuario: `john.smith` (configurable en `env/magento.env`)
  - Contraseña: `password123` (configurable en `env/magento.env`)
- **phpMyAdmin:** http://localhost:8080
- **MailCatcher:** http://localhost:1080
- **RabbitMQ Management:** http://localhost:15672
  - Usuario: `magento`
  - Contraseña: `magento`

## Configuración

### Variables de Entorno

Los archivos de configuración están en la carpeta `env/`:

- `env/db.env` - Configuración de base de datos
- `env/magento.env` - Configuración de Magento (admin, locale, etc.)
- `env/phpfpm.env` - Configuración de PHP
- `env/opensearch.env` - Configuración de OpenSearch
- `env/redis.env` - Configuración de Redis
- `env/rabbitmq.env` - Configuración de RabbitMQ

### Personalizar Configuración de Magento

Edita `env/magento.env` para cambiar:
- Email del administrador
- Nombre de usuario del administrador
- Contraseña del administrador
- Idioma, moneda, zona horaria

## Solución de Problemas

### Error: "There must be at least 6GB of RAM allocated to Docker"

Aumenta la memoria asignada a Docker en Docker Desktop:
1. Abre Docker Desktop
2. Ve a Settings → Resources → Advanced
3. Aumenta la memoria a al menos 6GB
4. Aplica los cambios y reinicia Docker

### Error: "The src directory is not empty"

El directorio `src/` debe estar vacío antes de descargar Magento:

```bash
# En Windows (PowerShell)
Remove-Item -Recurse -Force src\*
# O manualmente borra el contenido de la carpeta src/

# Luego intenta de nuevo
bash bin/download
```

### Error de permisos

```bash
bash bin/fixperms
bash bin/fixowns
```

### Los contenedores no inician

Verifica los logs:

```bash
bash bin/docker-compose logs
```

O para un servicio específico:

```bash
bash bin/docker-compose logs phpfpm
bash bin/docker-compose logs db
```

### OpenSearch no inicia

OpenSearch requiere bastante memoria. Si falla, puedes:
1. Aumentar la memoria de Docker
2. O cambiar a Elasticsearch editando `compose.yaml`

## Estructura del Proyecto

```
magento2-test/
├── bin/                    # Scripts de utilidad
├── env/                    # Archivos de configuración de entorno
├── src/                    # Código de Magento (se crea al descargar)
├── compose.yaml            # Configuración principal de Docker Compose
├── compose.dev.yaml        # Configuración de desarrollo
├── compose.healthcheck.yaml # Health checks
├── start-docker.bat        # Script de inicio para Windows
├── download-magento.bat    # Script de descarga para Windows
└── setup-magento.bat       # Script de setup para Windows
```

## Notas Adicionales

- Los datos de la base de datos se almacenan en volúmenes persistentes de Docker
- Los archivos de Magento se sincronizan entre el host y el contenedor
- Para desarrollo, se recomienda usar el modo developer: `bash bin/magento deploy:mode:set developer`
- Los certificados SSL se generan automáticamente usando mkcert

## Recursos

- [Documentación oficial de docker-magento](https://github.com/markshust/docker-magento)
- [Documentación de Magento 2](https://devdocs.magento.com/)
- [Marketplace de Magento](https://marketplace.magento.com/)

## Licencia

Este proyecto está basado en [markshust/docker-magento](https://github.com/markshust/docker-magento) que está bajo licencia MIT.
