<#
.SYNOPSIS
This function adds Jira tickets to Azure DevOps pull requests.

.DESCRIPTION
The `Add-JiraTicketsToPullRequests` function is used to add Jira tickets to Azure DevOps pull requests. It uses the Jira API to retrieve the relevant Jira tickets based on the custom field 'JiraIssueKey' in the Azure DevOps pull request. The function then adds these Jira tickets to the pull request object.

.PARAMETER AzureDevOpsPullRequests
This parameter requires an array of PSCustomObject that represents Azure DevOps pull requests. Each object in the array must have a property named 'Custom.JiraIssueKey' that stores the Jira issue key associated with the pull request.

.PARAMETER JiraApiToken
This parameter requires a string that represents the Jira API token. This token is used to authenticate the requests to the Jira API.

.EXAMPLE
$pullRequests = @(
    @{ 'fields.'='Custom.JiraIssueKey'; 'Custom.JiraIssueKey'='KEY-1' },
    @{ 'fields.'='Custom.JiraIssueKey'; 'Custom.JiraIssueKey'='KEY-2' }
)
$token = 'your-jira-api-token'
Add-JiraTicketsToPullRequests -AzureDevOpsPullRequests $pullRequests -JiraApiToken $token

This example adds the Jira tickets with keys 'KEY-1' and 'KEY-2' to the respective Azure DevOps pull requests.
#>
function Add-JiraTicketsToPullRequests{
    Param (        
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]] $AzureDevOpsPullRequests,
        [Parameter(Mandatory=$true)]
        [string] $JiraApiToken
    )

    foreach ($azureDevOpsPullRequest in $AzureDevOpsPullRequests) {
        #$jiraIssueId = $azureDevOpsPullRequest.fields."Custom.JiraIssueId"
        $jiraIssueKey = $azureDevOpsPullRequest.fields."Custom.JiraIssueKey"
        $uri = Get-JiraUri -Route "rest/api/latest/issue/$jiraIssueKey"        
        $response = Invoke-JiraWebRequest -Uri $uri -Method "GET"  -JiraApiToken $JiraApiToken    
        if ($response.StatusCode -ne 200) {
            Write-Error "Add-JiraTicketsToPullRequests for jira ticket item $jiraIssueKey failed with status code: $($response.StatusCode) $($response.StatusDescription)" 
            exit
        }   
        $jJiraIssue = $response.Content | ConvertFrom-Json 
        $azureDevOpsPullRequest | Add-Member -MemberType NoteProperty -Name jiraIssue -Value $jJiraIssue  
    }
}
Export-ModuleMember -Function Add-JiraTicketsToPullRequests