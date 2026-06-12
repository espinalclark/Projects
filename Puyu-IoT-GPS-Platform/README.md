# Cliente GPS IoT — Informe de Pentesting Externo

![Tipo](https://img.shields.io/badge/tipo-black--box-black?style=flat-square)
![Hosts](https://img.shields.io/badge/hosts-3-blue?style=flat-square)
![Hallazgos](https://img.shields.io/badge/hallazgos-19-critical?style=flat-square&color=C0392B)
![Metodología](https://img.shields.io/badge/metodolog%C3%ADa-OWASP%20%2F%20PTES-orange?style=flat-square)
![Estado](https://img.shields.io/badge/estado-completado-green?style=flat-square)

Prueba de penetración externa de caja negra contra una plataforma GPS IoT en producción distribuida en tres servidores. Evaluación realizada sin credenciales previas, desde internet público, siguiendo OWASP Testing Guide v4.2 y PTES.

> Todos los datos que pudieran identificar al cliente han sido redactados.

---

## Alcance

| Host | Servicios |
|------|-----------|
| `HOST-A` | Jenkins CI/CD |
| `HOST-B` | Grafana · Laravel · phpMyAdmin · MySQL |
| `HOST-C` | Wiki.js · Spring Boot · Kong API Gateway · MySQL · SSH |

---

## Resumen Ejecutivo

19 hallazgos distribuidos en tres hosts. HOST-C concentra el mayor riesgo: una instancia de Wiki.js accesible sin autenticación expone la arquitectura completa de la infraestructura, incluyendo un script de acceso SSH como `root`. Combinado con la ausencia de protección anti-bruteforce en SSH, existe un vector directo hacia el compromiso total del servidor.

| Severidad | Cantidad |
|-----------|----------|
| 🔴 Crítico | 3 |
| 🟠 Alto    | 5 |
| 🟡 Medio   | 5 |
| 🟢 Bajo    | 4 |
| ⚪ Info    | 2 |

---

## Hallazgos Principales

### 🔴 F-C-01 — Wiki.js pública sin autenticación · CVSS 9.1
Documentación técnica interna accesible desde internet sin ningún control de acceso. Expone arquitectura completa de microservicios, scripts de acceso SSH, configuración de servicios (Kafka, Redis, PostgreSQL, MongoDB), tokens de APIs externas y datos del equipo interno.

### 🔴 F-C-02 — `tunnels.sh` con acceso root SSH expuesto · CVSS 9.8
La wiki documenta públicamente el script usado por el equipo para conectarse al servidor de producción, incluyendo el usuario `root`, la IP pública y el mapa completo de puertos internos. Combinado con F-C-08, el único factor que previene el compromiso total es la fortaleza de la contraseña de root.

### 🔴 F-B-01 — Grafana con credenciales por defecto `admin:admin` · CVSS 9.8
Acceso administrativo inmediato al panel de monitoreo. Datasources de PostgreSQL con cadenas de conexión a bases de datos internas expuestas, incluyendo configuración de la base de datos GPS de producción.

### 🟠 F-C-08 — SSH root sin protección anti-bruteforce · CVSS 8.1
Autenticación por contraseña habilitada para `root`. Más de 2.000 intentos consecutivos con `hydra` sin respuesta defensiva del servidor — sin `fail2ban`, sin rate limiting, sin bloqueo de IP.

### 🟠 F-B-03 — Laravel Debug Mode activo en producción · CVSS 7.5
`APP_DEBUG=true` en producción. Los errores HTTP devuelven stacktraces completos con rutas absolutas del servidor, versiones de dependencias y configuración de conexión a base de datos.

---

## Metodología

```
Reconocimiento → Enumeración → Análisis de vulns → Explotación → Documentación
     nmap            curl           nuclei             hydra        Informe LaTeX
   whatweb       feroxbuster     revisión manual    mysql-client
```

Fases siguiendo OWASP Testing Guide v4.2 y PTES. Tipo: caja negra, externo, sin credenciales previas.

---

## Herramientas

| Herramienta | Uso |
|-------------|-----|
| `nmap` | Escaneo de puertos y detección de servicios |
| `whatweb` | Fingerprinting de tecnologías web |
| `feroxbuster` | Enumeración de directorios |
| `nuclei` | Detección automatizada de vulnerabilidades |
| `curl` | Inspección de cabeceras y endpoints HTTP |
| `hydra` | Prueba de rate limiting en SSH |
| `mysql-client` | Verificación de acceso a MySQL expuesto |

---

## MITRE ATT&CK

| Táctica | Técnica | Hallazgo |
|---------|---------|----------|
| Reconnaissance | T1595.001 — Escaneo activo de puertos | Todos |
| Reconnaissance | T1596.005 — Enumeración via certificado SSL | F-C-11 |
| Reconnaissance | T1213 — Reconocimiento via wiki pública | F-C-01 |
| Initial Access | T1078.001 — Credenciales por defecto | F-B-01 |
| Credential Access | T1110.001 — Bruteforce SSH | F-C-08 |
| Credential Access | T1552.001 — Credenciales en texto claro en wiki | F-C-02 |
| Discovery | T1046 — Escaneo de servicios expuestos | F-C-10 |
| Discovery | T1083 — Directory listing en phpMyAdmin | F-B-04 |
| Collection | T1530 — Acceso a datasources DB via Grafana | F-B-02 |
| Defense Evasion | T1082 — Stacktraces con información del sistema | F-C-04 |

---

## Archivos

| Archivo | Descripción |
|---------|-------------|
| [`Report/INFORME.pdf`](Report/INFORME.pdf) | Informe completo (datos del cliente redactados) |
| [`Report/INFORME.tex`](Report/INFORME.tex) | Fuente LaTeX |

---

## Autor

**Clark Espinal** — Penetration Tester  
[clarkportafolio.vercel.app](https://clarkportafolio.vercel.app) · [linkedin.com/in/espinalclark](https://linkedin.com/in/espinalclark) · [github.com/espinalclark](https://github.com/espinalclark)

---

