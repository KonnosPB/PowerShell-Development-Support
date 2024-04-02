function Get-AzureDevOpsPullRequestWorkItems {
    Param (        
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]] $AzureDevOpsPullRequests,
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsToken
    )
    $result = @()
    foreach ($pullRequest in $AzureDevOpsPullRequest) {        
        $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/repositories/$($pullRequest.repository)/pullRequests/$($pullRequest.pullRequestId)/workitems"         
        $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken        
        $jWorkItems = $response.Content | ConvertFrom-Json
        foreach ($workItem in $jWorkItems.value) {
            $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/wit/workitems/$($workItem.Id)" -Parameter '$expand=relations&api-version=6.0'            
            $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken                 
            $workItem = $response.Content | ConvertFrom-Json  
            $workItem | Add-Member -MemberType NoteProperty -Name pullRequest -Value $pullRequest        
            $result += $workItem 
        }
    }
    return $result
}
Export-ModuleMember -Function Get-AzureDevOpsPullRequestWorkItems