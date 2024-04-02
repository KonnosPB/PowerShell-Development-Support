function Get-AzureDevOpsRepositories{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsProject, 
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsToken
    )
    $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/repositories"
    $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method "Get" -AzureDevOpsToken $AzureDevOpsToken
    $rawResult = $response.Content | ConvertFrom-Json
    $result = @()
    foreach($value in $rawResult.value){
        $result += $value.Name        
    }
    return $result
}