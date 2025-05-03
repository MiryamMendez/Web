-- Esquema de Base de Datos para VITALSOFT
-- Este script creará las tablas necesarias para el sistema médico

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS vitalsoft;
USE vitalsoft;

-- Tabla de Usuarios (común para todos los tipos de usuarios)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('paciente', 'medico', 'empleado') NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Pacientes
CREATE TABLE IF NOT EXISTS pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_nacimiento DATE,
    genero ENUM('M', 'F', 'Otro'),
    telefono VARCHAR(15),
    direccion TEXT,
    seguro_medico VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabla de Médicos
CREATE TABLE IF NOT EXISTS medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    numero_licencia VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabla de Empleados
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabla de Horarios de Médicos
CREATE TABLE IF NOT EXISTS horarios_medicos (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_medico INT NOT NULL,
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

-- Tabla de Citas
CREATE TABLE IF NOT EXISTS citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado ENUM('programada', 'completada', 'cancelada') DEFAULT 'programada',
    tipo_cita ENUM('presencial', 'virtual') DEFAULT 'presencial',
    motivo TEXT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

-- Tabla de Historiales Médicos
CREATE TABLE IF NOT EXISTS historiales_medicos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente)
);

-- Tabla de Consultas (parte del historial)
CREATE TABLE IF NOT EXISTS consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_historial INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_consulta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    FOREIGN KEY (id_historial) REFERENCES historiales_medicos(id_historial),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

-- Tabla de Recetas
CREATE TABLE IF NOT EXISTS recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta)
);

-- Tabla de Medicamentos en Recetas
CREATE TABLE IF NOT EXISTS medicamentos_receta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    nombre_medicamento VARCHAR(100) NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion VARCHAR(50) NOT NULL,
    instrucciones TEXT,
    FOREIGN KEY (id_receta) REFERENCES recetas(id_receta)
);

-- Tabla de Mensajes
CREATE TABLE IF NOT EXISTS mensajes (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    emisor_id INT NOT NULL,
    receptor_id INT NOT NULL,
    asunto VARCHAR(100),
    contenido TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (emisor_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (receptor_id) REFERENCES usuarios(id_usuario)
);

-- Tabla de Documentos Médicos
CREATE TABLE IF NOT EXISTS documentos_medicos (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    tipo_documento VARCHAR(50), -- Por ejemplo: "resultado_laboratorio", "radiografia", etc.
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ruta_archivo VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente)
);

-- Insertar datos de prueba para desarrollo
-- Un usuario empleado (admin)
INSERT INTO usuarios (nombre, apellido, correo, contrasena, tipo_usuario) 
VALUES ('Admin', 'Sistema', 'admin@vitalsoft.com', 'admin123', 'empleado');

-- Insertar en tabla empleados
INSERT INTO empleados (id_usuario, cargo, telefono) 
VALUES (1, 'Administrador del Sistema', '123456789'); ADD
