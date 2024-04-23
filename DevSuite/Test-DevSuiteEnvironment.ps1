<#
.SYNOPSIS
This function checks if a DevSuite environment exists based on the provided name or description.

.DESCRIPTION
The 'Test-DevSuiteEnvironment' function is used to check if a DevSuite environment exists. It accepts a name or description as a parameter and returns a boolean value, true if the environment exists and false if it does not.

.PARAMETER NameOrDescription
This parameter accepts a string value. The value can either be the name or description of the DevSuite environment that is to be checked. This parameter is mandatory.

.EXAMPLE
```powershell
PS C:\> Test-DevSuiteEnvironment -NameOrDescription "Test Environment"
```
This command checks if a DevSuite environment with the name or description "Test Environment" exists and returns true or false.

.EXAMPLE
```powershell
PS C:\> Test-DevSuiteEnvironment -NameOrDescription "NonExistentEnvironment"
```
This command checks if a DevSuite environment with the name or description "NonExistentEnvironment" exists. Since no such environment exists, it will return false.
#>
function Test-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite
    )
    $devSuiteEnvironment = Get-DevSuiteEnvironment -NameOrDescription $DevSuite 
    if ($devSuiteEnvironment) {
        return $true
    }
    return $false
}

Export-ModuleMember -Function Test-DevSuiteEnvironment