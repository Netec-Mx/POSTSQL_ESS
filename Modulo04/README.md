
# Práctica 4.1 Ejercicios aplicados a la base de datos del curso

<br/><br/>

## Duración	
60 minutos

<br/><br/>

## Objetivos de Aprendizaje

Al completar este laboratorio, usted será capaz de:

- Ejecutar consultas `SELECT` básicas y con proyección de columnas específicas.
- Aplicar filtros con `WHERE` usando operadores de comparación, lógicos y `LIKE`.
- Utilizar funciones de agregación: `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`.
- Implementar ordenamientos con `ORDER BY` (`ASC` / `DESC`) y múltiples columnas.
- Aplicar la cláusula `LIMIT` para la paginación de resultados.
- Crear agrupamientos con `GROUP BY` y filtrar grupos con `HAVING`.
- Combinar funciones de texto, fecha y matemáticas en consultas SQL.


<br/><br/>

## Prerrequisitos

### Conocimientos Requeridos

- Base de datos `tienda_barrio` implementada con datos de prueba  
  (Lab 03-00-01 completado).
- Comprensión de la sintaxis básica `SELECT` y de la estructura de consultas SQL.
- Conocimiento de operadores lógicos (`AND`, `OR`, `NOT`) y operadores de comparación  
  (`=`, `>`, `<`, `>=`, `<=`, `<>`).
- Familiaridad con los conceptos de tablas, filas y columnas en bases de datos relacionales.

### Acceso Requerido

- Acceso a **pgAdmin 4** con conexión activa al servidor PostgreSQL.
- Permisos de lectura sobre la base de datos `tienda_barrio`.
- Usuario de base de datos con privilegios `SELECT` sobre todas las tablas.


<br/><br/>

## Entorno de Laboratorio

### Requisitos de Hardware

| Componente        | Especificación                     |
|------------------|------------------------------------|
| Procesador       | 64 bits (x86-64 o compatible)       |
| RAM              | Mínimo 4 GB                         |
| Espacio en disco | 500 MB disponibles                 |
| Pantalla         | Resolución mínima 1280x720          |


### Requisitos de Software

| Software        | Versión                         | Propósito                                                |
|-----------------|----------------------------------|----------------------------------------------------------|
| PostgreSQL      | 18.x                             | Motor de base de datos para ejecutar consultas            |
| PgAdmin         | 4.x                              | Interfaz gráfica para gestión y ejecución de consultas SQL|
| Windows         | 10 u 11 (64-bit)                 | Sistema operativo base                                   |
| Navegador web   | Chrome 90+, Firefox 88+ o Edge 90+ | Requerido para PgAdmin 4                                  |


### Configuración Inicial
Antes de comenzar, verifique que la base de datos esté lista:

```sql
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
```

#### Resultado esperado: 
Debe mostrar el nombre de cada tabla con su conteo de registros (todos mayores a 0).

<br/><br/>

## Instrucciones

### Paso 1. Consultas SELECT Básicas
Practicar consultas SELECT simples para recuperar todos los datos y proyecciones específicas de columnas.
 
1.	Abra PgAdmin y conéctese a la base de datos tienda_barrio.

2.	Abra el Query Tool haciendo clic derecho sobre la base de datos → Query Tool.

3.	Ejecute la siguiente consulta para ver todos los productos:

    ```sql
    -- Ejercicio 1.1: Seleccionar todos los productos
    SELECT * FROM productos;
    ```

4.	Ejecute una consulta con proyección específica de columnas:

    ```sql
    -- Ejercicio 1.2: Mostrar solo nombre y precio de productos
    SELECT nombre, precio FROM productos;
    ```

5.	Agregue un alias a las columnas para mejorar la legibilidad:

    ```sql
    -- Ejercicio 1.3: Usar alias para columnas
    SELECT
        nombre AS nombre_producto,
        precio AS precio_unitario,
        stock AS cantidad_disponible
    FROM productos;
    ```

<br/><br/>

#### Salida Esperada:
La primera consulta mostrará todas las columnas de la tabla productos. La se-gunda mostrará solo dos columnas. La tercera mostrará tres columnas con nombres personalizados en los encabezados.


#### Verificación:

- Confirmar que los datos de la tabla `productos` se visualizan correctamente en el panel de resultados.
- Verificar que los alias definidos en la consulta aparecen como encabezados de columna.
- Contar visualmente que existen al menos 10 registros (productos) en la tabla.


<br/><br/>

### Paso 2. Aplicar Filtros con WHERE
Utilizar la cláusula WHERE con diferentes operadores para filtrar regis-tros específicos.
 
1.	Filtre productos con precio mayor a 5000:

    ```sql
    -- Ejercicio 2.1: Productos caros
    SELECT nombre, precio
    FROM productos
    WHERE precio > 5000;
    ```

2.	Use el operador BETWEEN para rangos:

    ```sql
    -- Ejercicio 2.2: Productos en rango de precio
    SELECT nombre, precio
    FROM productos
    WHERE precio BETWEEN 2000 AND 5000
    ORDER BY precio;
    ```

3.	Aplique el operador IN para múltiples valores:

    ```sql
    -- Ejercicio 2.3: Productos de categorías específicas
    SELECT nombre, categoria_id, precio
    FROM productos
    WHERE categoria_id IN (1, 2, 3);
    ```

4.	Use el operador LIKE para búsquedas de texto:

    ```sql
    -- Ejercicio 2.4: Buscar productos que contengan "Arroz"
    SELECT nombre, precio
    FROM productos
    WHERE nombre LIKE '%Arroz%';
    ```

5.	Combine múltiples condiciones con AND y OR:

    ```sql
    -- Ejercicio 2.5: Productos con condiciones múltiples
    SELECT nombre, precio, stock
    FROM productos
    WHERE precio < 3000
        AND stock > 50
        AND categoria_id = 1;
    ```

<br/><br/>

#### Salida Esperada:

- Cada consulta debe retornar un subconjunto de productos filtrados que cumplan con las condiciones especificadas.
- El ejercicio 2.2 debe mostrar los resultados ordenados por el campo precio en orden ascendente.


#### Verificación:

- Verificar que todos los precios del ejercicio 2.1 sean mayores a 5000.
- Confirmar que los precios del ejercicio 2.2 estén en el rango entre 2000 y 5000.
- Validar que los resultados del ejercicio 2.4 contengan la palabra "Arroz".
- Revisar que todos los productos del ejercicio 2.5 cumplan las tres condiciones simultáneamente.


<br/><br/>

### Paso 3. Ordenamiento de Resultados
Aplicar la cláusula ORDER BY para ordenar los resultados en orden ascendente y descendente utilizando múltiples columnas.

 
1.	Ordene productos por precio de menor a mayor:

    ```sql
    -- Ejercicio 3.1: Ordenamiento ascendente
    SELECT nombre, precio
    FROM productos
    ORDER BY precio ASC;
    ```

2.	Ordene productos por precio de mayor a menor:

    ```sql
    -- Ejercicio 3.2: Ordenamiento descendente
    SELECT nombre, precio
    FROM productos
    ORDER BY precio DESC;
    ```

3.	Aplique ordenamiento por múltiples columnas:

    ```sql
    -- Ejercicio 3.3: Ordenamiento múltiple
    SELECT nombre, categoria_id, precio
    FROM productos
    ORDER BY categoria_id ASC, precio DESC;
    ```

4.	Combine ORDER BY con LIMIT para obtener top N:

    ```sql
    -- Ejercicio 3.4: Top 5 productos más caros
    SELECT nombre, precio
    FROM productos
    ORDER BY precio DESC
    LIMIT 5;
    ```

5.	Obtenga los productos con menor stock:

    ```sql
    -- Ejercicio 3.5: Productos con bajo inventario
    SELECT nombre, stock, precio
    FROM productos
    ORDER BY stock ASC
    LIMIT 10;
    ```

<br/><br/>

#### Salida Esperada:
- Los resultados deben aparecer ordenados de acuerdo con los criterios especificados en cada consulta.
- El ejercicio 3.4 debe mostrar exactamente 5 productos con los precios más altos.


#### Verificación:

- Confirmar que en el ejercicio 3.1 el primer producto tiene el precio más bajo.
- Verificar que en el ejercicio 3.2 el primer producto tiene el precio más alto.
- En el ejercicio 3.3, comprobar que los productos están agrupados por categoría y que, dentro de cada categoría, se encuentran ordenados por precio de forma descendente.
- Validar que el ejercicio 3.4 muestra exactamente 5 registros.


<br/><br/>

### Paso 4. Funciones de Agregación
Utilizar funciones de agregación para realizar cálculos sobre conjuntos de datos.
 
1.	Cuente el total de productos:

    ```sql
    -- Ejercicio 4.1: Contar productos
    SELECT COUNT(*) AS total_productos
    FROM productos;
    ```

2.	Calcule el precio promedio de productos:
    ```sql
    -- Ejercicio 4.2: Precio promedio
    SELECT
        AVG(precio) AS precio_promedio,
        ROUND(AVG(precio), 2) AS precio_promedio_redondeado
    FROM productos;
    ```

3.	Encuentre el precio máximo y mínimo:
    ```sql
    -- Ejercicio 4.3: Precios extremos
    SELECT
        MAX(precio) AS precio_maximo,
        MIN(precio) AS precio_minimo,
        MAX(precio) - MIN(precio) AS diferencia
    FROM productos;
    ```

4.	Calcule la suma total del inventario:
    ```sql
    -- Ejercicio 4.4: Valor total del inventario
    SELECT
        SUM(precio * stock) AS valor_total_inventario,
        ROUND(SUM(precio * stock), 2) AS valor_redondeado
    FROM productos;
    ```

5.	Combine múltiples agregaciones:
    ```sql
    -- Ejercicio 4.5: Estadísticas generales de productos
    SELECT
        COUNT(*) AS total_productos,
        ROUND(AVG(precio), 2) AS precio_promedio,
        MAX(precio) AS precio_maximo,
        MIN(precio) AS precio_minimo,
        SUM(stock) AS stock_total
    FROM productos;
    ```

<br/><br/>

#### Salida esperada
Cada consulta debe retornar una sola fila con los valores calculados.  
Los valores numéricos deben ser coherentes con los datos almacenados en la tabla.

#### Verificación
- El total de productos debe ser un número entero positivo.
- El precio promedio debe encontrarse entre el precio mínimo y el precio máximo.
- El valor total del inventario debe ser un número significativo.
- Todos los valores calculados deben ser mayores que cero.


<br/><br/>

### Paso 5. Agrupamiento con GROUP BY
Agrupar datos y aplicar funciones de agregación a cada grupo.
 
1.	Cuente productos por categoría:
    ```sql
    -- Ejercicio 5.1: Productos por categoría
    SELECT
        categoria_id,
        COUNT(*) AS cantidad_productos
    FROM productos
    GROUP BY categoria_id
    ORDER BY cantidad_productos DESC;
    ```

2.	Calcule el precio promedio por categoría:
    ```sql
    -- Ejercicio 5.2: Precio promedio por categoría
    SELECT
        c.nombre AS categoria,
        COUNT(p.id) AS total_productos,
        ROUND(AVG(p.precio), 2) AS precio_promedio
    FROM categorias c
    LEFT JOIN productos p ON c.id = p.categoria_id
    GROUP BY c.id, c.nombre
    ORDER BY precio_promedio DESC;
    ```

3.	Obtenga el stock total por categoría:
    ```sql
    -- Ejercicio 5.3: Stock por categoría
    SELECT
        categoria_id,
        SUM(stock) AS stock_total,
        AVG(stock) AS stock_promedio
    FROM productos
    GROUP BY categoria_id
    ORDER BY stock_total DESC;
    ```

4.	Analice ventas por cliente:
    ```sql
    -- Ejercicio 5.4: Cantidad de compras por cliente
    SELECT
        cliente_id,
        COUNT(*) AS total_compras,
        SUM(total) AS monto_total_gastado
    FROM ventas
    GROUP BY cliente_id
    ORDER BY monto_total_gastado DESC;
    ```

5.	Agrupe ventas por fecha:
    ```sql
    -- Ejercicio 5.5: Ventas por día
    SELECT
        DATE(fecha) AS fecha_venta,
        COUNT(*) AS numero_ventas,
        SUM(total) AS total_vendido
    FROM ventas
    GROUP BY DATE(fecha)
    ORDER BY fecha_venta DESC;
    ```

<br/><br/>

#### Salida esperada
Cada consulta debe mostrar múltiples filas, una por cada grupo.  
Los totales y promedios deben ser calculados correctamente para cada grupo.

#### Verificación
- La suma de `cantidad_productos` en el ejercicio 5.1 debe ser igual al total de productos.
- Cada categoría debe aparecer una sola vez en los resultados.
- Los valores de agregación deben ser coherentes con los datos agrupados.
- El ordenamiento debe aplicarse correctamente según los criterios definidos.


<br/><br/>

### Paso 6. Filtrar Grupos con HAVING

Aplicar la cláusula HAVING para filtrar grupos después de realizar operaciones de agregación.

 
1.	Filtre categorías con más de 5 productos:

    ```sql
    -- Ejercicio 6.1: Categorías con muchos productos
    SELECT
        categoria_id,
        COUNT(*) AS cantidad_productos
    FROM productos
    GROUP BY categoria_id
    HAVING COUNT(*) > 5
    ORDER BY cantidad_productos DESC;
    ```

2.	Encuentre categorías con precio promedio alto:

    ```sql
    -- Ejercicio 6.2: Categorías con productos caros
    SELECT
        categoria_id,
        ROUND(AVG(precio), 2) AS precio_promedio,
        COUNT(*) AS total_productos
    FROM productos
    GROUP BY categoria_id
    HAVING AVG(precio) > 3000
    ORDER BY precio_promedio DESC;
    ```

3.	Identifique clientes con compras significativas:

    ```sql
    -- Ejercicio 6.3: Clientes frecuentes
    SELECT
        cliente_id,
        COUNT(*) AS total_compras,
        ROUND(SUM(total), 2) AS monto_total
    FROM ventas
    GROUP BY cliente_id
    HAVING COUNT(*) >= 2
    ORDER BY total_compras DESC;
    ```

4.	Combine WHERE y HAVING:

    ```sql
    -- Ejercicio 6.4: Productos en stock por categoría (filtrado doble)
    SELECT
        categoria_id,
        COUNT(*) AS productos_en_stock,
        SUM(stock) AS stock_total
    FROM productos
    WHERE stock > 0
    GROUP BY categoria_id
    HAVING SUM(stock) > 100
    ORDER BY stock_total DESC;
    ```

5.	Analice productos con bajo stock promedio por categoría:

    ```sql
    
    -- Ejercicio 6.5: Categorías con bajo inventario promedio
    SELECT
        categoria_id,
        COUNT(*) AS total_productos,
        ROUND(AVG(stock), 2) AS stock_promedio
    FROM productos
    GROUP BY categoria_id
    HAVING AVG(stock) < 50
    ORDER BY stock_promedio ASC;
    ```

<br/><br/>

#### Salida esperada
Solo deben aparecer los grupos que cumplan las condiciones especificadas en la cláusula HAVING.  
El número de filas puede ser menor que en los ejercicios que utilizan GROUP BY sin HAVING.

#### Verificación
- Todos los grupos mostrados deben cumplir la condición definida en HAVING.
- Verificar manualmente al menos un grupo para confirmar que cumple con el criterio.
- Comparar los resultados obtenidos con y sin HAVING para comprender la diferencia.
- Confirmar que la cláusula WHERE filtra filas antes de la agrupación y HAVING filtra grupos después de la agregación.


<br/><br/>

### Paso 7. Funciones de texto
Aplicar funciones de manipulación de texto en consultas SQL.

 
1.	Convierta nombres a mayúsculas y minúsculas:
    ```sql
    -- Ejercicio 7.1: Manipulación de mayúsculas/minúsculas
    SELECT
        nombre,
        UPPER(nombre) AS nombre_mayusculas,
        LOWER(nombre) AS nombre_minusculas
    FROM productos
    LIMIT 10;
    ```

2.	Concatene columnas de texto:
    ```sql
    -- Ejercicio 7.2: Concatenación
    SELECT
        nombre,
        precio,
        CONCAT(nombre, ' - $', precio) AS producto_con_precio,
        nombre || ' (Stock: ' || stock || ')' AS producto_con_stock
    FROM productos
    LIMIT 10;
    ```

3.	Extraiga subcadenas y obtenga longitud:
    ```sql
    -- Ejercicio 7.3: Subcadenas y longitud
    SELECT
        nombre,
        LENGTH(nombre) AS longitud,
        SUBSTRING(nombre, 1, 10) AS primeros_10_caracteres,
        LEFT(nombre, 5) AS primeros_5
    FROM productos
    LIMIT 10;
    ```

4.	Elimine espacios en blanco:
    ```sql
    -- Ejercicio 7.4: Limpieza de espacios
    SELECT
        '  ' || nombre || '  ' AS con_espacios,
        TRIM('  ' || nombre || '  ') AS sin_espacios,
        LTRIM('  ' || nombre) AS sin_espacios_izq,
        RTRIM(nombre || '  ') AS sin_espacios_der
    FROM productos
    LIMIT 5;
    ```

5.	Busque y reemplace texto:

    ```sql
    -- Ejercicio 7.5: Reemplazo de texto
    SELECT
        nombre,
        REPLACE(nombre, 'Arroz', 'ARROZ') AS nombre_modificado,
        POSITION('a' IN LOWER(nombre)) AS posicion_primera_a
    FROM productos
    WHERE nombre LIKE '%Arroz%';
    ```

<br/><br/>

#### Salida esperada
Cada consulta debe mostrar las transformaciones de texto aplicadas correctamente.  
Los nombres deben aparecer en diferentes formatos según la función utilizada.

#### Verificación
- Verificar que la función `UPPER()` convierte el texto completamente a mayúsculas.
- Confirmar que la función `CONCAT()` une correctamente las cadenas.
- Validar que la función `LENGTH()` retorna valores enteros positivos.
- Comprobar que la función `TRIM()` elimina los espacios en blanco correctamente.


<br/><br/>

### Paso 8. Funciones de Fecha y Hora
Utilizar funciones de fecha para extraer y manipular información tem-poral.
 
1.	Extraiga componentes de fecha:

    ```sql
    -- Ejercicio 8.1: Componentes de fecha
    SELECT
        fecha,
        EXTRACT(YEAR FROM fecha) AS año,
        EXTRACT(MONTH FROM fecha) AS mes,
        EXTRACT(DAY FROM fecha) AS dia,
        EXTRACT(DOW FROM fecha) AS dia_semana
    FROM ventas
    LIMIT 10;
    ```

2.	Formatee fechas de diferentes maneras:
    ```sql
    -- Ejercicio 8.2: Formato de fechas
    SELECT
        fecha,
        TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha_formateada,
        TO_CHAR(fecha, 'Day, DD Month YYYY') AS fecha_texto,
        TO_CHAR(fecha, 'YYYY-MM') AS año_mes
    FROM ventas
    LIMIT 10;
    ```

3.	Calcule diferencias de tiempo:
    ```sql
    -- Ejercicio 8.3: Diferencias de fecha
    SELECT
        fecha,
        CURRENT_DATE AS fecha_actual,
        CURRENT_DATE - DATE(fecha) AS dias_transcurridos,
        AGE(CURRENT_DATE, DATE(fecha)) AS tiempo_transcurrido
    FROM ventas
    ORDER BY fecha DESC
    LIMIT 10;
    ```

4.	Agrupe por períodos de tiempo:
    ```sql
    -- Ejercicio 8.4: Ventas por mes
    SELECT
        TO_CHAR(fecha, 'YYYY-MM') AS año_mes,
        COUNT(*) AS total_ventas,
        ROUND(SUM(total), 2) AS monto_total
    FROM ventas
    GROUP BY TO_CHAR(fecha, 'YYYY-MM')
    ORDER BY año_mes DESC;
    ```

5.	Use DATE_TRUNC para truncar fechas:
    ```sql
    -- Ejercicio 8.5: Truncamiento de fechas
    SELECT
        DATE_TRUNC('month', fecha) AS inicio_mes,
        COUNT(*) AS ventas_del_mes,
        SUM(total) AS total_mes
    FROM ventas
    GROUP BY DATE_TRUNC('month', fecha)
    ORDER BY inicio_mes DESC;
    ```

<br/><br/>

#### Salida esperada
Las consultas deben mostrar fechas en diferentes formatos y realizar cálculos temporales correctos.  
Los agrupamientos por mes deben consolidar todas las ventas correspondientes al mismo período.

#### Verificación
- Los valores de año, mes y día deben ser coherentes con la fecha original.
- El día de la semana (DOW) debe estar entre 0 (domingo) y 6 (sábado).
- Los días transcurridos deben ser valores numéricos positivos.
- Los agrupamientos por mes deben mostrar un único registro por cada mes con ventas.


<br/><br/>

### Paso 9. Funciones Matemáticas
Aplicar funciones matemáticas para cálculos y redondeos.
 
1.	Aplique funciones de redondeo:

    ```sql
    -- Ejercicio 9.1: Redondeo de números
    SELECT
        precio,
        ROUND(precio) AS redondeado,
        ROUND(precio, 1) AS un_decimal,
        CEIL(precio) AS redondeo_superior,
        FLOOR(precio) AS redondeo_inferior
    FROM productos
    LIMIT 10;
    ```

2.	Calcule valores absolutos y signos:

    ```sql
    -- Ejercicio 9.2: Valores absolutos
    SELECT
        precio,
        precio - 5000 AS diferencia,
        ABS(precio - 5000) AS diferencia_absoluta,
        SIGN(precio - 5000) AS signo
    FROM productos
    LIMIT 10;
    ```

3.	Use funciones de potencia y raíz:

    ```sql
    -- Ejercicio 9.3: Potencias y raíces
    SELECT
        stock,
        POWER(stock, 2) AS stock_al_cuadrado,
        SQRT(stock) AS raiz_cuadrada_stock,
        ROUND(SQRT(stock), 2) AS raiz_redondeada
    FROM productos
    WHERE stock > 0
    LIMIT 10;
    ```

4.	Calcule módulos y divisiones:

    ```sql
    -- Ejercicio 9.4: Módulo y división
    SELECT
        id,
        precio,
        MOD(precio::INTEGER, 100) AS modulo_100,
        precio / 100 AS division_entera,
        ROUND(precio / 100.0, 2) AS division_decimal
    FROM productos
    LIMIT 10;
    ```

5.	Genere números aleatorios:

    ```sql
    -- Ejercicio 9.5: Números aleatorios
    SELECT
        nombre,
        precio,
        RANDOM() AS aleatorio_0_1,
        ROUND(RANDOM() * 100) AS aleatorio_0_100,
        FLOOR(RANDOM() * 10 + 1) AS aleatorio_1_10
    FROM productos
    LIMIT 10;
    ```

<br/><br/>

#### Salida esperada
Cada consulta debe mostrar los cálculos matemáticos aplicados correctamente.  
Los valores redondeados deben seguir las reglas matemáticas estándar.

#### Verificación
- La función `ROUND()` debe redondear al entero más cercano cuando no se especifican decimales.
- La función `CEIL()` siempre debe redondear hacia arriba y `FLOOR()` siempre hacia abajo.
- La función `ABS()` debe retornar siempre valores positivos.
- La función `RANDOM()` debe generar valores distintos en cada ejecución.


<br/><br/>


### Paso 10. Consultas Complejas Integradas
Combinar múltiples técnicas aprendidas en consultas complejas.
 
1.	Cree un reporte completo de productos:

    ```sql
    -- Ejercicio 10.1: Reporte detallado de productos
    SELECT
        UPPER(p.nombre) AS producto,
        c.nombre AS categoria,
        CONCAT('$', ROUND(p.precio, 2)) AS precio_formateado,
        p.stock AS stock_actual,
        CASE
            WHEN p.stock = 0 THEN 'SIN STOCK'
            WHEN p.stock < 20 THEN 'STOCK BAJO'
            WHEN p.stock < 50 THEN 'STOCK MEDIO'
            ELSE 'STOCK ALTO'
        END AS estado_stock,
        ROUND(p.precio * p.stock, 2) AS valor_inventario
    FROM productos p
    INNER JOIN categorias c ON p.categoria_id = c.id
    ORDER BY valor_inventario DESC
    LIMIT 20;
    ```

2.	Analice el rendimiento de ventas:

    ```sql
    -- Ejercicio 10.2: Análisis de ventas
    SELECT
        TO_CHAR(v.fecha, 'YYYY-MM') AS periodo,
        COUNT(DISTINCT v.id) AS total_ventas,
        COUNT(DISTINCT v.cliente_id) AS clientes_unicos,
        SUM(v.total) AS monto_total,
        ROUND(AVG(v.total), 2) AS ticket_promedio,
        MAX(v.total) AS venta_maxima,
        MIN(v.total) AS venta_minima
    FROM ventas v
    GROUP BY TO_CHAR(v.fecha, 'YYYY-MM')
    ORDER BY periodo DESC;
    ```

3.	Identifique productos más vendidos:

    ```sql
    -- Ejercicio 10.3: Top productos vendidos
    SELECT
        p.nombre AS producto,
        c.nombre AS categoria,
        COUNT(dv.id) AS veces_vendido,
        SUM(dv.cantidad) AS unidades_vendidas,
        ROUND(SUM(dv.subtotal), 2) AS ingresos_generados,
        ROUND(AVG(dv.precio_unitario), 2) AS precio_promedio_venta
    FROM detalle_ventas dv
    INNER JOIN productos p ON dv.producto_id = p.id
    INNER JOIN categorias c ON p.categoria_id = c.id
    GROUP BY p.id, p.nombre, c.nombre
    HAVING SUM(dv.cantidad) > 0
    ORDER BY unidades_vendidas DESC
    LIMIT 15;
    ```

4.	Cree un análisis de clientes:

    ```sql
    -- Ejercicio 10.4: Perfil de clientes
    SELECT
        CONCAT(c.nombre, ' ', c.apellido) AS cliente_completo,
        c.email,
        COUNT(v.id) AS total_compras,
        ROUND(SUM(v.total), 2) AS gasto_total,
        ROUND(AVG(v.total), 2) AS gasto_promedio,
        MAX(v.fecha) AS ultima_compra,
        CURRENT_DATE - MAX(DATE(v.fecha)) AS dias_sin_comprar,
        CASE
            WHEN COUNT(v.id) >= 5 THEN 'PREMIUM'
            WHEN COUNT(v.id) >= 3 THEN 'REGULAR'
            ELSE 'NUEVO'
        END AS tipo_cliente
    FROM clientes c
    LEFT JOIN ventas v ON c.id = v.cliente_id
    GROUP BY c.id, c.nombre, c.apellido, c.email
    HAVING COUNT(v.id) > 0
    ORDER BY gasto_total DESC;
    ```

5.	Genere un dashboard ejecutivo:

    ```sql
    -- Ejercicio 10.5: Dashboard general
    SELECT 'Total Productos' AS metrica,
        COUNT(*)::TEXT AS valor
    FROM productos
    UNION ALL
    SELECT 'Valor Inventario',
        CONCAT('$', ROUND(SUM(precio * stock), 2))
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
    ```

<br/><br/>

#### Salida esperada
Consultas complejas que integran múltiples técnicas y producen reportes analíticos útiles.  
Los resultados deben ser coherentes y proporcionar información valiosa sobre el negocio.

#### Verificación
- El reporte de productos debe mostrar información completa y correctamente formateada.
- Los análisis de ventas deben incluir múltiples métricas calculadas correctamente.
- Los productos más vendidos deben estar ordenados por unidades vendidas.
- El perfil de clientes debe clasificarlos correctamente según su nivel de actividad.
- El dashboard debe mostrar métricas clave del negocio en un formato consolidado.


<br/><br/>

### Validación y pruebas  

- [ ] Todas las consultas se ejecutan sin errores de sintaxis.
- [ ] Los resultados de las consultas son coherentes con los datos de la base de datos.
- [ ] Las funciones de agregación (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) retornan valores correctos.
- [ ] Los filtros `WHERE` y `HAVING` funcionan según lo esperado.
- [ ] Los ordenamientos con `ORDER BY` organizan los datos correctamente.
- [ ] Las funciones de texto, fecha y matemáticas producen resultados precisos.
- [ ] Las consultas complejas integran múltiples técnicas de forma exitosa.
- [ ] Se comprende la diferencia entre `WHERE` (filtro de filas) y `HAVING` (filtro de grupos).
- [ ] Se pueden explicar claramente los resultados obtenidos en cada ejercicio.


<br/><br/>

## Procedimiento de Prueba

### 1. Ejecute una verificación general de todas las tablas:

```sql
    -- Test 1: Verificar integridad de datos
    SELECT
        (SELECT COUNT(*) FROM productos) AS total_productos,
        (SELECT COUNT(*) FROM categorias) AS total_categorias,
        (SELECT COUNT(*) FROM clientes) AS total_clientes,
        (SELECT COUNT(*) FROM ventas) AS total_ventas,
        (SELECT COUNT(*) FROM detalle_ventas) AS total_detalles;
```

#### Resultado Esperado: 
Todos los conteos deben ser mayores que cero.

<br/><br/>

### 2. Valide que las agregaciones son correctas

```sql
    -- Test 2: Validar agregaciones
    SELECT
        COUNT(*) AS productos_contados,
        SUM(1) AS suma_manual,
        COUNT(*) = SUM(1) AS conteo_correcto
    FROM
        productos;
```

#### Resultado Esperado:
La columna `conteo_correcto` debe mostrar el valor `true`.

<br/><br/>

### 3. Pruebe la consistencia de GROUP BY

```sql
    -- Test 3: Consistencia de agrupamiento
    SELECT
        (SELECT COUNT(*) FROM productos) AS total_productos,
        (SELECT SUM(cantidad)
        FROM (
            SELECT COUNT(*) AS cantidad
            FROM productos
            GROUP BY categoria_id
        ) subquery) AS suma_por_grupos,
        (SELECT COUNT(*) FROM productos) =
        (SELECT SUM(cantidad)
        FROM (
            SELECT COUNT(*) AS cantidad
            FROM productos
            GROUP BY categoria_id
        ) subquery) AS agrupamiento_correcto;
```

#### Resultado Esperado:

La columna `agrupamiento_correcto` debe mostrar el valor `true`.

<br/><br/>

### 4. Verifique el funcionamiento de HAVING

```sql
    -- Test 4: Validar HAVING
    SELECT  categoria_id, COUNT(*) AS cantidad
    FROM
        productos
    GROUP BY
        categoria_id
    HAVING
        COUNT(*) > 0
    ORDER BY
        cantidad DESC;
```

#### Resultado Esperado:

Debe mostrar todas las categorías que tengan al menos un producto asociado.

<br/><br/>

### 5. Pruebe las funciones de fecha

```sql
    -- Test 5: Validar funciones de fecha
    SELECT
        fecha,
        EXTRACT(YEAR FROM fecha) AS anio,
        EXTRACT(YEAR FROM fecha) >= 2020 AS anio_valido
    FROM
        ventas
    LIMIT 5;
```

#### Resultado Esperado:

La columna `anio_valido` debe mostrar valores booleanos coherentes con el año de la fecha.

<br/><br/>


## Solución de Problemas

### Problema 1. Error de sintaxis en consultas con funciones

#### Síntomas
- Mensaje de error: `ERROR: function does not exist`
- La consulta no se ejecuta y muestra un error de función desconocida.

#### Causa
Uso incorrecto del nombre de la función o de los parámetros esperados por las funciones de PostgreSQL.

#### Solución

```sql
-- Incorrecto
SELECT ROUND(precio, 2.5) FROM productos;

-- Correcto
SELECT ROUND(precio, 2) FROM productos;

-- Verificación de la sintaxis correcta de la función
SELECT ROUND(1234.5678, 2);  -- Debe retornar 1234.57
```

#### Prevención

* Consultar la documentación oficial de PostgreSQL para conocer la sintaxis exacta de cada función.
* Utilizar el autocompletado de pgAdmin para identificar los parámetros esperados.
* Probar las funciones con valores literales antes de aplicarlas sobre columnas de tablas.

<br/><br/>

### Problema 2. Resultados inesperados con GROUP BY

#### Síntomas
- Error: `ERROR: column must appear in the GROUP BY clause or be used in an aggregate function`
- Los resultados agrupados no muestran las columnas esperadas.

#### Causa
Todas las columnas incluidas en la cláusula `SELECT` deben estar presentes en la cláusula `GROUP BY` o formar parte de una función de agregación.

#### Solución

```sql
-- Incorrecto
SELECT categoria_id, nombre, COUNT(*) FROM productos GROUP BY categoria_id;

-- Correcto (opción 1: agregar la columna a GROUP BY)
SELECT categoria_id, nombre, COUNT(*) FROM productos GROUP BY categoria_id, nombre;

-- Correcto (opción 2: usar solo columnas agrupadas y agregadas)
SELECT categoria_id, COUNT(*) AS total FROM productos GROUP BY categoria_id;
```

#### Prevención

- Revisar cuidadosamente qué columnas son necesarias en el resultado final.
- Asegurarse de que cada columna no agregada esté incluida en la cláusula `GROUP BY`.
- Utilizar alias descriptivos para las funciones de agregación.


<br/><br/>

### Problema 3. HAVING vs WHERE: uso incorrecto

#### Síntomas
- Error: `ERROR: aggregate functions are not allowed in WHERE`
- Los filtros no funcionan como se esperaba.

#### Causa
Confusión entre la cláusula `WHERE` (filtra filas antes de agrupar) y la cláusula `HAVING` (filtra grupos después de aplicar funciones de agregación).

#### Solución

```sql
-- Incorrecto: no se puede usar COUNT en WHERE
SELECT categoria_id, COUNT(*) FROM productos WHERE COUNT(*) > 5 GROUP BY categoria_id;

-- Correcto: usar HAVING para filtrar grupos
SELECT categoria_id, COUNT(*) AS total FROM productos GROUP BY categoria_id HAVING COUNT(*) > 5;

-- Correcto: combinar WHERE y HAVING
SELECT categoria_id, COUNT(*) AS total FROM productos WHERE precio > 1000 GROUP BY categoria_id HAVING COUNT(*) > 5;
```

#### Prevención

- Utilizar `WHERE` para filtrar filas individuales antes de la agrupación.
- Utilizar `HAVING` para filtrar grupos basándose en resultados de funciones de agregación.
- Recordar el orden lógico de ejecución: `WHERE → GROUP BY → HAVING → ORDER BY`.


<br/><br/>

### Problema 4. División por cero en cálculos

#### Síntomas
- Error: `ERROR: division by zero`
- La consulta falla al intentar dividir por valores que pueden ser cero.

#### Causa
Intentar dividir por columnas o expresiones que contienen valores con valor cero.

#### Solución

```sql
-- Incorrecto: puede causar división por cero
SELECT nombre, precio / stock AS precio_por_unidad FROM productos;

-- Correcto: usar NULLIF para evitar división por cero
SELECT nombre, precio / NULLIF(stock, 0) AS precio_por_unidad FROM productos;

-- Correcto: usar CASE para manejar el caso
SELECT nombre, CASE WHEN stock = 0 THEN NULL ELSE precio / stock END AS precio_por_unidad FROM productos;
```

#### Prevención

* Utilizar `NULLIF(columna, 0)` en divisiones para convertir ceros en `NULL`.
* Implementar validaciones con `CASE WHEN` para manejar casos especiales.
* Filtrar previamente los registros con divisor cero usando `WHERE` antes de realizar el cálculo.


<br/><br/>

### Problema 5. Conversión de tipos de datos incorrecta

#### Síntomas
- Error: `ERROR: operator does not exist`
- Error: `ERROR: invalid input syntax for type`
- Los cálculos no producen los resultados esperados.

#### Causa
Operaciones entre tipos de datos incompatibles sin realizar una conversión explícita.

#### Solución

```sql
-- Incorrecto: concatenar número con texto sin conversión
SELECT 'Precio: ' + precio FROM productos;

-- Correcto: usar :: o CAST para convertir tipos
SELECT 'Precio: ' || precio::TEXT FROM productos;
SELECT 'Precio: ' || CAST(precio AS TEXT) FROM productos;

-- Correcto: convertir texto a número
SELECT '100'::INTEGER + 50;  -- Resultado: 150

-- Correcto: convertir fecha a texto con formato
SELECT TO_CHAR(fecha, 'DD/MM/YYYY') FROM ventas;
```

#### Prevención

* Utilizar `::` o `CAST()` para conversiones explícitas de tipo.
* Emplear el operador `||` para concatenación de texto en lugar de `+`.
* Revisar los tipos de datos de las columnas antes de operar con ellas.
* Utilizar funciones de conversión específicas como `TO_CHAR()`, `TO_DATE()` y `TO_NUMBER()`.


<br/><br/>

## Limpieza

Este laboratorio es de solo lectura (consultas `SELECT`), por lo que no requiere limpieza de datos.  
Sin embargo, es buena práctica cerrar las conexiones adecuadamente.

```sql
-- Verificar conexiones activas (opcional)
SELECT datname AS base_datos, COUNT(*) AS conexiones_activas
FROM pg_stat_activity
WHERE datname = 'tienda_barrio'
GROUP BY datname;
```

<br/><br/>

## Resumen

### Lo que ha logrado

- Ejecutado más de **50 consultas SQL** progresivas desde básicas hasta complejas.
- Aplicado filtros con `WHERE` usando múltiples operadores (comparación, lógicos, `LIKE`, `BETWEEN`, `IN`).
- Implementado ordenamientos simples y compuestos con `ORDER BY` y limitado resultados con `LIMIT`.
- Utilizado funciones de agregación (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) para análisis estadístico.
- Creado agrupamientos con `GROUP BY` y aplicado filtros a grupos con `HAVING`.
- Manipulado texto con funciones de cadena (`UPPER`, `LOWER`, `CONCAT`, `SUBSTRING`, `TRIM`, `REPLACE`).
- Trabajado con fechas usando `EXTRACT`, `TO_CHAR`, `DATE_TRUNC` y cálculos temporales.
- Aplicado funciones matemáticas para redondeo, potencias, raíces y cálculos diversos.
- Desarrollado consultas complejas que integran múltiples técnicas simultáneamente.
- Generado reportes analíticos útiles para la toma de decisiones de negocio.


<br/><br/>

## Conceptos Clave Aprendidos

- **SELECT**  
  Instrucción fundamental para recuperar datos de bases de datos relacionales.

- **WHERE vs HAVING**  
  `WHERE` filtra filas antes de la agrupación; `HAVING` filtra grupos después de aplicar funciones de agregación.

- **Orden lógico de ejecución SQL**  
  `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`

- **Funciones de agregación**  
  Operan sobre conjuntos de filas para producir un único valor (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`).

- **GROUP BY**  
  Agrupa filas que comparten valores comunes para aplicar funciones de agregación.

- **Proyección de columnas**  
  Seleccionar únicamente las columnas necesarias mejora el rendimiento y la claridad de las consultas.

- **Alias**  
  Mejoran la legibilidad de las consultas y de los resultados mediante el uso de `AS`.

- **Conversión de tipos**  
  PostgreSQL requiere conversiones explícitas entre tipos de datos incompatibles.

- **CASE WHEN**  
  Permite implementar lógica condicional directamente dentro de consultas SQL.

- **Funciones integradas**  
  PostgreSQL ofrece una amplia biblioteca de funciones para la manipulación y análisis de datos.


<br/><br/>


## Próximos Pasos

- **Lab 5.1:** Consultas avanzadas con JOINs para combinar datos de múltiples tablas.
- Practicar consultas adicionales sobre la base de datos `tienda_barrio` para reforzar los conceptos aprendidos.
- Explorar la documentación oficial de funciones de PostgreSQL para descubrir más capacidades del motor.
- Experimentar con subconsultas (subqueries) para construir consultas más sofisticadas.
- Investigar el uso de vistas (`VIEWS`) para encapsular consultas complejas y reutilizables.
- Estudiar índices y su impacto en el rendimiento de las consultas.
- Comenzar a diseñar consultas orientadas al proyecto final de base de datos.


<br/><br/>

## Recursos Adicionales

- **Documentación Oficial de PostgreSQL 18 – Funciones y Operadores**  
  https://www.postgresql.org/docs/18/functions.html  
  Referencia completa de todas las funciones integradas.

- **PostgreSQL Tutorial – SELECT Statement**  
  https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-select/  
  Tutorial interactivo de consultas SELECT.

- **SQL Aggregate Functions**  
  https://www.postgresqltutorial.com/postgresql-aggregate-functions/  
  Guía detallada de funciones de agregación.

- **PostgreSQL Date/Time Functions**  
  https://www.postgresql.org/docs/18/functions-datetime.html  
  Documentación oficial de funciones de fecha y hora.

- **PostgreSQL String Functions**  
  https://www.postgresql.org/docs/18/functions-string.html  
  Referencia completa de funciones de texto.

- **SQLBolt – Interactive Lessons**  
  https://sqlbolt.com/  
  Lecciones interactivas de SQL para práctica adicional.

- **Mode Analytics – SQL Tutorial**  
  https://mode.com/sql-tutorial/  
  Tutorial completo con ejercicios prácticos.

- **PostgreSQL Exercises**  
  https://pgexercises.com/  
  Plataforma de ejercicios prácticos de PostgreSQL.

- **Stack Overflow – PostgreSQL Tag**  
  https://stackoverflow.com/questions/tagged/postgresql  
  Comunidad para resolver dudas específicas.

- **W3Schools – SQL Tutorial**  
  https://www.w3schools.com/sql/  
  Referencia rápida con ejemplos ejecutables.


