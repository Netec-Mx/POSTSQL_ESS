═══════════════════════════════════════════════════════════════
DOCUMENTACIÓN DE DISEÑO - BASE DE DATOS TIENDA DE BARRIO
═══════════════════════════════════════════════════════════════

Diseñador: [Tu Nombre]
Fecha: [Fecha Actual]
Versión: 1.0

═══════════════════════════════════════════════════════════════
1. RESUMEN EJECUTIVO
═══════════════════════════════════════════════════════════════

Este diseño de base de datos soporta las operaciones de una tienda de
barrio típica, incluyendo gestión de productos, inventario, ventas,
clientes y proveedores. El modelo está normalizado hasta 3FN con
excepciones justificadas para atributos calculados que requieren
persistencia por razones de auditoría y rendimiento.

Entidades principales: 7
Relaciones: 6
Nivel de normalización: 3FN

═══════════════════════════════════════════════════════════════
2. DECISIONES DE DISEÑO CLAVE
═══════════════════════════════════════════════════════════════

2.1 USO DE CLAVES PRIMARIAS SURROGATE (INTEGER AUTO-INCREMENT)

Decisión: Todas las tablas usan INTEGER auto-incrementable como PK

Alternativa considerada: Claves primarias naturales o compuestas

Justificación:
- Simplifica relaciones entre tablas
- Mejor rendimiento en índices y JOINs
- Facilita migraciones y replicación de datos
- Evita problemas cuando claves naturales cambian
- Estándar en la industria para aplicaciones modernas

Impacto: Todas las tablas tienen campo [tabla]_id como PK

-------------------------------------------------------------------

2.2 TABLA INTERMEDIA DETALLE_VENTA

Decisión: Crear tabla DETALLE_VENTA para resolver relación N:M
            entre VENTA y PRODUCTO

Alternativa considerada: Almacenar productos como array en VENTA

Justificación:
- Cumple con 1FN (elimina grupos repetitivos)
- Permite múltiples productos por venta
- Captura precio histórico al momento de venta
- Facilita consultas y reportes de productos vendidos
- Permite rastrear cantidad vendida por producto

Atributos adicionales:
- precio_unitario: Captura precio al momento de venta
- subtotal: Calculado pero persistido para auditoría

-------------------------------------------------------------------

2.3 TABLA INTERMEDIA PRODUCTO_PROVEEDOR

Decisión: Crear tabla PRODUCTO_PROVEEDOR para resolver relación N:M
            entre PRODUCTO y PROVEEDOR

Alternativa considerada: FK simple proveedor_id en PRODUCTO

Justificación:
- Un producto puede tener múltiples proveedores (backup, mejores precios)
- Un proveedor suministra múltiples productos
- Permite almacenar precio_compra específico por proveedor
- Facilita comparación de precios entre proveedores
- Soporta información de tiempo_entrega_dias por proveedor
- Campo es_proveedor_principal identifica proveedor preferido

-------------------------------------------------------------------

2.4 CLIENTE_ID NULLABLE EN VENTA

Decisión: El campo cliente_id en VENTA acepta NULL

Alternativa considerada: Crear cliente "Anónimo" por defecto

Justificación:
- Muchas ventas en tienda de barrio son anónimas (sin registro)
- NULL es semánticamente correcto (ausencia de información)
- Evita datos ficticios que contaminen estadísticas de clientes
- Permite diferenciar ventas registradas vs anónimas en reportes

Impacto: Las consultas deben manejar cliente_id NULL apropiadamente

-------------------------------------------------------------------

2.5 ATRIBUTOS CALCULADOS PERSISTIDOS

Decisión: Mantener campos calculados (total, subtotal) en la BD

Alternativa considerada: Calcular valores en tiempo de consulta

Campos afectados:
- VENTA.total (= subtotal + impuesto)
- DETALLE_VENTA.subtotal (= cantidad * precio_unitario)

Justificación:
- Auditoría: Valor exacto confirmado al momento de la transacción
- Histórico: Fórmulas de cálculo pueden cambiar con el tiempo
- Rendimiento: Evita recalcular en cada consulta
- Integridad: Valor validado por lógica de negocio
- Reportes: Simplifica agregaciones y análisis

Consideración: Requiere validación en capa de aplicación para
                mantener consistencia

-------------------------------------------------------------------

2.6 CAMPOS DE AUDITORÍA Y CONTROL

Decisión: Incluir campos fecha_registro y activo en entidades principales

Campos implementados:
- fecha_registro (TIMESTAMP): Fecha de creación del registro
- activo (BOOLEAN): Soft delete en lugar de DELETE físico

Justificación:
- Trazabilidad: Saber cuándo se creó cada registro
- Soft delete: Preservar integridad referencial e histórico
- Reportes: Filtrar registros activos/inactivos
- Auditoría: Cumplir con requisitos de trazabilidad

Tablas con estos campos: PRODUCTO, CLIENTE, PROVEEDOR

-------------------------------------------------------------------

2.7 NORMALIZACIÓN DE DIRECCIONES

Decisión: Mantener "direccion" como campo único (VARCHAR(255))

Alternativa considerada: Normalizar en tabla DIRECCION con
                            (calle, ciudad, estado, codigo_postal)

Justificación:
- Simplicidad apropiada para tienda de barrio local
- No se requieren búsquedas geográficas complejas
- Evita sobrenormalización para este contexto
- Reduce complejidad de consultas

Consideración futura: Si se requiere análisis geográfico, crear
                        tabla DIRECCION normalizada


═══════════════════════════════════════════════════════════════
3. RESTRICCIONES Y REGLAS DE NEGOCIO
═══════════════════════════════════════════════════════════════

3.1 CONSTRAINTS DE INTEGRIDAD

- Todas las PKs son NOT NULL, UNIQUE, AUTO_INCREMENT
- Todas las FKs tienen ON DELETE RESTRICT por defecto (protección)
- Campos de precio: DECIMAL(10,2) con CHECK (precio >= 0)
- Campos de cantidad: INTEGER con CHECK (cantidad > 0)
- codigo_barras en PRODUCTO debe ser UNIQUE
- stock_actual debe ser >= 0

3.2 REGLAS DE NEGOCIO IMPLEMENTADAS

RN1: Un producto debe pertenecer a exactamente una categoría
        Implementación: PRODUCTO.categoria_id NOT NULL

RN2: Una venta puede ser anónima o asociada a un cliente
        Implementación: VENTA.cliente_id NULL permitido

RN3: Una venta debe tener al menos un detalle
        Implementación: Validación en capa de aplicación

RN4: El precio de venta debe ser mayor que el precio de compra
        Implementación: Validación en capa de aplicación

RN5: No se pueden vender productos con stock_actual = 0
        Implementación: Validación en capa de aplicación

RN6: stock_actual debe actualizarse después de cada venta
        Implementación: Trigger o lógica de aplicación

═══════════════════════════════════════════════════════════════
4. CONSULTAS TÍPICAS SOPORTADAS
═══════════════════════════════════════════════════════════════

Q1: Productos con stock bajo (< stock_minimo)
Q2: Ventas totales por período
Q3: Productos más vendidos
Q4: Historial de compras de un cliente
Q5: Proveedores de un producto específico
Q6: Productos por categoría
Q7: Ventas totales por cliente
Q8: Productos que necesitan reorden
Q9: Comparación de precios entre proveedores
Q10: Total de ventas por método de pago

═══════════════════════════════════════════════════════════════
5. CONSIDERACIONES FUTURAS
═══════════════════════════════════════════════════════════════

5.1 EXTENSIONES POSIBLES

- Tabla EMPLEADO para registrar quién procesa cada venta
- Tabla PROMOCION para descuentos y ofertas especiales
- Tabla ORDEN_COMPRA para pedidos a proveedores
- Tabla MOVIMIENTO_INVENTARIO para trazabilidad de stock
- Tabla CATEGORIA_NIVEL2 para categorías jerárquicas
- Tabla METODO_PAGO normalizada (actualmente VARCHAR)

5.2 OPTIMIZACIONES FUTURAS

- Índices en campos de búsqueda frecuente (codigo_barras, nombre)
- Índices compuestos para consultas comunes
- Particionamiento de tabla VENTA por fecha (si crece mucho)
- Vistas materializadas para reportes complejos
- Triggers para actualización automática de stock
- Stored procedures para operaciones transaccionales complejas

═══════════════════════════════════════════════════════════════