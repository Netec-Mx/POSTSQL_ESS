
-- Agregar columna de observaciones a productos
ALTER TABLE productos
ADD COLUMN observaciones TEXT;

-- Verificar el cambio
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'productos'
  AND column_name = 'observaciones';
  

-- Agregar columna de descuento máximo a clientes
ALTER TABLE clientes
ADD COLUMN descuento_maximo NUMERIC(5, 2) DEFAULT 0.00
CHECK (descuento_maximo >= 0 AND descuento_maximo <= 100);


select * from clientes; 

-- Actualizar algunos clientes con descuento
UPDATE clientes
SET descuento_maximo = 10.00
WHERE credito_disponible > 0;



-- Ampliar el campo de teléfono en clientes
ALTER TABLE clientes
ALTER COLUMN telefono TYPE VARCHAR(20);


-- Agregar constraint para validar formato de email en clientes
ALTER TABLE clientes
ADD CONSTRAINT chk_email_formato
CHECK (email IS NULL OR email LIKE '%@%.%');


-- Verificar la estructura actualizada de clientes
SELECT
    column_name,
    data_type,
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'clientes'
ORDER BY ordinal_position;

-- Resumen de ventas por cliente

SELECT
    COALESCE(c.nombre || ' ' || c.apellido_paterno, 'Cliente General') AS ente,
    COUNT(v.venta_id) AS total_ventas,
    SUM(v.total) AS monto_total,
    AVG(v.total) AS promedio_venta
FROM ventas v
LEFT JOIN clientes c
    ON v.cliente_id = c.cliente_id
WHERE v.estado = 'completada'
GROUP BY
    c.cliente_id,
    c.nombre,
    c.apellido_paterno
ORDER BY monto_total DESC;



-- Top 5 productos más vendidos

SELECT
    p.nombre AS producto,
    c.nombre AS categoria,
    SUM(dv.cantidad) AS unidades_vendidas,
    SUM(dv.subtotal) AS ingresos_generados
FROM detalle_ventas dv
INNER JOIN productos p
    ON dv.producto_id = p.producto_id
INNER JOIN categorias c
    ON p.categoria_id = c.categoria_id
INNER JOIN ventas v
    ON dv.venta_id = v.venta_id
WHERE v.estado = 'completada'
GROUP BY
    p.producto_id,
    p.nombre,
    c.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;


-- Query Correlacionado
SELECT
    COUNT(*) AS productos_sin_categoria
FROM productos p
WHERE  NOT EXISTS (
    SELECT 1
    FROM categorias c
    WHERE c.categoria_id = p.categoria_id
);

select count(*) cuantos from productos;


-- Esto debe fallar debido a ON DELETE RESTRICT
DELETE FROM categorias WHERE categoria_id = 1;


-- Esto debe fallar debido al constraint chk_precio_venta_mayor
INSERT INTO productos (
    codigo_barras,
    nombre,
    categoria_id,
    precio_compra,
    cio_venta,
    stock_actual
)
VALUES (
    '1234567890123',
    'Producto Prueba',
    1,
    50.00,
    40.00,
    10
);


-- Esto debe fallar debido al constraint UNIQUE en codigo_barras
INSERT INTO productos (
    codigo_barras,
    nombre,
    categoria_id,
    precio_compra,
    precio_venta,
    stock_actual
)
VALUES (
    '7501234567890',
    'Otro Producto',
    1,
    10.00,
    15.00,
    5
);
