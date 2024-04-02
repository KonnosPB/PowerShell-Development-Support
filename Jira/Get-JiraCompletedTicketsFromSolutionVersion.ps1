function Get-CompletedJiraTicketsFromSolutionVersion {     
    $jiraUrl = "$script:jiraBaseUrl/rest/api/latest/search?jql=project=$script:jiraProject AND fixVersion=$script:jiraSolutionVersion AND status in (Done, ""Ready Rollout Prod"", ""Waiting for Release"") ORDER BY key ASC, created DESC"
    $jiraIssue = Invoke-WebRequest -Uri $jiraUrl -Headers $script:jiraAuthHeader -Method Get
    if ($jiraIssue.StatusCode -ne 200) {
        Write-Error "Get-CompletedJiraTicketsFromSolutionVersion for jira ticket item $jiraIssueKey failed with status code: $($jiraIssue.StatusCode) $($jiraIssue.StatusDescription)" 
        exit
    }   
    $jJiraIssues = $jiraIssue.Content | ConvertFrom-Json 
    foreach ($jJiraIssue in $jJiraIssues.issues) {
        $script:jiraTickets += $jJiraIssue    
    }    
}
Export-ModuleMember -Function Get-CompletedJiraTicketsFromSolutionVersion 