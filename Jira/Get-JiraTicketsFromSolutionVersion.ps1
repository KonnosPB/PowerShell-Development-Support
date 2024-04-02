<#
.SYNOPSIS
This function retrieves Jira tickets based on a specific project and version.

.DESCRIPTION
The Get-JiraTicketsFromSolutionVersion function queries the Jira API to fetch all the Jira issues (tickets) for a given project and version. It constructs a URI with the provided project and version parameters, and then makes a GET request to the Jira API. If the request is successful, it parses the response content and returns an array of Jira issues.

.PARAMETER JiraProject
This parameter takes in the name of the Jira project. This is a mandatory parameter.

.PARAMETER Version
This parameter takes in the version of the solution. This is a mandatory parameter.

.PARAMETER JiraApiToken
This parameter is the API token for accessing the Jira API. This is a mandatory parameter.

.EXAMPLE
Get-JiraTicketsFromSolutionVersion -JiraProject "PROJ" -Version "1.0.0" -JiraApiToken "YourApiToken"

This example retrieves all the Jira tickets for the "PROJ" project and "1.0.0" version using the provided Jira API token.
#>
function Get-JiraTicketsFromSolutionVersion {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $JiraProject,
        [Parameter(Mandatory = $true)]
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [string] $JiraApiToken
    )        
    $uri = Get-JiraUri -Route "/rest/api/latest/search" -Parameter "jql=project=$JiraProject AND fixVersion=$Version ORDER BY key ASC, created DESC"        
    $response = Invoke-JiraWebRequest -Uri $uri -Method "GET"  -JiraApiToken $JiraApiToken    
    if ($response.StatusCode -ne 200) {
        Write-Error "Get-JiraTicketsFromSolutionVersion failed with status code: $($response.StatusCode) $($response.StatusDescription)" 
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