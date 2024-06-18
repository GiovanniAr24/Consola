@echo off
IF NOT EXIST last_backup.txt (
    ECHO No se encontró información del último respaldo.
    EXIT /B
)

:: Leer la ruta del último respaldo
SET /P BK_FILE_RAW=<last_backup.txt

:: Rutina de limpieza para eliminar comillas adicionales
SET "BK_FILE=%BK_FILE_RAW:"=%"

:: Preguntar al usuario si desea usar el último respaldo o proporcionar uno nuevo
ECHO El último archivo de respaldo es: %BK_FILE%
SET /P NEW_BK_FILE_RAW="Ingrese nombre de resplado o presione Enter para usar el último [%BK_FILE%]: "
IF NOT "%NEW_BK_FILE_RAW%"=="" SET "BK_FILE=%NEW_BK_FILE_RAW:"=%"

:: Ver el contenido del archivo de respaldo
ECHO Mostrando contenido del respaldo: %BK_FILE%
pg_restore -l "%BK_FILE%"
