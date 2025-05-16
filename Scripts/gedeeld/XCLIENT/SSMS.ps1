# Configuratievariabelen
$dest = 'Z:\Scripts\SSMS-Setup-ENU.exe' # Pas dit pad aan indien nodig
$install_path = "C:\Program Files\SSMS"
$params = "/Install /Passive SSMSInstallRoot=`"$install_path`""

# Controleer of het gedownloade bestand bestaat
if (Test-Path -Path $dest) {
    try {
        # Start de installatie
        Write-Host "Starting SSMS installation..."
        Start-Process -FilePath $dest -ArgumentList $params -Wait -NoNewWindow
        Write-Host "SSMS installation completed successfully."
    } catch {
        Write-Error "Failed to install SSMS. Error: $_"
        exit 1
    }
} else {
    Write-Error "Setup file not found at $dest. Cannot proceed with installation."
    exit 1
}
