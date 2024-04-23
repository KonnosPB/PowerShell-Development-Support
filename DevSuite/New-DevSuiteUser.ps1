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

    $devSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $DevSuite
    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant/$Tenant/user/$UserName"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'POST' 
}

Export-ModuleMember -Function New-DevSuiteUser