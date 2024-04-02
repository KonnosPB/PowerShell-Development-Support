<#
.SYNOPSIS
A function to get completed Jira tickets from a specific version of a project.

.DESCRIPTION
The Get-JiraCompletedTicketsFromSolutionVersion function makes a GET request to the Jira API to retrieve completed tickets from a specified version of a project. It checks the status of the response and writes an error if the status code is not 200. It then converts the response content from JSON and adds each issue to the result array, which is returned at the end of the function.

.PARAMETER JiraProject
Mandatory parameter. The name of the Jira project from which to retrieve completed tickets.

.PARAMETER Version
Mandatory parameter. The specific version of the project from which to retrieve completed tickets.

.PARAMETER JiraApiToken
Mandatory parameter. The API token used to authenticate the GET request to the Jira API.

.EXAMPLE
Get-JiraCompletedTicketsFromSolutionVersion -JiraProject "ProjectA" -Version "1.0" -JiraApiToken "xyz123"

This example retrieves all completed tickets from version 1.0 of ProjectA using the provided Jira API token.
#>
function Get-JiraCompletedTicketsFromSolutionVersion {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $JiraProject,
        [Parameter(Mandatory = $true)]
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [string] $JiraApiToken
    )        
    $uri = Get-JiraUri -Route "/rest/api/latest/search" -Parameter "jql=project=$JiraProject AND fixVersion=$Version AND status in (Done, ""Ready Rollout Prod"", ""Waiting for Release"") ORDER BY key ASC, created DESC"        
    $response = Invoke-JiraWebRequest -Uri $uri -Method "GET"  -JiraApiToken $JiraApiToken    
    if ($response.StatusCode -ne 200) {
        Write-Error "Get-JiraCompletedTicketsFromSolutionVersion failed with status code: $($response.StatusCode) $($response.StatusDescription)" 
        exit
    }   
    $result = @()
    $jJiraIssues = $response.Content | ConvertFrom-Json 
    foreach ($jJiraIssue in $jJiraIssues.issues) {
        $result += $jJiraIssue    
    }    
    return $result
}

Export-ModuleMember -Function Get-JiraCompletedTicketsFromSolutionVersion 