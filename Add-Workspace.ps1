[CmdletBinding()]
param (
    [string]$RemoteServer="OMSAgent"#<<< Name of the server you are connecting to remotely to configure
    )
[string]$WorkspaceId = ""#<<< Enter your Workspace ID here
[string]$WorkspaceKey = ""#<<< Enter your Workspace Key here

#Create a PSSession to the RemoteServer
$Session = New-PSSession -ComputerName $RemoteServer

#Configure the Microsoft Monitoring Agent with the Log Analytics workspace information
Invoke-Command -Session $Session -ScriptBlock {
    $Mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
    $AddWorkspace = $Mma.AddCloudWorkspace($Using:WorkspaceId, $Using:WorkspaceKey)
    $AddWorkspace
    $ReloadConfig = $Mma.ReloadConfiguration()
    $ReloadConfig
    }
