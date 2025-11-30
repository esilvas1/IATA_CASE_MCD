--------------------------------------------------------
-- Script para eliminar TODOS los objetos del schema ESILVAS
-- Conexión: DataManage_MCD
-- ADVERTENCIA: Este script eliminará PERMANENTEMENTE todos los objetos
--------------------------------------------------------

-- 1. Eliminar todas las tablas con CASCADE CONSTRAINTS
BEGIN
   FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'ESILVAS') LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ESILVAS.' || t.table_name || ' CASCADE CONSTRAINTS';
      DBMS_OUTPUT.PUT_LINE('Tabla eliminada: ' || t.table_name);
   END LOOP;
END;
/

-- 2. Eliminar todas las vistas
BEGIN
   FOR v IN (SELECT view_name FROM all_views WHERE owner = 'ESILVAS') LOOP
      EXECUTE IMMEDIATE 'DROP VIEW ESILVAS.' || v.view_name;
      DBMS_OUTPUT.PUT_LINE('Vista eliminada: ' || v.view_name);
   END LOOP;
END;
/

-- 3. Eliminar todas las secuencias
BEGIN
   FOR s IN (SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'ESILVAS') LOOP
      EXECUTE IMMEDIATE 'DROP SEQUENCE ESILVAS.' || s.sequence_name;
      DBMS_OUTPUT.PUT_LINE('Secuencia eliminada: ' || s.sequence_name);
   END LOOP;
END;
/

-- 4. Eliminar todos los procedimientos
BEGIN
   FOR p IN (SELECT object_name FROM all_objects WHERE owner = 'ESILVAS' AND object_type = 'PROCEDURE') LOOP
      EXECUTE IMMEDIATE 'DROP PROCEDURE ESILVAS.' || p.object_name;
      DBMS_OUTPUT.PUT_LINE('Procedimiento eliminado: ' || p.object_name);
   END LOOP;
END;
/

-- 5. Eliminar todas las funciones
BEGIN
   FOR f IN (SELECT object_name FROM all_objects WHERE owner = 'ESILVAS' AND object_type = 'FUNCTION') LOOP
      EXECUTE IMMEDIATE 'DROP FUNCTION ESILVAS.' || f.object_name;
      DBMS_OUTPUT.PUT_LINE('Función eliminada: ' || f.object_name);
   END LOOP;
END;
/

-- 6. Eliminar todos los paquetes
BEGIN
   FOR pk IN (SELECT object_name FROM all_objects WHERE owner = 'ESILVAS' AND object_type = 'PACKAGE') LOOP
      EXECUTE IMMEDIATE 'DROP PACKAGE ESILVAS.' || pk.object_name;
      DBMS_OUTPUT.PUT_LINE('Paquete eliminado: ' || pk.object_name);
   END LOOP;
END;
/

-- 7. Eliminar todos los tipos
BEGIN
   FOR tp IN (SELECT type_name FROM all_types WHERE owner = 'ESILVAS') LOOP
      EXECUTE IMMEDIATE 'DROP TYPE ESILVAS.' || tp.type_name || ' FORCE';
      DBMS_OUTPUT.PUT_LINE('Tipo eliminado: ' || tp.type_name);
   END LOOP;
END;
/

-- 8. Eliminar todos los sinónimos
BEGIN
   FOR sy IN (SELECT synonym_name FROM all_synonyms WHERE owner = 'ESILVAS') LOOP
      EXECUTE IMMEDIATE 'DROP SYNONYM ESILVAS.' || sy.synonym_name;
      DBMS_OUTPUT.PUT_LINE('Sinónimo eliminado: ' || sy.synonym_name);
   END LOOP;
END;
/

-- Verificar que no queden objetos
SELECT object_type, COUNT(*) AS cantidad
FROM all_objects
WHERE owner = 'ESILVAS'
GROUP BY object_type
ORDER BY object_type;

COMMIT;

