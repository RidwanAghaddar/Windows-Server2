$username = "WS2-2425-ridwan.hogent\vagrant"
$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force

$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Add-Computer -DomainName "WS2-2425-ridwan.hogent" -Credential $credential

Read-Host "Druk op enter om de computer te herstarten"
Restart-Computer
