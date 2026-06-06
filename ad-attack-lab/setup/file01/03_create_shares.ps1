Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - FILE01 / 03_create_shares.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 3] Creando shares vulnerables..." -ForegroundColor Cyan

$Paths = @(
    "C:\Shares\data",
    "C:\Shares\it-tools",
    "C:\Shares\backup"
)

foreach ($Path in $Paths) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

Write-Host "[+] Directorios creados en C:\Shares\" -ForegroundColor Green

New-SmbShare `
    -Name "data" `
    -Path "C:\Shares\data" `
    -ChangeAccess "CORP\Domain Users" `
    -FullAccess "CORP\Domain Admins" `
    -Description "Datos corporativos compartidos"

Write-Host "[!] MISCONFIGURACION: \\FILE01\data - Domain Users tiene Change access" -ForegroundColor Red

New-SmbShare `
    -Name "it-tools" `
    -Path "C:\Shares\it-tools" `
    -FullAccess "CORP\Domain Admins" `
    -ChangeAccess "CORP\Domain Computers" `
    -Description "Herramientas IT"

Write-Host "[!] MISCONFIGURACION: \\FILE01\it-tools - Domain Computers tiene Change access" -ForegroundColor Red

New-SmbShare `
    -Name "backup" `
    -Path "C:\Shares\backup" `
    -FullAccess "CORP\Domain Admins" `
    -ReadAccess "CORP\svc_backup" `
    -Description "Destino de backups"

Write-Host "[!] MISCONFIGURACION: \\FILE01\backup - svc_backup tiene Read access" -ForegroundColor Red

$CredsContent = @"
# config.ini - Database Connection
# NOTA: mover a vault antes de produccion

[database]
host     = 10.10.10.20
port     = 1433
username = svc_sql
password = Summer2024!
database = CorpDB
"@

$NotesContent = @"
IT Admin Notes - Enero 2024

- svc_backup password rotada: Backup2024!
- WinRM habilitado en todos los servidores para administracion remota
- Recordar deshabilitar SMBv1 antes de auditoria (PENDIENTE)
"@

$CredsContent | Out-File "C:\Shares\data\config.ini" -Encoding UTF8
$NotesContent | Out-File "C:\Shares\data\it-notes.txt" -Encoding UTF8

Write-Host "[!] LOOT PLANTADO: C:\Shares\data\config.ini (credenciales svc_sql hardcodeadas)" -ForegroundColor Red
Write-Host "[!] LOOT PLANTADO: C:\Shares\data\it-notes.txt (menciona password svc_backup)" -ForegroundColor Red

Write-Host ""
Write-Host "[+] Shares creados:" -ForegroundColor Green
Write-Host "  \\FILE01\data     - Domain Users: Change" -ForegroundColor Gray
Write-Host "  \\FILE01\it-tools - Domain Computers: Change" -ForegroundColor Gray
Write-Host "  \\FILE01\backup   - svc_backup: Read" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 04_gpo_misconfiguration.ps1" -ForegroundColor Cyan
