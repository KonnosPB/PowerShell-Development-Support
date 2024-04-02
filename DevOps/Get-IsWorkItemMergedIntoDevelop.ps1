function Get-IsWorkItemMergedIntoDevelop {   
    foreach ($devopsPullRequestWorkItem in $script:devopsPullRequestWorkItems) {
        $devopsPullRequestWorkItem | Add-Member -MemberType NoteProperty -Name MergedIntoDevelop -Value $false          
        foreach ($relation in $devopsPullRequestWorkItem.relations) {
            if ($relation.attributes.name -eq "Pull Request") {
                # Pull Request-URL extrahieren und die Pull Request-ID am Ende der URL finden
                $pullRequestUrl = $relation.url
                $pullRequestId = $pullRequestUrl.Split("%2F")[-1]

                # API-Anforderung senden, um Details zum Pull Request zu erhalten
                $devopsUrl = "https://dev.azure.com/$script:devopsOrganisation/$script:devopsProject/_apis/git/pullrequests/$($pullRequestId)?api-version=6.0"
                $pullRequestResponse = Invoke-WebRequest -Uri $devopsUrl -Headers $script:devopsAuthHeader -Method Get
                if ($pullRequestResponse.StatusCode -ne 200) {
                    Write-Error "Get-IsWorkItemMergedIntoDevelop pull request for $($pullRequestId) failed with status code: $($pullRequestResponse.StatusCode) $($pullRequestResponse.StatusDescription)" 
                }
                $jPullRequestResponse = $pullRequestResponse.Content | ConvertFrom-Json   
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
        }                
    }

    foreach ($jiraTickets in $script:jiraTickets) {    
        if (-not $jiraTickets.devopsWorkItem) {
            continue
        }
        $devopsWorkItem = $jiraTickets.devopsWorkItem  
        if ($devopsWorkItem.PSobject.Properties.name -match "MergedIntoDevelop"){
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
                    $devopsUrl = "https://dev.azure.com/$script:devopsOrganisation/$script:devopsProject/_apis/git/pullrequests/$($pullRequestId)?api-version=6.0"
                    $pullRequestResponse = Invoke-WebRequest -Uri $devopsUrl -Headers $script:devopsAuthHeader -Method Get
                    if ($pullRequestResponse.StatusCode -ne 200) {
                        Write-Error "Get-IsWorkItemMergedIntoDevelop pull request for $($pullRequestId) failed with status code: $($pullRequestResponse.StatusCode) $($pullRequestResponse.StatusDescription)" 
                    }
                    $jPullRequestResponse = $pullRequestResponse.Content | ConvertFrom-Json   
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
Export-ModuleMember -Function Get-IsWorkItemMergedIntoDevelop