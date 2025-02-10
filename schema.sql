-- Initial attempt

CREATE TABLE ESTUDIANTE (
    id_estudiante SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE
);

CREATE TABLE CURSO (
    id_curso SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    creditos INTEGER
);

CREATE TABLE PROFESOR (
    id_profesor SERIAL PRIMARY KEY,
    nombre_profesor VARCHAR(100) NOT NULL,
    departamento VARCHAR(100)
);

CREATE TABLE INSCRIPCION (
    id_estudiante INTEGER REFERENCES ESTUDIANTE(id_estudiante),
    id_curso INTEGER REFERENCES CURSO(id_curso),
    fecha_inscripcion DATE,
    PRIMARY KEY (id_estudiante, id_curso)
);

CREATE TABLE ENSEÑA (
    id_profesor INTEGER REFERENCES PROFESOR(id_profesor),
    id_curso INTEGER REFERENCES CURSO(id_curso),
    PRIMARY KEY (id_profesor, id_curso)
);
