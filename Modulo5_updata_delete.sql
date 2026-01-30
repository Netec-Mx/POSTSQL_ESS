
-- Verificar conexión a la base de datos
SELECT current_database(), current_user;

-- Verificar tablas existentes
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;


-- Crear respaldo de estudiantes

SELECT * FROM estudiantes;

CREATE TABLE estudiantes_backup AS
SELECT * FROM estudiantes;

SELECT * from estudiantes_backup;

-- Verificar respaldo
SELECT COUNT(*) as total_respaldo FROM estudiantes_backup;

-- Ver estudiantes actuales
SELECT estudiante_id, nombre, apellido, email, fecha_inscripcion
FROM estudiantes
ORDER BY estudiante_id
LIMIT 5;

-------------------------------------------
Paso 2. UPDATE Simple - Modificar un Registro Específico
-------------------------------------------
-- Consultar antes de actualizar
SELECT estudiante_id, nombre, apellido, email
FROM estudiantes
WHERE estudiante_id = 1;

-- Actualizar email
UPDATE estudiantes
SET email = 'juan.perez.nuevo@email.com'
WHERE estudiante_id = 1;

-- Verificar actualización
SELECT estudiante_id, nombre, apellido, email
FROM estudiantes
WHERE estudiante_id = 1;

--------------------------------------------------------
Paso 3: UPDATE Masivo con WHERE - Actualización Selectiva
--------------------------------------------------------
-- Ver estudiantes a actualizar
SELECT estudiante_id, nombre, apellido, fecha_inscripcion
FROM estudiantes
WHERE fecha_inscripcion < '2024-01-20'
ORDER BY fecha_inscripcion;


-- Agregar columna si no existe
ALTER TABLE estudiantes
ADD COLUMN IF NOT EXISTS observaciones VARCHAR(200);


-- Actualizar múltiples registros
UPDATE estudiantes
SET observaciones = 'Estudiante inscrito en primera cohorte'
WHERE fecha_inscripcion < '2024-01-20';

-- Verificar actualizaciones
SELECT estudiante_id, nombre, apellido, observaciones
FROM estudiantes
WHERE observaciones IS NOT NULL;


-----------------------------------------------------------------------
-- Paso 4. UPDATE con Expresiones Calculadas - Incremento Porcentual
-----------------------------------------------------------------------

-- Ver precios actuales
SELECT curso_id, nombre_curso, precio
FROM cursos
ORDER BY precio DESC;


-- Incrementar precios en 10%
UPDATE cursos
SET precio = precio * 1.10
WHERE precio > 100;


-- Comparar precios
SELECT
    curso_id,
    nombre_curso,
    precio as precio_nuevo,
    ROUND(precio / 1.10, 2) as precio_anterior
FROM cursos
WHERE precio > 110
ORDER BY precio DESC;


-----------------------------------------------------------------------
-- Paso 5: UPDATE con Subconsultas - Actualización Basada en Otra Tabla
-----------------------------------------------------------------------

-- Agregar columna para contador
ALTER TABLE cursos
ADD COLUMN IF NOT EXISTS total_inscritos INTEGER DEFAULT 0;

-- Actualizar con subconsulta

select * from inscripciones;

UPDATE cursos
SET total_inscritos = (
    SELECT COUNT(*)
    FROM inscripciones
    WHERE inscripciones.curso_id = cursos.curso_id
);


select * from inscripciones;

-- Verificar actualización
SELECT
    c.curso_id,
    c.nombre_curso,
    c.total_inscritos,
    COUNT(i.inscripcion_id) as verificacion_count
FROM cursos c
LEFT JOIN inscripciones i ON c.curso_id = i.curso_id
GROUP BY c.curso_id, c.nombre_curso, c.total_inscritos
ORDER BY c.total_inscritos DESC;

-----------------------------------------------------------------------
-- Paso 6: UPDATE de Múltiples Columnas Simultáneamente
-----------------------------------------------------------------------

-- Ver datos actuales
SELECT estudiante_id, nombre, apellido, email, observaciones
FROM estudiantes
WHERE estudiante_id = 3;

-- Actualizar múltiples columnas
UPDATE estudiantes
SET
    email = 'carlos.lopez.actualizado@email.com',
    observaciones = 'Datos actualizados - Verificado 2024',
    fecha_inscripcion = '2024-01-18'
WHERE estudiante_id = 3;

-- Verificar cambios múltiples
SELECT estudiante_id, nombre, apellido, email, observaciones, fecha_inscripcion
FROM estudiantes
WHERE estudiante_id = 3;


---------------------------------------------------------------------
-- Paso 7. Paso 7: DELETE Simple - Eliminar Registros Específicos
---------------------------------------------------------------------

-- Insertar registro de prueba
INSERT INTO estudiantes (nombre, apellido, email, fecha_inscripcion)
VALUES ('Temporal', 'Prueba', 'temporal@test.com', CURRENT_DATE)
RETURNING estudiante_id;

-- Verificar existencia
SELECT * FROM estudiantes WHERE email = 'temporal@test.com';

-- Eliminar registro específico
DELETE FROM estudiantes
WHERE email = 'temporal@test.com';

-- Verificar eliminación
SELECT * FROM estudiantes WHERE email = 'temporal@test.com';
WHERE email = 'temporal@test.com';


--------------------------------------------------------------------------
-- Paso 8: Manejo de Restricciones de Integridad Referencial
--------------------------------------------------------------------------

-- Verificar estudiante con inscripciones
SELECT e.estudiante_id, e.nombre, e.apellido, COUNT(i.inscripcion_id) as total_inscripciones
FROM estudiantes e
INNER JOIN inscripciones i ON e.estudiante_id = i.estudiante_id
GROUP BY e.estudiante_id, e.nombre, e.apellido
HAVING COUNT(i.inscripcion_id) > 0
LIMIT 1;

-- Intentar eliminar (generará error)
DELETE FROM estudiantes
WHERE estudiante_id = 4;

-- Ver registros dependientes
SELECT inscripcion_id, estudiante_id, curso_id, fecha_inscripcion
FROM inscripciones
WHERE estudiante_id = 4;



--------------------------------------------------------------------------
-- Paso 9: DELETE con CASCADE - Eliminación en Cascada
--------------------------------------------------------------------------

-- Crear tablas de prueba

drop table productos_prueba;
drop table categorias_prueba;

CREATE TABLE IF NOT EXISTS categorias_prueba (
	categoria_id SERIAL PRIMARY KEY,
	nombre_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS productos_prueba (
	producto_id SERIAL PRIMARY KEY,
	nombre_producto VARCHAR(100) NOT NULL,
	categoria_id INTEGER REFERENCES categorias_prueba(categoria_id) ON DELETE CASCADE
);


-- Insertar categoría
INSERT INTO categorias_prueba (nombre_categoria)
VALUES ('Electrónica')
RETURNING categoria_id;

select * from categorias_prueba;

-- Insertar productos (usar el categoria_id retornado, asumiendo 1)
INSERT INTO productos_prueba (nombre_producto, categoria_id)
VALUES
    ('Laptop', 1),
    ('Mouse', 1),
    ('Teclado', 1);

select * from productos_prueba;

-- Ver datos relacionados
SELECT c.categoria_id, c.nombre_categoria, COUNT(p.producto_id) as total_productos
FROM categorias_prueba c
LEFT JOIN productos_prueba p ON c.categoria_id = p.categoria_id
GROUP BY c.categoria_id, c.nombre_categoria;	

-- Eliminar con CASCADE
DELETE FROM categorias_prueba
WHERE categoria_id = 1;

-- Verificar eliminación en cascada
SELECT * FROM productos_prueba;



--------------------------------------------------------------------------
-- Paso 10: Transacciones - BEGIN, COMMIT y ROLLBACK
--------------------------------------------------------------------------


-- Iniciar transacción
BEGIN;

-- Ver precio actual
SELECT curso_id, nombre_curso, precio
FROM cursos
WHERE curso_id = 2;

-- Actualizar precio
UPDATE cursos
SET precio = 150.00
WHERE curso_id = 2;

-- Verificar cambio (dentro de la transacción)
SELECT curso_id, nombre_curso, precio
FROM cursos
WHERE curso_id = 2;

-- Revertir cambios
ROLLBACK;

-- Verificar que el precio no cambió
SELECT curso_id, nombre_curso, precio
FROM cursos
WHERE curso_id = 2;


-- Nueva transacción
BEGIN;

-- Actualizar precio
UPDATE cursos
SET precio = 145.00
WHERE curso_id = 2;

-- Confirmar cambios
COMMIT;

-- Verificar cambio permanente
SELECT curso_id, nombre_curso, precio
FROM cursos
WHERE curso_id = 2;


--------------------------------------------------------------------------
-- Paso 11: Soft Delete - Estrategia de Eliminación Lógica
--------------------------------------------------------------------------

-- Agregar columna de estado
ALTER TABLE estudiantes
ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT TRUE;

-- Verificar columna agregada
SELECT estudiante_id, nombre, apellido, activo
FROM estudiantes
LIMIT 6;


-- Soft delete: marcar como inactivo
UPDATE estudiantes
SET activo = FALSE
WHERE estudiante_id = 5;

-- Ver solo estudiantes activos
SELECT estudiante_id, nombre, apellido, email, activo
FROM estudiantes
WHERE activo = TRUE
ORDER BY estudiante_id;


-- Ver estudiantes inactivos (eliminados lógicamente)
SELECT estudiante_id, nombre, apellido, email, activo
FROM estudiantes
WHERE activo = FALSE;


-- Restaurar estudiante
UPDATE estudiantes
SET activo = TRUE
WHERE estudiante_id = 5;

-- Verificar restauración
SELECT estudiante_id, nombre, apellido, activo
FROM estudiantes
WHERE estudiante_id = 5;


--------------------------------------------------------------------------
-- Paso 12: Práctica Combinada - Transacción Compleja
--------------------------------------------------------------------------


-- Transacción compleja
BEGIN;

-- 1. Actualizar precio de un curso
UPDATE cursos
SET precio = precio * 0.90
WHERE curso_id = 3;

-- 2. Agregar observación a estudiantes de ese curso
UPDATE estudiantes
SET observaciones = 'Curso con descuento aplicado'
WHERE estudiante_id IN (
    SELECT estudiante_id
    FROM inscripciones
    WHERE curso_id = 3
);

-- 3. Verificar cambios antes de confirmar
SELECT c.curso_id, c.nombre_curso, c.precio,
        e.estudiante_id, e.nombre, e.apellido, e.observaciones
FROM cursos c
INNER JOIN inscripciones i ON c.curso_id = i.curso_id
INNER JOIN estudiantes e ON i.estudiante_id = e.estudiante_id
WHERE c.curso_id = 3;

-- 4. Confirmar si todo está correcto
COMMIT;


-- Verificación final
SELECT
    c.nombre_curso,
    c.precio as precio_con_descuento,
    COUNT(DISTINCT e.estudiante_id) as estudiantes_notificados
FROM cursos c
INNER JOIN inscripciones i ON c.curso_id = i.curso_id
INNER JOIN estudiantes e ON i.estudiante_id = e.estudiante_id
WHERE c.curso_id = 3
    AND e.observaciones LIKE '%descuento%'
GROUP BY c.nombre_curso, c.precio;


