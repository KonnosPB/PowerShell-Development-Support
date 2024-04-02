<#
.SYNOPSIS
This function checks if the tenants in a specified DevSuite are mounted.

.DESCRIPTION
The Test-DevSuiteTenantsMounted function checks if the tenants in a specified DevSuite are mounted by sending a GET request to the DevSuite Uri. The function returns the tenants if they are mounted, or null if the DevSuite is not found.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the name of the DevSuite.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.EXAMPLE
Test-DevSuiteTenantsMounted -DevSuite "DevSuite1" -BearerToken "abc123"

This example checks if the tenants in the DevSuite named "DevSuite1" are mounted, using the bearer token "abc123". The function returns the tenants if they are mounted, or null if the DevSuite is not found.
#>
function Test-DevSuiteTenantsMounted {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )
    $devSuite = Get-DevSuiteTenants -DevSuite $DevSuite -BearerToken $BearerToken
    if (-not $devSuite) {
        return $null
    }

    $uri = Get-DevSuiteUri -Route "vm/$($devSuite.name)/tenant" -Parameter clearCache=true
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET' -BearerToken $BearerToken
    $tenants = $response.Content | ConvertFrom-Json
    return $tenants
}

Export-ModuleMember -Function Test-DevSuiteTenantsMounted