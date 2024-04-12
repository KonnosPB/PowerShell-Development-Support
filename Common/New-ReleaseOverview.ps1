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

    $jProjectName = $Global:Config.JiraHealthcareProject
    $dProjectName = $Global:Config.AzureDevOpsHealthcareProject
    if ($Project -eq "Medtec") {
        $dProjectName = $Global:Config.AzureDevOpsMedtecProject
        $jProjectName = $Global:Config.JiraMedtecProject
    }
    
    $repositories = Get-AzureDevOpsRepositories -AzureDevOpsProject $dProjectName `
        -AzureDevOpsToken $AzureDevOpsToken

    $pullRequests = Get-AzureDevOpsMasterBranchPullRequests -AzureDevOpsProject $dProjectName `
        -AzureDevOpsRepositories $repositories `
        -AzureDevOpsToken $AzureDevOpsToken
    
    $workItems = Get-AzureDevOpsPullRequestWorkItems -AzureDevOpsProject $dProjectName `
        -AzureDevOpsPullRequests $pullRequests  `
        -AzureDevOpsToken $AzureDevOpsToken 

    Add-JiraTicketsToPullRequests -AzureDevOpsPullRequestWorkItems $workItems `
        -JiraApiToken $JiraApiToken

    $jiraTickets = Get-JiraTicketsFromSolutionVersion -JiraProject $jProjectName `
        -Version $JiraSolutionVersion `
        -JiraApiToken $JiraApiToken

    Test-AzureDevOpsWorkItemMergedIntoDevelop  -AzureDevOpsProject $dProjectName `
        -AzureDevOpsPullRequestWorkItems $workItems `
        -AzureDevOpsToken $AzureDevOpsToken 

    New-ReleaseExcelWorksheet -AzureDevOpsProject $dProjectName `
        -JiraSolutionVersion $JiraSolutionVersion `
        -AzureDevOpsPullRequestWorkItems $workItems `
        -JiraTickets $jiraTickets `

}
Export-ModuleMember -Function New-ReleaseOverview
