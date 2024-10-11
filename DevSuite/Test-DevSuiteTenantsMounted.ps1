<#
.SYNOPSIS
   This function verifies if DevSuite tenants are mounted.

.DESCRIPTION
   The Test-DevSuiteTenantsMounted function validates if any DevSuite tenants are mounted. 
   It uses the Get-DevSuiteTenants function to get the DevSuite details. It returns null if no DevSuite tenants are found. 
   Otherwise, it constructs a URI with the DevSuite name and tenant, and makes a 'GET' request to the URI. 
   It finally converts the response content into JSON format and returns it.

.PARAMETER DevSuite
   This is a mandatory parameter. It is a string representing the DevSuite.

.EXAMPLE
   Test-DevSuiteTenantsMounted -DevSuite "DevSuite1"
   This example checks if any tenants are mounted on the DevSuite named "DevSuite1".

.EXAMPLE
   $devSuite = "DevSuite1"
   Test-DevSuiteTenantsMounted -DevSuite $devSuite
   This example checks if any tenants are mounted on the DevSuite named "DevSuite1", using a variable to store the DevSuite name.
#>
function Test-DevSuiteTenantsMounted {
    Param (
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias("Name", "Description", "NameOrDescription")]
      [string] $DevSuite
    )
    $devSuite = Get-DevSuiteTenants -DevSuite $DevSuite 
    if (-not $devSuite) {
        return $null
    }

    $uri = Get-DevSuiteUri -Route "vm/$($devSuite.name)/tenant" -Parameter clearCache=true
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET' 
    $tenants = $response.Content | ConvertFrom-Json
    return $tenants
}

Export-ModuleMember -Function Test-DevSuiteTenantsMounted