<#
.SYNOPSIS
This function retrieves published Business Central App packages from a specific tenant in a DevSuite.

.DESCRIPTION
The Get-DevSuitePublishedBCAppPackages function uses the DevSuite, Tenant, and BearerToken parameters to retrieve a list of published Business Central App packages from a specific tenant in a DevSuite.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite from which the published Business Central App packages will be retrieved.

.PARAMETER Tenant
This is a mandatory parameter that specifies the tenant in the DevSuite from which the published Business Central App packages will be retrieved.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuitePublishedBCAppPackages -DevSuite "DevSuite1" -Tenant "Tenant1" -BearerToken "1234567890"

This example retrieves the published Business Central App packages from the tenant "Tenant1" in DevSuite "DevSuite1" using the BearerToken "1234567890" for authentication.
#>
function Get-DevSuitePublishedBCAppPackages {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )    
    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$Tenant/appInfo"
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET' -BearerToken $BearerToken
    $appPackages = $response.Content | ConvertFrom-Json
    return $appPackages
}

Export-ModuleMember -Function Get-DevSuitePublishedBCAppPackages