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

-- Mensaje de confirmación
PROMPT Usuario IATA_OLAP (OLAP) creado exitosamente
PROMPT El sistema está listo para ejecutar el script IATA_OLAP.sql

