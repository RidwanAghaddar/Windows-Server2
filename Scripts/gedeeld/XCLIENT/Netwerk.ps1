# Haal de netwerkadapter op met de naam "Ethernet 2"
$nic = Get-NetAdapter -Name 'Ethernet 2'

# IPv6 uitschakelen op de adapter
Disable-NetAdapterBinding -Name "Ethernet 2" -ComponentID ms_tcpip6

# Schakel DHCP in voor de netwerkadapter om een IP-adres van de DHCP-server te verkrijgen
$nic | Set-NetIPInterface -DHCP Enabled

# Stel het DNS-serveradres handmatig in
$dnsServers = "192.168.24.10", "192.168.24.20"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses $dnsServers

# Stel het PowerShell-uitvoeringsbeleid in op 'Onbeperkt'
Set-ExecutionPolicy Unrestricted -Force

