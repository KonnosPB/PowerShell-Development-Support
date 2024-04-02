function Get-AzureDevOpsUri{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory=$true)]
        [string] $Route,        
        [Parameter(Mandatory=$false)]
        [string] $Parameter = $null        
    )
    $uri = "https://dev.azure.com/$Global:AzureDevOpsOrganisation/$AzureDevOpsProject/"
    if ($Route){
        $uri += $Route
    }       
    if ($Parameter){
        $uri += "?$Parameter"
    }
    return($uri)
}
Export-ModuleMember -Function Get-AzureDevOpsUri