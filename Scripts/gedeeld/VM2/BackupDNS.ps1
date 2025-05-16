Install-WindowsFeature -Name DNS -IncludeManagementTools

# Variabelen
$primaryDnsServer = "192.168.24.10"

# Stel de server in als een secundaire (Backup) DNS-server voor de zone
Add-DnsServerSecondaryZone -Name "WS2-2425-ridwan.hogent" -MasterServers $primaryDnsServer -ZoneFile "WS2-2425-ridwan.hogent.dns"
Start-DnsServerZoneTransfer -Name "WS2-2425-ridwan.hogent"

# Om ervoor te zorgen dat nslookup correct werkt en het juiste interface gebruikt
# Ik geef de windows interface een hogere prioriteit

Set-NetIPInterface -InterfaceAlias "Ethernet" -InterfaceMetric 30
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -InterfaceMetric 10
