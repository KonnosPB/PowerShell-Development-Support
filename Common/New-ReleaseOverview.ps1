function New-ReleaseOverview {  
    Param (        
        [Parameter(Mandatory = $true)]
        [ValidateSet("Healthcare", "Medtec")]
        [string] $Project,       
        [Parameter(Mandatory = $true)]        
        [string] $JiraSolutionVersion,       
        [Parameter(Mandatory = $false)]
        [string] $JiraApiToken = $null,
        [Parameter(Mandatory = $false)]
        [string] $AzureDevOpsToken = $null,
        [Parameter(Mandatory = $false)]
        [string] $Output = $null
    )

    if (-not $JiraApiToken) {
        $JiraApiToken = $Global:JiraApiToken
    }

    if (-not $AzureDevOpsToken) {
        $AzureDevOpsToken = $Global:AzureDevopsToken
    }

    $jiraProjectName = $Global:Config.JiraHealthcareProject
    $azureDevOpsProjectName = $Global:Config.AzureDevOpsHealthcareProject
    if ($Project -eq "Medtec") {
        $azureDevOpsProjectName = $Global:Config.AzureDevOpsMedtecProject
        $jiraProjectName = $Global:Config.JiraMedtecProject
    }
    
    $azureDevOpsRepositories = Get-AzureDevOpsRepositories -AzureDevOpsProject $azureDevOpsProjectName `
        -AzureDevOpsToken $AzureDevOpsToken

    $masterBranchPullRequests = Get-AzureDevOpsMasterBranchPullRequests -AzureDevOpsProject $azureDevOpsProjectName `
        -AzureDevOpsRepositories $azureDevOpsRepositories `
        -AzureDevOpsToken $AzureDevOpsToken 
    
    $masterBranchPullRequestsWorkItems = Get-AzureDevOpsPullRequestWorkItems -AzureDevOpsProject $azureDevOpsProjectName `
        -AzureDevOpsPullRequests $masterBranchPullRequests  `
        -AzureDevOpsToken $AzureDevOpsToken 

    Add-JiraTicketsToPullRequests -AzureDevOpsPullRequests $masterBranchPullRequests `
        -JiraApiToken $JiraApiToken

    $jiraTickets = Get-JiraTicketsFromSolutionVersion -JiraProject $jiraProjectName `
        -Version $JiraSolutionVersion `
        -JiraApiToken $JiraApiToken

    New-ReleaseExcelWorksheet -AzureDevOpsProject $azureDevOpsProjectName `
        -JiraSolutionVersion $JiraSolutionVersion `
        -AzureDevOpsPullRequestWorkItems $masterBranchPullRequestsWorkItems `
        -JiraTickets $jiraTickets `

}
Export-ModuleMember -Function New-ReleaseOverview
