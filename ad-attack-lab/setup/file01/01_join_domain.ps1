Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - FILE01 / 01_join_domain.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 1] Uniendo FILE01 al dominio corp.local..." -ForegroundColor Cyan

$DomainName = "corp.local"
$DomainJoinUser = "CORP\Administrator"
$DomainJoinPass = ConvertTo-SecureString "Admin123!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($DomainJoinUser, $DomainJoinPass)

$NicAlias = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1).Name
Set-DnsClientServerAddress -InterfaceAlias $NicAlias -ServerAddresses "10.10.10.10"
Write-Host "[+] DNS configurado -> 10.10.10.10 (DC01)" -ForegroundColor Green

Rename-Computer -NewName "FILE01" -Force
Write-Host "[+] Hostname configurado: FILE01" -ForegroundColor Green

Add-Computer `
    -DomainName $DomainName `
    -Credential $Credential `
    -Restart `
    -Force

Write-Host ""
Write-Host "Siguiente paso (post-reboot): correr 02_install_fileserver.ps1" -ForegroundColor Cyan
