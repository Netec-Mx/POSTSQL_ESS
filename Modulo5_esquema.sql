/* =========================================================
   ESQUEMA BASE PARA PRÁCTICA 5.1
   Base de datos: curso_db
   PostgreSQL 18
   ========================================================= */

-- =========================
-- 1. TABLA: estudiantes
-- =========================
CREATE TABLE IF NOT EXISTS estudiantes (
    estudiante_id     SERIAL PRIMARY KEY,
    nombre             VARCHAR(100) NOT NULL,
    apellido           VARCHAR(100) NOT NULL,
    email              VARCHAR(150) NOT NULL UNIQUE,
    fecha_inscripcion  DATE NOT NULL,
    observaciones      VARCHAR(200),
    activo             BOOLEAN DEFAULT TRUE
);

-- =========================
-- 2. TABLA: cursos
-- =========================
CREATE TABLE IF NOT EXISTS cursos (
    curso_id        SERIAL PRIMARY KEY,
    nombre_curso    VARCHAR(150) NOT NULL,
    precio          NUMERIC(10,2) NOT NULL,
    total_inscritos INTEGER DEFAULT 0
);

-- =========================
-- 3. TABLA: inscripciones
-- =========================
CREATE TABLE IF NOT EXISTS inscripciones (
    inscripcion_id     SERIAL PRIMARY KEY,
    estudiante_id      INTEGER NOT NULL,
    curso_id           INTEGER NOT NULL,
    fecha_inscripcion  DATE NOT NULL,

    CONSTRAINT fk_inscripciones_estudiante
        FOREIGN KEY (estudiante_id)
        REFERENCES estudiantes(estudiante_id),

    CONSTRAINT fk_inscripciones_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos(curso_id)
);

-- =========================
-- 4. TABLA DE RESPALDO
-- (se crea durante la práctica)
-- =========================
-- CREATE TABLE estudiantes_backup AS
-- SELECT * FROM estudiantes;

-- =========================
-- 5. TABLAS DE PRUEBA (CASCADE)
-- =========================
CREATE TABLE IF NOT EXISTS categorias_prueba (
    categoria_id     SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS productos_prueba (
    producto_id     SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria_id    INTEGER,

    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categorias_prueba(categoria_id)
        ON DELETE CASCADE
);

-- CARGA

INSERT INTO estudiantes (nombre, apellido, email, fecha_inscripcion)
VALUES
('Juan',   'Pérez',     'juan.perez@email.com',     '2024-01-15'),
('María',  'García',    'maria.garcia@email.com',   '2024-01-16'),
('Carlos', 'López',     'carlos.lopez@email.com',   '2024-01-17'),
('Ana',    'Martínez',  'ana.martinez@email.com',   '2024-01-18'),
('Pedro',  'Sánchez',   'pedro.sanchez@email.com',  '2024-01-19'),
('Lucía',  'Ramírez',   'lucia.ramirez@email.com',  '2024-01-21'),
('Jorge',  'Hernández', 'jorge.hernandez@email.com','2024-01-22'),
('Sofía',  'Torres',    'sofia.torres@email.com',   '2024-01-23'),
('Diego',  'Flores',    'diego.flores@email.com',   '2024-01-24'),
('Laura',  'Gómez',     'laura.gomez@email.com',    '2024-01-25'),
('Miguel', 'Rojas',     'miguel.rojas@email.com',   '2024-01-26'),
('Elena',  'Vargas',    'elena.vargas@email.com',   '2024-01-27'),
('Raúl',   'Castillo',  'raul.castillo@email.com', '2024-01-28'),
('Paola',  'Navarro',   'paola.navarro@email.com',  '2024-01-29'),
('Andrés', 'Mendoza',   'andres.mendoza@email.com', '2024-01-30');



INSERT INTO cursos (nombre_curso, precio)
VALUES
('Bases de Datos Avanzadas', 150.00),
('Programación en Python', 120.00),
('Desarrollo Web Full Stack', 200.00),
('Introducción a SQL', 80.00),
('Fundamentos de Linux', 90.00);


INSERT INTO inscripciones (estudiante_id, curso_id, fecha_inscripcion)
VALUES
-- Curso 1: Bases de Datos Avanzadas (8)
(1, 1, '2024-02-01'),
(2, 1, '2024-02-01'),
(3, 1, '2024-02-02'),
(4, 1, '2024-02-02'),
(5, 1, '2024-02-03'),
(6, 1, '2024-02-03'),
(7, 1, '2024-02-04'),
(8, 1, '2024-02-04'),

-- Curso 2: Programación en Python (6)
(1, 2, '2024-02-05'),
(2, 2, '2024-02-05'),
(3, 2, '2024-02-06'),
(4, 2, '2024-02-06'),
(5, 2, '2024-02-07'),
(6, 2, '2024-02-07'),

-- Curso 3: Desarrollo Web Full Stack (5)
(9, 3, '2024-02-08'),
(10, 3, '2024-02-08'),
(11, 3, '2024-02-09'),
(12, 3, '2024-02-09'),
(13, 3, '2024-02-10');


SELECT COUNT(*) FROM estudiantes;
-- Debe retornar: 15


SELECT curso_id, COUNT(*) 
FROM inscripciones
GROUP BY curso_id
ORDER BY curso_id;





