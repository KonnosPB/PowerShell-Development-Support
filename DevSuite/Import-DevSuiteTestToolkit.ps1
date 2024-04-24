<#
.SYNOPSIS
The Import-DevSuiteTestToolkit function is used to import the DevSuite Test Toolkit into a specific tenant.

.DESCRIPTION
The Import-DevSuiteTestToolkit function is a powershell function that is used to import the DevSuite Test Toolkit into a tenant. It uses the Invoke-DevSuiteWebRequest function to send a POST request to the DevSuite API. The function can also be configured to only include the test libraries or the test framework.

.PARAMETER DevSuite
This is a mandatory string parameter that specifies the DevSuite to be imported.

.PARAMETER Tenant
This is a mandatory string parameter that specifies the tenant into which the DevSuite Test Toolkit will be imported.

.PARAMETER IncludeTestLibrariesOnly
This is a bool parameter that is optional. If set to true, only the test libraries will be imported. By default, it is set to true.

.PARAMETER IncludeTestFrameworkOnly
This is a bool parameter that is optional. If set to true, only the test framework will be imported. By default, it is set to false.

.EXAMPLE
Import-DevSuiteTestToolkit -DevSuite "DevSuite1" -Tenant "Tenant1"

This example will import the DevSuite Test Toolkit into the specified tenant with only the test libraries.

.EXAMPLE
Import-DevSuiteTestToolkit -DevSuite "DevSuite1" -Tenant "Tenant1" -IncludeTestFrameworkOnly $true

This example will import the DevSuite Test Toolkit into the specified tenant with only the test framework.
#>
function Import-DevSuiteTestToolkit {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $false)]
        [bool] $IncludeTestLibrariesOnly = $true,
        [Parameter(Mandatory = $false)]
        [bool] $IncludeTestFrameworkOnly = $false
    )   
    Write-Host "Importing test tool kit into devsuite '$DevSuite' tenant '$Tenant'" -ForegroundColor Green
    $devSuiteObj = Get-DevSuiteEnvironment -DevSuite $DevSuite
    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant/$Tenant/importtesttoolkit" -Parameter "includeTestLibrariesOnly=$IncludeTestLibrariesOnly&includeTestFrameworkOnly=$IncludeTestFrameworkOnly"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST'
}

Export-ModuleMember -Function Import-DevSuiteTestToolkit