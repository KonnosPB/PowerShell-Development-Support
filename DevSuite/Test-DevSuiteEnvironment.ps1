<#
.SYNOPSIS
This function tests if a specified DevSuite environment exists.

.DESCRIPTION
The Test-DevSuiteEnvironment function checks if a specified DevSuite environment exists. It uses the Get-DevSuiteEnvironment function to retrieve the environment based on the provided NameOrDescription. If the environment exists, the function returns $true, otherwise it returns $false.

.PARAMETER NameOrDescription
The NameOrDescription parameter is a mandatory string parameter that specifies the name or description of the DevSuite environment to be checked.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token used for authenticating the web request.

.EXAMPLE
Test-DevSuiteEnvironment -NameOrDescription "DevSuite1" -BearerToken "abc123"

This example checks if a DevSuite environment with the name or description "DevSuite1" exists, using the bearer token "abc123".
#>
function Test-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $NameOrDescription,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )
    $devSuiteEnvironment = Get-DevSuiteEnvironment -NameOrDescription $NameOrDescription -BearerToken $BearerToken
    if ($devSuiteEnvironment) {
        return $true
    }
    return $false
}

Export-ModuleMember -Function Test-DevSuiteEnvironment