-- Verificar conexión a la base de datos
SELECT current_database();

-- Verificar que las tablas existen y tienen datos
SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM categorias
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL
SELECT 'detalle_ventas', COUNT(*) FROM detalle_ventas;


-- Ejercicio 1.1: Seleccionar todos los productos
SELECT * FROM productos;



-- Ejercicio 1.2: Mostrar solo nombre y precio_venta_venta de productos
SELECT nombre, precio_venta FROM productos;

-- Ejercicio 1.3: Usar alias para columnas
SELECT
    nombre AS nombre_producto,
    precio_venta AS precio_unitario,
    stock_actual AS cantidad_disponible
FROM productos;

-- Ejercicio 2.1: Productos caros
SELECT nombre, precio_venta
FROM productos
WHERE precio_venta > 5000;

-- Ejercicio 2.2: Productos en rango de precio_venta
SELECT nombre, precio_venta
FROM productos
WHERE precio_venta BETWEEN 5 AND 50
ORDER BY precio_venta;


-- Ejercicio 2.3: Productos de categorías específicas
SELECT nombre, categoria_id, precio_venta
FROM productos
WHERE categoria_id IN (1, 2, 3);

-- Ejercicio 2.4: Buscar productos que contengan "Arroz"
SELECT nombre, precio_venta
FROM productos
WHERE nombre LIKE '%Arroz%';

-- Ejercicio 2.5: Productos con condiciones múltiples
SELECT nombre, precio_venta, stock_actual
    FROM productos
    WHERE precio_venta < 3000
        AND stock_actual > 0
        AND categoria_id = 1;


-- Actualiza precio, stock

Paso 4

-- Ejercicio 4.1: Contar productos


SELECT *  
FROM productos;

SELECT COUNT(*) AS total_productos
FROM productos;

SELECT COUNT(1) AS total_productos
FROM productos;

SELECT COUNT(observaciones) AS total_productos
FROM productos;

-- Ejercicio 4.2: Precio promedio
SELECT
    AVG(precio_venta) AS precio_promedio,
    ROUND(AVG(precio_venta), 2) AS precio_promedio_redondeado
FROM productos;


-- Ejercicio 4.3: Precios extremos
SELECT
    MAX(precio_venta) AS precio_maximo,
    MIN(precio_venta) AS precio_minimo,
    MAX(precio_venta) - MIN(precio_venta) AS diferencia
FROM productos;


-- Ejercicio 4.4: Valor total del inventario
SELECT
    SUM(precio_venta * stock_actual) AS valor_total_inventario,
    ROUND(SUM(precio_venta * stock_actual), 2) AS valor_redondeado
FROM productos;



-- Paso 5

-- Ejercicio 5.1: Productos por categoría
SELECT
    categoria_id,
    COUNT(*) AS cantidad_productos
FROM productos
GROUP BY categoria_id
ORDER BY cantidad_productos DESC;



-- Ejercicio 5.2: Precio promedio por categoría
SELECT
    c.nombre AS categoria,
    COUNT(p.producto_id) AS total_productos,
    ROUND(AVG(p.precio_venta), 2) AS precio_promedio
FROM categorias c
LEFT JOIN productos p ON c.categoria_id = p.categoria_id
GROUP BY c.categoria_id, c.nombre
ORDER BY precio_promedio DESC;


-- Ejercicio 5.3: Stock por categoría
SELECT
    categoria_id,
    SUM(stock_actual) AS stock_total,
    AVG(stock_actual) AS stock_promedio
FROM productos
GROUP BY categoria_id
ORDER BY stock_total DESC;


-- Ejercicio 5.4: Cantidad de compras por cliente
SELECT
    cliente_id,
    COUNT(*) AS total_compras,
    SUM(total) AS monto_total_gastado
FROM ventas
GROUP BY cliente_id
ORDER BY monto_total_gastado DESC;


-- Ejercicio 5.5: Ventas por día
SELECT
    DATE(fecha) AS fecha_venta,
    COUNT(*) AS numero_ventas,
    SUM(total) AS total_vendido
FROM ventas
GROUP BY DATE(fecha)
ORDER BY fecha_venta DESC;

select * from ventas;

ALTER TABLE ventas
RENAME COLUMN fecha_venta TO fecha;


----------------------------------------
-- Paso 6. Filtrar Grupos con Having
----------------------------------------

-- Ejercicio 6.1: Categorías con muchos productos
SELECT
    categoria_id,
    COUNT(*) AS cantidad_productos
FROM productos
GROUP BY categoria_id
HAVING COUNT(*) >= 2
ORDER BY cantidad_productos DESC;


-- Ejercicio 6.2: Categorías con productos caros
SELECT
    categoria_id,
    ROUND(AVG(precio_venta), 2) AS precio_promedio,
    COUNT(*) AS total_productos
FROM productos
GROUP BY categoria_id
HAVING AVG(precio_venta) > 30
ORDER BY precio_promedio DESC;


-- Ejercicio 6.3: Clientes frecuentes
SELECT
    cliente_id,
    COUNT(*) AS total_compras,
    ROUND(SUM(total), 2) AS monto_total
FROM ventas
GROUP BY cliente_id
HAVING COUNT(*) >= 2
ORDER BY total_compras DESC;


select venta_id, cliente_id from ventas;


-- Ejercicio 6.4: Productos en stock por categoría (filtrado doble)
SELECT
    categoria_id,
    COUNT(*) AS productos_en_stock,
    SUM(stock_actual) AS stock_total
FROM productos
WHERE stock_actual > 0
GROUP BY categoria_id
HAVING SUM(stock_actual) > 1 --100
ORDER BY stock_total DESC;



-- Ejercicio 6.5: Categorías con bajo inventario promedio
SELECT
    categoria_id,
    COUNT(*) AS total_productos,
    ROUND(AVG(stock_actual), 2) AS stock_promedio
FROM productos
GROUP BY categoria_id
HAVING AVG(stock_actual) < 50
ORDER BY stock_promedio ASC;


--------------------------------------------------
-- Paso 7. Funciones de Texto
--------------------------------------------------
-- Ejercicio 7.1: Manipulación de mayúsculas/minúsculas
SELECT
    nombre,
    UPPER(nombre) AS nombre_mayusculas,
    LOWER(nombre) AS nombre_minusculas
FROM productos
LIMIT 10;


-- Ejercicio 7.2: Concatenación
SELECT
    nombre,
    precio_compra,
    CONCAT(nombre, ' - $', precio_compra) AS producto_con_precio,
    nombre || ' (Stock: ' || stock_actual || ')' AS producto_con_stock
FROM productos
LIMIT 10;


-- Ejercicio 7.3: Subcadenas y longitud
SELECT
    nombre,
    LENGTH(nombre) AS longitud,
    SUBSTRING(nombre, 1, 10) AS primeros_10_caracteres,
    LEFT(nombre, 5) AS primeros_5
FROM productos
LIMIT 10;

-- Ejercicio 7.4: Limpieza de espacios
SELECT
    '  ' || nombre || '  ' AS con_espacios,
    TRIM('  ' || nombre || '  ') AS sin_espacios,
    LTRIM('  ' || nombre) AS sin_espacios_izq,
    RTRIM(nombre || '  ') AS sin_espacios_der
FROM productos
LIMIT 5;


-- Ejercicio 7.5: Reemplazo de texto
SELECT
    nombre,
    REPLACE(nombre, 'Arroz', 'ARROZ') AS nombre_modificado,
    POSITION('a' IN LOWER(nombre)) AS posicion_primera_a
FROM productos
WHERE nombre LIKE '%Arroz%';


-------------------------------------------
-- Paso 8. Funciones de Fecha y Hora
-------------------------------------------
-- Ejercicio 8.1: Componentes de fecha
SELECT
    fecha,
    EXTRACT(YEAR FROM fecha) AS año,
    EXTRACT(MONTH FROM fecha) AS mes,
    EXTRACT(DAY FROM fecha) AS dia,
    EXTRACT(DOW FROM fecha) AS dia_semana  -- 0 Domingo
FROM ventas
LIMIT 10;

-- Ejercicio 8.2: Formato de fechas
SELECT
    fecha,
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha_formateada,
    TO_CHAR(fecha, 'Day, DD Month YYYY') AS fecha_texto,
    TO_CHAR(fecha, 'YYYY-MM') AS año_mes
FROM ventas
LIMIT 10;

-- Ejercicio 8.3: Diferencias de fecha
SELECT
    fecha,
    CURRENT_DATE AS fecha_actual,
    CURRENT_DATE - DATE(fecha) AS dias_transcurridos,
    AGE(CURRENT_DATE, DATE(fecha)) AS tiempo_transcurrido
FROM ventas
ORDER BY fecha DESC
LIMIT 10;


-- Ejercicio 8.4: Ventas por mes
SELECT
    TO_CHAR(fecha, 'YYYY-MM') AS año_mes,
    COUNT(*) AS total_ventas,
    ROUND(SUM(total), 2) AS monto_total
FROM ventas
GROUP BY TO_CHAR(fecha, 'YYYY-MM')
ORDER BY año_mes DESC;


-- Ejercicio 8.5: Truncamiento de fechas
SELECT
    DATE_TRUNC('month', fecha) AS inicio_mes,
    COUNT(*) AS ventas_del_mes,
    SUM(total) AS total_mes
FROM ventas
GROUP BY DATE_TRUNC('month', fecha)
ORDER BY inicio_mes DESC;

-- Demos TIMESTAMP
SELECT
    '1995-10-11'::DATE              AS fecha,
    DATE_TRUNC('day', '1995-10-11'::DATE) AS trunc_day;

SELECT
    '1995-10-11 15:45:30',
	DATE_TRUNC('minute', '1995-10-11 15:45:30'::TIMESTAMP) "minute",
    DATE_TRUNC('hour', '1995-10-11 15:45:30'::TIMESTAMP) "hour",
    DATE_TRUNC('day', '1995-10-11 15:45:30'::TIMESTAMP) "day",
	DATE_TRUNC('month', '1995-10-11 15:45:30'::TIMESTAMP) "month",
	DATE_TRUNC('year', '1995-10-11 15:45:30'::TIMESTAMP) "year"	;


-------------------------------------------------------
-- Paso 9. Funciones Matemáticas
--------------------------------------------------------

-- Ejercicio 9.1: Redondeo de números

SELECT
    precio_venta,
    ROUND(precio_venta) AS redondeado,
    ROUND(precio_venta, 1) AS un_decimal,
    CEIL(precio_venta) AS redondeo_superior,
    FLOOR(precio_venta) AS redondeo_inferior
FROM productos
LIMIT 10;


-- POC

SELECT
   '189.9467',
   ROUND ( 189.9467, -2),
   ROUND ( 189.9467, -1),
   ROUND ( 189.9467, 0),
   ROUND ( 189.9467),
   ROUND ( 189.9467, 1),
   ROUND ( 189.9467, 2);


 SELECT
   '189.9467',
   TRUNC ( 189.9467, -2),
   TRUNC ( 189.9467, -1),
   TRUNC ( 189.9467, 0),
   TRUNC ( 189.9467),
   TRUNC ( 189.9467, 1),
   TRUNC ( 189.9467, 2);

-- Ejercicio 9.2: Valores absolutos
SELECT
    precio_venta,
    precio_venta - 5000 AS diferencia,
    ABS(precio_venta - 5000) AS diferencia_absoluta,
    SIGN(precio_venta - 5000) AS signo
FROM productos
LIMIT 10;
 

-- Ejercicio 9.3: Potencias y raíces
SELECT
    stock_actual,
    POWER(stock_actual, 2) AS stock_al_cuadrado,
    SQRT(stock_actual) AS raiz_cuadrada_stock,  -- SQRT devuelve double precision
    ROUND(SQRT(stock_actual)::NUMERIC, 2) AS raiz_redondeada
FROM productos
WHERE stock_actual > 0
LIMIT 10;


-- Ejercicio 9.4: Módulo y división
SELECT
    producto_id,
    precio_venta,
    MOD(precio_venta::INTEGER, 100) AS modulo_100,
    precio_venta / 100 AS division_entera,
    ROUND(precio_venta / 100.0, 2) AS division_decimal
FROM productos
LIMIT 10;


-- Ejercicio 9.5: Números aleatorios
SELECT
    nombre,
    precio_venta,
    RANDOM() AS aleatorio_0_1,
    ROUND(RANDOM() * 100) AS aleatorio_0_100,
    FLOOR(RANDOM() * 10 + 1) AS aleatorio_1_10
FROM productos
LIMIT 10;


-------------------------------------------
-- Paso 10. Consultas Complejas Integradas
-------------------------------------------
-- Ejercicio 10.1: Reporte detallado de productos
SELECT
    UPPER(p.nombre) AS producto,
    c.nombre AS categoria,
    CONCAT('$', ROUND(p.precio_venta, 2)) AS precio_formateado,
    p.stock_actual AS stock_actual,
    CASE
        WHEN p.stock_actual = 0 THEN 'SIN STOCK'
        WHEN p.stock_actual < 20 THEN 'STOCK BAJO'
        WHEN p.stock_actual < 50 THEN 'STOCK MEDIO'
        ELSE 'STOCK ALTO'
    END AS estado_stock,
    ROUND(p.precio_venta * p.stock_actual, 2) AS valor_inventario
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY valor_inventario DESC
LIMIT 20;



-- Ejercicio 10.2: Análisis de ventas
SELECT
    TO_CHAR(v.fecha, 'YYYY-MM') AS periodo,
    COUNT(DISTINCT v.venta_id) AS total_ventas,
    COUNT(DISTINCT v.cliente_id) AS clientes_unicos,
    SUM(v.total) AS monto_total,
    ROUND(AVG(v.total), 2) AS ticket_promedio,
    MAX(v.total) AS venta_maxima,
    MIN(v.total) AS venta_minima
FROM ventas v
GROUP BY TO_CHAR(v.fecha, 'YYYY-MM')
ORDER BY periodo DESC;



-- Ejercicio 10.3: Top productos vendidos
SELECT
    p.nombre AS producto,
    c.nombre AS categoria,
    COUNT(dv.producto_id) AS veces_vendido,
    SUM(dv.cantidad) AS unidades_vendidas,
    ROUND(SUM(dv.subtotal), 2) AS ingresos_generados,
    ROUND(AVG(dv.precio_unitario), 2) AS precio_promedio_venta
FROM detalle_ventas dv
INNER JOIN productos p ON dv.producto_id = p.producto_id
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
GROUP BY p.producto_id, p.nombre, c.nombre
HAVING SUM(dv.cantidad) > 0
ORDER BY unidades_vendidas DESC
LIMIT 15;

select * from detalle_ventas;


-- Ejercicio 10.4: Perfil de clientes
SELECT
    CONCAT(c.nombre, ' ', c.apellido_paterno) AS cliente_completo,
    c.email,
    COUNT(v.cliente_id) AS total_compras,
    ROUND(SUM(v.total), 2) AS gasto_total,
    ROUND(AVG(v.total), 2) AS gasto_promedio,
    MAX(v.fecha) AS ultima_compra,
    CURRENT_DATE - MAX(DATE(v.fecha)) AS dias_sin_comprar,
    CASE
        WHEN COUNT(v.cliente_id) >= 5 THEN 'PREMIUM'
        WHEN COUNT(v.cliente_id) >= 3 THEN 'REGULAR'
        ELSE 'NUEVO'
    END AS tipo_cliente
FROM clientes c
LEFT JOIN ventas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido_paterno, c.email
HAVING COUNT(v.cliente_id) > 0
ORDER BY gasto_total DESC;


select * from ventas;


-- Ejercicio 10.5: Dashboard general

SELECT 'Total Productos' AS metrica,
    COUNT(*)::TEXT AS valor
FROM productos
UNION ALL
SELECT 'Valor Inventario',
    CONCAT('$', ROUND(SUM(precio_venta * stock_actual), 2))
FROM productos
UNION ALL
SELECT 'Total Clientes',
    COUNT(*)::TEXT
FROM clientes
UNION ALL
SELECT 'Total Ventas',
    COUNT(*)::TEXT
FROM ventas
UNION ALL
SELECT 'Ingresos Totales',
    CONCAT('$', ROUND(SUM(total), 2))
FROM ventas
UNION ALL
SELECT 'Ticket Promedio',
    CONCAT('$', ROUND(AVG(total), 2))
FROM ventas;



