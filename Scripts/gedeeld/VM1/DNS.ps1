# Definieer domeinnaam en reverse lookup zone
$domainName = "WS2-2425-ridwan.hogent"
$reverseLookupZone = "24.168.192.in-addr.arpa"


# Functie om fouten te loggen
function Write-ErrorLog {
    param (
        [string]$message,
        [System.Management.Automation.ErrorRecord]$errorRecord
    )
    Write-Host "FOUT: $message" 
    Write-Host "Foutdetails: $($errorRecord.Exception.Message)" 
}

# Maak de forward lookup zone aan
try {
    Add-DnsServerPrimaryZone -Name $domainName -ZoneFile "$domainName.dns" -DynamicUpdate Secure
    Write-Host "Forward lookup zone $domainName succesvol aangemaakt." 
} catch {
    Write-ErrorLog "Mislukt om forward lookup zone aan te maken" $_
}

# Maak de reverse lookup zone aan
try {
    Add-DnsServerPrimaryZone -Name $reverseLookupZone -ZoneFile "$reverseLookupZone.dns" -DynamicUpdate Secure
    Write-Host "Reverse lookup zone $reverseLookupZone succesvol aangemaakt." 
} catch {
    Write-ErrorLog "Mislukt om reverse lookup zone aan te maken" $_
}

# Voeg A- en PTR-records toe
try {
    # A-records
    Add-DnsServerResourceRecordA -Name "server1" -ZoneName $domainName -IPv4Address "192.168.24.10"
    Add-DnsServerResourceRecordA -Name "server2" -ZoneName $domainName -IPv4Address "192.168.24.20"
    Add-DnsServerResourceRecordA -Name "client" -ZoneName $domainName -IPv4Address "192.168.24.101"

    # PTR-records
    Add-DnsServerResourceRecordPtr -Name "10" -ZoneName $reverseLookupZone -PtrDomainName "server1.$domainName"
    Add-DnsServerResourceRecordPtr -Name "20" -ZoneName $reverseLookupZone -PtrDomainName "server2.$domainName"
    Add-DnsServerResourceRecordPtr -Name "101" -ZoneName $reverseLookupZone -PtrDomainName "client.$domainName"

    Write-Host "A- en PTR-records succesvol toegevoegd."
} catch {
    Write-ErrorLog "Mislukt om A- of PTR-records toe te voegen" $_
}