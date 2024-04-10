<#
.SYNOPSIS
This function retrieves available BC app packages for a specified DevSuite.

.DESCRIPTION
The Get-DevSuiteAvailableBCAppPackages function sends a GET request to a DevSuite's BC packages route. It uses the Invoke-DevSuiteWebRequest function to send this request and receives a response. The response content is converted from JSON format and returned as the result.

.PARAMETER DevSuite
This is the mandatory string parameter that specifies the DevSuite for which the BC app packages are to be retrieved.

.EXAMPLE
Get-DevSuiteAvailableBCAppPackages -DevSuite "DevSuite1"

This command retrieves the available BC app packages for the DevSuite named "DevSuite1".

#>function Get-DevSuiteAvailableBCAppPackages {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite
    )
    Write-Debug "Getting all app packages infos from devsuite '$DevSuite'" -ForegroundColor Gray

    $devSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $DevSuite
    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/bcpackages"
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET'
    $appPackages = $response.Content | ConvertFrom-Json
    return $appPackages
}

Export-ModuleMember -Function Get-DevSuiteAvailableBCAppPackages