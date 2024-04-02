<#
.SYNOPSIS
A function to get work items related to pull requests in a given Azure DevOps project.

.DESCRIPTION
The Get-AzureDevOpsPullRequestWorkItems function is designed to connect to a given Azure DevOps project using provided API token and fetch work items related to each pull request. 

.PARAMETER AzureDevOpsProject
Specifies the Azure DevOps project to fetch the pull requests and related work items from. This parameter is mandatory.

.PARAMETER AzureDevOpsPullRequests
This parameter accepts an array of pull request objects (PSCustomObject[]) from the Azure DevOps project. Each pull request object should contain details like repository name and pull request ID. This parameter is mandatory.

.PARAMETER AzureDevOpsToken
This is the API token for connecting to the Azure DevOps project. This parameter is mandatory.

.EXAMPLE
$pullRequests = @(
    @{
        repository = 'Repo1'
        pullRequestId = 123
    },
    @{
        repository = 'Repo2'
        pullRequestId = 456
    }
)

Get-AzureDevOpsPullRequestWorkItems -AzureDevOpsProject 'MyProject' -AzureDevOpsPullRequests $pullRequests -AzureDevOpsToken 'MyToken'

In this example, the function will fetch work items related to pull requests 123 and 456 from the repositories 'Repo1' and 'Repo2' in the Azure DevOps project 'MyProject'.
#>
function Get-AzureDevOpsPullRequestWorkItems {
    Param (        
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory = $false)]
        [PSCustomObject[]] $AzureDevOpsPullRequests,
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsToken
    )
    $result = @()
    if (-not $AzureDevOpsPullRequests){
        return $result
    }
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