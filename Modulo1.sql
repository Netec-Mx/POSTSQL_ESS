   -- Crear tabla de prueba
   CREATE TABLE prueba_instalacion (
       id SERIAL PRIMARY KEY,
       nombre VARCHAR(100),
       fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );

   -- Insertar datos de prueba
   INSERT INTO prueba_instalacion (nombre)
   VALUES ('PostgreSQL 18 instalado correctamente');

   -- Consultar datos
   SELECT * FROM prueba_instalacion;