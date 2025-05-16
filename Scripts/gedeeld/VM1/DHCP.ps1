Add-WindowsFeature -Name DHCP -IncludeManagementTools

Import-Module DhcpServer

# Controleer of de server lid is van het domein
$domain = (Get-WmiObject Win32_ComputerSystem).Domain
if ($domain -eq $env:COMPUTERNAME) {
    Write-Host "De server is geen lid van een domein. Voeg de server toe aan het domein en probeer opnieuw."
    exit
} else {
    Write-Host "De server is lid van het domein: $domain"
}

# Voeg DHCP server toe aan Active Directory met credentials
try {
    $hostname = (Get-WmiObject Win32_ComputerSystem).Name
    Start-Process -FilePath PowerShell -Credential $domainAdminCreds -ArgumentList "-Command Add-DhcpServerInDC -DnsName `"$hostname`" -IPAddress 192.168.24.10"
    Write-Host "DHCP server successfully added to Active Directory." 
} catch {
    Write-Host "Failed to add DHCP server to Active Directory: $_" 
}
# Voeg DHCP-scope toe
Add-DhcpServerv4Scope -Name "ClientDHCP" -StartRange 192.168.24.101 -EndRange 192.168.24.200 -SubnetMask 255.255.255.0 -State Active
Write-Host "DHCP Scope '192.168.24.0' toegevoegd."

# Voeg uitsluitingsbereik toe
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.24.0 -StartRange 192.168.24.151 -EndRange 192.168.24.200
Write-Host "Uitsluitingsbereik '192.168.24.151 - 192.168.24.200' toegevoegd."

# Stel DNS-servers en router in voor de DHCP-scope
$dnsServers = @("192.168.24.10", "192.168.24.20")
Set-DhcpServerv4OptionValue -ComputerName "Server1" -DnsDomain "WS2-2425-ridwan.hogent" -DnsServer $dnsServers -Router 192.168.24.1
Write-Host "DHCP opties ingesteld."

Enable-NetFirewallRule -DisplayGroup "DHCP Server"


# Herstart de DHCP-service
Restart-Service DhcpServer
