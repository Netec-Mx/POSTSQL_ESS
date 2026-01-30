-- Conectarse a la base de datos tienda_curso
-- En PgAdmin: clic derecho en tienda_curso > Query Tool

-- Verificar existencia de tablas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Verificar cantidad de registros en cada tabla
SELECT
    'clientes' AS tabla, COUNT(*) AS registros FROM clientes
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'categorias', COUNT(*) FROM categorias
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalle_pedidos', COUNT(*) FROM detalle_pedidos;


---------------------------------------------------------
-- Paso 1. Consultas con INNER JOIN - Análisis de Ventas
---------------------------------------------------------
-- Ejercicio 1: Pedidos con información de clientes
SELECT
    p.pedido_id,
    p.fecha_pedido,
    p.total,
    c.nombre AS cliente_nombre,
    c.email AS cliente_email
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
ORDER BY p.fecha_pedido DESC;


-- Ejercicio 2: Detalle completo de ventas
SELECT
    p.pedido_id,
    p.fecha_pedido,
    c.nombre AS cliente,
    prod.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
INNER JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
INNER JOIN productos prod ON dp.producto_id = prod.producto_id
ORDER BY p.fecha_pedido DESC, p.pedido_id;


-- Ejercicio 3: Ventas totales por categoría
SELECT
    cat.nombre AS categoria,
    COUNT(DISTINCT p.pedido_id) AS total_pedidos,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos_totales
FROM categorias cat
INNER JOIN productos prod ON cat.categoria_id = prod.categoria_id
INNER JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
INNER JOIN pedidos p ON dp.pedido_id = p.pedido_id
GROUP BY cat.categoria_id, cat.nombre
ORDER BY ingresos_totales DESC;


--------------------------------------------------------------
Paso 2. Consultas con LEFT JOIN - Identificar Datos Faltantes
--------------------------------------------------------------

-- Ejercicio 4: Clientes sin pedidos
SELECT
    c.cliente_id,
    c.nombre,
    COALESCE(c.email, 'sin correo'),
    c.fecha_registro,
    COUNT(p.pedido_id) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre, c.email, c.fecha_registro
HAVING COUNT(p.pedido_id) = 0
ORDER BY c.fecha_registro DESC;

-- Ejercicio 5: Productos sin ventas
SELECT
    prod.producto_id,
    prod.nombre,
    prod.precio_venta,
    cat.nombre AS categoria,
    prod.stock_actual
FROM productos prod
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
WHERE dp.detalle_id IS NULL
ORDER BY prod.stock_actual DESC;

-- Ejercicio 6: Categorías con conteo de productos
SELECT
    cat.categoria_id,
    cat.nombre AS categoria,
    cat.descripcion,
    COUNT(prod.producto_id) AS total_productos,
    COALESCE(SUM(prod.stock_actual), 0) AS stock_total
FROM categorias cat
LEFT JOIN productos prod ON cat.categoria_id = prod.categoria_id
GROUP BY cat.categoria_id, cat.nombre, cat.descripcion
ORDER BY total_productos DESC;


--------------------------------------------------------------
-- Paso 3. Consultas con RIGHT JOIN y FULL OUTER JOIN
--------------------------------------------------------------
-- Ejercicio 7: Verificar pedidos sin cliente (no debería haber)
SELECT
    p.pedido_id,
    p.fecha_pedido,
    p.total,
    c.cliente_id,
    c.nombre
FROM clientes c
RIGHT JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE c.cliente_id IS NULL;


-- Ejercicio 8: Comparación completa de productos y ventas
SELECT
    COALESCE(prod.producto_id, dp.producto_id) AS producto_id,
    prod.nombre AS producto_nombre,
    prod.stock_actual,
    COUNT(dp.detalle_id) AS veces_vendido,
    COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas
FROM productos prod
FULL OUTER JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
GROUP BY prod.producto_id, prod.nombre, prod.stock_actual, dp.producto_id
ORDER BY unidades_vendidas DESC;

---------------------------------------------------------------
-- Paso 4. Creación de Vistas para Consultas Recurrentes
---------------------------------------------------------------

-- Ejercicio 9: Vista de ventas completas
CREATE OR REPLACE VIEW vista_ventas_completas AS
SELECT
    p.pedido_id,
    p.fecha_pedido,
    p.estado,
    c.cliente_id,
    c.nombre AS cliente_nombre,
    c.email AS cliente_email,
    prod.producto_id,
    prod.nombre AS producto_nombre,
    cat.nombre AS categoria,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal,
    p.total AS total_pedido
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
INNER JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
INNER JOIN productos prod ON dp.producto_id = prod.producto_id
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id;

-- Probar la vista
SELECT * FROM vista_ventas_completas
ORDER BY fecha_pedido DESC
LIMIT 10;


-- Ejercicio 10: Vista de inventario valorizado
CREATE OR REPLACE VIEW vista_inventario_valorizado AS
SELECT
    prod.producto_id,
    prod.nombre AS producto,
    cat.nombre AS categoria,
    prod.precio_venta,
    prod.stock_actual,
    (prod.precio_venta * prod.stock_actual) AS valor_inventario,
    COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
    COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) AS ingresos_generados
FROM productos prod
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
GROUP BY prod.producto_id, prod.nombre, cat.nombre, prod.precio_venta, prod.stock_actual;

-- Probar la vista
SELECT * FROM vista_inventario_valorizado
ORDER BY valor_inventario DESC;




-- Ejercicio 11: Vista de perfil de clientes
CREATE OR REPLACE VIEW vista_perfil_clientes AS
SELECT
    c.cliente_id,
    c.nombre,
    c.email,
    c.fecha_registro,
    COUNT(DISTINCT p.pedido_id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado,
    COALESCE(AVG(p.total), 0) AS promedio_por_pedido,
    MAX(p.fecha_pedido) AS ultima_compra,
    CASE
        WHEN COUNT(p.pedido_id) = 0 THEN 'Inactivo'
        WHEN COUNT(p.pedido_id) BETWEEN 1 AND 3 THEN 'Ocasional'
        WHEN COUNT(p.pedido_id) BETWEEN 4 AND 10 THEN 'Regular'
        ELSE 'VIP'
    END AS segmento
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre, c.email, c.fecha_registro;

-- Probar la vista
SELECT * FROM vista_perfil_clientes
ORDER BY total_gastado DESC;



----------------------------------------------------------------------
-- Paso 5. Subqueries en Cláusula WHERE
----------------------------------------------------------------------


-- Ejercicio 12: Clientes con pedidos sobre el promedio
SELECT
    c.nombre,
    c.email,
    p.pedido_id,
    p.fecha_pedido,
    p.total
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.total > (
    SELECT AVG(total)
    FROM pedidos
)
ORDER BY p.total DESC;


-- Ejercicio 13: Productos premium por categoría
SELECT
    prod.producto_id,
    prod.nombre,
    cat.nombre AS categoria,
    prod.precio_venta,
    (SELECT AVG(precio_venta)
        FROM productos
        WHERE categoria_id = prod.categoria_id) AS promedio_categoria
FROM productos prod
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
WHERE prod.precio_venta > (
    SELECT AVG(precio_venta)
    FROM productos p2
    WHERE p2.categoria_id = prod.categoria_id
)
ORDER BY cat.nombre, prod.precio_venta DESC;


-- Ejercicio 14: Clientes diversificados (compraron de todas las categorías)
SELECT
    c.cliente_id,
    c.nombre,
    c.email,
    COUNT(DISTINCT cat.categoria_id) AS categorias_compradas
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
INNER JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
INNER JOIN productos prod ON dp.producto_id = prod.producto_id
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
GROUP BY c.cliente_id, c.nombre, c.email
HAVING COUNT(DISTINCT cat.categoria_id) = (
    SELECT COUNT(*) FROM categorias
)
ORDER BY c.nombre;



-- Ejercicio 15: Productos con estadísticas de venta
SELECT
    prod.producto_id,
    prod.nombre,
    prod.precio_venta,
    prod.stock_actual,
    (SELECT COUNT(*)
        FROM detalle_pedidos dp
        WHERE dp.producto_id = prod.producto_id) AS veces_vendido,
    (SELECT COALESCE(SUM(cantidad), 0)
        FROM detalle_pedidos dp
        WHERE dp.producto_id = prod.producto_id) AS unidades_vendidas,
    (SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
        FROM detalle_pedidos dp
        WHERE dp.producto_id = prod.producto_id) AS ingresos_totales
FROM productos prod
ORDER BY ingresos_totales DESC;


-- Ejercicio 16: Análisis de ventas mensuales
SELECT
    ventas_mes.mes,
    ventas_mes.anio,
    ventas_mes.total_pedidos,
    ventas_mes.ingresos_mes,
    ROUND(ventas_mes.ingresos_mes / ventas_mes.total_pedidos, 2) AS ticket_promedio
FROM (
    SELECT
        EXTRACT(MONTH FROM fecha_pedido) AS mes,
        EXTRACT(YEAR FROM fecha_pedido) AS anio,
        COUNT(*) AS total_pedidos,
        SUM(total) AS ingresos_mes
    FROM pedidos
    GROUP BY EXTRACT(YEAR FROM fecha_pedido), EXTRACT(MONTH FROM fecha_pedido)
) AS ventas_mes
ORDER BY ventas_mes.anio, ventas_mes.mes;



-- Ejercicio 17: Comparación de clientes top vs promedio
SELECT
    top_clientes.nombre,
    top_clientes.total_gastado,
    promedios.promedio_general,
    ROUND((top_clientes.total_gastado / promedios.promedio_general - 1) * 100, 2) AS porcentaje_sobre_promedio
FROM (
    SELECT
        c.cliente_id,
        c.nombre,
        SUM(p.total) AS total_gastado
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nombre
    ORDER BY total_gastado DESC
    LIMIT 5
) AS top_clientes
CROSS JOIN (
    SELECT AVG(total_por_cliente) AS promedio_general
    FROM (
        SELECT SUM(total) AS total_por_cliente
        FROM pedidos
        GROUP BY cliente_id
    ) AS totales
) AS promedios
ORDER BY top_clientes.total_gastado DESC;


--------------------------------------------------------------
Paso 7. Operadores de Conjuntos (UNION, INTERSECT, EXCEPT)
--------------------------------------------------------------

-- Ejercicio 18: Lista unificada de contactos (clientes y proveedores simula-dos)
SELECT
    'Cliente' AS tipo,
    cliente_id AS id,
    nombre,
    email 
FROM clientes
UNION
SELECT
    'Producto' AS tipo,
    producto_id AS id,
    nombre,
    'N/A' AS email  
FROM productos
WHERE stock_actual < 20
ORDER BY tipo, nombre;



-- Ejercicio 19: Clientes que compraron en dos períodos específicos
SELECT cliente_id, nombre, email
FROM clientes
WHERE cliente_id IN (
    SELECT cliente_id
    FROM pedidos
    WHERE fecha_pedido BETWEEN '2024-01-01' AND '2024-01-31'
    INTERSECT
    SELECT cliente_id
    FROM pedidos
    WHERE fecha_pedido BETWEEN '2024-02-01' AND '2024-02-28'
)
ORDER BY nombre;

-- Ejercicio 20: Clientes registrados que nunca compraron
SELECT cliente_id, nombre, email, fecha_registro
FROM clientes
EXCEPT
SELECT c.cliente_id, c.nombre, c.email, c.fecha_registro
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
ORDER BY fecha_registro DESC;

--------------------------------------------------------------------
-- Paso 8. Expresiones CASE para Lógica Condicional
--------------------------------------------------------------------
-- Ejercicio 21: Segmentación de productos por precio
SELECT
    producto_id,
    nombre,
    precio_venta,
    CASE
        WHEN precio_venta < 100 THEN 'Económico'
        WHEN precio_venta BETWEEN 100 AND 500 THEN 'Medio'
        WHEN precio_venta BETWEEN 501 AND 2000 THEN 'Premium'
        ELSE 'Lujo'
    END AS segmento_precio,
    stock_actual,
    CASE
        WHEN stock_actual = 0 THEN 'Sin stock'
        WHEN stock_actual < 10 THEN 'Stock crítico'
        WHEN stock_actual < 50 THEN 'Stock bajo'
        ELSE 'Stock adecuado'
    END AS estado_inventario
FROM productos
ORDER BY precio_venta DESC;


-- Ejercicio 22: Segmentación de clientes
SELECT
    c.cliente_id,
    c.nombre,
    COUNT(p.pedido_id) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado,
    CASE
        WHEN COUNT(p.pedido_id) = 0 THEN 'Nuevo/Inactivo'
        WHEN COUNT(p.pedido_id) = 1 THEN 'Primera compra'
        WHEN COUNT(p.pedido_id) BETWEEN 2 AND 5 THEN 'Ocasional'
        WHEN COUNT(p.pedido_id) BETWEEN 6 AND 15 THEN 'Regular'
        ELSE 'VIP'
    END AS tipo_cliente,
    CASE
        WHEN COALESCE(SUM(p.total), 0) = 0 THEN 'Sin valor'
        WHEN COALESCE(SUM(p.total), 0) < 5000 THEN 'Valor bajo'
        WHEN COALESCE(SUM(p.total), 0) < 20000 THEN 'Valor medio'
        WHEN COALESCE(SUM(p.total), 0) < 50000 THEN 'Valor alto'
        ELSE 'Valor premium'
    END AS segmento_valor
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre
ORDER BY total_gastado DESC;




-- Ejercicio 23: KPIs de productos
SELECT
    prod.producto_id,
    prod.nombre,
    prod.precio_venta,
    prod.stock_actual,
    COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
    CASE
        WHEN COALESCE(SUM(dp.cantidad), 0) = 0 THEN 'Sin ventas'
        WHEN COALESCE(SUM(dp.cantidad), 0) < 10 THEN 'Ventas bajas'
        WHEN COALESCE(SUM(dp.cantidad), 0) < 50 THEN 'Ventas normales'
        ELSE 'Best seller'
    END AS indicador_ventas,
    CASE
        WHEN prod.stock_actual = 0 THEN 'Agotado'
        WHEN prod.stock_actual < 10 THEN 'Crítico'
        WHEN prod.stock_actual > 100 THEN 'Sobrestock'
        ELSE 'Normal'
    END AS indicador_stock
FROM productos prod
LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
GROUP BY prod.producto_id, prod.nombre, prod.precio_venta, prod.stock_actual
ORDER BY unidades_vendidas DESC;


--------------------------------------------------------------------
-- Paso 9. Funciones Window - Ranking y Análisis
--------------------------------------------------------------------

-- Ejercicio 24: Ranking de productos más vendidos
SELECT
    prod.producto_id,
    prod.nombre,
    cat.nombre AS categoria,
    COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
    ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC) AS posicion,
    RANK() OVER (ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC) AS ranking,
    DENSE_RANK() OVER (ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC) AS ranking_denso
FROM productos prod
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
GROUP BY prod.producto_id, prod.nombre, cat.nombre
ORDER BY unidades_vendidas DESC
LIMIT 10;



-- Ejercicio 25: Top 3 productos por categoría
WITH productos_rankeados AS (
    SELECT
        prod.producto_id,
        prod.nombre,
        cat.nombre AS categoria,
        prod.precio_venta,
        COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
        ROW_NUMBER() OVER (
            PARTITION BY cat.categoria_id
            ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC
        ) AS ranking_categoria
    FROM productos prod
    INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    GROUP BY prod.producto_id, prod.nombre, cat.nombre, prod.precio_venta, cat.categoria_id
)
SELECT
    categoria,
    ranking_categoria,
    nombre,
    precio_venta,
    unidades_vendidas
FROM productos_rankeados
WHERE ranking_categoria <= 3
ORDER BY categoria, ranking_categoria;

-- Ejercicio 26: Análisis acumulativo de ventas
SELECT
    fecha_pedido::date AS fecha,
    pedido_id,
    total,
    SUM(total) OVER (
        ORDER BY fecha_pedido
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS total_acumulado,
    AVG(total) OVER (
        ORDER BY fecha_pedido
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS promedio_movil_7dias,
    COUNT(*) OVER (
        ORDER BY fecha_pedido
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS pedidos_acumulados
FROM pedidos
ORDER BY fecha_pedido;


------------------------------------------------------------------------
-- Paso 10.  Funciones Window - LAG y LEAD para Análisis Temporal
------------------------------------------------------------------------
-- Ejercicio 27: Comparación de ventas día a día
WITH ventas_diarias AS (
    SELECT
        fecha_pedido::date AS fecha,
        COUNT(*) AS pedidos_dia,
        SUM(total) AS ventas_dia
    FROM pedidos
    GROUP BY fecha_pedido::date
)
SELECT
    fecha,
    pedidos_dia,
    ventas_dia,
    LAG(ventas_dia, 1) OVER (ORDER BY fecha) AS ventas_dia_anterior,
    ventas_dia - LAG(ventas_dia, 1) OVER (ORDER BY fecha) AS diferencia,
    ROUND(
        (ventas_dia - LAG(ventas_dia, 1) OVER (ORDER BY fecha)) /
        NULLIF(LAG(ventas_dia, 1) OVER (ORDER BY fecha), 0) * 100,
        2
    ) AS porcentaje_cambio
FROM ventas_diarias
ORDER BY fecha;



-- Ejercicio 28: Análisis de brechas de precio
SELECT
    producto_id,
    nombre,
    precio_venta,
    LEAD(precio_venta, 1) OVER (ORDER BY precio_venta DESC) AS siguiente_precio,
    precio_venta - LEAD(precio_venta, 1) OVER (ORDER BY precio_venta DESC) AS brecha_precio,
    LAG(nombre, 1) OVER (ORDER BY precio_venta DESC) AS producto_mas_caro,
    LEAD(nombre, 1) OVER (ORDER BY precio_venta DESC) AS producto_mas_barato
FROM productos
ORDER BY precio_venta DESC;


-- Ejercicio 29: Análisis de frecuencia de compra, ERROR la diferencia de fechas es de tiopo INTERVAL
WITH compras_cliente AS (
    SELECT
        c.cliente_id,
        c.nombre,
        p.pedido_id,
        p.fecha_pedido,
        p.total,
        LAG(p.fecha_pedido, 1) OVER (
            PARTITION BY c.cliente_id
            ORDER BY p.fecha_pedido
        ) AS fecha_compra_anterior
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
)
SELECT
    cliente_id,
    nombre,
    pedido_id,
    fecha_pedido,
    fecha_compra_anterior::Date,
    fecha_pedido - fecha_compra_anterior AS dias_entre_compras,
    CASE
        WHEN fecha_pedido - fecha_compra_anterior IS NULL THEN 'Primera com-pra'
        WHEN fecha_pedido - fecha_compra_anterior <= 7 THEN 'Comprador frecuente'
        WHEN fecha_pedido - fecha_compra_anterior <= 30 THEN 'Comprador regu-lar'
        WHEN fecha_pedido - fecha_compra_anterior <= 90 THEN 'Comprador ocasional'
        ELSE 'Comprador esporádico'
    END AS frecuencia
FROM compras_cliente
ORDER BY cliente_id, fecha_pedido;



WITH compras_cliente AS (
    SELECT
        c.cliente_id,
        c.nombre,
        p.pedido_id,
        p.fecha_pedido,
        p.total,
        LAG(p.fecha_pedido) OVER (
            PARTITION BY c.cliente_id
            ORDER BY p.fecha_pedido
        ) AS fecha_compra_anterior
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
)
SELECT
    cliente_id,
    nombre,
    pedido_id,
    fecha_pedido,
    fecha_compra_anterior,
    EXTRACT(DAY FROM (fecha_pedido - fecha_compra_anterior)) AS dias_entre_compras,
    CASE
        WHEN fecha_compra_anterior IS NULL THEN 'Primera compra'
        WHEN EXTRACT(DAY FROM (fecha_pedido - fecha_compra_anterior)) <= 7
            THEN 'Comprador frecuente'
        WHEN EXTRACT(DAY FROM (fecha_pedido - fecha_compra_anterior)) <= 30
            THEN 'Comprador regular'
        WHEN EXTRACT(DAY FROM (fecha_pedido - fecha_compra_anterior)) <= 90
            THEN 'Comprador ocasional'
        ELSE 'Comprador esporádico'
    END AS frecuencia
FROM compras_cliente
ORDER BY cliente_id, fecha_pedido;



WITH compras_cliente AS (
    SELECT
        c.cliente_id,
        c.nombre,
        p.pedido_id,
        p.fecha_pedido,
        p.total,
        EXTRACT(
            DAY FROM (p.fecha_pedido - 
            LAG(p.fecha_pedido) OVER (
                PARTITION BY c.cliente_id
                ORDER BY p.fecha_pedido
            ))
        ) AS dias_entre_compras
    FROM clientes c
    JOIN pedidos p ON c.cliente_id = p.cliente_id
)
SELECT *,
    CASE
        WHEN dias_entre_compras IS NULL THEN 'Primera compra'
        WHEN dias_entre_compras <= 7 THEN 'Comprador frecuente'
        WHEN dias_entre_compras <= 30 THEN 'Comprador regular'
        WHEN dias_entre_compras <= 90 THEN 'Comprador ocasional'
        ELSE 'Comprador esporádico'
    END AS frecuencia
FROM compras_cliente
ORDER BY cliente_id, fecha_pedido;



-------------------------------------------------------------------
-- Paso 11. Common Table Expressions (CTEs) - Consultas Complejas
-------------------------------------------------------------------


