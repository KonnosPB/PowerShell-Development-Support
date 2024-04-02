<#
.SYNOPSIS
This function creates a new user for a specified DevSuite and Tenant.

.DESCRIPTION
The New-DevSuiteUser function creates a new user for a specified DevSuite and Tenant. The function makes a POST web request to the DevSuite Uri retrieved by the Get-DevSuiteUri function. The Uri includes the DevSuite name, Tenant name and the new UserName.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the name of the DevSuite.

.PARAMETER Tenant
The Tenant parameter is a mandatory string parameter that specifies the name of the Tenant.

.PARAMETER UserName
The UserName parameter is a mandatory string parameter that specifies the name of the new user to be created.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.EXAMPLE
New-DevSuiteUser -DevSuite "DevSuite1" -Tenant "Tenant1" -UserName "User1" -BearerToken "abc123"

This example creates a new user named "User1" for the DevSuite named "DevSuite1" and the Tenant named "Tenant1", using the bearer token "abc123".
#>
function New-DevSuiteUser {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $true)]
        [string] $UserName,        
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )      

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$Tenant/user/$UserName"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' -BearerToken $BearerToken
}

Export-ModuleMember -Function New-DevSuiteUser