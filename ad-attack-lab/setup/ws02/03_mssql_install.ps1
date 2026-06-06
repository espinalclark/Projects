Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS02 / 03_mssql_install.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 3] Instalando SQL Server Express..." -ForegroundColor Cyan

Write-Host "[*] Descargando SQL Server Express..." -ForegroundColor Yellow
$url = "https://download.microsoft.com/download/3/8/d/38de7036-2433-4207-8eae-06e247e17b25/SQLEXPR_x64_ENU.exe"
$installer = "C:\Tmp\sql_installer.exe"
Invoke-WebRequest -Uri $url -OutFile $installer

Write-Host "[*] Instalando en modo silencioso..." -ForegroundColor Yellow
Start-Process -FilePath $installer -ArgumentList "/ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT=`"CORP\svc_sql`" /SQLSVCPASSWORD=`"Summer2024!`" /SQLSYSADMINACCOUNTS=`"CORP\Domain Admins`" /AGTSVCACCOUNT=`"NT AUTHORITY\Network Service`" /IACCEPTSQLSERVERLICENSETERMS /QUIET" -Wait

Write-Host "[+] SQL Server Express instalado" -ForegroundColor Green
Write-Host "[!] MISCONFIGURACION: svc_sql es service account de SQL (SPN registrado en DC01)" -ForegroundColor Red
Write-Host ""
Write-Host "Verificar SPN desde DC01:" -ForegroundColor White
Write-Host "  setspn -L svc_sql" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 04_acl_genericwrite.ps1" -ForegroundColor Cyan
