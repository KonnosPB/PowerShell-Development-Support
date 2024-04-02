<#
.SYNOPSIS
This function fetches the tenants from a specified DevSuite.

.DESCRIPTION
The Get-DevSuiteTenants function uses the DevSuite and BearerToken parameters to retrieve a list of tenants from a specified DevSuite. It first fetches the DevSuite environment object based on the provided DevSuite name and then fetches the tenants associated with that DevSuite environment.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite from which the tenants will be fetched.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuiteTenants -DevSuite "DevSuite1" -BearerToken "1234567890"

This example fetches the tenants from DevSuite1 using the BearerToken 1234567890 for authentication.
#>
function Get-DevSuiteTenants {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )
    $devSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $DevSuite -BearerToken $BearerToken
    if (-not $devSuiteObj) {
        return $null
    }

    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant" -Parameter "clearCache=true"
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET' -BearerToken $BearerToken
    $tenants = $response.Content | ConvertFrom-Json
    return $tenants
}

Export-ModuleMember -Function Get-DevSuiteTenants2