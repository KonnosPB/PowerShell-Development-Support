<#
.SYNOPSIS
This function creates a new user in the specified Development Suite and Tenant.

.DESCRIPTION
The New-DevSuiteUser function uses the Invoke-DevSuiteWebRequest to send a POST request to the corresponding DevSuite and Tenant specified by the user. The UserName is used as the new user's name. 

.PARAMETER DevSuite
Specifies the Development Suite where the user will be created. This parameter is mandatory.

.PARAMETER Tenant
Specifies the Tenant where the user will be created. This parameter is mandatory.

.PARAMETER UserName
Specifies the name of the new user to be created. This parameter is mandatory.

.EXAMPLE
New-DevSuiteUser -DevSuite "DevSuite1" -Tenant "Tenant1" -UserName "User1"

This example creates a new user named User1 in the DevSuite1 and Tenant1.
#>
function New-DevSuiteUser {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $true)]
        [string] $UserName
    )      

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$Tenant/user/$UserName"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' 
}

Export-ModuleMember -Function New-DevSuiteUser