<#
.SYNOPSIS
This function fetches all available Business Central App packages from a specified DevSuite.

.DESCRIPTION
The Get-DevSuiteAvailableBCAppPackages function uses the DevSuite and BearerToken parameters to retrieve a list of all available Business Central App packages from a specified DevSuite. 

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite from which the available Business Central App packages will be fetched.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuiteAvailableBCAppPackages -DevSuite "DevSuite1" -BearerToken "1234567890"

This example fetches all available Business Central App packages from DevSuite1 using the BearerToken 1234567890 for authentication.
#>
function Get-DevSuiteAvailableBCAppPackages {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/bcpackages"
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET' -BearerToken $BearerToken
    $appPackages = $response.Content | ConvertFrom-Json
    return $appPackages
}

Export-ModuleMember -Function Get-DevSuiteAvailableBCAppPackages