function New-ReleaseExcelWorksheet {    
    Param (        
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory = $true)]
        [string[]] $JiraSolutionVersion,
        [Parameter(Mandatory = $false)]
        [PSCustomObject[]] $AzureDevOpsPullRequestWorkItems,
        [Parameter(Mandatory = $false)]
        [PSCustomObject[]] $JiraTickets,
        [Parameter(Mandatory = $false)]
        [string] $Output = $null
    )
    $excel = New-Object -ComObject excel.application
    $excel.visible = $True
    $workbook = $excel.Workbooks.Add()
    $workbook.Worksheets.Add()
    $Data = $workbook.Worksheets.Item(1)
    $Data.Name = "$AzureDevOpsProject_$JiraSolutionVersion"
    $Data.Cells.Item(1, 1) = 'Repository'
    $Data.Cells.Item(1, 2) = 'Pull-Request'
    $Data.Cells.Item(1, 3) = 'WorkItem-Id'
    $Data.Cells.Item(1, 4) = 'WorkItem-Status'
    $Data.Cells.Item(1, 5) = 'WorkItem-Type'
    $Data.Cells.Item(1, 6) = 'WorkItem Merged into Develop'
    $Data.Cells.Item(1, 7) = 'Jira-Id'
    $Data.Cells.Item(1, 8) = 'Jira-Status'
    $Data.Cells.Item(1, 9) = 'Jira-Priorität'    
    $Data.Cells.Item(1, 10) = 'Jira-Version'
    $Data.Cells.Item(1, 11) = 'Jira-Verantwortlich'
    $Data.Cells.Item(1, 12) = 'Jira-Changelog Ausschluss'
    $Data.Cells.Item(1, 13) = 'Jira-Title'    
    $Data.Cells.Item(1, 14) = 'Jira-Changelog Text'
    
    $row = 1
    if ($AzureDevOpsPullRequestWorkItems) {
        foreach ($devOpsPullRequestWorkItem in $AzureDevOpsPullRequestWorkItems) {
            $row += 1
            $repository = $($devOpsPullRequestWorkItem.pullRequest.repository)
            $repoLink = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/_git/$repository" 
            $repositoryFormular = "=HYPERLINK(""$repoLink"", ""$repository"")"
            $workItemLink = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/_workitems/edit/$($devOpsPullRequestWorkItem.id)"            
            $workItemIDFormular = "=HYPERLINK(""$workItemLink"", ""$($devOpsPullRequestWorkItem.id)"")"
            $prLink = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/_git/$repository/pullrequest/$($devOpsPullRequestWorkItem.pullRequest.pullRequestId)"            
            $prIdFormular = "=HYPERLINK(""$prLink"", ""$($devOpsPullRequestWorkItem.pullRequest.pullRequestId)"")"        
        
            # Insert Data   
            $Data.Cells.Item($row, 1).Formula = $repositoryFormular        
            $Data.Cells.Item($row, 2).Formula = $prIdFormular
            $Data.Cells.Item($row, 3).Formula = $workItemIDFormular
            $Data.Cells.Item($row, 4) = "$($devOpsPullRequestWorkItem.fields.'System.State')"
            $Data.Cells.Item($row, 5) = "$($devOpsPullRequestWorkItem.fields.'System.WorkItemType')"
            $Data.Cells.Item($row, 6) = "$($devOpsPullRequestWorkItem.MergedIntoDevelop)"
       
            if ($devOpsPullRequestWorkItem.jiraIssue) {
                $ji = $devOpsPullRequestWorkItem.jiraIssue
                # customfield_10204 Changelog value 10377 value Yes
                $jiraKey = $ji.key
                $jiraLink = "$($Global:Config.JiraBaseUrl)/browse/$($ji.key)"     
                $fixVersions = $ji.fields.fixVersions | Select-Object -ExpandProperty name            
                $fixVersionsJoined = "'" 
                $fixVersionsJoined += $fixVersions -join ', '
                $assignee = $ji.fields.assignee.displayName
                $status = $ji.fields.status.name
                $changeLogAusschluss = $ji.fields.customfield_10204.value
                $changeLogText = $ji.fields.customfield_10171
                $summary = $ji.fields.summary
                $priority = $ji.fields.priority.Name
                $Data.Cells($row, 7).Formula = "=HYPERLINK(""$jiraLink"", ""$jiraKey"")"                       
                $Data.Cells.Item($row, 8) = $status
                $Data.Cells.Item($row, 9) = $priority                
                $Data.Cells.Item($row, 10) = $fixVersionsJoined 
                $Data.Cells.Item($row, 11) = $assignee            
                $Data.Cells.Item($row, 12) = $changeLogAusschluss                                                                       
                $Data.Cells.Item($row, 13) = $summary
                $Data.Cells.Item($row, 14) = $changeLogText
            }
        }        
    }

    if ($JiraTickets) {
        foreach ($jiraTicket in $JiraTickets) {
            $wi = $AzureDevOpsPullRequestWorkItems | Where-Object { $_.id -eq $jiraTicket.devopsWorkItem.id }
            if ($wi) {
                continue # Already handled
            }        
            $row += 1
            if ($jiraTicket.devopsWorkItem) {
                $repository = $($jiraTicket.devopsWorkItem.repository)
                $repoLink = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/_git/$repository" 
                $repositoryFormular = "=HYPERLINK(""$repoLink"", ""$repository"")"
                $workItemLink = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/_workitems/edit/$($jiraTicket.devopsWorkItem.id)"            
                $workItemIDFormular = "=HYPERLINK(""$workItemLink"", ""$($jiraTicket.devopsWorkItem.id)"")"
                $prLink = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/_git/$repository/pullrequest/$($jiraTicket.devopsWorkItem.pullRequest.pullRequestId)"            
                $prIdFormular = "=HYPERLINK(""$prLink"", ""$($jiraTicket.devopsWorkItem.pullRequest.pullRequestId)"")"        
                # Insert Data   
                $Data.Cells.Item($row, 1).Formula = $repositoryFormular        
                $Data.Cells.Item($row, 2).Formula = $prIdFormular
                $Data.Cells.Item($row, 3).Formula = $workItemIDFormular
                $Data.Cells.Item($row, 4) = "$($jiraTicket.devopsWorkItem.fields.'System.State')"
                $Data.Cells.Item($row, 5) = "$($jiraTicket.devopsWorkItem.fields.'System.WorkItemType')"
                $Data.Cells.Item($row, 6) = "$($jiraTicket.devopsWorkItem.MergedIntoDevelop)"
            }                      
       
            $ji = $jiraTicket
            # customfield_10204 Changelog value 10377 value Yes
            $jiraKey = $ji.key
            $jiraLink = "$($Global:Config.JiraBaseUrl)/browse/$($ji.key)"     
            $fixVersions = $ji.fields.fixVersions | Select-Object -ExpandProperty name            
            $fixVersionsJoined = "'" 
            $fixVersionsJoined += $fixVersions -join ', '
            $assignee = $ji.fields.assignee.displayName
            $status = $ji.fields.status.name
            $changeLogAusschluss = $ji.fields.customfield_10204.value
            $changeLogText = $ji.fields.customfield_10171
            $summary = $ji.fields.summary
            $priority = $ji.fields.priority.Name
            $Data.Cells($row, 7).Formula = "=HYPERLINK(""$jiraLink"", ""$jiraKey"")"                       
            $Data.Cells.Item($row, 8) = $status
            $Data.Cells.Item($row, 9) = $priority            
            $Data.Cells.Item($row, 10) = $fixVersionsJoined 
            $Data.Cells.Item($row, 11) = $assignee            
            $Data.Cells.Item($row, 12) = $changeLogAusschluss            
            $Data.Cells.Item($row, 13) = $summary
            $Data.Cells.Item($row, 14) = $changeLogText                                                   
        }   
    }     
    
    # Format excel
    $color1 = 240 + (245 * 256) + (255 * 256 * 256) # $r = 200, $g = 236, $b = 250
    $color2 = 230 + (238 * 256) + (250 * 256 * 256) # $r = 173, $g = 216, $b = 230    
    $usedRange = $Data.UsedRange 
    $usedRange.EntireColumn.AutoFit() | Out-Null
    $usedRange.EntireRow.AutoFit() | Out-Null
    $usedRange.AutoFilter() 

    for ($row = 1; $row -le $usedRange.Rows.Count; $row++) {
        for ($col = 1; $col -le $usedRange.Columns.Count; $col++) {
            # Wechselnder Hintergrund pro Zeile
            if ($row % 2 -eq 0) {
                $Data.Cells.Item($row, $col).Interior.Color = $color1 
            }
            else {
                $Data.Cells.Item($row, $col).Interior.Color = $color2
            }
        }
    }     
    
    # Aktivieren Sie die Fensterteilung und frieren Sie die erste Zeile ein
    $excel.ActiveWindow.SplitRow = 1
    $excel.ActiveWindow.FreezePanes = $true
    
    if ($Output) {
        $workbook.SaveAs($Output)
        $excel.Quit()
    }
}

Export-ModuleMember -Function New-ReleaseExcelWorksheet