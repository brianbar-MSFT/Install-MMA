# Install-MMA - Remote install of Microsoft Monitoring Agent  

Install-MMA is PowerShell I wrote for a customer last year to deploy the Microsoft Monitoring Agent remotely to servers.

It uses PowerShell Remoting. It also includes a few other scripts to help manage the MMA later as needed. This was built to help customers install/upgrade to the Log Analytics version of the MMA but can also be used to deploy the SCOM version as well.

## Requirements

- Download the Microsoft Monitoring Agent
  - Windows 64-bit agent - https://go.microsoft.com/fwlink/?LinkId=828603
  - Windows 32-bit agent - https://go.microsoft.com/fwlink/?LinkId=828604
- Extract the momagent.msi from the Agent .exe
  - `MMASetup-<platform>.exe /c /t:<Path>`
- The Log Analytics workspace ID
- The Log Analytics workspace key
- Ensure PowerShell remoting is enabaled in the environment

## Implementation

Install-MMA has a single parameter: RemoteServer

Example: `Install-MMA -RemoteServer OMSAgent`

You will need to do the following in the code to use:

- Define RemoteServer if you don't use the parameter
- Provide the location of the momagent.msi that you extracted
- Enter the Workspace ID
- Enter the Workspace key