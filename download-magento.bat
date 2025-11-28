@echo off
REM Script para descargar Magento en Windows
echo Descargando Magento 2...
echo.

REM Verificar si Docker está corriendo
docker ps >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker no está corriendo. Por favor ejecuta start-docker.bat primero.
    pause
    exit /b 1
)

REM Verificar si docker compose está disponible
docker compose version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set DOCKER_COMPOSE=docker compose
) else (
    docker-compose --version >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set DOCKER_COMPOSE=docker-compose
    ) else (
        echo ERROR: Docker Compose no está disponible
        pause
        exit /b 1
    )
)

REM Verificar si src está vacío
if exist src\* (
    echo ERROR: El directorio src no está vacío.
    echo Por favor elimina el contenido de src antes de continuar.
    pause
    exit /b 1
)

REM Verificar si Git Bash está disponible para ejecutar el script de descarga
where bash >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ejecutando script de descarga con Git Bash...
    bash bin/download %*
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ==========================================
        echo Magento descargado correctamente!
        echo ==========================================
        echo.
        echo Próximos pasos:
        echo   1. Configura Magento con: setup-magento.bat magento.test
        echo   2. O instala manualmente siguiendo el README.md
    ) else (
        echo.
        echo ERROR: No se pudo descargar Magento
        echo Verifica que los servicios de Docker estén corriendo.
    )
) else (
    echo.
    echo ADVERTENCIA: Git Bash no está disponible.
    echo.
    echo Opciones:
    echo   1. Instala Git for Windows: https://git-scm.com/download/win
    echo   2. O descarga Magento manualmente usando Docker:
    echo.
    echo      %DOCKER_COMPOSE% -f compose.yaml -f compose.healthcheck.yaml exec -T phpfpm composer create-project --repository=https://repo.magento.com/ magento/project-community-edition=2.4.7-p3 .
    echo.
    echo      (Nota: Necesitarás configurar las credenciales de Composer primero)
)

pause
