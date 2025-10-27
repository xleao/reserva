🩺 CitaSys — Plataforma de Reservas Médicas (README)












Plataforma minimalista para agendar citas médicas con negociación de horarios entre paciente y médico, panel administrativo, exportaciones a Excel y seguridad robusta (Argon2id, CSRF, rate limiting).

📚 Tabla de contenido

🚀 Vista general

🔐 Login & Seguridad

🧭 Rutas pre-login

✅ Requerimientos funcionales

🧩 Requerimientos no funcionales

👤 Actores y casos de uso

🔄 Flujos clave (Mermaid)

🗄️ Diseño lógico de BD (19 tablas)

⚙️ Endpoints sugeridos

📤 Exportaciones Excel

⚡ Índices & reglas de rendimiento

🚀 Vista general

Pacientes: buscan médicos por especialidad/nombre/⭐, solicitan cita, negocian propuestas, gestionan “Mis Citas”, favoritos y notificaciones.

Médicos: agenda tipo calendario, proponen horarios, confirman/reprograman/cancelan, marcan atención y exportan historial.

Admin: dashboard con métricas, CRUD de usuarios/especialidades, gestión de citas y notificaciones, exportaciones con filtros.

🔐 Login & Seguridad

Hash de contraseñas: Argon2id (no BCrypt).
Parámetros recomendados:

saltLen=16
hashLen=32
parallelism=2
memory=65536   # 64 MB
iterations=3


Opcional pepper en variable de entorno.

CSRF activado + cookies de sesión SameSite=Lax/Strict + HttpOnly.

Rate limiting: bloqueo temporal por usuario/IP tras N fallos (registro en auth_login_intento).

Password reset: tokens firmados con expiración, un solo uso (auth_password_reset).

Redirección post-login por rol:

PACIENTE → /paciente/inicio

MEDICO → /medico/inicio

ADMIN → /admin/inicio

🧭 Rutas pre-login

/ (Landing mínima): logo, texto breve, botón Iniciar sesión → /auth/login

/auth/login: email + contraseña, “Recordarme”, “¿Olvidaste tu contraseña?” → /auth/recuperar

/auth/recuperar: ingresa email → envío de token con expiración

/auth/restablecer?token=...: nueva contraseña (y confirmación)

Endpoints de auth

POST /api/auth/login
POST /api/auth/logout
POST /api/auth/recuperar
POST /api/auth/restablecer
GET  /api/auth/me

✅ Requerimientos funcionales
👩‍⚕️ Paciente

Inicio con saludo, guía, CTA Reservar cita y carrusel de médicos (foto, especialidad, ⭐1–5).

Buscar médicos por nombre, especialidad o rating.

Ver perfil del médico (foto, CMP, consultorio, especialidad, reseñas).

Solicitar cita: motivo, fecha/rango preferido, canal (presencial/teleconsulta).

Aceptar/Rechazar propuesta del médico; negociación con mensajes.

Mis Citas por tabs: Pendientes, En negociación, Confirmadas, Historial (canceladas/atendidas/no asistió).

Cancelar antes de confirmar; reprogramar (pre-llenado).

Notificaciones (propuestas, confirmaciones, recordatorios).

Favoritos (marcar/quitar y solicitar desde ahí).

Perfil y preferencias de notificación (app/correo).

👨‍⚕️ Médico

Inicio con KPIs + “Citas de hoy”.

Agenda calendario: confirmadas (bloquean), pendientes/propuestas resaltadas.

Proponer fecha/hora, responder solicitudes, confirmar/reprogramar/cancelar.

Marcar ATENDIDA / NO_ASISTIÓ.

Exportar historial por filtros (Excel).

Editar perfil profesional (CMP, especialidades, consultorio, duración de turno).

🛠️ Administrador

Dashboard: citas por período, médicos/pacientes activos, especialidades más demandadas, % confirmaciones/cancelaciones.

Usuarios: crear/editar, activar/desactivar, eliminar; exportar Excel (por rol/estado/búsqueda).

Citas: ver/filtrar por estado/fechas/médico/paciente; exportar Excel; forzar cancelación/reprogramación (auditado).

Especialidades: CRUD.

Notificaciones: listar, filtrar, reintentar fallidas, marcar leídas.

Perfil admin y preferencias.

🧩 Requerimientos no funcionales

Usabilidad: UI responsiva y minimal; estados vacíos claros.

Seguridad: Argon2id, CSRF, rate limiting, auditoría de acciones críticas.

Rendimiento: T < 2 s por request; paginación en listados.

Disponibilidad: 99% + backups automáticos.

Escalabilidad: REST desacoplado; caching selectivo (carrusel y especialidades).

Mantenibilidad: Controller/Service/Repository; DTOs; Bean Validation.

Compatibilidad: navegadores modernos + móvil.

Observabilidad: logs estructurados y métricas (Spring Actuator).

👤 Actores y casos de uso

Actores: Paciente, Médico, Administrador.

Paciente: Buscar médico · Ver perfil · Solicitar · Aceptar/Rechazar · Cancelar/Reprogramar · Mis Citas · Perfil · Favoritos · Notificaciones.
Médico: Agenda · Proponer · Confirmar/Cancelar/Reprogramar · Marcar Atención · Exportar · Perfil · Notificaciones.
Admin: Dashboard · Usuarios · Citas · Exportar · Especialidades · Notificaciones · Perfil.

🔄 Flujos clave (Mermaid)
A) Reserva y negociación
sequenceDiagram
  participant P as Paciente
  participant API as API Citas
  participant M as Médico

  P->>API: POST /api/citas (SOLICITADA)
  API-->>M: Notificación (SOLICITADA)
  M->>API: POST /api/citas/{id}/proponer (PROPUESTA)
  API-->>P: Notificación (PROPUESTA)
  P->>API: POST /api/citas/{id}/aceptar (CONFIRMADA)
  API-->>M: Actualiza agenda (bloquea slot)
  M->>API: POST /api/citas/{id}/marcar?estado=ATENDIDA|NO_ASISTIO

B) Cancelación / Reprogramación
flowchart LR
  A[SOLICITADA] -- Cancelar ambos --> X[Cancelada]
  A -- Propuesta --> B[PROPUESTA]
  B -- Rechazar --> C[EN_NEGOCIACION]
  C -- Aceptar --> D[CONFIRMADA]
  D -- Reprogramar (cualquiera) --> C
  D -- Atendida / No asistió --> H[Historial]

🗄️ Diseño lógico de BD (19 tablas)

Objetivo: cubrir búsqueda por especialidad/nombre/rating, negociación con propuestas/mensajes, estados de cita, favoritos, notificaciones, exportes, agenda, y seguridad (login + recuperación).

A) Seguridad & cuentas (6)

1. usuario
id_usuario (PK), email (UNIQUE), password_hash, nombres, apellidos, telefono, fecha_nacimiento, dni, foto_url, estado(ACTIVO/INACTIVO), fecha_creacion

2. rol
id_rol (PK), nombre(PACIENTE/MEDICO/ADMIN)

3. usuario_rol (N:M, PK compuesta)
id_usuario (FK), id_rol (FK)

4. auth_login_intento
id (PK), id_usuario (FK), ip, user_agent, exitoso(bool), timestamp

5. auth_password_reset
id (PK), id_usuario (FK), token (UNIQUE), expira_en, usado(bool)

6. preferencia_notificacion
id (PK), id_usuario (FK), canal_app(bool), canal_email(bool), quiet_hours_json(nullable)

B) Catálogos & perfiles clínicos (5)

7. especialidad
id_especialidad (PK), nombre(UNIQUE), descripcion

8. medico (perfil profesional; 1:1 con usuario)
id_medico (PK & FK usuario), consultorio, duracion_turno_min, valoracion_promedio (denormalizado)

9. medico_especialidad (N:M, PK compuesta)
id_medico (FK), id_especialidad (FK)

10. paciente (perfil; 1:1 con usuario)
id_paciente (PK & FK usuario), contacto_emergencia, otros_datos_json(nullable)

11. favorito (PK compuesta)
id_paciente (FK), id_medico (FK), fecha_agregado

C) Agenda, reservas y negociación (7)

12. medico_horario
id (PK), id_medico (FK), dia_semana(0–6), hora_inicio, hora_fin, slot_minutos

13. medico_bloqueo
id (PK), id_medico (FK), inicio(datetime), fin(datetime), motivo

14. cita (núcleo)
id_cita (PK), id_paciente (FK), id_medico (FK),
fecha_hora(nullable en negociación), canal(PRESENCIAL/TELECONSULTA), motivo,
estado(SOLICITADA/PROPUESTA/EN_NEGOCIACION/CONFIRMADA/CANCELADA/ATENDIDA/NO_ASISTIO),
fecha_creacion

15. cita_propuesta
id_propuesta (PK), id_cita (FK), propuesto_por(MEDICO/PACIENTE),
fecha_hora_propuesta, comentario, vigente(bool), timestamp

16. cita_mensaje (diálogo)
id_mensaje (PK), id_cita (FK), emisor(PACIENTE/MEDICO/ADMIN), mensaje, timestamp

17. cita_historial (auditoría)
id_historial (PK), id_cita (FK), antes, despues, actor(PACIENTE/MEDICO/ADMIN), comentario, timestamp

18. valoracion (reseñas ⭐)
id_valoracion (PK), id_cita (FK), puntuacion(1–5), comentario, fecha

19. notificacion
id_notificacion (PK), id_destinatario (FK usuario), tipo(PROPUESTA/CONFIRMADA/CANCELADA/RECORDATORIO/...), mensaje, leida(bool), fecha_envio, metadata_json(nullable)

🔗 Diagrama ER (Mermaid)

GitHub renderiza Mermaid automáticamente.

erDiagram
  USUARIO ||--o{ USUARIO_ROL : posee
  ROL ||--o{ USUARIO_ROL : asignado
  USUARIO ||--|| MEDICO : "1:1"
  USUARIO ||--|| PACIENTE : "1:1"
  MEDICO ||--o{ MEDICO_ESPECIALIDAD : tiene
  ESPECIALIDAD ||--o{ MEDICO_ESPECIALIDAD : agrupa
  PACIENTE ||--o{ FAVORITO : marca
  MEDICO ||--o{ FAVORITO : recibe

  MEDICO ||--o{ MEDICO_HORARIO : programa
  MEDICO ||--o{ MEDICO_BLOQUEO : bloquea

  PACIENTE ||--o{ CITA : solicita
  MEDICO ||--o{ CITA : atiende

  CITA ||--o{ CITA_PROPUESTA : propone
  CITA ||--o{ CITA_MENSAJE : dialoga
  CITA ||--o{ CITA_HISTORIAL : audita
  CITA ||--o| VALORACION : califica

  USUARIO ||--o{ AUTH_LOGIN_INTENTO : intenta
  USUARIO ||--o{ AUTH_PASSWORD_RESET : resetea
  USUARIO ||--o{ PREFERENCIA_NOTIFICACION : prefiere
  USUARIO ||--o{ NOTIFICACION : recibe

⚙️ Endpoints sugeridos
Usuarios
GET  /api/usuarios?rol=&estado=&q=&page=&size=
POST /api/usuarios
PUT  /api/usuarios/{id}
DELETE /api/usuarios/{id}

Especialidades
GET  /api/especialidades
POST /api/especialidades
PUT  /api/especialidades/{id}
DELETE /api/especialidades/{id}

Médicos (listado/carrusel/búsqueda)
GET /api/medicos?especialidad=&q=&minRating=&page=&size=

Favoritos
GET    /api/favoritos
POST   /api/favoritos
DELETE /api/favoritos/{idMedico}

Citas (paciente)
POST /api/citas                           # crea SOLICITADA
GET  /api/mis-citas?estado=&page=&size=
POST /api/citas/{id}/aceptar
POST /api/citas/{id}/rechazar
POST /api/citas/{id}/cancelar
POST /api/citas/{id}/reprogramar          # crea nueva cita_propuesta

Citas (médico)
GET  /api/agenda?desde=&hasta=
POST /api/citas/{id}/proponer
POST /api/citas/{id}/confirmar
POST /api/citas/{id}/marcar?estado=ATENDIDA|NO_ASISTIO

Negociación (mensajes/propuestas)
GET  /api/citas/{id}/mensajes
POST /api/citas/{id}/mensajes
GET  /api/citas/{id}/propuestas
POST /api/citas/{id}/propuestas

Notificaciones
GET  /api/notificaciones?soloNoLeidas=
PUT  /api/notificaciones/{id}/leer
GET  /api/notificaciones/preferencias
PUT  /api/notificaciones/preferencias

📤 Exportaciones Excel

Usuarios

GET /api/usuarios/exportar?rol=&estado=&q=
# Nombre sugerido: usuarios_[filtro]_[YYYY-MM-DD].xlsx


Citas

GET /api/citas/exportar?estado=&desde=&hasta=&paciente=&medico=
# Nombre sugerido: citas_[filtro]_[YYYY-MM-DD].xlsx


Ejemplos (curl)

# Exportar solo médicos activos que contengan "pedi" en búsqueda
curl -L "https://tu-api.com/api/usuarios/exportar?rol=MEDICO&estado=ACTIVO&q=pedi" -o usuarios_medicos_$(date +%F).xlsx

# Exportar citas confirmadas del mes
curl -L "https://tu-api.com/api/citas/exportar?estado=CONFIRMADA&desde=2025-11-01&hasta=2025-11-30" -o citas_confirmadas_$(date +%F).xlsx

⚡ Índices & reglas de rendimiento

Búsqueda:

usuario(apellidos, nombres) compuesto

especialidad(nombre)

medico(valoracion_promedio)

Citas:

cita(id_medico, fecha_hora, estado)

cita(id_paciente, estado)

Mensajes/Historial:

cita_mensaje(id_cita, timestamp)

cita_historial(id_cita, timestamp)

Notificaciones:

notificacion(id_destinatario, leida, fecha_envio)

Rating consistente:

Servicio/trigger que recalcula medico.valoracion_promedio al insertar en valoracion.

🎨 Tips visuales (para el repo)

Usa badges (como arriba) para dar color y contexto rápido.

Añade gifs/screenshots de los flujos principales en la carpeta /docs.

Mantén esta estructura en el README con secciones plegables (<details>) si crece.
