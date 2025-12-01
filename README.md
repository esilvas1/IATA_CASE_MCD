# Caso IATA - Gestión de Datos

| **Información del Proyecto** | |
|:---|---:|
| **Maestría:** Ciencia de Datos<br>**Universidad:** Pontificia Universidad Javeriana<br>**Materia:** Gestión de Datos<br>**Estudiantes:** Edwin Silva Salas, Carlos Preciado Cárdenas, Cristian Restrepo Zapata<br>**Fecha de inicio:** Noviembre 2025 | <img src="https://raw.githubusercontent.com/esilvas1/IATA_CASE_MCD/main/images/pontificia-universidad-logo.png" alt="Logo Pontificia Universidad Javeriana" width="120"/> |


## Descripción del proyecto

Este proyecto corresponde al **Caso IATA** de la materia Gestión de Datos, en el cual se trabaja con una base de datos relacional de un sistema de reservas y vuelos de aerolíneas. El objetivo principal es realizar operaciones de gestión de datos, análisis y potencialmente crear un **Data Mart** para facilitar consultas analíticas sobre el negocio de vuelos.


## Objetivos del Proyecto

1. **Configurar la base de datos transaccional IATA** con las tablas y datos proporcionados
2. **Realizar consultas y análisis** sobre los datos de vuelos, usuarios, aerolíneas e itinerarios
3. **Diseñar e implementar un Data Mart dimensional** (Star Schema) para análisis de negocio
4. **Generar reportes y métricas** clave del negocio de aerolíneas
5. **Visualizar la información** interactiva y dinamica para la toma de decisiones 


## Modelo de Datos - Base Transaccional (OLTP)

La base de datos IATA contiene las siguientes entidades:

### Tablas Principales

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| **AEROLINEAS** | Aerolíneas disponibles (Avianca, Latam, Wingo) | 3 |
| **MODELOS** | Modelos de aviones (Airbus 320, Boeing 747) | 2 |
| **AVIONES** | Flota de aviones de cada aerolínea | 10 |
| **CIUDADES** | Ciudades origen/destino de los vuelos | 12 |
| **AEROPUERTOS** | Aeropuertos internacionales | 12 |
| **ITINERARIOS** | Rutas y horarios de vuelos | 35 |
| **USUARIOS** | Pasajeros registrados en el sistema | 20 |
| **VUELOS** | Reservas y compras de vuelos (Fact table) | 170 |


## Proceso de Implementación (OLTP)

### Fase 1: Preparación del Entorno 
- [x] Configurar conexión a Oracle Database local del estudiante
- [x] Crear usuario IATA en la base de datos local
- [x] Otorgar privilegios básicos al usuario IATA
- [x] Preparar scripts de eliminación y verificación

#### Detalles de Configuración Inicial

Como primera actividad del caso, se procedió a crear el **usuario IATA** en la base de datos Oracle local del computador del estudiante. Esta decisión se tomó debido a que el script `IATA.sql` proporcionado como material de la actividad utiliza la nomenclatura `IATA.OBJECT` para todos los objetos de base de datos (tablas, constraints, índices, etc.).

**Pasos ejecutados:**

1. **Conexión como usuario SYS**: Se estableció conexión a la base de datos local utilizando el usuario administrador SYS con rol SYSDBA
2. **Creación del usuario IATA**: Se ejecutó el comando `CREATE USER IATA` con contraseña segura
3. **Asignación de privilegios**: Se otorgaron los privilegios básicos necesarios:
   - `CONNECT`: Para conectarse a la base de datos
   - `RESOURCE`: Para crear objetos (tablas, vistas, secuencias, etc.)
   - `QUOTA UNLIMITED ON USERS`: Para utilizar espacio ilimitado en el tablespace USERS

```sql
-- Comandos ejecutados como SYS
CREATE USER IATA IDENTIFIED BY "passIATA123";
GRANT CONNECT, RESOURCE TO IATA;
ALTER USER IATA QUOTA UNLIMITED ON USERS;
```

### Fase 2: Carga de Datos Fuente
- [x] Ejecutar script `IATA.sql` para crear las tablas transaccionales
- [x] Verificar la carga de datos (170 vuelos, 20 usuarios, 35 itinerarios)
- [x] Validar integridad referencial y constraints

#### Ejecución del Script IATA.sql

Posterior a la creación del usuario IATA, se procedió a ejecutar el script **`IATA.sql`** proporcionado como insumo de la actividad. Este script contiene:

- **8 tablas del modelo relacional**: AEROLINEAS, AEROPUERTOS, AVIONES, CIUDADES, ITINERARIOS, MODELOS, USUARIOS, VUELOS
- **Inserción de datos de prueba**: 170 registros de vuelos, 20 usuarios, 35 itinerarios, 12 ciudades, entre otros
- **Constraints y Foreign Keys**: Definición completa de integridad referencial
- **Índices únicos**: Para optimización de consultas

**Resultado de la ejecución:**
El script se ejecutó **con cero errores**, creando exitosamente toda la estructura de base de datos y cargando los datos en el schema IATA

## Proceso de Implementación (OLAP)

### Fase 1: Preparación del Entorno OLAP
- [x] Crear esquema IATA_OLAP en la base de datos
- [x] Otorgar privilegios básicos al esquema OLAP
- [x] Configurar permisos de lectura sobre esquema OLTP (IATA)
- [x] Validar conectividad entre esquemas

#### Detalles de Creación del Esquema OLAP

Para implementar una arquitectura de datos robusta y siguiendo las mejores prácticas de separación entre sistemas transaccionales (OLTP) y analíticos (OLAP), se procedió a crear un **esquema independiente llamado IATA_OLAP** que albergará el Data Mart dimensional.

**Justificación arquitectónica:**

La separación de esquemas OLTP y OLAP permite:
- **Independencia operacional**: Las consultas analíticas no afectan el rendimiento transaccional
- **Seguridad por capas**: Control de acceso diferenciado entre operaciones y análisis
- **Optimización específica**: Cada esquema puede optimizarse para su propósito (escritura vs lectura)
- **Mantenibilidad**: Cambios en el modelo dimensional no impactan el sistema operacional

**Pasos ejecutados (ver script completo en [`Creacion_IATA_OLAP.sql`](https://github.com/esilvas1/IATA_CASE_MCD/blob/main/scripts/Creacion_IATA_OLAP.sql)):**

1. **Conexión como usuario SYS**: Se estableció conexión con privilegios SYSDBA
2. **Creación del esquema IATA_OLAP**:
   ```sql
   CREATE USER IATA_OLAP IDENTIFIED BY "passIATAOLAP123";
   ```

3. **Asignación de privilegios básicos**:
   ```sql
   GRANT CONNECT, RESOURCE TO IATA_OLAP;
   ALTER USER IATA_OLAP QUOTA UNLIMITED ON USERS;
   GRANT CREATE MATERIALIZED VIEW TO IATA_OLAP;
   ```
   - `CONNECT`: Permite conectarse a la base de datos
   - `RESOURCE`: Permite crear objetos dimensionales (tablas, vistas, procedimientos)
   - `QUOTA UNLIMITED`: Espacio ilimitado en tablespace USERS
   - `CREATE MATERIALIZED VIEW`: Para crear vistas materializadas (opcional para optimización)

4. **Configuración de permisos de lectura sobre IATA (OLTP)**:
   ```sql
   GRANT SELECT ON IATA.AEROLINEAS TO IATA_OLAP;
   GRANT SELECT ON IATA.AEROPUERTOS TO IATA_OLAP;
   GRANT SELECT ON IATA.AVIONES TO IATA_OLAP;
   GRANT SELECT ON IATA.CIUDADES TO IATA_OLAP;
   GRANT SELECT ON IATA.ITINERARIOS TO IATA_OLAP;
   GRANT SELECT ON IATA.MODELOS TO IATA_OLAP;
   GRANT SELECT ON IATA.USUARIOS TO IATA_OLAP;
   GRANT SELECT ON IATA.VUELOS TO IATA_OLAP;
   ```
   Estos permisos son esenciales para que el proceso ETL pueda extraer datos del sistema transaccional.

5. **Verificación de la configuración**:
   - Se validó la creación del usuario/esquema
   - Se verificaron los privilegios otorgados
   - Se comprobaron las cuotas asignadas en tablespace

**Arquitectura resultante:**

```
┌─────────────────┐         ETL         ┌─────────────────┐
│  Esquema IATA   │  ────────────────>  │ Esquema         │
│     (OLTP)      │   SELECT Grants     │  IATA_OLAP      │
│                 │                     │     (OLAP)      │
│ - AEROLINEAS    │                     │                 │
│ - AEROPUERTOS   │                     │ [Por crear:]    │
│ - AVIONES       │                     │ - DIM_TIEMPO    │
│ - CIUDADES      │                     │ - DIM_RUTA      │
│ - ITINERARIOS   │                     │ - DIM_AEROLINEA │
│ - MODELOS       │                     │ - DIM_CLIENTE   │
│ - USUARIOS      │                     │ - FACT_VENTAS   │
│ - VUELOS        │                     │                 │
└─────────────────┘                     └─────────────────┘
    170 registros                        Data Mart dimensional
```

**Resultado:**
El esquema IATA_OLAP se creó exitosamente con todos los privilegios necesarios y permisos de lectura configurados sobre las tablas del esquema IATA (OLTP). El sistema está listo para iniciar el diseño y carga del Data Mart.

### Fase 2: Diseño del Data Mart (Pendiente)
- [ ] Crear tablas de dimensiones (Tiempo, Ruta, Aerolínea, Cliente)
- [ ] Crear tabla de hechos (Ventas de Vuelos)
- [ ] Implementar proceso ETL para poblar el Data Mart

### Fase 2: Análisis y Reporting (Pendiente)
- [ ] Desarrollar consultas analíticas clave
- [ ] Generar reportes de negocio
- [ ] Documentar insights y hallazgos

---

## Data Mart Propuesto (Star Schema)

Se ha diseñado un **Data Mart de Ventas de Vuelos** con el siguiente modelo dimensional:

### Tablas de Dimensiones

- **DM_TIEMPO**: Dimensión temporal (fecha, año, mes, trimestre, día de la semana)
- **DM_RUTA**: Rutas origen-destino con información de ciudades y aeropuertos
- **DM_AEROLINEA**: Información de aerolíneas y modelos de aviones
- **DM_CLIENTE**: Datos demográficos de los pasajeros

### Tabla de Hechos

- **HECHO_VENTAS_VUELOS**: Métricas de ventas (costo, duración, cantidad de pasajeros)

### Métricas Clave del Negocio

- **Ingresos totales por aerolínea**
- **Rutas más rentables**
- **Tendencias de ventas por mes/trimestre**
- **Análisis de clientes por ciudad**
- **Duración promedio de vuelos**

---

## Autores

**Estudiante:** Edwin Silva Salas, Carlos Preciado Cárdenas, Cristian Restrepo Zapata       
**Programa:** Maestría en Ciencia de Datos  
**Universidad:** Pontificia Universidad Javeriana  
**Repositorio:** [IATA_CASE_MCD](https://github.com/esilvas1/IATA_CASE_MCD)

