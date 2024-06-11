
function Invoke-DevSuiteMigrate {
    Param (
        [Parameter(Mandatory = $false)]
        [string] $SourceResourceGroup = $null,
        [Parameter(Mandatory = $true)]
        [string] $SourceDevSuite,
        [Parameter(Mandatory = $true)]
        [string] $SourceTenant,
        [Parameter(Mandatory = $false)]
        [string] $DestinationResourceGroup = $null,
        [Parameter(Mandatory = $true)]
        [string] $DestinationDevSuite,
        [Parameter(Mandatory = $false)]
        [string] $DestinationTenant = $null,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 120
    )      

    $sourceTenantObj = Get-DevSuiteTenant -DevSuite $SourceDevSuite -Tenant $SourceTenant
    if (-not $sourceTenantObj) {
        throw "Source tenant '$SourceTenant' doesn't exist in '$SourceDevSuite'"
    }

    if (-not $SourceResourceGroup) {
        $sourceDevSuiteObj = Get-DevSuiteEnvironment -DevSuite $SourceDevSuite
        $SourceResourceGroup = $sourceDevSuiteObj.resourceGroup
    }

    if (-not $DestinationResourceGroup) {
        $DestinationResourceGroup = $SourceResourceGroup
    }

    if (-not $DestinationTenant) {
        $DestinationTenant = $SourceTenant
    }
    
    Write-Host "Migrating tenant '$SourceTenant' from '$SourceDevSuite' into '$DestinationTenant' in devsuite '$DestinationDevSuite'" -ForegroundColor Green

    $jsonObject = @{
        "SourceResourceGroup"      = $SourceResourceGroup
        "SourceVmName"             = $SourceDevSuite
        "SourceTenantName"         = $SourceTenant
        "DestinationResourceGroup" = $DestinationResourceGroup
        "DestinationVmName"        = $DestinationDevSuite
        "DestinationTenantName"    = $DestinationTenant
    } | ConvertTo-Json

    $uri = Get-DevSuiteUri -Route "migrateTenant/async"    
    #Start-Job -ScriptBlock { 
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' -Body $jsonObject
    #} | Out-Null

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {   
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        $percentComplete = ($minutes / $TimeoutMinutes * 100)
        Write-Progress -Activity "Waiting for $minutes/$TimeoutMinutes minutes" -Status "Timeout $($percentComplete.ToString("F2"))%" -PercentComplete $percentComplete
        $tenant = Get-DevSuiteTenant -DevSuite $DestinationDevSuite -Tenant $DestinationTenant 
        if ($tenant -and @('Mounted', 'Operational') -contains $tenant.Status) {  
            Write-Host "Tenant '$DestinationDevSuite'copied and mounted successfully into '$DestinationTenant' from devsuite '$SourceDevSuite' tenant '$SourceTenant'" -ForegroundColor Green                
            return $tenant          
        }    
        Start-Sleep -Seconds 30
    }    
    throw "Timeout migrating tenant '$SourceTenant' from '$SourceDevSuite' into '$DestinationDevSuite'!"
}

Export-ModuleMember -Function Invoke-DevSuiteMigrate