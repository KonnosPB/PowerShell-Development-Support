
function Test-DevSuiteStarted {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite
    )
   
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
        return $false
    }
    return $false
}

Export-ModuleMember -Function Test-DevSuiteStarted