 

# Práctica 6.1 Ejercicios aplicados a la base de datos del curso

<br/><br/>

## Duración	

30 minutos

<br/><br/>


## Objetivos

Al completar este laboratorio, serás capaz de:

* Implementar `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` y `FULL OUTER JOIN` para combinar datos de múltiples tablas
* Crear vistas (`VIEW`) para simplificar consultas complejas recurrentes
* Escribir consultas anidadas y `subqueries` en `SELECT`, `WHERE` y `FROM`
* Aplicar operadores de conjuntos: `UNION`, `INTERSECT`, `EXCEPT`
* Utilizar `SELECT CASE` para lógica condicional en consultas
* Implementar funciones que retornan conjuntos (`generate_series`, `unnest`)
* Aplicar funciones window (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`) para análisis
* Crear `Common Table Expressions` (`WITH clause`) para consultas complejas


<br/><br/>

## Prerrequisitos

### Conocimientos Requeridos

* Dominio completo de `SELECT` básico con `WHERE`, `ORDER BY`, `GROUP BY` y `HAVING`
* Comprensión de relaciones entre tablas (claves primarias y foráneas)
* Familiaridad con funciones de agregación (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
* Conocimiento de la estructura de la base de datos `tienda_curso` creada en `Lab 03-00-01`
* Experiencia con operaciones `DML` básicas (`INSERT`, `UPDATE`, `DELETE`)

### Acceso Requerido

* `PostgreSQL 18` instalado y funcionando
* `PgAdmin 4` configurado y conectado
* Base de datos `tienda_curso` con datos insertados (`Labs 03-00-01` y `05-00-01` completados)
* Usuario con permisos de lectura y escritura sobre la base de datos


### Entorno de Laboratorio

#### Requisitos de Hardware

| Componente       | Especificación                       |
| ---------------- | ------------------------------------ |
| RAM              | Mínimo 4 GB (recomendado 8 GB)       |
| Procesador       | 64-bit (x86-64 o compatible)         |
| Espacio en Disco | 500 MB libres para datos adicionales |
| Pantalla         | Resolución mínima 1280x720           |


#### Requisitos de Software

| Software      | Versión                            | Propósito                                                    |
| ------------- | ---------------------------------- | ------------------------------------------------------------ |
| PostgreSQL    | 18.x                               | Motor de base de datos para ejecutar consultas SQL avanzadas |
| PgAdmin       | 4.x (compatible con PostgreSQL 18) | Interfaz gráfica para escribir y ejecutar consultas          |
| Windows       | 10 o 11 (64-bit)                   | Sistema operativo base                                       |
| Navegador Web | Chrome 90+, Firefox 88+, Edge 90+  | Para interfaz de PgAdmin                                     |



#### Configuración Inicial

Verificación de la base de datos:

```sql
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
```

<br/><br/>

## Instrucciones

### Paso 1. Consultas con INNER JOIN - Análisis de Ventas

Combinar datos de múltiples tablas usando INNER JOIN para obtener información completa de ventas.

1.	Ejecuta una consulta que muestre todos los pedidos con información del cliente:

    ```sql
    -- Ejercicio 1: Pedidos con información de clientes
    SELECT
        p.pedido_id,
        p.fecha_pedido,
        p.total,
        c.nombre AS cliente_nombre,
        c.email AS cliente_email,
        c.ciudad
    FROM pedidos p
    INNER JOIN clientes c ON p.cliente_id = c.cliente_id
    ORDER BY p.fecha_pedido DESC;
    ```

<br/><br/>

2.	Crea una consulta que muestre el detalle completo de ventas (pedido, producto, cliente):

    ```sql
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
    ```

<br/><br/>

3.	Obtén las ventas por categoría de producto:

    ```sql
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
    ```

<br/><br/>

#### Resultado Esperado:
```sql
categoria          | total_pedidos | unidades_vendidas | ingresos_totales
-------------------+---------------+-------------------+-----------------
Electrónica        |             5 |                15 |         45000.00
Ropa               |             3 |                12 |          3600.00
Alimentos          |             4 |                20 |          1200.00
```

#### Verificación:
•	Los totales de ingresos_totales deben coincidir con los datos insertados
•	Todas las categorías con productos vendidos deben aparecer
•	No debe haber valores NULL en ninguna columna

<br/><br/>

### Paso 2. Consultas con LEFT JOIN - Identificar Datos Faltantes

Utilizar LEFT JOIN para identificar registros sin coincidencias en tablas relacionadas.

1.	Encuentra clientes que no han realizado pedidos:
    ```sql
    -- Ejercicio 4: Clientes sin pedidos
    SELECT
        c.cliente_id,
        c.nombre,
        c.email,
        c.fecha_registro,
        COUNT(p.pedido_id) AS total_pedidos
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nombre, c.email, c.fecha_registro
    HAVING COUNT(p.pedido_id) = 0
    ORDER BY c.fecha_registro DESC;
    ```

<br/><br/>

2.	Identifica productos que nunca se han vendido:
    ```sql
    -- Ejercicio 5: Productos sin ventas
    SELECT
        prod.producto_id,
        prod.nombre,
        prod.precio,
        cat.nombre AS categoria,
        prod.stock
    FROM productos prod
    INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    WHERE dp.detalle_id IS NULL
    ORDER BY prod.stock DESC;
    ```

<br/><br/>

3.	Lista todas las categorías con el conteo de productos (incluyendo catego-rías sin productos):
    ```sql
    -- Ejercicio 6: Categorías con conteo de productos
    SELECT
        cat.categoria_id,
        cat.nombre AS categoria,
        cat.descripcion,
        COUNT(prod.producto_id) AS total_productos,
        COALESCE(SUM(prod.stock), 0) AS stock_total
    FROM categorias cat
    LEFT JOIN productos prod ON cat.categoria_id = prod.categoria_id
    GROUP BY cat.categoria_id, cat.nombre, cat.descripcion
    ORDER BY total_productos DESC;
    ```

<br/><br/>

#### Resultado Esperado:

```sql
categoria_id | categoria    | descripcion              | total_productos | stock_total
-------------+--------------+--------------------------+-----------------+-------------
1            | Electrónica  | Dispositivos y gadgets   |               5 |         150
2            | Ropa         | Vestimenta y accesorios  |               8 |         320
4            | Libros       | Literatura y educación   |               0 |           0
```

#### Verificación:

* Las categorías sin productos deben mostrar `0` en `total_productos`
* Los clientes sin pedidos deben tener `total_pedidos = 0`
* `COALESCE` debe evitar valores `NULL` en `stock_total`


<br/><br/>

### Paso 3. Consultas con RIGHT JOIN y FULL OUTER JOIN
Aplicar RIGHT JOIN y FULL OUTER JOIN para análisis bidireccional de datos.
 
1.	Usa RIGHT JOIN para verificar integridad referencial inversa:
    ```sql
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
    ```

<br/><br/>

2.	Implementa FULL OUTER JOIN para comparar dos conjuntos de datos:
    ```sql
    -- Ejercicio 8: Comparación completa de productos y ventas
    SELECT
        COALESCE(prod.producto_id, dp.producto_id) AS producto_id,
        prod.nombre AS producto_nombre,
        prod.stock,
        COUNT(dp.detalle_id) AS veces_vendido,
        COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas
    FROM productos prod
    FULL OUTER JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    GROUP BY prod.producto_id, prod.nombre, prod.stock, dp.producto_id
    ORDER BY unidades_vendidas DESC;
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 7 debe retornar 0 filas (integridad correcta)

-- Ejercicio 8:
producto_id | producto_nombre      | stock | veces_vendido | unidades_vendidas
------------+----------------------+-------+---------------+-------------------
15          | Laptop Dell XPS      |    25 |             8 |                45
23          | Camiseta Nike        |    80 |             5 |                30
7           | Mouse Inalámbrico    |   100 |             0 |                 0
```

#### Verificación:

* El ejercicio `7` debe retornar `0` filas si la integridad referencial es correcta
* `FULL OUTER JOIN` debe incluir productos vendidos y no vendidos
* `COALESCE` debe manejar correctamente los valores `NULL`

<br/><br/>

### Paso 4. Creación de Vistas para Consultas Recurrentes
Crear vistas que encapsulen consultas complejas para simplificar su uso futuro.
 
1.	Crea una vista con información completa de ventas:
    ```sql
    -- Ejercicio 9: Vista de ventas completas
    CREATE OR REPLACE VIEW vista_ventas_completas AS
    SELECT
        p.pedido_id,
        p.fecha_pedido,
        p.estado,
        c.cliente_id,
        c.nombre AS cliente_nombre,
        c.email AS cliente_email,
        c.ciudad AS cliente_ciudad,
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
    ```

<br/><br/>

2.	Crea una vista de inventario valorizado:
    ```sql
    -- Ejercicio 10: Vista de inventario valorizado
    CREATE OR REPLACE VIEW vista_inventario_valorizado AS
    SELECT
        prod.producto_id,
        prod.nombre AS producto,
        cat.nombre AS categoria,
        prod.precio,
        prod.stock,
        (prod.precio * prod.stock) AS valor_inventario,
        COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
        COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) AS ingresos_generados
    FROM productos prod
    INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    GROUP BY prod.producto_id, prod.nombre, cat.nombre, prod.precio, prod.stock;

    -- Probar la vista
    SELECT * FROM vista_inventario_valorizado
    ORDER BY valor_inventario DESC;
    ```

<br/><br/>

3.	Crea una vista de clientes con estadísticas de compra:
    ```sql
    -- Ejercicio 11: Vista de perfil de clientes
    CREATE OR REPLACE VIEW vista_perfil_clientes AS
    SELECT
        c.cliente_id,
        c.nombre,
        c.email,
        c.ciudad,
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
    GROUP BY c.cliente_id, c.nombre, c.email, c.ciudad, c.fecha_registro;

    -- Probar la vista
    SELECT * FROM vista_perfil_clientes
    ORDER BY total_gastado DESC;
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Vista creada exitosamente
CREATE VIEW

-- Al consultar vista_perfil_clientes:
cliente_id | nombre           | total_pedidos | total_gastado | segmento
-----------+------------------+---------------+---------------+----------
5          | Ana Martínez     |            12 |     85000.00  | VIP
3          | Carlos López     |             5 |     32000.00  | Regular
8          | María González   |             0 |         0.00  | Inactivo
```


#### Verificación:

* Las vistas deben crearse sin errores
* Las consultas `SELECT` sobre las vistas deben retornar datos correctos
* Verifica que las vistas aparezcan en `PgAdmin`: `Schemas > public > Views`


<br/><br/>

### Paso 5. Subqueries en Cláusula WHERE
Utilizar subqueries para filtrar resultados basados en condiciones complejas.
 
1.	Encuentra clientes con pedidos superiores al promedio:
    ```sql
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
    ```

<br/><br/>

2.	Lista productos más caros que el promedio de su categoría:
    ```sql
    -- Ejercicio 13: Productos premium por categoría
    SELECT
        prod.producto_id,
        prod.nombre,
        cat.nombre AS categoria,
        prod.precio,
        (SELECT AVG(precio)
            FROM productos
            WHERE categoria_id = prod.categoria_id) AS promedio_categoria
    FROM productos prod
    INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    WHERE prod.precio > (
        SELECT AVG(precio)
        FROM productos p2
        WHERE p2.categoria_id = prod.categoria_id
    )
    ORDER BY cat.nombre, prod.precio DESC;
    ```

<br/><br/>

3.	Encuentra clientes que han comprado productos de todas las categorías:
    ```sql
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
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 12:
nombre           | email                | pedido_id | total
-----------------+----------------------+-----------+----------
Ana Martínez     | ana@email.com        |       105 | 25000.00
Carlos López     | carlos@email.com     |       108 | 18000.00

-- Ejercicio 13:
producto_id | nombre              | categoria    | precio   | promedio_categoria
------------+---------------------+--------------+----------+-------------------
15          | Laptop Dell XPS     | Electrónica  | 12000.00 |           8500.00
23          | iPhone 15 Pro       | Electrónica  | 15000.00 |           8500.00
```

#### Verificación:

* Las `subqueries` deben ejecutarse sin errores
* Los resultados deben incluir solo registros que cumplan las condiciones
* Verifica manualmente el promedio calculado en la `subquery`


<br/><br/>

### Paso 6.  Subqueries en Cláusula SELECT y FROM
Implementar subqueries escalares en SELECT y subqueries de tabla en FROM.
 
1.	Agrega columnas calculadas con subqueries en SELECT:
    ```sql
    -- Ejercicio 15: Productos con estadísticas de venta
    SELECT
        prod.producto_id,
        prod.nombre,
        prod.precio,
        prod.stock,
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
    ```

<br/><br/>

2.	Usa subquery en FROM para crear tabla derivada:
    ```sql
    -- Ejercicio 16: Análisis de ventas mensuales
    SELECT
        ventas_mes.mes,
        ventas_mes.anio,
        ventas_mes.total_pedidos,
        ventas_mes.ingresos_mes,
        ROUND(ventas_mes.ingresos_mes / ventas_mes.total_pedidos, 2) AS tick-et_promedio
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
    ```

<br/><br/>

3.	Combina múltiples subqueries en FROM con JOIN:
    ```sql
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
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 15:
producto_id | nombre              | veces_vendido | unidades_vendidas | in-gresos_totales
------------+---------------------+---------------+-------------------+-----------------
15          | Laptop Dell XPS     |             8 |                45 |        540000.00
23          | iPhone 15 Pro       |             5 |                12 |        180000.00
7           | Mouse Inalámbrico   |             0 |                 0 |             0.00

-- Ejercicio 16:
mes | anio | total_pedidos | ingresos_mes | ticket_promedio
----+------+---------------+--------------+----------------
1   | 2024 |            15 |    125000.00 |         8333.33
2   | 2024 |            12 |     98000.00 |         8166.67
```

#### Verificación:

* Las `subqueries` escalares deben retornar un solo valor por fila
* Las `subqueries` en `FROM` deben tener alias obligatoriamente
* Los cálculos derivados deben ser correctos


<br/><br/>

### Paso 7. Operadores de Conjuntos (UNION, INTERSECT, EXCEPT)
Aplicar operadores de conjuntos para combinar y comparar resulta-dos de consultas.
 
1.	Usa UNION para combinar listas de diferentes tablas:
    ```sql
    -- Ejercicio 18: Lista unificada de contactos (clientes y proveedores simula-dos)
    SELECT
        'Cliente' AS tipo,
        cliente_id AS id,
        nombre,
        email,
        ciudad
    FROM clientes
    UNION
    SELECT
        'Producto' AS tipo,
        producto_id AS id,
        nombre,
        'N/A' AS email,
        'Almacén' AS ciudad
    FROM productos
    WHERE stock < 20
    ORDER BY tipo, nombre;
    ```

<br/><br/>

2.	Implementa INTERSECT para encontrar coincidencias:
    ```sql
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
    ```

<br/><br/>

3.	Usa EXCEPT para encontrar diferencias:
    ```sql
    -- Ejercicio 20: Clientes registrados que nunca compraron
    SELECT cliente_id, nombre, email, fecha_registro
    FROM clientes
    EXCEPT
    SELECT c.cliente_id, c.nombre, c.email, c.fecha_registro
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    ORDER BY fecha_registro DESC;
    ```

<br/><br/>


#### Resultado Esperado:
```sql
-- Ejercicio 18:
tipo     | id | nombre              | email              | ciudad
---------+----+---------------------+--------------------+---------
Cliente  |  5 | Ana Martínez        | ana@email.com      | Madrid
Cliente  |  8 | Carlos López        | carlos@email.com   | Barcelona
Producto | 23 | Auriculares Sony    | N/A                | Almacén
Producto | 45 | Teclado Mecánico    | N/A                | Almacén

-- Ejercicio 20:
cliente_id | nombre           | email              | fecha_registro
-----------+------------------+--------------------+---------------
12         | Pedro Sánchez    | pedro@email.com    | 2024-02-15
18         | Laura Fernández  | laura@email.com    | 2024-01-20
```


#### Verificación:

* `UNION` debe eliminar duplicados automáticamente (usa `UNION ALL` para mantenerlos)
* Las columnas en todas las consultas deben coincidir en número y tipo
* `EXCEPT` debe retornar solo elementos del primer conjunto que no están en el segundo



<br/><br/>

## Paso 8. Expresiones CASE para Lógica Condicional
Utilizar CASE para crear columnas calculadas con lógica condicional.
 
1.	Categoriza productos por rango de precio:
    ```sql
    -- Ejercicio 21: Segmentación de productos por precio
    SELECT
        producto_id,
        nombre,
        precio,
        CASE
            WHEN precio < 100 THEN 'Económico'
            WHEN precio BETWEEN 100 AND 500 THEN 'Medio'
            WHEN precio BETWEEN 501 AND 2000 THEN 'Premium'
            ELSE 'Lujo'
        END AS segmento_precio,
        stock,
        CASE
            WHEN stock = 0 THEN 'Sin stock'
            WHEN stock < 10 THEN 'Stock crítico'
            WHEN stock < 50 THEN 'Stock bajo'
            ELSE 'Stock adecuado'
        END AS estado_inventario
    FROM productos
    ORDER BY precio DESC;
    ```

<br/><br/>

2.	Clasifica clientes por comportamiento de compra:
    ```sql
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
    ```

<br/><br/>

3.	Crea indicadores de rendimiento con CASE:
    ```sql
    -- Ejercicio 23: KPIs de productos
    SELECT
        prod.producto_id,
        prod.nombre,
        prod.precio,
        prod.stock,
        COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
        CASE
            WHEN COALESCE(SUM(dp.cantidad), 0) = 0 THEN 'Sin ventas'
            WHEN COALESCE(SUM(dp.cantidad), 0) < 10 THEN 'Ventas bajas'
            WHEN COALESCE(SUM(dp.cantidad), 0) < 50 THEN 'Ventas normales'
            ELSE 'Best seller'
        END AS indicador_ventas,
        CASE
            WHEN prod.stock = 0 THEN 'Agotado'
            WHEN prod.stock < 10 THEN 'Crítico'
            WHEN prod.stock > 100 THEN 'Sobrestock'
            ELSE 'Normal'
        END AS indicador_stock
    FROM productos prod
    LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    GROUP BY prod.producto_id, prod.nombre, prod.precio, prod.stock
    ORDER BY unidades_vendidas DESC;
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 21:
producto_id | nombre              | precio   | segmento_precio | es-tado_inventario
------------+---------------------+----------+-----------------+------------------
23          | iPhone 15 Pro       | 15000.00 | Lujo            | Stock adecuado
15          | Laptop Dell XPS     | 12000.00 | Lujo            | Stock bajo
8           | Camiseta Nike       |    45.00 | Económico       | Stock adecuado

-- Ejercicio 22:
cliente_id | nombre          | total_pedidos | tipo_cliente | segmento_valor
-----------+-----------------+---------------+--------------+----------------
5          | Ana Martínez    |            12 | Regular      | Valor premium
8          | Carlos López    |             5 | Ocasional    | Valor medio
12         | Pedro Sánchez   |             0 | Nuevo/Inactivo| Sin valor
```

#### Verificación:

* Las expresiones `CASE` deben cubrir todos los casos posibles
* Usa `ELSE` para manejar casos no especificados
* Los emojis deben visualizarse correctamente en `PgAdmin`


<br/><br/>

## Paso 9. Funciones Window - Ranking y Análisis
Aplicar funciones window para análisis avanzado sin agrupar datos.
 
1.	Implementa ROW_NUMBER y RANK para ranking de productos:
    ```sql
    -- Ejercicio 24: Ranking de productos más vendidos
    SELECT
        prod.producto_id,
        prod.nombre,
        cat.nombre AS categoria,
        COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
        ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC) AS posi-cion,
        RANK() OVER (ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC) AS ranking,
        DENSE_RANK() OVER (ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC) AS rank-ing_denso
    FROM productos prod
    INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    GROUP BY prod.producto_id, prod.nombre, cat.nombre
    ORDER BY unidades_vendidas DESC
    LIMIT 10;
    ```

<br/><br/>

2.	Usa PARTITION BY para ranking dentro de categorías:
    ```sql
    -- Ejercicio 25: Top 3 productos por categoría
    WITH productos_rankeados AS (
        SELECT
            prod.producto_id,
            prod.nombre,
            cat.nombre AS categoria,
            prod.precio,
            COALESCE(SUM(dp.cantidad), 0) AS unidades_vendidas,
            ROW_NUMBER() OVER (
                PARTITION BY cat.categoria_id
                ORDER BY COALESCE(SUM(dp.cantidad), 0) DESC
            ) AS ranking_categoria
        FROM productos prod
        INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
        LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
        GROUP BY prod.producto_id, prod.nombre, cat.nombre, prod.precio, cat.categoria_id
    )
    SELECT
        categoria,
        ranking_categoria,
        nombre,
        precio,
        unidades_vendidas
    FROM productos_rankeados
    WHERE ranking_categoria <= 3
    ORDER BY categoria, ranking_categoria;
    ```

<br/><br/>

3.	Implementa funciones de agregación window:
    ```sql
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
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 24:
producto_id | nombre              | unidades_vendidas | posicion | ranking | ranking_denso
------------+---------------------+-------------------+----------+---------+--------------
15          | Laptop Dell XPS     |                45 |        1 |       1 |            1
23          | iPhone 15 Pro       |                38 |        2 |       2 |            2
8           | Camiseta Nike       |                30 |        3 |       3 |            3

-- Ejercicio 25:
categoria    | ranking_categoria | nombre              | unidades_vendidas
-------------+-------------------+---------------------+------------------
Electrónica  |                 1 | Laptop Dell XPS     |                45
Electrónica  |                 2 | iPhone 15 Pro       |                38
Electrónica  |                 3 | Mouse Logitech      |                25
Ropa         |                 1 | Camiseta Nike       |                30
Ropa         |                 2 | Pantalón Levi's     |                18
```


#### Verificación:

* `ROW_NUMBER` debe asignar números únicos consecutivos
* `RANK` puede tener saltos en numeración con valores empatados
* `PARTITION BY` debe reiniciar el ranking para cada grupo
* Las funciones `window` no reducen el número de filas


<br/><br/>

## Paso 10. Funciones Window - LAG y LEAD para Análisis Temporal
Usar LAG y LEAD para comparar valores entre filas consecutivas.
 
1.	Analiza cambios en ventas entre períodos:
    ```sql
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
    ```

<br/><br/>


2.	Compara precios de productos con el siguiente más caro:
    ```sql
    -- Ejercicio 28: Análisis de brechas de precio
    SELECT
        producto_id,
        nombre,
        precio,
        LEAD(precio, 1) OVER (ORDER BY precio DESC) AS siguiente_precio,
        precio - LEAD(precio, 1) OVER (ORDER BY precio DESC) AS brecha_precio,
        LAG(nombre, 1) OVER (ORDER BY precio DESC) AS producto_mas_caro,
        LEAD(nombre, 1) OVER (ORDER BY precio DESC) AS producto_mas_barato
    FROM productos
    ORDER BY precio DESC;
    ```

<br/><br/>

3.	Identifica tendencias en comportamiento de clientes:
    ```sql
    -- Ejercicio 29: Análisis de frecuencia de compra
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
        fecha_compra_anterior,
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
    ```

<br/><br/>

#### Resultado Esperado:

```sql
-- Ejercicio 27:
fecha      | pedidos_dia | ventas_dia | ventas_dia_anterior | diferencia | por-centaje_cambio
-----------+-------------+------------+---------------------+------------+------------------
2024-01-15 |           3 |  12000.00  | NULL                | NULL       | NULL
2024-01-16 |           5 |  18000.00  | 12000.00            | 6000.00    | 50.00
2024-01-17 |           2 |   8500.00  | 18000.00            | -9500.00   | -52.78

-- Ejercicio 29:
cliente_id | nombre        | fecha_pedido | dias_entre_compras | frecuencia
-----------+---------------+--------------+--------------------+-------------------
5          | Ana Martínez  | 2024-01-15   | NULL               | Primera compra
5          | Ana Martínez  | 2024-01-20   | 5                  | Comprador frecuente
5          | Ana Martínez  | 2024-02-10   | 21                 | Comprador regu-lar
```

#### Verificación:

* `LAG` debe retornar `NULL` para la primera fila de cada partición
* `LEAD` debe retornar `NULL` para la última fila de cada partición
* `NULLIF` previene división por cero en cálculos de porcentaje
* Los días entre compras deben calcularse correctamente


<br/><br/>

### Paso 11. Common Table Expressions (CTEs) - Consultas Complejas
Usar CTEs para estructurar consultas complejas de forma legible y mantenible.
 
1.	Crea un CTE simple para análisis de ventas:

    ```sql
    -- Ejercicio 30: CTE para análisis de rentabilidad por cliente
    WITH ventas_por_cliente AS (
        SELECT
            c.cliente_id,
            c.nombre,
            c.email,
            COUNT(DISTINCT p.pedido_id) AS total_pedidos,
            SUM(p.total) AS total_gastado,
            AVG(p.total) AS ticket_promedio
        FROM clientes c
        INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
        GROUP BY c.cliente_id, c.nombre, c.email
    ),
    estadisticas_globales AS (
        SELECT
            AVG(total_gastado) AS promedio_global,
            STDDEV(total_gastado) AS desviacion_estandar
        FROM ventas_por_cliente
    )
    SELECT
        vpc.cliente_id,
        vpc.nombre,
        vpc.total_pedidos,
        vpc.total_gastado,
        eg.promedio_global,
        ROUND(vpc.total_gastado - eg.promedio_global, 2) AS diferen-cia_vs_promedio,
        CASE
            WHEN vpc.total_gastado > eg.promedio_global + eg.desviacion_estandar THEN 'Alto valor'
            WHEN vpc.total_gastado < eg.promedio_global - eg.desviacion_estandar THEN 'Bajo valor'
            ELSE 'Valor normal'
        END AS clasificacion
    FROM ventas_por_cliente vpc
    CROSS JOIN estadisticas_globales eg
    ORDER BY vpc.total_gastado DESC;
    ```

<br/><br/>

2.	Implementa CTEs múltiples para análisis de inventario:
    ```sql
    -- Ejercicio 31: Análisis completo de inventario y rotación
    WITH ventas_producto AS (
        SELECT
            dp.producto_id,
            SUM(dp.cantidad) AS unidades_vendidas,
            SUM(dp.cantidad * dp.precio_unitario) AS ingresos_totales,
            COUNT(DISTINCT dp.pedido_id) AS pedidos_distintos
        FROM detalle_pedidos dp
        GROUP BY dp.producto_id
    ),
    inventario_actual AS (
        SELECT
            prod.producto_id,
            prod.nombre,
            cat.nombre AS categoria,
            prod.precio,
            prod.stock,
            prod.precio * prod.stock AS valor_inventario
        FROM productos prod
        INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    ),
    metricas_combinadas AS (
        SELECT
            ia.producto_id,
            ia.nombre,
            ia.categoria,
            ia.precio,
            ia.stock,
            ia.valor_inventario,
            COALESCE(vp.unidades_vendidas, 0) AS unidades_vendidas,
            COALESCE(vp.ingresos_totales, 0) AS ingresos_totales,
            COALESCE(vp.pedidos_distintos, 0) AS pedidos_distintos,
            CASE
                WHEN COALESCE(vp.unidades_vendidas, 0) = 0 THEN 0
                ELSE ROUND(ia.stock::numeric / vp.unidades_vendidas, 2)
            END AS ratio_stock_ventas
        FROM inventario_actual ia
        LEFT JOIN ventas_producto vp ON ia.producto_id = vp.producto_id
    )
    SELECT
        producto_id,
        nombre,
        categoria,
        stock,
        unidades_vendidas,
        valor_inventario,
        ingresos_totales,
        ratio_stock_ventas,
        CASE
            WHEN unidades_vendidas = 0 THEN 'Sin rotación'
            WHEN ratio_stock_ventas > 10 THEN 'Rotación lenta'
            WHEN ratio_stock_ventas > 5 THEN 'Rotación normal'
            ELSE 'Rotación rápida'
        END AS indicador_rotacion,
        CASE
            WHEN unidades_vendidas = 0 AND stock > 50 THEN 'Revisar stock'
            WHEN ratio_stock_ventas < 2 AND stock > 0 THEN 'Reabastecer pronto'
            WHEN stock = 0 AND unidades_vendidas > 10 THEN 'Agotado crítico'
            ELSE 'OK'
        END AS recomendacion
    FROM metricas_combinadas
    ORDER BY ingresos_totales DESC;
    ```

<br/><br/>

3.	Crea CTEs recursivos para análisis jerárquico (simulación):
    ```sql
    -- Ejercicio 32: Serie temporal con generate_series y CTE
    WITH calendario_ventas AS (
        SELECT
            generate_series(
                '2024-01-01'::date,
                '2024-01-31'::date,
                '1 day'::interval
            )::date AS fecha
    ),
    ventas_diarias AS (
        SELECT
            fecha_pedido::date AS fecha,
            COUNT(*) AS pedidos,
            SUM(total) AS ventas
        FROM pedidos
        WHERE fecha_pedido >= '2024-01-01' AND fecha_pedido < '2024-02-01'
        GROUP BY fecha_pedido::date
    )
    SELECT
        cv.fecha,
        COALESCE(vd.pedidos, 0) AS pedidos,
        COALESCE(vd.ventas, 0) AS ventas,
        SUM(COALESCE(vd.ventas, 0)) OVER (
            ORDER BY cv.fecha
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS ventas_acumuladas,
        CASE
            WHEN COALESCE(vd.pedidos, 0) = 0 THEN 'Sin ventas'
            WHEN COALESCE(vd.pedidos, 0) < 3 THEN 'Bajo'
            WHEN COALESCE(vd.pedidos, 0) < 7 THEN 'Normal'
            ELSE 'Alto'
        END AS nivel_actividad
    FROM calendario_ventas cv
    LEFT JOIN ventas_diarias vd ON cv.fecha = vd.fecha
    ORDER BY cv.fecha;
    ```

<br/><br/>

#### Resultado Esperado:

```sql
-- Ejercicio 30:
cliente_id | nombre          | total_gastado | promedio_global | clasificacion
-----------+-----------------+---------------+-----------------+--------------
5          | Ana Martínez    |     85000.00  |       32000.00  | Alto valor
3          | Carlos López    |     32000.00  |       32000.00  | Valor normal
8          | Luis Gómez      |     12000.00  |       32000.00  | Bajo valor

-- Ejercicio 31:
producto_id | nombre              | stock | unidades_vendidas | indica-dor_rotacion | recomendacion
------------+---------------------+-------+-------------------+--------------------+---------------
15          | Laptop Dell XPS     |    25 |                45 | ⚡ Rotación rápida | 📦 Reabastecer pronto
23          | iPhone 15 Pro       |    50 |                38 | 🟢 Rotación nor-mal | ✅ OK
7           | Mouse Inalámbrico   |   100 |                 0 | 🔴 Sin rotación    | ⚠️ Revisar stock
```

#### Verificación:

* Los `CTEs` deben definirse antes de su uso en la consulta principal
* Múltiples `CTEs` se separan con comas, no con punto y coma
* Los `CTEs` pueden referenciar `CTEs` anteriores en la misma consulta
* `generate_series` debe crear todas las fechas del rango especificado


<br/><br/>

### Paso 12. Funciones que Retornan Conjuntos
Utilizar funciones como generate_series y unnest para generar datos dinámicos.
 
1.	Usa generate_series para crear reportes de fechas:
    ```sql
    -- Ejercicio 33: Reporte de ventas con todos los días del mes
    SELECT
        fecha_serie::date AS fecha,
        EXTRACT(DOW FROM fecha_serie) AS dia_semana,
        TO_CHAR(fecha_serie, 'Day') AS nombre_dia,
        COALESCE(COUNT(p.pedido_id), 0) AS pedidos,
        COALESCE(SUM(p.total), 0) AS ventas_totales
    FROM generate_series(
        '2024-01-01'::timestamp,
        '2024-01-31'::timestamp,
        '1 day'::interval
    ) AS fecha_serie
    LEFT JOIN pedidos p ON p.fecha_pedido::date = fecha_serie::date
    GROUP BY fecha_serie
    ORDER BY fecha_serie;
    ```

<br/><br/>

2.	Implementa generate_series para análisis de rangos numéricos:
    ```sql
    -- Ejercicio 34: Distribución de precios por rangos
    WITH rangos_precio AS (
        SELECT
            generate_series AS rango_inicio,
            generate_series + 1000 AS rango_fin
        FROM generate_series(0, 20000, 1000)
    )
    SELECT
        rp.rango_inicio,
        rp.rango_fin,
        CONCAT(rp.rango_inicio, ' - ', rp.rango_fin) AS rango,
        COUNT(p.producto_id) AS productos_en_rango,
        COALESCE(SUM(p.stock), 0) AS stock_total
    FROM rangos_precio rp
    LEFT JOIN productos p ON p.precio >= rp.rango_inicio AND p.precio < rp.rango_fin
    GROUP BY rp.rango_inicio, rp.rango_fin
    ORDER BY rp.rango_inicio;
    ```

<br/><br/>

3.	Usa unnest para expandir arrays (simulación con datos):
    ```sql
    -- Ejercicio 35: Análisis de productos por palabras clave
    WITH productos_keywords AS (
        SELECT
            producto_id,
            nombre,
            STRING_TO_ARRAY(LOWER(nombre), ' ') AS palabras
        FROM productos
    )
    SELECT
        UNNEST(palabras) AS palabra_clave,
        COUNT(DISTINCT producto_id) AS productos_con_palabra,
        STRING_AGG(DISTINCT nombre, ', ') AS productos
    FROM productos_keywords
    WHERE LENGTH(UNNEST(palabras)) > 3
    GROUP BY palabra_clave
    HAVING COUNT(DISTINCT producto_id) > 1
    ORDER BY productos_con_palabra DESC;
    ```
<br/><br/>

#### Resultado Esperado:

```sql
-- Ejercicio 33:
fecha      | dia_semana | nombre_dia | pedidos | ventas_totales
-----------+------------+------------+---------+---------------
2024-01-01 |          1 | Monday     |       3 |      12000.00
2024-01-02 |          2 | Tuesday    |       0 |          0.00
2024-01-03 |          3 | Wednesday  |       5 |      25000.00

-- Ejercicio 34:
rango_inicio | rango_fin | rango         | productos_en_rango | stock_total
-------------+-----------+---------------+--------------------+------------
0            |      1000 | 0 - 1000      |                 15 |         450
1000         |      2000 | 1000 - 2000   |                  8 |         200
10000        |     11000 | 10000 - 11000 |                  2 |          30
```


#### Verificación:

* `generate_series` debe crear una fila por cada valor en el rango
* `LEFT JOIN` con `generate_series` debe incluir fechas sin ventas
* `unnest` expande arrays en múltiples filas
* `STRING_TO_ARRAY` convierte texto en array separado por delimitador


<br/><br/>

## Paso 13. Consultas Avanzadas Integradas
Combinar múltiples técnicas avanzadas en consultas complejas únicas.
 
1.	Crea un dashboard completo de ventas:
    ```sql
    -- Ejercicio 36: Dashboard ejecutivo de ventas
    WITH metricas_generales AS (
        SELECT
            COUNT(DISTINCT pedido_id) AS total_pedidos,
            COUNT(DISTINCT cliente_id) AS clientes_activos,
            SUM(total) AS ingresos_totales,
            AVG(total) AS ticket_promedio,
            MAX(total) AS venta_maxima,
            MIN(total) AS venta_minima
        FROM pedidos
    ),
    top_productos AS (
        SELECT
            prod.nombre,
            SUM(dp.cantidad) AS unidades,
            RANK() OVER (ORDER BY SUM(dp.cantidad) DESC) AS ranking
        FROM detalle_pedidos dp
        INNER JOIN productos prod ON dp.producto_id = prod.producto_id
        GROUP BY prod.producto_id, prod.nombre
        LIMIT 5
    ),
    top_clientes AS (
        SELECT
            c.nombre,
            SUM(p.total) AS total_gastado,
            RANK() OVER (ORDER BY SUM(p.total) DESC) AS ranking
        FROM clientes c
        INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
        GROUP BY c.cliente_id, c.nombre
        LIMIT 5
    )
    SELECT
        'Métricas Generales' AS seccion,
        NULL::text AS item,
        NULL::integer AS ranking,
        mg.total_pedidos::numeric AS valor
    FROM metricas_generales mg
    UNION ALL
    SELECT 'Métricas Generales', 'Clientes Activos', NULL, mg.clientes_activos
    FROM metricas_generales mg
    UNION ALL
    SELECT 'Métricas Generales', 'Ingresos Totales', NULL, mg.ingresos_totales
    FROM metricas_generales mg
    UNION ALL
    SELECT 'Top Productos', tp.nombre, tp.ranking, tp.unidades
    FROM top_productos tp
    UNION ALL
    SELECT 'Top Clientes', tc.nombre, tc.ranking, tc.total_gastado
    FROM top_clientes tc
    ORDER BY seccion, ranking NULLS FIRST;
    ```

<br/><br/>


2.	Implementa análisis de cohortes de clientes:
    ```sql
    -- Ejercicio 37: Análisis de cohortes por mes de registro
    WITH cohortes AS (
        SELECT
            cliente_id,
            DATE_TRUNC('month', fecha_registro) AS mes_cohorte
        FROM clientes
    ),
    actividad_mensual AS (
        SELECT
            c.mes_cohorte,
            DATE_TRUNC('month', p.fecha_pedido) AS mes_actividad,
            COUNT(DISTINCT p.cliente_id) AS clientes_activos,
            SUM(p.total) AS ingresos
        FROM cohortes c
        INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
        GROUP BY c.mes_cohorte, DATE_TRUNC('month', p.fecha_pedido)
    ),
    tamano_cohorte AS (
        SELECT
            mes_cohorte,
            COUNT(DISTINCT cliente_id) AS tamano
        FROM cohortes
        GROUP BY mes_cohorte
    )
    SELECT
        TO_CHAR(am.mes_cohorte, 'YYYY-MM') AS cohorte,
        TO_CHAR(am.mes_actividad, 'YYYY-MM') AS mes,
        tc.tamano AS tamano_cohorte,
        am.clientes_activos,
        ROUND(am.clientes_activos::numeric / tc.tamano * 100, 2) AS tasa_retencion,
        am.ingresos,
        ROUND(am.ingresos / am.clientes_activos, 2) AS ingreso_por_cliente
    FROM actividad_mensual am
    INNER JOIN tamano_cohorte tc ON am.mes_cohorte = tc.mes_cohorte
    ORDER BY am.mes_cohorte, am.mes_actividad;
    ```

<br/><br/>

3.	Crea un análisis RFM (Recency, Frequency, Monetary):
    ```sql
    -- Ejercicio 38: Segmentación RFM de clientes
    WITH datos_rfm AS (
        SELECT
            c.cliente_id,
            c.nombre,
            c.email,
            CURRENT_DATE - MAX(p.fecha_pedido::date) AS recency_dias,
            COUNT(p.pedido_id) AS frequency,
            SUM(p.total) AS monetary
        FROM clientes c
        LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
        GROUP BY c.cliente_id, c.nombre, c.email
    ),
    percentiles_rfm AS (
        SELECT
            PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY recency_dias) AS r_33,
            PERCENTILE_CONT(0.67) WITHIN GROUP (ORDER BY recency_dias) AS r_67,
            PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY frequency) AS f_33,
            PERCENTILE_CONT(0.67) WITHIN GROUP (ORDER BY frequency) AS f_67,
            PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY monetary) AS m_33,
            PERCENTILE_CONT(0.67) WITHIN GROUP (ORDER BY monetary) AS m_67
        FROM datos_rfm
        WHERE frequency > 0
    ),
    scores_rfm AS (
        SELECT
            dr.cliente_id,
            dr.nombre,
            dr.email,
            dr.recency_dias,
            dr.frequency,
            dr.monetary,
            CASE
                WHEN dr.recency_dias IS NULL THEN 0
                WHEN dr.recency_dias <= pr.r_33 THEN 3
                WHEN dr.recency_dias <= pr.r_67 THEN 2
                ELSE 1
            END AS r_score,
            CASE
                WHEN dr.frequency >= pr.f_67 THEN 3
                WHEN dr.frequency >= pr.f_33 THEN 2
                WHEN dr.frequency > 0 THEN 1
                ELSE 0
            END AS f_score,
            CASE
                WHEN dr.monetary >= pr.m_67 THEN 3
                WHEN dr.monetary >= pr.m_33 THEN 2
                WHEN dr.monetary > 0 THEN 1
                ELSE 0
            END AS m_score
        FROM datos_rfm dr
        CROSS JOIN percentiles_rfm pr
    )
    SELECT
        cliente_id,
        nombre,
        email,
        recency_dias,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        (r_score + f_score + m_score) AS rfm_total,
        CASE
            WHEN r_score + f_score + m_score >= 8 THEN '⭐ Champions'
            WHEN r_score >= 2 AND f_score >= 2 THEN '💎 Loyal Customers'
            WHEN r_score >= 2 AND m_score >= 2 THEN '🎯 Big Spenders'
            WHEN r_score = 3 THEN '🆕 New Customers'
            WHEN r_score = 1 AND f_score >= 2 THEN '⚠️ At Risk'
            WHEN r_score = 1 THEN '😴 Hibernating'
            ELSE '📊 Potential'
        END AS segmento
    FROM scores_rfm
    ORDER BY rfm_total DESC, monetary DESC;
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 38 (RFM):
cliente_id | nombre          | recency_dias | frequency | monetary  | rfm_total | segmento
-----------+-----------------+--------------+-----------+-----------+-----------+------------------
5          | Ana Martínez    |            5 |        12 | 85000.00  |         9 | ⭐ Champions
3          | Carlos López    |           10 |         8 | 45000.00  |         8 | ⭐ Champions
8          | Luis Gómez      |           15 |         5 | 28000.00  |         7 | 💎 Loyal Customers
12         | María Silva     |           90 |         2 | 8000.00   |         3 | ⚠️ At Risk
15         | Pedro Sánchez   |          180 |         1 | 2000.00   |         2 | 😴 Hibernating
```

#### Verificación:

* Los percentiles deben dividir los datos en tercios aproximadamente iguales
* Los scores `RFM` deben estar en el rango `0-3` para cada dimensión
* La segmentación debe ser lógica basada en los scores combinados
* `PERCENTILE_CONT` requiere `WITHIN GROUP` y `ORDER BY`

<br/><br/>

### Paso 14. Optimización y Análisis de Planes de Ejecución
Aprender a analizar y optimizar consultas usando EXPLAIN.
 
1.	Analiza el plan de ejecución de una consulta simple:
    ```sql
    -- Ejercicio 39: Plan de ejecución básico
    EXPLAIN ANALYZE
    SELECT
        c.nombre,
        COUNT(p.pedido_id) AS total_pedidos,
        SUM(p.total) AS total_gastado
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nombre
    ORDER BY total_gastado DESC;
    ```

<br/><br/>

2.	Compara planes de ejecución con y sin índices:
    ```sql
    -- Ejercicio 40: Impacto de índices en rendimiento

    -- Primero, analizar sin índice adicional
    EXPLAIN ANALYZE
    SELECT *
    FROM pedidos
    WHERE fecha_pedido BETWEEN '2024-01-01' AND '2024-01-31'
    ORDER BY fecha_pedido;

    -- Crear índice en fecha_pedido
    CREATE INDEX idx_pedidos_fecha ON pedidos(fecha_pedido);

    -- Analizar nuevamente con índice
    EXPLAIN ANALYZE
    SELECT *
    FROM pedidos
    WHERE fecha_pedido BETWEEN '2024-01-01' AND '2024-01-31'
    ORDER BY fecha_pedido;

    -- Comparar tiempos de ejecución
    ```

3.	Optimiza una consulta compleja identificando cuellos de botella:
    ```sql
    -- Ejercicio 41: Optimización de consulta compleja

    -- Versión original (potencialmente ineficiente)
    EXPLAIN ANALYZE
    SELECT
        prod.nombre,
        (SELECT COUNT(*) FROM detalle_pedidos dp WHERE dp.producto_id = prod.producto_id) AS veces_vendido,
        (SELECT SUM(cantidad) FROM detalle_pedidos dp WHERE dp.producto_id = prod.producto_id) AS unidades,
        (SELECT AVG(precio_unitario) FROM detalle_pedidos dp WHERE dp.producto_id = prod.producto_id) AS precio_promedio
    FROM productos prod
    ORDER BY veces_vendido DESC;

    -- Versión optimizada con JOIN
    EXPLAIN ANALYZE
    SELECT
        prod.nombre,
        COUNT(dp.detalle_id) AS veces_vendido,
        COALESCE(SUM(dp.cantidad), 0) AS unidades,
        AVG(dp.precio_unitario) AS precio_promedio
    FROM productos prod
    LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
    GROUP BY prod.producto_id, prod.nombre
    ORDER BY veces_vendido DESC;
    ```

<br/><br/>

#### Resultado Esperado:
```sql
-- Ejercicio 39 (EXPLAIN ANALYZE output):
                                                    QUERY PLAN
------------------------------------------------------------------------------------------------------------------
Sort  (cost=45.23..45.73 rows=200 width=48) (actual time=2.345..2.367 rows=150 loops=1)
Sort Key: (sum(p.total)) DESC
Sort Method: quicksort  Memory: 35kB
->  HashAggregate  (cost=35.00..38.00 rows=200 width=48) (actual time=2.123..2.234 rows=150 loops=1)
        Group Key: c.cliente_id
        ->  Hash Left Join  (cost=15.00..30.00 rows=500 width=40) (actual time=0.234..1.567 rows=500 loops=1)
            Hash Cond: (c.cliente_id = p.cliente_id)
            ->  Seq Scan on clientes c  (cost=0.00..10.00 rows=200 width=32) (actual time=0.012..0.123 rows=150 loops=1)
            ->  Hash  (cost=10.00..10.00 rows=400 width=16) (actual time=0.189..0.189 rows=350 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 25kB
                    ->  Seq Scan on pedidos p  (cost=0.00..10.00 rows=400 width=16) (actual time=0.008..0.098 rows=350 loops=1)
Planning Time: 0.456 ms
Execution Time: 2.456 ms
```

#### Verificación:

* `EXPLAIN` muestra el plan sin ejecutar, `EXPLAIN ANALYZE` ejecuta y muestra tiempos reales
* Busca `"Seq Scan"` (escaneo secuencial) que puede ser ineficiente en tablas grandes
* `"Index Scan"` o `"Index Only Scan"` son generalmente más eficientes
* Compara `"Execution Time"` entre consultas para medir mejoras


<br/><br/>

### Paso 15. Ejercicios de Práctica Final
Consolidar todos los conocimientos con ejercicios desafiantes.
 
1.	Crea un reporte ejecutivo completo:
    ```sql
    -- Ejercicio 42: Reporte ejecutivo mensual
    WITH ventas_mensuales AS (
        SELECT
            DATE_TRUNC('month', fecha_pedido) AS mes,
            COUNT(DISTINCT pedido_id) AS pedidos,
            COUNT(DISTINCT cliente_id) AS clientes_unicos,
            SUM(total) AS ingresos,
            AVG(total) AS ticket_promedio
        FROM pedidos
        GROUP BY DATE_TRUNC('month', fecha_pedido)
    ),
    comparacion_mensual AS (
        SELECT
            mes,
            pedidos,
            clientes_unicos,
            ingresos,
            ticket_promedio,
            LAG(ingresos) OVER (ORDER BY mes) AS ingresos_mes_anterior,
            LAG(pedidos) OVER (ORDER BY mes) AS pedidos_mes_anterior
        FROM ventas_mensuales
    )
    SELECT
        TO_CHAR(mes, 'YYYY-MM') AS periodo,
        pedidos,
        clientes_unicos,
        ROUND(ingresos, 2) AS ingresos,
        ROUND(ticket_promedio, 2) AS ticket_promedio,
        ROUND(ingresos - ingresos_mes_anterior, 2) AS cambio_ingresos,
        ROUND((ingresos - ingresos_mes_anterior) / NULLIF(ingresos_mes_anterior, 0) * 100, 2) AS porcentaje_crecimiento,
        CASE
            WHEN ingresos > ingresos_mes_anterior THEN '📈 Crecimiento'
            WHEN ingresos < ingresos_mes_anterior THEN '📉 Decrecimiento'
            ELSE '➡️ Estable'
        END AS tendencia
    FROM comparacion_mensual
    ORDER BY mes;
    ```

2.	Implementa un análisis de cesta de compra (Market Basket):
    ```sql
    -- Ejercicio 43: Productos frecuentemente comprados juntos
    WITH pares_productos AS (
        SELECT
            dp1.producto_id AS producto_a,
            dp2.producto_id AS producto_b,
            COUNT(DISTINCT dp1.pedido_id) AS veces_juntos
        FROM detalle_pedidos dp1
        INNER JOIN detalle_pedidos dp2
            ON dp1.pedido_id = dp2.pedido_id
            AND dp1.producto_id < dp2.producto_id
        GROUP BY dp1.producto_id, dp2.producto_id
        HAVING COUNT(DISTINCT dp1.pedido_id) >= 2
    )
    SELECT
        prod_a.nombre AS producto_1,
        prod_b.nombre AS producto_2,
        pp.veces_juntos,
        ROUND(pp.veces_juntos::numeric /
            (SELECT COUNT(DISTINCT pedido_id) FROM pedidos) * 100, 2) AS por-centaje_pedidos
    FROM pares_productos pp
    INNER JOIN productos prod_a ON pp.producto_a = prod_a.producto_id
    INNER JOIN productos prod_b ON pp.producto_b = prod_b.producto_id
    ORDER BY pp.veces_juntos DESC
    LIMIT 10;
    ```

3.	Crea un sistema de alertas automatizado:
    ```sql
    -- Ejercicio 44: Sistema de alertas de negocio
    WITH alertas_stock AS (
        SELECT
            'STOCK CRÍTICO' AS tipo_alerta,
            'Alto' AS prioridad,
            producto_id::text AS entidad_id,
            nombre AS entidad_nombre,
            CONCAT('Stock crítico: ', stock, ' unidades') AS mensaje
        FROM productos
        WHERE stock < 10 AND stock > 0
    ),
    alertas_agotado AS (
        SELECT
            'PRODUCTO AGOTADO' AS tipo_alerta,
            'Crítico' AS prioridad,
            producto_id::text,
            nombre,
            'Producto agotado - Reabastecer urgente' AS mensaje
        FROM productos
        WHERE stock = 0
    ),
    alertas_clientes_inactivos AS (
        SELECT
            'CLIENTE INACTIVO' AS tipo_alerta,
            'Medio' AS prioridad,
            c.cliente_id::text,
            c.nombre,
            CONCAT('Sin compras desde hace ', CURRENT_DATE - MAX(p.fecha_pedido::date), ' días') AS mensaje
        FROM clientes c
        INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
        GROUP BY c.cliente_id, c.nombre
        HAVING CURRENT_DATE - MAX(p.fecha_pedido::date) > 90
    ),
    alertas_productos_sin_venta AS (
        SELECT
            'PRODUCTO SIN VENTAS' AS tipo_alerta,
            'Bajo' AS prioridad,
            prod.producto_id::text,
            prod.nombre,
            CONCAT('Sin ventas - Stock: ', prod.stock, ' unidades') AS mensaje
        FROM productos prod
        LEFT JOIN detalle_pedidos dp ON prod.producto_id = dp.producto_id
        WHERE dp.detalle_id IS NULL AND prod.stock > 50
    )
    SELECT * FROM alertas_agotado
    UNION ALL
    SELECT * FROM alertas_stock
    UNION ALL
    SELECT * FROM alertas_clientes_inactivos
    UNION ALL
    SELECT * FROM alertas_productos_sin_venta
    ORDER BY
        CASE prioridad
            WHEN 'Crítico' THEN 1
            WHEN 'Alto' THEN 2
            WHEN 'Medio' THEN 3
            ELSE 4
        END,
        tipo_alerta;
    ```

<br/><br/>

#### Resultado Esperado:

```sql
-- Ejercicio 44 (Sistema de alertas):
tipo_alerta          | prioridad | entidad_id | entidad_nombre      | mensaje
---------------------+-----------+------------+---------------------+----------------------------------------
PRODUCTO AGOTADO     | Crítico   | 23         | iPhone 15 Pro       | Producto agotado - Reabastecer urgente
PRODUCTO AGOTADO     | Crítico   | 45         | Laptop HP           | Producto agotado - Reabastecer urgente
STOCK CRÍTICO        | Alto      | 15         | Mouse Logitech      | Stock crítico: 8 unidades
STOCK CRÍTICO        | Alto      | 32         | Teclado Mecánico    | Stock crítico: 5 unidades
CLIENTE INACTIVO     | Medio     | 12         | Pedro Sánchez       | Sin com-pras desde hace 120 días
PRODUCTO SIN VENTAS  | Bajo      | 67         | Cable HDMI          | Sin ventas - Stock: 150 unidades
```

#### Verificación:

* El sistema de alertas debe identificar correctamente todas las condiciones
* Las prioridades deben ordenarse correctamente (`Crítico` > `Alto` > `Medio` > `Bajo`)
* Los mensajes deben ser descriptivos y accionables
* `UNION ALL` preserva todas las filas (incluyendo duplicados)


<br/><br/>

## Validación y Pruebas

### Criterios de Éxito

* [ ] Todas las consultas ejecutan sin errores de sintaxis
* [ ] Los `JOINs` combinan correctamente datos de múltiples tablas
* [ ] Las vistas se crean exitosamente y son consultables
* [ ] Las `subqueries` retornan resultados coherentes con la lógica de negocio
* [ ] Los operadores de conjuntos (`UNION`, `INTERSECT`, `EXCEPT`) funcionan correctamente
* [ ] Las expresiones `CASE` categorizan datos apropiadamente
* [ ] Las funciones `window` calculan rankings y análisis temporales correctamente
* [ ] Los `CTEs` estructuran consultas complejas de forma legible
* [ ] `generate_series` crea series temporales y numéricas completas
* [ ] Los planes de ejecución muestran mejoras con índices
* [ ] Los reportes integrados combinan múltiples técnicas exitosamente


<br/><br/>

## Procedimiento de Pruebas
1.	Prueba de JOINs:
    ```sql
    -- Verificar que no hay productos huérfanos
    SELECT COUNT(*)
    FROM productos p
    LEFT JOIN categorias c ON p.categoria_id = c.categoria_id
    WHERE c.categoria_id IS NULL;
    -- Debe retornar 0
    ```

<br/><br/>

2.	Prueba de Vistas:
    ```sql
    -- Verificar que las vistas existen
    SELECT viewname
    FROM pg_views
    WHERE schemaname = 'public'
    AND viewname LIKE 'vista_%';
    -- Debe retornar las 3 vistas creadas
    ```

<br/><br/>

3.	Prueba de Funciones Window:
    ```sql
    -- Verificar que ROW_NUMBER no tiene duplicados
    WITH test_ranking AS (
        SELECT
            producto_id,
            ROW_NUMBER() OVER (ORDER BY producto_id) AS rn
        FROM productos
    )
    SELECT COUNT(*), COUNT(DISTINCT rn)
    FROM test_ranking;
    -- Ambos conteos deben ser iguales
    ```

<br/><br/>

4.	Prueba de CTEs:
    ```sql
    -- Verificar que CTE y subconsulta dan mismo resultado
    WITH cte_test AS (
        SELECT AVG(total) AS promedio FROM pedidos
    )
    SELECT
        (SELECT promedio FROM cte_test) AS promedio_cte,
        (SELECT AVG(total) FROM pedidos) AS promedio_directo;
    -- Ambos valores deben ser idénticos
    ```

<br/><br/>

5.	Prueba de Rendimiento:
    ```sql
    -- Comparar tiempos de ejecución
    \timing on

    -- Consulta con subqueries correlacionadas
    SELECT nombre,
        (SELECT COUNT(*) FROM detalle_pedidos dp WHERE dp.producto_id = p.producto_id)
    FROM productos p;

    -- Consulta con JOIN
    SELECT p.nombre, COUNT(dp.detalle_id)
    FROM productos p
    LEFT JOIN detalle_pedidos dp ON p.producto_id = dp.producto_id
    GROUP BY p.producto_id, p.nombre;

    \timing off
    -- El JOIN debería ser más rápido
    ```

<br/><br/>

## Solución de Problemas

### Problema 1: Error `"column must appear in GROUP BY clause"`

#### Síntomas:

* Mensaje de error al ejecutar consultas con `GROUP BY`
* El error menciona columnas específicas no agregadas

#### Causa:

En PostgreSQL, todas las columnas en `SELECT` que no están en funciones de agregación deben aparecer en `GROUP BY`.

#### Solución:
```sql
-- Incorrecto
SELECT
    c.cliente_id,
    c.nombre,
    c.email,  -- Esta columna falta en GROUP BY
    COUNT(p.pedido_id)
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre;

-- Correcto
SELECT
    c.cliente_id,
    c.nombre,
    c.email,
    COUNT(p.pedido_id)
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre, c.email;
```

<br/><br/>

### Problema 2: Subquery retorna más de una fila

#### Síntomas:

* Error: `"more than one row returned by a subquery used as an expression"`
* Ocurre en `subqueries` escalares en `SELECT`

#### Causa:

Una `subquery` escalar debe retornar exactamente una fila y una columna.


#### Solución:
```sql
-- Incorrecto (puede retornar múltiples filas)
SELECT
    c.nombre,
    (SELECT p.total FROM pedidos p WHERE p.cliente_id = c.cliente_id) AS total
FROM clientes c;

-- Correcto (agregación garantiza una fila)
SELECT
    c.nombre,
    (SELECT SUM(p.total) FROM pedidos p WHERE p.cliente_id = c.cliente_id) AS total
FROM clientes c;

-- Alternativa con JOIN
SELECT
    c.nombre,
    SUM(p.total) AS total
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre;
```

<br/><br/>

### Problema 3: División por cero en cálculos

#### Síntomas:

* Error: `"division by zero"`
* Ocurre en cálculos de porcentajes o promedios

#### Causa:

Intentar dividir por un valor que puede ser cero.

#### Solución:
```sql
-- Incorrecto
SELECT
    producto_id,
    stock / unidades_vendidas AS ratio
FROM productos;

-- Correcto con NULLIF
SELECT
    producto_id,
    stock / NULLIF(unidades_vendidas, 0) AS ratio
FROM productos;

-- Correcto con CASE
SELECT
    producto_id,
    CASE
        WHEN unidades_vendidas = 0 THEN NULL
        ELSE stock / unidades_vendidas
    END AS ratio
FROM productos;
```

<br/><br/>

### Problema 4: Funciones `Window` sin `OVER` clause

#### Síntomas:

* Error: `"window function call requires an OVER clause"`
* Funciones como `ROW_NUMBER`, `RANK` no funcionan

#### Causa:

Las funciones `window` requieren obligatoriamente la cláusula `OVER`.


#### Solución:
```sql
-- Incorrecto
SELECT
    nombre,
    precio,
    ROW_NUMBER() AS ranking
FROM productos;

-- Correcto
SELECT
    nombre,
    precio,
    ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos;

-- Con PARTITION BY
SELECT
    nombre,
    categoria_id,
    precio,
    ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY precio DESC) AS rank-ing
FROM productos;
```

<br/><br/>

### Problema 5: `CTE` no reconocido en consulta

#### Síntomas:

* Error: `"relation does not exist"`
* El `CTE` no es visible donde se intenta usar

#### Causa:

Los `CTEs` solo son visibles en la consulta inmediatamente siguiente, no en `CTEs` subsiguientes mal referenciados.

#### Solución:
```sql
-- Incorrecto (cte2 intenta usar cte1 pero está mal estructurado)
WITH cte1 AS (SELECT * FROM clientes)
WITH cte2 AS (SELECT * FROM cte1 WHERE ciudad = 'Madrid')
SELECT * FROM cte2;

-- Correcto (CTEs separados por comas)
WITH cte1 AS (
    SELECT * FROM clientes
),
cte2 AS (
    SELECT * FROM cte1 WHERE ciudad = 'Madrid'
)
SELECT * FROM cte2;
```

<br/><br/>

### Problema 6: Rendimiento lento con subqueries correlacionadas

#### Síntomas:

* Consultas extremadamente lentas
* `EXPLAIN` muestra `SubPlan` ejecutándose muchas veces

#### Causa:

Las `subqueries correlacionadas` se ejecutan una vez por cada fila de la tabla externa.


#### Solución:
```sql
-- Lento (subquery correlacionada)
SELECT
    p.producto_id,
    p.nombre,
    (SELECT COUNT(*) FROM detalle_pedidos dp WHERE dp.producto_id = p.producto_id) AS ventas
FROM productos p;

-- Rápido (JOIN con agregación)
SELECT
    p.producto_id,
    p.nombre,
    COUNT(dp.detalle_id) AS ventas
FROM productos p
LEFT JOIN detalle_pedidos dp ON p.producto_id = dp.producto_id
GROUP BY p.producto_id, p.nombre;

-- Verificar con EXPLAIN ANALYZE
EXPLAIN ANALYZE [tu consulta];
```

<br/><br/>

### Problema 7: UNION con diferentes tipos de columnas

#### Síntomas:
* Error: `"UNION types cannot be matched"`
* Las consultas tienen columnas incompatibles

#### Causa:
`UNION` requiere que todas las consultas tengan el mismo número de columnas con tipos compatibles.

#### Solución:
```sql
-- Incorrecto (tipos diferentes)
SELECT cliente_id, nombre FROM clientes
UNION
SELECT producto_id, precio FROM productos;

-- Correcto (conversión de tipos)
SELECT cliente_id::text AS id, nombre AS descripcion FROM clientes
UNION
SELECT producto_id::text, nombre FROM productos;

-- Correcto (columnas adicionales con NULL)
SELECT cliente_id, nombre, email FROM clientes
UNION
SELECT producto_id, nombre, NULL::text FROM productos;
```

<br/><br/>

## Limpieza

```sql
-- Eliminar índices creados durante las pruebas
DROP INDEX IF EXISTS idx_pedidos_fecha;

-- Eliminar vistas creadas (opcional, puedes mantenerlas)
-- DROP VIEW IF EXISTS vista_ventas_completas;
-- DROP VIEW IF EXISTS vista_inventario_valorizado;
-- DROP VIEW IF EXISTS vista_perfil_clientes;

-- Verificar vistas restantes
SELECT viewname FROM pg_views WHERE schemaname = 'public';

-- Verificar índices
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
```


> **Advertencia:** No elimines las `vistas` si planeas usarlas en futuros análisis. Son útiles para consultas recurrentes y no ocupan espacio adicional significativo.

> **Nota:** Los `CTEs` no persisten en la base de datos, son solo consultas temporales durante la ejecución, por lo que no requieren limpieza.


<br/><br/>

## Resumen

### Lo que Lograste

* Implementaste todos los tipos de `JOINs` (`INNER`, `LEFT`, `RIGHT`, `FULL OUTER`) para combinar datos de múltiples tablas
* Creaste vistas reutilizables que encapsulan consultas complejas
* Escribiste `subqueries` en cláusulas `SELECT`, `WHERE`, `FROM` y `HAVING`
* Aplicaste operadores de conjuntos (`UNION`, `INTERSECT`, `EXCEPT`) para combinar resultados
* Utilizaste expresiones `CASE` para lógica condicional y categorización dinámica
* Implementaste funciones `window` (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`) para análisis avanzado
* Creaste `Common Table Expressions` (`CTEs`) para estructurar consultas complejas
* Usaste funciones de conjunto (`generate_series`, `unnest`) para generar datos dinámicos
* Analizaste planes de ejecución con `EXPLAIN ANALYZE` para optimizar consultas
* Desarrollaste reportes ejecutivos, análisis `RFM`, cohortes y sistemas de alertas

<br/><br/>


## Conceptos Clave Aprendidos

* `JOINs`: Permiten combinar datos relacionados de múltiples tablas basándose en claves
* `Vistas`: Son consultas almacenadas que simplifican el acceso a datos complejos
* `Subqueries`: Consultas anidadas que pueden usarse como valores escalares, tablas o condiciones
* `Funciones Window`: Realizan cálculos sobre conjuntos de filas relacionadas sin agrupar
* `CTEs`: Mejoran la legibilidad y mantenibilidad de consultas complejas
* `EXPLAIN ANALYZE`: Herramienta esencial para entender y optimizar el rendimiento de consultas
* `Optimización`: Los `JOINs` son generalmente más eficientes que subqueries correlacionadas



<br/><br/>

## Próximos Pasos

* Practica escribiendo consultas complejas sobre tus propios conjuntos de datos
* Explora funciones `window` adicionales (`NTILE`, `PERCENT_RANK`, `CUME_DIST`)
* Aprende sobre índices compuestos y estrategias avanzadas de indexación
* Investiga técnicas de particionamiento de tablas para grandes volúmenes de datos
* Estudia transacciones y control de concurrencia para operaciones `DML` seguras
* Prepárate para el proyecto final (`Lab 7.1`) aplicando todas estas técnicas



<br/><br/>


## Recursos Adicionales

* Documentación Oficial de PostgreSQL – `SELECT`: [https://www.postgresql.org/docs/18/sql-select.html](https://www.postgresql.org/docs/18/sql-select.html)
  Referencia completa de la sintaxis `SELECT`

* Documentación Oficial – Window Functions: [https://www.postgresql.org/docs/18/tutorial-window.html](https://www.postgresql.org/docs/18/tutorial-window.html)
  Tutorial detallado de funciones `window`

* Documentación Oficial – `WITH` Queries (CTE): [https://www.postgresql.org/docs/18/queries-with.html](https://www.postgresql.org/docs/18/queries-with.html)
  Guía completa de `CTEs`

* PostgreSQL Performance Tuning: [https://wiki.postgresql.org/wiki/Performance_Optimization](https://wiki.postgresql.org/wiki/Performance_Optimization)
  Wiki oficial sobre optimización

* EXPLAIN Visualizer: [https://explain.dalibo.com/](https://explain.dalibo.com/)
  Herramienta online para visualizar planes de ejecución

* SQL Style Guide: [https://www.sqlstyle.guide/](https://www.sqlstyle.guide/)
  Guía de buenas prácticas de formato SQL

* Use The Index, Luke: [https://use-the-index-luke.com/](https://use-the-index-luke.com/)
  Guía completa sobre índices en bases de datos

* PostgreSQL Exercises: [https://pgexercises.com/](https://pgexercises.com/)
  Ejercicios prácticos interactivos de SQL

* Mode Analytics SQL Tutorial: [https://mode.com/sql-tutorial/](https://mode.com/sql-tutorial/)
  Tutorial interactivo de SQL avanzado

