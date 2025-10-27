/* ==========================================================
   BASE DE DATOS
   ========================================================== */
DROP DATABASE IF EXISTS reserva;
CREATE DATABASE reserva
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE reserva;

SET NAMES utf8mb4;
SET time_zone = '+00:00';

/* ==========================================================
   SEGURIDAD / ACCESOS
   ========================================================== */
CREATE TABLE usuario (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  email           VARCHAR(120) NOT NULL,
  password_hash   VARCHAR(255) NOT NULL,
  nombres         VARCHAR(120) NOT NULL,
  apellidos       VARCHAR(120) NOT NULL,
  telefono        VARCHAR(30),
  activo          TINYINT(1) NOT NULL DEFAULT 1,
  creado_en       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuario_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE rol (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre        VARCHAR(40)  NOT NULL,
  descripcion   VARCHAR(200),
  PRIMARY KEY (id),
  UNIQUE KEY uq_rol_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE usuario_rol (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario_id    BIGINT UNSIGNED NOT NULL,
  rol_id        BIGINT UNSIGNED NOT NULL,
  asignado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuario_rol (usuario_id, rol_id),
  KEY idx_usuario_rol_usuario (usuario_id),
  KEY idx_usuario_rol_rol (rol_id),
  CONSTRAINT fk_usuario_rol_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_usuario_rol_rol
    FOREIGN KEY (rol_id) REFERENCES rol(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/* ==========================================================
   PERFILES
   ========================================================== */
CREATE TABLE paciente (
  id_usuario           BIGINT UNSIGNED NOT NULL,
  nro_historia         VARCHAR(30),
  fecha_nacimiento     DATE,
  sexo                 VARCHAR(10),
  doc_identidad        VARCHAR(20),
  contacto_emergencia  VARCHAR(120),
  PRIMARY KEY (id_usuario),
  CONSTRAINT fk_paciente_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE especialidad (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(80) NOT NULL,
  descripcion  VARCHAR(200),
  PRIMARY KEY (id),
  UNIQUE KEY uq_especialidad_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE consultorio (
  id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(60) NOT NULL,
  piso   VARCHAR(20),
  tipo   ENUM('PRESENCIAL','VIRTUAL') NOT NULL DEFAULT 'PRESENCIAL',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE medico (
  id_usuario         BIGINT UNSIGNED NOT NULL,
  cmp                VARCHAR(20) NOT NULL,
  especialidad_id    BIGINT UNSIGNED NOT NULL,
  consultorio_id     BIGINT UNSIGNED NOT NULL,
  duracion_turno_min INT,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_medico_cmp (cmp),
  KEY idx_medico_especialidad (especialidad_id),
  KEY idx_medico_consultorio (consultorio_id),
  CONSTRAINT fk_medico_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_medico_especialidad
    FOREIGN KEY (especialidad_id) REFERENCES especialidad(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_medico_consultorio
    FOREIGN KEY (consultorio_id) REFERENCES consultorio(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/* ==========================================================
   AGENDA
   ========================================================== */
CREATE TABLE horario_medico (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  medico_id     BIGINT UNSIGNED NOT NULL,
  dia_semana    TINYINT UNSIGNED NOT NULL,  /* 1=Lun ... 7=Dom */
  hora_inicio   TIME NOT NULL,
  hora_fin      TIME NOT NULL,
  duracion_min  INT,
  PRIMARY KEY (id),
  KEY idx_horario_medico (medico_id, dia_semana),
  CONSTRAINT fk_horario_medico_medico
    FOREIGN KEY (medico_id) REFERENCES medico(id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE bloqueo_agenda (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  medico_id  BIGINT UNSIGNED NOT NULL,
  inicio     DATETIME NOT NULL,
  fin        DATETIME NOT NULL,
  motivo     VARCHAR(160),
  PRIMARY KEY (id),
  KEY idx_bloqueo_medico_tiempo (medico_id, inicio, fin),
  CONSTRAINT fk_bloqueo_medico
    FOREIGN KEY (medico_id) REFERENCES medico(id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE feriado (
  id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  fecha  DATE NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_feriado_fecha (fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/* ==========================================================
   CITAS
   ========================================================== */
CREATE TABLE cita (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  paciente_id     BIGINT UNSIGNED NOT NULL,
  medico_id       BIGINT UNSIGNED NOT NULL,
  consultorio_id  BIGINT UNSIGNED NOT NULL,
  fecha           DATE NOT NULL,
  hora_inicio     TIME NOT NULL,
  hora_fin        TIME NOT NULL,
  estado          ENUM('RESERVADA','CANCELADA','ATENDIDA','NO_ASISTIO') NOT NULL DEFAULT 'RESERVADA',
  motivo          VARCHAR(200),
  canal           ENUM('PRESENCIAL','TELECONSULTA') NOT NULL DEFAULT 'PRESENCIAL',
  creado_en       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_slot_unico (medico_id, fecha, hora_inicio),
  KEY idx_cita_paciente_fecha (paciente_id, fecha),
  KEY idx_cita_medico_fecha (medico_id, fecha),
  CONSTRAINT fk_cita_paciente
    FOREIGN KEY (paciente_id) REFERENCES paciente(id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_medico
    FOREIGN KEY (medico_id) REFERENCES medico(id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_consultorio
    FOREIGN KEY (consultorio_id) REFERENCES consultorio(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE cita_historial (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  cita_id          BIGINT UNSIGNED NOT NULL,
  estado_anterior  ENUM('RESERVADA','CANCELADA','ATENDIDA','NO_ASISTIO'),
  estado_nuevo     ENUM('RESERVADA','CANCELADA','ATENDIDA','NO_ASISTIO') NOT NULL,
  cambiado_por     BIGINT UNSIGNED,  /* usuario.id que hizo el cambio */
  cambiado_en      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  nota             VARCHAR(200),
  PRIMARY KEY (id),
  KEY idx_hist_cita (cita_id, cambiado_en),
  KEY idx_hist_cambiado_por (cambiado_por),
  CONSTRAINT fk_hist_cita
    FOREIGN KEY (cita_id) REFERENCES cita(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_hist_usuario
    FOREIGN KEY (cambiado_por) REFERENCES usuario(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/* ==========================================================
   NOTIFICACIONES
   ========================================================== */
CREATE TABLE notificacion (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario_id    BIGINT UNSIGNED NOT NULL,
  tipo          ENUM('CITA_RESERVADA','CITA_CANCELADA','CITA_REPROGRAMADA') NOT NULL,
  canal         ENUM('INAPP','EMAIL') NOT NULL,
  payload_json  JSON NULL,
  leida         TINYINT(1) NOT NULL DEFAULT 0,
  enviada_en    DATETIME NULL,
  error_envio   VARCHAR(200) NULL,
  PRIMARY KEY (id),
  KEY idx_notif_usuario_leida (usuario_id, leida, enviada_en),
  CONSTRAINT fk_notif_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE preferencia_notificacion (
  usuario_id        BIGINT UNSIGNED NOT NULL,
  email_habilitado  TINYINT(1) NOT NULL DEFAULT 1,
  inapp_habilitado  TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (usuario_id),
  CONSTRAINT fk_pref_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/* ==========================================================
   ÍNDICES EXTRA (por performance de consultas típicas)
   ========================================================== */
-- Citas del día por médico
CREATE INDEX idx_cita_medico_fecha_hora ON cita (medico_id, fecha, hora_inicio);

-- Horarios del médico por día de semana
CREATE INDEX idx_horario_medico_dia ON horario_medico (dia_semana);

/* ==========================================================
   (OPCIONAL) DATOS SEMILLA BÁSICOS
   Descomenta si deseas cargar algo inicial.
   ========================================================== */
/*
INSERT INTO rol (nombre, descripcion) VALUES
 ('ADMIN','Administrador del sistema'),
 ('MEDICO','Médico'),
 ('PACIENTE','Paciente');

INSERT INTO especialidad (nombre, descripcion) VALUES
 ('Medicina General',''),
 ('Cardiología',''),
 ('Pediatría','');

INSERT INTO consultorio (nombre, piso, tipo) VALUES
 ('Sala 101','1','PRESENCIAL'),
 ('Teleconsulta','-','VIRTUAL');
*/
