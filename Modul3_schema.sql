-- Tabla: categorias
-- Descripción: Almacena las categorías de productos disponibles en la tienda
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comentario de la tabla
COMMENT ON TABLE categorias IS 'Catálogo de categorías de productos';
COMMENT ON COLUMN categorias.categoria_id IS 'Identificador único de la categoría';
COMMENT ON COLUMN categorias.nombre IS 'Nombre de la categoría (único)';
COMMENT ON COLUMN categorias.activa IS 'Indica si la categoría está activa';


-- Insertar categorías de prueba
INSERT INTO categorias (nombre, descripcion, activa) VALUES
('Abarrotes', 'Productos de despensa y alimentos no perecederos', TRUE),
('Lácteos', 'Leche, quesos, yogures y derivados', TRUE),
('Bebidas', 'Refrescos, jugos, agua y bebidas alcohólicas', TRUE),
('Panadería', 'Pan, pasteles y productos de panadería', TRUE),
('Limpieza', 'Productos de limpieza para el hogar', TRUE),
('Higiene Personal', 'Jabones, shampoos y productos de cuidado personal', TRUE),
('Snacks', 'Botanas, dulces y golosinas', TRUE),
('Frutas y Verduras', 'Productos frescos del campo', TRUE);

SELECT * FROM categorias ORDER BY categoria_id;

-- Tabla: productos
-- Descripción: Almacena información de los productos disponibles en la tienda

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    categoria_id INTEGER NOT NULL,
    precio_compra NUMERIC(10, 2) NOT NULL CHECK (precio_compra >= 0),
    precio_venta NUMERIC(10, 2) NOT NULL CHECK (precio_venta >= 0),
    stock_actual INTEGER NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INTEGER DEFAULT 5 CHECK (stock_minimo >= 0),
    unidad_medida VARCHAR(20) DEFAULT 'unidad',
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Constraint de integridad referencial

    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categorias(categoria_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- Constraint adicional: precio de venta debe ser mayor que precio de compra

    CONSTRAINT chk_precio_venta_mayor
        CHECK (precio_venta > precio_compra)
);

-- Índices para mejorar rendimiento

CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_productos_codigo_barras ON productos(codigo_barras);
CREATE INDEX idx_productos_nombre ON productos(nombre);

-- Comentarios

COMMENT ON TABLE productos IS 'Catálogo de productos disponibles en la tienda';
COMMENT ON COLUMN productos.codigo_barras IS 'Código de barras único del producto';
COMMENT ON COLUMN productos.stock_actual IS 'Cantidad actual en inventario';
COMMENT ON COLUMN productos.stock_minimo IS 'Nivel mínimo de stock para reorden';


-- Insertar productos de prueba
INSERT INTO productos (
    codigo_barras,
    nombre,
    descripcion,
    categoria_id,
    precio_compra,
    precio_venta,
    stock_actual,
    stock_minimo,
    unidad_medida
) VALUES
('7501234567890', 'Arroz Blanco 1kg', 'Arroz grano largo premium', 1, 15.50, 22.00, 50, 10, 'kg'),
('7501234567891', 'Frijol Negro 1kg', 'Frijol negro seleccionado', 1, 18.00, 25.00, 40, 10, 'kg'),
('7501234567892', 'Leche Entera 1L', 'Leche entera pasteurizada', 2, 16.00, 22.50, 30, 15, 'litro'),
('7501234567893', 'Yogurt Natural 1L', 'Yogurt natural sin azúcar', 2, 20.00, 28.00, 25, 10, 'litro'),
('7501234567894', 'Coca Cola 2L', 'Refresco de cola', 3, 18.00, 26.00, 60, 20, 'litro'),
('7501234567895', 'Agua Purificada 1L', 'Agua purificada embotellada', 3, 5.00, 10.00, 100, 30, 'litro'),
('7501234567896', 'Pan Blanco', 'Pan de caja blanco rebanado', 4, 22.00, 32.00, 20, 10, 'pieza'),
('7501234567897', 'Pan Integral', 'Pan de caja integral rebanado', 4, 25.00, 35.00, 15, 10, 'pieza'),
('7501234567898', 'Cloro 1L', 'Blanqueador con cloro', 5, 12.00, 20.00, 35, 10, 'litro'),
('7501234567899', 'Jabón Líquido 500ml', 'Jabón líquido para manos', 6, 25.00, 38.00, 40, 15, 'ml');

SELECT
    p.producto_id,
    p.codigo_barras,
    p.nombre,
    c.nombre AS categoria,
    p.precio_venta,
    p.stock_actual
FROM productos p
INNER JOIN categorias c
    ON p.categoria_id = c.categoria_id
ORDER BY p.producto_id;


-- Tabla: clientes
-- Descripción: Almacena información de los clientes de la tienda

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(150) UNIQUE,
    direccion TEXT,
    colonia VARCHAR(100),
    codigo_postal VARCHAR(10),
    fecha_registro DATE DEFAULT CURRENT_DATE,
    credito_disponible NUMERIC(10, 2) DEFAULT 0.00 CHECK (credito_disponible >= 0),
    limite_credito NUMERIC(10, 2) DEFAULT 0.00 CHECK (limite_credito >= 0),
    activo BOOLEAN DEFAULT TRUE,

    -- Constraint: crédito disponible no puede exceder el límite
    CONSTRAINT chk_credito_limite
        CHECK (credito_disponible <= limite_credito)
);

-- Índices
CREATE INDEX idx_clientes_nombre ON clientes(nombre, apellido_paterno);
CREATE INDEX idx_clientes_telefono ON clientes(telefono);

-- Comentarios
COMMENT ON TABLE clientes IS 'Información de clientes de la tienda';
COMMENT ON COLUMN clientes.credito_disponible IS 'Crédito actual disponible para el cliente';
COMMENT ON COLUMN clientes.limite_credito IS 'Límite máximo de crédito autorizado';

INSERT INTO clientes (
    nombre,
    apellido_paterno,
    apellido_materno,
    telefono,
    email,
    direccion,
    colonia,
    codigo_postal,
    credito_disponible,
    limite_credito
) VALUES
('Juan', 'Pérez', 'García', '5551234567', 'juan.perez@email.com', 'Calle Principal 123', 'Centro', '12345', 500.00, 1000.00),
('María', 'López', 'Martínez', '5552345678', 'maria.lopez@email.com', 'Avenida Juárez 456', 'Norte', '12346', 0.00, 500.00),
('Carlos', 'González', 'Rodríguez', '5553456789', 'carlos.gonzalez@email.com', 'Calle Hidalgo 789', 'Sur', '12347', 750.00, 1500.00),
('Ana', 'Martínez', 'Hernández', '5554567890', 'ana.martinez@email.com', 'Calle Morelos 321', 'Centro', '12345', 0.00, 0.00),
('Luis', 'Hernández', 'Sánchez', '5555678901', 'luis.hernandez@email.com', 'Avenida Reforma 654', 'Este', '12348', 300.00, 800.00),
('Laura', 'García', 'Ramírez', '5556789012', NULL, 'Calle Allende 987', 'Oeste', '12349', 0.00, 0.00),
('Pedro', 'Ramírez', 'Torres', '5557890123', 'pedro.ramirez@email.com', 'Calle Zaragoza 147', 'Norte', '12346', 200.00, 600.00),
('Sofia', 'Torres', 'Flores', '5558901234', 'sofia.torres@email.com', 'Avenida Insurgentes 258', 'Sur', '12347', 0.00, 1000.00);



-- Verificar clientes insertados
SELECT
    cliente_id,
    nombre,
    apellido_paterno,
    telefono,
    credito_disponible,
    limite_credito
FROM clientes
ORDER BY cliente_id;


-- Tabla: ventas
-- Descripción: Registra las transacciones de venta realizadas
CREATE TABLE ventas (
    venta_id SERIAL PRIMARY KEY,
    cliente_id INTEGER,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal NUMERIC(10, 2) NOT NULL CHECK (subtotal >= 0),
    impuesto NUMERIC(10, 2) DEFAULT 0.00 CHECK (impuesto >= 0),
    descuento NUMERIC(10, 2) DEFAULT 0.00 CHECK (descuento >= 0),
    total NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
    metodo_pago VARCHAR(20) NOT NULL
        CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'credito', 'transferencia')),
    estado VARCHAR(20) DEFAULT 'completada'
        CHECK (estado IN ('completada', 'cancelada', 'pendiente')),
    notas TEXT,

    -- Foreign key a clientes (puede ser NULL para ventas sin cliente registrado)
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES clientes(cliente_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    -- Constraint: total debe ser igual a subtotal + impuesto - descuento
    CONSTRAINT chk_total_correcto
        CHECK (total = subtotal + impuesto - descuento)
);

-- Índices
CREATE INDEX idx_ventas_cliente ON ventas(cliente_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_estado ON ventas(estado);

-- Comentarios
COMMENT ON TABLE ventas IS 'Registro de transacciones de venta';
COMMENT ON COLUMN ventas.metodo_pago IS 'Forma de pago: efectivo, tarjeta, credito, transferencia';
COMMENT ON COLUMN ventas.estado IS 'Estado de la venta: completada, cancelada, pendiente';

-- Insertar ventas de prueba
INSERT INTO ventas (
    cliente_id,
    fecha_venta,
    subtotal,
    impuesto,
    descuento,
    total,
    metodo_pago,
    estado
) VALUES
(1, '2024-01-15 10:30:00', 100.00, 16.00, 0.00, 116.00, 'efectivo', 'completada'),
(1, '2024-01-16 14:20:00', 250.00, 40.00, 20.00, 270.00, 'tarjeta', 'completada'),
(2, '2024-01-17 09:15:00', 150.00, 24.00, 0.00, 174.00, 'efectivo', 'completada'),
(3, '2024-01-17 16:45:00', 500.00, 80.00, 50.00, 530.00, 'credito', 'completada'),
(NULL, '2024-01-18 11:00:00', 75.00, 12.00, 0.00, 87.00, 'efectivo', 'completada'),
(4, '2024-01-18 15:30:00', 200.00, 32.00, 10.00, 222.00, 'tarjeta', 'completada'),
(5, '2024-01-19 10:00:00', 300.00, 48.00, 0.00, 348.00, 'credito', 'completada'),
(NULL, '2024-01-19 17:20:00', 120.00, 19.20, 5.00, 134.20, 'efectivo', 'completada');


-- Verificar ventas con información de clientes
SELECT
    v.venta_id,
    COALESCE(c.nombre || ' ' || c.apellido_paterno, 'Cliente General') AS cliente,
    v.fecha_venta,
    v.total,
    v.metodo_pago,
    v.estado
FROM ventas v
LEFT JOIN clientes c
    ON v.cliente_id = c.cliente_id
ORDER BY v.venta_id;

-- Tabla: detalle_ventas
-- Descripción: Almacena el detalle de productos vendidos en cada venta
CREATE TABLE detalle_ventas (
    detalle_id SERIAL PRIMARY KEY,
    venta_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal NUMERIC(10, 2) NOT NULL CHECK (subtotal >= 0),

    -- Foreign keys
    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (venta_id)
        REFERENCES ventas(venta_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(producto_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- Constraint: subtotal debe ser cantidad * precio_unitario
    CONSTRAINT chk_subtotal_correcto
        CHECK (subtotal = cantidad * precio_unitario),

    -- Constraint: no puede haber duplicados de producto en la misma venta
    CONSTRAINT uk_venta_producto
        UNIQUE (venta_id, producto_id)
);

-- Índices
CREATE INDEX idx_detalle_venta ON detalle_ventas(venta_id);
CREATE INDEX idx_detalle_producto ON detalle_ventas(producto_id);

-- Comentarios
COMMENT ON TABLE detalle_ventas IS 'Detalle de productos vendidos en cada transacción';
COMMENT ON COLUMN detalle_ventas.cantidad IS 'Cantidad de unidades vendidas';
COMMENT ON COLUMN detalle_ventas.precio_unitario IS 'Precio unitario al momento de la venta';


-- Insertar detalle de ventas (Venta 1: subtotal 100.00)
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 2, 22.00, 44.00),
(1, 5, 2, 26.00, 52.00),
(1, 10, 1, 4.00, 4.00);

-- Venta 2: subtotal 250.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(2, 3, 5, 22.50, 112.50),
(2, 4, 3, 28.00, 84.00),
(2, 7, 1, 32.00, 32.00),
(2, 9, 1, 20.00, 20.00);

-- Venta 3: subtotal 150.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(3, 2, 4, 25.00, 100.00),
(3, 6, 5, 10.00, 50.00);

-- Venta 4: subtotal 500.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(4, 1, 10, 22.00, 220.00),
(4, 2, 8, 25.00, 200.00),
(4, 5, 3, 26.00, 78.00),
(4, 10, 1, 2.00, 2.00);

-- Venta 5: subtotal 75.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(5, 8, 2, 35.00, 70.00),
(5, 6, 1, 5.00, 5.00);

-- Venta 6: subtotal 200.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(6, 3, 8, 22.50, 180.00),
(6, 9, 1, 20.00, 20.00);

-- Venta 7: subtotal 300.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(7, 5, 10, 26.00, 260.00),
(7, 7, 1, 32.00, 32.00),
(7, 10, 2, 4.00, 8.00);

-- Venta 8: subtotal 120.00
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(8, 1, 3, 22.00, 66.00),
(8, 4, 2, 27.00, 54.00);



-- Verificar detalle de ventas con nombres de productos
SELECT
    dv.detalle_id,
    dv.venta_id,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal
FROM detalle_ventas dv
INNER JOIN productos p
    ON dv.producto_id = p.producto_id
ORDER BY dv.venta_id, dv.detalle_id;


-- Tabla: proveedores
-- Descripción: Almacena información de los proveedores de productos
CREATE TABLE proveedores (
    proveedor_id SERIAL PRIMARY KEY,
    nombre_empresa VARCHAR(200) NOT NULL,
    nombre_contacto VARCHAR(150),
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(150),
    direccion TEXT,
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    codigo_postal VARCHAR(10),
    rfc VARCHAR(13) UNIQUE,
    dias_credito INTEGER DEFAULT 0 CHECK (dias_credito >= 0),
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    notas TEXT
);

-- Índices
CREATE INDEX idx_proveedores_nombre ON proveedores(nombre_empresa);
CREATE INDEX idx_proveedores_rfc ON proveedores(rfc);

-- Comentarios
COMMENT ON TABLE proveedores IS 'Información de proveedores de productos';
COMMENT ON COLUMN proveedores.dias_credito IS 'Días de crédito otorgados por el proveedor';
COMMENT ON COLUMN proveedores.rfc IS 'Registro Federal de Contribuyentes (México)';


-- Insertar proveedores de prueba
INSERT INTO proveedores (
    nombre_empresa,
    nombre_contacto,
    telefono,
    email,
    direccion,
    ciudad,
    estado,
    rfc,
    dias_credito
) VALUES
('Abarrotes Mayoristas SA', 'Roberto Méndez', '5559876543', 'ventas@abarrotes.com', 'Industrial 100', 'Ciudad de México', 'CDMX', 'AMA950101ABC', 30),
('Lácteos del Valle', 'Patricia Ruiz', '5558765432', 'contacto@lacteosval.com', 'Carretera Norte Km 5', 'Querétaro', 'Querétaro', 'LDV980215XYZ', 15),
('Distribuidora de Bebidas', 'Miguel Ángel Castro', '5557654321', 'pedidos@disbebidas.com', 'Boulevard Sur 250', 'Monterrey', 'Nuevo León', 'DBE000320MNO', 20),
('Panificadora La Espiga', 'Carmen Flores', '5556543210', 'ventas@laespiga.com', 'Calle Panaderos 45', 'Guadalajara', 'Jalisco', 'PLE010510PQR', 7),
('Productos de Limpieza Pro', 'Jorge Sánchez', '5555432109', 'info@limpiezapro.com', 'Zona Industrial 300', 'Puebla', 'Puebla', 'PLP020815STU', 30);


-- Verificar proveedores insertados
SELECT
    proveedor_id,
    nombre_empresa,
    nombre_contacto,
    telefono,
    dias_credito
FROM proveedores
ORDER BY proveedor_id;


---

select constraint_name, check_clause
FROM information_schema.check_constraints
Where constraint_schema = 'public' AND constraint_name LIKE '%productos%';
  

