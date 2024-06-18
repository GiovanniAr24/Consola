@echo off
SET "BK_PATH_RAW=%~1"

:: Rutina de limpieza para eliminar comillas adicionales
SET "BK_PATH=%BK_PATH_RAW:"=%"

:: Listar archivos de respaldo
ECHO Listando respaldos disponibles en %BK_PATH%...
DIR /B "%BK_PATH%\*.backup"
