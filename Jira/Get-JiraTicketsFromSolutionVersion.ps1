function Get-JiraTicketsFromSolutionVersion {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $JiraProject,
        [Parameter(Mandatory = $true)]
        [string] $Version,
        [Parameter(Mandatory = $false)]
        [Switch] $TestApp,
        [Parameter(Mandatory = $false)]
        [Switch] $Preview,
        [Parameter(Mandatory = $true)]
        [string] $JiraApiToken
    )        
    $uri = Get-JiraUri -Route "/rest/api/latest/search" -Parameter "jql=project=$JiraProject AND fixVersion=$Version ORDER BY key ASC, created DESC"    
    #$jiraUrl = "$script:jiraBaseUrl/rest/api/latest/search?jql=project=$JiraProject AND fixVersion=$Version ORDER BY key ASC, created DESC"
    $response = Invoke-JiraWebRequest -Uri $uri -Method "GET"  -JiraApiToken $JiraApiToken    
    if ($response.StatusCode -ne 200) {
        Write-Error "Get-JiraTicketsFromSolutionVersion for jira ticket item $jiraIssueKey failed with status code: $($response.StatusCode) $($response.StatusDescription)" 
        exit
    }   
    $result = @()
    $jJiraIssues = $response.Content | ConvertFrom-Json 
    foreach ($jJiraIssue in $jJiraIssues.issues) {
        $result += $jJiraIssue    
    }    
    return $result
}

Export-ModuleMember -Function Get-JiraTicketsFromSolutionVersion 