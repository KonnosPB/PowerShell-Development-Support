function New-ReleaseOverview {  
    Param (        
        [Parameter(Mandatory=$true)]
        [ValidateSet("healthcare", "medtec")]
        [string] $Project,       
        [Parameter(Mandatory=$true)]        
        [string] $SolutionVersion,       
        [Parameter(Mandatory=$false)]
        [string] $JiraApiToken = $null,
        [Parameter(Mandatory=$false)]
        [string] $AzureDevOpsToken = $null,
        [Parameter(Mandatory=$false)]
        [string] $Output
    )

    if (-not $JiraApiToken){
        $JiraApiToken = $Global:JiraApiToken
    }

    if (-not $AzureDevOpsToken){
        $AzureDevOpsToken = $Global:AzureDevopsToken
    }

    if ($Project -eq "medtec"){
        $azureDevOpsProjectName = $Global:AzureDevopMEDTECProject
    }else{
        $azureDevOpsProjectName = $Global:AzureDevopHealthcareProject
    }  
    
    $azureDevOpsRepositories = Get-AzureDevOpsRepositories -AzureDevOpsProject $azureDevOpsProjectName -AzureDevOpsToken $AzureDevOpsToken
    $masterBranchPullRequests = Get-AzureDevOpsMasterBranchPullRequests -AzureDevOpsProject $azureDevOpsProjectName -AzureDevOpsRepositories $azureDevOpsRepositories -AzureDevOpsToken $AzureDevOpsToken 
    $masterBranchPullRequestsWorkItems = Get-AzureDevOpsPullRequestWorkItems -AzureDevOpsProject $azureDevOpsProjectName AzureDevOpsPullRequests $masterBranchPullRequests -AzureDevOpsToken $AzureDevOpsToken 
    $jiraTicketsFromWorkItems = Add-JiraTicketsFromPullRequests -AzureDevOpsPullRequests $masterBranchPullRequests -JiraApiToken $JiraApiToken
    
}
Export-ModuleMember -Function New-ReleaseOverview