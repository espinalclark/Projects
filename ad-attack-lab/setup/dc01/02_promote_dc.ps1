
$DomainName    = "corp.local"
$DomainNetbios = "CORP"
$SafeModePass  = ConvertTo-SecureString "Admin123!" -AsPlainText -Force

Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab — 02_promote_dc.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 2] Promoviendo a Domain Controller..." -ForegroundColor Cyan

Import-Module ADDSDeployment
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $DomainNetbios `
    -SafeModeAdministratorPassword $SafeModePass `
    -InstallDns:$true `
    -Force:$true `
    -NoRebootOnCompletion:$false

Write-Host ""
Write-Host "Siguiente paso (post-reboot): correr 03_create_users.ps1" -ForegroundColor Cyan
