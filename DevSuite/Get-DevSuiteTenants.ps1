<#
.SYNOPSIS
This function retrieves all tenants from a specific DevSuite environment.

.DESCRIPTION
The Get-DevSuiteTenants function is used to obtain all the tenants from a specified DevSuite environment. It first retrieves the DevSuite object using the Get-DevSuiteEnvironment function. If the object does not exist, it returns null. Otherwise, it constructs a URI for the request using the Get-DevSuiteUri function and sends a GET request to the DevSuite API using the Invoke-DevSuiteWebRequest function. The function then converts the response content from JSON format to a PowerShell object and returns it.

.PARAMETER DevSuite
A mandatory parameter that specifies the name or description of the DevSuite environment from which the tenants are to be retrieved.

.EXAMPLE
```powershell
PS C:\> Get-DevSuiteTenants -DevSuite "DevSuite1"
```
This command retrieves all tenants from the DevSuite environment named "DevSuite1".

.EXAMPLE
```powershell
PS C:\> $tenants = Get-DevSuiteTenants -DevSuite "DevSuite1"
PS C:\> $tenants.Count
```
This command retrieves all tenants from the DevSuite environment named "DevSuite1" and stores them in the $tenants variable. The next command outputs the number of tenants.
#>
function Get-DevSuiteTenants {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite
    )

    Write-Debug "Getting all tenant infos from devsuite '$DevSuite'" -ForegroundColor Gray
    $devSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $DevSuite
    if (-not $devSuiteObj) {
        return $null
    }

    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant" -Parameter "clearCache=true"
    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method 'GET'
    $tenants = $response.Content | ConvertFrom-Json
    return $tenants
}

Export-ModuleMember -Function Get-DevSuiteTenants