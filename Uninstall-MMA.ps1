[CmdletBinding()]
param (
    [string]$RemoteServer = "SC-SCOM16-AG1"#<<< Remote SCOM agent here
    )

#Create a PSSession to the RemoteServer
$Session = New-PSSession -ComputerName $RemoteServer

#Uninstall the Microsoft Monitoring Agent from a remote server
Invoke-Command -Session $Session -ScriptBlock {
    $app = Get-WmiObject -ClassName Win32_Product | Where-Object { $_.name -eq "Microsoft Monitoring Agent" }
    $app.Uninstall()
}