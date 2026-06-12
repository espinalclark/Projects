# Puyu IoT GPS Platform — External Pentest Report

![Type](https://img.shields.io/badge/type-black--box-black?style=flat-square)
![Hosts](https://img.shields.io/badge/hosts-3-blue?style=flat-square)
![Findings](https://img.shields.io/badge/findings-19-critical?style=flat-square&color=C0392B)
![Methodology](https://img.shields.io/badge/methodology-OWASP%20%2F%20PTES-orange?style=flat-square)
![Status](https://img.shields.io/badge/status-completed-green?style=flat-square)

Black-box external penetration test against a production GPS IoT platform running across three servers. Assessment performed without prior credentials, from public internet, following OWASP Testing Guide v4.2 and PTES methodology.

> All data that could identify the client has been redacted. This report is published for portfolio purposes with client authorization.

---

## Scope

| Host | Services |
|------|----------|
| `HOST-A` | Jenkins CI/CD |
| `HOST-B` | Grafana · Laravel · phpMyAdmin · MySQL |
| `HOST-C` | Wiki.js · Spring Boot · Kong API Gateway · MySQL · SSH |

---

## Executive Summary

19 findings across three hosts. HOST-C carries the highest risk: a publicly accessible Wiki.js instance without authentication exposes the complete infrastructure architecture, including an SSH access script with `root` credentials. Combined with no brute-force protection on SSH, this represents a direct path to full server compromise.

| Severity | Count |
|----------|-------|
| 🔴 Critical | 3 |
| 🟠 High | 5 |
| 🟡 Medium | 5 |
| 🟢 Low | 4 |
| ⚪ Info | 2 |

---

## Top Findings

### 🔴 F-C-01 — Wiki.js public without authentication · CVSS 9.1
Internal documentation accessible from the internet with no auth. Exposed full microservices architecture, SSH access scripts, service configuration (Kafka, Redis, PostgreSQL, MongoDB), external API tokens and internal team details.

### 🔴 F-C-02 — `tunnels.sh` with root SSH exposed · CVSS 9.8
The wiki publicly documented a shell script used by the dev team to connect to the production server — including the `root` user, public IP and full internal port map. Combined with F-C-08 (no brute-force protection), the only barrier to full compromise is root password strength.

### 🔴 F-B-01 — Grafana default credentials `admin:admin` · CVSS 9.8
Immediate admin access to the monitoring panel. PostgreSQL datasources with internal connection strings exposed, including production GPS database configuration.

### 🟠 F-C-08 — SSH root without brute-force protection · CVSS 8.1
Password authentication enabled for `root`. Over 2,000 consecutive login attempts with `hydra` triggered zero defensive response — no `fail2ban`, no rate limiting, no IP blocking.

### 🟠 F-B-03 — Laravel Debug Mode active in production · CVSS 7.5
`APP_DEBUG=true` on production. HTTP errors returned full stack traces with absolute server paths, dependency versions and database connection configuration.

---

## Methodology

```
Reconnaissance → Enumeration → Vulnerability Analysis → Exploitation → Documentation
     nmap            curl           nuclei              hydra           LaTeX report
   whatweb       feroxbuster      manual review        mysql-client
```

Phases followed OWASP Testing Guide v4.2 and PTES. Assessment type: black-box, external, no prior credentials.

---

## Tools

| Tool | Purpose |
|------|---------|
| `nmap` | Port scanning and service detection |
| `whatweb` | Web technology fingerprinting |
| `feroxbuster` | Directory enumeration |
| `nuclei` | Automated vulnerability detection |
| `curl` | HTTP header and endpoint inspection |
| `hydra` | SSH brute-force rate limiting test |
| `mysql-client` | Exposed MySQL access verification |

---

## MITRE ATT&CK Coverage

| Tactic | Technique | Finding |
|--------|-----------|---------|
| Reconnaissance | T1595.001 — Active Scanning | All hosts |
| Reconnaissance | T1596.005 — SSL Certificate enumeration | F-C-11 |
| Reconnaissance | T1213 — Wiki public recon | F-C-01 |
| Initial Access | T1078.001 — Default credentials | F-B-01 |
| Credential Access | T1110.001 — SSH brute force | F-C-08 |
| Credential Access | T1552.001 — Credentials in wiki | F-C-02 |
| Discovery | T1046 — Network service scanning | F-C-10 |
| Discovery | T1083 — Directory listing | F-B-04 |
| Collection | T1530 — DB access via Grafana | F-B-02 |
| Defense Evasion | T1082 — Stack traces with system info | F-C-04 |

---

## Report

| File | Description |
|------|-------------|
| [`Report/INFORME_portfolio.pdf`](Report/INFORME_portfolio.pdf) | Full pentest report (client data redacted) |
| [`Report/INFORME_portfolio.tex`](Report/INFORME_portfolio.tex) | LaTeX source |
| [`assets/`](assets/) | Evidence screenshots (sensitive data redacted) |

---

## Author

**Clark Espinal** — Penetration Tester  
[clarkportafolio.vercel.app](https://clarkportafolio.vercel.app) · [linkedin.com/in/espinalclark](https://linkedin.com/in/espinalclark) · [github.com/espinalclark](https://github.com/espinalclark)

---

> ⚠️ This report documents an authorized external penetration test. All techniques described must not be applied against infrastructure without explicit written authorization from the owner.
