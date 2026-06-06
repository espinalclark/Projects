Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - FILE01 / 05_winrm_misconfiguration.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 5] Configurando WinRM vulnerable..." -ForegroundColor Cyan

Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Write-Host "[!] MISCONFIGURACION: WinRM habilitado sin restricciones de host" -ForegroundColor Red

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

New-NetFirewallRule -DisplayName "WinRM-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 5985 -Action Allow -Profile Any

New-NetFirewallRule -DisplayName "SMB-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 445 -Action Allow -Profile Any

New-NetFirewallRule -DisplayName "RDP-Lab" -Direction Inbound `
    -Protocol TCP -LocalPort 3389 -Action Allow -Profile Any

Write-Host "[!] MISCONFIGURACION: Firewall activo pero reglas permisivas (WinRM/SMB/RDP abiertos a cualquier origen)" -ForegroundColor Red

Add-LocalGroupMember -Group "Administrators" -Member "CORP\j.smith"
Write-Host "[!] MISCONFIGURACION: j.smith es local admin en FILE01" -ForegroundColor Red

Add-LocalGroupMember -Group "Administrators" -Member "CORP\svc_backup"
Write-Host "[!] MISCONFIGURACION: svc_backup es local admin en FILE01" -ForegroundColor Red

Write-Host ""
Write-Host "[+] WinRM y acceso remoto configurados" -ForegroundColor Green
Write-Host ""
Write-Host "Attack paths desde Kali (via tunnel ligolo -> 10.10.10.20):" -ForegroundColor White
Write-Host "  evil-winrm -i 10.10.10.20 -u j.smith -p 'Password123!'" -ForegroundColor Gray
Write-Host "  evil-winrm -i 10.10.10.20 -u Administrator -H <NTLM_HASH>  (PTH)" -ForegroundColor Gray
Write-Host "  crackmapexec smb 10.10.10.20 -u j.smith -H <NTLM_HASH>     (PTH)" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 06_network_misconfigs.ps1" -ForegroundColor Cyan
