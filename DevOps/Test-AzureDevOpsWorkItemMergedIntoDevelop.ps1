<#
.SYNOPSIS
This function checks if Azure DevOps work items linked with pull requests are merged into the 'develop' branch.

.DESCRIPTION
The function 'Test-AzureDevOpsWorkItemMergedIntoDevelop' iterates through each provided Azure DevOps pull request work item, and checks if they are merged into the 'develop' branch by sending an API request to Azure DevOps. It adds a new member 'MergedIntoDevelop' to the pull request work item object, which will be set to 'true' if the linked pull request is merged into 'develop', and 'false' otherwise.

.PARAMETER AzureDevOpsProject
The name of the Azure DevOps project. This parameter is mandatory.

.PARAMETER AzureDevOpsToken
The Azure DevOps personal access token. This parameter is mandatory.

.PARAMETER AzureDevOpsPullRequestWorkItems
An array of Azure DevOps pull request work items. These are custom PowerShell objects. This parameter is mandatory.

.EXAMPLE
$AzureDevOpsProject = "MyProject"
$AzureDevOpsToken = "MyToken"
$AzureDevOpsPullRequestWorkItems = @({id=1;relations=@({url="https://dev.azure.com/...";attributes=@{name="Pull Request"}})},{id=2;relations=@({url="https://dev.azure.com/...";attributes=@{name="Pull Request"}})})
Test-AzureDevOpsWorkItemMergedIntoDevelop -AzureDevOpsProject $AzureDevOpsProject -AzureDevOpsToken $AzureDevOpsToken -AzureDevOpsPullRequestWorkItems $AzureDevOpsPullRequestWorkItems

This example demonstrates how to call the 'Test-AzureDevOpsWorkItemMergedIntoDevelop' function with a project name, personal access token, and an array of pull request work items. The function will check if the pull requests linked with these work items are merged into the 'develop' branch.
#>
function Test-AzureDevOpsWorkItemMergedIntoDevelop {   
    Param (       
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject, 
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsToken,
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]] $JiraTickets, 
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]] $AzureDevOpsPullRequestWorkItems
    )

    foreach ($devopsPullRequestWorkItem in $AzureDevOpsPullRequestWorkItems) {
        $devopsPullRequestWorkItem | Add-Member -MemberType NoteProperty -Name MergedIntoDevelop -Value $false          
        foreach ($relation in $devopsPullRequestWorkItem.relations) {
            if ($relation.attributes.name -eq "Pull Request") {
                # Pull Request-URL extrahieren und die Pull Request-ID am Ende der URL finden
                $pullRequestUrl = $relation.url
                $pullRequestId = $pullRequestUrl.Split("%2F")[-1]

                # API-Anforderung senden, um Details zum Pull Request zu erhalten                
                try {
                    $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/pullrequests/$($pullRequestId)" -Parameter "api-version=6.0"
                    $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken
                    if ($response.StatusCode -ne 200) {
                        Write-Error "Test-AzureDevOpsWorkItemMergedIntoDevelop pull request for $($pullRequestId) failed with status code: $($response.StatusCode) $($response.StatusDescription)" 
                    }
                    $jPullRequestResponse = $response.Content | ConvertFrom-Json   
                    if ($jPullRequestResponse.status -ne 'completed') {
                        continue
                    }
                    # Zielbranch aus der Antwort extrahieren und ausgeben
                    $targetBranch = $jPullRequestResponse.targetRefName
                    if ($targetBranch -eq 'refs/heads/develop') {
                        $devopsPullRequestWorkItem.MergedIntoDevelop = $true
                        break
                    }
                }
                catch {
                    Write-Error "Test-AzureDevOpsWorkItemMergedIntoDevelop pull request for $($pullRequestId) failed $($_)" 
                    continue
                }
            }           
        }                
    }

    foreach ($jiraTickets in $JiraTickets) {    
        if (-not $jiraTickets.devopsWorkItem) {
            continue
        }
        $devopsWorkItem = $jiraTickets.devopsWorkItem  
        if ($devopsWorkItem.PSobject.Properties.name -match "MergedIntoDevelop") {
            continue
        }        
        $devopsWorkItem | Add-Member -MemberType NoteProperty -Name MergedIntoDevelop -Value $false   
        if (-not $devopsWorkItem.MergedIntoDevelop) {
            foreach ($relation in $devopsWorkItem.relations) {
                if ($relation.attributes.name -eq "Pull Request") {
                    # Pull Request-URL extrahieren und die Pull Request-ID am Ende der URL finden
                    $pullRequestUrl = $relation.url
                    $pullRequestId = $pullRequestUrl.Split("%2F")[-1]

                    # API-Anforderung senden, um Details zum Pull Request zu erhalten
                    $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/pullrequests/$($pullRequestId)" -Parameter "api-version=6.0"
                    $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken                   
                    if ($response.StatusCode -ne 200) {
                        Write-Error "Test-AzureDevOpsWorkItemMergedIntoDevelop pull request for $($pullRequestId) failed with status code: $($response.StatusCode) $($response.StatusDescription)" 
                    }
                    $jPullRequestResponse = $response.Content | ConvertFrom-Json   
                    if ($jPullRequestResponse.status -ne 'completed') {
                        continue
                    }
                    # Zielbranch aus der Antwort extrahieren und ausgeben
                    $targetBranch = $jPullRequestResponse.targetRefName
                    if ($targetBranch -eq 'refs/heads/develop') {
                        $devopsWorkItem.MergedIntoDevelop = $true
                        break
                    }
                }           
            }             
        }   
    }
}
Export-ModuleMember -Function Test-AzureDevOpsWorkItemMergedIntoDevelop