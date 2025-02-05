-- Función de prueba para la inserción de un estudiante
CREATE OR REPLACE FUNCTION test_insertar_estudiante()
RETURNS VOID AS $$
BEGIN
    -- Insertar un estudiante
    INSERT INTO ESTUDIANTE (nombre, apellido, fecha_nacimiento) VALUES ('Ana', 'López', '2002-03-15');

    -- Verificar que se insertó correctamente
    IF NOT EXISTS (SELECT 1 FROM ESTUDIANTE WHERE nombre = 'Ana' AND apellido = 'López') THEN
        RAISE EXCEPTION 'Error: No se insertó el estudiante.';
    END IF;

    -- Eliminar el estudiante para no afectar otras pruebas
    DELETE FROM ESTUDIANTE WHERE nombre = 'Ana' AND apellido = 'López';
END;
$$ LANGUAGE plpgsql;

-- Función de prueba para la restricción NOT NULL en el nombre del curso
CREATE OR REPLACE FUNCTION test_not_null_nombre_curso()
RETURNS VOID AS $$
BEGIN
    -- Intentar insertar un curso sin nombre
    BEGIN
        INSERT INTO CURSO (nombre_curso, creditos) VALUES (NULL, 4);
        RAISE EXCEPTION 'Error: Se permitió insertar un curso sin nombre.';
    EXCEPTION WHEN unique_violation THEN
        -- Se espera una excepción de violación de restricción única
    END;
END;
$$ LANGUAGE plpgsql;

-- Función de prueba para la consulta de estudiantes inscritos en un curso
CREATE OR REPLACE FUNCTION test_consulta_estudiantes_por_curso()
RETURNS VOID AS $$
DECLARE
    cantidad_esperada INTEGER := 2; -- Cantidad de estudiantes esperados
    cantidad_real INTEGER;
BEGIN
    -- Obtener la cantidad de estudiantes inscritos en el curso 'Cálculo I'
    SELECT COUNT(*) INTO cantidad_real
    FROM ESTUDIANTE e
    JOIN INSCRIPCION i ON e.id_estudiante = i.id_estudiante
    JOIN CURSO c ON i.id_curso = c.id_curso
    WHERE c.nombre_curso = 'Cálculo I';

    -- Verificar que la cantidad es la esperada
    IF cantidad_real != cantidad_esperada THEN
        RAISE EXCEPTION 'Error: La consulta no devolvió la cantidad esperada de estudiantes.';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Tabla para almacenar los resultados de las pruebas
CREATE TABLE IF NOT EXISTS pruebas_unitarias (
    nombre_prueba VARCHAR(255),
    resultado VARCHAR(20)
);

-- Función para ejecutar todas las pruebas y registrar los resultados
CREATE OR REPLACE FUNCTION ejecutar_pruebas()
RETURNS VOID AS $$
DECLARE
    resultado_prueba VARCHAR(20);
BEGIN
    -- Ejecutar y registrar la prueba de inserción de estudiante
    BEGIN
        PERFORM test_insertar_estudiante();
        resultado_prueba := 'Éxito';
    EXCEPTION WHEN OTHERS THEN
        resultado_prueba := 'Fallo';
    END;
    INSERT INTO pruebas_unitarias (nombre_prueba, resultado) VALUES ('Inserción de estudiante', resultado_prueba);

    -- Ejecutar y registrar la prueba de restricción NOT NULL en nombre del curso
    BEGIN
        PERFORM test_not_null_nombre_curso();
        resultado_prueba := 'Éxito';
    EXCEPTION WHEN OTHERS THEN
        resultado_prueba := 'Fallo';
    END;
    INSERT INTO pruebas_unitarias (nombre_prueba, resultado) VALUES ('Restricción NOT NULL nombre curso', resultado_prueba);

    -- Ejecutar y registrar la prueba de consulta de estudiantes por curso
    BEGIN
        PERFORM test_consulta_estudiantes_por_curso();
        resultado_prueba := 'Éxito';
    EXCEPTION WHEN OTHERS THEN
        resultado_prueba := 'Fallo';
    END;
    INSERT INTO pruebas_unitarias (nombre_prueba, resultado) VALUES ('Consulta estudiantes por curso', resultado_prueba);
END;
$$ LANGUAGE plpgsql;

-- Ejecutar todas las pruebas
SELECT ejecutar_pruebas();