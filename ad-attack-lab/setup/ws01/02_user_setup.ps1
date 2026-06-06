Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS01 / 02_user_setup.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 2] Configurando usuarios y acceso remoto..." -ForegroundColor Cyan

Add-LocalGroupMember -Group "Administrators" -Member "CORP\j.smith" -ErrorAction SilentlyContinue
Write-Host "[!] MISCONFIGURACION: j.smith es local admin en WS01" -ForegroundColor Red

Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Write-Host "[!] MISCONFIGURACION: WinRM habilitado sin restricciones de host" -ForegroundColor Red

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

New-NetFirewallRule -DisplayName "WinRM-Lab" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow -Profile Any -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "SMB-Lab" -Direction Inbound -Protocol TCP -LocalPort 445 -Action Allow -Profile Any -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "RDP-Lab" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow -Profile Any -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Ligolo-Lab" -Direction Inbound -Protocol TCP -LocalPort 11601 -Action Allow -Profile Any -ErrorAction SilentlyContinue

Write-Host "[!] MISCONFIGURACION: Firewall activo pero reglas permisivas" -ForegroundColor Red
Write-Host ""
Write-Host "[+] Usuarios y acceso remoto configurados" -ForegroundColor Green
Write-Host ""
Write-Host "Attack paths iniciales desde Kali:" -ForegroundColor White
Write-Host "  evil-winrm -i 192.168.1.5 -u j.smith -p 'Password123!'" -ForegroundColor Gray
Write-Host "  crackmapexec smb 192.168.1.5 -u j.smith -p 'Password123!'" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 03_ligolo_prep.ps1" -ForegroundColor Cyan
