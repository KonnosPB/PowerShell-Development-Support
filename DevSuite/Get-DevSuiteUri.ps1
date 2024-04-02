<#
.SYNOPSIS
This function generates a URI for the specified DevSuite route and parameter.

.DESCRIPTION
The Get-DevSuiteUri function uses the Route and Parameter parameters to generate a URI for the specified DevSuite route. The Global:DevSuiteUrl and Global:DevSuiteHost variables are used as part of the base URI.

.PARAMETER Route
This is a mandatory parameter that specifies the route for the DevSuite URI.

.PARAMETER Parameter
This is an optional parameter that specifies the parameter for the DevSuite URI. It defaults to null if not provided.

.EXAMPLE
Get-DevSuiteUri -Route "vm/DevSuite1/tenant/Tenant1/appInfo" -Parameter "clearCache=false"

This example generates a URI for the route "vm/DevSuite1/tenant/Tenant1/appInfo" with the parameter "clearCache=false".
#>
function Get-DevSuiteUri {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Route,
        [Parameter(Mandatory = $false)]
        [string] $Parameter = $null        
    )
    $uri = $Global:Config.DevSuiteUrl    
    if ($Route) {
        $uri += $Route
    }   
    $uri += "?code=$($Global:Config.DevSuiteHost)"     
    if ($Parameter) {
        $uri += "&$Parameter"
    }
    return($uri)
}
Export-ModuleMember -Function Get-DevSuiteUri