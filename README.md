<!-- README COMPLETO EN HTML PURO (para pegar directo en README.md) -->
<h1 id="top">🩺 CitaSys — Plataforma de Reservas Médicas (README)</h1>

<p>
  <img alt="Status" src="https://img.shields.io/badge/status-ACTIVO-00B37E?style=for-the-badge">
  <img alt="Backend" src="https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">
  <img alt="Security" src="https://img.shields.io/badge/Spring%20Security-Argon2id-0A7E8C?style=for-the-badge">
  <img alt="DB" src="https://img.shields.io/badge/MySQL-8.x-00758F?style=for-the-badge&logo=mysql&logoColor=white">
  <img alt="Auth" src="https://img.shields.io/badge/CSRF-ON-3E7BFA?style=for-the-badge">
  <img alt="Export" src="https://img.shields.io/badge/Export-Excel-2F855A?style=for-the-badge">
</p>

<p>Plataforma minimalista para agendar citas médicas con negociación de horarios entre paciente y médico, panel administrativo, exportaciones a Excel y seguridad robusta (Argon2id, CSRF, rate limiting).</p>

<hr/>

<h2 id="tabla-de-contenido">📚 Tabla de contenido</h2>
<ul>
  <li><a href="#vista-general">🚀 Vista general</a></li>
  <li><a href="#login-seguridad">🔐 Login &amp; Seguridad</a></li>
  <li><a href="#rutas-pre-login">🧭 Rutas pre-login</a></li>
  <li><a href="#requerimientos-funcionales">✅ Requerimientos funcionales</a></li>
  <li><a href="#requerimientos-no-funcionales">🧩 Requerimientos no funcionales</a></li>
  <li><a href="#actores-y-casos-de-uso">👤 Actores y casos de uso</a></li>
  <li><a href="#flujos-clave">🔄 Flujos clave (Mermaid)</a></li>
  <li><a href="#bd-19-tablas">🗄️ Diseño lógico de BD (19 tablas)</a></li>
  <li><a href="#endpoints-sugeridos">⚙️ Endpoints sugeridos</a></li>
  <li><a href="#exportaciones-excel">📤 Exportaciones Excel</a></li>
  <li><a href="#indices-rendimiento">⚡ Índices &amp; reglas de rendimiento</a></li>
</ul>

<hr/>

<h2 id="vista-general">🚀 Vista general</h2>
<ul>
  <li><strong>Pacientes:</strong> buscan médicos por especialidad/nombre/⭐, solicitan cita, negocian propuestas, gestionan “Mis Citas”, favoritos y notificaciones.</li>
  <li><strong>Médicos:</strong> agenda tipo calendario, proponen horarios, confirman/reprograman/cancelan, marcan atención y exportan historial.</li>
  <li><strong>Admin:</strong> dashboard con métricas, CRUD de usuarios/especialidades, gestión de citas y notificaciones, exportaciones con filtros.</li>
</ul>
<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="login-seguridad">🔐 Login &amp; Seguridad</h2>

<p><strong>Hash de contraseñas:</strong> <code>Argon2id</code> (no BCrypt).</p>

<pre><code>saltLen=16
hashLen=32
parallelism=2
memory=65536   # 64 MB
iterations=3
</code></pre>

<ul>
  <li>Opcional <strong>pepper</strong> en variable de entorno.</li>
  <li><strong>CSRF</strong> activado + cookies de sesión <code>SameSite=Lax/Strict</code> + <code>HttpOnly</code>.</li>
  <li><strong>Rate limiting:</strong> bloqueo temporal por usuario/IP tras N fallos (registro en <code>auth_login_intento</code>).</li>
  <li><strong>Password reset:</strong> tokens firmados con expiración, un solo uso (<code>auth_password_reset</code>).</li>
  <li><strong>Redirección post-login por rol:</strong>
    <ul>
      <li>PACIENTE → <code>/paciente/inicio</code></li>
      <li>MEDICO → <code>/medico/inicio</code></li>
      <li>ADMIN → <code>/admin/inicio</code></li>
    </ul>
  </li>
</ul>

<p><strong>Endpoints de auth</strong></p>
<pre><code>POST /api/auth/login
POST /api/auth/logout
POST /api/auth/recuperar
POST /api/auth/restablecer
GET  /api/auth/me
</code></pre>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="rutas-pre-login">🧭 Rutas pre-login</h2>

<ul>
  <li><code>/</code> (Landing mínima): logo, texto breve, botón <strong>Iniciar sesión</strong> → <code>/auth/login</code></li>
  <li><code>/auth/login</code>: email + contraseña, “Recordarme”, “¿Olvidaste tu contraseña?” → <code>/auth/recuperar</code></li>
  <li><code>/auth/recuperar</code>: ingresa email → envío de token con expiración</li>
  <li><code>/auth/restablecer?token=...</code>: nueva contraseña (y confirmación)</li>
</ul>

<blockquote><strong>TIP:</strong> Usa <code>SameSite=Lax</code> para UX web estándar; <code>Strict</code> si priorizas seguridad.</blockquote>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="requerimientos-funcionales">✅ Requerimientos funcionales</h2>

<h3>👩‍⚕️ Paciente</h3>
<ul>
  <li>Inicio con saludo, guía, CTA <strong>Reservar cita</strong> y carrusel de médicos (foto, especialidad, ⭐1–5).</li>
  <li>Buscar médicos por <strong>nombre</strong>, <strong>especialidad</strong> o <strong>rating</strong>.</li>
  <li>Ver <strong>perfil del médico</strong> (foto, CMP, consultorio, especialidad, reseñas).</li>
  <li><strong>Solicitar cita</strong>: motivo, fecha/rango preferido, canal (presencial/teleconsulta).</li>
  <li>Aceptar/Rechazar <strong>propuesta</strong> del médico; <strong>negociación</strong> con mensajes.</li>
  <li><strong>Mis Citas</strong> por tabs: Pendientes, En negociación, Confirmadas, Historial (canceladas/atendidas/no asistió).</li>
  <li><strong>Cancelar</strong> antes de confirmar; <strong>reprogramar</strong> (pre-llenado).</li>
  <li><strong>Notificaciones</strong> (propuestas, confirmaciones, recordatorios).</li>
  <li><strong>Favoritos</strong> (marcar/quitar y solicitar desde ahí).</li>
  <li><strong>Perfil</strong> y preferencias de notificación (app/correo).</li>
</ul>

<h3>👨‍⚕️ Médico</h3>
<ul>
  <li>Inicio con <strong>KPIs</strong> + “<strong>Citas de hoy</strong>”.</li>
  <li><strong>Agenda calendario</strong>: confirmadas (bloquean), pendientes/propuestas resaltadas.</li>
  <li><strong>Proponer</strong> fecha/hora, responder solicitudes, <strong>confirmar/reprogramar/cancelar</strong>.</li>
  <li>Marcar <strong>ATENDIDA / NO_ASISTIÓ</strong>.</li>
  <li><strong>Exportar</strong> historial por filtros (Excel).</li>
  <li>Editar <strong>perfil profesional</strong> (CMP, especialidades, consultorio, duración de turno).</li>
</ul>

<h3>🛠️ Administrador</h3>
<ul>
  <li><strong>Dashboard</strong>: citas por período, médicos/pacientes activos, especialidades más demandadas, % confirmaciones/cancelaciones.</li>
  <li><strong>Usuarios</strong>: crear/editar, activar/desactivar, eliminar; <strong>exportar Excel</strong> (por rol/estado/búsqueda).</li>
  <li><strong>Citas</strong>: ver/filtrar por estado/fechas/médico/paciente; <strong>exportar Excel</strong>; forzar cancelación/reprogramación (<strong>auditado</strong>).</li>
  <li><strong>Especialidades</strong>: CRUD.</li>
  <li><strong>Notificaciones</strong>: listar, filtrar, reintentar fallidas, marcar leídas.</li>
  <li><strong>Perfil admin</strong> y preferencias.</li>
</ul>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="requerimientos-no-funcionales">🧩 Requerimientos no funcionales</h2>
<ul>
  <li><strong>Usabilidad:</strong> UI responsiva y minimal; estados vacíos claros.</li>
  <li><strong>Seguridad:</strong> Argon2id, CSRF, rate limiting, <strong>auditoría</strong> de acciones críticas.</li>
  <li><strong>Rendimiento:</strong> T &lt; 2 s por request; <strong>paginación</strong> en listados.</li>
  <li><strong>Disponibilidad:</strong> 99% + <strong>backups</strong> automáticos.</li>
  <li><strong>Escalabilidad:</strong> REST desacoplado; <strong>caching selectivo</strong> (carrusel y especialidades).</li>
  <li><strong>Mantenibilidad:</strong> Controller/Service/Repository; <strong>DTOs</strong>; <strong>Bean Validation</strong>.</li>
  <li><strong>Compatibilidad:</strong> navegadores modernos + móvil.</li>
  <li><strong>Observabilidad:</strong> <strong>logs estructurados</strong> y métricas (Spring Actuator).</li>
</ul>
<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="actores-y-casos-de-uso">👤 Actores y casos de uso</h2>
<p><strong>Actores:</strong> Paciente, Médico, Administrador.</p>
<p><strong>Paciente:</strong> Buscar médico · Ver perfil · Solicitar · Aceptar/Rechazar · Cancelar/Reprogramar · Mis Citas · Perfil · Favoritos · Notificaciones.</p>
<p><strong>Médico:</strong> Agenda · Proponer · Confirmar/Cancelar/Reprogramar · Marcar Atención · Exportar · Perfil · Notificaciones.</p>
<p><strong>Admin:</strong> Dashboard · Usuarios · Citas · Exportar · Especialidades · Notificaciones · Perfil.</p>
<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="flujos-clave">🔄 Flujos clave (Mermaid)</h2>

<h3>A) Reserva y negociación</h3>
<pre><code class="language-mermaid">sequenceDiagram
  participant P as Paciente
  participant API as API Citas
  participant M as Médico

  P-&gt;&gt;API: POST /api/citas (SOLICITADA)
  API--&gt;&gt;M: Notificación (SOLICITADA)
  M-&gt;&gt;API: POST /api/citas/{id}/proponer (PROPUESTA)
  API--&gt;&gt;P: Notificación (PROPUESTA)
  P-&gt;&gt;API: POST /api/citas/{id}/aceptar (CONFIRMADA)
  API--&gt;&gt;M: Actualiza agenda (bloquea slot)
  M-&gt;&gt;API: POST /api/citas/{id}/marcar?estado=ATENDIDA|NO_ASISTIO
</code></pre>

<h3>B) Cancelación / Reprogramación</h3>
<pre><code class="language-mermaid">flowchart LR
  A[SOLICITADA] -- Cancelar ambos --&gt; X[Cancelada]
  A -- Propuesta --&gt; B[PROPUESTA]
  B -- Rechazar --&gt; C[EN_NEGOCIACION]
  C -- Aceptar --&gt; D[CONFIRMADA]
  D -- Reprogramar (cualquiera) --&gt; C
  D -- Atendida / No asistió --&gt; H[Historial]
</code></pre>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="bd-19-tablas">🗄️ Diseño lógico de BD (19 tablas)</h2>
<p><em>Cubre búsqueda por especialidad/nombre/rating, negociación (propuestas/mensajes), estados de cita, favoritos, notificaciones, exportes, agenda y seguridad (login + recuperación).</em></p>

<h3>A) Seguridad &amp; cuentas (6)</h3>
<ol>
  <li><strong>usuario</strong> — <code>id_usuario</code> (PK), <code>email</code> (UNIQUE), <code>password_hash</code>, <code>nombres</code>, <code>apellidos</code>, <code>telefono</code>, <code>fecha_nacimiento</code>, <code>dni</code>, <code>foto_url</code>, <code>estado</code> (ACTIVO/INACTIVO), <code>fecha_creacion</code></li>
  <li><strong>rol</strong> — <code>id_rol</code> (PK), <code>nombre</code> (PACIENTE/MEDICO/ADMIN)</li>
  <li><strong>usuario_rol</strong> (N:M, PK compuesta) — <code>id_usuario</code> (FK), <code>id_rol</code> (FK)</li>
  <li><strong>auth_login_intento</strong> — <code>id</code> (PK), <code>id_usuario</code> (FK), <code>ip</code>, <code>user_agent</code>, <code>exitoso</code> (bool), <code>timestamp</code></li>
  <li><strong>auth_password_reset</strong> — <code>id</code> (PK), <code>id_usuario</code> (FK), <code>token</code> (UNIQUE), <code>expira_en</code>, <code>usado</code> (bool)</li>
  <li><strong>preferencia_notificacion</strong> — <code>id</code> (PK), <code>id_usuario</code> (FK), <code>canal_app</code> (bool), <code>canal_email</code> (bool), <code>quiet_hours_json</code> (nullable)</li>
</ol>

<h3>B) Catálogos &amp; perfiles clínicos (5)</h3>
<ol start="7">
  <li><strong>especialidad</strong> — <code>id_especialidad</code> (PK), <code>nombre</code> (UNIQUE), <code>descripcion</code></li>
  <li><strong>medico</strong> (perfil profesional; 1:1 con usuario) — <code>id_medico</code> (PK &amp; FK <code>usuario</code>), <code>consultorio</code>, <code>duracion_turno_min</code>, <code>valoracion_promedio</code> (denormalizado)</li>
  <li><strong>medico_especialidad</strong> (N:M, PK compuesta) — <code>id_medico</code> (FK), <code>id_especialidad</code> (FK)</li>
  <li><strong>paciente</strong> (perfil; 1:1 con usuario) — <code>id_paciente</code> (PK &amp; FK <code>usuario</code>), <code>contacto_emergencia</code>, <code>otros_datos_json</code> (nullable)</li>
  <li><strong>favorito</strong> (PK compuesta) — <code>id_paciente</code> (FK), <code>id_medico</code> (FK), <code>fecha_agregado</code></li>
</ol>

<h3>C) Agenda, reservas y negociación (7)</h3>
<ol start="12">
  <li><strong>medico_horario</strong> — <code>id</code> (PK), <code>id_medico</code> (FK), <code>dia_semana</code> (0–6), <code>hora_inicio</code>, <code>hora_fin</code>, <code>slot_minutos</code></li>
  <li><strong>medico_bloqueo</strong> — <code>id</code> (PK), <code>id_medico</code> (FK), <code>inicio</code> (datetime), <code>fin</code> (datetime), <code>motivo</code></li>
  <li><strong>cita</strong> (núcleo) — <code>id_cita</code> (PK), <code>id_paciente</code> (FK), <code>id_medico</code> (FK), <code>fecha_hora</code> (nullable), <code>canal</code> (PRESENCIAL/TELECONSULTA), <code>motivo</code>, <code>estado</code> (SOLICITADA/PROPUESTA/EN_NEGOCIACION/CONFIRMADA/CANCELADA/ATENDIDA/NO_ASISTIO), <code>fecha_creacion</code></li>
  <li><strong>cita_propuesta</strong> — <code>id_propuesta</code> (PK), <code>id_cita</code> (FK), <code>propuesto_por</code> (MEDICO/PACIENTE), <code>fecha_hora_propuesta</code>, <code>comentario</code>, <code>vigente</code> (bool), <code>timestamp</code></li>
  <li><strong>cita_mensaje</strong> (diálogo) — <code>id_mensaje</code> (PK), <code>id_cita</code> (FK), <code>emisor</code> (PACIENTE/MEDICO/ADMIN), <code>mensaje</code>, <code>timestamp</code></li>
  <li><strong>cita_historial</strong> (auditoría) — <code>id_historial</code> (PK), <code>id_cita</code> (FK), <code>antes</code>, <code>despues</code>, <code>actor</code> (PACIENTE/MEDICO/ADMIN), <code>comentario</code>, <code>timestamp</code></li>
  <li><strong>valoracion</strong> (reseñas ⭐) — <code>id_valoracion</code> (PK), <code>id_cita</code> (FK), <code>puntuacion</code> (1–5), <code>comentario</code>, <code>fecha</code></li>
  <li><strong>notificacion</strong> — <code>id_notificacion</code> (PK), <code>id_destinatario</code> (FK <code>usuario</code>), <code>tipo</code> (PROPUESTA/CONFIRMADA/CANCELADA/RECORDATORIO/...), <code>mensaje</code>, <code>leida</code> (bool), <code>fecha_envio</code>, <code>metadata_json</code> (nullable)</li>
</ol>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="endpoints-sugeridos">⚙️ Endpoints sugeridos</h2>

<h3>Usuarios</h3>
<pre><code>GET  /api/usuarios?rol=&amp;estado=&amp;q=&amp;page=&amp;size=
POST /api/usuarios
PUT  /api/usuarios/{id}
DELETE /api/usuarios/{id}
</code></pre>

<h3>Especialidades</h3>
<pre><code>GET  /api/especialidades
POST /api/especialidades
PUT  /api/especialidades/{id}
DELETE /api/especialidades/{id}
</code></pre>

<h3>Médicos (listado/carrusel/búsqueda)</h3>
<pre><code>GET /api/medicos?especialidad=&amp;q=&amp;minRating=&amp;page=&amp;size=
</code></pre>

<h3>Favoritos</h3>
<pre><code>GET    /api/favoritos
POST   /api/favoritos
DELETE /api/favoritos/{idMedico}
</code></pre>

<h3>Citas (paciente)</h3>
<pre><code>POST /api/citas                           # crea SOLICITADA
GET  /api/mis-citas?estado=&amp;page=&amp;size=
POST /api/citas/{id}/aceptar
POST /api/citas/{id}/rechazar
POST /api/citas/{id}/cancelar
POST /api/citas/{id}/reprogramar          # crea nueva cita_propuesta
</code></pre>

<h3>Citas (médico)</h3>
<pre><code>GET  /api/agenda?desde=&amp;hasta=
POST /api/citas/{id}/proponer
POST /api/citas/{id}/confirmar
POST /api/citas/{id}/marcar?estado=ATENDIDA|NO_ASISTIO
</code></pre>

<h3>Negociación (mensajes/propuestas)</h3>
<pre><code>GET  /api/citas/{id}/mensajes
POST /api/citas/{id}/mensajes
GET  /api/citas/{id}/propuestas
POST /api/citas/{id}/propuestas
</code></pre>

<h3>Notificaciones</h3>
<pre><code>GET  /api/notificaciones?soloNoLeidas=
PUT  /api/notificaciones/{id}/leer
GET  /api/notificaciones/preferencias
PUT  /api/notificaciones/preferencias
</code></pre>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="exportaciones-excel">📤 Exportaciones Excel</h2>

<p><strong>Usuarios</strong></p>
<pre><code>GET /api/usuarios/exportar?rol=&amp;estado=&amp;q=
</code></pre>
<p><strong>Nombre sugerido:</strong> <code>usuarios_[filtro]_[YYYY-MM-DD].xlsx</code></p>

<p><strong>Citas</strong></p>
<pre><code>GET /api/citas/exportar?estado=&amp;desde=&amp;hasta=&amp;paciente=&amp;medico=
</code></pre>
<p><strong>Nombre sugerido:</strong> <code>citas_[filtro]_[YYYY-MM-DD].xlsx</code></p>

<p><strong>Ejemplos (curl)</strong></p>
<pre><code># Exportar solo médicos activos que contengan "pedi" en búsqueda
curl -L "https://tu-api.com/api/usuarios/exportar?rol=MEDICO&amp;estado=ACTIVO&amp;q=pedi" -o usuarios_medicos_$(date +%F).xlsx

# Exportar citas confirmadas del mes
curl -L "https://tu-api.com/api/citas/exportar?estado=CONFIRMADA&amp;desde=2025-11-01&amp;hasta=2025-11-30" -o citas_confirmadas_$(date +%F).xlsx
</code></pre>

<p><a href="#top">⬆ Volver arriba</a></p>

<hr/>

<h2 id="indices-rendimiento">⚡ Índices &amp; reglas de rendimiento</h2>
<ul>
  <li><strong>Búsqueda:</strong>
    <ul>
      <li><code>usuario(apellidos, nombres)</code> compuesto</li>
      <li><code>especialidad(nombre)</code></li>
      <li><code>medico(valoracion_promedio)</code></li>
    </ul>
  </li>
  <li><strong>Citas:</strong>
    <ul>
      <li><code>cita(id_medico, fecha_hora, estado)</code></li>
      <li><code>cita(id_paciente, estado)</code></li>
    </ul>
  </li>
  <li><strong>Mensajes/Historial:</strong>
    <ul>
      <li><code>cita_mensaje(id_cita, timestamp)</code></li>
      <li><code>cita_historial(id_cita, timestamp)</code></li>
    </ul>
  </li>
  <li><strong>Notificaciones:</strong>
    <ul>
      <li><code>notificacion(id_destinatario, leida, fecha_envio)</code></li>
    </ul>
  </li>
  <li><strong>Rating consistente:</strong> servicio/trigger que recalcula <code>medico.valoracion_promedio</code> al insertar en <code>valoracion</code>.</li>
</ul>

<p><a href="#top">⬆ Volver arriba</a></p>
