<#
.SYNOPSIS
This function retrieves a specific tenant from a specified DevSuite.

.DESCRIPTION
The Get-DevSuiteTenant function takes in two mandatory parameters - DevSuite and Tenant. It retrieves the list of tenants under the specified DevSuite, filters out the required tenant, and returns it. This function is useful when you need information about a specific tenant from a particular DevSuite.

.PARAMETER DevSuite
This is a mandatory parameter. It specifies the DevSuite from which the tenant needs to be retrieved. It should be a string value.

.PARAMETER Tenant
This is a mandatory parameter. It specifies the tenant that needs to be retrieved from the given DevSuite. It should be a string value.

.EXAMPLE
Get-DevSuiteTenant -DevSuite "DevSuite1" -Tenant "Tenant1"

This command will retrieve the tenant "Tenant1" from the DevSuite "DevSuite1".

.EXAMPLE
$tenant = Get-DevSuiteTenant -DevSuite "DevSuite2" -Tenant "Tenant2"
Write-Output $tenant

This command will retrieve the tenant "Tenant2" from the DevSuite "DevSuite2" and store it in the $tenant variable. The Write-Output command will then print the tenant information to the console.
#>
function Get-DevSuiteTenant {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant
    )
    $tenants = Get-DevSuiteTenants -DevSuite $DevSuite
    $tenantObj = $tenants | Where-Object { $_.name -eq $Tenant } | Select-Object -First 1    
    return $tenantObj
}

Export-ModuleMember -Function Get-DevSuiteTenant
