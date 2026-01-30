

CREATE TABLE IF NOT EXISTS pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(cliente_id),
    fecha_pedido TIMESTAMP NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,
    impuesto NUMERIC(10,2) NOT NULL,
    descuento NUMERIC(10,2) NOT NULL DEFAULT 0,
    total NUMERIC(10,2) NOT NULL,
    metodo_pago VARCHAR(20),
    estado VARCHAR(20)
);


CREATE TABLE IF NOT EXISTS detalle_pedidos (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(pedido_id),
    producto_id INTEGER NOT NULL REFERENCES productos(producto_id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL
);

INSERT INTO pedidos
(cliente_id, fecha_pedido, subtotal, impuesto, descuento, total, metodo_pago, estado)
VALUES
(1, '2024-01-05', 12000, 1920, 0, 13920, 'Tarjeta', 'Pagado'),
(1, '2024-01-20', 18000, 2880, 0, 20880, 'Tarjeta', 'Pagado'),
(2, '2024-01-15', 8500, 1360, 0, 9860, 'Efectivo', 'Pagado'),
(3, '2024-02-10', 25000, 4000, 0, 29000, 'Transferencia', 'Pagado'),
(3, '2024-02-20', 18000, 2880, 0, 20880, 'Tarjeta', 'Pagado'),
(4, '2024-03-01', 32000, 5120, 0, 37120, 'Tarjeta', 'Pagado'),
(5, '2024-03-15', 45000, 7200, 0, 52200, 'Transferencia', 'Pagado');


INSERT INTO detalle_pedidos
(pedido_id, producto_id, cantidad, precio_unitario)
VALUES
(1, 1, 1, 12000),
(2, 1, 1, 12000),
(2, 2, 1, 6000),
(3, 3, 2, 4250),
(4, 1, 1, 12000),
(4, 4, 1, 13000),
(5, 2, 2, 9000),
(6, 5, 2, 16000),
(7, 1, 3, 15000),
(7, 6, 1, 0);


-- Conteos
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalle_pedidos', COUNT(*) FROM detalle_pedidos;

-- Integridad
SELECT COUNT(*)
FROM detalle_pedidos dp
LEFT JOIN pedidos p ON dp.pedido_id = p.pedido_id
WHERE p.pedido_id IS NULL;
-- Debe retornar 0



