
<#
.SYNOPSIS
Retrieves the available BC app packages from a specified DevSuite.

.DESCRIPTION
The Get-DevSuiteAvailableBCAppPackages function retrieves the available BC app packages from a specified DevSuite. It is a process that involves calling other functions like Get-DevSuiteEnvironment and Invoke-DevSuiteWebRequest to get the necessary details. The function then outputs the app packages found.

.PARAMETER DevSuite
This is a mandatory string parameter that specifies the DevSuite from which to retrieve the BC app packages. It has aliases "Name", "Description", and "NameOrDescription" for flexibility.

.EXAMPLE
Get-DevSuiteAvailableBCAppPackages -DevSuite "DevSuite1"

This command retrieves the BC app packages from the DevSuite named "DevSuite1".

.EXAMPLE
Get-DevSuiteAvailableBCAppPackages -Name "DevSuite1"

This command retrieves the BC app packages from the DevSuite named "DevSuite1". It uses the alias "Name" for the DevSuite parameter.

.EXAMPLE
Get-DevSuiteAvailableBCAppPackages -Description "DevSuite for development"

This command retrieves the BC app packages from the DevSuite with the description "DevSuite for development". It uses the alias "Description" for the DevSuite parameter.
#>
function Get-DevSuiteAvailableBCAppPackages {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite
    )
    BEGIN {
        Write-Debug "Getting all app packages infos from devsuite '$DevSuite'"
    }

    PROCESS {  
        $devSuiteObj = Get-DevSuiteEnvironment -DevSuite $DevSuite
        $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/bcpackages"
        $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET'
        $appPackages = $response.Content | ConvertFrom-Json
        foreach ($appPackage in $appPackages) {
            Write-Output $appPackage
        }    
    }
    END {}  
}

Export-ModuleMember -Function Get-DevSuiteAvailableBCAppPackages
New-Alias "Get-DevSuiteApps" -Value Get-DevSuiteAvailableBCAppPackages
New-Alias "Get-DevSuiteAppPackages" -Value Get-DevSuiteAvailableBCAppPackages
New-Alias "Get-DevSuitePackages" -Value Get-DevSuiteAvailableBCAppPackages