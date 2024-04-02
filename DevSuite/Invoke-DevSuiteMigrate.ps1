<#
.SYNOPSIS
This function migrates a tenant from a source DevSuite to a destination DevSuite.

.DESCRIPTION
The Invoke-DevSuiteMigrate function migrates a tenant from a source DevSuite to a destination DevSuite within a specified resource group. The function retrieves the source tenant using the Get-DevSuiteTenant function and throws an error if the tenant does not exist. The function then initiates a POST web request to the DevSuite Uri to migrate the tenant. The function waits for up to a specified number of minutes for the migration process to complete.

.PARAMETER SourceResourceGroup
The SourceResourceGroup parameter is a mandatory string parameter that specifies the name of the source resource group.

.PARAMETER SourceDevSuite
The SourceDevSuite parameter is a mandatory string parameter that specifies the name of the source DevSuite.

.PARAMETER SourceTenant
The SourceTenant parameter is a mandatory string parameter that specifies the name of the source tenant.

.PARAMETER DestinationResourceGroup
The DestinationResourceGroup parameter is a mandatory string parameter that specifies the name of the destination resource group.

.PARAMETER DestinationDevSuite
The DestinationDevSuite parameter is a mandatory string parameter that specifies the name of the destination DevSuite.

.PARAMETER DestinationTenant
The DestinationTenant parameter is a mandatory string parameter that specifies the name of the destination tenant.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.PARAMETER TimeoutMinutes
The TimeoutMinutes parameter is an optional integer parameter that specifies the timeout for the migration process in minutes. The default value is 45 minutes.

.EXAMPLE
Invoke-DevSuiteMigrate -SourceResourceGroup "RG1" -SourceDevSuite "DevSuite1" -SourceTenant "Tenant1" -DestinationResourceGroup "RG2" -DestinationDevSuite "DevSuite2" -DestinationTenant "Tenant2" -BearerToken "abc123"

This example migrates the tenant named "Tenant1" from the DevSuite named "DevSuite1" in the resource group named "RG1" to the tenant named "Tenant2" within the DevSuite named "DevSuite2" in the resource group named "RG2", using the bearer token "abc123". The function will wait for up to 45 minutes for the migration process to complete.
#>
function Invoke-DevSuiteMigrate {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $SourceResourceGroup,
        [Parameter(Mandatory = $true)]
        [string] $SourceDevSuite,
        [Parameter(Mandatory = $true)]
        [string] $SourceTenant,
        [Parameter(Mandatory = $true)]
        [string] $DestinationResourceGroup,
        [Parameter(Mandatory = $true)]
        [string] $DestinationDevSuite,
        [Parameter(Mandatory = $true)]
        [string] $DestinationTenant,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 45
    )   

    $sourceTenantObj = Get-DevSuiteTenant -DevSuite $SourceDevSuite -Tenant $SourceTenant -BearerToken $BearerToken
    if (-not $sourceTenantObj) {
        throw "Source tenant $SourceTenant doesn't exist in $SourceDevSuite"
    }
    
    $jsonObject = @{
        "SourceResourceGroup"      = $SourceResourceGroup
        "SourceVmName"             = $SourceDevSuite
        "SourceTenantName"         = $SourceTenant
        "DestinationResourceGroup" = $DestinationResourceGroup
        "DestinationVmName"        = $DestinationDevSuite
        "DestinationTenantName"    = $DestinationTenant
    } | ConvertTo-Json

    $uri = Get-DevSuiteUri -Route "migrateTenant/async"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' -BearerToken $BearerToken -Body $jsonObject 

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

Export-ModuleMember -Function Invoke-DevSuiteMigrate