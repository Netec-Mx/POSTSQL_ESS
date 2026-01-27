# Práctica 5.1 Ejercicios aplicados a la base de datos del curso

<br/><br/>

## Tiempo estimado	
95 minutos

<br/><br/>

## Objetivos 

Al completar este laboratorio, usted será capaz de:

- Ejecutar sentencias `UPDATE` para modificar registros existentes en tablas.
- Aplicar `UPDATE` con cláusula `WHERE` para realizar actualizaciones selectivas y seguras.
- Utilizar `UPDATE` con subconsultas y expresiones calculadas.
- Implementar sentencias `DELETE FROM` para eliminar registros específicos.
- Comprender y manejar restricciones de integridad referencial en operaciones `DELETE`.
- Aplicar transacciones (`BEGIN`, `COMMIT`, `ROLLBACK`) para garantizar la consistencia de los datos.
- Practicar estrategias de respaldo y verificación antes de operaciones destructivas.

<br/><br/>

## Prerrequisitos

### Conocimientos Requeridos

- Comprensión sólida de consultas `SELECT` con `WHERE`, `JOIN` y subconsultas.
- Conocimiento de la estructura de la base de datos del curso (tablas, relaciones, constraints).
- Familiaridad con tipos de datos y operadores SQL.
- Entendimiento básico de integridad referencial y llaves foráneas.

### Acceso Requerido

- Acceso a **pgAdmin** con conexión establecida a **PostgreSQL 18**.
- Base de datos `curso_db` creada y poblada con datos de prueba (Lab 3.1).
- Permisos de lectura y escritura sobre las tablas de la base de datos.


<br/><br/>

## Entorno de Laboratorio

### Requisitos de Hardware

| Componente        | Especificación              |
|------------------|-----------------------------|
| RAM              | Mínimo 4 GB                 |
| Espacio en Disco | 500 MB libres               |
| Procesador       | 64 bits (x86-64)             |


### Requisitos de Software


| Software    | Versión           | Propósito                                   |
|------------|-------------------|---------------------------------------------|
| PostgreSQL | 18.x              | Sistema gestor de base de datos             |
| PgAdmin    | 4.x               | Interfaz gráfica para ejecutar consultas SQL|
| Windows    | 10/11 (64-bit)    | Sistema operativo base                      |
 


### Configuración Inicial

Antes de comenzar, verifique que la base de datos del curso esté disponible:

    ```sql
    -- Verificar conexión a la base de datos
    SELECT current_database(), current_user;

    -- Verificar tablas existentes
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
    ORDER BY table_name;
    ```

<br/><br/>

## Instrucciones 

### Paso 1. Preparación y Respaldo de Datos

Crear respaldos de seguridad y verificar el estado inicial de los datos antes de realizar modificaciones.
 
1.	Abra PgAdmin y conéctese a la base de datos curso_db.

2.	Cree una tabla temporal de respaldo para la tabla estudiantes:
    ```sql
    -- Crear respaldo de estudiantes
    CREATE TABLE estudiantes_backup AS
    SELECT * FROM estudiantes;

    -- Verificar respaldo
    SELECT COUNT(*) as total_respaldo FROM estudiantes_backup;
    ```

3.	Visualice el estado actual de algunos registros que modificaremos:
    ```sql
    -- Ver estudiantes actuales
    SELECT estudiante_id, nombre, apellido, email, fecha_inscripcion
    FROM estudiantes
    ORDER BY estudiante_id
    LIMIT 5;
    ```

<br/><br/>

### Salida Esperada:

```sql
total_respaldo
--------------
           15

estudiante_id | nombre  | apellido | email                    | fecha_inscripcion
--------------+---------+----------+--------------------------+------------------
            1 | Juan    | Pérez    | juan.perez@email.com    | 2024-01-15
            2 | María   | García   | maria.garcia@email.com  | 2024-01-16
            3 | Carlos  | López    | carlos.lopez@email.com  | 2024-01-17
...
```

### Verificación

- La tabla `estudiantes_backup` debe contener el mismo número de registros que `estudiantes`.
- Los datos deben ser idénticos entre ambas tablas.



<br/><br/>

### Paso 2. UPDATE Simple - Modificar un Registro Específico
Actualizar información de un solo estudiante utilizando su clave pri-maria.
 
1.	Primero, consulte el registro actual del estudiante con ID 1:
    ```sql
    -- Consultar antes de actualizar
    SELECT estudiante_id, nombre, apellido, email
    FROM estudiantes
    WHERE estudiante_id = 1;
    ```

2.	Actualice el email del estudiante:
    ```sql
    -- Actualizar email
    UPDATE estudiantes
    SET email = 'juan.perez.nuevo@email.com'
    WHERE estudiante_id = 1;
    ```

3.	Verifique el cambio realizado:
    ```sql
    -- Verificar actualización
    SELECT estudiante_id, nombre, apellido, email
    FROM estudiantes
    WHERE estudiante_id = 1;
    ```

<br/><br/>

### Salida Esperada:

```sql
-- Antes:
estudiante_id | nombre | apellido | email
--------------+--------+----------+----------------------
            1 | Juan   | Pérez    | juan.perez@email.com

-- Después:
estudiante_id | nombre | apellido | email
--------------+--------+----------+----------------------------
            1 | Juan   | Pérez    | juan.perez.nuevo@email.com
```


### Verificación

- El email del estudiante con ID 1 debe haber cambiado.
- Solo un registro debe ser afectado (verificar el mensaje `UPDATE 1` en pgAdmin).


<br/><br/>

### Paso 3: UPDATE Masivo con WHERE - Actualización Selectiva
Actualizar múltiples registros que cumplan una condición específica.
 
1.	Consulte los estudiantes inscritos antes del 20 de enero de 2024:
```sql
   -- Ver estudiantes a actualizar
   SELECT estudiante_id, nombre, apellido, fecha_inscripcion
   FROM estudiantes
   WHERE fecha_inscripcion < '2024-01-20'
   ORDER BY fecha_inscripcion;
```

2.	Agregue un campo de observación (primero agregue la columna si no ex-iste):
    ```sql
    -- Agregar columna si no existe
    ALTER TABLE estudiantes
    ADD COLUMN IF NOT EXISTS observaciones VARCHAR(200);
    ```

3.	Actualice las observaciones para estudiantes antiguos:
    ```sql
    -- Actualizar múltiples registros
    UPDATE estudiantes
    SET observaciones = 'Estudiante inscrito en primera cohorte'
    WHERE fecha_inscripcion < '2024-01-20';
    ```

4.	Verifique los cambios:
    ```sql
    -- Verificar actualizaciones
    SELECT estudiante_id, nombre, apellido, observaciones
    FROM estudiantes
    WHERE observaciones IS NOT NULL;
    ```

<br/><br/>

### Salida Esperada:
```sql
UPDATE 5

estudiante_id | nombre  | apellido | observaciones
--------------+---------+----------+----------------------------------------
            1 | Juan    | Pérez    | Estudiante inscrito en primera cohorte
            2 | María   | García   | Estudiante inscrito en primera cohorte
            3 | Carlos  | López    | Estudiante inscrito en primera cohorte

...
```

### Verificación

- Múltiples registros deben mostrar la nueva observación.
- Solo los estudiantes con fecha anterior al 20 de enero deben estar actualizados.

<br/><br/>

### Paso 4. UPDATE con Expresiones Calculadas - Incremento Porcentual
Aplicar cálculos matemáticos en actualizaciones, simulando un incre-mento de precios en cursos.
 
1.	Consulte los precios actuales de los cursos:
    ```sql
    -- Ver precios actuales
    SELECT curso_id, nombre_curso, precio
    FROM cursos
    ORDER BY precio DESC;
    ```

2.	Aplique un incremento del 10% a todos los cursos con precio mayor a 100:
    ```sql
    -- Incrementar precios en 10%
    UPDATE cursos
    SET precio = precio * 1.10
    WHERE precio > 100;
    ```

3.	Verifique los nuevos precios:
    ```sql
    -- Comparar precios
    SELECT
        curso_id,
        nombre_curso,
        precio as precio_nuevo,
        ROUND(precio / 1.10, 2) as precio_anterior
    FROM cursos
    WHERE precio > 110
    ORDER BY precio DESC;
    ```

<br/><br/>

### Salida Esperada:
```sql
UPDATE 3

curso_id | nombre_curso              | precio_nuevo | precio_anterior
---------+---------------------------+--------------+----------------
       1 | Bases de Datos Avanzadas  |       165.00 |          150.00
       2 | Programación en Python    |       132.00 |          120.00
       3 | Desarrollo Web Full Stack |       220.00 |          200.00
```

### Verificación

- Los precios deben reflejar un incremento del 10%.
- Solo los cursos con precio original mayor a 100 deben estar actualizados.

<br/><br/>

### Paso 5: UPDATE con Subconsultas - Actualización Basada en Otra Tabla
Utilizar subconsultas para actualizar registros basándose en infor-mación de tablas relacionadas.
 
1.	Agregue una columna para contar inscripciones (si no existe):
    ```sql
    -- Agregar columna para contador
    ALTER TABLE cursos
    ADD COLUMN IF NOT EXISTS total_inscritos INTEGER DEFAULT 0;
    ```

2.	Actualice el contador de inscritos usando una subconsulta:
    ```sql
    -- Actualizar con subconsulta
    UPDATE cursos
    SET total_inscritos = (
        SELECT COUNT(*)
        FROM inscripciones
        WHERE inscripciones.curso_id = cursos.curso_id
    );
    ```

3.	Verifique los resultados:
    ```sql
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
    ```
<br/><br/>

### Salida Esperada:

```sql
curso_id | nombre_curso              | total_inscritos | verificacion_count
---------+---------------------------+-----------------+-------------------
       1 | Bases de Datos Avanzadas  |               8 |                  8
       2 | Programación en Python    |               6 |                  6
       3 | Desarrollo Web Full Stack |               5 |                  5
```

### Verificación

- Los valores de `total_inscritos` deben coincidir con `verificacion_count`.
- Todos los cursos deben tener un valor numérico (0 o mayor).

<br/><br/>

### Paso 6: UPDATE de Múltiples Columnas Simultáneamente
Modificar varios campos en una sola sentencia UPDATE.
 
1.	Consulte el estado actual de un estudiante:
    ```sql
    -- Ver datos actuales
    SELECT estudiante_id, nombre, apellido, email, observaciones
    FROM estudiantes
    WHERE estudiante_id = 3;
    ```

2.	Actualice múltiples columnas a la vez:
    ```sql
    -- Actualizar múltiples columnas
    UPDATE estudiantes
    SET
        email = 'carlos.lopez.actualizado@email.com',
        observaciones = 'Datos actualizados - Verificado 2024',
        fecha_inscripcion = '2024-01-18'
    WHERE estudiante_id = 3;
    ```

3.	Verifique todos los cambios:
    ```sql
    -- Verificar cambios múltiples
    SELECT estudiante_id, nombre, apellido, email, observaciones, fecha_inscripcion
    FROM estudiantes
    WHERE estudiante_id = 3;
    ```

<br/><br/>

### Salida Esperada:

```sql
UPDATE 1

estudiante_id | nombre | apellido | email                               | ob-servaciones                      | fecha_inscripcion
--------------+--------+----------+-------------------------------------+------------------------------------+------------------
            3 | Carlos | López    | carlos.lopez.actualizado@email.com | Datos actualizados - Verificado 2024 | 2024-01-18
```


### Verificación

- Las tres columnas especificadas deben mostrar los nuevos valores.
- Solo el estudiante con ID 3 debe estar modificado.


<br/><br/>

### Paso 7: DELETE Simple - Eliminar Registros Específicos
Eliminar registros individuales utilizando la clave primaria.
 
1.	Primero, cree un registro de prueba para eliminar:
    ```sql
    -- Insertar registro de prueba
    INSERT INTO estudiantes (nombre, apellido, email, fecha_inscripcion)
    VALUES ('Temporal', 'Prueba', 'temporal@test.com', CURRENT_DATE)
    RETURNING estudiante_id;
    ```

2.	Verifique que el registro existe:
    ```sql
    -- Verificar existencia
    SELECT * FROM estudiantes WHERE email = 'temporal@test.com';
    ```

3.	Elimine el registro de prueba:
    ```sql
    -- Eliminar registro específico
    DELETE FROM estudiantes
    WHERE email = 'temporal@test.com';
    ```

4.	Confirme la eliminación:
    ```sql
    -- Verificar eliminación
    SELECT * FROM estudiantes WHERE email = 'temporal@test.com';
    ```

<br/><br/>

### Salida Esperada:
```sql
-- Después del INSERT:
estudiante_id | nombre   | apellido | email              | fecha_inscripcion
--------------+----------+----------+--------------------+------------------
           16 | Temporal | Prueba   | temporal@test.com  | 2024-03-15

DELETE 1

-- Después del DELETE:
(0 rows)
```

### Verificación

- El mensaje debe indicar `DELETE 1`.
- La consulta de verificación debe retornar 0 registros.

<br/><br/>

### Paso 8: Manejo de Restricciones de Integridad Referencial
Comprender cómo las llaves foráneas previenen eliminaciones que violarían la integridad referencial.
 
1.	Intente eliminar un estudiante que tiene inscripciones:
    ```sql
    -- Verificar estudiante con inscripciones
    SELECT e.estudiante_id, e.nombre, e.apellido, COUNT(i.inscripcion_id) as to-tal_inscripciones
    FROM estudiantes e
    INNER JOIN inscripciones i ON e.estudiante_id = i.estudiante_id
    GROUP BY e.estudiante_id, e.nombre, e.apellido
    HAVING COUNT(i.inscripcion_id) > 0
    LIMIT 1;
    ```

2.	Intente eliminar el estudiante (esto generará un error):
    ```sql
    -- Intentar eliminar (generará error)
    DELETE FROM estudiantes
    WHERE estudiante_id = 1;
    ```

3.	Consulte las inscripciones relacionadas:
    ```sql
    -- Ver registros dependientes
    SELECT inscripcion_id, estudiante_id, curso_id, fecha_inscripcion
    FROM inscripciones
    WHERE estudiante_id = 1;
    ```

<br/><br/>

### Salida Esperada:

```sql
ERROR:  update or delete on table "estudiantes" violates foreign key constraint "inscripciones_estudiante_id_fkey" on table "inscripciones"
DETAIL:  Key (estudiante_id)=(1) is still referenced from table "inscripciones".
```


### Verificación

- Debe recibir un error de violación de llave foránea.
- El estudiante **NO** debe ser eliminado.
- Las inscripciones relacionadas deben permanecer intactas.

<br/><br/>

### Paso 9: DELETE con CASCADE - Eliminación en Cascada
Demostrar cómo eliminar registros que tienen dependencias cuando la constraint está configurada con ON DELETE CASCADE.
 
1.	Cree tablas de prueba con CASCADE:

    ```sql
        -- Crear tablas de prueba
        CREATE TABLE IF NOT EXISTS categorias_prueba (
            categoria_id SERIAL PRIMARY KEY,
            nombre_categoria VARCHAR(100) NOT NULL
        );

        CREATE TABLE IF NOT EXISTS productos_prueba (
            producto_id SERIAL PRIMARY KEY,
            nombre_producto VARCHAR(100) NOT NULL,
            categoria_id INTEGER REFERENCES categorias_prueba(categoria_id) ON DELETE CASCADE
        );
    ```

2. Inserte datos de prueba:
    ```sql
    -- Insertar categoría
    INSERT INTO categorias_prueba (nombre_categoria)
    VALUES ('Electrónica')
    RETURNING categoria_id;

    -- Insertar productos (usar el categoria_id retornado, asumiendo 1)
    INSERT INTO productos_prueba (nombre_producto, categoria_id)
    VALUES
        ('Laptop', 1),
        ('Mouse', 1),
        ('Teclado', 1);
    ```

3.	Verifique los datos insertados:
    ```sql
    -- Ver datos relacionados
    SELECT c.categoria_id, c.nombre_categoria, COUNT(p.producto_id) as to-tal_productos
    FROM categorias_prueba c
    LEFT JOIN productos_prueba p ON c.categoria_id = p.categoria_id
    GROUP BY c.categoria_id, c.nombre_categoria;
    ```

4.	Elimine la categoría (esto eliminará los productos automáticamente):
    ```sql
    -- Eliminar con CASCADE
    DELETE FROM categorias_prueba
    WHERE categoria_id = 1;
    ```

5.	Verifique que los productos también fueron eliminados:
    ```sql
    -- Verificar eliminación en cascada
    SELECT * FROM productos_prueba;
    ```

<br/><br/>

### Salida Esperada:
```sql
-- Antes del DELETE:
categoria_id | nombre_categoria | total_productos
-------------+------------------+----------------
           1 | Electrónica      |              3

DELETE 1

-- Después del DELETE:
(0 rows)
```

### Verificación

- La categoría debe ser eliminada.
- Todos los productos relacionados deben ser eliminados automáticamente.
- Ambas tablas deben estar vacías.


<br/><br/>

### Paso 10: Transacciones - BEGIN, COMMIT y ROLLBACK
Utilizar transacciones para garantizar la consistencia de datos y poder revertir cambios si es necesario.
 
1.	Inicie una transacción y realice actualizaciones:
    ```sql
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
    ```

2.	Revierta la transacción (ROLLBACK):
    ```sql
    -- Revertir cambios
    ROLLBACK;

    -- Verificar que el precio no cambió
    SELECT curso_id, nombre_curso, precio
    FROM cursos
    WHERE curso_id = 2;
    ```

3.	Ahora realice una transacción que sí confirmaremos:
    ```sql
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
    ```

<br/><br/>

### Salida Esperada:
```sql
-- Después del ROLLBACK (precio original):
curso_id | nombre_curso           | precio
---------+------------------------+--------
       2 | Programación en Python | 132.00

-- Después del COMMIT (precio actualizado):
curso_id | nombre_curso           | precio
---------+------------------------+--------
       2 | Programación en Python | 145.00
```


### Verificación

- Después del `ROLLBACK`, el precio debe permanecer sin cambios.
- Después del `COMMIT`, el cambio debe ser permanente.
- Las transacciones deben proteger contra cambios accidentales.


<br/><br/>

### Paso 11: Soft Delete - Estrategia de Eliminación Lógica
Implementar una estrategia de eliminación lógica que marca registros como inactivos en lugar de eliminarlos físicamente.
 
1.	Agregue una columna de estado activo a la tabla estudiantes:
    ```sql
    -- Agregar columna de estado
    ALTER TABLE estudiantes
    ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT TRUE;

    -- Verificar columna agregada
    SELECT estudiante_id, nombre, apellido, activo
    FROM estudiantes
    LIMIT 5;
    ```

2.	Implemente un "soft delete" marcando un estudiante como inactivo:
    ```sql
    -- Soft delete: marcar como inactivo
    UPDATE estudiantes
    SET activo = FALSE
    WHERE estudiante_id = 5;
    ```

3.	Consulte solo estudiantes activos:
    ```sql
    -- Ver solo estudiantes activos
    SELECT estudiante_id, nombre, apellido, email, activo
    FROM estudiantes
    WHERE activo = TRUE
    ORDER BY estudiante_id;
    ```

4.	Consulte estudiantes inactivos:
    ```sql
    -- Ver estudiantes inactivos (eliminados lógicamente)
    SELECT estudiante_id, nombre, apellido, email, activo
    FROM estudiantes
    WHERE activo = FALSE;
    ```

5.	"Restaure" un estudiante inactivo:
    ```sql
    -- Restaurar estudiante
    UPDATE estudiantes
    SET activo = TRUE
    WHERE estudiante_id = 5;

    -- Verificar restauración
    SELECT estudiante_id, nombre, apellido, activo
    FROM estudiantes
    WHERE estudiante_id = 5;
    ```

<br/><br/>

### Salida Esperada:
```sql
-- Estudiantes activos (sin ID 5):
estudiante_id | nombre  | apellido | email                   | activo
--------------+---------+----------+-------------------------+--------
            1 | Juan    | Pérez    | juan.perez.nuevo@...    | t
            2 | María   | García   | maria.garcia@...        | t
            3 | Carlos  | López    | carlos.lopez.act...     | t
            4 | Ana     | Martínez | ana.martinez@...        | t

-- Estudiante inactivo:
estudiante_id | nombre | apellido | email              | activo
--------------+--------+----------+--------------------+--------
            5 | Pedro  | Sánchez  | pedro.sanchez@...  | f

-- Después de restaurar:
estudiante_id | nombre | apellido | email              | activo
--------------+--------+----------+--------------------+--------
            5 | Pedro  | Sánchez  | pedro.sanchez@...  | t
```


### Verificación

- El estudiante marcado como inactivo no debe aparecer en consultas con `WHERE activo = TRUE`.
- El registro debe permanecer en la base de datos (no eliminado físicamente).
- La restauración debe cambiar el estado de `FALSE` a `TRUE`.


<br/><br/>

### Paso 12: Práctica Combinada - Transacción Compleja
Combinar múltiples operaciones DML en una sola transacción para garantizar consistencia.
 
1.	Ejecute una transacción compleja que actualice múltiples tablas:
    ```sql
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
    ```

2.	Verifique que todos los cambios fueron aplicados:
    ```sql
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
    ```

<br/><br/>

### Salida Esperada:
```sql
COMMIT

nombre_curso              | precio_con_descuento | estudiantes_notificados
--------------------------+----------------------+------------------------
Desarrollo Web Full Stack |               198.00 |                       5
```


### Verificación

- El precio del curso debe reflejar el 10% de descuento.
- Todos los estudiantes inscritos en ese curso deben tener la observación actualizada.
- La transacción debe completarse exitosamente sin errores.


<br/><br/>

## Validación y Pruebas

### Criterios de Éxito

- [ ] Todas las sentencias `UPDATE` ejecutadas correctamente sin errores de sintaxis.
- [ ] Las actualizaciones afectan únicamente los registros especificados en `WHERE`.
- [ ] Las restricciones de integridad referencial se respetan en operaciones `DELETE`.
- [ ] Las transacciones con `ROLLBACK` revierten los cambios correctamente.
- [ ] Las transacciones con `COMMIT` persisten los cambios de forma permanente.
- [ ] La estrategia de *soft delete* permite “eliminar” y restaurar registros.
- [ ] Las subconsultas en `UPDATE` producen resultados correctos.
- [ ] Los cálculos matemáticos en `UPDATE` (incrementos porcentuales) son precisos.


### Procedimiento de Prueba
1.	Verificar que las tablas de respaldo contienen datos originales:
    ```sql
    -- Comparar datos originales con actuales
    SELECT
        (SELECT COUNT(*) FROM estudiantes_backup) as backup_count,
        (SELECT COUNT(*) FROM estudiantes WHERE activo = TRUE) as cur-rent_active_count;
    ```

#### Resultado Esperado: 
Los conteos deben ser coherentes con las operaciones re-alizadas.

<br/><br/>

2.	Probar ROLLBACK en una transacción de prueba:
    ```sql
    BEGIN;
    DELETE FROM productos_prueba;
    SELECT COUNT(*) FROM productos_prueba; -- Debe ser 0
    ROLLBACK;
    SELECT COUNT(*) FROM productos_prueba; -- Debe volver al valor original
    ```

#### Resultado Esperado: 
El conteo después del ROLLBACK debe ser el mismo que antes del BEGIN.

<br/><br/>

3.	Verificar integridad referencial:
    ```sql
    -- Verificar que no hay registros huérfanos
    SELECT i.inscripcion_id, i.estudiante_id, i.curso_id
    FROM inscripciones i
    LEFT JOIN estudiantes e ON i.estudiante_id = e.estudiante_id
    LEFT JOIN cursos c ON i.curso_id = c.curso_id
    WHERE e.estudiante_id IS NULL OR c.curso_id IS NULL;
    ```

#### Resultado Esperado:
La consulta debe retornar 0 registros (no debe haber huérfanos).

<br/><br/>

## Solución de Problemas

### Problema 1: Error de Violación de Llave Foránea al Eliminar

#### Síntomas
- Mensaje de error: `ERROR: update or delete on table "X" violates foreign key constraint`
- La operación `DELETE` no se completa.

#### Causa
Intento de eliminar un registro que tiene registros relacionados en otras tablas a través de llaves foráneas sin `ON DELETE CASCADE`.


#### Solución:
```sql
-- Opción 1: Eliminar primero los registros dependientes
BEGIN;

-- Eliminar inscripciones del estudiante
DELETE FROM inscripciones
WHERE estudiante_id = 5;

-- Ahora eliminar el estudiante
DELETE FROM estudiantes
WHERE estudiante_id = 5;

COMMIT;

-- Opción 2: Usar soft delete en su lugar
UPDATE estudiantes
SET activo = FALSE
WHERE estudiante_id = 5;
```

<br/><br/>

### Problema 2: UPDATE Afecta Más Registros de lo Esperado

#### Síntomas
- El mensaje indica `UPDATE 50` cuando se esperaba `UPDATE 1`.
- Múltiples registros fueron modificados incorrectamente.

#### Causa
Cláusula `WHERE` incorrecta, demasiado amplia o ausente.


#### Solución:
```sql
-- INMEDIATAMENTE ejecutar ROLLBACK si estás en una transacción
ROLLBACK;

-- Si NO estabas en transacción, restaurar desde respaldo
BEGIN;

-- Restaurar registros desde backup
UPDATE estudiantes e
SET
    email = b.email,
    observaciones = b.observaciones
FROM estudiantes_backup b
WHERE e.estudiante_id = b.estudiante_id;

COMMIT;

-- SIEMPRE probar WHERE con SELECT primero
SELECT * FROM estudiantes WHERE condicion; -- Verificar cuántos registros
-- Luego ejecutar UPDATE con la misma condición
```

<br/><br/>

### Problema 3: Transacción Bloqueada o en Estado Idle

#### Síntomas
- Las consultas posteriores no muestran los cambios esperados.
- pgAdmin muestra una transacción en estado **"idle in transaction"**.
- Otros usuarios no pueden acceder a las tablas.

#### Causa
Se ejecutó `BEGIN`, pero nunca se ejecutó `COMMIT` o `ROLLBACK`.

#### Solución:
```sql
-- Verificar transacciones activas
SELECT pid, usename, state, query_start, query
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND usename = current_user;

-- Cerrar la transacción pendiente
COMMIT; -- o ROLLBACK si deseas revertir

-- Si es necesario, terminar la conexión bloqueada (requiere permisos)
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND usename = current_user;
```

<br/><br/>

### Problema 4: No se Pueden Actualizar Columnas Calculadas

#### Síntomas
- Error: `column "nombre_completo" cannot be updated`
- La columna es un campo generado o pertenece a una vista.

#### Causa
Intento de actualizar una columna calculada o de solo lectura.


#### Solución:
```sql
-- Identificar columnas generadas
SELECT column_name, is_generated, generation_expression
FROM information_schema.columns
WHERE table_name = 'estudiantes'
  AND is_generated = 'ALWAYS';

-- Actualizar las columnas base en su lugar
UPDATE estudiantes
SET
    nombre = 'Juan Carlos',
    apellido = 'Pérez García'
WHERE estudiante_id = 1;
-- La columna generada se actualizará automáticamente
```

<br/><br/>

### Problema 5: Pérdida de Datos por DELETE sin WHERE

#### Síntomas
- Mensaje `DELETE 150` cuando se esperaba eliminar pocos registros.
- La tabla completa o casi completa fue vaciada.

#### Causa
Ejecución de una sentencia `DELETE` sin cláusula `WHERE`, lo que provoca la eliminación de todos los registros.

#### Solución:
```sql
-- RESTAURAR INMEDIATAMENTE desde respaldo
BEGIN;

-- Restaurar todos los datos
INSERT INTO estudiantes
SELECT * FROM estudiantes_backup
ON CONFLICT (estudiante_id) DO NOTHING;

COMMIT;

-- Verificar restauración
SELECT COUNT(*) FROM estudiantes;

-- PREVENCIÓN: Siempre usar transacciones para operaciones peligrosas
BEGIN;
DELETE FROM tabla WHERE condicion;
-- Verificar antes de COMMIT
SELECT * FROM tabla;
-- Si está correcto: COMMIT; si no: ROLLBACK;
```

<br/><br/>

## Limpieza
Ejecute los siguientes comandos para limpiar las tablas de prueba creadas durante el laboratorio:

```sql
-- Eliminar tablas de prueba
DROP TABLE IF EXISTS productos_prueba CASCADE;
DROP TABLE IF EXISTS categorias_prueba CASCADE;

-- Opcional: Eliminar tabla de respaldo
DROP TABLE IF EXISTS estudiantes_backup;

-- Opcional: Revertir cambios de columnas agregadas
ALTER TABLE estudiantes DROP COLUMN IF EXISTS observaciones;
ALTER TABLE estudiantes DROP COLUMN IF EXISTS activo;
ALTER TABLE cursos DROP COLUMN IF EXISTS total_inscritos;

-- Verificar limpieza
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```


> **Advertencia:** Si desea conservar los datos modificados para referencia futura, **NO** ejecute los comandos de limpieza.  
> Considere crear un respaldo completo de la base de datos antes de limpiar.



```sql
-- Crear respaldo completo (opcional)
CREATE SCHEMA IF NOT EXISTS backup_lab05;

CREATE TABLE backup_lab05.estudiantes AS SELECT * FROM estudiantes;
CREATE TABLE backup_lab05.cursos AS SELECT * FROM cursos;
CREATE TABLE backup_lab05.inscripciones AS SELECT * FROM inscripciones;
```

<br/><br/>

## Resumen

### Lo que Ha Logrado

- Ejecutó actualizaciones simples y complejas utilizando `UPDATE` con diversas cláusulas `WHERE`.
- Aplicó cálculos matemáticos y expresiones en actualizaciones de datos.
- Utilizó subconsultas para actualizar registros basándose en información de tablas relacionadas.
- Implementó operaciones `DELETE` respetando restricciones de integridad referencial.
- Comprendió el funcionamiento de `ON DELETE CASCADE` en relaciones de llaves foráneas.
- Aplicó transacciones con `BEGIN`, `COMMIT` y `ROLLBACK` para garantizar consistencia de datos.
- Implementó estrategias de *soft delete* como alternativa a eliminaciones físicas.
- Practicó técnicas de respaldo y verificación antes de operaciones destructivas.

<br/><br/>

## Conceptos Clave Aprendidos
- **UPDATE con WHERE**: Siempre especificar condiciones precisas para evitar actualizaciones masivas no deseadas.
- **Integridad referencial**: Las llaves foráneas protegen contra eliminaciones que dejarían datos huérfanos.
- **Transacciones**: Permiten agrupar operaciones y revertirlas si algo sale mal.
- **Soft Delete**: Estrategia que preserva datos históricos marcándolos como inactivos.
- **Verificación previa**: Usar `SELECT` con las mismas condiciones antes de ejecutar `UPDATE` o `DELETE`.
- **Respaldos**: Crear copias de seguridad antes de operaciones de modificación masiva.


<br/><br/>

## Próximos Pasos

- Practique con el **Lab 06-00-01** para trabajar con consultas avanzadas y optimización.
- Explore el uso de **triggers** para auditar cambios en `UPDATE` y `DELETE`.
- Investigue políticas de retención de datos y estrategias de archivado.
- Estudie índices y su impacto en el rendimiento de operaciones DML.
- Prepare el diseño para el proyecto final del curso (**Lab 7.1**).


<br/><br/>

## Recursos Adicionales

- **Documentación Oficial PostgreSQL – UPDATE**  
  Referencia completa de la sentencia `UPDATE`.

- **Documentación Oficial PostgreSQL – DELETE**  
  Referencia completa de la sentencia `DELETE`.

- **PostgreSQL Transaction Management**  
  Tutorial sobre el manejo de transacciones.

- **Foreign Key Constraints**  
  Documentación sobre llaves foráneas y `CASCADE`.

- **pgAdmin Query Tool Guide**  
  Guía de uso de la herramienta de consultas.

- **SQL Style Guide**  
  Guía de buenas prácticas para escribir SQL legible.

- **PostgreSQL Backup and Restore**  
  Estrategias de respaldo de bases de datos.
