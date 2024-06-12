function New-DevSuiteUser {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
        [string] $Tenant,
        [Parameter(Mandatory = $true)]
        [string] $UserName
    )  
    
    Write-Host "Adding user '$UserName' into devsuite '$DevSuite' tenant '$Tenant'" -ForegroundColor Green

    $devSuiteObj = Get-DevSuiteEnvironment -DevSuite $DevSuite
    $devSuiteName = $devSuiteObj.name
    $route = "vm/$devSuiteName/tenant/$Tenant/user/$UserName"
    $uri = Get-DevSuiteUri -Route $route
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST'  | Out-Null
}

Export-ModuleMember -Function New-DevSuiteUser