<#
.SYNOPSIS
This function retrieves Azure DevOps work items associated with given Jira tickets.

.DESCRIPTION
The Add-AzureDevOpsWorkItemsToJiraTickets function connects to Azure DevOps via API, makes a query for work items associated with each provided Jira ticket, and returns the associated Azure DevOps work item(s) if they exist. If a work item is also associated with an Azure DevOps pull request, that association is also returned.

.PARAMETER JiraTickets
An array of Jira tickets for which the associated Azure DevOps work items should be retrieved. 

.PARAMETER AzureDevOpsProject
The Azure DevOps project in which to search for associated work items.

.PARAMETER AzureDevOpsToken
The Azure DevOps API token to use for authentication.

.PARAMETER azureDevOpsPullRequestWorkItems
An array of Azure DevOps pull requests. This is used to find any associations between the Jira tickets, work items, and pull requests.

.EXAMPLE
```powershell
$JiraTickets = @("JIRA-123", "JIRA-124", "JIRA-125")
$AzureDevOpsProject = "MyProject"
$AzureDevOpsToken = "abc123"
$azureDevOpsPullRequestWorkItems = @({id="1", title="PR1"}, {id="2", title="PR2"})
Add-AzureDevOpsWorkItemsToJiraTickets -JiraTickets $JiraTickets -AzureDevOpsProject $AzureDevOpsProject -AzureDevOpsToken $AzureDevOpsToken -AzureDevOpsPullRequests $azureDevOpsPullRequestWorkItems
```
In this example, the function will retrieve any Azure DevOps work items associated with the Jira tickets JIRA-123, JIRA-124, and JIRA-125 from the Azure DevOps project "MyProject".
#>
function Add-AzureDevOpsWorkItemsToJiraTickets() {
    Param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]] $JiraTickets, 
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject, 
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsToken,
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]] $AzureDevOpsPullRequestWorkItems
    )
    foreach ($jiraTicket in $JiraTickets) {        
        $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/wit/wiql" -Parameter "api-version=6.0"
        $query = @{
            query = "SELECT [System.Id], [System.WorkItemType], [System.Title], [System.AssignedTo], [System.State] FROM workitems WHERE [System.TeamProject] = '$AzureDevOpsProject' AND [Custom.JiraIssueKey] = '$($jiraTicket.key)'"          
        } | ConvertTo-Json
        $devopsQueryResponse = Invoke-AzureDevOpsWebRequest -Uri $uri -Method Post -Body $query -AzureDevOpsToken $AzureDevOpsToken
        if ($devopsQueryResponse.StatusCode -eq 200) {
            $devopsQuery = $devopsQueryResponse.Content | ConvertFrom-Json
            $devopsWorkItem = $devopsQuery.workitems | Select-Object -Last 1
            $devopsPullRequestWorkItem = $azureDevOpsPullRequestWorkItems | Where-Object { $_.id -eq $devopsWorkItem.Id } | Select-Object -First 1
            if ($devopsPullRequestWorkItem) {
                $jiraTicket | Add-Member -MemberType NoteProperty -Name devopsWorkItem -Value $devopsPullRequestWorkItem         
                $devopsPullRequestWorkItem | Add-Member -MemberType NoteProperty -Name jiraTicket -Value $jiraTicket  
            }
            else {
                if (-not $devopsWorkItem -or -not $devopsWorkItem.Id) {
                    continue
                }                
                $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/wit/workitems/$($devopsWorkItem.Id)" -Parameter '$expand=relations&api-version=6.0'
                $workItemResponse = Invoke-AzureDevOpsWebRequest -Uri $uri -Method Get -AzureDevOpsToken $AzureDevOpsToken
                if ($workItemResponse.StatusCode -ne 200) {
                    Write-Error "Add-AzureDevOpsWorkItemsToJiraTickets for work item $($wi.Id) failed with status code: $($pullRequestWorkItem.StatusCode) $($pullRequestWorkItem.StatusDescription)" 
                    exit
                }   
                $workItem = $workItemResponse.Content | ConvertFrom-Json                  
                $workItem | Add-Member -MemberType NoteProperty -Name jiraTicket -Value $jiraTicket  
                $jiraTicket | Add-Member -MemberType NoteProperty -Name devopsWorkItem -Value $workItem          
            }                                    
        }           
    }
}
Export-ModuleMember -Function Add-AzureDevOpsWorkItemsToJiraTickets