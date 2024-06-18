@echo off
SETLOCAL EnableDelayedExpansion
CHCP 65001

:: Nombre común en las tareas de respaldo programado
SET "TASK_NAME_KEYWORD=RespaldoProgramado"

:: Obtener y mostrar las tareas programadas
schtasks /query /fo table /v | findstr /i "%TASK_NAME_KEYWORD%"

ENDLOCAL
