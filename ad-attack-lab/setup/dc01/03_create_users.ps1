Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab — 03_create_users.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 3] Creando usuarios del dominio..." -ForegroundColor Cyan

Import-Module ActiveDirectory
New-ADUser `
    -Name "John Smith" `
    -GivenName "John" `
    -Surname "Smith" `
    -SamAccountName "j.smith" `
    -UserPrincipalName "j.smith@corp.local" `
    -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $true

New-ADUser `
    -Name "Mike Jones" `
    -GivenName "Mike" `
    -Surname "Jones" `
    -SamAccountName "m.jones" `
    -UserPrincipalName "m.jones@corp.local" `
    -AccountPassword (ConvertTo-SecureString "Welcome1" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $true

Set-ADAccountControl -Identity "m.jones" -D
Write-Host "[!] MISCONFIGURACION: m.jones no requiere PreAuth (AS-REP Roastable)" -ForegroundColor Red

New-ADUser `
    -Name "SQL Service" `
    -GivenName "SQL" `
    -Surname "Service" `
    -SamAccountName "svc_sql" `
    -UserPrincipalName "svc_sql@corp.local" `
    -AccountPassword (ConvertTo-SecureString "Summer2024!" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $true

setspn -A MSSQLSvc/WS02.corp.local:1433 svc_sql
setspn -A MSSQLSvc/WS02:1433 svc_sql
Write-Host "[!] MISCONFIGURACION: svc_sql tiene SPN registrado (Kerberoastable)" -ForegroundColor Red

New-ADUser `
    -Name "Backup Service" `
    -GivenName "Backup" `
    -Surname "Service" `
    -SamAccountName "svc_backup" `
    -UserPrincipalName "svc_backup@corp.local" `
    -AccountPassword (ConvertTo-SecureString "Backup2024!" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $true

Write-Host "[+] Usuarios creados: j.smith, m.jones, svc_sql, svc_backup" -ForegroundColor Green
Write-Host ""
Write-Host "Resumen de cuentas:" -ForegroundColor White
Write-Host "  j.smith    : Password123!  (initial foothold via LLMNR)" -ForegroundColor Gray
Write-Host "  m.jones    : Welcome1      (AS-REP Roastable)" -ForegroundColor Gray
Write-Host "  svc_sql    : Summer2024!   (Kerberoastable)" -ForegroundColor Gray
Write-Host "  svc_backup : Backup2024!   (WriteDACL sobre Domain Admins)" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 04_acl_abuse.ps1" -ForegroundColor Cyan
