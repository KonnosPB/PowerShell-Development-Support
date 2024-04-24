<#
.SYNOPSIS
This function retrieves the published app packages from a specified dev suite.

.DESCRIPTION
The Get-DevSuitePublishedBCAppPackages function retrieves and outputs the details of all app packages that have been published in the specified dev suite. It invokes a web request to the dev suite and processes the response to extract app package information.

.PARAMETER DevSuite
This mandatory parameter specifies the name or description of the dev suite from which to retrieve app packages. It accepts pipeline input and aliases including "Name" and "Description".

.PARAMETER Tenant
This mandatory parameter specifies the tenant in the dev suite from which to retrieve app packages.

.EXAMPLE
Get-DevSuitePublishedBCAppPackages -DevSuite "Dev Suite 1" -Tenant "Tenant1"
This example retrieves all published app packages from the dev suite named "Dev Suite 1" for the tenant "Tenant1".

.EXAMPLE
"Dev Suite 1" | Get-DevSuitePublishedBCAppPackages -Tenant "Tenant1"
This example retrieves all published app packages from the dev suite named "Dev Suite 1" for the tenant "Tenant1", with the dev suite name provided via pipeline input.

#>
function Get-DevSuitePublishedBCAppPackages {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
        [string] $Tenant
    )    
    BEGIN {}

    PROCESS {
        Write-Debug "Getting published app app packages infos from devsuite '$DevSuite'"

        $devSuiteObj = Get-DevSuiteEnvironment -DevSuite $DevSuite
        $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant/$Tenant/appInfo"
        $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET'
        $appPackages = $response.Content | ConvertFrom-Json
        foreach ($appPackage in $appPackages){
            Write-Output $appPackage
        }        
    }
    END {}
}

Export-ModuleMember -Function Get-DevSuitePublishedBCAppPackages
New-Alias "Get-DevSuitePublishedApps" -Value Get-DevSuitePublishedBCAppPackages
New-Alias "Get-DevSuitePublishedAppPackages" -Value Get-DevSuitePublishedBCAppPackages
New-Alias "Get-DevSuitePublishedPackages" -Value Get-DevSuitePublishedBCAppPackages