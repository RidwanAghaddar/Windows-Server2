# Laat inkomend ICMP-verkeer (ping-verzoeken) toe van het opgegeven IP-bereik
New-NetFirewallRule -DisplayName "Allow ICMPv4 Inbound from 192.168.24.0/24" `
    -Direction Inbound `
    -Protocol ICMPv4 `
    -ICMPType 8 `
    -RemoteAddress 192.168.24.0/24 `
    -Action Allow

# Laat uitgaand ICMP-verkeer (ping-antwoorden) toe naar het opgegeven IP-bereik
New-NetFirewallRule -DisplayName "Allow ICMPv4 Outbound to 192.168.24.0/24" `
    -Direction Outbound `
    -Protocol ICMPv4 `
    -ICMPType 0 `
    -RemoteAddress 192.168.24.0/24 `
    -Action Allow

# Laat inkomend HTTP- en HTTPS-verkeer toe 
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow

# Laat in- en uitgaand SQL-verkeer toe
New-NetFirewallRule -DisplayName "Allow SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
New-NetFirewallRule -DisplayName "Allow SQL Server Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
