CREATE TABLE estudiante (
  id_estudiante SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL
);

CREATE TABLE curso (
  id_curso SERIAL PRIMARY KEY,
  nombre_curso VARCHAR(50) NOT NULL,
  creditos INTEGER NOT NULL
);

CREATE TABLE profesor (
  id_profesor SERIAL PRIMARY KEY,
  nombre_profesor VARCHAR(50) NOT NULL,
  departamento VARCHAR(50) NOT NULL
);

CREATE TABLE inscripcion (
  id_inscripcion SERIAL PRIMARY KEY,
  id_estudiante INT REFERENCES estudiante(id_estudiante) NOT NULL,
  id_curso INT REFERENCES curso(id_curso) NOT NULL,
  fecha_inscripcion DATE NOT NULL
);

CREATE TABLE enseña (
  id_enseña SERIAL PRIMARY KEY,
  id_profesor INT NOT NULL,
  id_curso INT NOT NULL
);

INSERT INTO estudiante (nombre, apellido, fecha_nacimiento) VALUES
('Juan', 'Pérez', '2000-05-10'),
('María', 'González', '2001-02-20'),
('Carlos', 'López', '1999-11-15');

INSERT INTO curso (nombre_curso, creditos) VALUES
('Introducción a la programación', 4),
('Cálculo I', 5),
('Física General', 4);

INSERT INTO profesor (nombre_profesor, departamento) VALUES
('Ana Rodríguez', 'Ciencias de la Computación'),
('Luis Sánchez', 'Matemáticas'),
('Sofía Martínez', 'Física');

INSERT INTO inscripcion (id_estudiante, id_curso, fecha_inscripcion) VALUES
(1, 1, '2023-08-20'),
(2, 2, '2023-08-20'),
(3, 3, '2023-08-20');

INSERT INTO enseña (id_profesor, id_curso) VALUES
(1, 1),
(2, 2),
(3, 3);

SELECT * FROM  estudiante;
SELECT * FROM  curso;
SELECT * FROM  profesor;
SELECT * FROM  inscripcion;
SELECT * FROM  enseña;
