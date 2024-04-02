function Get-DevOpsWorkItemsFromJiraTickets() {
    foreach ($jiraTicket in $script:jiraTickets) {
        $devopsUrl = "https://dev.azure.com/$script:devopsOrganisation/$script:devopsProject/_apis/wit/wiql?api-version=6.0" 
        $query = @{
            query = "SELECT [System.Id], [System.WorkItemType], [System.Title], [System.AssignedTo], [System.State] FROM workitems WHERE [System.TeamProject] = '$($script:devopsProject)' AND [Custom.JiraIssueKey] = '$($jiraTicket.key)'"          
        } | ConvertTo-Json
        $devopsQueryResponse = Invoke-WebRequest -Uri $devopsUrl -Headers $script:devopsAuthHeader -Method Post -Body $query -ContentType "application/json"        
        if ($devopsQueryResponse.StatusCode -eq 200) {
            $devopsQuery = $devopsQueryResponse.Content | ConvertFrom-Json
            $devopsWorkItem = $devopsQuery.workitems | Select-Object -Last 1
            $devopsPullRequestWorkItem = $script:devopsPullRequestWorkItems | Where-Object { $_.id -eq $devopsWorkItem.Id } | Select-Object -First 1
            if ($devopsPullRequestWorkItem) {
                $jiraTicket | Add-Member -MemberType NoteProperty -Name devopsWorkItem -Value $devopsPullRequestWorkItem         
                $devopsPullRequestWorkItem | Add-Member -MemberType NoteProperty -Name jiraTicket -Value $jiraTicket  
            }
            else {
                if (-not $devopsWorkItem -or -not $devopsWorkItem.Id) {
                    continue
                }
                $devopsUrl = "https://dev.azure.com/$script:devopsOrganisation/$script:devopsProject/_apis/wit/workitems/$($devopsWorkItem.Id)?`$expand=relations&api-version=6.0"    
                $workItemResponse = Invoke-WebRequest -Uri $devopsUrl -Headers $script:devopsAuthHeader -Method Get
                if ($workItemResponse.StatusCode -ne 200) {
                    Write-Error "Get-PullRequestWorkItems for work item $($wi.Id) failed with status code: $($pullRequestWorkItem.StatusCode) $($pullRequestWorkItem.StatusDescription)" 
                    exit
                }   
                $workItem = $workItemResponse.Content | ConvertFrom-Json                  
                $workItem | Add-Member -MemberType NoteProperty -Name jiraTicket -Value $jiraTicket  
                $jiraTicket | Add-Member -MemberType NoteProperty -Name devopsWorkItem -Value $workItem          
            }                                    
        }           
    }
}
Export-ModuleMember -Function Get-DevOpsWorkItemsFromJiraTickets