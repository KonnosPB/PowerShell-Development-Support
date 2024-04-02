
<#
# Jira Module https://atlassianps.org/docs/JiraPS/
Install-Module JiraPS -Scope CurrentUser -ErrorAction SilentlyContinue# 
Update-Module JiraPS -ErrorAction SilentlyContinue

# Sharepoint Module https://www.koskila.net/how-to-use-microsoft-online-sharepoint-powershell-with-powershell-7/
# https://learn.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online
Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser -ErrorAction SilentlyContinue
Update-Module Microsoft.Online.SharePoint.PowerShell  -ErrorAction SilentlyContinue
#>

# Common
. (Join-Path $PSScriptRoot "InitializeModule.ps1")

# DevSuite
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteUri.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Invoke-DevSuiteWebRequest.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Test-DevSuiteBearerToken.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Update-DevSuiteBearerToken.ps1")
. (Join-Path $PSScriptRoot "DevSuite\New-DevSuiteEnvironment.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Test-DevSuiteEnvironment.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteEnvironment.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteEnvironments.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Wait-DevSuiteTenantsReady.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Test-DevSuiteTenantsMounted.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteTenants.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteTenant.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Invoke-DevSuiteMigrate.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Wait-DevSuiteTenantsReady.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Install-DevSuiteBCAppPackage.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteAvailableBCAppPackages.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuiteAvailableBCAppPackage.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Get-DevSuitePublishedBCAppPackages.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Import-DevSuiteLicense.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Invoke-DevSuiteCopy.ps1")
. (Join-Path $PSScriptRoot "DevSuite\New-DevSuiteUser.ps1")
. (Join-Path $PSScriptRoot "DevSuite\Import-DevSuiteTestToolkit.ps1")

# DevOps
. (Join-Path $PSScriptRoot "DevOps\Get-AzureDevOpsUri.ps1")
. (Join-Path $PSScriptRoot "DevOps\Invoke-AzureDevOpsWebRequest.ps1")
. (Join-Path $PSScriptRoot "DevOps\Get-AzureDevOpsRepositories.ps1")
. (Join-Path $PSScriptRoot "DevOps\Get-AzureDevOpsMasterBranchPullRequests.ps1")

# Jira
. (Join-Path $PSScriptRoot "Jira\Get-JiraUri.ps1")
. (Join-Path $PSScriptRoot "Jira\Invoke-JiraWebRequest.ps1")
#. (Join-Path $PSScriptRoot "Jira\Get-JiraTicketsFromPullRequests.ps1")
#. (Join-Path $PSScriptRoot "Jira\Add-JiraTicketsToPullRequests")
. (Join-Path $PSScriptRoot "Jira\Get-JiraTicketsFromSolutionVersion.ps1")


# Common
. (Join-Path $PSScriptRoot "Common\New-ReleaseOverview.ps1")
. (Join-Path $PSScriptRoot "Common\Test-PSDevSupportEnvironment.ps1")
. (Join-Path $PSScriptRoot "Common\Get-BusinessCentralArtifactUrl.ps1")

