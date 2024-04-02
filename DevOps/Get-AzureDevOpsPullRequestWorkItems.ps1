function Get-AzureDevOpsPullRequestWorkItems {
    Param (        
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]] $AzureDevOpsPullRequests,
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsToken
    )
    $results = @()
    foreach ($pullRequest in $AzureDevOpsPullRequest) {        
        $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/repositories/$($pullRequest.repository)/pullRequests/$($pullRequest.pullRequestId)/workitems"         
        $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken        
        $jWorkItems = $response.Content | ConvertFrom-Json
        foreach ($workItem in $jWorkItems.value) {
            $uri = "https://dev.azure.com/$script:devopsOrganisation/$script:devopsProject/_apis/wit/workitems/$($workItem.Id)?`$expand=relations&api-version=6.0"    
            $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken                 
            $jWorkItem = $response.Content | ConvertFrom-Json  
            $jWorkItem | Add-Member -MemberType NoteProperty -Name pullRequest -Value $pullRequest        
            $results += $jWorkItem 
        }
    }
    return $results
}
Export-ModuleMember -Function Get-AzureDevOpsPullRequestWorkItems