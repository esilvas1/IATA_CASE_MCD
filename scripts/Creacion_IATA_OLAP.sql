--------------------------------------------------------
-- Script de Creación del Usuario IATA (OLAP)
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
-- 1. CREAR USUARIO IATA_OLAP
--------------------------------------------------------
-- El usuario IATA_OLAP será el propietario de todas las tablas (OLAP)
-- del sistema de reservas de vuelos

CREATE USER IATA_OLAP IDENTIFIED BY "passIATAOLAP123";

--------------------------------------------------------
-- 2. OTORGAR PRIVILEGIOS BÁSICOS
--------------------------------------------------------

-- Privilegio CONNECT: Permite conectarse a la base de datos
GRANT CONNECT TO IATA_OLAP;

-- Privilegio RESOURCE: Permite crear objetos de base de datos
-- (tablas, vistas, secuencias, procedimientos, etc.)
GRANT RESOURCE TO IATA_OLAP;
--------------------------------------------------------
-- 3. ASIGNAR CUOTA EN TABLESPACE
--------------------------------------------------------

-- Otorga espacio ilimitado en el tablespace USERS
-- Necesario para almacenar las tablas y datos del sistema OLTP
ALTER USER IATA_OLAP QUOTA UNLIMITED ON USERS;

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
WHERE username = 'IATA_OLAP';

--------------------------------------------------------
-- 5. VERIFICAR PRIVILEGIOS OTORGADOS
--------------------------------------------------------

-- Listar privilegios del sistema otorgados al usuario IATA_OLAP
SELECT 
    grantee,
    privilege,
    admin_option
FROM dba_sys_privs 
WHERE grantee = 'IATA_OLAP'
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
WHERE username = 'IATA_OLAP';

--------------------------------------------------------
-- 7. OTORGAR PERMISOS DE LECTURA SOBRE ESQUEMA IATA (OLTP)
--------------------------------------------------------
-- Necesario para que IATA_OLAP pueda leer datos del sistema transaccional
-- durante el proceso ETL (Extracción, Transformación y Carga)

GRANT SELECT ON IATA.AEROLINEAS TO IATA_OLAP;
GRANT SELECT ON IATA.AEROPUERTOS TO IATA_OLAP;
GRANT SELECT ON IATA.AVIONES TO IATA_OLAP;
GRANT SELECT ON IATA.CIUDADES TO IATA_OLAP;
GRANT SELECT ON IATA.ITINERARIOS TO IATA_OLAP;
GRANT SELECT ON IATA.MODELOS TO IATA_OLAP;
GRANT SELECT ON IATA.USUARIOS TO IATA_OLAP;
GRANT SELECT ON IATA.VUELOS TO IATA_OLAP;

--------------------------------------------------------
-- 8. VERIFICAR PERMISOS DE LECTURA OTORGADOS
--------------------------------------------------------

-- Consultar privilegios sobre tablas otorgados a IATA_OLAP
SELECT 
    grantee,
    owner,
    table_name,
    privilege
FROM dba_tab_privs 
WHERE grantee = 'IATA_OLAP'
ORDER BY table_name;

--------------------------------------------------------
-- RESULTADO ESPERADO:
-- Usuario/Esquema IATA_OLAP creado con:
--   - Privilegio CONNECT (conexión a BD)
--   - Privilegio RESOURCE (creación de objetos dimensionales)
--   - Cuota UNLIMITED en tablespace USERS
--   - Permisos SELECT sobre 8 tablas del esquema IATA (OLTP)
--
-- El esquema IATA_OLAP está listo para:
--   1. Crear tablas de dimensiones y hechos (Data Mart)
--   2. Ejecutar queries ETL sobre el esquema IATA
--   3. Poblar el Data Mart con datos del sistema OLTP
--------------------------------------------------------

-- Mensaje de confirmación
PROMPT ==========================================================
PROMPT Usuario/Esquema IATA_OLAP (OLAP) creado exitosamente
PROMPT Permisos de lectura sobre IATA (OLTP) otorgados
PROMPT El sistema está listo para crear el Data Mart dimensional
PROMPT ==========================================================

EXIT;

