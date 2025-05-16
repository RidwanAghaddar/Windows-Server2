# Installatie van CA
Install-WindowsFeature -Name AD-Certificate -IncludeManagementTools
write-host "AD-Certificate geinstalleerd"

Install-AdcsCertificationAuthority -Force
write-host "CA geinstalleerd"

Install-WindowsFeature -Name Web-Server -IncludeManagementTools 
write-host "Web-Server geinstalleerd"

Install-WindowsFeature -Name ADCS-Web-Enrollment -IncludeManagementTools
write-host "ADCS-Web-Enrollment geinstalleerd"
