Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab — 01_install_adds.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "`n[BLOQUE 1] Instalando AD DS..." -ForegroundColor Cyan

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Write-Host "[+] AD DS instalado correctamente" -ForegroundColor Green
Write-Host ""
Write-Host "Siguiente paso: correr 02_promote_dc.ps1" -ForegroundColor Cyan
