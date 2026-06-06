Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab — 04_acl_abuse.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 4] Configurando ACLs vulnerables..." -ForegroundColor Cyan

Import-Module ActiveDirectory
$svcBackup    = Get-ADUser -Identity "svc_backup"
$domainAdmins = Get-ADGroup -Identity "Domain Admins"
$jSmith       = Get-ADUser -Identity "j.smith"
$mJones       = Get-ADUser -Identity "m.jones"
$svcSql       = Get-ADUser -Identity "svc_sql"

$acl = Get-Acl "AD:$($domainAdmins.DistinguishedName)"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $svcBackup.SID,
    "WriteDacl",
    "Allow"
)
$acl.AddAccessRule($ace)
Set-Acl "AD:$($domainAdmins.DistinguishedName)" $acl
Write-Host "[!] MISCONFIGURACION: svc_backup tiene WriteDACL sobre Domain Admins" -ForegroundColor Red

$acl2 = Get-Acl "AD:$($svcBackup.DistinguishedName)"
$ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $mJones.SID,
    "ExtendedRight",
    "Allow",
    [System.Guid]"00299570-246d-11d0-a768-00aa006e0529"
)
$acl2.AddAccessRule($ace2)
Set-Acl "AD:$($svcBackup.DistinguishedName)" $acl2
Write-Host "[!] MISCONFIGURACION: m.jones tiene ForceChangePassword sobre svc_backup" -ForegroundColor Red

Write-Host "[+] ACLs vulnerables configuradas" -ForegroundColor Green
Write-Host ""
Write-Host "Attack path configurado:" -ForegroundColor White
Write-Host "  AS-REP Roast m.jones" -ForegroundColor Gray
Write-Host "  -> ForceChangePassword sobre svc_backup" -ForegroundColor Gray
Write-Host "  -> WriteDACL sobre Domain Admins" -ForegroundColor Gray
Write-Host "  -> Domain Admin" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 05_install_adcs.ps1" -ForegroundColor Cyan
