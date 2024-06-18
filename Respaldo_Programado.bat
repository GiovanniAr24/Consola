@echo off
SETLOCAL EnableDelayedExpansion
CHCP 65001

:: Validar y establecer parámetros
SET "PG_BIN_PATH=%~1"
SET "PG_HOST=%~2"
SET "PG_PORT=%~3"
SET "PG_USER=%~4"
SET "PG_DATABASE=%~5"
SET "BK_PATH=%~6"

:: Rutina de limpieza para eliminar comillas y caracteres no permitidos
SET "PG_BIN_PATH=%PG_BIN_PATH:"=%"
SET "PG_HOST=%PG_HOST:"=%"
SET "PG_PORT=%PG_PORT:"=%"
SET "PG_USER=%PG_USER:"=%"
SET "PG_DATABASE=%PG_DATABASE:"=%"


IF "%PG_BIN_PATH%"=="" SET "PG_BIN_PATH=C:\Program Files\PostgreSQL\15\bin"
IF "%PG_HOST%"=="" SET "PG_HOST=localhost"
IF "%PG_PORT%"=="" SET "PG_PORT=5432"
IF "%PG_USER%"=="" SET "PG_USER=postgres"
IF "%PG_DATABASE%"=="" SET "PG_DATABASE=mi_financiera_demo"
SET "BK_PATH="C:\Users\Admin\Documents"" 


:: Solicitar fecha y hora para el respaldo
ECHO Programar Respaldo para la Base de Datos: %PG_DATABASE%
SET /P "BACKUP_DATE=Ingrese la fecha para el respaldo (formato MM/DD/YYYY): "
SET /P "BACKUP_TIME=Ingrese la hora para el respaldo (formato HH:MM): "

:: Reemplazar ":" en la hora para el nombre del archivo
SET "CLEAN_BACKUP_TIME=%BACKUP_TIME::=%"
SET "FILE_BACKUP_DATE=%BACKUP_DATE:/=%"


:: Crear archivo batch temporal
SET "TEMP_BATCH=%BK_PATH%\temp_respaldo_mi_financiera_demo_%FILE_BACKUP_DATE%_%CLEAN_BACKUP_TIME%.bat"
ECHO  %TEMP_BATCH%
ECHO @echo off > %TEMP_BATCH%
ECHO SET "PGPASSWORD=%PG_PASSWORD%" >> %TEMP_BATCH%
ECHO "%PG_BIN_PATH%\pg_dump" -h %PG_HOST% -p %PG_PORT% -U %PG_USER% -F c -b -v -f "%BK_PATH%\%PG_DATABASE%_%FILE_BACKUP_DATE%_%CLEAN_BACKUP_TIME%.backup" %PG_DATABASE% >> %TEMP_BATCH%
ECHO SET PGPASSWORD= >> %TEMP_BATCH%
::ECHO DEL "%TEMP_BATCH%"

:: Programar la tarea
SET "TASK_NAME=RespaldoProgramado_%PG_DATABASE%_%FILE_BACKUP_DATE%_%CLEAN_BACKUP_TIME%"
schtasks /create /tn "%TASK_NAME%" /tr "%TEMP_BATCH%" /sc once /sd %BACKUP_DATE% /st %BACKUP_TIME% /ru SYSTEM

:: Confirmación y limpieza
IF %ERRORLEVEL% EQU 0 (
    ECHO Tarea programada creada exitosamente.
) ELSE (
    ECHO Error al crear la tarea programada.
)

SET "PG_PASSWORD="

ENDLOCAL
