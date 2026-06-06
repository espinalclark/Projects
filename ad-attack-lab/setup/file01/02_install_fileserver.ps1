Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - FILE01 / 02_install_fileserver.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 2] Instalando rol File Server..." -ForegroundColor Cyan

Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools

Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

Write-Host "[!] MISCONFIGURACION: SMBv1 habilitado" -ForegroundColor Red

Set-SmbServerConfiguration -EnableSecuritySignature $false -RequireSecuritySignature $false -Force

Write-Host "[!] MISCONFIGURACION: SMB signing deshabilitado (vulnerable a SMB relay)" -ForegroundColor Red

Write-Host "[+] Rol File Server instalado" -ForegroundColor Green
Write-Host ""
Write-Host "Siguiente paso: correr 03_create_shares.ps1" -ForegroundColor Cyan

