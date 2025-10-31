-- =========================================================
-- BASE DE DATOS
-- =========================================================
-- OPCIONAL: DROP DATABASE IF EXISTS reserva;
CREATE DATABASE IF NOT EXISTS reserva
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE reserva;

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- =========================================================
-- SEGURIDAD / ACCESO
-- =========================================================
CREATE TABLE usuario (
  id_usuario       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  email            VARCHAR(120) NOT NULL,
  password_hash    VARCHAR(255) NOT NULL,     -- Argon2id
  nombres          VARCHAR(100) NOT NULL,
  apellidos        VARCHAR(100) NOT NULL,
  telefono         VARCHAR(20),
  fecha_nacimiento DATE,
  dni              VARCHAR(20),
  foto_url         VARCHAR(255),
  -- CAMPOS NUEVOS PARA FOTO EN BD
  foto_blob        LONGBLOB NULL,
  foto_mime        VARCHAR(100) NULL,
  foto_actualizado DATETIME NULL,
  -- FIN CAMBIOS
  estado           ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  fecha_creacion   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuario_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol (
  id_rol      INT NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(30) NOT NULL,          -- PACIENTE | MEDICO | ADMIN
  descripcion VARCHAR(200),
  PRIMARY KEY (id_rol),
  UNIQUE KEY uq_rol_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuario_rol (
  id_usuario  BIGINT UNSIGNED NOT NULL,
  id_rol      INT NOT NULL,
  asignado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_rol),
  KEY idx_usuario_rol_usuario_rol (id_usuario, id_rol),
  CONSTRAINT fk_usuario_rol_usuario  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_usuario_rol_rol      FOREIGN KEY (id_rol)     REFERENCES rol(id_rol)         ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE auth_login_intento (
  id_intento  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario  BIGINT UNSIGNED NULL,
  ip          VARCHAR(64),
  user_agent  VARCHAR(255),
  exitoso     TINYINT(1) NOT NULL DEFAULT 0,
  timestamp   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_intento),
  KEY idx_intento_usuario_time (id_usuario, timestamp),
  CONSTRAINT fk_login_intento_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE auth_password_reset (
  id_reset   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT UNSIGNED NOT NULL,
  token      VARCHAR(120) NOT NULL,
  expira_en  DATETIME NOT NULL,
  usado      TINYINT(1) NOT NULL DEFAULT 0,
  creado_en  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_reset),
  UNIQUE KEY uq_reset_token (token),
  KEY idx_reset_usuario (id_usuario, creado_en),
  CONSTRAINT fk_reset_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE preferencia_notificacion (
  id_pref     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario  BIGINT UNSIGNED NOT NULL,
  canal_app   TINYINT(1) NOT NULL DEFAULT 1,
  canal_email TINYINT(1) NOT NULL DEFAULT 1,
  quiet_hours_json TEXT,
  actualizado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_pref),
  UNIQUE KEY uq_pref_usuario (id_usuario),
  CONSTRAINT fk_pref_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- CATÁLOGOS
-- =========================================================
CREATE TABLE especialidad (
  id_especialidad BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(120) NOT NULL,
  descripcion VARCHAR(200),
  activo      TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_especialidad),
  UNIQUE KEY uq_especialidad_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- PERFILES
-- =========================================================
CREATE TABLE medico (
  id_medico            BIGINT UNSIGNED NOT NULL,   -- = usuario.id_usuario
  consultorio          VARCHAR(80),
  duracion_turno_min   INT NOT NULL DEFAULT 20,
  valoracion_promedio  DECIMAL(2,1) DEFAULT NULL,
  actualizado_en       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_medico),
  CONSTRAINT fk_medico_usuario FOREIGN KEY (id_medico) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE medico_especialidad (
  id_medico       BIGINT UNSIGNED NOT NULL,
  id_especialidad BIGINT UNSIGNED NOT NULL,
  principal       TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id_medico, id_especialidad),
  KEY idx_me_especialidad (id_especialidad),
  CONSTRAINT fk_me_medico       FOREIGN KEY (id_medico)       REFERENCES medico(id_medico)                 ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_me_especialidad FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad)     ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE paciente (
  id_paciente          BIGINT UNSIGNED NOT NULL,   -- = usuario.id_usuario
  nro_historia         VARCHAR(30),
  fecha_nacimiento     DATE,
  sexo                 ENUM('M','F','X'),
  contacto_emergencia  VARCHAR(120),
  otros_datos_json     TEXT,
  actualizado_en       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_paciente),
  CONSTRAINT fk_paciente_usuario FOREIGN KEY (id_paciente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE favorito (
  id_paciente   BIGINT UNSIGNED NOT NULL,
  id_medico     BIGINT UNSIGNED NOT NULL,
  fecha_agregado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_paciente, id_medico),
  KEY idx_fav_paciente_medico (id_paciente, id_medico),
  CONSTRAINT fk_fav_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_fav_medico   FOREIGN KEY (id_medico)   REFERENCES medico(id_medico)     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- AGENDA
-- =========================================================
CREATE TABLE medico_horario (
  id_horario    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_medico     BIGINT UNSIGNED NOT NULL,
  dia_semana    TINYINT NOT NULL,            -- 0=Dom ... 6=Sab
  hora_inicio   TIME NOT NULL,
  hora_fin      TIME NOT NULL,
  slot_minutos  INT NOT NULL,
  vigente_desde DATE NULL,
  vigente_hasta DATE NULL,
  PRIMARY KEY (id_horario),
  KEY idx_horario_medico_dia (id_medico, dia_semana),
  CONSTRAINT fk_horario_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE medico_bloqueo (
  id_bloqueo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_medico  BIGINT UNSIGNED NOT NULL,
  inicio     DATETIME NOT NULL,
  fin        DATETIME NOT NULL,
  motivo     VARCHAR(180),
  PRIMARY KEY (id_bloqueo),
  KEY idx_bloqueo_medico_rango (id_medico, inicio, fin),
  CONSTRAINT fk_bloqueo_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- CITAS / NEGOCIACIÓN
-- =========================================================
CREATE TABLE cita (
  id_cita        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_paciente    BIGINT UNSIGNED NOT NULL,
  id_medico      BIGINT UNSIGNED NOT NULL,
  fecha_hora     DATETIME NULL,                                 -- NULL durante negociación
  propuesta_fecha_hora DATETIME NULL,                           -- NUEVO: última fecha/hora propuesta
  ultima_propuesta_por ENUM('PACIENTE','MEDICO') NULL,          -- NUEVO: quién hizo la última propuesta
  canal          ENUM('PRESENCIAL','TELECONSULTA') NOT NULL DEFAULT 'PRESENCIAL',
  confirmada_fecha_hora DATETIME NULL,                          -- fecha/hora exacta de confirmación
  motivo         TEXT,
  estado         ENUM('SOLICITADA','PROPUESTA','EN_NEGOCIACION','CONFIRMADA','CANCELADA','ATENDIDA','NO_ASISTIO') NOT NULL DEFAULT 'SOLICITADA',
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_cita),
  UNIQUE KEY uq_cita_slot (id_medico, fecha_hora),              -- evita doble booking (permite múltiples NULL)
  KEY idx_cita_paciente_estado (id_paciente, estado),
  KEY idx_cita_medico_estado   (id_medico, estado),
  CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_medico   FOREIGN KEY (id_medico)   REFERENCES medico(id_medico)     ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cita_propuesta (
  id_propuesta          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cita               BIGINT UNSIGNED NOT NULL,
  propuesto_por         ENUM('PACIENTE','MEDICO') NOT NULL,
  fecha_hora_propuesta  DATETIME NOT NULL,
  comentario            VARCHAR(255),
  vigente               TINYINT(1) NOT NULL DEFAULT 1,
  timestamp             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_propuesta),
  KEY idx_propuesta_cita_vigente (id_cita, vigente),
  CONSTRAINT fk_propuesta_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cita_mensaje (
  id_mensaje  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cita     BIGINT UNSIGNED NOT NULL,
  emisor      ENUM('PACIENTE','MEDICO','ADMIN') NOT NULL,
  mensaje     TEXT NOT NULL,
  timestamp   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_mensaje),
  KEY idx_mensaje_cita_time (id_cita, timestamp),
  CONSTRAINT fk_mensaje_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cita_historial (
  id_historial BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cita      BIGINT UNSIGNED NOT NULL,
  antes        VARCHAR(32),
  despues      VARCHAR(32),
  actor        ENUM('PACIENTE','MEDICO','ADMIN') NOT NULL,
  comentario   VARCHAR(255),
  timestamp    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_historial),
  KEY idx_hist_cita_time (id_cita, timestamp),
  CONSTRAINT fk_historial_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE valoracion (
  id_valoracion BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_cita       BIGINT UNSIGNED NOT NULL,
  puntuacion    TINYINT NOT NULL,
  comentario    TEXT,
  fecha         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_valoracion),
  UNIQUE KEY uq_valoracion_cita (id_cita),                       -- una valoración por cita
  CONSTRAINT chk_valoracion_puntuacion CHECK (puntuacion BETWEEN 1 AND 5),
  CONSTRAINT fk_valoracion_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- NOTIFICACIONES
-- =========================================================
CREATE TABLE notificacion (
  id_notificacion BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_destinatario BIGINT UNSIGNED NOT NULL,                      -- FK a usuario
  tipo            VARCHAR(40) NOT NULL,                          -- PROPUESTA, CONFIRMADA, CANCELADA, RECORDATORIO, ...
  mensaje         TEXT,
  leida           TINYINT(1) NOT NULL DEFAULT 0,
  fecha_envio     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  metadata_json   TEXT,
  PRIMARY KEY (id_notificacion),
  KEY idx_notif_dest_estado_fecha (id_destinatario, leida, fecha_envio),
  CONSTRAINT fk_notif_usuario FOREIGN KEY (id_destinatario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- (OPCIONAL) SEMILLAS BÁSICAS
-- =========================================================
INSERT INTO rol (nombre, descripcion) VALUES
  ('ADMIN','Administrador del sistema'),
  ('MEDICO','Profesional de la salud'),
  ('PACIENTE','Usuario paciente')
ON DUPLICATE KEY UPDATE descripcion=VALUES(descripcion);

-- =========================================================
-- (OPCIONAL) MIGRACIÓN PARA BD EXISTENTE
-- Ejecuta esto SOLO si ya tenías la tabla 'cita' y quieres
-- agregar las nuevas columnas sin recrear la tabla.
-- Si tu servidor no soporta "IF NOT EXISTS", quítalo.
-- =========================================================
-- ALTER TABLE cita
--   ADD COLUMN IF NOT EXISTS propuesta_fecha_hora DATETIME NULL AFTER fecha_hora,
--   ADD COLUMN IF NOT EXISTS ultima_propuesta_por ENUM('PACIENTE','MEDICO') NULL AFTER propuesta_fecha_hora,
--   ADD COLUMN IF NOT EXISTS confirmada_fecha_hora DATETIME NULL AFTER canal;
