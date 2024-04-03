<#
.SYNOPSIS
A function to copy a tenant from one DevSuite to another.

.DESCRIPTION
The Invoke-DevSuiteCopy function is used to copy a tenant from a source DevSuite to a destination DevSuite. The function checks if the source tenant exists in the source DevSuite, then sends a POST request to the DevSuite API to initiate the tenant copy. The function then waits for the copy to be complete or until a specified timeout period has been reached.

.PARAMETER DevSuite
The name of the DevSuite environment where the source tenant resides. This parameter is mandatory.

.PARAMETER SourceTenant
The name of the tenant in the source DevSuite that is to be copied. This parameter is mandatory.

.PARAMETER DestinationTenant
The name of the tenant in the destination DevSuite where the source tenant will be copied to. This parameter is mandatory.

.PARAMETER TimeoutMinutes
The maximum time, in minutes, the function will wait for the copy process to complete. If this parameter is not specified, the default value is 15 minutes. This parameter is optional.

.EXAMPLE
Invoke-DevSuiteCopy -DevSuite "DevSuite1" -SourceTenant "Tenant1" -DestinationTenant "Tenant2" -TimeoutMinutes 30

This example copies Tenant1 from DevSuite1 to Tenant2 in the same DevSuite and waits for a maximum of 30 minutes for the copy process to complete.
#>
function Invoke-DevSuiteCopy {
    Param (      
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $SourceTenant,
        [Parameter(Mandatory = $true)]
        [string] $DestinationTenant,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 15
    )   

    $sourceTenantObj = Get-DevSuiteTenant -DevSuite $DevSuite -Tenant $SourceTenant
    if (-not $sourceTenantObj) {
        throw "Source tenant $SourceTenant doesn't exist in $DevSuite"
    } 

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$SourceTenant/copyTo/$DestinationTenant"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST'

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {  
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Host "Waiting $minutes minutes: " -NoNewline 
        $tenant = Get-DevSuiteTenant -DevSuite $DevSuite -Tenant $DestinationTenant
        if ($tenant -and @('Mounted', 'Operational') -contains $tenant.Status) {          
            return $true            
        }    
        Start-Sleep -Seconds 5
    }    
    return $false
}

Export-ModuleMember -Function Invoke-DevSuiteCopy