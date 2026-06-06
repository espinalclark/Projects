Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS02 / 01_join_domain.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 1] Configurando red y uniendo WS02 al dominio..." -ForegroundColor Cyan

$NicInterna = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" } |
    Where-Object { (Get-NetIPAddress -InterfaceIndex $_.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress -like "10.10.10.*" }).Name

if ($NicInterna) {
    Set-DnsClientServerAddress -InterfaceAlias $NicInterna -ServerAddresses "10.10.10.10"
    Write-Host "[+] DNS configurado -> 10.10.10.10 (DC01)" -ForegroundColor Green
} else {
    Write-Host "[!] NIC interna no detectada - configurar DNS manualmente" -ForegroundColor Yellow
}

Rename-Computer -NewName "WS02" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Hostname configurado: WS02" -ForegroundColor Green

$pass = ConvertTo-SecureString "Admin123!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("CORP\Administrator", $pass)

Add-Computer -DomainName "corp.local" -Credential $cred -Restart -Force

Write-Host ""
Write-Host "Siguiente paso (post-reboot): correr 02_user_setup.ps1" -ForegroundColor Cyan
