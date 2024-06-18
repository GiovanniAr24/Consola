@echo off
SETLOCAL EnableDelayedExpansion

SET "PG_BIN_PATH_RAW=%~1"
SET "PG_HOST_RAW=%~2"
SET "PG_PORT_RAW=%~3"
SET "PG_USER_RAW=%~4"
SET "PG_PASSWORD_RAW=%~5"
SET "PG_DATABASE_RAW=%~6"
SET "BK_PATH_RAW=%7"

:: Rutina de limpieza para eliminar comillas adicionales
SET "PG_BIN_PATH=%PG_BIN_PATH_RAW:"=%"
SET "PG_HOST=%PG_HOST_RAW:"=%"
SET "PG_PORT=%PG_PORT_RAW:"=%"
SET "PG_USER=%PG_USER_RAW:"=%"
SET "PG_PASSWORD=%PG_PASSWORD_RAW:"=%"
SET "PG_DATABASE=%PG_DATABASE_RAW:"=%"
SET "BK_PATH=%BK_PATH_RAW:"=%"

:: Obtener fecha y hora actuales en formato seguro para nombres de archivo
FOR /F "tokens=2 delims==" %%i IN ('wmic os get localdatetime /VALUE') DO SET datetime=%%i
SET "datetime=%datetime:~0,8%_%datetime:~8,6%"

:: Proponer un nombre de archivo por defecto
SET "DEFAULT_BACKUP_NAME=%PG_DATABASE%_%datetime%.backup"

:: Solicitar al usuario un nombre de archivo, usando el valor por defecto si no se proporciona uno
ECHO Nombre de archivo de respaldo propuesto: %DEFAULT_BACKUP_NAME%

SET /P "BACKUP_NAME=Ingrese un nombre para el archivo de respaldo o presione Enter para usar el predeterminado [%DEFAULT_BACKUP_NAME%]: "
IF "!BACKUP_NAME!"=="" SET "BACKUP_NAME=!DEFAULT_BACKUP_NAME!"


:: Establecer la contraseña para la sesión
SET "PGPASSWORD=%PG_PASSWORD%"

:: Crear el archivo de respaldo
ECHO Creando respaldo: %BK_PATH%\%BACKUP_NAME%
"%PG_BIN_PATH%\pg_dump" -h "%PG_HOST%" -p "%PG_PORT%" -U "%PG_USER%" -F c -b -v -f "%BK_PATH%\%BACKUP_NAME%" "%PG_DATABASE%"
IF %ERRORLEVEL% NEQ 0 (
    ECHO Error al realizar el respaldo.
) ELSE (
    ECHO Respaldo completado.
    ECHO %BK_PATH%\%BACKUP_NAME% > last_backup.txt
)

:: Limpiar la variable de entorno
SET "PGPASSWORD="

ENDLOCAL
