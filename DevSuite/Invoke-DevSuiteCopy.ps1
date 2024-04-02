<#
.SYNOPSIS
This function copies a tenant from a source tenant to a destination tenant within a specified DevSuite.

.DESCRIPTION
The Invoke-DevSuiteCopy function copies a tenant from a source tenant to a destination tenant within a specified DevSuite. The function retrieves the source tenant using the Get-DevSuiteTenant function and throws an error if the tenant does not exist. The function then initiates a POST web request to the DevSuite Uri to copy the tenant. The function waits for up to a specified number of minutes for the copy process to complete.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the name of the DevSuite.

.PARAMETER SourceTenant
The SourceTenant parameter is a mandatory string parameter that specifies the name of the source tenant.

.PARAMETER DestinationTenant
The DestinationTenant parameter is a mandatory string parameter that specifies the name of the destination tenant.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.PARAMETER TimeoutMinutes
The TimeoutMinutes parameter is an optional integer parameter that specifies the timeout for the copy process in minutes. The default value is 15 minutes.

.EXAMPLE
Invoke-DevSuiteCopy -DevSuite "DevSuite1" -SourceTenant "Tenant1" -DestinationTenant "Tenant2" -BearerToken "abc123"

This example copies the tenant named "Tenant1" to the tenant named "Tenant2" within the DevSuite named "DevSuite1", using the bearer token "abc123". The function will wait for up to 15 minutes for the copy process to complete.
#>
function Invoke-DevSuiteCopy {
    Param (      
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $SourceTenant,
        [Parameter(Mandatory = $true)]
        [string] $DestinationTenant,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 15
    )   

    $sourceTenantObj = Get-DevSuiteTenant -DevSuite $DevSuite -Tenant $SourceTenant -BearerToken $BearerToken
    if (-not $sourceTenantObj) {
        throw "Source tenant $SourceTenant doesn't exist in $DevSuite"
    } 

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$SourceTenant/copyTo/$DestinationTenant"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' -BearerToken $BearerToken

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {  
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Host "Waiting $minutes minutes: " -NoNewline 
        $tenant = Get-DevSuiteTenant -DevSuite $DestinationDevSuite -Tenant $DestinationTenant -BearerToken $BearerToken
        if ($tenant -and @('Mounted', 'Operational') -contains $tenant.Status) {          
            return $true            
        }    
        Start-Sleep -Seconds 5
    }    
    return $false
}

Export-ModuleMember -Function Invoke-DevSuiteCopy