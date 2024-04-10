<#
.SYNOPSIS
The Invoke-DevSuiteMigrate function migrates a tenant from one DevSuite to another.

.DESCRIPTION
This function retrieves the source tenant, constructs a JSON object with the necessary migration information, and sends a web request to initiate the migration. It will then wait until the migration is complete or the timeout has been reached.

.PARAMETER SourceResourceGroup
The name of the resource group of the source DevSuite.

.PARAMETER SourceDevSuite
The name of the source DevSuite.

.PARAMETER SourceTenant
The name of the tenant in the source DevSuite.

.PARAMETER DestinationResourceGroup
The name of the resource group of the destination DevSuite.

.PARAMETER DestinationDevSuite
The name of the destination DevSuite.

.PARAMETER DestinationTenant
The name of the tenant in the destination DevSuite.

.PARAMETER TimeoutMinutes
The time in minutes that the function should wait for the migration to complete before timing out. This is optional and defaults to 45 minutes.

.EXAMPLE
Invoke-DevSuiteMigrate -SourceResourceGroup "ResourceGroup1" -SourceDevSuite "DevSuite1" -SourceTenant "Tenant1" -DestinationResourceGroup "ResourceGroup2" -DestinationDevSuite "DevSuite2" -DestinationTenant "Tenant2"

This example migrates "Tenant1" from "DevSuite1" in "ResourceGroup1" to "DevSuite2" in "ResourceGroup2", naming the tenant "Tenant2" in the destination DevSuite. It will wait up to 45 minutes for the migration to complete.
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
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 45
    )   

    Write-Host "Migrating tenant '$SourceTenant' from '$SourceDevSuite' into '$DestinationTenant' in devsuite '$DestinationDevSuite'" -ForegroundColor Green

    $sourceTenantObj = Get-DevSuiteTenant -DevSuite $SourceDevSuite -Tenant $SourceTenant
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

    $uri = Get-DevSuiteUri -Route "migrateTenant"    
    #Start-Job -ScriptBlock { 
        Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' -Body $jsonObject
    #} | Out-Null

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {   
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Progress -Activity "Waiting for $minutes minutes" -Status "Running" -PercentComplete ($minutes / $TimeoutMinutes * 100)
        $tenant = Get-DevSuiteTenant -DevSuite $DestinationDevSuite -Tenant $DestinationTenant 
        if ($tenant -and @('Mounted', 'Operational') -contains $tenant.Status) {  
            Write-Host "Tenant '$DestinationDevSuite'copied and mounted successfully into '$DestinationTenant' from devsuite '$SourceDevSuite' tenant '$SourceTenant'" -ForegroundColor Green                
            return $true            
        }    
        Start-Sleep -Seconds 5
    }    
    return $false
}

Export-ModuleMember -Function Invoke-DevSuiteMigrate