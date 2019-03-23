[CmdletBinding()]
param (
    [string]$RemoteServer="OMSAgent"#<<< Name of the server you are connecting to remotely to configure
    )
[string]$WorkspaceId = "230335f0-2392-4823-9e4a-f47b9482e980"#<<< Enter your Workspace ID here
[string]$WorkspaceKey = "udWazjInW1mMK9Qchwj5Xoq0MZXS+cdvL1DNjqkJvsfZlUX1k/Vnzu7X9Ogr35N8A87DGqCQqGN9MzWS8Gta7w=="#<<< Enter your Workspace Key here

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