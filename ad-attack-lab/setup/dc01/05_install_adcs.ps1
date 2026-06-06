Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab — 05_install_adcs.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 5] Instalando ADCS..." -ForegroundColor Cyan

Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority `
    -CAType EnterpriseRootCA `
    -CACommonName "corp-CA" `
    -KeyLength 2048 `
    -HashAlgorithmName SHA256 `
    -Force

Write-Host "[+] ADCS instalado — CA: corp-CA" -ForegroundColor Green
Write-Host ""
Write-Host "Siguiente paso: correr 06_esc1_template.ps1" -ForegroundColor Cyan
