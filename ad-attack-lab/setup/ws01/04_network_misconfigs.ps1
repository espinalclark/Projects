Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS01 / 04_network_misconfigs.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 4] Configurando misconfigs de red..." -ForegroundColor Cyan

Set-SmbServerConfiguration -EnableSecuritySignature $false `
    -RequireSecuritySignature $false -Force
Write-Host "[!] MISCONFIGURACION: SMB signing deshabilitado (SMB relay posible)" -ForegroundColor Red

Write-Host "[!] MISCONFIGURACION: LLMNR/NBT-NS activos (default Windows)" -ForegroundColor Red

Write-Host ""
Write-Host "`n============================================" -ForegroundColor Yellow
Write-Host "  SETUP COMPLETADO - WS01" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Hostname:      WS01" -ForegroundColor White
Write-Host "IP externa:    192.168.1.5  (accesible desde Kali)" -ForegroundColor White
Write-Host "IP interna:    10.10.10.30  (ve red corp)" -ForegroundColor White
Write-Host "Dominio:       corp.local" -ForegroundColor White
Write-Host ""
Write-Host "Misconfigs activas:" -ForegroundColor White
Write-Host "  [!] j.smith local admin" -ForegroundColor Red
Write-Host "  [!] WinRM sin restricciones" -ForegroundColor Red
Write-Host "  [!] Firewall permisivo (WinRM/SMB/RDP/Ligolo abiertos)" -ForegroundColor Red
Write-Host "  [!] Defender excluye C:\Tools" -ForegroundColor Red
Write-Host "  [!] Credenciales en texto claro en disco" -ForegroundColor Red
Write-Host "  [!] SMB signing deshabilitado" -ForegroundColor Red
Write-Host ""
Write-Host "Siguiente paso: configurar WS02 - ws02_setup.ps1" -ForegroundColor Cyan
Write-Host "[DISCLAIMER] Solo para laboratorio controlado" -ForegroundColor DarkYellow
