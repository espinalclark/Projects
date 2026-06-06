Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS01 / 01_join_domain.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 1] Configurando red y uniendo WS01 al dominio..." -ForegroundColor Cyan

$NicInterna = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" } |
    Where-Object { (Get-NetIPAddress -InterfaceIndex $_.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress -like "10.10.10.*" }).Name

Set-DnsClientServerAddress -InterfaceAlias $NicInterna -ServerAddresses "10.10.10.10"
Write-Host "[+] DNS configurado -> 10.10.10.10 (DC01)" -ForegroundColor Green

Rename-Computer -NewName "WS01" -Force
Write-Host "[+] Hostname configurado: WS01" -ForegroundColor Green

$DomainJoinPass = ConvertTo-SecureString "Admin123!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential("CORP\Administrator", $DomainJoinPass)

Add-Computer `
    -DomainName "corp.local" `
    -Credential $Credential `
    -Restart `
    -Force

Write-Host ""
Write-Host "Siguiente paso (post-reboot): correr 02_user_setup.ps1" -ForegroundColor Cyan
