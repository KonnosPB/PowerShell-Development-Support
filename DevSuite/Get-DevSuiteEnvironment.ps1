<#
.SYNOPSIS
This function retrieves a specific DevSuite environment based on the provided Name or Description.

.DESCRIPTION
The Get-DevSuiteEnvironment function uses the NameOrDescription and BearerToken parameters to fetch a specific DevSuite environment. If the environment does not exist in the global DevSuiteEnvironments variable, the function will update it by invoking the Get-DevSuiteEnvironments function with the provided BearerToken.

.PARAMETER NameOrDescription
This is a mandatory parameter specifying the Name or Description of the DevSuite environment to be retrieved.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuiteEnvironment -NameOrDescription "DevSuite1" -BearerToken "1234567890"

This example retrieves the DevSuite environment with the name or description "DevSuite1", using the BearerToken 1234567890 for authentication.
#>
function Get-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $NameOrDescription,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )
    try {
        $devSuite = $Global:DevSuiteEnvironments | Where-Object { ($_.name -eq $NameOrDescription) -or ($_.projectDescription -eq $NameOrDescription) } | Select-Object -First 1
        if ($devSuite) {
            return $devSuite
        }
        $Global:DevSuiteEnvironments = Get-DevSuiteEnvironments -BearerToken $BearerToken
        $devSuiteObj = $Global:DevSuiteEnvironments | Where-Object { ($_.name -eq $NameOrDescription) -or ($_.projectDescription -eq $NameOrDescription) } | Select-Object -First 1
        if ($devSuiteObj) {
            return $devSuiteObj
        }
        return $null
    }
    catch {
        return $null
    }
}

Export-ModuleMember -Function Get-DevSuiteEnvironment