--DIM_RUTA_EXT**

SELECT
    i.id_itinerario              AS ID_RUTA,
    c_o.nombre                   AS CIUDAD_ORIGEN,
    a_o.nombre                   AS AEROPUERTO_ORIGEN,
    c_d.nombre                   AS CIUDAD_DESTINO,
    a_d.nombre                   AS AEROPUERTO_DESTINO,
    c_o.nombre || ' - ' || c_d.nombre AS RUTA_COMPLETA
FROM  IATA.ITINERARIOS      i
JOIN  IATA.AEROPUERTOS      a_o ON i.id_aeropuerto_origen  = a_o.id_aeropuerto
JOIN  IATA.CIUDADES         c_o ON a_o.id_ciudad           = c_o.id_ciudad
JOIN  IATA.AEROPUERTOS      a_d ON i.id_aeropuerto_destino = a_d.id_aeropuerto
JOIN  IATA.CIUDADES         c_d ON a_d.id_ciudad           = c_d.id_ciudad
;

--DIM_TIEMPO_EXT**

SELECT
    -- Secuencia 1,2,3,... según la fecha
    ROW_NUMBER() OVER (ORDER BY f)              AS ID_TIEMPO,
    f                                           AS FECHA,
    EXTRACT(YEAR  FROM f)                       AS ANIO,
    CASE 
        WHEN EXTRACT(MONTH FROM f) BETWEEN 1 AND 6 THEN 1 
        ELSE 2 
    END                                         AS SEMESTRE,
    TO_NUMBER(TO_CHAR(f, 'Q'))                  AS TRIMESTRE,
    EXTRACT(MONTH FROM f)                       AS MES,
    TO_CHAR(f, 'fmMonth', 'NLS_DATE_LANGUAGE=SPANISH')
                                                AS NOMBRE_MES,
    EXTRACT(DAY   FROM f)                       AS DIA,
    TO_NUMBER(TO_CHAR(f, 'D'))                  AS DIA_SEMANA,   -- 1=Domingo, 7=Sábado
    TO_CHAR(f, 'fmDay', 'NLS_DATE_LANGUAGE=SPANISH')
                                                AS NOMBRE_DIA
FROM (
    -- Fechas distintas tomadas de los itinerarios
    SELECT DISTINCT TRUNC(fecha_salida)  AS f FROM IATA.ITINERARIOS
    UNION
    SELECT DISTINCT TRUNC(fecha_llegada) AS f FROM IATA.ITINERARIOS
)
ORDER BY f
;

--DIM_CLIENTE**

SELECT
    -- Clave surrogate de la dimensión = cédula numérica
    u.cedula                               AS ID_CLIENTE,
    
    -- Nombre y apellido concatenados
    u.nombre || ' ' || u.apellido          AS NOMBRE_COMPLETO,
    
    -- Email del usuario
    u.email                                AS EMAIL,
    
    -- Nombre de la ciudad de residencia
    c.nombre                               AS CIUDAD_RESIDENCIA
FROM IATA.USUARIOS u
JOIN IATA.CIUDADES c
      ON u.id_ciudad = c.id_ciudad
;

--DIM_MODELO
SELECT
    m.id_modelo  AS ID_MODELO,
    m.nombre     AS NOMBRE_MODELO
FROM IATA.MODELOS m
;

--DIM_AEROLINEA

SELECT
    a.id_aerolinea AS ID_AEROLINEA,
    a.nombre       AS NOMBRE_AEROLINEA
FROM IATA.AEROLINEAS a
;

--FACT_VENTAS_VUELOS_EXT
SELECT 
    ROW_NUMBER() OVER ( 
        ORDER BY v.id_itinerario, v.id_avion, v.id_usuario 
    )                                         AS ID_VENTA, 
    dt.id_tiempo                              AS ID_TIEMPO, 
    i.id_itinerario                           AS ID_RUTA, 
    a.id_aerolinea                            AS ID_AEROLINEA, 
    av.id_modelo                              AS ID_MODELO, 
    TO_NUMBER(u.cedula)                       AS ID_CLIENTE, 
    v.costo                                   AS COSTO, 
    (i.fecha_llegada - i.fecha_salida) * 24   AS DURACION_VUELO_HORAS, 
    COUNT(*) OVER ( 
        PARTITION BY i.id_itinerario, av.id_avion 
    )                                         AS CANTIDAD_PASAJEROS 
FROM IATA.VUELOS        v 
JOIN IATA.ITINERARIOS   i   ON v.id_itinerario = i.id_itinerario 
JOIN IATA.AVIONES       av  ON v.id_avion      = av.id_avion 
JOIN IATA.AEROLINEAS    a   ON av.id_aerolinea = a.id_aerolinea 
JOIN IATA.USUARIOS      u   ON v.id_usuario    = u.cedula 
JOIN DIM_TIEMPO         dt  ON dt.fecha        = TRUNC(i.fecha_salida);

