<#
.SYNOPSIS
This function waits for all tenants in a DevSuite to be ready.

.DESCRIPTION
The Wait-DevSuiteTenantsReady function waits for all tenants in a specified DevSuite to be ready. It retrieves the list of tenants in the DevSuite using the Get-DevSuiteTenants function and checks their status. If any tenant is not in the 'Mounted' or 'Operational' status, the function waits and checks again. The function continues to check the status of the tenants until all tenants are ready or a specified timeout is reached.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the name of the DevSuite.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.PARAMETER TimeoutMinutes
The TimeoutMinutes parameter is an optional integer parameter that specifies the timeout for the wait process in minutes. The default value is 100 minutes.

.EXAMPLE
Wait-DevSuiteTenantsReady -DevSuite "DevSuite1" -BearerToken "abc123"

This example waits for all tenants in the DevSuite named "DevSuite1" to be ready, using the bearer token "abc123". The function will wait for up to 100 minutes.
#>
function Wait-DevSuiteTenantsReady {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 100
    )    
    # Startzeit festlegen
    $startTime = Get-Date

    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes([int] $TimeoutMinutes)) {   
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Host "Waiting $minutes minutes: " -NoNewline
        $tenants = Get-DevSuiteTenants -DevSuite $DevSuite -BearerToken $BearerToken
        $unreadyTenants = $tenants |  Where-Object { (-not (@('Mounted', 'Operational') -contains $_.status)) }        
        if ((-not $unreadyTenants) -and ($tenants.Count -gt 0)) {
            return;
        }         
        Start-Sleep -Seconds 5
    }    

    throw "Wait-DevSuiteTenantsReady timeout"
}

Export-ModuleMember -Function Wait-DevSuiteTenantsReady