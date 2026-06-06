<div align="center">
█████╗ ██████╗      █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗    ██╗      █████╗ ██████╗
██╔══██╗██╔══██╗    ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝    ██║     ██╔══██╗██╔══██╗
███████║██║  ██║    ███████║   ██║      ██║   ███████║██║     █████╔╝     ██║     ███████║██████╔╝
██╔══██║██║  ██║    ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗     ██║     ██╔══██║██╔══██╗
██║  ██║██████╔╝    ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗    ███████╗██║  ██║██████╔╝
╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═════╝

**`AD-ATTACK-LAB`** — Full Active Directory Red Team Simulation

![Status](https://img.shields.io/badge/status-completed-brightgreen?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Windows%20Server%202019-blue?style=flat-square)
![Domain](https://img.shields.io/badge/domain-corp.local-red?style=flat-square)
![Hosts](https://img.shields.io/badge/hosts-4%20VMs-orange?style=flat-square)
![Type](https://img.shields.io/badge/type-red--team-darkred?style=flat-square)
![Author](https://img.shields.io/badge/author-Clark%20Espinal-purple?style=flat-square)

> De zero credentials a Domain Admin con metodología profesional de red team interno.
> LLMNR poisoning → credential attacks → pivoting → ACL abuse → DCSync → Golden Ticket → persistencia.

</div>

---

## `> whoami`
Laboratorio de Active Directory construido desde cero para simular
un engagement real de red team interno. Sin guías. Sin walkthroughs.
Metodología ofensiva profesional aplicada paso a paso.
Objetivo: corp.local
Resultado: Domain Admin + DCSync + Golden Ticket + DSRM backdoor

---

## `> ifconfig`
┌─────────────────────────────────────────────────────────────┐
│                RED EXTERNA — 192.168.1.0/24                 │
│                                                             │
│   [KALI]  192.168.1.3          [WS01]  192.168.1.5         │
│   Atacante                     Pivot / Dual-NIC             │
└─────────────────────────────────────────────────────────────┘
│
Ligolo-ng tunnel
│
┌─────────────────────────────────────────────────────────────┐
│                RED INTERNA — 10.10.10.0/24                  │
│                                                             │
│   [DC01]    10.10.10.10    Domain Controller / CA           │
│   [FILE01]  10.10.10.20    File Server                      │
│   [WS01]    10.10.10.30    Pivot (dual-NIC)                 │
│   [WS02]    10.10.10.40    Workstation / MSSQL              │
│                                                             │
│   Dominio: corp.local                                       │
└─────────────────────────────────────────────────────────────┘

---

## `> cat credentials.txt`
usuario       password        hash NTLM                          origen
──────────────────────────────────────────────────────────────────────────────
j.smith       Password123!    2b576acbe6bcfda7294d6bd18041b8fe   LLMNR poisoning
m.jones       Welcome1        cf3a5525ee9414229e66279623ed5c58   AS-REP Roasting
svc_sql       Summer2024!     72f0eefcc213ea8f350773b831cf2c9c   Kerberoasting
svc_backup    Backup2024!     dda1e66a984215e9f233baf23c316bc6   texto claro FILE01
Administrator (domain)        520126a03f5d5a8d836f1c4f34ede7ce   DCSync
krbtgt        -               4d2b88171d53437c365166048fd65a24   DCSync ← Golden Ticket

---

## `> cat attack_chain.txt`
FASE 00 — Zero Credentials
│
│  Responder → LLMNR/NBT-NS poisoning
│  WS01 intenta resolver \FILE01\it-tools\ via GPO
│  NTLMv2 hash de j.smith capturado
│  Hashcat → Password123!
│
├─► FASE 01 — Enumeración
│
│  netexec smb → Pwn3d! en WS01
│  psexec → SYSTEM en WS01
│  ldapdomaindump → usuarios, grupos, ACLs
│  nmap → DC01, FILE01, WS01, WS02
│  Hallazgos: m.jones (AS-REP) | svc_sql (Kerberoastable)
│
├─► FASE 02 — Credential Attacks
│
│  AS-REP Roasting → m.jones → Welcome1
│  Kerberoasting   → svc_sql → Summer2024!
│  Clock skew +2h  → resuelto con faketime
│
├─► FASE 03 — Pivoting
│
│  Ligolo-ng agent → WS01
│  Tunnel: Kali → WS01 → 10.10.10.0/24
│  ip route add 10.10.10.0/24 dev ligolo
│
├─► FASE 04 — Lateral Movement
│
│  smbclient → FILE01 share /data con m.jones
│  config.ini   → svc_sql:Summer2024!
│  it-notes.txt → svc_backup:Backup2024!
│
├─► FASE 05 — Privilege Escalation (ACL Abuse)
│
│  bloodyAD get writable → svc_backup tiene WriteDACL sobre Domain Admins
│  ForceChangePwd: m.jones → svc_backup:Hacked123!
│  WriteDACL → add genericAll → add groupMember
│  svc_backup → Domain Admin ✅
│
├─► FASE 06 — Domain Compromise
│
│  DCSync → impacket-secretsdump → NTDS.dit completo
│  Golden Ticket → krbtgt hash → Administrator.ccache
│  PTH → SYSTEM en WS02 y FILE01
│
└─► FASE 07 — Persistencia
│
DSRM backdoor → DsrmAdminLogonBehavior=2
WIN-FIAQQKE3IKT\Administrator (Pwn3d!) ← backdoor permanente

---

## `> ls -la misconfigs/`

| Misconfiguracion | Host | Vector |
|-----------------|------|--------|
| LLMNR/NBT-NS habilitado | Red | Initial foothold |
| GPO net use sin UNC validation | WS01 | LLMNR trigger |
| AS-REP Roasting (DONT_REQ_PREAUTH) | DC01 | m.jones hash |
| Kerberoasting (SPN registrado) | DC01 | svc_sql TGS |
| Credenciales en texto claro | FILE01 | config.ini / it-notes.txt |
| WriteDACL sobre Domain Admins | DC01 | ACL abuse → DA |
| ForceChangePassword | DC01 | svc_backup takeover |
| SMB signing deshabilitado | WS02 | relay attack |
| UAC remoto deshabilitado | WS02 | PTH local |
| DSRM habilitado para login remoto | DC01 | backdoor permanente |

---

## `> tree attack/`
attack/
├── 00_zero_creds/          LLMNR poisoning + hashcat
├── 01_enumeration/         ldapdomaindump + nmap + ad_recon.py
├── 02_credential_attacks/  AS-REP + Kerberoasting
├── 03_pivoting/            Ligolo-ng tunnel
├── 04_lateral_movement/    SMB + loot FILE01
├── 05_privesc/             ACL abuse → Domain Admin
├── 06_domain_compromise/   DCSync + Golden Ticket + PTH
└── 07_persistence/         DSRM backdoor

---

## `> cat tools.txt`

| Herramienta | Uso |
|-------------|-----|
| `Responder` | LLMNR/NBT-NS poisoning |
| `Hashcat` | Cracking offline NTLMv2 / TGS / AS-REP |
| `impacket` | psexec, secretsdump, GetNPUsers, GetUserSPNs, ticketer |
| `netexec` | SMB/WinRM/MSSQL enumeration y ejecucion |
| `bloodyAD` | ACL abuse — WriteDACL, GenericAll, groupMember |
| `Ligolo-ng` | Pivoting transparente sin proxychains |
| `ldapdomaindump` | Dump completo de objetos AD via LDAP |
| `certipy` | ADCS enumeration (ESC1) |
| `faketime` | Clock skew bypass para Kerberos |
| `evil-winrm` | Shell remota Windows via WinRM |
| `ad_recon.py` | Herramienta propia de enumeracion AD |

---

## `> python3 ad_recon.py --help`

```bash
# Herramienta de enumeracion automatica incluida en el lab
python3 attack/01_enumeration/ad_recon.py \
  -d corp.local \
  -u j.smith \
  -p 'Password123!' \
  -dc 10.10.10.10 \
  -o

# Enumera automaticamente:
# → Usuarios del dominio
# → AS-REP Roastables
# → Kerberoastables (SPNs)
# → Shares SMB
# → Hosts en la red
# → Genera reporte en txt
```

---

## `> cat setup.md`

### Requisitos
RAM:   16GB minimo (12GB VMs + 4GB host)
Disco: 100GB libres
CPU:   4+ cores con virtualizacion habilitada

### VMs
DC01   → Windows Server 2019 Eval
FILE01 → Windows Server 2019 Eval
WS01   → Windows 10 Pro Eval
WS02   → Windows 10 Pro Eval
Kali   → Kali Linux 2024+

### Red en VirtualBox
Adaptador 1: NAT o Bridged     → Kali + WS01 (192.168.1.0/24)
Adaptador 2: Internal Network  → DC01 + FILE01 + WS01 + WS02 (10.10.10.0/24)

### Deploy
```powershell
# DC01
.\setup\dc01\01_install_adds.ps1
.\setup\dc01\02_promote_dc.ps1
.\setup\dc01\03_create_users.ps1
.\setup\dc01\04_acl_abuse.ps1
.\setup\dc01\05_install_adcs.ps1

# FILE01
.\setup\file01\01_join_domain.ps1
.\setup\file01\02_install_fileserver.ps1
.\setup\file01\03_create_shares.ps1
.\setup\file01\04_gpo_misconfiguration.ps1

# WS01 y WS02
.\setup\ws01\01_join_domain.ps1
.\setup\ws02\01_join_domain.ps1
.\setup\ws02\02_user_setup.ps1
```

---

## `> cat findings.txt`

| # | Hallazgo | Severidad | CVSS |
|---|----------|-----------|------|
| 1 | LLMNR/NBT-NS habilitado en la red | High | 8.8 |
| 2 | AS-REP Roasting — m.jones sin preauth | High | 7.5 |
| 3 | Kerberoasting — svc_sql SPN expuesto | High | 7.5 |
| 4 | Credenciales en texto claro — FILE01 | High | 8.0 |
| 5 | ACL abuse — WriteDACL → Domain Admin | Critical | 9.0 |
| 6 | DCSync sin restriccion de replicacion | Critical | 9.0 |
| 7 | DSRM backdoor habilitado en DC01 | Critical | 9.8 |

---

<div align="center">
[+] corp.local — COMPROMETIDO
[+] Domain Admin — OBTENIDO
[+] DCSync — EJECUTADO
[+] Golden Ticket — GENERADO
[+] Persistencia — ESTABLECIDA

*[Clark Espinal](https://clarkportafolio.vercel.app) — Offensive Security Portfolio*

</div>
