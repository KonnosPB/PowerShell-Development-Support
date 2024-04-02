<#
.SYNOPSIS
This function retrieves a list of DevSuite environments using a bearer token.

.DESCRIPTION
The Get-DevSuiteEnvironments function uses the BearerToken parameter to authenticate and fetch a list of available DevSuite environments. This function also handles errors and returns an empty array if any exception is encountered.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuiteEnvironments -BearerToken "1234567890"

This example retrieves the list of DevSuite environments using the BearerToken 1234567890 for authentication.
#>
function Get-DevSuiteEnvironments {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )
    try {
        $uri = Get-DevSuiteUri -Route "vm" -Parameter "clearCache=false"
        $result = Invoke-DevSuiteWebRequest -Uri $uri -Method "GET" -BearerToken $BearerToken -SkipErrorHandling
        if ($result.StatusCode -ne 200) {
            return false;
        }
        $jsonDevSuite = $result.Content | ConvertFrom-Json
        return $jsonDevSuite;        
    }
    catch {
        return @()
    }
}
Export-ModuleMember -Function Get-DevSuiteEnvironments