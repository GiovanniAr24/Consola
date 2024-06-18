@echo off
:: Cambiar la página de códigos a CHCP 65001 para un mejor soporte de caracteres latinos
CHCP 65001

SETLOCAL EnableDelayedExpansion

:: Variables de configuración inicial
SET "PG_BIN_PATH_RAW=%~1"
SET "PG_HOST_RAW=%2"
SET "PG_PORT_RAW=%3"
SET "PG_DATABASE_RAW=%6"
SET "BK_PATH_RAW=%7"

:: Solicitar credenciales del superusuario con privilegios de creación de bases de datos
ECHO Ingrese las credenciales del superusuario para la creación de bases de datos.
SET /P "SUPER_USER=Ingrese el nombre del superusuario: "
ECHO Ingrese la contraseña del superusuario y presione Enter.
SET /P "SUPER_PASSWORD="

:: Rutina de limpieza para eliminar comillas adicionales
SET "PG_BIN_PATH=%PG_BIN_PATH_RAW:"=%"
SET "PG_HOST=%PG_HOST_RAW:"=%"
SET "PG_PORT=%PG_PORT_RAW:"=%"
SET "PG_DATABASE=%PG_DATABASE_RAW:"=%"
SET "BK_PATH=%BK_PATH_RAW:"=%"

:: Determinar el archivo de respaldo a utilizar
IF NOT EXIST last_backup.txt (
    ECHO No se encontró información del último respaldo.
    SET /P "BACKUP_FILE=Ingrese la ruta completa del archivo de respaldo a utilizar: "
) ELSE (
    SET /P BACKUP_FILE=<last_backup.txt
    ECHO El último archivo de respaldo es: !BACKUP_FILE!
    SET /P "USER_INPUT=Ingrese la ruta de un archivo de respaldo diferente o presione Enter para usar el último: "
    IF NOT "!USER_INPUT!"=="" SET "BACKUP_FILE=!USER_INPUT!"
)

:: Solicitar el nuevo nombre de la base de datos
ECHO Nombre actual de la base de datos del respaldo: %PG_DATABASE%
SET /P "NEW_DB_NAME=Ingrese un nuevo nombre para la base de datos donde aplicará el respaldo: "
IF NOT "!NEW_DB_NAME!"=="" SET "PG_DATABASE=!NEW_DB_NAME!" 

:: Establecer la contraseña del superusuario para la sesión
SET "PGPASSWORD=%SUPER_PASSWORD%"

:: Crear la nueva base de datos
ECHO Creando la base de datos: %PG_DATABASE%
"%PG_BIN_PATH%\psql" -h "%PG_HOST%" -p "%PG_PORT%" -U "%SUPER_USER%" -c "CREATE DATABASE %PG_DATABASE%;"

:: Restaurar el respaldo en la nueva base de datos
ECHO Restaurando el respaldo en la base de datos: %PG_DATABASE%
"%PG_BIN_PATH%\pg_restore" -h "%PG_HOST%" -p "%PG_PORT%" -U "%SUPER_USER%" -d "%PG_DATABASE%" "%BACKUP_FILE%"

IF %ERRORLEVEL% NEQ 0 (
    ECHO Error al restaurar el respaldo.
) ELSE (
    ECHO Restauración completada.
)

:: Limpiar la variable de entorno
SET "PGPASSWORD="

ENDLOCAL
