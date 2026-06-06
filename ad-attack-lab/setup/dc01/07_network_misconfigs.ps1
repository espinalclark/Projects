Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab — 07_network_misconfigs.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 7] Configurando misconfigs de red..." -ForegroundColor Cyan
Write-Host "[!] MISCONFIGURACION: LLMNR/NBT-NS activos (default Windows)" -ForegroundColor Red
Write-Host "    Responder puede capturar hashes NTLMv2 en esta red" -ForegroundColor Red
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Write-Host "[!] MISCONFIGURACION: WinRM habilitado sin restricciones de host" -ForegroundColor Red

Write-Host "[+] Misconfigs de red aplicadas" -ForegroundColor Green

Write-Host "`n============================================" -ForegroundColor Yellow
Write-Host "  SETUP COMPLETADO — corp.local" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Dominio:     corp.local" -ForegroundColor White
Write-Host "DC:          DC01 (10.10.10.1)" -ForegroundColor White
Write-Host ""
Write-Host "Usuarios:" -ForegroundColor White
Write-Host "  j.smith    : Password123!  (initial foothold)" -ForegroundColor Gray
Write-Host "  m.jones    : Welcome1      (AS-REP Roastable)" -ForegroundColor Gray
Write-Host "  svc_sql    : Summer2024!   (Kerberoastable)" -ForegroundColor Gray
Write-Host "  svc_backup : Backup2024!   (WriteDACL → DA)" -ForegroundColor Gray
Write-Host ""
Write-Host "Misconfigs activas:" -ForegroundColor White
Write-Host "  [!] LLMNR/NBT-NS habilitado (default)" -ForegroundColor Red
Write-Host "  [!] m.jones — PreAuth deshabilitado (AS-REP Roast)" -ForegroundColor Red
Write-Host "  [!] svc_sql — SPN registrado (Kerberoast)" -ForegroundColor Red
Write-Host "  [!] svc_backup — WriteDACL sobre Domain Admins" -ForegroundColor Red
Write-Host "  [!] m.jones — ForceChangePassword sobre svc_backup" -ForegroundColor Red
Write-Host "  [!] ADCS ESC1 — CorpUserCert vulnerable" -ForegroundColor Red
Write-Host "  [!] WinRM sin restricciones" -ForegroundColor Red
Write-Host ""
Write-Host "Siguiente paso: correr ws01_setup.ps1 en WS01" -ForegroundColor Cyan
Write-Host ""
Write-Host "[DISCLAIMER] Solo para laboratorio controlado" -ForegroundColor DarkYellow
