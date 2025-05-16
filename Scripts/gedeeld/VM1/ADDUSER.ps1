# Parameters
$UserName = "ridwan" # Gebruikersnaam voor de nieuwe rootgebruiker
$DisplayName = "Ridwan Admin"                    
$Password = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force # Wachtwoord
$OU = "CN=Users,DC=WS2-2425-ridwan,DC=hogent"   # Organizational Unit
$Description = "Root domeinbeheerder account"

# Importeer de Active Directory module
Import-Module ActiveDirectory

# Controleer of de gebruiker al bestaat
if (Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue) {
    Write-Host "Gebruiker '$UserName' bestaat al." 
    exit 0
}

# Maak de rootgebruiker aan
New-ADUser `
    -SamAccountName $UserName `
    -Name $DisplayName `
    -UserPrincipalName "$UserName@$domainName" `
    -Path $OU `
    -AccountPassword $Password `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -Description $Description `
    -ChangePasswordAtLogon $false

Write-Host "Gebruiker '$UserName' succesvol aangemaakt." 

# Voeg de gebruiker toe aan de groep Domain Admins
Add-ADGroupMember -Identity "Domain Admins" -Members $UserName
Write-Host "Gebruiker '$UserName' toegevoegd aan de groep 'Domain Admins'." 