<#
.SYNOPSIS
Install-MMA installs the Microsoft Monitoring Agent on a remote 
Windows Server and configures it for a Log Analytics workspace.
.DESCRIPTION
Install-MMA installs the Microsoft Monitoring Agent on a remote 
Windows Server and configures it for a Log Analytics workspace. 
It requires that the momagent.msi already be extracted from the 
agent installer.

Links to the agent installers:
Windows 64-bit agent - https://go.microsoft.com/fwlink/?LinkId=828603
Windows 32-bit agent - https://go.microsoft.com/fwlink/?LinkId=828604

To extract the installer:
MMASetup-<platform>.exe /c /t:<Path>

#Note: Install-MMA calls momagent.msi directly and so only installs 
the ENU version of the MMA. You will need to copy the language files
and setup.exe in addition to momagent.msi if you want to install 
under a different language. Then call setup.exe rather than 
momagent.msi.
.PARAMETER RemoteServer
The computer name to install the MMA on.
.EXAMPLE
Install-MMA -RemoteServer OMSAgent
#>
[CmdletBinding()]
param (
    [string]$RemoteServer="OMSAgent"
    )
[string]$LocalFile = "C:\Temp\momagent.msi"#<<<Change to where your source momagent.msi is located
[string]$WorkspaceId = ""#<<< Enter your Workspace ID here
[string]$WorkspaceKey = ""#<<< Enter your Workspace Key here

#Create a PSSession to the RemoteServer
$Session = New-PSSession -ComputerName $RemoteServer

#Check for the existence of C:\Windows\temp\MMASetup first and if it doesn't exist then create it
$Path = Test-Path -Path "\\$RemoteServer\c$\windows\temp\mmasetup"
    if ( $Path -eq $false ) { Invoke-Command -Session $Session -ScriptBlock { New-Item -ItemType Directory -Path c:\Windows\temp\mmasetup } }

#Copy the OMS agent ( momagent.msi ) from where we are executing the script to the target server
[string]$LocalFile = "C:\Temp\momagent.msi"
Copy-Item -Path $LocalFile -Destination "\\$RemoteServer\c$\windows\temp\MMASetup\momagent.msi"

#Install the Microsoft Monitoring Agent on the target server
$ScriptBlockContent =
    {
    Start-Process -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i","c:\windows\temp\mmasetup\momagent.msi","/qn","/l*v",
    "C:\windows\temp\mmasetup\MMAAgentInstall.log","NOAPM=1","AcceptEndUserLicenseAgreement=1" -Wait -NoNewWindow
    }
Invoke-Command -Session $Session -ScriptBlock $ScriptBlockContent
Start-Sleep -Seconds 60

#Configure the Microsoft Monitoring Agent with the Log Analytics workspace information
Invoke-Command -Session $Session -ScriptBlock {    
    $Mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
    $AddWorkspace = $Mma.AddCloudWorkspace($Using:WorkspaceId, $Using:WorkspaceKey)
    $AddWorkspace
    $ReloadConfig = $Mma.ReloadConfiguration()
    $ReloadConfig
    }