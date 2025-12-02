--Verify all objects owned by user ESILVAS does exist in the database
SELECT * FROM ALL_OBJECTS
WHERE OWNER = 'IATA_OLAP';

SELECT * FROM ALL_TABLES;

SELECT * FROM IATA.AVIONES;


