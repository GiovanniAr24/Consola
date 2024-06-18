@echo off
SETLOCAL EnableDelayedExpansion

CHCP 65001

:: Establecer valores predeterminados
SET PG_BIN_PATH=C:\Program Files\PostgreSQL\15\bin
SET PG_HOST=localhost
SET PG_PORT=5432
SET PG_USER=postgres
SET PG_DATABASE=mi_financiera_demo
SET BK_PATH=C:\Users\Admin\Documents

:: Solicitar parámetros al usuario
SET /P "PG_BIN_PATH=Ingrese el path de los binarios de PostgreSQL [%PG_BIN_PATH%]: "
SET /P "PG_HOST=Ingrese el host de la base de datos [%PG_HOST%]: "
SET /P "PG_PORT=Ingrese el puerto [%PG_PORT%]: "
SET /P "PG_USER=Ingrese el usuario de la base de datos [%PG_USER%]: "
SET /P "PG_DATABASE=Ingrese el nombre de la base de datos [%PG_DATABASE%]: "
SET /P "PG_PASSWORD=Ingrese la contraseña: "
SET /P "BK_PATH=Ingrese la ruta de trabajo para los respaldos [%BK_PATH%]: "

:MENU
ECHO.
ECHO 1. Crear un respaldo
ECHO 2. Ver Historial de respaldo
ECHO 3. Ver contenido del respaldo creado
ECHO 4. Restaurar un respaldo
ECHO 5. Adicionar un usuario
ECHO 6. Programar un respaldo
ECHO 7. Ver las tareas programadas
ECHO 8. Monitorizar la base de datos
ECHO 9. Salir
ECHO.
SET /P "OPTION=Seleccione una opción: "

IF "%OPTION%"=="1" CALL "C:\Users\artea\OneDrive\Escritorio\Consola Administradora DB\Consola Administradora DB Administradora DB\Respaldo_DB.bat" "%PG_BIN_PATH%" "%PG_HOST%" "%PG_PORT%" "%PG_USER%" "%PG_PASSWORD%" "%PG_DATABASE%" "%BK_PATH%"
IF "%OPTION%"=="2" CALL "C:\Users\artea\OneDrive\Escritorio\Consola Administradora DB\Consola Administradora DB Administradora DB\Ver_Respaldos.bat" "%BK_PATH%"
IF "%OPTION%"=="3" CALL "C:\Users\artea\OneDrive\Escritorio\Consola Administradora DB\Consola Administradora DB Administradora DB\Ver_Contenido_Respaldo.bat" "%BK_PATH%"
IF "%OPTION%"=="4" CALL "C:\Users\Admin\Downloads\Consola Administradora DB\Restaurar.bat" "%PG_BIN_PATH%" "%PG_HOST%" "%PG_PORT%" "%PG_USER%" "%PG_PASSWORD%" "%PG_DATABASE%" "%BK_PATH%"
IF "%OPTION%"=="5" CALL "C:\Users\Admin\Downloads\Consola Administradora DB\Adicionar_usuario.bat"
IF "%OPTION%"=="6" CALL "C:\Users\Admin\Downloads\Consola Administradora DB\Respaldo_Programado.bat" "%PG_BIN_PATH%" "%PG_HOST%" "%PG_PORT%" "%PG_USER%" "%PG_DATABASE%" "%BK_PATH%"
IF "%OPTION%"=="7" CALL "C:\Users\Admin\Downloads\Consola Administradora DB\Ver_tareas.bat"
IF "%OPTION%"=="8" CALL "C:\Users\Admin\Downloads\Consola Administradora DB\Monitor_db.bat"
IF "%OPTION%"=="9" EXIT


GOTO MENU

ENDLOCAL

