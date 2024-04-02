function Get-JiraUri{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Route,
        [Parameter(Mandatory=$false)]
        [string] $Parameter = $null        
    )
    $uri = $Global:Config.JiraBaseUrl     
    if ($Route){
        $uri += $Route
    }       
    if ($Parameter){
        $uri += "?$Parameter"
    }
    return($uri)
}
Export-ModuleMember -Function Get-JiraUri