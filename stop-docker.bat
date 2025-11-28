@echo off
REM Script para detener Docker en Windows
echo Deteniendo servicios de Docker...
echo.

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

%DOCKER_COMPOSE% -f compose.yaml -f compose.healthcheck.yaml -f compose.dev.yaml stop

if %ERRORLEVEL% EQU 0 (
    echo Servicios detenidos correctamente.
) else (
    echo ERROR: No se pudieron detener los servicios.
)

pause

