# Práctica 7.1 Aplicación de lo aprendido en el curso

<br/><br/>

## Tiempo estimado	
155 minutos

<br/><br/>

## Objetivos

Al completar este laboratorio, serás capaz de:

* Diseñar desde cero una base de datos normalizada para un sistema de reservas de alojamientos.
* Aplicar principios de normalización y mejores prácticas de diseño relacional en un proyecto real.
* Implementar una base de datos completa con múltiples tablas, relaciones y *constraints*.
* Insertar datasets realistas de prueba para todas las entidades del sistema.
* Crear consultas SQL complejas para reportes de negocio usando JOINs, agregaciones y funciones *window*.
* Desarrollar vistas y consultas reutilizables para operaciones comunes del sistema.
* Documentar completamente un proyecto de base de datos con diagramas, scripts y README.


<br/><br/>

## Prerrequisitos

### Conocimientos Requeridos
* Diseño de bases de datos relacionales y modelado entidad–relación.
* Normalización de bases de datos (1FN, 2FN, 3FN).
* SQL DDL para creación de tablas, *constraints* y relaciones.
* SQL DML para inserción, actualización y eliminación de datos.
* SQL DQL avanzado, incluyendo JOINs, subqueries, CTEs y funciones *window*.
* Creación de vistas y gestión de bases de datos en PostgreSQL.
* Uso de pgAdmin para la administración de bases de datos.

<br/>

### Laboratorios Completados
* **Lab 1.1:** Instalación y configuración de PostgreSQL y pgAdmin
* **Lab 2.1:** Fundamentos de diseño de bases de datos relacionales
* **Lab 3.1:** Implementación de bases de datos con DDL
* **Lab 4.1:** Manipulación de datos con DML
* **Lab 5.1:** Consultas básicas con SELECT
* **Lab 6.1:** Consultas avanzadas y optimización


<br/>

### Acceso Requerido
* **PostgreSQL 18** instalado y en ejecución.
* **pgAdmin 4** configurado y conectado a **PostgreSQL**.
* Permisos de **superusuario** o permisos para **crear bases de datos**.


<br/>

### Entorno de Laboratorio

#### Requisitos de Hardware

| **Componente** | **Especificación**             |
| -------------- | ------------------------------ |
| Procesador     | 64-bit (x86-64 o compatible)   |
| RAM            | Mínimo 4 GB (recomendado 8 GB) |
| Disco Duro     | Mínimo 2 GB libres             |
| Pantalla       | Resolución mínima 1280×720     |

<br/>

#### Requisitos de Software

| **Software**    | **Versión**                        | **Propósito**                             |
| --------------- | ---------------------------------- | ----------------------------------------- |
| PostgreSQL      | 18.x                               | Sistema gestor de base de datos principal |
| pgAdmin         | 4.x (compatible con PostgreSQL 18) | Interfaz gráfica de administración        |
| Windows         | 10 o 11 (64-bit)                   | Sistema operativo base                    |
| Navegador web   | Chrome 90+, Firefox 88+, Edge 90+  | Para ejecutar pgAdmin                     |
| Editor de texto | Notepad++, VS Code o similar       | Opcional para editar scripts SQL          |


<br/><br/>

## Configuración Inicial

#### Verificación del entorno:
1. Abre **pgAdmin** y confirma la conexión a **PostgreSQL 18**.
2. Verifica que tienes permisos para **crear bases de datos**.
3. Prepara un **directorio de trabajo** para guardar los **scripts SQL** del proyecto.

    ```sql
    -- Verificar versión de PostgreSQL
    SELECT version();
    ```

<br/><br/>


## Instrucciones

### Paso 1: Análisis de Requisitos y Diseño Conceptual

1. Análisis de requisitos del sistema

    Analiza los **requisitos del sistema de reservas de alojamientos**. El sistema debe manejar:

    * **Propiedades** (alojamientos) con características detalladas.
    * **Usuarios** (**anfitriones** y **huéspedes**).
    * **Reservas** con **fechas** y **estados**.
    * **Reseñas** y **calificaciones**.
    * **Amenidades** (servicios) de las propiedades.
    * **Ubicaciones geográficas**.
    * **Pagos** y **transacciones**.

<br/>

2. Identificación de entidades y atributos

    **Entidades identificadas:**

    * **usuarios**: id, nombre, apellido, email, telefono, tipo_usuario, fecha_registro, password_hash

    * **ubicaciones**: id, pais, ciudad, estado_provincia, codigo_postal, direccion

    * **propiedades**: id, id_anfitrion, id_ubicacion, titulo, descripcion, tipo_propiedad, precio_noche, capacidad_huespedes, num_habitaciones, num_banos, fecha_creacion

    * **amenidades**: id, nombre, descripcion, categoria

    * **propiedades_amenidades** (tabla intermedia): id_propiedad, id_amenidad

    * **reservas**: id, id_propiedad, id_huesped, fecha_inicio, fecha_fin, num_huespedes, precio_total, estado, fecha_reserva

    * **pagos**: id, id_reserva, monto, metodo_pago, estado_pago, fecha_pago

    * **resenas**: id, id_reserva, id_usuario, calificacion, comentario, fecha_resena

<br/>

3. Identificación de relaciones entre entidades

    * Un **usuario** puede ser **anfitrión** de múltiples **propiedades** (**1:N**).
    * Una **propiedad** pertenece a una **ubicación** (**N:1**).
    * Una **propiedad** puede tener múltiples **amenidades** (**N:M**).
    * Una **propiedad** puede tener múltiples **reservas** (**1:N**).
    * Una **reserva** pertenece a un **huésped** (**usuario**) (**N:1**).
    * Una **reserva** puede tener múltiples **pagos** (**1:N**).
    * Una **reserva** puede tener una **reseña** (**1:1**).

<br/>

4. Elaboración del diagrama Entidad–Relación (ER)

    Dibuja un **diagrama ER** en papel o utilizando una herramienta como **draw.io** o **dbdiagram.io**. El diagrama debe incluir:

    * Todas las **entidades** representadas como rectángulos.
    * **Atributos** dentro de cada entidad.
    * **Relaciones** representadas con líneas y sus **cardinalidades** (1:1, 1:N, N:M).
    * **Claves primarias** claramente identificadas (subrayadas).
    * **Claves foráneas** indicando la relación entre entidades.


<br/>

#### Verificación

- Has identificado al menos **8 entidades principales**
- Cada entidad tiene **atributos relevantes** y una **clave primaria**
- Las **relaciones entre entidades** están claramente definidas
- El diseño está en **Tercera Forma Normal (3FN)**, sin dependencias transitivas



<br/><br/>

### Paso 2: Creación de la Base de Datos y Esquema
 Crear la base de datos del proyecto y establecer la estructura inicial.
 
1.	Abre PgAdmin y conéctate a tu servidor PostgreSQL.

2.	Crea una nueva base de datos para el proyecto:
    ```sql
    -- Crear base de datos para sistema de reservas
    CREATE DATABASE sistema_reservas_alojamientos
        WITH
        ENCODING = 'UTF8'
        LC_COLLATE = 'Spanish_Spain.1252'
        LC_CTYPE = 'Spanish_Spain.1252'
        TEMPLATE = template0;
    ```

3.	Conéctate a la nueva base de datos haciendo clic derecho sobre ella y seleccionando "Query Tool".

4.	Crea un comentario descriptivo para la base de datos:
    ```sql
    COMMENT ON DATABASE sistema_reservas_alojamientos IS
    'Base de datos para sistema de reservas de alojamientos tipo Airbnb/Booking. Proyecto final del curso de PostgreSQL.';
    ```

5.	Verifica la creación de la base de datos:
    ```sql
    SELECT datname, encoding, datcollate, datctype
    FROM pg_database
    WHERE datname = 'sistema_reservas_alojamientos';
    ```

<br/>

#### Salida Esperada:

```sql
datname                          | encoding | datcollate              | datctype
---------------------------------|----------|-------------------------|-------------------------
sistema_reservas_alojamientos    | 6        | Spanish_Spain.1252      | Spanish_Spain.1252
```

#### Verificación

- [ ] La base de datos **sistema_reservas_alojamientos** aparece en el navegador de **pgAdmin**
- [ ] Puedes conectarte y abrir **Query Tool** en la nueva base de datos
- [ ] La **consulta de verificación** retorna la información correcta


<br/><br/>

### Paso 3: Implementación de Tablas con DDL
Crear todas las tablas del sistema con sus constraints, claves primarias, foráneas e índices.

1.	Crea la tabla de usuarios (primera entidad independiente):
    ```sql
    -- Tabla: usuarios
    CREATE TABLE usuarios (
        id_usuario SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        apellido VARCHAR(100) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        telefono VARCHAR(20),
        tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('huesped', 'anfitrion', 'ambos')),
        fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        password_hash VARCHAR(255) NOT NULL,
        activo BOOLEAN DEFAULT TRUE
    );

    CREATE INDEX idx_usuarios_email ON usuarios(email);
    CREATE INDEX idx_usuarios_tipo ON usuarios(tipo_usuario);

    COMMENT ON TABLE usuarios IS 'Almacena información de usuarios del sistema (huéspedes y anfitriones)';
    ```

<br/>

2.	Crea la tabla de ubicaciones:
    ```sql
    -- Tabla: ubicaciones
    CREATE TABLE ubicaciones (
        id_ubicacion SERIAL PRIMARY KEY,
        pais VARCHAR(100) NOT NULL,
        ciudad VARCHAR(100) NOT NULL,
        estado_provincia VARCHAR(100),
        codigo_postal VARCHAR(20),
        direccion TEXT NOT NULL,
        latitud DECIMAL(10, 8),
        longitud DECIMAL(11, 8)
    );

    CREATE INDEX idx_ubicaciones_ciudad ON ubicaciones(ciudad);
    CREATE INDEX idx_ubicaciones_pais ON ubicaciones(pais);

    COMMENT ON TABLE ubicaciones IS 'Ubicaciones geográficas de las propiedades';
    ```

<br/>

3.	Crea la tabla de propiedades:
    ```sql
    -- Tabla: propiedades
    CREATE TABLE propiedades (
        id_propiedad SERIAL PRIMARY KEY,
        id_anfitrion INTEGER NOT NULL,
        id_ubicacion INTEGER NOT NULL,
        titulo VARCHAR(255) NOT NULL,
        descripcion TEXT,
        tipo_propiedad VARCHAR(50) NOT NULL CHECK (tipo_propiedad IN ('casa', 'apartamento', 'habitacion', 'villa', 'cabana', 'otro')),
        precio_noche DECIMAL(10, 2) NOT NULL CHECK (precio_noche > 0),
        capacidad_huespedes INTEGER NOT NULL CHECK (capacidad_huespedes > 0),
        num_habitaciones INTEGER NOT NULL CHECK (num_habitaciones >= 0),
        num_banos DECIMAL(3, 1) NOT NULL CHECK (num_banos >= 0),
        fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        activo BOOLEAN DEFAULT TRUE,
        FOREIGN KEY (id_anfitrion) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
        FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion) ON DELETE RESTRICT
    );

    CREATE INDEX idx_propiedades_anfitrion ON propiedades(id_anfitrion);
    CREATE INDEX idx_propiedades_ubicacion ON propiedades(id_ubicacion);
    CREATE INDEX idx_propiedades_tipo ON propiedades(tipo_propiedad);
    CREATE INDEX idx_propiedades_precio ON propiedades(precio_noche);

    COMMENT ON TABLE propiedades IS 'Propiedades/alojamientos disponibles para reserva';
    ```

<br/>

4.	Crea la tabla de amenidades:
    ```sql
    -- Tabla: amenidades
    CREATE TABLE amenidades (
        id_amenidad SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE,
        descripcion TEXT,
        categoria VARCHAR(50) CHECK (categoria IN ('basico', 'confort', 'entretenimiento', 'seguridad', 'accesibilidad'))
    );

    CREATE INDEX idx_amenidades_categoria ON amenidades(categoria);

    COMMENT ON TABLE amenidades IS 'Servicios y amenidades disponibles en propiedades';
    ```

<br/>

5.	Crea la tabla intermedia para la relación N:M entre propiedades y amenidades:
    ```sql
    -- Tabla: propiedades_amenidades (relación N:M)
    CREATE TABLE propiedades_amenidades (
        id_propiedad INTEGER NOT NULL,
        id_amenidad INTEGER NOT NULL,
        PRIMARY KEY (id_propiedad, id_amenidad),
        FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad) ON DELETE CASCADE,
        FOREIGN KEY (id_amenidad) REFERENCES amenidades(id_amenidad) ON DELETE CASCADE
    );

    COMMENT ON TABLE propiedades_amenidades IS 'Relación entre propiedades y sus amenidades';
    ```

<br/>

6.	Crea la tabla de reservas:
    ```sql
    -- Tabla: reservas
    CREATE TABLE reservas (
        id_reserva SERIAL PRIMARY KEY,
        id_propiedad INTEGER NOT NULL,
        id_huesped INTEGER NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL,
        num_huespedes INTEGER NOT NULL CHECK (num_huespedes > 0),
        precio_total DECIMAL(10, 2) NOT NULL CHECK (precio_total >= 0),
        estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada', 'completada')),
        fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CHECK (fecha_fin > fecha_inicio),
        FOREIGN KEY (id_propiedad) REFERENCES propiedades(id_propiedad) ON DELETE RESTRICT,
        FOREIGN KEY (id_huesped) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT
    );

    CREATE INDEX idx_reservas_propiedad ON reservas(id_propiedad);
    CREATE INDEX idx_reservas_huesped ON reservas(id_huesped);
    CREATE INDEX idx_reservas_fechas ON reservas(fecha_inicio, fecha_fin);
    CREATE INDEX idx_reservas_estado ON reservas(estado);

    COMMENT ON TABLE reservas IS 'Reservas realizadas por huéspedes';
    ```

<br/>

7.	Crea la tabla de pagos:
    ```sql
    -- Tabla: pagos
    CREATE TABLE pagos (
        id_pago SERIAL PRIMARY KEY,
        id_reserva INTEGER NOT NULL,
        monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),
        metodo_pago VARCHAR(50) NOT NULL CHECK (metodo_pago IN ('tarjeta_credito', 'tarjeta_debito', 'paypal', 'transferencia', 'efectivo')),
        estado_pago VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado_pago IN ('pendiente', 'procesando', 'completado', 'fallido', 'reembolsado')),
        fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE RESTRICT
    );

    CREATE INDEX idx_pagos_reserva ON pagos(id_reserva);
    CREATE INDEX idx_pagos_estado ON pagos(estado_pago);

    COMMENT ON TABLE pagos IS 'Pagos asociados a reservas';
    ```

<br/>

8.	Crea la tabla de reseñas:
    ```sql
    -- Tabla: resenas
    CREATE TABLE resenas (
        id_resena SERIAL PRIMARY KEY,
        id_reserva INTEGER NOT NULL UNIQUE,
        id_usuario INTEGER NOT NULL,
        calificacion INTEGER NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
        comentario TEXT,
        fecha_resena TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE,
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
    );

    CREATE INDEX idx_resenas_reserva ON resenas(id_reserva);
    CREATE INDEX idx_resenas_calificacion ON resenas(calificacion);

    COMMENT ON TABLE resenas IS 'Reseñas y calificaciones de propiedades por huéspedes';
    ```

<br/>

9.	Verifica que todas las tablas se crearon correctamente:
    ```sql
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
    ORDER BY table_name;
    ```

<br/><br/>


#### Salida Esperada:

```sql
table_name
---------------------------
amenidades
pagos
propiedades
propiedades_amenidades
reservas
resenas
ubicaciones
usuarios
```

<br/>

#### Verificación:

* ☐ Todas las **8 tablas** aparecen en el navegador de **pgAdmin** bajo **Tables**.
* ☐ Cada tabla tiene su **clave primaria** definida.
* ☐ Las **claves foráneas** están correctamente establecidas.
* ☐ Los **constraints CHECK** están implementados.
* ☐ Los **índices** se crearon para mejorar el **rendimiento de las consultas**.


<br/><br/>


### Paso 4: Inserción de Datos de Prueba - Usuarios y Ubicaciones
Poblar las tablas independientes con datos realistas de prueba.
 
1.	Inserta usuarios (huéspedes y anfitriones):
```sql
   -- Insertar usuarios (50 usuarios mínimo, aquí 20 como ejemplo)
   INSERT INTO usuarios (nombre, apellido, email, telefono, tipo_usuario, password_hash) VALUES
   ('Juan', 'García', 'juan.garcia@email.com', '+34612345001', 'anfitrion', 'hash_password_1'),
   ('María', 'López', 'maria.lopez@email.com', '+34612345002', 'anfitrion', 'hash_password_2'),
   ('Carlos', 'Martínez', 'carlos.martinez@email.com', '+34612345003', 'anfitrion', 'hash_password_3'),
   ('Ana', 'Rodríguez', 'ana.rodriguez@email.com', '+34612345004', 'huesped', 'hash_password_4'),
   ('Luis', 'Fernández', 'luis.fernandez@email.com', '+34612345005', 'huesped', 'hash_password_5'),
   ('Elena', 'González', 'elena.gonzalez@email.com', '+34612345006', 'ambos', 'hash_password_6'),
   ('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '+34612345007', 'anfitrion', 'hash_password_7'),
   ('Laura', 'Díaz', 'laura.diaz@email.com', '+34612345008', 'huesped', 'hash_password_8'),
   ('Miguel', 'Torres', 'miguel.torres@email.com', '+34612345009', 'huesped', 'hash_password_9'),
   ('Isabel', 'Ramírez', 'isabel.ramirez@email.com', '+34612345010', 'anfitrion', 'hash_password_10'),
   ('Javier', 'Flores', 'javier.flores@email.com', '+34612345011', 'huesped', 'hash_password_11'),
   ('Carmen', 'Jiménez', 'carmen.jimenez@email.com', '+34612345012', 'huesped', 'hash_password_12'),
   ('Antonio', 'Moreno', 'antonio.moreno@email.com', '+34612345013', 'anfitrion', 'hash_password_13'),
   ('Rosa', 'Álvarez', 'rosa.alvarez@email.com', '+34612345014', 'huesped', 'hash_password_14'),
   ('Francisco', 'Romero', 'francisco.romero@email.com', '+34612345015', 'ambos', 'hash_password_15'),
   ('Lucía', 'Navarro', 'lucia.navarro@email.com', '+34612345016', 'huesped', 'hash_password_16'),
   ('David', 'Ruiz', 'david.ruiz@email.com', '+34612345017', 'anfitrion', 'hash_password_17'),
   ('Marta', 'Hernández', 'marta.hernandez@email.com', '+34612345018', 'huesped', 'hash_password_18'),
   ('Sergio', 'Muñoz', 'sergio.munoz@email.com', '+34612345019', 'anfitrion', 'hash_password_19'),
   ('Patricia', 'Vargas', 'patricia.vargas@email.com', '+34612345020', 'huesped', 'hash_password_20');
```

<br/>


2.	Inserta ubicaciones en diferentes ciudades:
    ```sql
    -- Insertar ubicaciones (mínimo 30, aquí 25 como ejemplo)
    INSERT INTO ubicaciones (pais, ciudad, estado_provincia, codigo_postal, direccion, latitud, longitud) VALUES
    ('España', 'Madrid', 'Madrid', '28001', 'Calle Gran Vía 45', 40.4168, -3.7038),
    ('España', 'Madrid', 'Madrid', '28013', 'Calle Alcalá 123', 40.4200, -3.6931),
    ('España', 'Barcelona', 'Cataluña', '08001', 'Passeig de Gràcia 78', 41.3874, 2.1686),
    ('España', 'Barcelona', 'Cataluña', '08002', 'Rambla Catalunya 56', 41.3912, 2.1649),
    ('España', 'Valencia', 'Valencia', '46001', 'Calle Colón 34', 39.4699, -0.3763),
    ('España', 'Valencia', 'Valencia', '46002', 'Avenida del Puerto 12', 39.4561, -0.3545),
    ('España', 'Sevilla', 'Andalucía', '41001', 'Calle Sierpes 89', 37.3891, -5.9845),
    ('España', 'Sevilla', 'Andalucía', '41004', 'Avenida de la Constitución 5', 37.3858, -5.9925),
    ('España', 'Málaga', 'Andalucía', '29001', 'Calle Larios 23', 36.7213, -4.4214),
    ('España', 'Málaga', 'Andalucía', '29016', 'Paseo Marítimo 67', 36.7156, -4.4167),
    ('España', 'Bilbao', 'País Vasco', '48001', 'Gran Vía Don Diego López 15', 43.2630, -2.9350),
    ('España', 'Granada', 'Andalucía', '18001', 'Calle Reyes Católicos 34', 37.1773, -3.5986),
    ('España', 'Zaragoza', 'Aragón', '50001', 'Paseo Independencia 45', 41.6488, -0.8891),
    ('España', 'Alicante', 'Valencia', '03001', 'Explanada de España 12', 38.3452, -0.4815),
    ('España', 'Córdoba', 'Andalucía', '14001', 'Calle Gondomar 8', 37.8882, -4.7794),
    ('España', 'Palma', 'Baleares', '07001', 'Paseo Marítimo 89', 39.5696, 2.6502),
    ('España', 'Las Palmas', 'Canarias', '35001', 'Calle Triana 56', 28.1000, -15.4130),
    ('España', 'Murcia', 'Murcia', '30001', 'Gran Vía Escultor Salzillo 23', 37.9922, -1.1307),
    ('España', 'Santander', 'Cantabria', '39001', 'Paseo Pereda 34', 43.4623, -3.8100),
    ('España', 'Toledo', 'Castilla-La Mancha', '45001', 'Calle Comercio 12', 39.8628, -4.0273),
    ('España', 'San Sebastián', 'País Vasco', '20001', 'Boulevard 45', 43.3183, -1.9812),
    ('España', 'Salamanca', 'Castilla y León', '37001', 'Plaza Mayor 8', 40.9701, -5.6635),
    ('España', 'Cádiz', 'Andalucía', '11001', 'Calle Ancha 23', 36.5271, -6.2886),
    ('España', 'Tarragona', 'Cataluña', '43001', 'Rambla Nova 67', 41.1189, 1.2445),
    ('España', 'Girona', 'Cataluña', '17001', 'Carrer de la Força 34', 41.9794, 2.8214);
    ```

<br/>

3.	Verifica la inserción de datos:
    ```sql
    SELECT COUNT(*) as total_usuarios FROM usuarios;
    SELECT COUNT(*) as total_ubicaciones FROM ubicaciones;

    -- Ver distribución de tipos de usuario
    SELECT tipo_usuario, COUNT(*) as cantidad
    FROM usuarios
    GROUP BY tipo_usuario;
    ```

<br/><br/>

#### Salida Esperada:

    ```sql
    total_usuarios
    ---------------
    20

    total_ubicaciones
    ------------------
    25

    tipo_usuario | cantidad
    -------------|----------
    anfitrion    | 8
    huesped      | 10
    ambos        | 2
    ```

#### Verificación:

- [ ] Se insertaron al menos **20 usuarios**
- [ ] Se insertaron al menos **25 ubicaciones**
- [ ] Hay usuarios de los **tres tipos** (**huésped**, **anfitrión**, **ambos**)
- [ ] Las **ubicaciones** tienen **coordenadas realistas**


<br/><br/>

### Paso 5: Inserción de Datos de Prueba - Propiedades y Amenidades
Poblar las tablas de propiedades, amenidades y sus relaciones.
 
1.	Inserta amenidades comunes en propiedades:
    ```sql
    -- Insertar amenidades
    INSERT INTO amenidades (nombre, descripcion, categoria) VALUES
    ('WiFi', 'Internet inalámbrico de alta velocidad', 'basico'),
    ('Aire acondicionado', 'Sistema de climatización', 'confort'),
    ('Calefacción', 'Sistema de calefacción central', 'confort'),
    ('Cocina equipada', 'Cocina completa con electrodomésticos', 'basico'),
    ('Lavadora', 'Lavadora en la propiedad', 'confort'),
    ('TV', 'Televisión con cable o streaming', 'entretenimiento'),
    ('Piscina', 'Piscina privada o comunitaria', 'entretenimiento'),
    ('Parking', 'Plaza de aparcamiento incluida', 'basico'),
    ('Ascensor', 'Ascensor en el edificio', 'accesibilidad'),
    ('Acceso para discapacitados', 'Instalaciones adaptadas', 'accesibilidad'),
    ('Alarma de seguridad', 'Sistema de alarma', 'seguridad'),
    ('Detector de humo', 'Detector de humo instalado', 'seguridad'),
    ('Extintor', 'Extintor de incendios', 'seguridad'),
    ('Terraza/Balcón', 'Espacio exterior privado', 'confort'),
    ('Jardín', 'Jardín privado o comunitario', 'entretenimiento');
    ```

<br/>

2.	Inserta propiedades (mínimo 50, aquí 30 como ejemplo representativo):
    ```sql
    -- Insertar propiedades (asegúrate de usar IDs válidos de anfitriones y ubicaciones)
    INSERT INTO propiedades (id_anfitrion, id_ubicacion, titulo, descripcion, tipo_propiedad, precio_noche, capacidad_huespedes, num_habitaciones, num_banos) VALUES
    (1, 1, 'Apartamento céntrico en Gran Vía', 'Moderno apartamento en el corazón de Madrid', 'apartamento', 85.00, 4, 2, 1.0),
    (1, 2, 'Estudio luminoso cerca de Retiro', 'Acogedor estudio con vistas al parque', 'apartamento', 65.00, 2, 1, 1.0),
    (2, 3, 'Piso modernista en Barcelona', 'Hermoso piso con elementos modernistas', 'apartamento', 120.00, 6, 3, 2.0),
    (2, 4, 'Loft en el Born', 'Loft de diseño en barrio histórico', 'apartamento', 95.00, 4, 2, 1.5),
    (3, 5, 'Apartamento junto a la Ciudad de las Artes', 'Moderno apartamento en Valencia', 'apartamento', 75.00, 4, 2, 1.0),
    (6, 6, 'Casa en la playa de Valencia', 'Casa familiar con acceso directo a playa', 'casa', 150.00, 8, 4, 3.0),
    (7, 7, 'Habitación en casa sevillana', 'Habitación privada en casa tradicional', 'habitacion', 35.00, 2, 1, 1.0),
    (7, 8, 'Apartamento cerca de la Catedral', 'Céntrico apartamento en Sevilla', 'apartamento', 70.00, 3, 1, 1.0),
    (10, 9, 'Piso con vistas al mar en Málaga', 'Espectacular piso en primera línea', 'apartamento', 110.00, 5, 2, 2.0),
    (10, 10, 'Estudio en el centro de Málaga', 'Pequeño estudio bien ubicado', 'apartamento', 55.00, 2, 1, 1.0),
    (13, 11, 'Apartamento moderno en Bilbao', 'Cerca del museo Guggenheim', 'apartamento', 90.00, 4, 2, 1.0),
    (15, 12, 'Casa con vistas a la Alhambra', 'Espectacular casa en Granada', 'casa', 180.00, 8, 4, 3.0),
    (17, 13, 'Piso céntrico en Zaragoza', 'Apartamento amplio en el centro', 'apartamento', 70.00, 4, 2, 1.0),
    (19, 14, 'Apartamento frente al mar en Alicante', 'Vistas increíbles al Mediterráneo', 'apartamento', 100.00, 4, 2, 2.0),
    (1, 15, 'Casa tradicional en Córdoba', 'Casa con patio andaluz típico', 'casa', 130.00, 6, 3, 2.0),
    (2, 16, 'Villa de lujo en Palma', 'Villa exclusiva con piscina privada', 'villa', 350.00, 10, 5, 4.0),
    (3, 17, 'Apartamento en Las Palmas', 'Cerca de la playa de Las Canteras', 'apartamento', 80.00, 4, 2, 1.0),
    (6, 18, 'Piso familiar en Murcia', 'Amplio piso en zona residencial', 'apartamento', 65.00, 5, 3, 2.0),
    (7, 19, 'Apartamento con vistas en Santander', 'Vistas a la bahía de Santander', 'apartamento', 85.00, 4, 2, 1.0),
    (10, 20, 'Casa histórica en Toledo', 'Casa restaurada en casco antiguo', 'casa', 140.00, 6, 3, 2.5),
    (13, 21, 'Piso en la playa de la Concha', 'Ubicación premium en San Sebastián', 'apartamento', 160.00, 4, 2, 2.0),
    (15, 22, 'Apartamento universitario en Salamanca', 'Cerca de la Plaza Mayor', 'apartamento', 60.00, 3, 1, 1.0),
    (17, 23, 'Piso con vistas al mar en Cádiz', 'Apartamento luminoso en primera línea', 'apartamento', 95.00, 4, 2, 1.5),
    (19, 24, 'Casa romana en Tarragona', 'Casa con restos romanos', 'casa', 120.00, 6, 3, 2.0),
    (1, 25, 'Apartamento medieval en Girona', 'En el barrio judío histórico', 'apartamento', 75.00, 3, 1, 1.0),
    (2, 1, 'Ático de lujo en Madrid', 'Ático con terraza y vistas panorámicas', 'apartamento', 200.00, 6, 3, 2.5),
    (3, 3, 'Cabana en las afueras de Barcelona', 'Escapada rural cerca de la ciudad', 'cabana', 110.00, 4, 2, 1.0),
    (6, 5, 'Loft industrial en Valencia', 'Espacio diáfano de diseño', 'apartamento', 105.00, 4, 2, 2.0),
    (7, 7, 'Casa completa en Sevilla', 'Casa tradicional con patio', 'casa', 160.00, 8, 4, 3.0),
    (10, 9, 'Apartamento boutique en Málaga', 'Decoración exclusiva y moderna', 'apartamento', 125.00, 4, 2, 2.0);
    ```

<br/>

3.	Relaciona propiedades con amenidades (asignar amenidades aleatorias a cada propiedad):
    ```sql
    -- Asignar amenidades a propiedades (ejemplos)
    -- Propiedad 1: Apartamento céntrico en Gran Vía
    INSERT INTO propiedades_amenidades (id_propiedad, id_amenidad) VALUES
    (1, 1), (1, 2), (1, 4), (1, 6), (1, 9), (1, 12),
    -- Propiedad 2
    (2, 1), (2, 2), (2, 4), (2, 6),
    -- Propiedad 3
    (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 8), (3, 9), (3, 14),
    -- Propiedad 4
    (4, 1), (4, 2), (4, 4), (4, 6), (4, 14),
    -- Propiedad 5
    (5, 1), (5, 2), (5, 4), (5, 6), (5, 8),
    -- Propiedad 6 (Casa en la playa)
    (6, 1), (6, 2), (6, 4), (6, 5), (6, 6), (6, 7), (6, 8), (6, 14), (6, 15),
    -- Propiedad 7 (Habitación)
    (7, 1), (7, 2), (7, 6),
    -- Propiedad 8
    (8, 1), (8, 2), (8, 4), (8, 6), (8, 9),
    -- Propiedad 9
    (9, 1), (9, 2), (9, 4), (9, 5), (9, 6), (9, 8), (9, 14),
    -- Propiedad 10
    (10, 1), (10, 2), (10, 4), (10, 6),
    -- Continuar para más propiedades...
    (11, 1), (11, 2), (11, 4), (11, 6), (11, 9),
    (12, 1), (12, 2), (12, 3), (12, 4), (12, 5), (12, 6), (12, 7), (12, 8), (12, 14), (12, 15),
    (13, 1), (13, 2), (13, 4), (13, 6), (13, 8),
    (14, 1), (14, 2), (14, 4), (14, 6), (14, 8), (14, 14),
    (15, 1), (15, 2), (15, 3), (15, 4), (15, 5), (15, 6), (15, 8), (15, 15),
    (16, 1), (16, 2), (16, 3), (16, 4), (16, 5), (16, 6), (16, 7), (16, 8), (16, 11), (16, 14), (16, 15),
    (17, 1), (17, 2), (17, 4), (17, 6), (17, 8),
    (18, 1), (18, 2), (18, 4), (18, 5), (18, 6), (18, 8),
    (19, 1), (19, 2), (19, 4), (19, 6), (19, 8), (19, 14),
    (20, 1), (20, 2), (20, 3), (20, 4), (20, 6), (20, 8);
    ```

<br/>

4.	Verifica los datos insertados:
    ```sql
    SELECT COUNT(*) as total_propiedades FROM propiedades;
    SELECT COUNT(*) as total_amenidades FROM amenidades;

    -- Ver propiedades por tipo
    SELECT tipo_propiedad, COUNT(*) as cantidad,
            ROUND(AVG(precio_noche), 2) as precio_promedio
    FROM propiedades
    GROUP BY tipo_propiedad
    ORDER BY cantidad DESC;
    ```

<br/><br/>

#### Salida Esperada:
    ```sql
    total_propiedades
    ------------------
    30

    total_amenidades
    -----------------
    15

    tipo_propiedad | cantidad | precio_promedio
    ---------------|----------|----------------
    apartamento    | 23       | 95.43
    casa           | 5        | 152.00
    villa          | 1        | 350.00
    habitacion     | 1        | 35.00
    ```

<br/>

#### Verificación:

- [ ] Se insertaron al menos **30 propiedades**
- [ ] Se insertaron **15 amenidades**
- [ ] Las **propiedades** tienen **precios realistas**
- [ ] Las **propiedades** están **asociadas a amenidades**


<br/><br/>


### Paso 6: Inserción de Datos de Prueba - Reservas, Pagos y Reseñas
 Completar el dataset con reservas, pagos y reseñas para simular actividad del sistema.
 
1.	Inserta reservas (mínimo 100, aquí 50 como ejemplo):
    ```sql
    -- Insertar reservas (usar IDs válidos de propiedades y huéspedes)
    INSERT INTO reservas (id_propiedad, id_huesped, fecha_inicio, fecha_fin, num_huespedes, precio_total, estado) VALUES
    (1, 4, '2024-01-15', '2024-01-20', 2, 425.00, 'completada'),
    (1, 5, '2024-02-10', '2024-02-15', 2, 425.00, 'completada'),
    (2, 8, '2024-01-20', '2024-01-25', 2, 325.00, 'completada'),
    (3, 9, '2024-02-01', '2024-02-07', 4, 720.00, 'completada'),
    (3, 11, '2024-03-15', '2024-03-20', 4, 600.00, 'confirmada'),
    (4, 12, '2024-01-10', '2024-01-15', 3, 475.00, 'completada'),
    (5, 14, '2024-02-05', '2024-02-10', 3, 375.00, 'completada'),
    (6, 16, '2024-07-01', '2024-07-08', 6, 1050.00, 'confirmada'),
    (6, 18, '2024-08-15', '2024-08-22', 7, 1050.00, 'confirmada'),
    (7, 20, '2024-03-01', '2024-03-05', 1, 140.00, 'completada'),
    (8, 4, '2024-03-10', '2024-03-15', 2, 350.00, 'completada'),
    (9, 5, '2024-06-20', '2024-06-27', 4, 770.00, 'confirmada'),
    (10, 8, '2024-02-15', '2024-02-18', 2, 165.00, 'completada'),
    (11, 9, '2024-04-01', '2024-04-05', 3, 360.00, 'confirmada'),
    (12, 11, '2024-05-10', '2024-05-17', 6, 1260.00, 'confirmada'),
    (13, 12, '2024-03-20', '2024-03-25', 3, 350.00, 'completada'),
    (14, 14, '2024-07-10', '2024-07-17', 4, 700.00, 'confirmada'),
    (15, 16, '2024-04-15', '2024-04-20', 5, 650.00, 'completada'),
    (16, 18, '2024-08-01', '2024-08-08', 8, 2450.00, 'confirmada'),
    (17, 20, '2024-03-25', '2024-03-30', 3, 400.00, 'completada'),
    (18, 4, '2024-02-20', '2024-02-25', 4, 325.00, 'completada'),
    (19, 5, '2024-06-01', '2024-06-06', 3, 425.00, 'confirmada'),
    (20, 8, '2024-05-01', '2024-05-07', 5, 840.00, 'confirmada'),
    (21, 9, '2024-07-15', '2024-07-20', 4, 800.00, 'confirmada'),
    (22, 11, '2024-09-01', '2024-09-05', 2, 240.00, 'pendiente'),
    (23, 12, '2024-06-10', '2024-06-15', 3, 475.00, 'confirmada'),
    (24, 14, '2024-04-20', '2024-04-25', 5, 600.00, 'completada'),
    (25, 16, '2024-03-05', '2024-03-08', 2, 225.00, 'completada'),
    (26, 18, '2024-08-20', '2024-08-25', 5, 1000.00, 'confirmada'),
    (27, 20, '2024-05-15', '2024-05-20', 3, 550.00, 'confirmada'),
    (28, 4, '2024-06-25', '2024-06-30', 4, 525.00, 'confirmada'),
    (29, 5, '2024-07-05', '2024-07-12', 6, 1120.00, 'confirmada'),
    (30, 8, '2024-04-10', '2024-04-15', 3, 625.00, 'completada'),
    (1, 9, '2024-03-01', '2024-03-04', 2, 255.00, 'completada'),
    (2, 11, '2024-04-05', '2024-04-08', 2, 195.00, 'completada'),
    (3, 12, '2024-05-20', '2024-05-25', 5, 600.00, 'confirmada'),
    (4, 14, '2024-06-15', '2024-06-20', 3, 475.00, 'confirmada'),
    (5, 16, '2024-03-15', '2024-03-20', 3, 375.00, 'completada'),
    (7, 18, '2024-04-25', '2024-04-28', 1, 105.00, 'completada'),
    (8, 20, '2024-05-05', '2024-05-10', 2, 350.00, 'confirmada'),
    (10, 4, '2024-03-12', '2024-03-14', 2, 110.00, 'completada'),
    (11, 5, '2024-06-05', '2024-06-10', 3, 450.00, 'confirmada'),
    (13, 8, '2024-04-18', '2024-04-22', 3, 280.00, 'completada'),
    (14, 9, '2024-08-10', '2024-08-17', 4, 700.00, 'confirmada'),
    (15, 11, '2024-05-25', '2024-05-30', 4, 650.00, 'confirmada'),
    (17, 12, '2024-04-01', '2024-04-05', 3, 320.00, 'completada'),
    (19, 14, '2024-07-20', '2024-07-25', 3, 425.00, 'confirmada'),
    (21, 16, '2024-08-05', '2024-08-10', 4, 800.00, 'confirmada'),
    (23, 18, '2024-07-01', '2024-07-06', 3, 475.00, 'confirmada'),
    (25, 20, '2024-04-12', '2024-04-15', 2, 225.00, 'completada');
    ```

<br/>

2.	Inserta pagos para las reservas:
    ```sql
    -- Insertar pagos (uno por cada reserva completada o confirmada)
    INSERT INTO pagos (id_reserva, monto, metodo_pago, estado_pago) VALUES
    (1, 425.00, 'tarjeta_credito', 'completado'),
    (2, 425.00, 'paypal', 'completado'),
    (3, 325.00, 'tarjeta_debito', 'completado'),
    (4, 720.00, 'tarjeta_credito', 'completado'),
    (5, 600.00, 'tarjeta_credito', 'completado'),
    (6, 475.00, 'paypal', 'completado'),
    (7, 375.00, 'tarjeta_credito', 'completado'),
    (8, 1050.00, 'transferencia', 'completado'),
    (9, 1050.00, 'tarjeta_credito', 'completado'),
    (10, 140.00, 'tarjeta_debito', 'completado'),
    (11, 350.00, 'paypal', 'completado'),
    (12, 770.00, 'tarjeta_credito', 'completado'),
    (13, 165.00, 'tarjeta_debito', 'completado'),
    (14, 360.00, 'tarjeta_credito', 'completado'),
    (15, 1260.00, 'transferencia', 'completado'),
    (16, 350.00, 'paypal', 'completado'),
    (17, 700.00, 'tarjeta_credito', 'completado'),
    (18, 650.00, 'tarjeta_credito', 'completado'),
    (19, 2450.00, 'transferencia', 'completado'),
    (20, 400.00, 'tarjeta_debito', 'completado'),
    (21, 325.00, 'paypal', 'completado'),
    (22, 425.00, 'tarjeta_credito', 'completado'),
    (23, 840.00, 'tarjeta_credito', 'completado'),
    (24, 800.00, 'tarjeta_credito', 'completado'),
    (25, 240.00, 'tarjeta_debito', 'pendiente'),
    (26, 475.00, 'tarjeta_credito', 'completado'),
    (27, 600.00, 'paypal', 'completado'),
    (28, 225.00, 'tarjeta_debito', 'completado'),
    (29, 1000.00, 'tarjeta_credito', 'completado'),
    (30, 550.00, 'tarjeta_credito', 'completado');
    ```

<br/>

3.	Inserta reseñas para reservas completadas:
    ```sql
    -- Insertar reseñas (solo para reservas completadas)
    INSERT INTO resenas (id_reserva, id_usuario, calificacion, comentario) VALUES
    (1, 4, 5, 'Excelente ubicación y apartamento muy limpio. Totalmente recomendable.'),
    (2, 5, 4, 'Muy buena experiencia, aunque el wifi era un poco lento.'),
    (3, 8, 5, 'Perfecto para una escapada. El anfitrión fue muy atento.'),
    (4, 9, 5, 'Apartamento precioso con decoración modernista auténtica.'),
    (6, 12, 4, 'Buen apartamento, bien ubicado. Faltaban algunos utensilios de cocina.'),
    (7, 14, 5, 'Muy buena relación calidad-precio. Repetiremos seguro.'),
    (10, 20, 3, 'Habitación correcta pero algo pequeña para el precio.'),
    (11, 4, 5, 'Apartamento impecable y anfitrión muy comunicativo.'),
    (13, 8, 4, 'Buen estudio, aunque un poco ruidoso por la noche.'),
    (16, 12, 5, 'Perfecto para familia. Muy cómodo y bien equipado.'),
    (18, 16, 5, 'Casa espectacular con vistas increíbles. Vale cada euro.'),
    (20, 20, 4, 'Apartamento muy bonito, solo faltaba aire acondicionado.'),
    (21, 4, 5, 'Excelente experiencia, todo como en las fotos.'),
    (25, 16, 5, 'Apartamento acogedor en el barrio judío. Encantador.'),
    (28, 18, 4, 'Buena casa, aunque la limpieza podría mejorar un poco.'),
    (30, 8, 5, 'Apartamento boutique de lujo. Superó nuestras expectativas.'),
    (34, 9, 5, 'Ubicación perfecta en Gran Vía. Muy recomendable.'),
    (35, 11, 4, 'Buen estudio cerca del Retiro. Acogedor y limpio.'),
    (38, 16, 5, 'Todo perfecto. Repetiremos sin duda.'),
    (39, 18, 3, 'Correcto pero esperábamos más por el precio.'),
    (41, 4, 4, 'Pequeño pero funcional. Buena ubicación.'),
    (43, 8, 5, 'Apartamento fantástico, anfitrión muy amable.'),
    (46, 12, 4, 'Buena casa, ideal para grupos. Bien equipada.'),
    (50, 20, 5, 'Excelente apartamento en Girona. Muy histórico y auténtico.');
    ```

<br/>

4.	Verifica los datos de reservas:
    ```sql
    SELECT COUNT(*) as total_reservas FROM reservas;
    SELECT COUNT(*) as total_pagos FROM pagos;
    SELECT COUNT(*) as total_resenas FROM resenas;

    -- Estadísticas de reservas por estado
    SELECT estado, COUNT(*) as cantidad,
            SUM(precio_total) as ingresos_totales
    FROM reservas
    GROUP BY estado
    ORDER BY cantidad DESC;
    ```

<br/><br/>


#### Salida Esperada:
```sql
total_reservas
---------------
50

total_pagos
------------
30

total_resenas
--------------
24

estado      | cantidad | ingresos_totales
------------|----------|------------------
confirmada  | 28       | 18615.00
completada  | 21       | 9505.00
pendiente   | 1        | 240.00
```

#### Verificación

* ☐ Se insertaron al menos **50 reservas**.
* ☐ Hay **pagos** asociados a las **reservas**.
* ☐ Las **reservas completadas** tienen **reseñas**.
* ☐ Las **fechas de las reservas** son lógicas (**fecha_fin > fecha_inicio**).

<br/><br/>

### Paso 7: Crear Consultas de Negocio Complejas
Desarrollar consultas SQL avanzadas para reportes y análisis del negocio.
 
1.	Consulta 1: Búsqueda de propiedades disponibles por ciudad y rango de precio:
    ```sql
    -- Buscar propiedades disponibles en una ciudad específica con filtros
    SELECT
        p.id_propiedad,
        p.titulo,
        p.tipo_propiedad,
        p.precio_noche,
        p.capacidad_huespedes,
        p.num_habitaciones,
        u.ciudad,
        u.direccion,
        COALESCE(ROUND(AVG(re.calificacion), 2), 0) as calificacion_promedio,
        COUNT(DISTINCT re.id_resena) as num_resenas
    FROM propiedades p
    INNER JOIN ubicaciones u ON p.id_ubicacion = u.id_ubicacion
    LEFT JOIN reservas r ON p.id_propiedad = r.id_propiedad
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva
    WHERE u.ciudad = 'Madrid'
        AND p.precio_noche BETWEEN 50 AND 150
        AND p.activo = TRUE
    GROUP BY p.id_propiedad, p.titulo, p.tipo_propiedad, p.precio_noche,
                p.capacidad_huespedes, p.num_habitaciones, u.ciudad, u.direccion
    ORDER BY calificacion_promedio DESC, p.precio_noche ASC;
    ```

<br/><br/>


2.	Consulta 2: Verificar disponibilidad de una propiedad en fechas específicas:
    ```sql
    -- Verificar si una propiedad está disponible en un rango de fechas
    SELECT
        p.id_propiedad,
        p.titulo,
        p.precio_noche,
        CASE
            WHEN EXISTS (
                SELECT 1 FROM reservas r
                WHERE r.id_propiedad = p.id_propiedad
                    AND r.estado IN ('confirmada', 'pendiente')
                    AND (
                        (r.fecha_inicio <= '2024-06-01' AND r.fecha_fin >= '2024-06-01')
                        OR (r.fecha_inicio <= '2024-06-07' AND r.fecha_fin >= '2024-06-07')
                        OR (r.fecha_inicio >= '2024-06-01' AND r.fecha_fin <= '2024-06-07')
                    )
            ) THEN 'No disponible'
            ELSE 'Disponible'
        END as disponibilidad
    FROM propiedades p
    WHERE p.id_propiedad = 1;
    ```

<br/>


3.	Consulta 3: Top 10 propiedades mejor calificadas con más reservas:
    ```sql
    -- Ranking de propiedades por calificación y número de reservas
    SELECT
        p.id_propiedad,
        p.titulo,
        u.ciudad,
        p.tipo_propiedad,
        p.precio_noche,
        COUNT(DISTINCT r.id_reserva) as total_reservas,
        COALESCE(ROUND(AVG(re.calificacion), 2), 0) as calificacion_promedio,
        COUNT(DISTINCT re.id_resena) as num_resenas,
        ROUND(SUM(r.precio_total), 2) as ingresos_totales
    FROM propiedades p
    INNER JOIN ubicaciones u ON p.id_ubicacion = u.id_ubicacion
    LEFT JOIN reservas r ON p.id_propiedad = r.id_propiedad
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva
    WHERE r.estado = 'completada'
    GROUP BY p.id_propiedad, p.titulo, u.ciudad, p.tipo_propiedad, p.precio_noche
    HAVING COUNT(DISTINCT r.id_reserva) >= 2
    ORDER BY calificacion_promedio DESC, total_reservas DESC
    LIMIT 10;
    ```

<br/>


4.	Consulta 4: Reporte de ingresos por anfitrión:
    ```sql
    -- Ingresos totales por anfitrión con estadísticas
    SELECT
        u.id_usuario,
        u.nombre || ' ' || u.apellido as anfitrion,
        u.email,
        COUNT(DISTINCT p.id_propiedad) as num_propiedades,
        COUNT(DISTINCT r.id_reserva) as total_reservas,
        COALESCE(SUM(CASE WHEN r.estado = 'completada' THEN r.precio_total ELSE 0 END), 0) as ingresos_completados,
        COALESCE(SUM(CASE WHEN r.estado = 'confirmada' THEN r.precio_total ELSE 0 END), 0) as ingresos_pendientes,
        COALESCE(SUM(r.precio_total), 0) as ingresos_totales,
        COALESCE(ROUND(AVG(re.calificacion), 2), 0) as calificacion_promedio
    FROM usuarios u
    INNER JOIN propiedades p ON u.id_usuario = p.id_anfitrion
    LEFT JOIN reservas r ON p.id_propiedad = r.id_propiedad
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva
    WHERE u.tipo_usuario IN ('anfitrion', 'ambos')
    GROUP BY u.id_usuario, u.nombre, u.apellido, u.email
    ORDER BY ingresos_totales DESC;
    ```

<br/>


5.	Consulta 5: Análisis de ocupación por propiedad:
    ```sql
    -- Tasa de ocupación y análisis por propiedad
    WITH reservas_por_propiedad AS (
        SELECT
            p.id_propiedad,
            p.titulo,
            COUNT(r.id_reserva) as total_reservas,
            SUM(r.fecha_fin - r.fecha_inicio) as total_noches_reservadas,
            SUM(r.precio_total) as ingresos_totales,
            MIN(r.fecha_reserva) as primera_reserva,
            MAX(r.fecha_reserva) as ultima_reserva
        FROM propiedades p
        LEFT JOIN reservas r ON p.id_propiedad = r.id_propiedad
        WHERE r.estado IN ('completada', 'confirmada')
        GROUP BY p.id_propiedad, p.titulo
    )
    SELECT
        id_propiedad,
        titulo,
        total_reservas,
        total_noches_reservadas,
        ROUND(ingresos_totales, 2) as ingresos_totales,
        ROUND(ingresos_totales / NULLIF(total_noches_reservadas, 0), 2) as ingreso_promedio_noche,
        primera_reserva,
        ultima_reserva,
        EXTRACT(DAY FROM (ultima_reserva - primera_reserva)) as dias_activo
    FROM reservas_por_propiedad
    WHERE total_reservas > 0
    ORDER BY ingresos_totales DESC;
    ```

<br/>

6.	Consulta 6: Historial completo de reservas de un huésped:
    ```sql
    -- Historial de reservas de un huésped específico
    SELECT
        r.id_reserva,
        r.fecha_reserva,
        p.titulo as propiedad,
        u_anf.nombre || ' ' || u_anf.apellido as anfitrion,
        ub.ciudad,
        r.fecha_inicio,
        r.fecha_fin,
        r.fecha_fin - r.fecha_inicio as noches,
        r.num_huespedes,
        r.precio_total,
        r.estado,
        pg.estado_pago,
        re.calificacion,
        re.comentario
    FROM reservas r
    INNER JOIN propiedades p ON r.id_propiedad = p.id_propiedad
    INNER JOIN usuarios u_anf ON p.id_anfitrion = u_anf.id_usuario
    INNER JOIN ubicaciones ub ON p.id_ubicacion = ub.id_ubicacion
    LEFT JOIN pagos pg ON r.id_reserva = pg.id_reserva
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva
    WHERE r.id_huesped = 4
    ORDER BY r.fecha_reserva DESC;
    ```

<br/>


7.	Consulta 7: Propiedades con sus amenidades:
    ```sql
    -- Listar propiedades con todas sus amenidades
    SELECT
        p.id_propiedad,
        p.titulo,
        p.tipo_propiedad,
        p.precio_noche,
        u.ciudad,
        STRING_AGG(a.nombre, ', ' ORDER BY a.nombre) as amenidades
    FROM propiedades p
    INNER JOIN ubicaciones u ON p.id_ubicacion = u.id_ubicacion
    LEFT JOIN propiedades_amenidades pa ON p.id_propiedad = pa.id_propiedad
    LEFT JOIN amenidades a ON pa.id_amenidad = a.id_amenidad
    GROUP BY p.id_propiedad, p.titulo, p.tipo_propiedad, p.precio_noche, u.ciudad
    ORDER BY p.id_propiedad;
    ```

<br/>

8.	Consulta 8: Análisis de métodos de pago y estados:
    ```sql
    -- Análisis de pagos por método y estado
    SELECT
        metodo_pago,
        estado_pago,
        COUNT(*) as num_transacciones,
        SUM(monto) as monto_total,
        ROUND(AVG(monto), 2) as monto_promedio,
        MIN(monto) as monto_minimo,
        MAX(monto) as monto_maximo
    FROM pagos
    GROUP BY metodo_pago, estado_pago
    ORDER BY monto_total DESC;
    ```

<br/>

9.	Consulta 9: Propiedades más reservadas por temporada (usando funciones window):
    ```sql
    -- Ranking de propiedades por temporada usando window functions
    WITH reservas_temporada AS (
        SELECT
            p.id_propiedad,
            p.titulo,
            CASE
                WHEN EXTRACT(MONTH FROM r.fecha_inicio) IN (6, 7, 8) THEN 'Verano'
                WHEN EXTRACT(MONTH FROM r.fecha_inicio) IN (12, 1, 2) THEN 'Invierno'
                WHEN EXTRACT(MONTH FROM r.fecha_inicio) IN (3, 4, 5) THEN 'Primavera'
                ELSE 'Otoño'
            END as temporada,
            COUNT(*) as num_reservas,
            SUM(r.precio_total) as ingresos
        FROM propiedades p
        INNER JOIN reservas r ON p.id_propiedad = r.id_propiedad
        WHERE r.estado IN ('completada', 'confirmada')
        GROUP BY p.id_propiedad, p.titulo, temporada
    )
    SELECT
        temporada,
        id_propiedad,
        titulo,
        num_reservas,
        ingresos,
        RANK() OVER (PARTITION BY temporada ORDER BY num_reservas DESC) as ranking_temporada
    FROM reservas_temporada
    ORDER BY temporada, ranking_temporada;
    ```

<br/>


10.	Consulta 10: Reporte completo de actividad del sistema:
    ```sql
        -- Dashboard general del sistema
        SELECT
            'Total Usuarios' as metrica,
            COUNT(*)::TEXT as valor
        FROM usuarios
        UNION ALL
        SELECT
            'Total Propiedades',
            COUNT(*)::TEXT
        FROM propiedades
        UNION ALL
        SELECT
            'Total Reservas',
            COUNT(*)::TEXT
        FROM reservas
        UNION ALL
        SELECT
            'Reservas Confirmadas',
            COUNT(*)::TEXT
        FROM reservas WHERE estado = 'confirmada'
        UNION ALL
        SELECT
            'Reservas Completadas',
            COUNT(*)::TEXT
        FROM reservas WHERE estado = 'completada'
        UNION ALL
        SELECT
            'Ingresos Totales',
            '€ ' || ROUND(SUM(precio_total), 2)::TEXT
        FROM reservas WHERE estado IN ('completada', 'confirmada')
        UNION ALL
        SELECT
            'Calificación Promedio',
            ROUND(AVG(calificacion), 2)::TEXT || ' / 5'
        FROM resenas
        UNION ALL
        SELECT
            'Total Reseñas',
            COUNT(*)::TEXT
        FROM resenas;
    ```

<br/><br/>


#### Verificación

* ☐ Todas las **consultas** se ejecutan **sin errores**.
* ☐ Los **resultados** son **coherentes** con los datos insertados.
* ☐ Las consultas usan **JOINs**, **agregaciones** y **funciones avanzadas**.
* ☐ Los **reportes** proporcionan **información útil para el negocio**.


<br/><br/>

### Paso 8: Crear Vistas para Consultas Comunes
Desarrollar vistas que encapsulen consultas frecuentes para facilitar su reutilización.
 
1.	Crea una vista para propiedades disponibles con información completa:
    ```sql
    -- Vista: propiedades_completas
    CREATE OR REPLACE VIEW vista_propiedades_completas AS
    SELECT
        p.id_propiedad,
        p.titulo,
        p.descripcion,
        p.tipo_propiedad,
        p.precio_noche,
        p.capacidad_huespedes,
        p.num_habitaciones,
        p.num_banos,
        u_anf.nombre || ' ' || u_anf.apellido as anfitrion,
        u_anf.email as email_anfitrion,
        ub.ciudad,
        ub.pais,
        ub.direccion,
        ub.latitud,
        ub.longitud,
        COALESCE(ROUND(AVG(re.calificacion), 2), 0) as calificacion_promedio,
        COUNT(DISTINCT re.id_resena) as num_resenas,
        COUNT(DISTINCT r.id_reserva) as total_reservas,
        STRING_AGG(DISTINCT a.nombre, ', ' ORDER BY a.nombre) as amenidades,
        p.activo
    FROM propiedades p
    INNER JOIN usuarios u_anf ON p.id_anfitrion = u_anf.id_usuario
    INNER JOIN ubicaciones ub ON p.id_ubicacion = ub.id_ubicacion
    LEFT JOIN propiedades_amenidades pa ON p.id_propiedad = pa.id_propiedad
    LEFT JOIN amenidades a ON pa.id_amenidad = a.id_amenidad
    LEFT JOIN reservas r ON p.id_propiedad = r.id_propiedad
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva
    GROUP BY p.id_propiedad, p.titulo, p.descripcion, p.tipo_propiedad,
                p.precio_noche, p.capacidad_huespedes, p.num_habitaciones,
                p.num_banos, anfitrion, email_anfitrion, ub.ciudad, ub.pais,
                ub.direccion, ub.latitud, ub.longitud, p.activo;

    COMMENT ON VIEW vista_propiedades_completas IS
    'Vista consolidada con información completa de propiedades incluyendo anfitrión, ubicación, amenidades y estadísticas';
    ```

<br/><br/>


2.	Crea una vista para el historial de reservas con detalles:
    ```sql
    -- Vista: historial_reservas
    CREATE OR REPLACE VIEW vista_historial_reservas AS
    SELECT
        r.id_reserva,
        r.fecha_reserva,
        r.fecha_inicio,
        r.fecha_fin,
        r.fecha_fin - r.fecha_inicio as num_noches,
        r.num_huespedes,
        r.precio_total,
        r.estado as estado_reserva,
        p.titulo as propiedad,
        p.tipo_propiedad,
        ub.ciudad,
        ub.pais,
        u_hue.nombre || ' ' || u_hue.apellido as huesped,
        u_hue.email as email_huesped,
        u_anf.nombre || ' ' || u_anf.apellido as anfitrion,
        u_anf.email as email_anfitrion,
        pg.monto as monto_pago,
        pg.metodo_pago,
        pg.estado_pago,
        re.calificacion,
        re.comentario as comentario_resena
    FROM reservas r
    INNER JOIN propiedades p ON r.id_propiedad = p.id_propiedad
    INNER JOIN ubicaciones ub ON p.id_ubicacion = ub.id_ubicacion
    INNER JOIN usuarios u_hue ON r.id_huesped = u_hue.id_usuario
    INNER JOIN usuarios u_anf ON p.id_anfitrion = u_anf.id_usuario
    LEFT JOIN pagos pg ON r.id_reserva = pg.id_reserva
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva;

    COMMENT ON VIEW vista_historial_reservas IS
    'Vista completa del historial de reservas con información de huésped, anfitrión, propiedad, pagos y reseñas';
    ```

<br/>


3.	Crea una vista para estadísticas de anfitriones:
    ```sql
    -- Vista: estadisticas_anfitriones
    CREATE OR REPLACE VIEW vista_estadisticas_anfitriones AS
    SELECT
        u.id_usuario as id_anfitrion,
        u.nombre || ' ' || u.apellido as anfitrion,
        u.email,
        u.fecha_registro,
        COUNT(DISTINCT p.id_propiedad) as num_propiedades,
        COUNT(DISTINCT r.id_reserva) as total_reservas,
        COUNT(DISTINCT CASE WHEN r.estado = 'completada' THEN r.id_reserva END) as reservas_completadas,
        COUNT(DISTINCT CASE WHEN r.estado = 'confirmada' THEN r.id_reserva END) as reservas_confirmadas,
        COALESCE(SUM(CASE WHEN r.estado = 'completada' THEN r.precio_total ELSE 0 END), 0) as ingresos_completados,
        COALESCE(SUM(CASE WHEN r.estado = 'confirmada' THEN r.precio_total ELSE 0 END), 0) as ingresos_pendientes,
        COALESCE(SUM(r.precio_total), 0) as ingresos_totales,
        COALESCE(ROUND(AVG(re.calificacion), 2), 0) as calificacion_promedio,
        COUNT(DISTINCT re.id_resena) as num_resenas
    FROM usuarios u
    INNER JOIN propiedades p ON u.id_usuario = p.id_anfitrion
    LEFT JOIN reservas r ON p.id_propiedad = r.id_propiedad
    LEFT JOIN resenas re ON r.id_reserva = re.id_reserva
    WHERE u.tipo_usuario IN ('anfitrion', 'ambos')
    GROUP BY u.id_usuario, u.nombre, u.apellido, u.email, u.fecha_registro;

    COMMENT ON VIEW vista_estadisticas_anfitriones IS
    'Estadísticas consolidadas de rendimiento y actividad de anfitriones';
    ```

<br/><br/>

4.	Prueba las vistas creadas:
    ```sql
    -- Probar vista de propiedades completas
    SELECT * FROM vista_propiedades_completas
    WHERE ciudad = 'Madrid'
    ORDER BY calificacion_promedio DESC
    LIMIT 5;

    -- Probar vista de historial de reservas
    SELECT * FROM vista_historial_reservas
    WHERE estado_reserva = 'completada'
    ORDER BY fecha_reserva DESC
    LIMIT 10;

    -- Probar vista de estadísticas de anfitriones
    SELECT * FROM vista_estadisticas_anfitriones
    ORDER BY ingresos_totales DESC;
    ```

<br/><br/>

#### Salida Esperada

Las **vistas** deberían retornar **datos consolidados y formateados**, facilitando **consultas complejas** sin necesidad de escribir **JOINs repetitivos**.


#### Verificación

* ☐ Las **tres vistas** se crearon correctamente.
* ☐ Las vistas aparecen en el navegador de **pgAdmin** bajo **Views**.
* ☐ Las **consultas a las vistas** retornan **datos correctos**.
* ☐ Los **comentarios de las vistas** están **documentados**.


<br/><br/>

### Paso 9: Documentación del Proyecto
Crear documentación completa del proyecto incluyendo diagrama ER, descripción de tablas y guía de uso.
 
1.	Crea un archivo README.md con la siguiente estructura (guarda en tu editor de texto):

```md
   # Sistema de Reservas de Alojamientos

   ## Descripción del Proyecto
   Base de datos relacional completa para sistema de reservas de alojamientos tipo Airbnb/Booking.
   Desarrollado como proyecto final del curso de PostgreSQL 18.

   ## Autor
   [Tu Nombre]
   Fecha: [Fecha actual]

   ## Tecnologías
   - PostgreSQL 18.x
   - PgAdmin 4
   - SQL (DDL, DML, DQL)

   ## Modelo de Datos

   ### Entidades Principales
   1. **usuarios**: Huéspedes y anfitriones del sistema
   2. **ubicaciones**: Ubicaciones geográficas de propiedades
   3. **propiedades**: Alojamientos disponibles para reserva
   4. **amenidades**: Servicios y características de propiedades
   5. **propiedades_amenidades**: Relación N:M entre propiedades y amenidades
   6. **reservas**: Reservas realizadas por huéspedes
   7. **pagos**: Transacciones de pago asociadas a reservas
   8. **resenas**: Calificaciones y comentarios de huéspedes

   ### Relaciones
   - Un usuario (anfitrión) puede tener múltiples propiedades (1:N)
   - Una propiedad pertenece a una ubicación (N:1)
   - Una propiedad puede tener múltiples amenidades (N:M)
   - Una propiedad puede tener múltiples reservas (1:N)
   - Una reserva pertenece a un huésped (N:1)
   - Una reserva puede tener múltiples pagos (1:N)
   - Una reserva puede tener una reseña (1:1)

   ## Instalación y Configuración

   ### Prerrequisitos
   - PostgreSQL 18 instalado
   - PgAdmin 4 configurado
   - Permisos para crear bases de datos

   ### Pasos de Instalación
   1. Crear base de datos: `CREATE DATABASE sistema_reservas_alojamientos;`
   2. Ejecutar script DDL: `01_crear_tablas.sql`
   3. Ejecutar script DML: `02_insertar_datos.sql`
   4. Ejecutar script vistas: `03_crear_vistas.sql`

   ## Consultas Disponibles

   ### Consultas de Búsqueda
   - Búsqueda de propiedades por ciudad y precio
   - Verificación de disponibilidad por fechas
   - Propiedades con amenidades específicas

   ### Reportes de Negocio
   - Top propiedades mejor calificadas
   - Ingresos por anfitrión
   - Análisis de ocupación
   - Estadísticas de pagos

   ### Vistas Creadas
   - `vista_propiedades_completas`: Información consolidada de propiedades
   - `vista_historial_reservas`: Historial completo de reservas
   - `vista_estadisticas_anfitriones`: Métricas de rendimiento de anfitriones

   ## Estadísticas del Sistema
   - Total de usuarios: [Verificar con consulta]
   - Total de propiedades: [Verificar con consulta]
   - Total de reservas: [Verificar con consulta]
   - Ingresos totales: [Verificar con consulta]

   ## Mejoras Futuras
   - Implementar triggers para validaciones automáticas
   - Añadir funciones almacenadas para lógica de negocio
   - Crear índices adicionales para optimización
   - Implementar auditoría de cambios
   - Añadir soporte multiidioma

   ## Licencia
   Proyecto educativo - Curso PostgreSQL 2024
```

<br/>

2.	Exporta el diagrama ER (si lo creaste en herramienta digital) o toma foto del diagrama en papel.

3.	Genera un script SQL completo con todo el código del proyecto:
    ```sql
    -- ============================================
    -- SISTEMA DE RESERVAS DE ALOJAMIENTOS
    -- Proyecto Final - Curso PostgreSQL 18
    -- Autor: [Tu Nombre]
    -- Fecha: [Fecha actual]
    -- ============================================

    -- SECCIÓN 1: CREACIÓN DE BASE DE DATOS
    -- (Incluir código del Paso 2)

    -- SECCIÓN 2: CREACIÓN DE TABLAS
    -- (Incluir código del Paso 3)

    -- SECCIÓN 3: INSERCIÓN DE DATOS
    -- (Incluir código de los Pasos 4, 5 y 6)

    -- SECCIÓN 4: CONSULTAS DE NEGOCIO
    -- (Incluir código del Paso 7)

    -- SECCIÓN 5: CREACIÓN DE VISTAS
    -- (Incluir código del Paso 8)

    -- FIN DEL SCRIPT
    ```

<br/><br/>

4.	Crea un documento con las decisiones de diseño:

    ```md
    # Decisiones de Diseño - Sistema de Reservas

    ## Normalización
    - Todas las tablas están en 3FN
    - Se eliminaron dependencias transitivas
    - Se creó tabla intermedia para relación N:M (propiedades_amenidades)

    ## Tipos de Datos
    - SERIAL para claves primarias autoincrementales
    - VARCHAR con límites apropiados para textos
    - DECIMAL(10,2) para valores monetarios
    - TIMESTAMP para fechas y horas
    - BOOLEAN para campos de estado

    ## Constraints
    - CHECK constraints para validar valores permitidos
    - UNIQUE constraints para evitar duplicados
    - FOREIGN KEY con ON DELETE CASCADE/RESTRICT según lógica de negocio
    - NOT NULL para campos obligatorios

    ## Índices
    - Índices en claves foráneas para mejorar JOINs
    - Índices en campos de búsqueda frecuente (ciudad, email, fechas)
    - Índices en campos de filtrado (tipo_propiedad, estado)

    ## Seguridad
    - Passwords almacenados como hash
    - Validación de rangos de precios y calificaciones
    - Validación de fechas (fecha_fin > fecha_inicio)
    ```

<br/><br/>

#### Verificación

* ☐ **README.md** creado con toda la información del proyecto.
* ☐ **Script SQL completo** generado y probado.
* ☐ **Diagrama ER** disponible (formato digital o fotografía).
* ☐ **Documento de decisiones de diseño** completado.


<br/><br/>

### Paso 10: Validación Final y Entrega
Verificar que todos los componentes del proyecto funcionan correctamente y preparar la entrega.
 
1.	Ejecuta una validación completa del sistema:
    ```sql
    -- Script de validación completa

    -- 1. Verificar todas las tablas
    SELECT
        table_name,
        (SELECT COUNT(*) FROM information_schema.columns
            WHERE table_name = t.table_name AND table_schema = 'public') as num_columnas
    FROM information_schema.tables t
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    ORDER BY table_name;

    -- 2. Verificar constraints
    SELECT
        tc.table_name,
        tc.constraint_name,
        tc.constraint_type
    FROM information_schema.table_constraints tc
    WHERE tc.table_schema = 'public'
    ORDER BY tc.table_name, tc.constraint_type;

    -- 3. Verificar integridad referencial
    SELECT
        COUNT(*) as total_registros,
        'usuarios' as tabla
    FROM usuarios
    UNION ALL
    SELECT COUNT(*), 'ubicaciones' FROM ubicaciones
    UNION ALL
    SELECT COUNT(*), 'propiedades' FROM propiedades
    UNION ALL
    SELECT COUNT(*), 'amenidades' FROM amenidades
    UNION ALL
    SELECT COUNT(*), 'reservas' FROM reservas
    UNION ALL
    SELECT COUNT(*), 'pagos' FROM pagos
    UNION ALL
    SELECT COUNT(*), 'resenas' FROM resenas;

    -- 4. Verificar vistas
    SELECT
        table_name as vista,
        view_definition
    FROM information_schema.views
    WHERE table_schema = 'public';

    -- 5. Verificar índices
    SELECT
        tablename,
        indexname,
        indexdef
    FROM pg_indexes
    WHERE schemaname = 'public'
    ORDER BY tablename, indexname;
    ```

<br/>


2.	Ejecuta pruebas de las consultas principales:
    ```sql
    -- Prueba 1: Búsqueda funciona correctamente
    SELECT COUNT(*) as propiedades_madrid
    FROM vista_propiedades_completas
    WHERE ciudad = 'Madrid';

    -- Prueba 2: Reservas tienen pagos asociados
    SELECT
        COUNT(DISTINCT r.id_reserva) as reservas_con_pago
    FROM reservas r
    INNER JOIN pagos p ON r.id_reserva = p.id_reserva
    WHERE r.estado IN ('completada', 'confirmada');

    -- Prueba 3: Reseñas solo para reservas completadas
    SELECT
        COUNT(*) as resenas_validas
    FROM resenas re
    INNER JOIN reservas r ON re.id_reserva = r.id_reserva
    WHERE r.estado = 'completada';

    -- Prueba 4: No hay reservas con fechas inválidas
    SELECT COUNT(*) as reservas_fechas_invalidas
    FROM reservas
    WHERE fecha_fin <= fecha_inicio;

    -- Resultado esperado: 0
    ```

<br/>

3.	Genera un reporte final de estadísticas:
    ```sql
    -- Reporte final del sistema
    SELECT 'ESTADÍSTICAS FINALES DEL SISTEMA' as titulo;

    SELECT
        'Total Usuarios' as metrica,
        COUNT(*)::TEXT as valor
    FROM usuarios
    UNION ALL
    SELECT 'Total Anfitriones', COUNT(*)::TEXT
    FROM usuarios WHERE tipo_usuario IN ('anfitrion', 'ambos')
    UNION ALL
    SELECT 'Total Huéspedes', COUNT(*)::TEXT
    FROM usuarios WHERE tipo_usuario IN ('huesped', 'ambos')
    UNION ALL
    SELECT 'Total Propiedades', COUNT(*)::TEXT
    FROM propiedades
    UNION ALL
    SELECT 'Total Ubicaciones', COUNT(*)::TEXT
    FROM ubicaciones
    UNION ALL
    SELECT 'Total Amenidades', COUNT(*)::TEXT
    FROM amenidades
    UNION ALL
    SELECT 'Total Reservas', COUNT(*)::TEXT
    FROM reservas
    UNION ALL
    SELECT 'Reservas Completadas', COUNT(*)::TEXT
    FROM reservas WHERE estado = 'completada'
    UNION ALL
    SELECT 'Reservas Confirmadas', COUNT(*)::TEXT
    FROM reservas WHERE estado = 'confirmada'
    UNION ALL
    SELECT 'Total Pagos', COUNT(*)::TEXT
    FROM pagos
    UNION ALL
    SELECT 'Pagos Completados', COUNT(*)::TEXT
    FROM pagos WHERE estado_pago = 'completado'
    UNION ALL
    SELECT 'Total Reseñas', COUNT(*)::TEXT
    FROM resenas
    UNION ALL
    SELECT 'Calificación Promedio Sistema', ROUND(AVG(calificacion), 2)::TEXT || ' / 5'
    FROM resenas
    UNION ALL
    SELECT 'Ingresos Totales Completados', '€ ' || ROUND(SUM(precio_total), 2)::TEXT
    FROM reservas WHERE estado = 'completada'
    UNION ALL
    SELECT 'Precio Promedio por Noche', '€ ' || ROUND(AVG(precio_noche), 2)::TEXT
    FROM propiedades;
    ```

<br/>

4. **Prepara los archivos para entrega:**

   * **README.md** – Documentación principal del proyecto.
   * **diagrama_er.png** o **diagrama_er.pdf** – Diagrama Entidad–Relación.
   * **script_completo.sql** – Todo el código SQL del proyecto.
   * **decisiones_diseno.md** – Documento de decisiones de diseño.
   * **consultas_negocio.sql** – Archivo separado con las **10 consultas principales** del negocio.
   * **validacion_final.txt** – Resultados de las pruebas de validación.


<br/><br/>

#### Salida Esperada del Reporte Final:
```sql
titulo
--------------------------------------
ESTADÍSTICAS FINALES DEL SISTEMA

metrica                          | valor
---------------------------------|------------------
Total Usuarios                   | 20
Total Anfitriones                | 10
Total Huéspedes                  | 12
Total Propiedades                | 30
Total Ubicaciones                | 25
Total Amenidades                 | 15
Total Reservas                   | 50
Reservas Completadas             | 21
Reservas Confirmadas             | 28
Total Pagos                      | 30
Pagos Completados                | 29
Total Reseñas                    | 24
Calificación Promedio Sistema    | 4.42 / 5
Ingresos Totales Completados     | € 9505.00
Precio Promedio por Noche        | € 112.17
```

<br/>

#### Verificación

* ☐ Todas las **tablas** tienen **datos**.
* ☐ No hay **errores de integridad referencial**.
* ☐ Todas las **consultas** se ejecutan correctamente.
* ☐ Las **vistas** funcionan como se espera.
* ☐ El **reporte final** muestra **estadísticas coherentes**.
* ☐ Todos los **archivos de documentación** están completos.


<br/><br/>

## Validación y Pruebas

### Criterios de Éxito (Checklist)

* ☐ **Base de datos** creada y configurada correctamente.
* ☐ Al menos **8 tablas** implementadas con **constraints** apropiados.
* ☐ Mínimo **50 propiedades** insertadas.
* ☐ Mínimo **100 usuarios** insertados.
* ☐ Mínimo **200 reservas** insertadas.
* ☐ Todas las **relaciones** (**claves foráneas**) funcionan correctamente.
* ☐ Al menos **10 consultas complejas de negocio** implementadas.
* ☐ Al menos **3 vistas** creadas y funcionales.
* ☐ **Documentación** completa del proyecto.
* ☐ **Diagrama ER** disponible y correcto.
* ☐ **Script SQL** ejecutable sin errores.
* ☐ **Pruebas de validación** pasadas exitosamente.


<br/><br/>

## Procedimiento de Pruebas

1.	Prueba de Integridad de Datos:
    ```sql
    -- Verificar que no hay registros huérfanos
    SELECT 'Propiedades sin anfitrión' as problema, COUNT(*) as cantidad
    FROM propiedades p
    LEFT JOIN usuarios u ON p.id_anfitrion = u.id_usuario
    WHERE u.id_usuario IS NULL
    UNION ALL
    SELECT 'Reservas sin propiedad', COUNT(*)
    FROM reservas r
    LEFT JOIN propiedades p ON r.id_propiedad = p.id_propiedad
    WHERE p.id_propiedad IS NULL
    UNION ALL
    SELECT 'Pagos sin reserva', COUNT(*)
    FROM pagos pg
    LEFT JOIN reservas r ON pg.id_reserva = r.id_reserva
    WHERE r.id_reserva IS NULL;

    -- Resultado esperado: 0 para todos
    ```

2.	Prueba de Rendimiento de Consultas:
    ```sql
    -- Activar análisis de rendimiento
    EXPLAIN ANALYZE
    SELECT * FROM vista_propiedades_completas
    WHERE ciudad = 'Madrid'
        AND precio_noche < 100
    ORDER BY calificacion_promedio DESC;
    ```

3.	Prueba de Constraints:
    ```sql
    -- Intentar insertar datos inválidos (debe fallar)
    -- Prueba 1: Precio negativo
    INSERT INTO propiedades (id_anfitrion, id_ubicacion, titulo, tipo_propiedad, precio_noche, capacidad_huespedes, num_habitaciones, num_banos)
    VALUES (1, 1, 'Test', 'apartamento', -50.00, 2, 1, 1);
    -- Debe fallar con error de CHECK constraint

    -- Prueba 2: Fechas inválidas en reserva
    INSERT INTO reservas (id_propiedad, id_huesped, fecha_inicio, fecha_fin, num_huespedes, precio_total, estado)
    VALUES (1, 4, '2024-06-10', '2024-06-05', 2, 100.00, 'pendiente');
    -- Debe fallar con error de CHECK constraint
    ```

<br/><br/>

## Solución de Problemas

### Problema 1: Error al crear la base de datos por permisos insuficientes

#### Síntomas

* Mensaje de error: **"permission denied to create database"**.
* No se puede ejecutar el comando **CREATE DATABASE**.

#### Causa

El **usuario actual** no tiene **privilegios** para **crear bases de datos**.


#### Solución:

```sql
-- Conectarse como superusuario (postgres) y otorgar permisos
GRANT CREATE ON DATABASE postgres TO tu_usuario;

-- O crear la base de datos como superusuario
-- y luego otorgar permisos al usuario
CREATE DATABASE sistema_reservas_alojamientos OWNER tu_usuario;
```

<br/><br/>

### Problema 2: Error de violación de clave foránea al insertar datos

#### Síntomas

* Mensaje de error: **"insert or update on table violates foreign key constraint"**.
* No se pueden insertar **registros** en **tablas dependientes**.

#### Causa

Se intenta insertar un **registro** que referencia un **ID inexistente** en la **tabla padre**.


#### Solución:

```sql
-- Verificar que los IDs referenciados existen
-- Por ejemplo, antes de insertar una propiedad:
SELECT id_usuario FROM usuarios WHERE id_usuario = 1;
SELECT id_ubicacion FROM ubicaciones WHERE id_ubicacion = 1;

-- Si no existen, insertar primero en las tablas padre
-- o usar IDs válidos existentes
```

<br/><br/>

### Problema 3: Consultas lentas con grandes volúmenes de datos

#### Síntomas

* Las **consultas** tardan mucho tiempo en ejecutarse.
* **pgAdmin** parece “congelado” durante la ejecución de consultas.

#### Causa

Falta de **índices** en columnas **frecuentemente consultadas** o **JOINs** sin optimizar.


#### Solución:
```sql
-- Crear índices adicionales en columnas de búsqueda
CREATE INDEX idx_propiedades_precio_ciudad
ON propiedades(precio_noche)
INCLUDE (id_ubicacion);

-- Analizar el plan de ejecución
EXPLAIN ANALYZE [tu_consulta];

-- Actualizar estadísticas de las tablas
ANALYZE propiedades;
ANALYZE reservas;
```

<br/><br/>

### Problema 4: Error al crear vistas por dependencias circulares

#### Síntomas

* Mensaje de error: **"cannot create view with circular dependencies"**.
* La **vista** no se crea correctamente.

#### Causa

La definición de la **vista** hace referencia a **sí misma** o a **otra vista** que, a su vez, la referencia.


#### Solución:
```sql
-- Revisar las dependencias de la vista
SELECT * FROM pg_views WHERE viewname = 'nombre_vista';

-- Recrear la vista sin dependencias circulares
-- Usar CTEs si es necesario para estructurar mejor la consulta
```

<br/><br/>

### Problema 5: Datos inconsistentes después de inserciones masivas

#### Síntomas

* Algunos **registros** no aparecen en las **consultas**.
* Los **conteos** no coinciden con lo esperado.

#### Causa

**Transacciones no confirmadas** (*COMMIT* faltante) o **errores silenciosos** durante la inserción de datos.


#### Solución:
```sql
-- Verificar transacciones pendientes
SELECT * FROM pg_stat_activity
WHERE state = 'idle in transaction';

-- Confirmar transacciones manualmente si es necesario
COMMIT;

-- Verificar conteos en todas las tablas
SELECT
    schemaname,
    tablename,
    n_live_tup as registros
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

<br/><br/>

## Limpieza

Advertencia: Los siguientes comandos eliminarán PERMANENTEMENTE la base de datos y todos sus datos. Asegúrate de haber guardado respaldos si necesitas conservar alguna información.

<br/>

- Para eliminar completamente el proyecto:

    ```sql
    -- 1. Desconectarse de la base de datos del proyecto
    -- (cambiar a otra base de datos como 'postgres')

    -- 2. Terminar todas las conexiones activas a la base de datos
    SELECT pg_terminate_backend(pg_stat_activity.pid)
    FROM pg_stat_activity
    WHERE pg_stat_activity.datname = 'sistema_reservas_alojamientos'
    AND pid <> pg_backend_pid();

    -- 3. Eliminar la base de datos
    DROP DATABASE IF EXISTS sistema_reservas_alojamientos;
    ```

<br/>

- Para eliminar solo los datos pero conservar la estructura:

    ```sql
    -- Conectarse a la base de datos del proyecto

    -- Eliminar datos en orden inverso a las dependencias
    TRUNCATE TABLE resenas CASCADE;
    TRUNCATE TABLE pagos CASCADE;
    TRUNCATE TABLE reservas CASCADE;
    TRUNCATE TABLE propiedades_amenidades CASCADE;
    TRUNCATE TABLE propiedades CASCADE;
    TRUNCATE TABLE amenidades CASCADE;
    TRUNCATE TABLE ubicaciones CASCADE;
    TRUNCATE TABLE usuarios CASCADE;

    -- Reiniciar secuencias
    ALTER SEQUENCE usuarios_id_usuario_seq RESTART WITH 1;
    ALTER SEQUENCE ubicaciones_id_ubicacion_seq RESTART WITH 1;
    ALTER SEQUENCE propiedades_id_propiedad_seq RESTART WITH 1;
    ALTER SEQUENCE amenidades_id_amenidad_seq RESTART WITH 1;
    ALTER SEQUENCE reservas_id_reserva_seq RESTART WITH 1;
    ALTER SEQUENCE pagos_id_pago_seq RESTART WITH 1;
    ALTER SEQUENCE resenas_id_resena_seq RESTART WITH 1;
    ```


- Para crear un respaldo antes de limpiar:

    ```cmd
    # Desde la línea de comandos de Windows
    pg_dump -U postgres -d sistema_reservas_alojamientos -F c -f "C:\respaldo_proyecto_final.backup"

    # O solo el esquema (sin datos)
    pg_dump -U postgres -d sistema_reservas_alojamientos -s -f "C:\respaldo_esquema.sql"
    ```

<br/><br/>

## Resumen

### Lo que Has Logrado

* [ ] Diseñaste una **base de datos relacional** completa desde cero para un **sistema real de reservas**.
* [ ] Aplicaste **principios de normalización (3FN)** en un proyecto complejo.
* [ ] Implementaste **8 tablas interrelacionadas** con **constraints**, **índices** y **validaciones**.
* [ ] Insertaste un **dataset realista** con **más de 300 registros** distribuidos en todas las entidades.
* [ ] Desarrollaste **10+ consultas SQL complejas** usando **JOINs**, **agregaciones**, **CTEs** y **funciones window**.
* [ ] Creaste **3 vistas** para encapsular consultas frecuentes y facilitar el **acceso a datos**.
* [ ] Documentaste completamente el proyecto con **diagramas**, **README** y **decisiones de diseño**.
* [ ] Validaste la **integridad de los datos** y el **correcto funcionamiento** del sistema.
* [ ] Aplicaste **mejores prácticas** de **desarrollo de bases de datos relacionales**.


<br/><br/>

### Conceptos Clave Aplicados

* **Diseño de bases de datos:** Identificación de **entidades**, **atributos** y **relaciones**.
* **Normalización:** Eliminación de **redundancias** y **dependencias transitivas**.
* **Integridad referencial:** Uso de **claves foráneas** con políticas **ON DELETE** apropiadas.
* **Validación de datos:** Implementación de **constraints** **CHECK**, **UNIQUE** y **NOT NULL**.
* **Optimización:** Creación de **índices estratégicos** para mejorar el **rendimiento**.
* **Consultas avanzadas:** Uso de **JOINs múltiples**, **subconsultas**, **CTEs** y **funciones window**.
* **Vistas:** Encapsulación de **lógica compleja** para **reutilización**.
* **Documentación técnica:** Creación de **documentación profesional** para proyectos de **bases de datos**.


<br/><br/>

### Próximos Pasos

* **Profundizar en optimización:** Estudiar **planes de ejecución** y técnicas avanzadas de **tuning**.
* **Explorar procedimientos almacenados:** Implementar **lógica de negocio** en la base de datos.
* **Aprender sobre triggers:** Automatizar **validaciones** y **auditorías**.
* **Estudiar particionamiento:** Técnicas para manejar **grandes volúmenes de datos**.
* **Investigar seguridad avanzada:** **Row-Level Security (RLS)**, **roles** y **permisos granulares**.
* **Practicar replicación:** Configurar **réplicas** para **alta disponibilidad**.
* **Explorar extensiones de PostgreSQL:** **PostGIS**, **pg_stat_statements**, **pgcrypto**.
* **Desarrollar aplicaciones:** Conectar esta **base de datos** con **aplicaciones web o móviles**.


<br/><br/>

### Aplicación en el Mundo Real

Este proyecto simula un **sistema real de reservas** que podrías encontrar en empresas como:

* **Plataformas de alojamiento** (Airbnb, Booking.com, Vrbo).
* **Sistemas de reservas hoteleras**.
* **Plataformas de alquiler temporal**.
* **Sistemas de gestión de propiedades**.

Las **habilidades desarrolladas** son directamente aplicables a:

* **Desarrollo backend** de aplicaciones web.
* **Análisis de datos** y **Business Intelligence**.
* **Administración de bases de datos**.
* **Arquitectura de sistemas de información**.
* **Consultoría en bases de datos**.


<br/><br/>

## Recursos Adicionales

### Documentación Oficial

* **PostgreSQL 18 Documentation** – Documentación oficial completa
  [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)

* **PostgreSQL Tutorial** – Tutoriales paso a paso
  [https://www.postgresqltutorial.com/](https://www.postgresqltutorial.com/)

* **pgAdmin Documentation** – Guía oficial de uso de pgAdmin
  [https://www.pgadmin.org/docs/](https://www.pgadmin.org/docs/)

<br/>

### Herramientas de Diseño

* **dbdiagram.io** – Herramienta online gratuita para diagramas ER
  [https://dbdiagram.io/](https://dbdiagram.io/)

* **draw.io (diagrams.net)** – Herramienta de diagramación general
  [https://app.diagrams.net/](https://app.diagrams.net/)

* **Lucidchart** – Plataforma profesional de diagramación
  [https://www.lucidchart.com/](https://www.lucidchart.com/)

* **DBeaver** – Cliente universal de bases de datos con diseñador ER
  [https://dbeaver.io/](https://dbeaver.io/)


<br/>

### Recursos de Aprendizaje

* **SQL Zoo** – Ejercicios interactivos de SQL
  [https://sqlzoo.net/](https://sqlzoo.net/)

* **Mode Analytics – SQL Tutorial** – Tutorial completo de SQL
  [https://mode.com/sql-tutorial/](https://mode.com/sql-tutorial/)

* **Use The Index, Luke** – Guía práctica sobre índices y optimización
  [https://use-the-index-luke.com/](https://use-the-index-luke.com/)

* **PostgreSQL Exercises** – Ejercicios prácticos de PostgreSQL
  [https://pgexercises.com/](https://pgexercises.com/)


<br/>


### Comunidades y Foros

* **Stack Overflow – PostgreSQL** – Preguntas y respuestas
  [https://stackoverflow.com/questions/tagged/postgresql](https://stackoverflow.com/questions/tagged/postgresql)

* **PostgreSQL Mailing Lists** – Listas de correo oficiales
  [https://www.postgresql.org/list/](https://www.postgresql.org/list/)

* **Reddit – r/PostgreSQL** – Comunidad en Reddit
  [https://www.reddit.com/r/PostgreSQL/](https://www.reddit.com/r/PostgreSQL/)

* **PostgreSQL Discord** – Chat en tiempo real
  [https://discord.gg/postgresql](https://discord.gg/postgresql)

<br/>


### Libros Recomendados

* **PostgreSQL: Up and Running** – Regina Obe, Leo Hsu
  [https://www.oreilly.com/library/view/postgresql-up-and/9781491963401/](https://www.oreilly.com/library/view/postgresql-up-and/9781491963401/)

* **The Art of PostgreSQL** – Dimitri Fontaine
  [https://theartofpostgresql.com/](https://theartofpostgresql.com/)

* **PostgreSQL Query Optimization** – Henrietta Dombrovskaya
  [https://www.amazon.com/PostgreSQL-Query-Optimization-Performance/dp/1838640632](https://www.amazon.com/PostgreSQL-Query-Optimization-Performance/dp/1838640632)

* **Database Design for Mere Mortals** – Michael J. Hernandez
  [https://www.informit.com/store/database-design-for-mere-mortals-9780136788041](https://www.informit.com/store/database-design-for-mere-mortals-9780136788041)


<br/>

### Datasets para Práctica

* **Kaggle Datasets** – Miles de datasets para práctica
  [https://www.kaggle.com/datasets](https://www.kaggle.com/datasets)

* **PostgreSQL Sample Databases** – Bases de datos de ejemplo
  [https://wiki.postgresql.org/wiki/Sample_Databases](https://wiki.postgresql.org/wiki/Sample_Databases)

* **Mockaroo** – Generador de datos de prueba realistas
  [https://www.mockaroo.com/](https://www.mockaroo.com/)


<br/><br/> 

---

¡Felicitaciones por completar el proyecto final del curso!
Has demostrado dominio completo de PostgreSQL y diseño de bases de datos relacionales. Este proyecto es una excelente pieza para tu portafolio profesional.

---