<#
.SYNOPSIS
This function retrieves a list of active pull requests from the master branch of specified Azure DevOps repositories.

.DESCRIPTION
The `Get-AzureDevOpsMasterBranchPullRequests` function communicates with the Azure DevOps API to retrieve a list of active pull requests from the master branch of one or more Azure DevOps repositories. The function uses the Azure DevOps project name, repository names, and a personal access token as input parameters.

.PARAMETER AzureDevOpsProject
This parameter specifies the name of the Azure DevOps project from which the pull requests will be retrieved. It is a mandatory parameter and accepts a string value.

.PARAMETER AzureDevOpsRepositories
This parameter specifies the names of the Azure DevOps repositories from which the pull requests will be retrieved. It is a mandatory parameter and accepts an array of string values.

.PARAMETER AzureDevOpsToken
This parameter is used for authentication. It accepts a personal access token (PAT) string that has the necessary permissions to access the Azure DevOps project and repositories. This is a mandatory parameter.

.EXAMPLE
```powershell
$project = "MyProject"
$repositories = @("Repo1", "Repo2")
$token = "abcd1234"

Get-AzureDevOpsMasterBranchPullRequests -AzureDevOpsProject $project -AzureDevOpsRepositories $repositories -AzureDevOpsToken $token
```
In this example, the function retrieves active pull requests from the master branches of "Repo1" and "Repo2" in the "MyProject" Azure DevOps project. The function uses "abcd1234" as the personal access token for authentication.
#>
function Get-AzureDevOpsMasterBranchPullRequests {
    Param (        
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory = $true)]
        [string[]] $AzureDevOpsRepositories,
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsToken
    )
    $result = @()
    foreach ($AzureDevOpsRepository in $AzureDevOpsRepositories) {
        # Get the list of pull requests        
        try {
            $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/repositories/$AzureDevOpsRepository/pullrequests" -Parameter "searchCriteria.targetRefName=refs/heads/master&searchCriteria.status=active"
            $pullRequests = Invoke-AzureDevOpsWebRequest -Uri $uri -Method GET -AzureDevOpsToken $AzureDevOpsToken              
            $jContent = $pullRequests.Content | ConvertFrom-Json
            foreach ($pullRequest in $jContent.value) {
                $pullRequest.repository = $AzureDevOpsRepository
                $result += $pullRequest                
            }
        }
        catch {    
            Write-Warning $_        
        }        
    }
    return $result
}
Export-ModuleMember -Function Get-AzureDevOpsMasterBranchPullRequests
