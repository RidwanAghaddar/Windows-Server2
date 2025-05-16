# Lijst van RSAT features die geïnstalleerd moeten worden
$rsatFeatures = @(
    "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0",
    "Rsat.Dns.Tools~~~~0.0.1.0",
    "Rsat.Dhcp.Tools~~~~0.0.1.0",
    "Rsat.FileServices.Tools~~~~0.0.1.0",
    "Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0",
    "Rsat.IPAM.Client.Tools~~~~0.0.1.0",
    "Rsat.NetworkController.Tools~~~~0.0.1.0",
    "Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0",
    "Rsat.ServerManager.Tools~~~~0.0.1.0",
    "Rsat.CertificateServices.Tools~~~~0.0.1.0"
    "Rsat.IIS.Tools~~~~0.0.1.0"
)

# Installeer de RSAT features
foreach ($feature in $rsatFeatures) {
    try {
        Add-WindowsCapability -Online -Name $feature -Verbose
        Write-Host "Successfully installed $feature" 
    } catch {
        Write-Host "Failed to install $feature : $_" 
    }
}