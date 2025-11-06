<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <title>CitaSys – Documentación Técnica y README</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <style>
    :root{
      --bg:#020617;
      --bg-soft:#020617;
      --card:#020617;
      --card-soft:#0b1220;
      --card-alt:#0f172a;
      --ink:#e5e7eb;
      --muted:#9ca3af;
      --accent:#22d3ee;
      --accent-soft:rgba(45,212,191,.16);
      --accent-2:#a855f7;
      --border:#1f2937;
      --danger:#f97373;
      --ok:#22c55e;

      --radius-lg:18px;
      --radius-sm:999px;
      --shadow-lg:0 20px 40px rgba(0,0,0,.45);
      --shadow-soft:0 10px 30px rgba(15,23,42,.7);
      --max-w:1120px;
    }

    *{box-sizing:border-box;margin:0;padding:0}
    html,body{height:100%}
    body{
      font-family: system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
      background: radial-gradient(circle at top,#111827 0,#020617 55%,#020617 100%);
      color:var(--ink);
      line-height:1.6;
    }

    .page{
      min-height:100vh;
      padding:24px 16px 64px;
      display:flex;
      flex-direction:column;
      align-items:center;
    }

    header{
      width:100%;
      max-width:var(--max-w);
      margin:0 auto 24px;
      padding:20px 20px 18px;
      border-radius:24px;
      background: radial-gradient(circle at 0 0,#22d3ee33 0,#0b1120 45%,#020617 100%);
      box-shadow:var(--shadow-lg);
      border:1px solid rgba(148,163,184,.45);
      position:relative;
      overflow:hidden;
    }

    header::before{
      content:"";
      position:absolute;
      inset:-120px;
      background:
        radial-gradient(circle at 100% 0,#a855f7 0,transparent 45%),
        radial-gradient(circle at 0 100%,#22d3ee 0,transparent 40%);
      opacity:.18;
      pointer-events:none;
    }

    header-inner{
      display:block;
      position:relative;
      z-index:1;
    }

    h1{
      font-size:2.1rem;
      letter-spacing:.03em;
      margin-bottom:.35rem;
      display:flex;
      flex-wrap:wrap;
      align-items:center;
      gap:.5rem;
    }

    .pill{
      display:inline-flex;
      align-items:center;
      gap:.35rem;
      padding:4px 10px;
      font-size:.72rem;
      text-transform:uppercase;
      letter-spacing:.12em;
      border-radius:var(--radius-sm);
      border:1px solid rgba(148,163,184,.5);
      background:rgba(15,23,42,.88);
      color:var(--muted);
    }
    .pill span{
      display:inline-block;
      width:7px;
      height:7px;
      border-radius:999px;
      background:var(--accent);
      box-shadow:0 0 0 4px rgba(34,211,238,.28);
    }

    .subtitle{
      font-size:.97rem;
      color:var(--muted);
      max-width:620px;
      margin-bottom:1rem;
    }

    .meta{
      display:flex;
      flex-wrap:wrap;
      gap:.6rem 1.25rem;
      font-size:.82rem;
      color:var(--muted);
    }

    .meta strong{color:var(--ink);font-weight:600}

    .badges-line{
      margin-top:1rem;
      display:flex;
      flex-wrap:wrap;
      gap:.45rem;
    }
    .badge{
      padding:4px 10px;
      border-radius:999px;
      border:1px solid rgba(148,163,184,.5);
      font-size:.74rem;
      display:inline-flex;
      align-items:center;
      gap:.4rem;
      background:rgba(15,23,42,.9);
    }
    .badge-dot{
      width:8px;
      height:8px;
      border-radius:999px;
      background:var(--accent);
    }
    .badge-alt .badge-dot{background:var(--accent-2)}

    /* Layout */
    main{
      width:100%;
      max-width:var(--max-w);
      margin:0 auto;
      display:grid;
      grid-template-columns:minmax(0,260px) minmax(0,1fr);
      gap:20px;
    }
    @media (max-width:900px){
      main{grid-template-columns:minmax(0,1fr);}
      .toc{position:static;top:unset;max-height:none;}
    }

    .toc{
      position:sticky;
      top:16px;
      align-self:flex-start;
      background:rgba(15,23,42,.96);
      border-radius:18px;
      border:1px solid var(--border);
      box-shadow:var(--shadow-soft);
      padding:14px 14px 16px;
      font-size:.82rem;
    }
    .toc h2{
      font-size:.86rem;
      text-transform:uppercase;
      letter-spacing:.14em;
      color:var(--muted);
      margin-bottom:.75rem;
    }
    .toc ul{list-style:none;padding-left:0;margin:0;}
    .toc li{margin-bottom:6px;}
    .toc a{
      color:var(--muted);
      text-decoration:none;
      display:block;
      padding:3px 6px;
      border-radius:8px;
    }
    .toc a:hover{
      background:rgba(15,118,110,.32);
      color:var(--accent);
    }
    .toc .toc-sub{
      padding-left:10px;
      margin-top:4px;
    }

    .content{
      background:rgba(15,23,42,.94);
      border-radius:24px;
      border:1px solid var(--border);
      box-shadow:var(--shadow-soft);
      padding:22px 20px 28px;
    }

    section+section{margin-top:22px;}

    h2{
      font-size:1.3rem;
      margin-bottom:.4rem;
      display:flex;
      align-items:center;
      gap:.5rem;
    }
    h2 span.num{
      font-size:.82rem;
      color:var(--accent);
      font-weight:600;
      text-transform:uppercase;
      letter-spacing:.15em;
    }

    h3{
      font-size:1rem;
      margin-top:12px;
      margin-bottom:4px;
    }

    p{margin-bottom:.4rem;font-size:.92rem;}
    ul,ol{margin:0 0 .4rem 1.1rem;font-size:.92rem;}
    li{margin-bottom:.25rem;}

    .card{
      background:var(--card-soft);
      border-radius:var(--radius-lg);
      border:1px solid rgba(31,41,55,.9);
      padding:12px 12px 10px;
      margin-top:6px;
      margin-bottom:8px;
    }

    code, pre{
      font-family:SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace;
      font-size:.83rem;
    }
    pre{
      margin:6px 0 10px;
      padding:10px 12px;
      border-radius:14px;
      background:#020617;
      border:1px solid #111827;
      overflow:auto;
    }
    pre code{background:none;padding:0;}

    .tag-pill{
      display:inline-flex;
      align-items:center;
      gap:.25rem;
      padding:2px 8px;
      border-radius:999px;
      border:1px solid rgba(55,65,81,.9);
      font-size:.7rem;
      text-transform:uppercase;
      letter-spacing:.12em;
      color:var(--muted);
    }

    .tree{
      margin-top:4px;
    }

    .note{
      border-left:3px solid var(--accent);
      padding-left:10px;
      margin-top:6px;
      color:var(--muted);
      font-size:.86rem;
    }

    .subtitle-small{
      font-size:.83rem;
      color:var(--muted);
      margin-bottom:.2rem;
    }

    hr{
      border:none;
      border-top:1px dashed rgba(75,85,99,.85);
      margin:16px 0 12px;
    }

    .section-badge{
      font-size:.7rem;
      letter-spacing:.15em;
      text-transform:uppercase;
      color:var(--accent);
    }
  </style>
</head>
<body>
<div class="page">

  <header>
    <header-inner>
      <div class="pill"><span></span>CitaSys · Sistema de citas médicas</div>
      <h1>CitaSys <small>(sistema de citas)</small></h1>
      <p class="subtitle">
        Documentación técnica principal y resumen tipo README para el proyecto CitaSys, un sistema web de gestión de citas médicas desarrollado con Spring Boot, Java y frontend HTML/CSS/JS.
      </p>

      <div class="meta">
        <div><strong>Autor:</strong> Jhostin Leonardo Rodriguez Neyra – Desarrollador Full&nbsp;Stack</div>
        <div><strong>Versión doc:</strong> v1.0</div>
        <div><strong>Fecha:</strong> 2025-11-05</div>
        <div><strong>Proyecto:</strong> CitaSys – Sistema de gestión de citas médicas</div>
      </div>

      <div class="badges-line">
        <div class="badge">
          <span class="badge-dot"></span> Spring Boot&nbsp;3.5.7 · Java&nbsp;17
        </div>
        <div class="badge badge-alt">
          <span class="badge-dot"></span> HTML · CSS · JS (vanilla)
        </div>
        <div class="badge">
          <span class="badge-dot"></span> MySQL · Spring Data JPA · Spring Security
        </div>
      </div>
    </header-inner>
  </header>

  <main>
    <!-- Tabla de contenido -->
    <aside class="toc">
      <h2>Contenido</h2>
      <ul>
        <li><a href="#resumen">1. Resumen ejecutivo</a></li>
        <li><a href="#objetivos">2. Objetivos y alcance</a>
          <ul class="toc-sub">
            <li><a href="#objetivo-general">2.1 Objetivo general</a></li>
            <li><a href="#objetivos-especificos">2.2 Objetivos específicos</a></li>
            <li><a href="#alcance">2.3 Alcance</a></li>
          </ul>
        </li>
        <li><a href="#usuarios">3. Usuarios y casos de uso</a></li>
        <li><a href="#arquitectura">4. Arquitectura del sistema</a></li>
        <li><a href="#modelo-datos">5. Modelo de datos</a></li>
        <li><a href="#api">6. API REST (backend)</a></li>
        <li><a href="#seguridad">7. Seguridad</a></li>
        <li><a href="#flujo-frontend">8. Flujo de navegación (frontend)</a></li>
        <li><a href="#desarrollo">9. Proceso de desarrollo y calidad</a></li>
        <li><a href="#despliegue">10. Despliegue y entorno</a></li>
        <li><a href="#limitaciones">11. Limitaciones y trabajo futuro</a></li>
        <li><a href="#anexos">12. Anexos</a></li>
        <li><a href="#readme">README · Resumen GitHub</a></li>
        <li><a href="#arquitectura-carpetas">Arquitectura de carpetas</a></li>
        <li><a href="#notas">Notas y acciones recomendadas</a></li>
      </ul>
    </aside>

    <!-- Contenido principal -->
    <div class="content">

      <!-- 1. Resumen ejecutivo -->
      <section id="resumen">
        <h2><span class="num">01</span> Resumen ejecutivo</h2>
        <p>
          CitaSys es un sistema web para gestionar el ciclo completo de citas médicas:
          solicitud, negociación de horarios, confirmación, atención y estados finales.
        </p>
        <div class="card">
          <h3>Perfiles de usuario</h3>
          <ul>
            <li><strong>Administrador</strong></li>
            <li><strong>Médico</strong></li>
            <li><strong>Paciente</strong></li>
          </ul>

          <h3>Principales funcionalidades</h3>
          <ul>
            <li>Gestión de usuarios, especialidades y médicos por especialidad.</li>
            <li>Flujo de citas con estados:
              <code>SOLICITADA</code>, <code>PROPUESTA</code>, <code>EN_NEGOCIACION</code>,
              <code>CONFIRMADA</code>, <code>CANCELADA</code>, <code>ATENDIDA</code>, <code>NO_ASISTIO</code>.
            </li>
            <li>Bot asistente (paciente/médico) y Bot Admin con consultas a BD (conteos, listados, detalles).</li>
            <li>Notificaciones y <em>deep links</em> a vistas específicas.</li>
          </ul>

          <h3>Tecnologías clave</h3>
          <ul>
            <li>Spring Boot 3.5.7 (Java 17)</li>
            <li>Spring Web, Spring Security, Spring Data JPA, Validation</li>
            <li>MySQL</li>
            <li>Frontend HTML/CSS/JS (vanilla)</li>
          </ul>

          <p><strong>Estado actual:</strong> MVP avanzado listo para pilotos internos.</p>
        </div>
      </section>

      <!-- 2. Objetivos y alcance -->
      <section id="objetivos">
        <h2><span class="num">02</span> Objetivos y alcance</h2>

        <h3 id="objetivo-general">2.1 Objetivo general</h3>
        <p>
          Digitalizar y automatizar la gestión de citas, reduciendo tiempos y errores en la coordinación entre pacientes y médicos.
        </p>

        <h3 id="objetivos-especificos">2.2 Objetivos específicos</h3>
        <ul>
          <li>Automatizar la solicitud y confirmación de citas.</li>
          <li>Estandarizar el flujo de negociación de horarios.</li>
          <li>Centralizar el catálogo de especialidades y médicos.</li>
          <li>Proveer un panel de administración con métricas básicas (conteos por estado).</li>
          <li>Habilitar asistentes conversacionales para orientar y operar tareas comunes.</li>
        </ul>

        <h3 id="alcance">2.3 Alcance</h3>
        <div class="card">
          <h4 class="subtitle-small">Qué <strong>sí</strong> hace</h4>
          <ul>
            <li>CRUD de especialidades.</li>
            <li>Flujo de citas con negociación y cambios de estado.</li>
            <li>Gestión de usuarios y roles.</li>
            <li>Bot Admin con respuestas desde la base de datos (conteos, listados, detalles puntuales).</li>
          </ul>

          <h4 class="subtitle-small">Qué <strong>no</strong> hace</h4>
          <ul>
            <li>No envía correos/SMS transaccionales.</li>
            <li>No integra pasarela de pagos.</li>
            <li>No incluye historias clínicas ni receta electrónica.</li>
            <li>No expone una API pública para terceros (más allá de la REST interna utilizada por el frontend).</li>
          </ul>
        </div>
      </section>

      <!-- 3. Usuarios y casos de uso -->
      <section id="usuarios">
        <h2><span class="num">03</span> Usuarios y casos de uso</h2>

        <h3>3.1 Perfiles de usuario</h3>
        <div class="card">
          <h4>Administrador</h4>
          <p><strong>Responsabilidades:</strong> gestionar especialidades, ver métricas, brindar soporte.</p>
          <p><strong>Vistas:</strong> panel admin, gestión de especialidades, Bot Admin.</p>

          <h4>Médico</h4>
          <p><strong>Responsabilidades:</strong> proponer horarios, confirmar/cancelar citas, marcar atención o no-asistencia.</p>
          <p><strong>Vistas:</strong> panel médico, notificaciones, módulo de citas.</p>

          <h4>Paciente</h4>
          <p><strong>Responsabilidades:</strong> solicitar cita, participar en la negociación, confirmar/cancelar.</p>
          <p><strong>Vistas:</strong> panel paciente, especialidades, selección de médico, citas.</p>
        </div>

        <h3>3.2 Casos de uso principales</h3>
        <ul>
          <li>Crear y gestionar especialidades (Administrador).</li>
          <li>Solicitar, negociar y confirmar una cita (Paciente/Médico).</li>
          <li>Aprobar o rechazar propuestas de horario (Médico/Paciente).</li>
          <li>Ver reportes simples de citas por estado (Administrador a través del Bot).</li>
          <li>Listar usuarios, médicos y especialidades (Administrador vía Bot).</li>
        </ul>

        <p class="note">
          Opcionalmente, se pueden representar estos flujos con un diagrama UML de casos de uso (Actores:
          Admin, Médico, Paciente; Casos: Gestionar especialidad, Solicitar cita, Proponer horario,
          Confirmar cita, Consultar métricas).
        </p>
      </section>

      <!-- 4. Arquitectura -->
      <section id="arquitectura">
        <h2><span class="num">04</span> Arquitectura del sistema</h2>

        <h3>4.1 Vista general</h3>
        <p>
          CitaSys implementa una arquitectura cliente–servidor clásica:
        </p>
        <ul>
          <li><strong>Frontend:</strong> HTML5, CSS3 y JavaScript (vanilla). Páginas separadas por rol bajo <code>static/{rol}/...</code>.</li>
          <li><strong>Backend:</strong> Spring Boot (REST) con capas bien definidas.</li>
          <li><strong>Base de datos:</strong> MySQL.</li>
        </ul>
        <p>Capas por convención:</p>
        <ul>
          <li><code>Controller → Repository → DB</code></li>
          <li>Entidades JPA bajo <code>pe.uni.consultas.entidad</code>.</li>
        </ul>
        <div class="card">
          <h4>Esquema de alto nivel</h4>
          <pre class="tree"><code>Navegador (Paciente / Médico / Admin)
      ↓  (HTTP/HTTPS · JSON)
Servidor Spring Boot (CitaSys API)
      ↓  (JPA / JDBC)
Base de datos MySQL (schema: reserva)</code></pre>
        </div>

        <h3>4.2 Tecnologías usadas</h3>
        <ul>
          <li><strong>Backend</strong>
            <ul>
              <li>Java 17, Spring Boot 3.5.7</li>
              <li>Spring Web, Spring Security, Spring Data JPA, Validation</li>
              <li><code>Argon2PasswordEncoder</code> (módulo security-crypto) para hash de contraseñas</li>
              <li>MySQL Connector/J</li>
              <li>H2 (opcional para desarrollo en memoria)</li>
            </ul>
          </li>
          <li><strong>Frontend</strong>
            <ul>
              <li>HTML5, CSS3 y JavaScript (vanilla)</li>
            </ul>
          </li>
          <li><strong>Herramientas</strong>
            <ul>
              <li>Maven</li>
              <li>Git</li>
              <li>IDE: IntelliJ IDEA / VS Code</li>
              <li>Apache POI (opcional, exportación XLSX si se requiere)</li>
            </ul>
          </li>
        </ul>

        <h3>4.3 Estructura de paquetes (backend)</h3>
        <p>Paquete raíz: <code>pe.uni.consultas</code></p>
        <ul>
          <li><code>controlador</code> – Controladores REST (seguridad, especialidades, citas, bots, módulos por rol).</li>
          <li><code>repositorio</code> – Interfaces Spring Data JPA.</li>
          <li><code>entidad</code> – Entidades JPA que representan las tablas.</li>
          <li><code>config</code> – Configuración de seguridad/CORS (si aplica en el repositorio).</li>
        </ul>
        <p>Responsabilidades por capa:</p>
        <ul>
          <li><strong>Controller:</strong> recibe solicitudes HTTP, realiza validaciones básicas y delega la lógica.</li>
          <li><strong>Repository:</strong> acceso a la base de datos mediante JPA y consultas derivadas o nativas.</li>
          <li><strong>Entity:</strong> mapeo de tablas a clases Java con anotaciones JPA.</li>
        </ul>

        <h3>4.4 Estructura del frontend</h3>
        <ul>
          <li><code>/static/{rol}/html/...</code></li>
          <li><code>/static/{rol}/js/...</code></li>
          <li><code>/static/common/...</code> (componentes compartidos, como bots o estilos comunes).</li>
        </ul>
        <p>La navegación se implementa con enlaces y botones por rol; el JavaScript realiza peticiones
          <code>fetch</code> hacia <code>/api/...</code>, manejando los tokens CSRF en las peticiones POST/PUT/DELETE.</p>
      </section>

      <!-- 5. Modelo de datos -->
      <section id="modelo-datos">
        <h2><span class="num">05</span> Modelo de datos</h2>

        <h3>5.1 Entidades clave</h3>

        <div class="card">
          <h4>Usuario (<code>usuario</code>)</h4>
          <ul>
            <li><code>id_usuario</code>, <code>email</code>, <code>password_hash</code>, <code>nombres</code>, <code>apellidos</code>, <code>telefono</code>, <code>dni</code>, <code>estado</code>, <code>fecha_creacion</code></li>
            <li>Campos de foto: <code>foto_url</code>, <code>foto_blob</code>, <code>foto_mime</code>, <code>foto_actualizado</code></li>
          </ul>

          <h4>Cita (<code>cita</code>)</h4>
          <ul>
            <li><code>id_cita</code>, <code>id_paciente</code>, <code>id_medico</code></li>
            <li><code>fecha_hora</code> (confirmada), <code>propuesta_fecha_hora</code>, <code>confirmada_fecha_hora</code></li>
            <li><code>canal</code>: <code>PRESENCIAL</code> | <code>TELECONSULTA</code></li>
            <li><code>estado</code>:
              <code>SOLICITADA</code>, <code>PROPUESTA</code>, <code>EN_NEGOCIACION</code>,
              <code>CONFIRMADA</code>, <code>CANCELADA</code>, <code>ATENDIDA</code>, <code>NO_ASISTIO</code>
            </li>
            <li><code>ultima_propuesta_por</code>: <code>PACIENTE</code> | <code>MEDICO</code></li>
          </ul>

          <h4>Especialidad (<code>especialidad</code>)</h4>
          <ul>
            <li><code>id_especialidad</code>, <code>nombre</code>, <code>descripcion</code>, <code>activo</code></li>
            <li>Soporte de medios: <code>foto_url</code>, <code>foto_blob</code>, <code>foto_mime</code>, <code>foto_actualizado</code></li>
          </ul>
        </div>

        <h3>Relaciones</h3>
        <ul>
          <li>Un <strong>Usuario</strong> se asocia a uno o más roles mediante la tabla intermedia <code>usuario_rol</code> y la tabla <code>rol</code>.</li>
          <li>Una <strong>Cita</strong> referencia a un usuario paciente y a un usuario médico mediante claves foráneas.</li>
          <li>La relación Médico–Especialidad se gestiona a través de la tabla <code>medico_especialidad</code>.</li>
        </ul>

        <h3>5.2 Tablas principales</h3>
        <ul>
          <li><strong><code>usuario</code></strong>: datos personales, credenciales hash y estado.</li>
          <li><strong><code>cita</code></strong>: relación paciente–médico, estado y fechas clave.</li>
          <li><strong><code>especialidad</code></strong>: catálogo de especialidades, campo activo/inactivo y medios asociados.</li>
          <li><strong><code>rol</code>, <code>usuario_rol</code></strong>: soporte de seguridad basada en roles.</li>
          <li><strong><code>medico_especialidad</code></strong>: asignación de especialidades a médicos.</li>
        </ul>
      </section>

      <!-- 6. API REST -->
      <section id="api">
        <h2><span class="num">06</span> API REST (backend)</h2>

        <h3>6.1 Convenciones generales</h3>
        <ul>
          <li><strong>Base URL:</strong> <code>/api/...</code></li>
          <li><strong>Formato:</strong> JSON</li>
          <li><strong>Autenticación:</strong> Sesiones HTTP gestionadas por Spring Security.</li>
          <li><strong>CSRF:</strong> habilitado para métodos de cambio de estado (POST/PUT/DELETE).</li>
          <li><strong>Roles:</strong> <code>ADMIN</code>, <code>MEDICO</code>, <code>PACIENTE</code> (y/o <code>USER</code> según configuración).</li>
        </ul>

        <h3>6.2 Endpoints principales</h3>

        <div class="card">
          <h4>Autenticación / CSRF</h4>
          <ul>
            <li><code>POST /api/auth/csrf</code> – entrega token CSRF para el frontend.</li>
            <li><code>GET</code>, <code>HEAD</code>, <code>OPTIONS /api/auth/csrf</code> – token y metadatos CSRF.</li>
          </ul>
          <p class="note">
            El login/logout completo puede residir en otro controlador del proyecto,
            siguiendo la configuración de Spring Security y sesiones.
          </p>
        </div>

        <div class="card">
          <h4>Especialidades (público autenticado)</h4>
          <ul>
            <li><code>GET /api/especialidades</code> – lista detallada (filtrable por <code>activas</code> y <code>q</code>).</li>
            <li><code>GET /api/especialidades/nombres?activas=true|false</code> – devuelve solo <code>id</code> y <code>nombre</code>.</li>
            <li><code>GET /api/especialidades/{id}/foto</code> – obtiene foto (blob o redirección 302 a URL externa).</li>
            <li><code>POST /api/especialidades</code> (ADMIN) – crear especialidad.</li>
            <li><code>PUT /api/especialidades/{id}</code> (ADMIN) – actualizar datos.</li>
            <li><code>DELETE /api/especialidades/{id}</code> (ADMIN) – eliminar o desactivar.</li>
            <li><code>POST /api/especialidades/{id}/foto</code> (ADMIN, multipart) – subir foto como blob.</li>
            <li><code>DELETE /api/especialidades/{id}/foto</code> (ADMIN) – eliminar foto.</li>
            <li><code>PUT /api/especialidades/{id}/foto-url</code> (ADMIN) – asociar URL de foto.</li>
          </ul>
        </div>

        <div class="card">
          <h4>Admin Especialidades (área admin)</h4>
          <p>Base <code>/api/admin/especialidades</code> con endpoints CRUD equivalentes,
            reforzando validaciones y reglas administrativas.</p>
        </div>

        <div class="card">
          <h4>Bot Admin</h4>
          <ul>
            <li><code>POST /api/admin/ai/chat</code> (solo ADMIN)</li>
          </ul>
          <p>Permite consultas sobre la base de datos, por ejemplo:</p>
          <ul>
            <li>Conteos de citas por estado y por fecha.</li>
            <li>Detalle de una cita concreta por ID.</li>
            <li>Listado de próximas citas.</li>
            <li>Listar nombres de usuarios, médicos, pacientes y especialidades.</li>
            <li>Interpretar referencias como “sus nombres” a partir del contexto.</li>
          </ul>
        </div>

        <div class="card">
          <h4>Citas, notificaciones y usuarios</h4>
          <p>
            El proyecto incluye controladores y páginas específicas para paciente y médico,
            cubriendo flujos de negociación y cambio de estado de las citas, junto con
            notificaciones y enlaces profundos hacia las vistas relevantes.
          </p>
        </div>

        <h3>6.3 Ejemplos de request/response</h3>

        <div class="card">
          <h4>Ejemplo: obtener nombres de especialidades activas</h4>
          <p><code>GET /api/especialidades/nombres?activas=true</code></p>
          <pre><code>[
  { "id": 1, "nombre": "Cardiología" },
  { "id": 2, "nombre": "Dermatología" }
]</code></pre>
        </div>

        <div class="card">
          <h4>Ejemplo: consulta al Bot Admin</h4>
          <p><code>POST /api/admin/ai/chat</code></p>
          <p><strong>Request</strong></p>
          <pre><code>{
  "messages": [
    { "role": "user", "content": "¿Cuántos médicos hay?" }
  ]
}</code></pre>
          <p><strong>Response</strong></p>
          <pre><code>{
  "ok": true,
  "reply": "Hay 7 médicos registrados en el sistema."
}</code></pre>
        </div>
      </section>

      <!-- 7. Seguridad -->
      <section id="seguridad">
        <h2><span class="num">07</span> Seguridad</h2>
        <ul>
          <li><strong>Autenticación:</strong> Sesiones HTTP con Spring Security (<code>JSESSIONID</code>).</li>
          <li><strong>CSRF:</strong> habilitado. El frontend envía el token en el header <code>X-XSRF-TOKEN</code> en las peticiones que modifican estado.</li>
          <li><strong>Roles y permisos:</strong>
            <ul>
              <li><code>ADMIN</code>: CRUD de especialidades y uso del Bot Admin con acceso a consultas internas de BD.</li>
              <li><code>MEDICO</code>: gestión de citas y propuestas de horarios.</li>
              <li><code>PACIENTE</code>: solicitud y confirmación/cancelación de citas.</li>
            </ul>
          </li>
          <li><strong>Buenas prácticas aplicadas:</strong>
            <ul>
              <li>Hash de contraseña con <code>Argon2PasswordEncoder</code>.</li>
              <li>Validación de entrada con Jakarta Validation (cuando aplica).</li>
              <li>Configuración de CORS y uso de <code>SameSite</code> en cookies.</li>
              <li>No exponer credenciales ni API keys en el frontend.</li>
            </ul>
          </li>
        </ul>
      </section>

      <!-- 8. Flujo de navegación -->
      <section id="flujo-frontend">
        <h2><span class="num">08</span> Flujo de navegación (frontend)</h2>
        <p>
          Tras el login, el sistema redirige según el rol del usuario.
        </p>
        <div class="card">
          <h4>Paciente</h4>
          <p>Flujo típico:</p>
          <ul>
            <li>Inicio → Especialidades → Seleccionar médico → Proponer/confirmar horario → Ver citas.</li>
          </ul>

          <h4>Médico</h4>
          <ul>
            <li>Inicio → Notificaciones → Citas → Proponer/confirmar/atender.</li>
          </ul>

          <h4>Admin</h4>
          <ul>
            <li>Inicio → Especialidades (CRUD) → Bot Admin para consultas y métricas.</li>
          </ul>
        </div>
      </section>

      <!-- 9. Proceso desarrollo -->
      <section id="desarrollo">
        <h2><span class="num">09</span> Proceso de desarrollo y calidad</h2>
        <ul>
          <li><strong>Control de versiones:</strong> Git, con ramas típicas como <code>main</code> y <code>dev</code>.</li>
          <li><strong>Convenciones:</strong> nombres en español, paquetes organizados por capas (controlador, entidad, repositorio).</li>
          <li><strong>Testing:</strong>
            <ul>
              <li>Pruebas unitarias y manuales en flujos críticos.</li>
              <li>Validación de estados de cita y transiciones de estados.</li>
            </ul>
          </li>
          <li><strong>Aseguramiento de calidad:</strong>
            <ul>
              <li>Verificación del comportamiento de CSRF en peticiones POST.</li>
              <li>Pruebas básicas de seguridad (restricción de endpoints por rol).</li>
            </ul>
          </li>
        </ul>
      </section>

      <!-- 10. Despliegue -->
      <section id="despliegue">
        <h2><span class="num">10</span> Despliegue y entorno</h2>

        <h3>10.1 Levantar localmente</h3>
        <p><strong>Requisitos:</strong></p>
        <ul>
          <li>JDK 17</li>
          <li>Maven</li>
          <li>MySQL en <code>localhost:3306</code>, base de datos <code>reserva</code></li>
        </ul>

        <p>Configurar <code>src/main/resources/application.properties</code>:</p>
        <pre><code>spring.datasource.url=jdbc:mysql://localhost:3306/reserva?useSSL=false&amp;serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=</code></pre>

        <p>Ejecutar la aplicación:</p>
        <ul>
          <li><code>mvn spring-boot:run</code>, o</li>
          <li>Ejecutar la clase <code>ConsultasApplication</code> desde el IDE.</li>
        </ul>

        <p>Luego navegar a <code>http://localhost:8080/</code>.</p>

        <h3>10.2 Perfiles</h3>
        <p>
          El archivo <code>application.properties</code> sirve por defecto para el entorno de desarrollo local.
          Se pueden definir <code>application-dev.properties</code> y <code>application-prod.properties</code>
          para separar URLs y credenciales según ambiente.
        </p>

        <h3>10.3 Despliegue</h3>
        <ul>
          <li>Se genera un <code>.jar</code> ejecutable con Tomcat embebido.</li>
          <li>Se recomienda usar Nginx/Apache como proxy inverso frente a la instancia de CitaSys.</li>
          <li>La base de datos MySQL puede ser un servicio administrado (cloud o on-premise).</li>
          <li>El proyecto es <em>dockerizable</em> si se desea; no se incluye actualmente un <code>Dockerfile</code> en el repositorio.</li>
        </ul>
      </section>

      <!-- 11. Limitaciones -->
      <section id="limitaciones">
        <h2><span class="num">11</span> Limitaciones y trabajo futuro</h2>
        <h3>Limitaciones actuales</h3>
        <ul>
          <li>No hay envío de notificaciones por email/SMS.</li>
          <li>No existe paginación en todas las listas.</li>
          <li>No se ofrecen métricas avanzadas ni gráficos detallados para el Administrador.</li>
        </ul>

        <h3>Trabajo futuro</h3>
        <ul>
          <li>Internacionalización del frontend.</li>
          <li>Reportes y dashboards avanzados (gráficos y KPIs).</li>
          <li>Integración de recordatorios vía email o WhatsApp.</li>
          <li>Auditoría extendida y logs estructurados.</li>
          <li>Permisos más granulares por módulo.</li>
        </ul>
      </section>

      <!-- 12. Anexos -->
      <section id="anexos">
        <h2><span class="num">12</span> Anexos</h2>
        <ul>
          <li>Diagramas UML de casos de uso, clases y secuencia (opcional, recomendados).</li>
          <li>Scripts SQL de creación de la base de datos <code>reserva</code>.</li>
          <li>Capturas de las pantallas principales del sistema (por rol).</li>
          <li>Diagrama de arquitectura de alto nivel (Navegador → Backend → DB).</li>
        </ul>
      </section>

      <hr />

      <!-- README estilo GitHub -->
      <section id="readme">
        <div class="section-badge">Readme · resumen para GitHub</div>
        <h2>README — CitaSys</h2>

        <h3>Título</h3>
        <p><strong>CitaSys – Sistema de gestión de citas médicas</strong></p>

        <h3>Descripción breve</h3>
        <p>
          Aplicación web para administrar especialidades, médicos y el ciclo de vida de las citas médicas,
          con asistentes conversacionales y panel administrativo.
        </p>

        <h3>Tecnologías</h3>
        <ul>
          <li>Java 17, Spring Boot 3.5.7</li>
          <li>Spring Web, Spring Data JPA, Spring Security</li>
          <li>MySQL</li>
          <li>HTML/CSS/JS (vanilla)</li>
        </ul>

        <h3>Arquitectura (resumen)</h3>
        <ul>
          <li>Cliente (HTML/JS) que consume la API REST del backend (Spring Boot).</li>
          <li>Persistencia con JPA sobre MySQL.</li>
          <li>Seguridad basada en sesiones y CSRF.</li>
          <li>Roles: <code>ADMIN</code>, <code>MEDICO</code>, <code>PACIENTE</code>.</li>
        </ul>

        <h3>Cómo ejecutar localmente</h3>
        <p><strong>Requisitos:</strong> JDK 17, Maven, MySQL.</p>
        <p>Configurar <code>src/main/resources/application.properties</code>:</p>
        <pre><code>spring.datasource.url=jdbc:mysql://localhost:3306/reserva?useSSL=false&amp;serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=</code></pre>
        <p>Ejecutar:</p>
        <pre><code>mvn spring-boot:run</code></pre>
        <p>Luego abrir <code>http://localhost:8080/</code> en el navegador.</p>
      </section>

      <!-- Arquitectura carpetas -->
      <section id="arquitectura-carpetas">
        <h3>Arquitectura de carpetas (backend &amp; frontend)</h3>

        <h4>Backend – código Java</h4>
        <pre class="tree"><code>src/
  main/
    java/
      pe/
        uni/
          consultas/
            ConsultasApplication.java
            controlador/
              ... Controladores REST (Auth, Especialidades, Citas, Admin, Bots, etc.)
            entidad/
              ... Entidades JPA (Usuario, Cita, Especialidad, Rol, etc.)
            repositorio/
              ... Repositorios Spring Data JPA
</code></pre>

        <h4>Frontend estático</h4>
        <pre class="tree"><code>src/
  main/
    resources/
      static/
        admin/
          html/
            ... vistas del Administrador
          js/
            ... lógica JS del Administrador
        medico/
          html/
            ... vistas del Médico
          js/
            ... lógica JS del Médico
        paciente/
          html/
            ... vistas del Paciente
          js/
            ... lógica JS del Paciente
        common/
          ... componentes compartidos (bots, estilos, utilidades)
        img/
          ... iconos y recursos gráficos
        index.html    (landing / página de entrada)
        login.html    (pantalla de autenticación)</code></pre>

        <h4>Configuración</h4>
        <pre class="tree"><code>src/
  main/
    resources/
      application.properties   (configuración de entorno: BD, puertos, etc.)</code></pre>

        <h3>Endpoints principales (muestra)</h3>
        <p>Listado resumido de endpoints de referencia:</p>
        <ul>
          <li><strong>Autenticación / CSRF</strong>
            <ul>
              <li><code>POST /api/auth/csrf</code></li>
              <li><code>GET /api/auth/csrf</code></li>
            </ul>
          </li>
          <li><strong>Especialidades</strong>
            <ul>
              <li><code>GET /api/especialidades</code></li>
              <li><code>GET /api/especialidades/nombres?activas=true</code></li>
              <li><code>GET /api/especialidades/{id}/foto</code></li>
              <li><code>POST /api/especialidades</code> (ADMIN)</li>
              <li><code>PUT /api/especialidades/{id}</code> (ADMIN)</li>
              <li><code>DELETE /api/especialidades/{id}</code> (ADMIN)</li>
            </ul>
          </li>
          <li><strong>Admin Especialidades</strong>
            <ul>
              <li><code>POST /api/admin/especialidades</code></li>
              <li><code>PUT /api/admin/especialidades/{id}</code></li>
              <li><code>DELETE /api/admin/especialidades/{id}</code></li>
              <li><code>POST /api/admin/especialidades/{id}/foto</code></li>
            </ul>
          </li>
          <li><strong>Bot Admin</strong>
            <ul>
              <li><code>POST /api/admin/ai/chat</code> (solo ADMIN)</li>
            </ul>
          </li>
        </ul>

        <h3>Autor</h3>
        <p><strong>Jhostin Leonardo Rodriguez Neyra</strong><br/>Desarrollador Full Stack</p>
      </section>

      <hr />

      <!-- Notas -->
      <section id="notas">
        <h3>Notas y acciones recomendadas</h3>
        <ul>
          <li>Validar que todos los endpoints y nombres de entidades reflejen exactamente el código fuente actual, ampliando el listado de API para incluir módulos de citas y usuarios si es necesario.</li>
          <li>Añadir diagramas UML (casos de uso, clases, arquitectura) directamente en el repositorio para complementar la documentación textual.</li>
          <li>Publicar una versión en PDF o DOCX de este documento para compartir fácilmente con jefes y stakeholders.</li>
          <li>Mantener esta documentación versionada junto con el código (por ejemplo, etiquetando la versión del documento como parte del tag <code>v1.0</code> del proyecto).</li>
        </ul>
      </section>

    </div>
  </main>
</div>
</body>
</html>
