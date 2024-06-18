@echo off
SETLOCAL EnableDelayedExpansion

:: Cambiar la página de códigos para soportar caracteres especiales
CHCP 65001

:: Establecer la ruta de los binarios de PostgreSQL
SET PG_BIN_PATH=C:\Program Files\PostgreSQL\15\bin

:Inicio
:: Solicitar credenciales del superusuario
ECHO Ingrese las credenciales del superusuario para PostgreSQL.
SET /P SUPER_USER=Nombre del superusuario: 
SET /P SUPER_PASSWORD=Contraseña del superusuario: 

:: Opciones de acciones
ECHO.
ECHO Elija una acción a realizar:
ECHO 1. Crear un nuevo usuario
ECHO 2. Listar usuarios existentes
SET /P ACTION_OPTION=Elija una acción: 

:: Ejecutar acciones según la opción elegida
IF "%ACTION_OPTION%"=="1" GOTO CrearUsuario
IF "%ACTION_OPTION%"=="2" GOTO ListarUsuarios

GOTO Fin

:CrearUsuario
:: Crear un nuevo usuario
ECHO.
ECHO Crear nuevo usuario de PostgreSQL.
SET /P NEW_USER=Nombre del nuevo usuario: 
SET /P NEW_PASSWORD=Contraseña del nuevo usuario: 

:: Elegir privilegios para el nuevo usuario
ECHO.
ECHO Elija los privilegios para el nuevo usuario:
ECHO 1. Solo lectura
ECHO 2. Lectura y escritura en todas las tablas
ECHO 3. DBA (acceso administrativo limitado)
ECHO 4. Superusuario (acceso completo)
SET /P PRIVILEGE_OPTION=Elija una opción para los privilegios: 

:: Crear el usuario y asignar privilegios
ECHO Creando el nuevo usuario...
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "CREATE USER %NEW_USER% WITH PASSWORD '%NEW_PASSWORD%';"

IF "%PRIVILEGE_OPTION%"=="1" (
    "%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO %NEW_USER%;"
) ELSE IF "%PRIVILEGE_OPTION%"=="2" (
    "%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO %NEW_USER%;"
) ELSE IF "%PRIVILEGE_OPTION%"=="3" (
    "%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "ALTER USER %NEW_USER% WITH CREATEDB;"
) ELSE IF "%PRIVILEGE_OPTION%"=="4" (
    "%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "ALTER USER %NEW_USER% WITH SUPERUSER;"
)

ECHO Nuevo usuario creado con los privilegios seleccionados.
GOTO Fin

:ListarUsuarios
:: Listar usuarios existentes
ECHO.
ECHO Listando usuarios existentes...
"%PG_BIN_PATH%\psql" -h localhost -p 5432 -U %SUPER_USER% -c "\du"
GOTO Fin

:Fin
ECHO Operación completada.
ECHO.
SET /P CONTINUAR="¿Desea realizar otra operación? (S/N): "
IF /I "!CONTINUAR!"=="S" GOTO Inicio
ENDLOCAL
