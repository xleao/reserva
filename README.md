# CitaSys – Sistema de gestión de citas médicas

**Documento Técnico Principal — CitaSys**  
- **Versión:** v1.0  
- **Fecha:** 2025-11-05  
- **Proyecto:** CitaSys – Sistema de gestión de citas médicas  
- **Autor:** Jhostin Leonardo Rodriguez Neyra – Desarrollador Full Stack  

Tecnologías clave:

- Spring Boot 3.5.7 (Java 17)
- Spring Web · Spring Security · Spring Data JPA · Validation
- MySQL
- Frontend HTML / CSS / JavaScript (vanilla)

---

## Tabla de contenido

1. [Resumen ejecutivo](#1-resumen-ejecutivo)  
2. [Objetivos y alcance](#2-objetivos-y-alcance)  
3. [Usuarios y casos de uso](#3-usuarios-y-casos-de-uso)  
4. [Arquitectura del sistema](#4-arquitectura-del-sistema)  
5. [Modelo de datos](#5modelo-de-datos)  
6. [API REST (backend)](#6-api-rest-backend)  
7. [Seguridad](#7-seguridad)  
8. [Flujo de navegación (frontend)](#8-flujo-de-navegación-frontend)  
9. [Proceso de desarrollo y calidad](#9-proceso-de-desarrollo-y-calidad)  
10. [Despliegue y entorno](#10-despliegue-y-entorno)  
11. [Limitaciones y trabajo futuro](#11-limitaciones-y-trabajo-futuro)  
12. [Anexos](#12-anexos)  

Secciones extra específicas para GitHub:

- [README rápido (resumen para el repo)](#readme-rápido-resumen-para-el-repo)  
- [Arquitectura de carpetas](#arquitectura-de-carpetas)  
- [Endpoints principales (muestra)](#endpoints-principales-muestra)  
- [Autor](#autor)  
- [Notas y acciones recomendadas](#notas-y-acciones-recomendadas)  

---

## 1. Resumen ejecutivo

CitaSys es un sistema web para gestionar el ciclo completo de citas médicas: solicitud, negociación de horarios, confirmación, atención y estados finales.

**Perfiles de usuario:**

- Administrador  
- Médico  
- Paciente  

**Principales funcionalidades:**

- Gestión de usuarios, especialidades y médicos por especialidad.  
- Flujo de citas con estados:

  `SOLICITADA`, `PROPUESTA`, `EN_NEGOCIACION`, `CONFIRMADA`, `CANCELADA`, `ATENDIDA`, `NO_ASISTIO`.  

- Bot asistente (paciente/médico) y Bot Admin con consultas a BD (conteos, listados, detalles).  
- Notificaciones y *deep links* a vistas específicas.  

**Tecnologías clave:**

- Spring Boot 3.5.7 (Java 17)  
- Spring Web, Spring Security, Spring Data JPA, Validation  
- MySQL  
- HTML / CSS / JS (vanilla)  

**Estado actual:** MVP avanzado listo para pilotos internos.

---

## 2. Objetivos y alcance

### 2.1 Objetivo general

Digitalizar y automatizar la gestión de citas, reduciendo tiempos y errores en la coordinación entre pacientes y médicos.

### 2.2 Objetivos específicos

- Automatizar la solicitud y confirmación de citas.  
- Estandarizar el flujo de negociación de horarios.  
- Centralizar el catálogo de especialidades y médicos.  
- Proveer panel de administración con métricas básicas (conteos por estado).  
- Habilitar asistentes conversacionales para orientar y operar tareas comunes.  

### 2.3 Alcance

- CRUD de especialidades.  
- Flujo de citas con negociación y cambios de estado.  
- Gestión de usuarios y roles.  
- Bot Admin con respuestas desde la base de datos (conteos, listados, detalles puntuales).  

---

## 3. Usuarios y casos de uso

### 3.1 Perfiles de usuario

**Administrador**

- **Responsabilidades:** gestionar especialidades, ver métricas, soporte.  
- **Vistas:** panel admin, gestión de especialidades, Bot Admin.  

**Médico**

- **Responsabilidades:** proponer horarios, confirmar/cancelar, marcar atención o no-asistencia.  
- **Vistas:** panel médico, notificaciones, citas.  

**Paciente**

- **Responsabilidades:** solicitar cita, negociar, confirmar/cancelar.  
- **Vistas:** panel paciente, especialidades, selección de médico, citas.  

### 3.2 Casos de uso principales

- Crear/gestionar especialidades (Admin).  
- Solicitar/negociar/confirmar una cita (Paciente/Médico).  
- Aprobar/rechazar propuestas (Médico/Paciente).  
- Ver reportes simples de citas por estado (Admin vía Bot).  
- Listar usuarios, médicos y especialidades (Admin vía Bot).  

> Opcional: diagrama UML de casos de uso (Actores: Admin, Médico, Paciente;  
> Casos: Gestionar especialidad, Solicitar cita, Proponer horario, Confirmar cita, Consultar métricas).

---

## 4. Arquitectura del sistema

### 4.1 Vista general

Arquitectura **cliente–servidor**:

- **Frontend:** HTML5, CSS3, JS (vanilla). Páginas por rol en `static/{rol}/...`.  
- **Backend:** Spring Boot REST.  
- **Base de datos:** MySQL.  

Capas por convención:

- `Controller → Repository → DB`  
- Entidades JPA bajo `pe.uni.consultas.entidad`.  

**Esquema de alto nivel:**

    Navegador (Paciente / Médico / Admin)
          ↓  (HTTP/HTTPS · JSON)
    Servidor Spring Boot (CitaSys API)
          ↓  (JPA / JDBC)
    Base de datos MySQL (schema: reserva)

### 4.2 Tecnologías usadas

**Backend**

- Java 17, Spring Boot 3.5.7  
- Spring Web, Spring Security, Spring Data JPA, Validation  
- `Argon2PasswordEncoder` (security-crypto) para hash de contraseñas  
- MySQL Connector/J  
- H2 (opcional en desarrollo)  

**Frontend**

- HTML5, CSS3, JavaScript (vanilla)  

**Herramientas**

- Maven  
- Git  
- IDE: IntelliJ IDEA / VS Code  
- Apache POI (opcional, exportación XLSX)  

### 4.3 Estructura de paquetes (backend)

Paquete raíz: `pe.uni.consultas`

- `controlador` – Controladores REST (Auth, Especialidades, Citas, Admin, Bots, etc.).  
- `repositorio` – Interfaces Spring Data JPA.  
- `entidad` – Entidades JPA que representan las tablas de la BD.  
- `config` – Configuración de seguridad/CORS (según repo).  

**Responsabilidades por capa:**

- **Controller:** recibe solicitudes HTTP, valida básico y delega.  
- **Repository:** acceso a la BD con JPA (consultas derivadas/nativas).  
- **Entity:** mapeo de tablas a clases Java con anotaciones JPA.  

### 4.4 Estructura del frontend

- `/static/{rol}/html/...`  
- `/static/{rol}/js/...`
- `/static/{rol}/css/...` 
- `/static/common/...` – componentes compartidos (bots, estilos, utilidades).  

La navegación se realiza mediante enlaces y botones por rol.  
JavaScript utiliza `fetch` hacia `/api/...` y maneja el token CSRF en `POST/PUT/DELETE`.

---

## 5.modelo de datos

### 5.1 Entidades clave

**Usuario (`usuario`)**

- `id_usuario`, `email`, `password_hash`, `nombres`, `apellidos`, `telefono`, `dni`, `estado`, `fecha_creacion`  
- Foto: `foto_url`, `foto_blob`, `foto_mime`, `foto_actualizado`  

**Cita (`cita`)**

- `id_cita`, `id_paciente`, `id_medico`  
- `fecha_hora` (confirmada), `propuesta_fecha_hora`, `confirmada_fecha_hora`  
- `canal`: `PRESENCIAL` | `TELECONSULTA`  
- `estado`:

  `SOLICITADA`, `PROPUESTA`, `EN_NEGOCIACION`, `CONFIRMADA`, `CANCELADA`, `ATENDIDA`, `NO_ASISTIO`  

- `ultima_propuesta_por`: `PACIENTE` | `MEDICO`  

**Especialidad (`especialidad`)**

- `id_especialidad`, `nombre`, `descripcion`, `activo`  
- Medios: `foto_url`, `foto_blob`, `foto_mime`, `foto_actualizado`  

### 5.2 Relaciones

- Un **Usuario** se asocia a uno o más roles con la tabla intermedia `usuario_rol` y la tabla `rol`.  
- Una **Cita** referencia al usuario paciente y al usuario médico mediante FKs.  
- La relación Médico–Especialidad se gestiona con la tabla `medico_especialidad`.  

### 5.3 Tablas principales

- `usuario`: datos personales, credenciales hash y estado.  
- `cita`: relación paciente–médico, estado y fechas clave.  
- `especialidad`: catálogo de especialidades, activo/inactivo, medios.  
- `rol`, `usuario_rol`: seguridad basada en roles.  
- `medico_especialidad`: asignación de especialidades a médicos.  

---

## 6. API REST (backend)

### 6.1 Convenciones generales

- **Base URL:** `/api/...`  
- **Formato:** JSON  
- **Autenticación:** sesiones HTTP gestionadas por Spring Security.  
- **CSRF:** habilitado para `POST`, `PUT`, `DELETE`.  
- **Roles:** `ADMIN`, `MEDICO`, `PACIENTE` (y/o `USER` según configuración).  

### 6.2 Endpoints principales

#### Autenticación / CSRF

- `POST /api/auth/csrf` – entrega token CSRF para el frontend.  
- `GET /api/auth/csrf`  
- `HEAD /api/auth/csrf`  
- `OPTIONS /api/auth/csrf` – token y metadatos CSRF.  

> El login/logout completo puede residir en otro controlador del proyecto, de acuerdo con la configuración de Spring Security y sesiones.

#### Especialidades (público autenticado)

- `GET /api/especialidades` – lista detallada (filtrable por `activas` y `q`).  
- `GET /api/especialidades/nombres?activas=true|false` – devuelve solo `id` y `nombre`.  
- `GET /api/especialidades/{id}/foto` – obtiene foto (blob o redirección 302 hacia URL).  
- `POST /api/especialidades` (**ADMIN**) – crear especialidad.  
- `PUT /api/especialidades/{id}` (**ADMIN**) – actualizar.  
- `DELETE /api/especialidades/{id}` (**ADMIN**) – eliminar o desactivar.  
- `POST /api/especialidades/{id}/foto` (**ADMIN**, multipart) – subir foto como blob.  
- `DELETE /api/especialidades/{id}/foto` (**ADMIN**) – borrar foto.  
- `PUT /api/especialidades/{id}/foto-url` (**ADMIN**) – definir URL de foto.  

#### Admin Especialidades (área admin)

Base: `/api/admin/especialidades`  

- Endpoints CRUD equivalentes, con validaciones administrativas adicionales sobre referencias y consistencia.  

#### Bot Admin

- `POST /api/admin/ai/chat` (**solo ADMIN**)  

Permite:

- Conteos de citas por estado/fechas.  
- Detalle de cita por ID.  
- Listado de próximas citas.  
- Listado de nombres de usuarios, médicos, pacientes y especialidades.  
- Interpretar expresiones como “sus nombres” según contexto.  

#### Citas / Notificaciones / Usuarios

El proyecto incluye controladores y páginas específicas para paciente y médico que cubren:

- Flujos de solicitud, negociación y cambio de estado de citas.  
- Gestión de notificaciones y deep links a vistas relevantes.  
- Listados de citas filtrados por rol y estado.  

### 6.3 Ejemplos de request/response

**Obtener nombres de especialidades activas**

`GET /api/especialidades/nombres?activas=true`

    [
      { "id": 1, "nombre": "Cardiología" },
      { "id": 2, "nombre": "Dermatología" }
    ]

**Consulta al Bot Admin**

`POST /api/admin/ai/chat`

_Request:_

    {
      "messages": [
        { "role": "user", "content": "¿Cuántos médicos hay?" }
      ]
    }

_Response:_

    {
      "ok": true,
      "reply": "Hay 7 médicos registrados en el sistema."
    }

---

## 7. Seguridad

- **Autenticación:** sesiones HTTP con Spring Security (`JSESSIONID`).  
- **CSRF:** habilitado; el frontend envía el token en el header `X-XSRF-TOKEN`.  

**Roles y permisos:**

- `ADMIN`: CRUD de especialidades y uso del Bot Admin con consultas internas de BD.  
- `MEDICO`: gestión de citas y propuestas.  
- `PACIENTE`: solicitud y confirmación / cancelación de citas.  

**Buenas prácticas aplicadas:**

- Hash de contraseña con `Argon2PasswordEncoder`.  
- Validación de entrada con Jakarta Validation (donde aplica).  
- CORS configurado; uso de `SameSite` en cookies.  
- No se exponen credenciales ni API keys en el frontend.  

---

## 8. Flujo de navegación (frontend)

Tras el login, el usuario es redirigido según su rol.

**Paciente**

- Inicio → Especialidades → Seleccionar médico → Proponer/confirmar → Ver citas.  

**Médico**

- Inicio → Notificaciones → Citas → Proponer/confirmar/atender.  

**Administrador**

- Inicio → Especialidades (CRUD) → Bot Admin para consultas y métricas.  

---

## 9. Proceso de desarrollo y calidad

- **Control de versiones:** Git (ramas típicas `main` y `dev`).  
- **Convenciones:** nombres en español, paquetes por capas (`controlador`, `entidad`, `repositorio`).  

**Testing:**

- Pruebas unitarias y manuales en flujos críticos.  
- Validación de estados de cita y de transiciones entre estados.  

**Aseguramiento de calidad (QA):**

- Verificación del comportamiento de CSRF en peticiones `POST`.  
- Pruebas básicas de seguridad (restricción de endpoints según rol).  

---

## 10. Despliegue y entorno

### 10.1 Levantar localmente

**Requisitos:**

- JDK 17  
- Maven  
- MySQL en `localhost:3306`, base de datos `reserva`  

Configurar `src/main/resources/application.properties`:

    spring.datasource.url=jdbc:mysql://localhost:3306/reserva?useSSL=false&serverTimezone=UTC
    spring.datasource.username=root
    spring.datasource.password=

Ejecutar la aplicación:

    mvn spring-boot:run
    # o desde el IDE ejecutando ConsultasApplication

Luego navegar a: `http://localhost:8080/`.

### 10.2 Perfiles

- `application.properties` sirve por defecto para desarrollo local.  
- Pueden definirse `application-dev.properties` y `application-prod.properties` para separar configuraciones por entorno (URLs de BD, credenciales, etc.).  

### 10.3 Despliegue

- Se genera un `.jar` ejecutable con Tomcat embebido.  
- Se recomienda Nginx/Apache como proxy inverso delante de CitaSys.  
- La base de datos MySQL puede ser un servicio administrado (cloud o on-premise).  
- El proyecto es *dockerizable*; actualmente no se incluye `Dockerfile` en el repositorio.  

---

## 11. Limitaciones y trabajo futuro

### Limitaciones actuales

- No hay notificaciones por email/SMS.  
- No hay paginación en todas las listas.  
- No hay métricas avanzadas ni dashboards gráficos para Admin.  

### Trabajo futuro

- Internacionalización del frontend.  
- Reportes y dashboards avanzados (gráficos, KPIs).  
- Integración de recordatorios por email o WhatsApp.  
- Auditoría extendida y logs estructurados.  
- Permisos más granulares por módulo.  

---

## 12. Anexos

No incluidos en este README pero recomendados dentro del repo:

- Diagramas UML (casos de uso, clases, secuencia).  
- Scripts SQL para la creación de la BD `reserva`.  
- Capturas de las pantallas principales (por rol).  
- Diagrama de arquitectura de alto nivel (Navegador → Backend → DB).  

---

## README rápido (resumen para el repo)

Esta sección es la versión “corta” del proyecto, pensada para quien entra rápido al repositorio.

### Título

**CitaSys – Sistema de gestión de citas médicas**

### Descripción breve

Aplicación web para administrar especialidades, médicos y el ciclo de vida de las citas médicas, con asistentes conversacionales y panel administrativo.

### Tecnologías

- Java 17, Spring Boot 3.5.7  
- Spring Web, Spring Data JPA, Spring Security  
- MySQL  
- HTML / CSS / JavaScript (vanilla)  

### Arquitectura (resumen)

- Cliente (HTML/JS) consume la API REST del backend (Spring Boot).  
- Persistencia con JPA sobre MySQL.  
- Seguridad con sesiones + CSRF.  
- Roles: `ADMIN`, `MEDICO`, `PACIENTE`.  

### Cómo ejecutar localmente

**Requisitos:** JDK 17, Maven, MySQL.

Configurar `src/main/resources/application.properties`:

    spring.datasource.url=jdbc:mysql://localhost:3306/reserva?useSSL=false&serverTimezone=UTC
    spring.datasource.username=root
    spring.datasource.password=

Ejecutar:

    mvn spring-boot:run

Abrir en el navegador:

    http://localhost:8080/

---

## Arquitectura de carpetas

### Backend – código Java

    src/
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

### Frontend estático

    src/
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
            login.html    (pantalla de autenticación)

### Configuración

    src/
      main/
        resources/
          application.properties   (configuración de entorno: BD, puertos, etc.)

---

## Endpoints principales (muestra)

Listado resumido de endpoints de referencia:

### Autenticación / CSRF

- `POST /api/auth/csrf`  
- `GET /api/auth/csrf`  

### Especialidades

- `GET /api/especialidades`  
- `GET /api/especialidades/nombres?activas=true`  
- `GET /api/especialidades/{id}/foto`  
- `POST /api/especialidades` (**ADMIN**)  
- `PUT /api/especialidades/{id}` (**ADMIN**)  
- `DELETE /api/especialidades/{id}` (**ADMIN**)  

### Admin Especialidades

- `POST /api/admin/especialidades`  
- `PUT /api/admin/especialidades/{id}`  
- `DELETE /api/admin/especialidades/{id}`  
- `POST /api/admin/especialidades/{id}/foto`  

### Bot Admin

- `POST /api/admin/ai/chat` (**solo ADMIN**)  

> Nota: El proyecto contiene más endpoints para gestión de citas, notificaciones y usuarios, alineados con el modelo de datos y flujos descritos en este documento.

---

## Autor

**Jhostin Leonardo Rodriguez Neyra**  
Desarrollador Full Stack  

---

## Notas y acciones recomendadas

- Validar que todos los endpoints y nombres de entidades reflejen exactamente el código fuente actual, ampliando el listado de API para incluir todos los módulos de citas y usuarios.  
- Añadir al repositorio los diagramas UML (casos de uso, clases, arquitectura) y los scripts SQL.  
- Publicar una versión en PDF o DOCX de esta documentación para compartir con jefes y stakeholders.  
- Versionar esta documentación junto con el código (por ejemplo, tag `v1.0`).  
