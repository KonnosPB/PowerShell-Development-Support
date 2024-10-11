<#
.SYNOPSIS
This function waits until all DevSuite tenants are ready.

.DESCRIPTION
The Wait-DevSuiteTenantsReady function waits for a specified amount of time until all tenants in a given DevSuite are in a 'Mounted' or 'Operational' state. If this condition is not met within the given timeout, the function throws a timeout error.

.PARAMETER DevSuite
This parameter takes in the name of the DevSuite for which the tenants' readiness is checked. This parameter is mandatory.

.PARAMETER TimeoutMinutes
This parameter specifies the amount of time to wait for the tenants to become ready. If not provided, the default wait time is 100 minutes. This parameter is not mandatory.

.EXAMPLE
Wait-DevSuiteTenantsReady -DevSuite "TestSuite" -TimeoutMinutes 120
This example checks the readiness of the tenants in the 'TestSuite' DevSuite. It waits for a maximum of 120 minutes before throwing a timeout error.
#>
function Wait-DevSuiteTenantsReady {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 100
    )    
    # Startzeit festlegen
    $startTime = Get-Date

    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes([int] $TimeoutMinutes)) {   
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        $percentComplete = ($minutes / $TimeoutMinutes * 100)
        Write-Progress -Activity "Waiting for $minutes/$TimeoutMinutes minutes" -Status "Timeout $($percentComplete.ToString("F2"))%" -PercentComplete $percentComplete
        try {
            $tenants = Get-DevSuiteTenants -DevSuite $DevSuite 
            if ($tenants) {
                $unreadyTenants = $tenants |  Where-Object { (-not (@('Mounted', 'Operational') -contains $_.status)) }        
                Write-Host "Unready tenants $unreadyTenants"
                if ((-not $unreadyTenants) -and ($tenants.Count -gt 0)) {
                    return $true;
                }   
            }
        }      
        catch {
            Write-Debug $_
        }
        Start-Sleep -Seconds 180
    }    

    throw "Wait-DevSuiteTenantsReady timeout"
}

Export-ModuleMember -Function Wait-DevSuiteTenantsReady