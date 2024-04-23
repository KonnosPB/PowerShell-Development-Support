<#
.SYNOPSIS
The Get-DevSuiteEnvironment function retrieves the information of a specific DevSuite environment based on its name or description.

.DESCRIPTION
The Get-DevSuiteEnvironment function is used to fetch and display the details of a DevSuite environment. It can accept the name or description of the environment as an input parameter. This function searches for the environment in the global DevSuiteEnvironments object and returns the first match.

.PARAMETER NameOrDescription
This is a mandatory string parameter. It can accept either the name or description of a DevSuite environment. The function will match this parameter against the name or project description of the environments stored in the global DevSuiteEnvironments object.

.EXAMPLE
Get-DevSuiteEnvironment -NameOrDescription "Test Environment"
This will fetch and display the details of the "Test Environment" from the global DevSuiteEnvironments object.

.EXAMPLE
"Test Environment" | Get-DevSuiteEnvironment
This will also fetch and display the details of the "Test Environment" from the global DevSuiteEnvironments object. Here, the input is passed through the pipeline.
#>
function Get-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "DevSuite")]
        [string] $NameOrDescription
    )
    BEGIN {}

    PROCESS {
        try {
            $devSuiteObj = $Global:DevSuiteEnvironments | Where-Object { ($_.name -eq $NameOrDescription) -or ($_.projectDescription -eq $NameOrDescription) } | Select-Object -First 1
            if ($devSuiteObj) {
                Write-Output $devSuiteObj             
            }
        
            Write-Debug "Getting devsuite info of '$NameOrDescription'"
            $Global:DevSuiteEnvironments = Get-DevSuiteEnvironments
            $devSuiteObj = $Global:DevSuiteEnvironments | Where-Object { ($_.name -eq $NameOrDescription) -or ($_.projectDescription -eq $NameOrDescription) } | Select-Object -First 1         
            Write-Output $devSuiteObj
        }
        catch {
            Write-Output $null
        }
    }
    END {}  
}

Export-ModuleMember -Function Get-DevSuiteEnvironment