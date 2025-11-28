@echo off
REM Script para configurar Magento en Windows

set DOMAIN=%1
if "%DOMAIN%"=="" set DOMAIN=magento.test

echo Configurando Magento para el dominio: %DOMAIN%
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

REM Verificar si Git Bash está disponible
where bash >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ejecutando script de configuración con Git Bash...
    bash bin/setup %DOMAIN%
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ==========================================
        echo Magento configurado correctamente!
        echo ==========================================
        echo.
        echo Puedes acceder a tu sitio en: https://%DOMAIN%/
        echo.
        echo Credenciales por defecto:
        echo   Usuario: john.smith
        echo   Contraseña: password123
        echo.
        echo NOTA: En Windows, necesitas agregar %DOMAIN% a tu archivo hosts:
        echo   C:\Windows\System32\drivers\etc\hosts
        echo   Agrega esta línea: 127.0.0.1 %DOMAIN%
    ) else (
        echo.
        echo ERROR: No se pudo configurar Magento
        echo Verifica los logs con: %DOCKER_COMPOSE% -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml logs
    )
) else (
    echo.
    echo ERROR: Git Bash no está instalado o no está en el PATH
    echo.
    echo Por favor instala Git for Windows: https://git-scm.com/download/win
    echo.
    echo O ejecuta los comandos manualmente siguiendo el README.md
)

pause

