<div align="center">

```text
 █████╗ ██╗    ██╗███████╗
██╔══██╗██║    ██║██╔════╝
███████║██║ █╗ ██║███████╗
██╔══██║██║███╗██║╚════██║
██║  ██║╚███╔███╔╝███████║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝

███╗   ███╗██╗███████╗ ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
████╗ ████║██║██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
██╔████╔██║██║███████╗██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
██║╚██╔╝██║██║╚════██║██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
██║ ╚═╝ ██║██║███████║╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
╚═╝     ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
```

# AWS Misconfiguration Lab

### Cloud Pentesting · IAM Privilege Escalation · SSRF · Lambda RCE · Secrets Harvesting

![AWS](https://img.shields.io/badge/AWS-Offensive%20Security-orange?style=for-the-badge)
![Terraform](https://img.shields.io/badge/Terraform-Infrastructure-blueviolet?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Pentesting-red?style=for-the-badge)

</div>

---

## Overview

Este proyecto simula una infraestructura corporativa en AWS con múltiples configuraciones inseguras diseñadas para reproducir escenarios reales de compromiso en entornos cloud.

El laboratorio permite practicar:

- Enumeración AWS
- SSRF hacia IMDSv1
- Robo de credenciales temporales
- IAM Privilege Escalation
- Lambda Command Injection
- Secrets Harvesting
- Persistencia mediante IAM Backdoors
- Análisis de impacto y remediación

---

## Attack Chain

```text
Internet
   │
   ▼
SSRF Vulnerability
   │
   ▼
IMDSv1 Metadata Access
   │
   ▼
Temporary AWS Credentials
   │
   ▼
S3 Enumeration
   │
   ▼
IAM Recon
   │
   ▼
AssumeRole Abuse
   │
   ▼
Lambda RCE
   │
   ▼
Secrets Extraction
   │
   ▼
Persistence
   │
   ▼
Full AWS Account Compromise
```

---

## Infrastructure

```text
┌──────────────────────────┐
│      Public EC2          │
│  Vulnerable Web App      │
└────────────┬─────────────┘
             │
             ▼
      IMDSv1 Enabled
             │
             ▼
┌──────────────────────────┐
│       IAM Role           │
│   Excessive Privileges   │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│      Lambda Function     │
│  Command Injection RCE   │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ Secrets Manager / SSM    │
│ Sensitive Credentials    │
└──────────────────────────┘
```

---

## Findings

| ID | Vulnerability | Severity |
|----|---------------|----------|
| F01 | SSRF to IMDSv1 | Critical |
| F02 | Credential Exposure | Critical |
| F03 | S3 Sensitive Data Exposure | High |
| F04 | IAM Enumeration | High |
| F05 | Privilege Escalation via AssumeRole | Critical |
| F06 | Lambda Command Injection | Critical |
| F07 | Secrets Manager Exposure | High |
| F08 | IAM Persistence Backdoor | Critical |
| F09 | CloudTrail Disabled | Medium |

---

## Project Structure

```bash
aws-misconfig-lab/
├── terraform/
│   ├── modules/
│   ├── main.tf
│   └── variables.tf
│
├── attack/
│   ├── enum_roles.py
│   ├── secret_dumper.py
│   └── refresh_credentials.sh
│
├── screenshots/
│   ├── attack/
│   └── infrastructure/
│
├── report/
│   ├── INFORME.pdf
│   └── INFORME.tex
│
└── README.md
```

---

## Skills Demonstrated

```yaml
Cloud Security:
  - AWS IAM
  - EC2
  - Lambda
  - S3
  - Secrets Manager
  - SSM

Offensive Security:
  - Reconnaissance
  - SSRF
  - Credential Access
  - Privilege Escalation
  - Persistence

Infrastructure:
  - Terraform
  - Linux
  - Bash
  - Python

Reporting:
  - Technical Documentation
  - Risk Assessment
  - Executive Reporting
```

---

## Sample Enumeration

```bash
aws sts get-caller-identity

aws iam list-roles

aws s3 ls

aws lambda list-functions

aws secretsmanager list-secrets

aws ssm describe-parameters
```

---

## Report

```bash
report/INFORME.pdf
```

Incluye:

- Arquitectura del laboratorio
- Cadena completa de ataque
- Evidencias técnicas
- Hallazgos clasificados por severidad
- Remediaciones
- Análisis de impacto

---

## Disclaimer

```text
This project was built exclusively for educational and
authorized security testing purposes.

All vulnerabilities are intentionally deployed inside a
controlled AWS environment owned by the author.

Do not attempt these techniques against systems without
explicit authorization.
```

---

<div align="center">

```text
root@aws-lab:~# whoami

cloud-pentester

root@aws-lab:~# mission_status

[✓] Initial Access
[✓] Credential Access
[✓] Privilege Escalation
[✓] Persistence
[✓] Documentation

STATUS: COMPLETE
```

</div>

