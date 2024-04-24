function Start-DevSuite {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $false)]
        [string] $TimeoutMinutes = 30  
    )
    Write-Debug "Starting devsuite '$DevSuite'" 

    $devSuiteObj = Get-DevSuiteEnvironment -DevSuite $DevSuite
    if (-not $devSuiteObj) {
        throw "Cannot start devsuite '$devSuiteObj', because the vm doesn't exist."
    }

    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/start"
    Invoke-DevSuiteWebRequest -Uri $uri -Method GET

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {    
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)        
        $percentComplete = ($minutes / $TimeoutMinutes * 100)
        Write-Progress -Activity "Waiting for $minutes/$TimeoutMinutes minutes" -Status "Timeout $($percentComplete.ToString("F2"))%" -PercentComplete $percentComplete
        if (Test-DevSuiteEnvironment -DevSuite $DevSuite ) {   
            Write-Host "Devsuite '$DevSuite' created. Waiting now for tenants" -ForegroundColor Green                     
            Wait-DevSuiteTenantsReady -DevSuite $devSuiteObj.name -TimeoutMinutes $TimeoutMinutes
            Write-Host "Tenants of devsuite '$DevSuite' also ready" -ForegroundColor Green         
            return $devSuiteObj            
        }    
        Start-Sleep -Seconds 15
    }    
    
    throw "Timeout starting devsuite '$DevSuite'!"
}

Export-ModuleMember -Function Start-DevSuite
