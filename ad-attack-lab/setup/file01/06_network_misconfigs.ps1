Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - FILE01 / 06_network_misconfigs.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 6] Configurando misconfigs de red finales..." -ForegroundColor Cyan

$smb1 = Get-SmbServerConfiguration | Select-Object -ExpandProperty EnableSMB1Protocol
if ($smb1) {
Write-Host "[!] MISCONFIGURACION: SMBv1 activo" -ForegroundColor Red
} else {
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart
Write-Host "[!] MISCONFIGURACION: SMBv1 activado" -ForegroundColor Red
}

Set-SmbServerConfiguration -EnableSecuritySignature $false -RequireSecuritySignature $false -Force
Write-Host "[!] MISCONFIGURACION: SMB signing deshabilitado (SMB relay posible)" -ForegroundColor Red

Write-Host "[!] MISCONFIGURACION: LLMNR/NBT-NS activos (default)" -ForegroundColor Red

Write-Host ""
Write-Host "`n============================================" -ForegroundColor Yellow
Write-Host "  SETUP COMPLETADO - FILE01" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Hostname:    FILE01" -ForegroundColor White
Write-Host "IP interna:  10.10.10.20" -ForegroundColor White
Write-Host "Dominio:     corp.local" -ForegroundColor White
Write-Host "DC:          10.10.10.10" -ForegroundColor White
Write-Host ""
Write-Host "Shares configurados:" -ForegroundColor White
Write-Host "  \FILE01\data     - Domain Users: Change  (loot: config.ini, it-notes.txt)" -ForegroundColor Gray
Write-Host "  \FILE01\it-tools - Domain Computers: Change  (loot: startup.bat)" -ForegroundColor Gray
Write-Host "  \FILE01\backup   - svc_backup: Read" -ForegroundColor Gray
Write-Host ""
Write-Host "Admins locales:" -ForegroundColor White
Write-Host "  CORP\j.smith    (foothold -> lateral movement directo)" -ForegroundColor Gray
Write-Host "  CORP\svc_backup (WriteDACL -> path a Domain Admin)" -ForegroundColor Gray
Write-Host ""
Write-Host "Misconfigs activas:" -ForegroundColor White
Write-Host "  [!] SMBv1 habilitado" -ForegroundColor Red
Write-Host "  [!] SMB signing deshabilitado (vulnerable a relay)" -ForegroundColor Red
Write-Host "  [!] LLMNR/NBT-NS activos" -ForegroundColor Red
Write-Host "  [!] WinRM sin restricciones" -ForegroundColor Red
Write-Host "  [!] Firewall deshabilitado" -ForegroundColor Red
Write-Host "  [!] Credenciales hardcodeadas en shares" -ForegroundColor Red
Write-Host "  [!] GPO apunta a share escribible" -ForegroundColor Red
Write-Host ""

Write-Host "Validando conectividad con DC01 (10.10.10.10)..." -ForegroundColor Cyan
$ping = Test-Connection -ComputerName "10.10.10.10" -Count 1 -Quiet
if ($ping) {
Write-Host "[+] DC01 alcanzable" -ForegroundColor Green
} else {
Write-Host "[-] DC01 no responde - verificar red interna" -ForegroundColor Red
}

Write-Host ""
Write-Host "Shares activos:" -ForegroundColor Cyan
Get-SmbShare | Where-Object { $_.Name -notlike "*$" } | Select-Object Name, Path, Description | Format-Table -AutoSize

Write-Host ""
Write-Host "Siguiente paso: configurar WS01 (pivot point) - ws01_setup.ps1" -ForegroundColor Cyan
Write-Host "[DISCLAIMER] Solo para laboratorio controlado" -ForegroundColor DarkYellow

