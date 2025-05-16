# Definieer domeinnaam, NetBIOS-naam en beheerderswachtwoord
$domainName = "WS2-2425-ridwan.hogent"
$domainNetbiosName = "WS2-2425-RIDWAN"
$adminPassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force

# Installeer Active Directory, DNS en DHCP
try {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Verbose
} catch {
    Write-Host "Er is een fout opgetreden bij het installeren van Windows-functies: $_" 
    exit 1
}
Write-Host "AD-Domain-Services succesvol geinstalleerd." 
Install-WindowsFeature -Name DNS -IncludeManagementTools -Verbose
Write-Host "DNS geinstalleerd"
Install-WindowsFeature -Name DHCP -IncludeManagementTools -Verbose
Write-Host "DHCP geinstalleerd"

# Active Directory implementeren
try {
    Import-Module ADDSDeployment -ErrorAction Stop

    Install-ADDSForest -CreateDnsDelegation:$false `
        -DatabasePath "C:\Windows\NTDS" `
        -DomainMode "WinThreshold" `
        -DomainName $domainName `
        -DomainNetbiosName $domainNetbiosName `
        -ForestMode "WinThreshold" `
        -InstallDns:$true `
        -LogPath "C:\Windows\NTDS" `
        -SysvolPath "C:\Windows\SYSVOL" `
        -SafeModeAdministratorPassword $adminPassword `
        -Force:$true `
        -NoRebootOnCompletion:$false `
        -Verbose

    Write-Host "Active Directory forest implementatie voltooid." 
} catch {
    Write-Host "Er is een fout opgetreden tijdens de ADDS-implementatie: $_" 
    exit 1
}

Write-Host "AD-implementatie voltooid." 