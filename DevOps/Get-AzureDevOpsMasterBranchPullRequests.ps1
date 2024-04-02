function Get-AzureDevOpsMasterBranchPullRequests {
    Param (        
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory=$true)]
        [string[]] $AzureDevOpsRepositories,
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsToken
    )
    $result = @()
    foreach ($AzureDevOpsRepository in $AzureDevOpsRepositories) {
        # Get the list of pull requests        
        try {
            $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/repositories/$AzureDevOpsRepository/pullrequests" -Parameter "searchCriteria.targetRefName=refs/heads/master&searchCriteria.status=active"
            $pullRequests = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken              
            $jContent = $pullRequests.Content | ConvertFrom-Json
            foreach ($pr in $jContent.value) {
                $pr.repository = $repository
                $result += $pr                
            }
        }
        catch {            
        }        
    }
    return $result
}
Export-ModuleMember -Function Get-AzureDevOpsMasterBranchPullRequests
