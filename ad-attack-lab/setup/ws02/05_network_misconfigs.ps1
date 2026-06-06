Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS02 / 05_network_misconfigs.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS02 / 05_network_misconfigs.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 5] Configurando misconfigs de red y loot..." -ForegroundColor Cyan

Set-SmbServerConfiguration -EnableSecuritySignature $false `
    -RequireSecuritySignature $false -Force
Write-Host "[!] MISCONFIGURACION: SMB signing deshabilitado" -ForegroundColor Red

$CredsContent = "# db_config.txt`r`nServer=WS02\MSSQLSERVER`r`nDatabase=CorpDB`r`nUser=svc_sql`r`nPassword=Summer2024!`r`nDomain=CORP"
$CredsContent | Out-File "C:\Users\Public\db_config.txt" -Encoding UTF8
Write-Host "[!] LOOT PLANTADO: C:\Users\Public\db_config.txt" -ForegroundColor Red

Write-Host ""
Write-Host "`n============================================" -ForegroundColor Yellow
Write-Host "  SETUP COMPLETADO - WS02" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Hostname:    WS02" -ForegroundColor White
Write-Host "IP interna:  10.10.10.40" -ForegroundColor White
Write-Host "Dominio:     corp.local" -ForegroundColor White
Write-Host ""
Write-Host "Misconfigs activas:" -ForegroundColor White
Write-Host "  [!] svc_sql local admin" -ForegroundColor Red
Write-Host "  [!] j.smith local admin" -ForegroundColor Red
Write-Host "  [!] WinRM sin restricciones" -ForegroundColor Red
Write-Host "  [!] MSSQL expuesto en 1433" -ForegroundColor Red
Write-Host "  [!] SMB signing deshabilitado" -ForegroundColor Red
Write-Host "  [!] Credenciales en disco" -ForegroundColor Red
Write-Host "  [!] j.smith GenericWrite sobre WS02" -ForegroundColor Red
Write-Host ""
Write-Host "Lab completo - todos los nodos configurados" -ForegroundColor Green
Write-Host "[DISCLAIMER] Solo para laboratorio controlado" -ForegroundColor DarkYellow
