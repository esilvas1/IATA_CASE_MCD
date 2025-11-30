--------------------------------------------------------
-- Script de Creación del Usuario IATA (OLTP)
-- Caso IATA - Gestión de Datos
-- Maestría en Ciencia de Datos
-- Pontificia Universidad Javeriana
-- Fecha: 30 de noviembre de 2025
--------------------------------------------------------
-- IMPORTANTE: Este script debe ejecutarse como usuario SYS con privilegios SYSDBA
--------------------------------------------------------

-- Verificar usuario actual (debe ser SYS)
SELECT USER FROM DUAL;

--------------------------------------------------------
-- 1. CREAR USUARIO IATA
--------------------------------------------------------
-- El usuario IATA será el propietario de todas las tablas transaccionales (OLTP)
-- del sistema de reservas de vuelos

CREATE USER IATA IDENTIFIED BY "passIATA123";

--------------------------------------------------------
-- 2. OTORGAR PRIVILEGIOS BÁSICOS
--------------------------------------------------------

-- Privilegio CONNECT: Permite conectarse a la base de datos
GRANT CONNECT TO IATA;

-- Privilegio RESOURCE: Permite crear objetos de base de datos
-- (tablas, vistas, secuencias, procedimientos, etc.)
GRANT RESOURCE TO IATA;

--------------------------------------------------------
-- 3. ASIGNAR CUOTA EN TABLESPACE
--------------------------------------------------------

-- Otorga espacio ilimitado en el tablespace USERS
-- Necesario para almacenar las tablas y datos del sistema OLTP
ALTER USER IATA QUOTA UNLIMITED ON USERS;

--------------------------------------------------------
-- 4. VERIFICAR CREACIÓN DEL USUARIO
--------------------------------------------------------

-- Consultar información del usuario creado
SELECT 
    username,
    account_status,
    default_tablespace,
    created
FROM dba_users 
WHERE username = 'IATA';

--------------------------------------------------------
-- 5. VERIFICAR PRIVILEGIOS OTORGADOS
--------------------------------------------------------

-- Listar privilegios del sistema otorgados al usuario IATA
SELECT 
    grantee,
    privilege,
    admin_option
FROM dba_sys_privs 
WHERE grantee = 'IATA'
ORDER BY privilege;

--------------------------------------------------------
-- 6. VERIFICAR CUOTAS ASIGNADAS
--------------------------------------------------------

-- Consultar cuotas en tablespaces
SELECT 
    username,
    tablespace_name,
    max_bytes,
    CASE 
        WHEN max_bytes = -1 THEN 'UNLIMITED'
        ELSE TO_CHAR(max_bytes / 1024 / 1024) || ' MB'
    END AS cuota
FROM dba_ts_quotas
WHERE username = 'IATA';

--------------------------------------------------------
-- RESULTADO ESPERADO:
-- Usuario IATA creado con:
--   - Privilegio CONNECT (conexión a BD)
--   - Privilegio RESOURCE (creación de objetos)
--   - Cuota UNLIMITED en tablespace USERS
--
-- El usuario IATA está listo para ejecutar el script IATA.sql
-- que creará las 8 tablas del sistema OLTP de reservas de vuelos
--------------------------------------------------------

-- Mensaje de confirmación
PROMPT Usuario IATA (OLTP) creado exitosamente
PROMPT El sistema está listo para ejecutar el script IATA.sql

EXIT;
