<#
.SYNOPSIS
This function imports the test toolkit for a specified DevSuite and Tenant.

.DESCRIPTION
The Import-DevSuiteTestToolkit function imports the test toolkit for a specified DevSuite and Tenant. The function makes a POST web request to the DevSuite Uri retrieved by the Get-DevSuiteUri function. The Uri includes parameters for specifying whether to include only test libraries or the test framework.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the name of the DevSuite.

.PARAMETER Tenant
The Tenant parameter is a mandatory string parameter that specifies the name of the Tenant.

.PARAMETER IncludeTestLibrariesOnly
The IncludeTestLibrariesOnly parameter is an optional boolean parameter that specifies whether to include only test libraries in the import. The default value is $true.

.PARAMETER IncludeTestFrameworkOnly
The IncludeTestFrameworkOnly parameter is an optional boolean parameter that specifies whether to include only the test framework in the import. The default value is $false.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.EXAMPLE
Import-DevSuiteTestToolkit -DevSuite "DevSuite1" -Tenant "Tenant1" -BearerToken "abc123"

This example imports the test toolkit for the DevSuite named "DevSuite1" and the Tenant named "Tenant1", using the bearer token "abc123". By default, it includes only test libraries in the import.
#>
function Import-DevSuiteTestToolkit {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $false)]
        [bool] $IncludeTestLibrariesOnly = $true,
        [Parameter(Mandatory = $false)]
        [bool] $IncludeTestFrameworkOnly = $false,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )   

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$Tenant/importtesttoolkit" -Parameter "includeTestLibrariesOnly=$IncludeTestLibrariesOnly&includeTestFrameworkOnly=$IncludeTestFrameworkOnly"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' -BearerToken $BearerToken
}

Export-ModuleMember -Function Import-DevSuiteTestToolkit