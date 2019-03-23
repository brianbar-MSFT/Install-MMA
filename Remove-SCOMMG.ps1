[CmdletBinding()]
param (
    [string]$ManagementGroup="SCOM2016",#<<< Management Group name here
    [string]$RemoteServer = "SC-SCOM16-AG1"#<<< Remote SCOM agent here
    )

#Create a PSSession to the RemoteServer
$Session = New-PSSession -ComputerName $RemoteServer

#Remove the SCOM Management Group from the RemoteServer agent
Invoke-Command -Session $Session -ScriptBlock {    
    $Mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
    $Mgs = $Mma.GetManagementGroups() | 
        ForEach-Object {$_.managementGroupName}
            if ($Mgs -contains $Using:ManagementGroup) {
                $Mma.RemoveManagementGroup($Using:ManagementGroup)
                $Mma.ReloadConfiguration()
                return "$Using:ManagementGroup removed from $Using:RemoteServer"
            }
        }