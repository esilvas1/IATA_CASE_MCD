# Caso IATA - Gestión de Datos

**Maestría:** Ciencia de Datos  
**Universidad:** Pontificia Universidad Javeriana  
**Materia:** Gestión de Datos  
**Estudiantes:** Edwin Silva Salas, Carlos Preciado Cárdenas, Cristian Restrepo Zapata  
**Fecha de inicio:** Noviembre 2025


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


### Fase 1: Diseño del Data Mart (Pendiente)
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

