function Add-JiraTicketsToPullRequests{
    Param (        
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]] $AzureDevOpsPullRequests,
        [Parameter(Mandatory=$true)]
        [string] $JiraApiToken
    )

    foreach ($pullRequest in $AzureDevOpsPullRequests) {
        #$jiraIssueId = $pullRequest.fields."Custom.JiraIssueId"
        $jiraIssueKey = $pullRequest.fields."Custom.JiraIssueKey"
        $jiraUrl = Get-JiraUri -Route "rest/api/latest/issue/$jiraIssueKey"        
        $jiraIssue = Invoke-WebRequest -Uri $jiraUrl -Headers $script:jiraAuthHeader -Method Get
        if ($jiraIssue.StatusCode -ne 200) {
            Write-Error "Add-JiraTicketsToPullRequests for jira ticket item $jiraIssueKey failed with status code: $($jiraIssue.StatusCode) $($jiraIssue.StatusDescription)" 
            exit
        }   
        $jJiraIssue = $jiraIssue.Content | ConvertFrom-Json 
        $pullRequest | Add-Member -MemberType NoteProperty -Name jiraIssue -Value $jJiraIssue  
    }
}
Export-ModuleMember -Function Add-JiraTicketsToPullRequests