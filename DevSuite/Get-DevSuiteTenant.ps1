<#
.SYNOPSIS
This function retrieves a specific tenant from a specified DevSuite.

.DESCRIPTION
The Get-DevSuiteTenant function uses the DevSuite, Tenant, and BearerToken parameters to retrieve a specific tenant from a specified DevSuite. If the tenant does not exist, the function will return null.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite from which the tenant will be retrieved.

.PARAMETER Tenant
This is a mandatory parameter that specifies the name of the tenant to be retrieved from the specified DevSuite.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuiteTenant -DevSuite "DevSuite1" -Tenant "Tenant1" -BearerToken "1234567890"

This example retrieves the tenant "Tenant1" from DevSuite "DevSuite1" using the BearerToken "1234567890" for authentication.
#>
function Get-DevSuiteTenant {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )
    $tenants = Get-DevSuiteTenants -DevSuite $DevSuite -BearerToken $BearerToken
    $tenantObj = $tenants | Where-Object { $_.name -eq $Tenant } | Select-Object -First 1    
    return $tenantObj
}

Export-ModuleMember -Function Get-DevSuiteTenant
