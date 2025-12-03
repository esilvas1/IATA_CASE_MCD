--------------------------------------------------------
-- Script de Creación del Data Mart (Esquema Estrella)
-- Caso IATA - Gestión de Datos
-- Maestría en Ciencia de Datos
-- Pontificia Universidad Javeriana
-- Fecha: 30 de noviembre de 2025
--------------------------------------------------------
-- IMPORTANTE: Este script debe ejecutarse conectado como usuario IATA_OLAP
--------------------------------------------------------

-- Verificar usuario actual (debe ser IATA_OLAP)
SELECT USER FROM DUAL;

--------------------------------------------------------
-- DISEÑO DEL DATA MART - MODELO ESTRELLA (STAR SCHEMA)
--------------------------------------------------------
-- El Data Mart de Ventas de Vuelos permite análisis multidimensionales
-- sobre las operaciones de reservas y vuelos de aerolíneas
--
-- Arquitectura:
--   - 4 Tablas de Dimensiones (DIM_*)
--   - 1 Tabla de Hechos (FACT_*)
--------------------------------------------------------

--------------------------------------------------------
-- DIMENSIÓN 1: DIM_TIEMPO
--------------------------------------------------------
-- Dimensión temporal para análisis por fecha, mes, año, semestre, trimestre
CREATE TABLE DIM_TIEMPO (
    ID_TIEMPO       NUMBER PRIMARY KEY,
    FECHA           DATE NOT NULL,
    ANIO            NUMBER(4) NOT NULL,
    SEMESTRE        NUMBER(1) NOT NULL,
    TRIMESTRE       NUMBER(1) NOT NULL,
    MES             NUMBER(2) NOT NULL,
    NOMBRE_MES      VARCHAR2(20),
    DIA             NUMBER(2) NOT NULL,
    DIA_SEMANA      NUMBER(1),
    NOMBRE_DIA      VARCHAR2(20)
);

COMMENT ON TABLE DIM_TIEMPO IS 'Dimensión temporal para análisis de ventas de vuelos por fecha';
COMMENT ON COLUMN DIM_TIEMPO.ID_TIEMPO IS 'Clave primaria en formato YYYYMMDD';
COMMENT ON COLUMN DIM_TIEMPO.SEMESTRE IS 'Semestre del año (1=Ene-Jun, 2=Jul-Dic)';
COMMENT ON COLUMN DIM_TIEMPO.TRIMESTRE IS 'Trimestre del año (1-4)';
COMMENT ON COLUMN DIM_TIEMPO.DIA_SEMANA IS 'Día de la semana (1=Domingo, 7=Sábado)';

--------------------------------------------------------
-- DIMENSIÓN 2: DIM_RUTA
--------------------------------------------------------
-- Dimensión de rutas (origen-destino) para análisis geográfico
CREATE TABLE DIM_RUTA (
    ID_RUTA                 NUMBER PRIMARY KEY,
    CIUDAD_ORIGEN           VARCHAR2(50) NOT NULL,
    AEROPUERTO_ORIGEN       VARCHAR2(100) NOT NULL,
    CIUDAD_DESTINO          VARCHAR2(50) NOT NULL,
    AEROPUERTO_DESTINO      VARCHAR2(100) NOT NULL,
    RUTA_COMPLETA           VARCHAR2(200) NOT NULL
);

COMMENT ON TABLE DIM_RUTA IS 'Dimensión de rutas para análisis de origen-destino';
COMMENT ON COLUMN DIM_RUTA.CIUDAD_ORIGEN IS 'Ciudad de origen del vuelo';
COMMENT ON COLUMN DIM_RUTA.CIUDAD_DESTINO IS 'Ciudad de destino del vuelo (ej: Roma, Madrid)';
COMMENT ON COLUMN DIM_RUTA.RUTA_COMPLETA IS 'Concatenación: Ciudad Origen - Ciudad Destino';

--------------------------------------------------------
-- DIMENSIÓN 3: DIM_AEROLINEA
--------------------------------------------------------
-- Dimensión de aerolíneas
CREATE TABLE DIM_AEROLINEA (
    ID_AEROLINEA        NUMBER PRIMARY KEY,
    NOMBRE_AEROLINEA    VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE DIM_AEROLINEA IS 'Dimensión de aerolíneas';
COMMENT ON COLUMN DIM_AEROLINEA.NOMBRE_AEROLINEA IS 'Nombre de la aerolínea (ej: Avianca, Latam, Wingo)';

--------------------------------------------------------
-- DIMENSIÓN 4: DIM_MODELO
--------------------------------------------------------
-- Dimensión de modelos de aviones
CREATE TABLE DIM_MODELO (
    ID_MODELO           NUMBER PRIMARY KEY,
    NOMBRE_MODELO       VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE DIM_MODELO IS 'Dimensión de modelos de avión';
COMMENT ON COLUMN DIM_MODELO.NOMBRE_MODELO IS 'Nombre del modelo (ej: Airbus 320, Boeing 747)';

--------------------------------------------------------
-- DIMENSIÓN 5: DIM_CLIENTE
--------------------------------------------------------
-- Dimensión de clientes/pasajeros para análisis demográfico
CREATE TABLE DIM_CLIENTE (
    ID_CLIENTE          NUMBER PRIMARY KEY,
    CEDULA              VARCHAR2(20) NOT NULL,
    NOMBRE_COMPLETO     VARCHAR2(100) NOT NULL,
    EMAIL               VARCHAR2(100) NOT NULL,
    CIUDAD_RESIDENCIA   VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE DIM_CLIENTE IS 'Dimensión de clientes/pasajeros';
COMMENT ON COLUMN DIM_CLIENTE.CEDULA IS 'Cédula del pasajero';
COMMENT ON COLUMN DIM_CLIENTE.NOMBRE_COMPLETO IS 'Nombre y apellido concatenados';
COMMENT ON COLUMN DIM_CLIENTE.CIUDAD_RESIDENCIA IS 'Ciudad de residencia del pasajero';

--------------------------------------------------------
-- TABLA DE HECHOS: FACT_VENTAS_VUELOS
--------------------------------------------------------
-- Tabla central del modelo estrella con métricas de ventas
CREATE TABLE FACT_VENTAS_VUELOS (
    ID_VENTA                NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_TIEMPO               NUMBER NOT NULL,
    ID_RUTA                 NUMBER NOT NULL,
    ID_AEROLINEA            NUMBER NOT NULL,
    ID_MODELO               NUMBER NOT NULL,
    ID_CLIENTE              NUMBER NOT NULL,
    COSTO                   NUMBER NOT NULL,
    DURACION_VUELO_HORAS    NUMBER(5,2),
    CANTIDAD_PASAJEROS      NUMBER DEFAULT 1,
    
    -- Claves foráneas hacia dimensiones
    CONSTRAINT FK_TIEMPO FOREIGN KEY (ID_TIEMPO) 
        REFERENCES DIM_TIEMPO(ID_TIEMPO),
    CONSTRAINT FK_RUTA FOREIGN KEY (ID_RUTA) 
        REFERENCES DIM_RUTA(ID_RUTA),
    CONSTRAINT FK_AEROLINEA FOREIGN KEY (ID_AEROLINEA) 
        REFERENCES DIM_AEROLINEA(ID_AEROLINEA),
    CONSTRAINT FK_MODELO FOREIGN KEY (ID_MODELO) 
        REFERENCES DIM_MODELO(ID_MODELO),
    CONSTRAINT FK_CLIENTE FOREIGN KEY (ID_CLIENTE) 
        REFERENCES DIM_CLIENTE(ID_CLIENTE)
);

COMMENT ON TABLE FACT_VENTAS_VUELOS IS 'Tabla de hechos con métricas de ventas de vuelos';
COMMENT ON COLUMN FACT_VENTAS_VUELOS.ID_VENTA IS 'Clave primaria autoincremental de cada venta';
COMMENT ON COLUMN FACT_VENTAS_VUELOS.COSTO IS 'Costo del vuelo en pesos colombianos';
COMMENT ON COLUMN FACT_VENTAS_VUELOS.DURACION_VUELO_HORAS IS 'Duración del vuelo en horas';
COMMENT ON COLUMN FACT_VENTAS_VUELOS.CANTIDAD_PASAJEROS IS 'Número de pasajeros (por defecto 1)';

--------------------------------------------------------
-- ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
--------------------------------------------------------

-- Índices en claves foráneas de la tabla de hechos
CREATE INDEX IDX_FACT_TIEMPO ON FACT_VENTAS_VUELOS(ID_TIEMPO);
CREATE INDEX IDX_FACT_RUTA ON FACT_VENTAS_VUELOS(ID_RUTA);
CREATE INDEX IDX_FACT_AEROLINEA ON FACT_VENTAS_VUELOS(ID_AEROLINEA);
CREATE INDEX IDX_FACT_MODELO ON FACT_VENTAS_VUELOS(ID_MODELO);
CREATE INDEX IDX_FACT_CLIENTE ON FACT_VENTAS_VUELOS(ID_CLIENTE);

-- Índices compuestos para análisis multidimensional
CREATE INDEX IDX_FACT_TIEMPO_AEROLINEA ON FACT_VENTAS_VUELOS(ID_TIEMPO, ID_AEROLINEA);
CREATE INDEX IDX_FACT_TIEMPO_MODELO ON FACT_VENTAS_VUELOS(ID_TIEMPO, ID_MODELO);

--------------------------------------------------------
-- VERIFICACIÓN DE TABLAS CREADAS
--------------------------------------------------------

SELECT *
FROM user_tab_comments 
WHERE table_name LIKE 'DIM_%' OR table_name LIKE 'FACT_%'
ORDER BY table_name;

--------------------------------------------------------
-- RESULTADO ESPERADO:
-- Data Mart con esquema estrella creado:
--   - 5 Tablas de Dimensiones (DIM_TIEMPO, DIM_RUTA, DIM_AEROLINEA, DIM_MODELO, DIM_CLIENTE)
--   - 1 Tabla de Hechos (FACT_VENTAS_VUELOS)
--   - 7 Índices para optimización
--
-- Próximo paso: Ejecutar proceso ETL para poblar las tablas
--------------------------------------------------------

PROMPT ==========================================================
PROMPT Data Mart (Esquema Estrella) creado exitosamente
PROMPT Tablas de dimensiones y hechos listas para carga ETL
PROMPT ==========================================================

COMMIT;
