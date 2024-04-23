<#
.SYNOPSIS
This function retrieves all tenants from a specific DevSuite.

.DESCRIPTION
The Get-DevSuiteTenants function retrieves and outputs the details of all tenants from the specified DevSuite. 
It first gets the DevSuite environment based on the input parameter and then it invokes a web request to the DevSuite with a specific route. 
The response is then converted from Json to output the tenants.

.PARAMETER DevSuite
This mandatory parameter specifies the name or description of the DevSuite from which to retrieve tenants. 
It accepts pipeline input and aliases including "Name", "Description", and "NameOrDescription".

.EXAMPLE
Get-DevSuiteTenants -DevSuite "Dev Suite 1"
This example retrieves all tenants from the DevSuite named "Dev Suite 1".

.EXAMPLE
"Dev Suite 1" | Get-DevSuiteTenants
This example retrieves all tenants from the DevSuite named "Dev Suite 1", with the DevSuite name provided via pipeline input.

#>
function Get-DevSuiteTenants {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite
    )
    BEGIN {
        Write-Debug "Getting all tenant infos from devsuite '$DevSuite'" 
    }

    PROCESS {
        
        $devSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $DevSuite
        if (-not $devSuiteObj) {
            return $null
        }

        $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant" -Parameter "clearCache=true"
        $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET'
        $tenants = $response.Content | ConvertFrom-Json
        foreach ($tenant in $tenants) {
            Write-Output $tenant
        }
    }
    END {}
}

Export-ModuleMember -Function Get-DevSuiteTenants