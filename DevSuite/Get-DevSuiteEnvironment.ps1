<#
.SYNOPSIS
This function returns a DevSuite environment that matches a given name or description.

.DESCRIPTION
The Get-DevSuiteEnvironment function retrieves the first DevSuite environment that matches the specified name or description. If no match is found, the function returns a null value. The function uses the global DevSuiteEnvironments variable to search for the environment.

.PARAMETER NameOrDescription
This is a mandatory parameter. It is the name or description of the DevSuite environment to be retrieved. The function uses this parameter to compare with the name or projectDescription properties of each DevSuite environment.

.EXAMPLES
Example 1: Get-DevSuiteEnvironment -NameOrDescription "Development"

This command returns the first DevSuite environment with the name or description "Development".

Example 2: Get-DevSuiteEnvironment -NameOrDescription "Test environment"

This command returns the first DevSuite environment with the name or description "Test environment". If there are no matches, the function returns a null value.
#>
function Get-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $NameOrDescription
    )
    try {
        $devSuite = $Global:DevSuiteEnvironments | Where-Object { ($_.name -eq $NameOrDescription) -or ($_.projectDescription -eq $NameOrDescription) } | Select-Object -First 1
        if ($devSuite) {
            return $devSuite
        }
        $Global:DevSuiteEnvironments = Get-DevSuiteEnvironments
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