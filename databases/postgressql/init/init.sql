-- Crear tabla de prueba
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    puesto VARCHAR(50),
    salario DECIMAL(10,2)
);

-- Insertar registros de prueba
INSERT INTO empleados (nombre, puesto, salario) VALUES
('Ana Torres', 'Ingeniera', 4500.00),
('Luis Pérez', 'Analista', 3800.00),
('María Gómez', 'Gerente', 6000.00);
