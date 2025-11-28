# Guía Rápida para Windows

Esta guía te ayudará a configurar Magento 2 con Docker en Windows.

## Requisitos

1. **Docker Desktop para Windows** - [Descargar](https://www.docker.com/products/docker-desktop)
2. **Git for Windows** (opcional pero recomendado) - [Descargar](https://git-scm.com/download/win)

## Configuración Inicial

### 1. Instalar Docker Desktop

1. Descarga e instala Docker Desktop desde el enlace anterior
2. Inicia Docker Desktop
3. Ve a Settings → Resources → Advanced
4. Asigna **al menos 6GB de RAM** a Docker
5. Aplica los cambios

### 2. Iniciar los Servicios

Ejecuta el script de inicio:

```cmd
start-docker.bat
```

O manualmente con PowerShell:

```powershell
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml up -d
```

### 3. Verificar que los Servicios Estén Corriendo

```cmd
status-docker.bat
```

O manualmente:

```powershell
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml ps
```

## Descargar Magento

### Opción A: Usando el Script (Requiere Git Bash)

```cmd
download-magento.bat
```

### Opción B: Manualmente con Docker

Si no tienes Git Bash, puedes descargar Magento directamente:

```powershell
# Primero, configura las credenciales de Composer (si las tienes)
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm composer config --global http-basic.repo.magento.com USERNAME PASSWORD

# Luego descarga Magento
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm composer create-project --repository=https://repo.magento.com/ magento/project-community-edition=2.4.7-p3 .
```

**Nota:** Para la versión Community Edition (Open Source), no necesitas credenciales. Solo omite el primer comando.

## Configurar Magento

### Opción A: Script Automático (Requiere Git Bash)

```cmd
setup-magento.bat magento.test
```

### Opción B: Configuración Manual

1. **Agregar dominio al archivo hosts:**

   Edita `C:\Windows\System32\drivers\etc\hosts` como administrador y agrega:
   ```
   127.0.0.1 magento.test
   ```

2. **Instalar Magento:**

   Si tienes Git Bash:
   ```bash
   bash bin/setup-install magento.test
   ```

   O manualmente con Docker:
   ```powershell
   docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm bin/magento setup:install --base-url=https://magento.test/ --base-url-secure=https://magento.test/ --db-host=db --db-name=magento --db-user=magento --db-password=magento --admin-firstname=Admin --admin-lastname=User --admin-email=admin@example.com --admin-user=admin --admin-password=Admin123 --language=en_US --currency=USD --timezone=America/New_York --use-rewrites=1 --backend-frontname=admin --opensearch-host=opensearch --opensearch-port=9200 --search-engine=opensearch
   ```

## Comandos Útiles

### Gestión de Contenedores

```cmd
# Iniciar
start-docker.bat

# Detener
stop-docker.bat

# Ver estado
status-docker.bat
```

### Comandos de Magento

Si tienes Git Bash:
```bash
bash bin/magento cache:flush
bash bin/magento setup:upgrade
```

O directamente con Docker:
```powershell
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm bin/magento cache:flush
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm bin/magento setup:upgrade
```

### Acceder al Contenedor

```powershell
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec phpfpm bash
```

## Solución de Problemas

### Error: "bash: command not found"

**Solución:** Instala Git for Windows o usa los comandos de Docker directamente.

### Error: "No such file or directory" al ejecutar scripts

**Solución:** Los scripts `.sh` requieren Git Bash. Usa los scripts `.bat` o ejecuta los comandos de Docker directamente.

### Los contenedores no inician

1. Verifica que Docker Desktop esté corriendo
2. Verifica que tengas al menos 6GB de RAM asignada
3. Revisa los logs:
   ```powershell
   docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml logs
   ```

### Error de permisos

En Windows, los permisos generalmente no son un problema, pero si tienes problemas:

```powershell
docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm chmod -R 777 var pub/static pub/media app/etc
```

## Acceso a Servicios

- **Magento Frontend:** http://localhost o https://magento.test (después de configurar)
- **Magento Admin:** https://magento.test/admin/
- **phpMyAdmin:** http://localhost:8080
- **MailCatcher:** http://localhost:1080
- **RabbitMQ:** http://localhost:15672 (usuario: magento, contraseña: magento)

## Notas Importantes

1. **Git Bash es opcional** pero facilita el uso de los scripts. Si no lo tienes, puedes usar Docker Compose directamente.

2. **Archivo hosts:** En Windows, necesitas editar el archivo hosts manualmente para agregar el dominio `magento.test`.

3. **Certificados SSL:** Los certificados SSL se generan automáticamente, pero en Windows necesitarás instalarlos manualmente si usas HTTPS.

4. **Rutas:** Los scripts `.bat` están diseñados para funcionar desde la raíz del proyecto.

## Próximos Pasos

Una vez que Magento esté instalado:

1. Configura el modo de desarrollo:
   ```powershell
   docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm bin/magento deploy:mode:set developer
   ```

2. Limpia la caché:
   ```powershell
   docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm bin/magento cache:flush
   ```

3. Reindexa:
   ```powershell
   docker compose -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml exec -T phpfpm bin/magento indexer:reindex
   ```

¡Listo! Ya tienes Magento 2 corriendo en Docker en Windows.

