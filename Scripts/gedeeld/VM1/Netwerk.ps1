# Haal de interface index op van de eerste actieve netwerkadapter
$adapter = Get-NetAdapter -Name 'Ethernet 2'

# Definieer de netwerkconfiguratie variabelen
$ipadres = "192.168.24.10"
$prefix = "24"
$gateway = "192.168.24.1" 
$dns1 = "127.0.0.1"
$dns2 = "192.168.24.20"

$adaptername = $adapter.InterfaceAlias

# Stel het nieuwe IP-adres, subnetmasker, en gateway in
New-NetIPAddress -IPAddress $ipadres -PrefixLength $prefix -AddressFamily IPv4 -DefaultGateway $gateway -InterfaceAlias $adaptername

# Stel de DNS-servers in (primaire en secundaire)
Set-DnsClientServerAddress -InterfaceAlias $adaptername -ServerAddresses ($dns1, $dns2)

Set-ExecutionPolicy Unrestricted