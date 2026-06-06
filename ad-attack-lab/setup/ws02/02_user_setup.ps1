Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS02 / 02_user_setup.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 2] Configurando usuarios y acceso remoto..." -ForegroundColor Cyan

Add-LocalGroupMember -Group "Administrators" -Member "CORP\svc_sql" -ErrorAction SilentlyContinue
Write-Host "[!] MISCONFIGURACION: svc_sql es local admin en WS02" -ForegroundColor Red

Add-LocalGroupMember -Group "Administrators" -Member "CORP\j.smith" -ErrorAction SilentlyContinue
Write-Host "[!] MISCONFIGURACION: j.smith es local admin en WS02" -ForegroundColor Red

Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Write-Host "[!] MISCONFIGURACION: WinRM habilitado sin restricciones" -ForegroundColor Red

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

New-NetFirewallRule -DisplayName "WinRM-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 5985 -Action Allow -Profile Any

New-NetFirewallRule -DisplayName "SMB-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 445 -Action Allow -Profile Any

New-NetFirewallRule -DisplayName "RDP-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 3389 -Action Allow -Profile Any

New-NetFirewallRule -DisplayName "MSSQL-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 1433 -Action Allow -Profile Any

Write-Host "[!] MISCONFIGURACION: Firewall activo pero reglas permisivas" -ForegroundColor Red

Write-Host ""
Write-Host "[+] Usuarios y acceso remoto configurados" -ForegroundColor Green
Write-Host ""
Write-Host "Attack paths desde Kali (via tunnel ligolo):" -ForegroundColor White
Write-Host "  evil-winrm -i 10.10.10.40 -u svc_sql -p 'Summer2024!'" -ForegroundColor Gray
Write-Host "  evil-winrm -i 10.10.10.40 -u j.smith -p 'Password123!'" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 03_mssql_install.ps1" -ForegroundColor Cyan

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
  -Name "LocalAccountTokenFilterPolicy" -Value 1 -Type DWord
Write-Host "[!] MISCONFIGURACION: UAC remoto deshabilitado" -ForegroundColor Red

net user Administrator /active:yes
Write-Host "[!] MISCONFIGURACION: Administrator local habilitado" -ForegroundColor Red
