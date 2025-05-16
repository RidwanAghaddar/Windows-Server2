# Installatie van .NET Framework en AD DS (Active Directory Domain Services) tools
Import-Module ServerManager
Install-WindowsFeature RSAT-ADDS -IncludeManagementTools
Install-WindowsFeature -Name Net-Framework-Core

# Variabelen voor SQL Server installatie
$sqlSetupPath = "D:\setup.exe" # Pas dit pad aan naar de locatie van je SQL Server setup bestand
$sqlAdminUser = "WS2-2425-ridwan\vagrant" # Pas dit aan naar de juiste admin gebruikersnaam
$sqlAdminPassword = "P@ssw0rd!" # Pas dit aan naar het juiste wachtwoord

# Install SQL Server
Start-Process -FilePath $sqlSetupPath -ArgumentList "/ACTION=Install", `
                                                 "/QS", `
                                                 "/SQLSYSADMINACCOUNTS=$sqlAdminUser", `
                                                 "/IACCEPTSQLSERVERLICENSETERMS", `
                                                 "/INSTANCENAME=MSSQLSERVER", `
                                                 "/SUPPRESSPRIVACYSTATEMENTNOTICE", `
                                                 "/SQLSVCACCOUNT=""NT AUTHORITY\SYSTEM""", `
                                                 "/AGTSVCACCOUNT=""NT AUTHORITY\Network Service""", `
                                                 "/FEATURES=SQLEngine", `
                                                 "/TCPENABLED=1", `
                                                 "/SECURITYMODE=SQL", `
                                                 "/SAPWD=""$sqlAdminPassword""" `
                                                 -NoNewWindow -Wait

if ($LASTEXITCODE -eq 0) {
    Write-Host "SQL Server installatie is succesvol afgerond." 
} else {
    Write-Host "SQL Server installatie is mislukt met code: $LASTEXITCODE"
}

# Aanmaken van firewallregels voor SQL Server
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow -Verbose
New-NetFirewallRule -DisplayName "SQL Admin Connection" -Direction Inbound -Protocol TCP -LocalPort 1434 -Action Allow -Verbose

Write-Host "Firewallregels zijn succesvol aangemaakt."

# Start de SQL Server en SQL Server Agent services
Start-Service -Name "MSSQLSERVER", "SQLSERVERAGENT"