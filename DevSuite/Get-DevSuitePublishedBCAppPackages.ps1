<#
.SYNOPSIS
This function retrieves the published Business Central application packages from a specific DevSuite tenant.

.DESCRIPTION
Get-DevSuitePublishedBCAppPackages is a function that queries the DevSuite environment for the list of published Business Central application packages. It uses DevSuite's web request functionality to make a GET request to the specified tenant's appInfo route.

.PARAMETER DevSuite
A mandatory parameter. This is the DevSuite environment from which the function retrieves the application packages.

.PARAMETER Tenant
A mandatory parameter. This is the specific tenant in the DevSuite environment from which the function retrieves the application packages.

.EXAMPLE
Get-DevSuitePublishedBCAppPackages -DevSuite "TestEnvironment" -Tenant "Tenant1"

This example retrieves the published Business Central application packages from the "Tenant1" in the "TestEnvironment" DevSuite environment.
#>
function Get-DevSuitePublishedBCAppPackages {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant
    )    
    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$Tenant/appInfo"
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET'
    $appPackages = $response.Content | ConvertFrom-Json
    return $appPackages
}

Export-ModuleMember -Function Get-DevSuitePublishedBCAppPackages