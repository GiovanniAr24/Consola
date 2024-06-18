@echo off
SETLOCAL EnableDelayedExpansion

:: Cambiar la página de códigos para soportar caracteres especiales
CHCP 65001

:: Establecer la ruta de los binarios de PostgreSQL
SET PG_BIN_PATH=C:\Program Files\PostgreSQL\15\bin


:: Solicitar credenciales del superusuario
ECHO Ingrese las credenciales del superusuario para PostgreSQL.
SET SUPER_USER=postgres
SET SUPER_PASSWORD=bd

:MenuMonitoreo
CLS
ECHO ╔════════════════════════════════════════════════════╗
ECHO ║  Menú de Monitoreo de Base de Datos PostgreSQL     ║
ECHO ╠════════════════════════════════════════════════════╣
ECHO ║ 1. Estado de la Base de Datos                      ║
ECHO ║ 2. Usuarios Conectados                             ║
ECHO ║ 3. Estadísticas de Rendimiento                     ║
ECHO ║ 4. Estado de las Conexiones                        ║
ECHO ║ 5. Espacio en Disco Usado por la Base de Datos     ║
ECHO ║ 6. Estado de las Tablas y los Índices              ║
ECHO ║ 7. Consultas Lentas                                ║
ECHO ║ 8. Estadísticas de Uso del Cache                   ║
ECHO ║ 9. Bloqueos de Larga Duración                      ║
ECHO ║ 10. Tamaño de la Base de Datos y sus Tablas        ║
ECHO ║ 11. Vista General del Sistema                      ║
ECHO ║ 12. Rendimiento de las Funciones                   ║
ECHO ║ 13. Salir                                          ║
ECHO ╚════════════════════════════════════════════════════╝
ECHO.

SET /P OPTION="Seleccione una opción: "

IF "%OPTION%"=="1" GOTO EstadoDB
IF "%OPTION%"=="2" GOTO UsuariosConectados
IF "%OPTION%"=="3" GOTO EstadisticasRendimiento
IF "%OPTION%"=="4" GOTO EstadoConexiones
IF "%OPTION%"=="5" GOTO EspacioDisco
IF "%OPTION%"=="6" GOTO EstadoTablasIndices
IF "%OPTION%"=="7" GOTO ConsultasLentas
IF "%OPTION%"=="8" GOTO EstadisticasCache
IF "%OPTION%"=="9" GOTO BloqueosLargaDuracion
IF "%OPTION%"=="10" GOTO TamanoDBTablas
IF "%OPTION%"=="11" GOTO VistaGeneralSistema
IF "%OPTION%"=="12" GOTO RendimientoFunciones
IF "%OPTION%"=="13" GOTO Fin

GOTO MenuMonitoreo

:EstadoDB
ECHO Estado de la Base de Datos:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT datname, pg_size_pretty(pg_database_size(datname)), pg_is_in_recovery() FROM pg_database;"
GOTO Pausa

:UsuariosConectados
ECHO Usuarios Conectados:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT usename, application_name, client_addr, backend_start FROM pg_stat_activity;"
GOTO Pausa

:EstadisticasRendimiento
ECHO Estadísticas de Rendimiento:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT * FROM pg_stat_database;"
GOTO Pausa

:EstadoConexiones
ECHO Estado de las Conexiones:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT count(*) AS total_connections FROM pg_stat_activity;"
GOTO Pausa

:EspacioDisco
ECHO Espacio en Disco Usado por la Base de Datos:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT pg_size_pretty(pg_database_size(current_database()));"
GOTO Pausa

:EstadoTablasIndices
ECHO Estado de las Tablas y los Índices:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT relname, n_tup_ins, n_tup_upd, n_tup_del, idx_scan, seq_scan FROM pg_stat_all_tables WHERE schemaname = 'public';"
GOTO Pausa

:ConsultasLentas
ECHO Consultas Lentas:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT query, calls, total_exec_time, rows, 100.0 * total_exec_time / sum(total_exec_time) OVER () AS percent_total FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;"
GOTO Pausa

:EstadisticasCache
ECHO Estadísticas de Uso del Cache:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT sum(heap_blks_read) as heap_read, sum(heap_blks_hit)  as heap_hit, (sum(heap_blks_hit) - sum(heap_blks_read)) / sum(heap_blks_hit) as ratio FROM pg_statio_user_tables;"
GOTO Pausa

:BloqueosLargaDuracion
ECHO Bloqueos de Larga Duración:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT pid, age(clock_timestamp(), query_start), usename, query FROM pg_stat_activity WHERE state = 'active' AND (clock_timestamp() - query_start) > interval '5 minutes';"
GOTO Pausa

:TamanoDBTablas
ECHO Tamaño de la Base de Datos y sus Tablas:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;"
GOTO Pausa

:VistaGeneralSistema
ECHO Vista General del Sistema:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT version(), current_database(), current_user, pg_postmaster_start_time();"
GOTO Pausa

:RendimientoFunciones
ECHO Rendimiento de las Funciones:
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "SELECT funcname, calls, total_time, self_time FROM pg_stat_user_functions;"
GOTO Pausa

:Pausa
PAUSE
GOTO MenuMonitoreo

:Fin
ECHO Saliendo...
ENDLOCAL
