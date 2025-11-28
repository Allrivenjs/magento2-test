@echo off
REM Script para iniciar Docker en Windows
echo Iniciando Docker para Magento...
echo.

REM Verificar si Docker está disponible
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker no está instalado o no está en el PATH
    echo Por favor instala Docker Desktop: https://www.docker.com/products/docker-desktop
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

echo Usando: %DOCKER_COMPOSE%
echo.

REM Verificar memoria de Docker (requiere al menos 6GB)
echo Verificando configuración de Docker...
docker info | findstr /C:"Total Memory" >nul
if %ERRORLEVEL% NEQ 0 (
    echo ADVERTENCIA: No se pudo verificar la memoria de Docker
    echo Asegúrate de tener al menos 6GB de RAM asignada a Docker
)

REM Iniciar los servicios usando docker compose directamente
echo Iniciando servicios de Docker...
%DOCKER_COMPOSE% -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml up -d --remove-orphans

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo Docker iniciado correctamente!
    echo ==========================================
    echo.
    echo Servicios disponibles:
    echo   - Nginx: http://localhost
    echo   - phpMyAdmin: http://localhost:8080
    echo   - MailCatcher: http://localhost:1080
    echo   - RabbitMQ: http://localhost:15672
    echo.
    echo Para descargar Magento, ejecuta:
    echo   download-magento.bat
    echo.
    echo O para configurar todo automáticamente:
    echo   setup-magento.bat magento.test
    echo.
    echo Para ver el estado de los contenedores:
    echo   %DOCKER_COMPOSE% -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml ps
) else (
    echo.
    echo ERROR: No se pudieron iniciar los servicios de Docker
    echo.
    echo Verifica:
    echo   1. Que Docker Desktop esté corriendo
    echo   2. Que tengas al menos 6GB de RAM asignada a Docker
    echo   3. Los logs con: %DOCKER_COMPOSE% -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml logs
)

pause
