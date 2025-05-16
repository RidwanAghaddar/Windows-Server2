# Configuraties
$CAName = "ws2-2425-ridwan-SERVER1-CA"
$GPOName = "Root CA Certificate Distribution"
$OUPath = "DC=ws2-2425-ridwan,DC=hogent"
$exportPath = "C:\Temp\MyRootCA.cer"

Install-AdcsWebEnrollment -Force

# Controle en aanmaak exportpad
if (!(Test-Path -Path (Split-Path -Path $exportPath -Parent))) {
    New-Item -ItemType Directory -Path (Split-Path -Path $exportPath -Parent) -Force
}

# Rootcertificaat ophalen
$rootCert = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*$CAName*" } | Select-Object -First 1

if ($rootCert) {
    # Certificaat exporteren
    Export-Certificate -Cert $rootCert -FilePath $exportPath -Force -Verbose
    Write-Output "Root CA certificaat geëxporteerd naar $exportPath."
} else {
    Write-Output "Fout: Het rootcertificaat '$CAName' werd niet gevonden."
    exit
}

# GPO aanmaken of ophalen
$gpo = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $GPOName -Verbose
    Write-Output "Nieuwe GPO '$GPOName' aangemaakt."
} else {
    Write-Output "GPO '$GPOName' bestaat al."
}

# Certificaat toevoegen met certutil
try {
    $certutilCommand = "certutil -f -addstore -enterprise -groupPolicy Root `"$exportPath`""
    Invoke-Expression $certutilCommand
    Write-Output "Certificaat toegevoegd aan de GPO."
} catch {
    Write-Output "Fout bij het toevoegen van certificaat aan GPO: $($_.Exception.Message)"
    exit
}

# GPO koppelen aan domein
$linkedGPOs = Get-GPInheritance -Target $OUPath | Where-Object { $_.GpoName -eq $GPOName }
if (-not $linkedGPOs) {
    New-GPLink -Name $GPOName -Target $OUPath -Verbose
    Write-Output "GPO '$GPOName' gekoppeld aan het domein $OUPath."
} else {
    Write-Output "GPO '$GPOName' is al gekoppeld aan $OUPath."
}

Write-Output "Root CA certificaatdistributie voltooid."